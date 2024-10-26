const GLOBAL_CONFIG = {
	// 訪問控制方式
	ACCESS_CONTROL: {
		USE_API: false,                        // true: 使用 API 封鎖整個域名, false: 使用 Worker 只封鎖代理
		ENABLE_REQUEST_COUNT: true,            // 是否啟用請求計數（需要 D1 數據庫）
	},
	
	// 國家訪問控制
	ALLOWED_COUNTRIES: ['CN'],                 // 白名單，留空[]表示不限制，['']表示不使用白名單
	BLOCKED_COUNTRIES: [],                      // 黑名單，當白名單為空或['']時生效
	
	// URL 控制
	ALLOWED_DOMAIN_PREFIXES: [                  // 允許的網址前綴列表
		'https://raw.githubusercontent.com/OG-Open-Source',
		'https://raw.githubusercontent.com/kejilion'
	],
	ALLOWED_GENERAL_PATTERN: '',                // URL必須包含的字符串，留空則不檢查
	
	// Cloudflare API 設置
	CF_API: {
		ZONE_ID: 'CF_ZONE_ID',  // 您的 Zone ID
		API_URL: 'https://api.cloudflare.com/client/v4',
		TOKEN_VARIABLE: 'CF_API_TOKEN'         // 環境變量名稱
	},

	// API 訪問控制
	API_ACCESS: {
		ENABLE_AUTH: true,                     // 是否啟用 API 認證
		UPDATE_KEY: '8f7d3b2a1e4c9f6d5b2a8e7c4f9d6b3a'  // 更新防火牆規則的密鑰
	}
};

// 運行時配置（無需修改）
const RUNTIME_CONFIG = {
	ALLOWED_DOMAIN_PREFIXES: new Set(GLOBAL_CONFIG.ALLOWED_DOMAIN_PREFIXES)
};

const URL_PATTERNS = {
	HTTPS: /^https:\//,
	HTTP: /^http:\//
};

const COMMON_HEADERS = {
	CORS: { 'Access-Control-Allow-Origin': '*' }
};

async function manageFirewallRules(env) {
	// 如果不使用 API，直接返回
	if (!GLOBAL_CONFIG.ACCESS_CONTROL.USE_API) {
		return true;
	}

	// 檢查必要的環境變量
	if (!env[GLOBAL_CONFIG.CF_API.TOKEN_VARIABLE]) {
		throw new Error('API Token not configured');
	}

	if (!env.CF_ZONE_ID) {
		throw new Error('Zone ID not configured');
	}

	const headers = {
		'Authorization': `Bearer ${env[GLOBAL_CONFIG.CF_API.TOKEN_VARIABLE]}`,
		'Content-Type': 'application/json'
	};

	// 新增：刪除特定描述的規則
	async function deleteRulesByDescription(descriptions) {
		try {
			// 獲取所有現有規則
			const listResponse = await fetch(
				`${GLOBAL_CONFIG.CF_API.API_URL}/zones/${env.CF_ZONE_ID}/firewall/rules`,
				{
					method: 'GET',
					headers: headers
				}
			);
			
			const existingRules = await listResponse.json();
			if (existingRules.success && existingRules.result) {
				// 找到並刪除匹配描述的規則
				for (const rule of existingRules.result) {
					if (descriptions.includes(rule.description)) {
						await fetch(
							`${GLOBAL_CONFIG.CF_API.API_URL}/zones/${env.CF_ZONE_ID}/firewall/rules/${rule.id}`,
							{
								method: 'DELETE',
								headers: headers
							}
						);
						console.log(`Deleted rule: ${rule.description}`);
					}
				}
			}
		} catch (error) {
			console.error('Error deleting rules:', error);
			throw error;
		}
	}

	async function updateAllowRule() {
		// 首先刪除舊的規則
		await deleteRulesByDescription([
			'Block non-listed countries',
			'Block listed countries'
		]);

		let rules = [];
		
		// 處理白名單
		if (GLOBAL_CONFIG.ALLOWED_COUNTRIES.length > 0 && 
			!(GLOBAL_CONFIG.ALLOWED_COUNTRIES.length === 1 && GLOBAL_CONFIG.ALLOWED_COUNTRIES[0] === '')) {
			// 有白名單且不是 ['']
			// 只創建一個阻止規則
			const blockOthersRule = {
				filter: {
					expression: `(not ip.geoip.country in {${GLOBAL_CONFIG.ALLOWED_COUNTRIES.map(c => `"${c}"`).join(' ')}})`
				},
				action: 'block',
				description: 'Block non-listed countries',
					enabled: true,
					paused: false,
					priority: 1  // 優先級改為 1，因為現在只有一個規則
			};
			
			rules.push(blockOthersRule);
		}
		// 處理黑名單
		else if (GLOBAL_CONFIG.BLOCKED_COUNTRIES.length > 0) {
			const blockRule = {
				filter: {
					expression: `(ip.geoip.country in {${GLOBAL_CONFIG.BLOCKED_COUNTRIES.map(c => `"${c}"`).join(' ')}})`
				},
				action: 'block',
				description: 'Block listed countries',
				enabled: true,
				paused: false,
				priority: 1
			};
			
			rules.push(blockRule);
		}

		// 如果沒有規則要創建，直接返回
		if (rules.length === 0) {
			console.log('No rules to create');
			return;
		}

		try {
			// 直接創建新規則，不刪除現有規則
			const response = await fetch(
				`${GLOBAL_CONFIG.CF_API.API_URL}/zones/${env.CF_ZONE_ID}/firewall/rules`,
				{
					method: 'POST',
					headers: headers,
					body: JSON.stringify(rules)
				}
			);

			const result = await response.json();
			if (!result.success) {
				console.error('Failed to create rules:', result.errors);
				throw new Error('Failed to create firewall rules');
			}
			
			console.log('Rules created successfully:', result);
		} catch (error) {
			console.error('Error creating rules:', error);
			throw error;
		}
	}

	try {
		await updateAllowRule();
		return true;
	} catch (error) {
		console.error('Error in manageFirewallRules:', error);
		return false;
	}
}

export default {
	async fetch(request, env, ctx) {
		return handleRequest(request, env, ctx);
	}
};

async function handleRequest(request, env, ctx) {
	if (request.url.endsWith('/update-rules')) {
		const authKey = request.headers.get('X-Update-Key');
		if (GLOBAL_CONFIG.API_ACCESS.ENABLE_AUTH && 
			authKey !== GLOBAL_CONFIG.API_ACCESS.UPDATE_KEY) {
			return new Response('Unauthorized', {
				status: 401,
				headers: COMMON_HEADERS.CORS
			});
		}

		// 檢查所有必要的環境變量
		if (!env[GLOBAL_CONFIG.CF_API.TOKEN_VARIABLE] || !env.CF_ZONE_ID) {
			return new Response('Missing required configuration (API Token or Zone ID)', {
				status: 500,
				headers: COMMON_HEADERS.CORS
			});
		}

		try {
			await manageFirewallRules(env);
			return new Response('Firewall rules updated', {
				status: 200,
				headers: COMMON_HEADERS.CORS
			});
		} catch (error) {
			return new Response(`Error updating firewall rules: ${error.message}`, {
				status: 500,
				headers: COMMON_HEADERS.CORS
			});
		}
	}

	const { url, headers, cf } = request;
	const parsedUrl = new URL(url);

	// 檢查並記錄訪問（移到國家檢查之前）
	const clientIP = request.headers.get('cf-connecting-ip') || 
					cf.ip || 
					'unknown';

	// 檢查是否啟用計數以及是否有 DB 綁定
	if (GLOBAL_CONFIG.ACCESS_CONTROL.ENABLE_REQUEST_COUNT && env.DB) {
		try {
			ctx.waitUntil(incrementRequestCount(env.DB, clientIP));
		} catch (error) {
			console.error('Error incrementing request count:', error);
		}
	}

	// 根據設置選擇使用 Worker 進行國家檢查
	if (!GLOBAL_CONFIG.ACCESS_CONTROL.USE_API) {
		const isAllowed = isAllowedCountry(cf.country);
		if (!isAllowed) {
			return new Response('Access denied: Your country is not allowed to use this proxy.', {
				status: 403,
				headers: COMMON_HEADERS.CORS
			});
		}
	}

	let targetUrl = parsedUrl.pathname.slice(1);

	if (URL_PATTERNS.HTTPS.test(targetUrl)) {
		targetUrl = targetUrl.replace('https:/', 'https://');
	} else if (URL_PATTERNS.HTTP.test(targetUrl)) {
		targetUrl = targetUrl.replace('http:/', 'http://');
	}

	if (!targetUrl) {
		return new Response('Invalid URL format.', {
			status: 400,
			headers: COMMON_HEADERS.CORS
		});
	}

	if (!isAllowedUrl(targetUrl)) {
		return new Response(`Access denied: The requested URL is not allowed.`, {
			status: 403,
			headers: COMMON_HEADERS.CORS
		});
	}

	const destinationURL = new URL(targetUrl);
	destinationURL.search = parsedUrl.search;

	try {
		const response = await fetch(destinationURL, {
			method: request.method,
			headers: headers
		});

		const newResponse = new Response(response.body, response);
		newResponse.headers.set('Access-Control-Allow-Origin', '*');

		return newResponse;
	} catch (error) {
		console.error('Error:', error);
		return new Response('Internal Server Error', {
			status: 500,
			headers: COMMON_HEADERS.CORS
		});
	}
}

function isAllowedUrl(url) {
	for (const prefix of RUNTIME_CONFIG.ALLOWED_DOMAIN_PREFIXES) {
		if (url.startsWith(prefix)) {
			return !GLOBAL_CONFIG.ALLOWED_GENERAL_PATTERN ||
				   url.includes(GLOBAL_CONFIG.ALLOWED_GENERAL_PATTERN);
		}
	}
	return false;
}

// 新增：國家檢查函數
function isAllowedCountry(country) {
	// 如果白名單不為空且不是 ['']
	if (GLOBAL_CONFIG.ALLOWED_COUNTRIES.length > 0 && 
		!(GLOBAL_CONFIG.ALLOWED_COUNTRIES.length === 1 && GLOBAL_CONFIG.ALLOWED_COUNTRIES[0] === '')) {
		return GLOBAL_CONFIG.ALLOWED_COUNTRIES.includes(country);
	}
	
	// 如果使用黑名單
	if (GLOBAL_CONFIG.BLOCKED_COUNTRIES.length > 0) {
		return !GLOBAL_CONFIG.BLOCKED_COUNTRIES.includes(country);
	}
	
	// 如果沒有任何限制
	return true;
}

async function incrementRequestCount(db, ip) {
	if (!db) {
		console.error('Database not configured');
		return;
	}

	const currentDate = new Date().toISOString().split('T')[0];
	const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];

	try {
		// 使用事務來確保原子性
		await db.batch([
			db.prepare(
				`INSERT INTO ip_visits (date, ip, count) 
				 VALUES (?, ?, 1) 
				 ON CONFLICT(date, ip) DO UPDATE 
				 SET count = count + 1 
				 WHERE date = ? AND ip = ?`
			).bind(currentDate, ip, currentDate, ip),
			
			db.prepare(
				`DELETE FROM ip_visits WHERE date = ?`
			).bind(yesterday)
		]);
	} catch (error) {
		console.error('Counter error:', error);
		throw error; // 拋出錯誤以便更好地追蹤問題
	}
}

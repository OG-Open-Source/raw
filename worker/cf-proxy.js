/*
Cloudflare Worker Proxy by OG-Open-Source

使用說明：
1. 設置環境變量：
   - CF_API_TOKEN: Cloudflare API Token（需要 Firewall Services 編輯權限）（祕密）
   - CF_ZONE_ID: Cloudflare Zone ID（數值）
   - CF_API_URL: https://api.cloudflare.com/client/v4（數值）

2. GLOBAL_CONFIG 配置說明：
   API_ACCESS: {
	 ENABLE_AUTH: true,                              // 是否啟用 API 認證（用於透過 API 呼叫 Worker）
	 UPDATE_KEY: 'your-update-key'                   // API 更新密鑰（自行生成用於 API 調用）
   },
   WAF: {
	 ENABLED: false,                                 // WAF 開關
	 ALLOWED_COUNTRIES: [],                          // 允許的國家列表
	 BLOCKED_COUNTRIES: [],                          // 封鎖的國家列表
	 BLOCKED_IPS: []                                 // 封鎖的 IP 列表
   },
   URL_CONTROL: {
	 ALLOWED_DOMAIN_PREFIXES: [                      // 允許的域名前綴列表（即 https://your-worker-url/<ALLOWED_DOMAIN_PREFIXES>/xxx）
	   'https://raw.githubusercontent.com/OG-Open-Source',
	   'https://raw.githubusercontent.com/kejilion'
	 ],
	 ALLOWED_GENERAL_PATTERN: ''                     // URL 通用匹配模式（除了 https://your-worker-url/ 外的連結都需要匹配）
   },
   ENABLE_REQUEST_COUNT: true                        // 是否啟用請求計數

3. WAF 功能指令：
   # 開啟 WAF 並設定允許的國家
   curl -X POST 'https://your-worker-url/api/config' \
   -H 'X-Update-Key: your-update-key' \
   -H 'Content-Type: application/json' \
   -d '{
	   "waf": {
		   "ENABLED": true,
		   "ALLOWED_COUNTRIES": ["TW", "HK", "JP"],
		   "BLOCKED_COUNTRIES": [],
		   "BLOCKED_IPS": []
	   }
   }'

   # 設定封鎖的國家
   curl -X POST 'https://your-worker-url/api/config' \
   -H 'X-Update-Key: your-update-key' \
   -H 'Content-Type: application/json' \
   -d '{
	   "waf": {
		   "ENABLED": true,
		   "ALLOWED_COUNTRIES": [],
		   "BLOCKED_COUNTRIES": ["CN", "RU"],
		   "BLOCKED_IPS": []
	   }
   }'

   # 設定封鎖的 IP
   curl -X POST 'https://your-worker-url/api/config' \
   -H 'X-Update-Key: your-update-key' \
   -H 'Content-Type: application/json' \
   -d '{
	   "waf": {
		   "ENABLED": true,
		   "ALLOWED_COUNTRIES": [],
		   "BLOCKED_COUNTRIES": [],
		   "BLOCKED_IPS": ["1.2.3.4", "5.6.7.8"]
	   }
   }'

   # 關閉 WAF
   curl -X POST 'https://your-worker-url/api/config' \
   -H 'X-Update-Key: your-update-key' \
   -H 'Content-Type: application/json' \
   -d '{
	   "waf": {
		   "ENABLED": false
	   }
   }'

注意事項：
1. ALLOWED_COUNTRIES 和 BLOCKED_COUNTRIES 不能同時使用
2. 國家代碼使用 ISO 3166-1 alpha-2 格式（如：TW, HK, JP）
3. IP 地址使用標準 IPv4 格式
4. 每次更新配置都會自動更新防火牆規則
5. 關閉 WAF 時會刪除所有名為 "Block non-listed countries"、"Block listed countries"、"Block listed IPs" 的防火牆規則
6. ALLOWED_DOMAIN_PREFIXES 和 ALLOWED_GENERAL_PATTERN 只能通過修改代碼更新
7. 請求計數功能需要配置 D1 數據庫，指令為
CREATE TABLE IF NOT EXISTS ip_visits (
	date TEXT,
	ip TEXT,
	count INTEGER DEFAULT 1,
	PRIMARY KEY (date, ip)
);
*/

const GLOBAL_CONFIG = {
	API_ACCESS: {
		ENABLE_AUTH: true,
		UPDATE_KEY: 'your-update-key'
	},

	WAF: {
		ENABLED: false,
		ALLOWED_COUNTRIES: [],
		BLOCKED_COUNTRIES: [],
		BLOCKED_IPS: []
	},

	URL_CONTROL: {
		ALLOWED_DOMAIN_PREFIXES: [
			'https://raw.githubusercontent.com/OG-Open-Source',
			'https://raw.githubusercontent.com'
		],
		ALLOWED_GENERAL_PATTERN: ''
	},

	ENABLE_REQUEST_COUNT: false
};

const RUNTIME_CONFIG = {
	ALLOWED_DOMAIN_PREFIXES: new Set(GLOBAL_CONFIG.URL_CONTROL.ALLOWED_DOMAIN_PREFIXES)
};

const COMMON_HEADERS = {
	CORS: { 'Access-Control-Allow-Origin': '*' }
};

async function manageFirewallRules(env) {
	try {
		const headers = {
			'Authorization': `Bearer ${env.CF_API_TOKEN}`,
			'Content-Type': 'application/json'
			};

		async function updateAllowRule() {
			try {
				const existingRules = await (await fetch(
					`${env.CF_API_URL}/zones/${env.CF_ZONE_ID}/firewall/rules`,
					{ method: 'GET', headers }
				)).json();

				if (existingRules.success && existingRules.result) {
					const filterIds = new Set();
					const ruleIds = [];

					for (const rule of existingRules.result) {
						if (rule.description === 'Block non-listed countries' ||
							rule.description === 'Block listed countries' ||
							rule.description === 'Block listed IPs') {
							ruleIds.push(rule.id);
							if (rule.filter && rule.filter.id) {
								filterIds.add(rule.filter.id);
							}
						}
					}

					for (const ruleId of ruleIds) {
						await fetch(
							`${env.CF_API_URL}/zones/${env.CF_ZONE_ID}/firewall/rules/${ruleId}`,
							{ method: 'DELETE', headers }
						);
					}

					for (const filterId of filterIds) {
						await fetch(
							`${env.CF_API_URL}/zones/${env.CF_ZONE_ID}/filters/${filterId}`,
							{ method: 'DELETE', headers }
						);
					}
				}

				if (!GLOBAL_CONFIG.WAF.ENABLED) return true;

				const rules = [];

				if (GLOBAL_CONFIG.WAF.ALLOWED_COUNTRIES.length > 0) {
					rules.push({
						filter: {
							expression: `(not ip.geoip.country in {${GLOBAL_CONFIG.WAF.ALLOWED_COUNTRIES.map(c => `"${c}"`).join(' ')}})`
						},
						action: 'block',
						description: 'Block non-listed countries',
						enabled: true
					});
				}
				else if (GLOBAL_CONFIG.WAF.BLOCKED_COUNTRIES.length > 0) {
					rules.push({
						filter: {
							expression: `(ip.geoip.country in {${GLOBAL_CONFIG.WAF.BLOCKED_COUNTRIES.map(c => `"${c}"`).join(' ')}})`
						},
						action: 'block',
						description: 'Block listed countries',
						enabled: true
					});
				}

				if (GLOBAL_CONFIG.WAF.BLOCKED_IPS.length > 0) {
					rules.push({
						filter: {
							expression: `(ip.src in { ${GLOBAL_CONFIG.WAF.BLOCKED_IPS.join(' ')} })`
						},
						action: 'block',
						description: 'Block listed IPs',
						enabled: true
					});
				}

				if (rules.length > 0) {
					await fetch(
						`${env.CF_API_URL}/zones/${env.CF_ZONE_ID}/firewall/rules`,
						{
							method: 'POST',
							headers,
							body: JSON.stringify(rules)
						}
					);
				}

				return true;
			} catch (error) {
				console.error('Error in updateAllowRule:', error);
				throw error;
			}
		}

		return await updateAllowRule();
	} catch (error) {
		throw error;
	}
}

export default {
	async fetch(request, env, ctx) {
		const { pathname } = new URL(request.url);
		const { headers, cf } = request;
		const isApiRequest = pathname.startsWith('/api/');

		if (GLOBAL_CONFIG.ENABLE_REQUEST_COUNT && env.DB) {
			try {
				const clientIP = headers.get('cf-connecting-ip') || cf.ip || 'unknown';
				ctx.waitUntil(incrementRequestCount(env.DB, clientIP));
			} catch (error) {
				console.error('Error incrementing request count:', error);
			}
		}

		if (isApiRequest) {
			const authKey = request.headers.get('X-Update-Key');
			if (authKey !== GLOBAL_CONFIG.API_ACCESS.UPDATE_KEY) {
				return new Response('Unauthorized', { status: 401, headers: COMMON_HEADERS.CORS });
			}

			if (!env.CF_API_TOKEN || !env.CF_ZONE_ID || !env.CF_API_URL) {
				return new Response('Missing API configuration', { status: 500, headers: COMMON_HEADERS.CORS });
			}

			switch (pathname) {
				case '/api/config':
					if (request.method === 'POST') {
						try {
							const newConfig = await request.json();
							if (newConfig.waf) {
								Object.assign(GLOBAL_CONFIG.WAF, newConfig.waf);
							}
							await manageFirewallRules(env);
							return new Response('Configuration updated', { status: 200, headers: COMMON_HEADERS.CORS });
						} catch (error) {
							return new Response(`Update failed: ${error.message}`, { status: 500, headers: COMMON_HEADERS.CORS });
						}
					}
					break;
			}
		}

		const parsedUrl = new URL(request.url);
		let targetUrl = parsedUrl.pathname.slice(1)
			.replace('https:/', 'https://')
			.replace('http:/', 'http://');

		if (!targetUrl || !isAllowedUrl(targetUrl)) {
			return new Response('Access denied', { status: 403, headers: COMMON_HEADERS.CORS });
		}

		try {
			const destinationURL = new URL(targetUrl);
			destinationURL.search = parsedUrl.search;

			const response = await fetch(destinationURL, {
				method: request.method,
				headers: request.headers
			});

			const newResponse = new Response(response.body, response);
			newResponse.headers.set('Access-Control-Allow-Origin', '*');
			return newResponse;
		} catch (error) {
			return new Response('Internal Server Error', { status: 500, headers: COMMON_HEADERS.CORS });
		}
	}
};

function isAllowedUrl(url) {
	for (const prefix of RUNTIME_CONFIG.ALLOWED_DOMAIN_PREFIXES) {
		if (url.startsWith(prefix)) {
			return !GLOBAL_CONFIG.URL_CONTROL.ALLOWED_GENERAL_PATTERN ||
				   url.includes(GLOBAL_CONFIG.URL_CONTROL.ALLOWED_GENERAL_PATTERN);
		}
	}
	return false;
}

async function incrementRequestCount(db, ip) {
	if (!db) {
		console.error('Database not configured');
		return;
	}

	const now = new Date();
	const utcHour = now.getUTCHours();
	const currentDate = now.toISOString().split('T')[0];

	const cleanupDate = new Date(now);
	if (utcHour < 12) {
		cleanupDate.setDate(cleanupDate.getDate() - 1);
	}
	const dateToClean = cleanupDate.toISOString().split('T')[0];

	try {
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
			).bind(dateToClean)
		]);
	} catch (error) {
		console.error('Counter error:', error);
		throw error;
	}
}

/*
Cloudflare Worker Proxy by OG-Open-Source

一、環境設置：
	1. 在 Cloudflare Workers 中設置以下環境變量：
		- CF_API_TOKEN：Cloudflare API Token（需要 Firewall Services 編輯權限）（祕密）
		- CF_ZONE_ID：Cloudflare Zone ID（數值）
		- CF_API_URL：https://api.cloudflare.com/client/v4（數值）

	2. 如需使用請求計數功能，需要創建 D1 數據庫：
		- 在 Cloudflare Workers 中創建名為 PROXY_DATABASE 的 D1 數據庫
		- 執行以下 SQL 創建表：
			CREATE TABLE IF NOT EXISTS ip_visits (
				date TEXT,
				ip TEXT,
				count INTEGER DEFAULT 1,
				PRIMARY KEY (date, ip)
			);
		- 在 wrangler.toml 中添加：
			[[d1_databases]]
			binding = "PROXY_DATABASE"
			database_name = "proxy_database"
			database_id = "<your-database-id>"

	3. 如需使用配置持久化功能，需要創建 KV namespace：
		- 在 Cloudflare Workers 中創建名為 PROXY_CONFIG 的 KV namespace
		- 在 wrangler.toml 中添加：
			kv_namespaces = [
				{ binding = "PROXY_CONFIG", id = "<your-namespace-id>" }
			]

二、功能說明：
	1. 訪問控制：
		- Worker 層面：當 WAF.ENABLED = false 時生效
		- Cloudflare WAF：當 WAF.ENABLED = true 時生效
		- 兩種方式都支持國家和 IP 封鎖

	2. URL 控制：
		- 只允許訪問指定域名前綴的 URL
		- 可選添加通用匹配模式

	3. 請求計數：
		- 記錄每個 IP 的訪問次數
		- 每天 UTC+0 12:00 清理前一天的數據

三、配置指令：
	1. 開啟 WAF 並設定允許的國家：
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

	2. 設定封鎖的國家：
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

	3. 設定封鎖的 IP：
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

	4. 關閉 WAF（使用 Worker 層面阻擋）：
	curl -X POST 'https://your-worker-url/api/config' \
	-H 'X-Update-Key: your-update-key' \
	-H 'Content-Type: application/json' \
	-d '{
		"waf": {
			"ENABLED": false,
			"ALLOWED_COUNTRIES": [],
			"BLOCKED_COUNTRIES": ["TW"],
			"BLOCKED_IPS": []
		}
	}'

四、注意事項：
	1. ALLOWED_COUNTRIES 和 BLOCKED_COUNTRIES 不能同時使用
	2. 國家代碼使用 ISO 3166-1 alpha-2 格式（如：TW, HK, JP）
	3. IP 地址使用標準 IPv4 格式
	4. 如需使用 API，則務必配置 API_ACCESS.ENABLE_AUTH = true 並設定 API_ACCESS.UPDATE_KEY，保持其餘配值不變
	5. 關閉 WAF 時會刪除所有名為 "Block non-listed countries"、"Block listed countries"、"Block listed IPs" 的防火牆規則
	6. ALLOWED_DOMAIN_PREFIXES 和 ALLOWED_GENERAL_PATTERN 只能通過修改代碼更新
	7. 請求計數功能需要配置 D1 數據庫
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

		const config = await env.PROXY_CONFIG.get('waf_config', { type: 'json' });
		if (!config) return true;

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

				if (!config.ENABLED) return true;

				const rules = [];

				if (config.ALLOWED_COUNTRIES.length > 0) {
					rules.push({
						filter: {
							expression: `(not ip.geoip.country in {${config.ALLOWED_COUNTRIES.map(c => `"${c}"`).join(' ')}})`
						},
						action: 'block',
						description: 'Block non-listed countries',
						enabled: true
					});
				}
				else if (config.BLOCKED_COUNTRIES.length > 0) {
					rules.push({
						filter: {
							expression: `(ip.geoip.country in {${config.BLOCKED_COUNTRIES.map(c => `"${c}"`).join(' ')}})`
						},
						action: 'block',
						description: 'Block listed countries',
						enabled: true
					});
				}

				if (config.BLOCKED_IPS.length > 0) {
					rules.push({
						filter: {
							expression: `(ip.src in { ${config.BLOCKED_IPS.join(' ')} })`
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
		let config = await env.PROXY_CONFIG.get('waf_config', { type: 'json' });
		if (!config) {
			config = GLOBAL_CONFIG.WAF;
		}

		const { pathname } = new URL(request.url);
		const { headers, cf } = request;
		const isApiRequest = pathname.startsWith('/api/');

		if (GLOBAL_CONFIG.ENABLE_REQUEST_COUNT && env.PROXY_DATABASE) {
			try {
				const clientIP = headers.get('cf-connecting-ip') || cf.ip || 'unknown';
				ctx.waitUntil(incrementRequestCount(env.PROXY_DATABASE, clientIP));
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
								await env.PROXY_CONFIG.put('waf_config', JSON.stringify(newConfig.waf));
								config = newConfig.waf;

								if (config.ENABLED) {
									await manageFirewallRules(env);
								} else {
									await manageFirewallRules(env);
								}
							}
							return new Response('Configuration updated', {
								status: 200,
								headers: COMMON_HEADERS.CORS
							});
						} catch (error) {
							return new Response(`Update failed: ${error.message}`, {
								status: 500,
								headers: COMMON_HEADERS.CORS
							});
						}
					}
					break;
			}
		}

		if (!isApiRequest && !config.ENABLED) {
			const clientIP = headers.get('cf-connecting-ip') || cf.ip || 'unknown';
			const clientCountry = cf.country;

			if (config.BLOCKED_IPS.includes(clientIP)) {
				return new Response('Access denied: Your IP has been blocked.', {
					status: 403,
					headers: COMMON_HEADERS.CORS
				});
			}

			if (config.ALLOWED_COUNTRIES.length > 0) {
				if (!config.ALLOWED_COUNTRIES.includes(clientCountry)) {
					return new Response('Access denied: Your country is not allowed.', {
						status: 403,
						headers: COMMON_HEADERS.CORS
					});
				}
			} else if (config.BLOCKED_COUNTRIES.includes(clientCountry)) {
				return new Response('Access denied: Your country is blocked.', {
					status: 403,
					headers: COMMON_HEADERS.CORS
				});
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
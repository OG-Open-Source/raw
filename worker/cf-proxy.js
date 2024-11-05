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

	PROXY: {
		TIMEOUT: 30
	},

	REQUEST_COUNT: {
		ENABLED: true,
	}
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

async function incrementRequestCount(db, ip) {
	if (!db) return;

	const now = new Date();
	const currentDate = now.toISOString().split('T')[0];
	const cleanupDate = new Date(now);
	
	if (now.getUTCHours() === 0) {
		cleanupDate.setDate(cleanupDate.getDate() - 1);
	}

	const batch = [
		db.prepare(`
			INSERT INTO ip_visits (date, ip, count)
			VALUES (?, ?, 1)
			ON CONFLICT(date, ip) DO UPDATE
				SET count = count + 1
				WHERE date = ? AND ip = ?
		`).bind(currentDate, ip, currentDate, ip),

		db.prepare(`
			DELETE FROM ip_visits WHERE date < ?
		`).bind(cleanupDate.toISOString().split('T')[0])
	];

	try {
		await db.batch(batch);
	} catch (error) {
		console.error('Counter error:', error);
	}
}

const URL_CACHE = {
	cache: new Map(),
	maxSize: 1000,
	get(url) {
		return this.cache.get(url);
	},
	set(url, allowed) {
		if (this.cache.size >= this.maxSize) {
			const entries = Array.from(this.cache.entries());
			const halfSize = Math.floor(this.maxSize / 2);
			this.cache.clear();
			for (const [key, value] of entries.slice(-halfSize)) {
				this.cache.set(key, value);
			}
		}
		this.cache.set(url, allowed);
	}
};

function isAllowedUrl(url) {
	const cachedResult = URL_CACHE.get(url);
	if (cachedResult !== undefined) {
		return cachedResult;
	}

	for (const prefix of RUNTIME_CONFIG.ALLOWED_DOMAIN_PREFIXES) {
		if (url.startsWith(prefix)) {
			const result = !GLOBAL_CONFIG.URL_CONTROL.ALLOWED_GENERAL_PATTERN ||
							url.includes(GLOBAL_CONFIG.URL_CONTROL.ALLOWED_GENERAL_PATTERN);
			URL_CACHE.set(url, result);
			return result;
		}
	}

	URL_CACHE.set(url, false);
	return false;
}

function errorResponse(message, status = 500) {
	return new Response(message, {
		status,
		headers: COMMON_HEADERS.CORS
	});
}

async function proxyRequest(destinationURL, request) {
	const options = {
		method: request.method,
		headers: request.headers,
		cf: {
			timeout: GLOBAL_CONFIG.PROXY.TIMEOUT
		}
	};

	try {
		const response = await fetch(destinationURL, options);
		const newResponse = new Response(response.body, response);
		newResponse.headers.set('Access-Control-Allow-Origin', '*');
		return newResponse;
	} catch (error) {
		return errorResponse('Proxy request failed', 502);
	}
}

function checkWafRules(config, headers, cf) {
	const clientIP = headers.get('cf-connecting-ip') || cf?.ip || 'unknown';
	const clientCountry = cf?.country;

	if (config.BLOCKED_IPS.includes(clientIP)) {
		return errorResponse('Access denied: Your IP has been blocked.', 403);
	}

	if (config.ALLOWED_COUNTRIES.length > 0) {
		if (!config.ALLOWED_COUNTRIES.includes(clientCountry)) {
			return errorResponse('Access denied: Your country is not allowed.', 403);
		}
	} else if (config.BLOCKED_COUNTRIES.includes(clientCountry)) {
		return errorResponse('Access denied: Your country is blocked.', 403);
	}

	return null;
}

export default {
	async fetch(request, env, ctx) {
		try {
			let config = await env.PROXY_CONFIG?.get('waf_config', { type: 'json' });
			if (!config) {
				config = GLOBAL_CONFIG.WAF;
			}

			const { pathname } = new URL(request.url);
			const { headers, cf } = request;
			const isApiRequest = pathname.startsWith('/api/');

			if (GLOBAL_CONFIG.REQUEST_COUNT.ENABLED && env.PROXY_DATABASE) {
				const clientIP = headers.get('cf-connecting-ip') || cf?.ip || 'unknown';
				ctx.waitUntil(incrementRequestCount(env.PROXY_DATABASE, clientIP));
			}

			if (isApiRequest) {
				const authKey = request.headers.get('X-Update-Key');
				if (authKey !== GLOBAL_CONFIG.API_ACCESS.UPDATE_KEY) {
					return errorResponse('Unauthorized', 401);
				}

				if (!env.CF_API_TOKEN || !env.CF_ZONE_ID || !env.CF_API_URL) {
					return errorResponse('Missing API configuration', 500);
				}

				switch (pathname) {
					case '/api/config':
						if (request.method === 'POST') {
							try {
								const newConfig = await request.json();
								if (newConfig.waf) {
									await env.PROXY_CONFIG.put('waf_config', JSON.stringify(newConfig.waf));
									config = newConfig.waf;
									await manageFirewallRules(env);
								}
								return errorResponse('Configuration updated', 200);
							} catch (error) {
								return errorResponse(`Update failed: ${error.message}`, 500);
							}
						}
						break;
				}
			}

			if (!isApiRequest && !config.ENABLED) {
				const wafCheck = checkWafRules(config, headers, cf);
				if (wafCheck) return wafCheck;
			}

			const parsedUrl = new URL(request.url);
			let targetUrl = parsedUrl.pathname.slice(1)
				.replace('https:/', 'https://')
				.replace('http:/', 'http://');

			if (!targetUrl || !isAllowedUrl(targetUrl)) {
				return errorResponse('Access denied', 403);
			}

			try {
				const destinationURL = new URL(targetUrl);
				destinationURL.search = parsedUrl.search;
				return await proxyRequest(destinationURL, request);
			} catch (error) {
				return errorResponse('Internal Server Error', 500);
			}
		} catch (error) {
			return errorResponse('Internal Server Error', 500);
		}
	}
};
// 全局設置
const GLOBAL_CONFIG = {
	// 是否啟用請求計數
	ENABLE_REQUEST_COUNT: true,
	// 允許訪問的國家列表 (白名單) (高優先級)
	ALLOWED_COUNTRIES: [''],
	// 被禁止訪問的國家列表 (黑名單) (低優先級)
	BLOCKED_COUNTRIES: ['SG'],
	// 允許的網域前綴列表
	ALLOWED_DOMAIN_PREFIXES: [
		'https://raw.githubusercontent.com/OG-Open-Source'
	],
	// 允許的通用字段 (指連結必須包含此字段)
	ALLOWED_GENERAL_PATTERN: ''
};

// KV 命名空間綁定
const REQUEST_COUNTER = typeof COUNTER_NAMESPACE !== 'undefined' ? COUNTER_NAMESPACE : {
	get: async () => null,
	put: async () => {},
	delete: async () => {}
};

const RUNTIME_CONFIG = {
	ALLOWED_COUNTRIES: new Set(GLOBAL_CONFIG.ALLOWED_COUNTRIES),
	BLOCKED_COUNTRIES: new Set(GLOBAL_CONFIG.BLOCKED_COUNTRIES),
	ALLOWED_DOMAIN_PREFIXES: new Set(GLOBAL_CONFIG.ALLOWED_DOMAIN_PREFIXES)
};

const URL_PATTERNS = {
	HTTPS: /^https:\//,
	HTTP: /^http:\//
};

const COMMON_HEADERS = {
	CORS: { 'Access-Control-Allow-Origin': '*' }
};

addEventListener('fetch', event => {
	event.respondWith(handleRequest(event))
})

async function handleRequest(event) {
	const { request } = event;
	const { url, headers, cf } = request;
	const parsedUrl = new URL(url);
	
	if (!isAllowedCountry(cf.country)) {
		return new Response('Access denied: Your country is not allowed to use this proxy.', { 
			status: 403,
			headers: COMMON_HEADERS.CORS
		});
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
		if (GLOBAL_CONFIG.ENABLE_REQUEST_COUNT) {
			incrementRequestCount().catch(console.error);
		}

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

function isAllowedCountry(country) {
	const hasOnlyEmptyString = RUNTIME_CONFIG.ALLOWED_COUNTRIES.size === 1 && 
							  RUNTIME_CONFIG.ALLOWED_COUNTRIES.has('');
	
	if (hasOnlyEmptyString) {
		return !RUNTIME_CONFIG.BLOCKED_COUNTRIES.has(country);
	}
	
	if (RUNTIME_CONFIG.ALLOWED_COUNTRIES.size === 0 && RUNTIME_CONFIG.BLOCKED_COUNTRIES.size === 0) {
		return true;
	}
	
	if (RUNTIME_CONFIG.ALLOWED_COUNTRIES.size > 0) {
		return RUNTIME_CONFIG.ALLOWED_COUNTRIES.has(country);
	}
	
	return !RUNTIME_CONFIG.BLOCKED_COUNTRIES.has(country);
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

async function incrementRequestCount() {
	const currentDate = new Date().toISOString().split('T')[0];
	const countKey = `count_${currentDate}`;

	try {
		const count = await REQUEST_COUNTER.get(countKey) || '0';
		const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];
		
		await Promise.all([
			REQUEST_COUNTER.put(countKey, (parseInt(count) + 1).toString()),
			REQUEST_COUNTER.delete(`count_${yesterday}`)
		]);
	} catch (error) {
		console.error('Counter error:', error);
	}
}

// 全局設置
const GLOBAL_CONFIG = {
	// 是否啟用請求計數
	ENABLE_REQUEST_COUNT: true,
	// 允許訪問的國家列表（白名單）(高優先級)
	ALLOWED_COUNTRIES: ['TW'],
	// 被禁止訪問的國家列表（黑名單）(低優先級)
	BLOCKED_COUNTRIES: ['CN', 'HK', 'MO', 'JP', 'KR', 'VN', 'ID', 'MY', 'PH', 'TH', 'VN'],
	// 允許的網域前綴列表
	ALLOWED_DOMAIN_PREFIXES: [
		'https://raw.githubusercontent.com/OG-Open-Source'
	],
	// 允許的通用字段 (指連結必須包含此字段)
	ALLOWED_GENERAL_PATTERN: '',
	// 快取設置
	CACHE_DURATION: 60 * 60, // 快取時間，單位為秒（這裡設置為1小時）
};

// KV 命名空間綁定(需設定KV COUNTER_NAMESPACE 並綁定到當前的Worker，如果沒有則跳過)
const REQUEST_COUNTER = typeof COUNTER_NAMESPACE !== 'undefined' ? COUNTER_NAMESPACE : {
	get: async () => null,
	put: async () => {},
	delete: async () => {}
};

addEventListener('fetch', event => {
	event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
	const country = request.cf.country;
	if (!isAllowedCountry(country)) {
		return new Response('Access denied: Your country is not allowed to use this proxy.', { status: 403 })
	}

	const url = new URL(request.url);

	const match = url.pathname.match(/^\/(https?:\/\/.+)/)

	if (!match) {
		return new Response('Invalid URL format.', { status: 400 })
	}

	const targetUrl = match[1]

	if (!isAllowedUrl(targetUrl)) {
		return new Response('Access denied: The requested URL is not allowed.', { status: 403 })
	}

	const destinationURL = new URL(targetUrl)
	destinationURL.pathname += url.pathname.slice(match[0].length)
	destinationURL.search = url.search

	let newRequest = new Request(destinationURL, request)

	if (GLOBAL_CONFIG.ENABLE_REQUEST_COUNT) {
		incrementRequestCount().catch(console.error);
	}

	const cacheKey = new Request(destinationURL.toString(), {
		method: 'GET',
		headers: request.headers
	});
	const cache = caches.default;
	let response = await cache.match(cacheKey);

	if (!response) {
		response = await fetch(newRequest);

		response = new Response(response.body, response);

		response.headers.set('Cache-Control', `public, max-age=${GLOBAL_CONFIG.CACHE_DURATION}`);

		event.waitUntil(cache.put(cacheKey, response.clone()));
	}

	response.headers.set('Access-Control-Allow-Origin', '*');

	return response;
}

function isAllowedCountry(country) {
	if (GLOBAL_CONFIG.ALLOWED_COUNTRIES.length > 0) {
		return GLOBAL_CONFIG.ALLOWED_COUNTRIES.includes(country);
	} else {
		return !GLOBAL_CONFIG.BLOCKED_COUNTRIES.includes(country);
	}
}

function isAllowedUrl(url) {
	const isPrefixAllowed = GLOBAL_CONFIG.ALLOWED_DOMAIN_PREFIXES.some(prefix => url.startsWith(prefix));

	if (!isPrefixAllowed) {
		return false;
	}

	if (GLOBAL_CONFIG.ALLOWED_GENERAL_PATTERN) {
		return url.includes(GLOBAL_CONFIG.ALLOWED_GENERAL_PATTERN);
	}

	return true;
}

async function incrementRequestCount() {
	const currentDate = new Date().toISOString().split('T')[0];
	const countKey = `count_${currentDate}`;

	let count = await REQUEST_COUNTER.get(countKey) || '0';
	await REQUEST_COUNTER.put(countKey, (parseInt(count) + 1).toString());

	const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];
	REQUEST_COUNTER.delete(`count_${yesterday}`).catch(console.error);
}
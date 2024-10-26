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
	ALLOWED_GENERAL_PATTERN: '',
	// 快取設置
	CACHE_CONFIG: {
		DURATION: 60 * 60, // 1小時
		SHARED_DURATION: 60 * 60, // 1小時
		CACHE_CONTROL_HEADER: 'public, max-age=3600, s-maxage=3600, stale-while-revalidate=3600',
		// 不應該被快取的請求頭
		EXCLUDED_HEADERS: [
			'authorization',
			'cookie',
			'set-cookie',
			'x-csrf-token',
			'cf-connecting-ip'
		]
	}
};

// KV 命名空間綁定 (需設定KV COUNTER_NAMESPACE 並綁定到當前的Worker，如果沒有則跳過)
const REQUEST_COUNTER = typeof COUNTER_NAMESPACE !== 'undefined' ? COUNTER_NAMESPACE : {
	get: async () => null,
	put: async () => {},
	delete: async () => {}
};

// 全局設置保持不變，但將常用的配置轉換為 Set 以提高查詢效率
const RUNTIME_CONFIG = {
	ALLOWED_COUNTRIES: new Set(GLOBAL_CONFIG.ALLOWED_COUNTRIES),
	BLOCKED_COUNTRIES: new Set(GLOBAL_CONFIG.BLOCKED_COUNTRIES),
	ALLOWED_DOMAIN_PREFIXES: new Set(GLOBAL_CONFIG.ALLOWED_DOMAIN_PREFIXES)
};

addEventListener('fetch', event => {
	event.respondWith(handleRequest(event))  // 修改：傳入整個 event 對象
})

async function handleRequest(event) {  // 修改：接收 event 參數
	const { request } = event;  // 從 event 中解構出 request
	const { url, headers, cf } = request;
	const parsedUrl = new URL(url);
	
	// 快速檢查國家限制
	if (!isAllowedCountry(cf.country)) {
		return new Response('Access denied: Your country is not allowed to use this proxy.', { 
			status: 403,
			headers: { 'Access-Control-Allow-Origin': '*' }
		});
	}

	// 修改：改進 URL 解析邏輯，確保正確處理斜線
	let targetUrl = parsedUrl.pathname.slice(1); // 移除開頭的 '/'
	
	// 確保 https:// 有兩個斜線
	if (targetUrl.startsWith('https:/')) {
		targetUrl = targetUrl.replace('https:/', 'https://');
	} else if (targetUrl.startsWith('http:/')) {
		targetUrl = targetUrl.replace('http:/', 'http://');
	}

	if (!targetUrl) {
		return new Response('Invalid URL format.', { 
			status: 400,
			headers: { 'Access-Control-Allow-Origin': '*' }
		});
	}

	// 檢查 URL 是否允許訪問
	if (!isAllowedUrl(targetUrl)) {
		return new Response(`Access denied: The requested URL is not allowed. URL: ${targetUrl}`, { 
			status: 403,
			headers: { 'Access-Control-Allow-Origin': '*' }
		});
	}

	// 創建目標 URL
	const destinationURL = new URL(targetUrl);
	destinationURL.search = parsedUrl.search;

	// 優化快取查詢
	const cache = caches.default;
	
	try {
		// 創建清理過的請求頭
		const cleanedHeaders = new Headers(headers);
		GLOBAL_CONFIG.CACHE_CONFIG.EXCLUDED_HEADERS.forEach(header => {
			cleanedHeaders.delete(header);
		});

		// 創建快取鍵 (不包含敏感頭部)
		const cacheKey = new Request(destinationURL.toString(), {
			method: 'GET',
			headers: cleanedHeaders
		});

		// 並行處理請求計數和快取查詢
		const [cacheResponse, _] = await Promise.all([
			cache.match(cacheKey),
			GLOBAL_CONFIG.ENABLE_REQUEST_COUNT ? incrementRequestCount() : Promise.resolve()
			]);

		if (cacheResponse) {
			const response = new Response(cacheResponse.body, cacheResponse);
			response.headers.set('Access-Control-Allow-Origin', '*');
			response.headers.set('X-Cache', 'HIT');
			return response;
		}

		const response = await fetch(new Request(destinationURL, {
			method: request.method,
			headers: cleanedHeaders
		}));

		const newResponse = new Response(response.body, response);
		
		// 設置增強的快取控制
		newResponse.headers.set('Cache-Control', GLOBAL_CONFIG.CACHE_CONFIG.CACHE_CONTROL_HEADER);
		newResponse.headers.set('Access-Control-Allow-Origin', '*');
		newResponse.headers.set('X-Cache', 'MISS');
		
		// 添加額外的快取相關響應頭
		newResponse.headers.set('Age', '0');
		newResponse.headers.set('X-Cache-Status', 'MISS');
		newResponse.headers.set('Vary', 'Accept-Encoding');

		// 非阻塞式快取存儲
		event.waitUntil(cache.put(cacheKey, newResponse.clone()));

		return newResponse;
	} catch (error) {
		console.error('Error:', error);
		return new Response('Internal Server Error: ' + error.message, { 
			status: 500,
			headers: { 'Access-Control-Allow-Origin': '*' }
		});
	}
}

function isAllowedCountry(country) {
	// 檢查白名單是否只包含空字符串
	const hasOnlyEmptyString = RUNTIME_CONFIG.ALLOWED_COUNTRIES.size === 1 && 
							  RUNTIME_CONFIG.ALLOWED_COUNTRIES.has('');
	
	// 如果白名單只有空字符串，視為未設置白名單
	if (hasOnlyEmptyString) {
		return !RUNTIME_CONFIG.BLOCKED_COUNTRIES.has(country);
	}
	
	// 如果白名單和黑名單都為空，允許所有國家
	if (RUNTIME_CONFIG.ALLOWED_COUNTRIES.size === 0 && RUNTIME_CONFIG.BLOCKED_COUNTRIES.size === 0) {
		return true;
	}
	
	// 如果有設置非空白名單，優先檢查白名單
	if (RUNTIME_CONFIG.ALLOWED_COUNTRIES.size > 0) {
		return RUNTIME_CONFIG.ALLOWED_COUNTRIES.has(country);
	}
	
	// 如果只有黑名單，檢查是否在黑名單中
	return !RUNTIME_CONFIG.BLOCKED_COUNTRIES.has(country);
}

function isAllowedUrl(url) {
	// 檢查 URL 是否以允許的前綴開始
	return Array.from(RUNTIME_CONFIG.ALLOWED_DOMAIN_PREFIXES).some(prefix => {
		const matches = url.startsWith(prefix);
		if (matches && GLOBAL_CONFIG.ALLOWED_GENERAL_PATTERN) {
			return url.includes(GLOBAL_CONFIG.ALLOWED_GENERAL_PATTERN);
		}
		return matches;
	});
}

async function incrementRequestCount() {
	const currentDate = new Date().toISOString().split('T')[0];
	const countKey = `count_${currentDate}`;

	try {
		const count = await REQUEST_COUNTER.get(countKey) || '0';
		const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];
		
		// 並行處理計數更新和清理
		await Promise.all([
			REQUEST_COUNTER.put(countKey, (parseInt(count) + 1).toString()),
			REQUEST_COUNTER.delete(`count_${yesterday}`)
		]);
	} catch (error) {
		console.error('Counter error:', error);
	}
}

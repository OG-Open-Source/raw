/**
 * Cloudflare Worker Proxy 使用教學
 *
 * 一、基本設定 (GLOBAL_CONFIG):
 * 1. 請求計數功能
 *    ENABLE_REQUEST_COUNT: true/false
 *    - 啟用後會記錄每日請求次數
 *    - 需要在 Cloudflare Dashboard 中設置 D1 數據庫
 *
 * 2. 國家訪問控制
 *    ALLOWED_COUNTRIES: ['TW', 'JP', ...]
 *    - 白名單，優先級高
 *    - 設為 [''] 表示不使用白名單
 *    - 留空 [] 且黑名單也為空時允許所有國家
 *
 *    BLOCKED_COUNTRIES: ['CN', 'RU', ...]
 *    - 黑名單，優先級低
 *    - 當白名單為 [''] 或空時才會檢查黑名單
 *
 * 3. URL 控制
 *    ALLOWED_DOMAIN_PREFIXES: ['https://example.com/path', ...]
 *    - 允許的網址前綴列表
 *    - 請求的 URL 必須以其中之一開頭
 *
 *    ALLOWED_GENERAL_PATTERN: 'string'
 *    - URL 必須包含的字符串
 *    - 留空則不檢查
 *
 * 二、設置步驟:
 * 1. D1 數據庫設置 (如果啟用請求計數):
 *    - 在 Cloudflare Dashboard 中:
 *      1. 進入 Workers & Pages
 *      2. 選擇您的 Worker
 *      3. 點擊 Settings 標籤
 *      4. 在 Resource Bindings 中:
 *         - 點擊 Add binding
 *         - Variable name: DB
 *         - Type: D1 Database
 *    - 創建數據表:
 *      1. 進入 D1 頁面
 *      2. 選擇您的數據庫
 *      3. 執行以下 SQL:
 *         CREATE TABLE IF NOT EXISTS request_counts (
 *             date TEXT PRIMARY KEY,
 *             count INTEGER NOT NULL DEFAULT 0
 *         );
 *
 * 三、使用方法:
 * 1. 代理請求格式:
 *    https://your-worker.domain/{target-url}
 *    例如: https://proxy.example.com/https://raw.githubusercontent.com/user/repo/file
 *
 * 2. 響應頭:
 *    - Access-Control-Allow-Origin: *
 *    所有響應都會加入 CORS 頭
 *
 * 四、錯誤響應:
 * - 403: 國家被禁止或 URL 不在允許列表中
 * - 400: URL 格式錯誤
 * - 500: 內部服務器錯誤
 */

const GLOBAL_CONFIG = {
	// 是否啟用請求計數
	ENABLE_REQUEST_COUNT: false,

	// 允許訪問的國家列表（白名單）
	ALLOWED_COUNTRIES: [],

	// 禁止訪問的國家列表（黑名單）
	BLOCKED_COUNTRIES: [],

	// 允許的網域前綴列表
	ALLOWED_DOMAIN_PREFIXES: [
		'https://example.com'
	],

	// 允許的通用字段
	ALLOWED_GENERAL_PATTERN: ''
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

export default {
	async fetch(request, env, ctx) {
		return handleRequest(request, env, ctx);
	}
};

async function handleRequest(request, env, ctx) {
	const { url, headers, cf } = request;
	const parsedUrl = new URL(url);

	const clientIP = request.headers.get('cf-connecting-ip') || 
					cf.ip || 
					'unknown';

	if (GLOBAL_CONFIG.ENABLE_REQUEST_COUNT) {
		ctx.waitUntil(incrementRequestCount(env.DB, clientIP));
	}

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

async function incrementRequestCount(db, ip) {
	const currentDate = new Date().toISOString().split('T')[0];
	const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];

	try {
		await db.prepare(
			`INSERT INTO ip_visits (date, ip, count) 
			 VALUES (?, ?, 1) 
			 ON CONFLICT(date, ip) DO UPDATE 
			 SET count = count + 1 
			 WHERE date = ? AND ip = ?`
		)
		.bind(currentDate, ip, currentDate, ip)
		.run();

		await db.prepare(
			`DELETE FROM ip_visits WHERE date = ?`
		)
		.bind(yesterday)
		.run();

	} catch (error) {
		console.error('Counter error:', error);
	}
}

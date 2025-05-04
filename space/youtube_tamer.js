// ==UserScript==
// @name         YouTube Tamer (by CY Fung)
// @namespace    UserScripts
// @version      1.0.0
// @description  To enhance YouTube performance
// @author       OG-Opne-Source
// @exclude      /^https?://\S+\.(txt|png|jpg|jpeg|gif|xml|svg|manifest|log|ini)[^\/]*$/
// @match        https://www.youtube.com/*
// @match        https://www.youtube-nocookie.com/embed/*
// @match        https://studio.youtube.com/live_chat*
// @license      MIT
// @icon         https://raw.githubusercontent.com/OG-Open-Source/raw/main/space/youtube_tamer.png
// @grant        none
// ==/UserScript==
(() => {
	const WeakMap = window.WeakMapOriginal || window.WeakMap;
	const NATIVE_CANVAS_ANIMATION = false;
	const FIX_schedulerInstanceInstance = 2 | 4;
	const FIX_yt_player = true;
	const FIX_Animation_n_timeline = true;
	const NO_PRELOAD_GENERATE_204 = false;
	const ENABLE_COMPUTEDSTYLE_CACHE = true;
	const NO_SCHEDULING_DUE_TO_COMPUTEDSTYLE = true;
	const CHANGE_appendChild = true;
	const FIX_bind_self_this = false;
	const FIX_weakMap_weakRef = false;
	const FIX_error_many_stack = true;
	const FIX_Iframe_NULL_SRC = false;
	const IGNORE_bindAnimationForCustomEffect = true;
	const FIX_ytdExpander_childrenChanged = true;
	const FIX_paper_ripple_animate = true;
	const FIX_avoid_incorrect_video_meta = true;
	const FIX_avoid_incorrect_video_meta_emitterBehavior = true;
	const FIX_doIdomRender = true;
	const FIX_Shady = true;
	const MODIFY_ShadyDOM_OBJ = true;
	const WEAKREF_ShadyDOM = true;
	const OMIT_ShadyDOM_EXPERIMENTAL = 1 | 0;
	const OMIT_ShadyDOM_settings = 0 | 0 | 0;
	const WEAK_REF_BINDING_CONTROL = 1 | 2;
	const FIX_ytAction_ = true;
	const FIX_onVideoDataChange = false;
	const FIX_onStateChange = true;
	const FIX_onLoopRangeChange = true;
	const FIX_VideoEVENTS_v2 = true;
	const ENABLE_discreteTasking = false;
	const FIX_stampDomArray_ = true;
	const FIX_stampDomArray = FIX_stampDomArray_ && typeof WeakRef === "function" && typeof FinalizationRegistry === "function";
	const stampDomArray_MemoryFix_Flag001 = false;
	const XFlag = true;
	const MemoryFix_Flag002 = 1 | 2 | 4 | 8 | 0 | 32 | 64 | 0 | 256;
	const FIX_perfNow = true;
	const ENABLE_ASYNC_DISPATCHEVENT = false;
	const FIX_Polymer_dom = true;
	const FIX_Polymer_AF = true;
	const SCRIPTLET_REMOVE_PRUNE_propNeedles = true;
	const DEBUG_removePrune = false;
	const FIX_XHR_REQUESTING = true;
	const LOG_FETCHMETA_UPDATE = false;
	const IGNORE_bufferhealth_CHECK = false;
	const DENY_requestStorageAccess = true;
	const DISABLE_IFRAME_requestStorageAccess = true;
	const DISABLE_COOLDOWN_SCROLLING = true;
	const FIX_removeChild = true;
	const FIX_fix_requestIdleCallback_timing = true;
	const HOOK_CSSPD_LEFT = true;
	const FORCE_NO_REUSEABLE_ELEMENT_POOL = true;
	const FIX_TRANSCRIPT_SEGMENTS = true;
	const FIX_POPUP_UNIQUE_ID = true;
	const FIX_DOM_IF_REPEAT = true;
	const FIX_DOM_IF_TEMPLATE = true;
	const FIX_DOM_IFREPEAT_RenderDebouncerChange = false;
	const DEBUG_DBR847 = false;
	const DEBUG_xx847 = false;
	const FIX_DOM_IFREPEAT_RenderDebouncerChange_SET_TO_PROPNAME = true;
	const DEBUG_renderDebounceTs = false;
	const FIX_ICON_RENDER = true;
	const FIX_VIDEO_PLAYER_MOUSEHOVER_EVENTS = true;

	const FIX_SHORTCUTKEYS = 2;
	const CHANGE_SPEEDMASTER_SPACEBAR_CONTROL = 0;
	const USE_IMPROVED_PAUSERESUME_UNDER_NO_SPEEDMASTER = true;
	const PROP_OverReInclusion_AVOID = true;
	const PROP_OverReInclusion_DEBUGLOG = false;
	const PROP_OverReInclusion_LIST = new Set([
		'hostElement72',
		'parentComponent72',
		'localVisibilityObserver_72',
		'cachedProviderNode_72',
		'__template72',
		'__templatizeOwner72',
		'__templateInfo72',
		'__dataHost72',
		'__CE_shadowRoot72',
		'elements_72',
		'ky36',
		'kz62',
		'm822',
		'disabled', 'allowedProps',
		'filledButtonOverrides', 'openPopupConfig', 'supportsInlineActionButtons', 'allowedProps',
		'dimension', 'loadTime', 'pendingPaint',
		'countdownDurationMs', 'countdownMs', 'lastCountdownTimeMs', 'rafId', 'playerProgressSec', 'detlaSincePausedSecs', 'behaviorActionMap', 'selected', 'maxLikeCount', 'maxReplyCount', 'isMouseOver',
		'respectLangDir', 'noEndpoints',
		'objectURL',
		'buttonOverrides', 'queuedMessages',
		'STEP', 'BLOCK_ON', 'MIN_PROGESS', 'MAX_PROGESS',
		'DISMISSED_CONTENT_KEYSPACE', 'followUpDialogPromise', 'followUpDialogPromiseResolve', 'followUpDialogPromiseReject',
		'hoverJobId', 'JSC$14573_touched',
		'toggleable', 'isConnected',
		'scrollDistance', 'dragging', 'dragMouseStart', 'dragOffsetStart', 'containerWidthDiff',
		'disableDeselectEvent',
		'emojiSize',
		'buttonOverride',
		'shouldUseStickyPreferences', 'longPressTimeoutId',
		'observeVisibleOption', 'observeHiddenOption', 'observePrescanOption', 'visibilityMonitorKeys',
		'observeVisibleOption', 'observeHiddenOption', 'observePrescanOption', 'visibilityMonitorKeys',
		'clearTimeout',
		'switchTemplateAtRegistration', 'hasUnmounted',
		'switchTemplateAtRegistration', 'stopKeyboardEventPropagation',
		'tangoConfiguration',
		'itemIdToDockDurationMap',
		'actionMap',
		'emojiManager', 'inputMethodEditorActive', 'suggestionIndex', 'JSC$10745_lastSuggestionRange',
		'actionMap', 'asyncHandle', 'shouldAnimateIn', 'lastFrameTimestamp', 'scrollClampRaf',
		'scrollRatePixelsPerSecond', 'scrollStartTime', 'scrollStopHandle'
	]);

	const advanceLogging = typeof AbortSignal !== 'undefined' && typeof (AbortSignal || 0).timeout === 'function' && typeof navigator !== 'undefined' && /\b(Macintosh|Mac\s*OS)\b/i.test((navigator || 0).userAgent || '');
	const win = this instanceof Window ? this : window;
	const hkey_script = 'jswylcojvzts';
	if (win[hkey_script]) throw new Error('Duplicated Userscript Calling');
	win[hkey_script] = true;
	const wk = Symbol();
	let BY_PASS_KEYBOARD_CONTROL = false;

	const nextBrowserTick_ = nextBrowserTick;
	if (typeof nextBrowserTick_ !== "function" || (nextBrowserTick_.version || 0) < 2) {
		console.log('nextBrowserTick is not found.');
		return;
	}
	let p59 = 0;
	const Promise = (async () => { })().constructor;
	const PromiseExternal = ((resolve_, reject_) => {
		const h = (resolve, reject) => { resolve_ = resolve; reject_ = reject };
		return class PromiseExternal extends Promise {
			constructor(cb = h) {
				super(cb);
				if (cb === h) {

					this.resolve = resolve_;

					this.reject = reject_;
				}
			}
		};
	})();
	const FinalizationRegistry_ = typeof FinalizationRegistry !== "undefined" ? FinalizationRegistry : class FinalizationRegistry__ {
		constructor(callback = undefined) {
		}
		register(target, heldValue, unregisterToken = undefined) {
		}
		unregister(unregisterToken) {
		}
	}
	let ttpHTML = (s) => {
		ttpHTML = s => s;
		if (typeof trustedTypes !== 'undefined' && trustedTypes.defaultPolicy === null) {
			let s = s => s;
			trustedTypes.createPolicy('default', { createHTML: s, createScriptURL: s, createScript: s });
		}
		return s;
	}

	const HTMLElement_ = Reflect.getPrototypeOf(HTMLTitleElement);
	const nativeAppendE = HTMLElement_.prototype.append;
	const nativeRemoveE = HTMLElement_.prototype.remove;
	const DocumentFragment_ = DocumentFragment;
	const nativeAppendD = DocumentFragment_.prototype.append;
	const Node_ = Node;

	const toFixed2 = (x, d) => {
		let t = x.toFixed(d);
		let y = `${+t}`;
		return y.length > t.length ? t : y;
	}
	const isChatRoomURL = location.pathname.startsWith('/live_chat');
	const TRANSLATE_DEBUG = false;
	let xdeadc00 = null;
	let xlivec00 = null;
	let removeTNodeRM = null;
	let removeTNodeBP = false;
	let FORCE_NO_REUSEABLE_ELEMENT_POOL_fired = false;
	const FORCE_NO_REUSEABLE_ELEMENT_POOL_fn = (mainCnt) => {
		if (FORCE_NO_REUSEABLE_ELEMENT_POOL_fired) return;
		FORCE_NO_REUSEABLE_ELEMENT_POOL_fired = true;
		if (typeof mainCnt.createComponent_ !== 'function' || mainCnt.createComponent_.length != 3) {
			console.warn('FORCE_NO_REUSEABLE_ELEMENT_POOL_fn failed.')
			return;
		}
		const mapGet = Map.prototype.get;
		const setHas = Set.prototype.has;

		let qcMap = null;
		Set.prototype.has = function (a) {
			if (a === 'dummy-4718') return false;
			return setHas.call(this, a);
		}
		Map.prototype.get = function (a) {
			if (a === 'dummy-4718') qcMap = this;
			return mapGet.call(this, a);
		};
		let r;
		try {
			r = mainCnt.createComponent_('dummy-4718', {}, true);
		} catch (e) {
		}
		Map.prototype.get = mapGet;
		Set.prototype.has = setHas;
		if (r && (r.nodeName || '').toLowerCase() === 'dummy-4718') {
			if (qcMap !== null && qcMap instanceof Map) {
				console.log('[yt-js-engine-tamer] qcMap', qcMap);
				qcMap.__qcMap8781__ = true;
				const setArrayC = (c) => {
					if (c instanceof Array) {
						c.length = 0;
						c.push = function () { };
						c.pop = function () { };
						c.shift = function () { };
						c.unshift = function () { };
						c.splice = function () { };
						c.sort = function () { };
						c.reverse = function () { };
					}
				}
				const cleaning = function (m) {
					m.forEach(setArrayC);
					m.clear();
				}
				qcMap.set = function (b, c) {
					if (!this.__qcMap8781__) return Map.prototype.set.call(this, b, c);
					setArrayC(c);
					if (this.size > 0) {
						console.log('[yt-js-engine-tamer] qcMap', 'clear 01')
						cleaning(this);
					}
				}
				qcMap.get = function (b) {
					if (!this.__qcMap8781__) return Map.prototype.get.call(this, b);
					if (this.size > 0) {
						console.log('[yt-js-engine-tamer] qcMap', 'clear 02')
						cleaning(this);
					}
				}
				if (qcMap.size > 0) {
					console.log('[yt-js-engine-tamer] qcMap', 'clear 03')
					cleaning(qcMap);
				}
			}
		}
		r = null;
		qcMap = null;
	}
	const dispatchYtEvent = function (a, b, c, d) {
		d || (d = {
			bubbles: !0,
			cancelable: !1,
			composed: !0
		});
		c !== null && c !== void 0 && (d.detail = c);
		b = new CustomEvent(b, d);
		a.dispatchEvent(b);
		return b
	};
	if (XFlag) {
		const cMap = new Set();
		cMap.add = cMap.addOriginal || cMap.add;
		const yMap = new Set();
		yMap.add = yMap.addOriginal || yMap.add;
		const ydMap = new Set();
		ydMap.add = ydMap.addOriginal || ydMap.add;
		window.yMap = yMap;
		window.cMap = cMap;
		window.ydMap = ydMap;
		const constructAts = new Set();
		constructAts.add = constructAts.addOriginal || constructAts.add;
		window.constructAts = constructAts;
		const kMap = new WeakMap();
		const kRefProp = (wr, prop) => {
			let o = kRef(wr);
			return o ? o[prop] : null;
		}
		const wrObj = (objRef, props) => {
			let wr = mWeakRef(objRef);
			if (wr === objRef || !props || !props.length) return wr;
			let properties = {};
			props.forEach(k => {
				properties[k] = {
					get() {
						return kRefProp(this, k)
					},
					enumerable: false,
					configurable: true
				};
			});
			Object.defineProperties(wr, properties);
			return wr;
		}
		const sProtos = {};
		const setupCProto = function (cProto) {
			if (cProto === Object.prototype) return;
			if (!kMap.get(cProto)) kMap.set(cProto, `protoKey0_${Math.floor(Math.random() * 314159265359 + 314159265359).toString(36)}_${Date.now()}`);
			cProto[kMap.get(cProto)] = true;
			const constructAt = `\n\n${new Error().stack}\n\n`.replace(/[\r\n]([^\r\n]*?\.user\.js[^\r\n]*?[\r\n]+)+/g, '\n').replace(/[\r\n]([^\r\n.]+[\r\n]+)+/g, '\n').trim().split(/[\r\n]+/)[0];
			constructAts.add(constructAt)
			if (MemoryFix_Flag002 & 32) {
				if (!cProto.dk322 && (cProto.__attachInstance || cProto.__detachInstance)) {
					fixDetachFn(cProto);
				}
			}
			if (MemoryFix_Flag002 & 2) {
				if (cProto._setPendingProperty && !cProto.__setPropDX38__) {
					cProto.__setPropDX38__ = true;
					if (cProto._setPendingProperty.length === 3) {
						cProto._setPendingProperty.bind = sProtos._setPendingProperty$bind || (sProtos._setPendingProperty$bind = function (obj, ...args) {
							let wobj = obj[wk] || (obj[wk] = mWeakRef(obj));
							return () => {
								const obj = kRef(wobj);
								let u = Reflect.apply(this, obj, args);
								args.length = 0;
								wobj = null;
								return u;
							};
						});
					}
				}
			}
			if (MemoryFix_Flag002 & 4) {
				if (cProto._runEffectsForTemplate && !cProto.__runEffectDX38__) {
					cProto.__runEffectDX38__ = true;
					if (cProto._runEffectsForTemplate.length === 4) {
						cProto._runEffectsForTemplate3858 = cProto._runEffectsForTemplate;
						cProto._runEffectsForTemplate = sProtos._runEffectsForTemplate || (sProtos._runEffectsForTemplate = function (c, d, e, g) {
							if (c && c.runEffects) {
								let wr = wrObj(c, ['propertyEffects', 'nodeList', 'firstChild']);
								if (!this[wk]) this[wk] = mWeakRef(this);
								if ((typeof (e || 0) === "object") && !e[wk]) e[wk] = mWeakRef(e);
								let cntWr = this[wk];
								let eWr = (typeof (e || 0) === "object") ? e[wk] : e;
								c.runEffects((n, r) => {
									const cnt = kRef(cntWr);
									const e = kRef(eWr);
									if (cnt) {
										cnt._runEffectsForTemplate3858(wr, n, e, r);
									}
									wr = cntWr = d = e = g = null;
								}, d, g);
							} else {
								let { propertyEffects, nodeList, firstChild } = c;
								let o = { propertyEffects, nodeList, firstChild }
								this._runEffectsForTemplate3858(o, d, e, g);
								o.propertyEffects = o.nodeList = o.firstChild = null;
								propertyEffects = nodeList = firstChild = null;
								o = null;
							}
						});
						cProto._runEffectsForTemplate.bind = sProtos._runEffectsForTemplate$bind || (sProtos._runEffectsForTemplate$bind = function (obj, ...args) {
							let wobj = obj[wk] || (obj[wk] = mWeakRef(obj));
							return () => {
								const obj = kRef(wobj);
								let u = Reflect.apply(this, obj, args);
								args.length = 0;
								wobj = null;
								return u;
							};
						});
					}
				}
			}
			const cProtoConstructor = cProto.constructor;
			if (MemoryFix_Flag002 & 8) {
				if (cProtoConstructor._parseBindings && !cProtoConstructor.__parseBindingsDX38__) {
					cProtoConstructor.__parseBindingsDX38__ = true;
					ydMap.add(cProtoConstructor);
					if (cProtoConstructor._parseBindings.length === 2) {
						cProtoConstructor._parseBindings3858 = cProtoConstructor._parseBindings;
						cProtoConstructor._parseBindings = sProtos._parseBindings || (sProtos._parseBindings = function (c, d) {
							let p = this._parseBindings3858(c, d);
							this.__bindingsArrs__ = this.__bindingsArrs__ || [];
							if (p) this.__bindingsArrs__.push(p);
							return p;
						});
					}
				}
			}


		}
		const symDH = Symbol();
		const wfStore = new WeakMap();
		const wrapF = function (f, key) {
			if (wfStore.get(f)) return wfStore.get(f);
			let g = function () {
				const o = kRef(this);
				if (!o) return;
				const cnt = insp(o);
				return f.apply(o, arguments);
			};
			g.key38 = key;
			g.originalFunc38 = f;
			g.__wrapF84__ = true;
			wfStore.set(f, g);
			wfStore.set(g, g);
			return g;
		};
		if (MemoryFix_Flag002 & 16) {
			['_createPropertyAccessor', '_addPropertyToAttributeMap', '_definePropertyAccessor', 'ready', '_initializeProperties', '_initializeInstanceProperties', '_setProperty', '_getProperty', '_setPendingProperty', '_isPropertyPending', '_invalidateProperties', '_enableProperties', '_flushProperties', '_shouldPropertiesChange', '_propertiesChanged', '_shouldPropertyChange', 'attributeChangedCallback', '_attributeToProperty', '_propertyToAttribute', '_valueToNodeAttribute', '_serializeValue', '_deserializeValue'].forEach(key => {
				Object.defineProperty(Node.prototype, key, {
					get() {
						return this[`__a0939${key}__`];
					},
					set(nv) {
						if (typeof nv !== 'function') return;
						const g = (nv.__wrapF84__) ? nv : wrapF(nv, key);
						this[`__a0939${key}__`] = g;
						return true;
					}
				});
			});
		}
		const fragQ = document.createDocumentFragment();
		const fixDetachFn = (tpProto) => {
			if (tpProto.dk322) return;
			tpProto.dk322 = true;
			tpProto.__detachInstance994 = tpProto.__detachInstance;
			if (typeof tpProto.__detachInstance994 === 'function' && tpProto.__detachInstance994.length === 1) {
				tpProto.__detachInstance = function (a) {
					const u = this.__instances[a];
					if (u && u.root) {
						const children = u ? u.children : null;
						if (children && children.length >= 1) {
							this.__detachInstance994(a);
						}
					} else if (u && !u.root) {
						const children = u ? u.children : null;
						if (children && children.length >= 1) {
							for (let i = 0, l = children.length; i < l; i++) {
								const node = children[i];
								fragQ.appendChild(node);
								Promise.resolve(node).then(node => (node.parentNode === fragQ) && !!node.remove());
							}
						}
					}
					return u;
				}
			}
			tpProto.__attachInstance994 = tpProto.__attachInstance;
			if (typeof tpProto.__attachInstance994 === 'function' && tpProto.__attachInstance994.length === 2) {
				tpProto.__attachInstance = function (a, b) {
					const u = this.__instances[a];
					if (u && u.root && b) {
						fragQ.appendChild(u.root);
						return this.__attachInstance994(a, b);
					}
				}
			}
		}
		const ytTemplateDomEntry = (tpProto) => {
			console.log('ytTemplateDomEntry triggered')
			const convertToWeakArr = (arr) => {
				if (arr.isWeak) return;
				for (let i = 0, l = arr.length; i < l; i++) {
					const o = arr[i]
					if (o) {
						let p = kRef(o)
						if (!p) arr[i] = null;
						else {
							if (!o[wk]) o[wk] = mWeakRef(o);
							arr[i] = o[wk];
						}
					}
				}
				arr.isWeak = true;
			}
			const convertToNormalArr = (arr) => {
				if (!arr.isWeak) return;
				for (let i = 0, l = arr.length; i < l; i++) {
					const o = arr[i]
					if (o) {
						let p = kRef(o)
						arr[i] = p;
					}
				}
				arr.isWeak = false;
			}
			if (MemoryFix_Flag002 & 256) {
				Object.defineProperty(tpProto, '__instances', {
					get() {
						this.dk322 || fixDetachFn(Reflect.getPrototypeOf(this));
						let arr = this.__instances_actual471__;
						convertToNormalArr(arr);
						Promise.resolve(arr).then(convertToWeakArr);
						return arr;
					},
					set(nv) {
						this.dk322 || fixDetachFn(Reflect.getPrototypeOf(this));
						this.__instances_actual471__ = nv;
						Promise.resolve(nv).then(convertToWeakArr);
						return true;
					},
					enumerable: false,
					configurable: true
				});
			}
			if (MemoryFix_Flag002 & 32) {
				if (tpProto.__detachInstance) {
					fixDetachFn(tpProto);
				} else {
					Promise.resolve(tpProto).then((tpProto) => {
						fixDetachFn(tpProto);
					})
				}
			}
		}
		if (MemoryFix_Flag002 & 32) {
			Object.defineProperty(Object.prototype, '__ensureTemplatized', {
				set(nv) {
					if (nv === true) return false;
					tpProto = this;
					if ('connectedCallback' in tpProto && tpProto !== Node.prototype && !tpProto.__domDX37__) {
						tpProto.__domDX37__ = true;
						ytTemplateDomEntry(tpProto);
					}
					this.__ensureTemplatized949__ = nv;
					return true;
				},
				get() {
					return this.__ensureTemplatized949__;
				}
			});
		}
		if (MemoryFix_Flag002 & 64) {
			HTMLElement_.prototype.__dataHostBinding374 = true;
			Object.defineProperty(HTMLElement_.prototype, '__dataHost', {
				get() {
					return kRef(this.__dataHostWr413__);
				},
				set(nv) {
					if (nv && typeof nv === 'object' && !nv.deref) {
						if (!nv[wk]) nv[wk] = mWeakRef(nv);
						nv = nv[wk];
					}
					this.__dataHostWr413__ = nv;
					return true;
				}
			});
		}
		const setupYProto = function (yProto) {
			if (yProto === Object.prototype) return;
			if (!kMap.get(yProto)) kMap.set(yProto, `protoKey1_${Math.floor(Math.random() * 314159265359 + 314159265359).toString(36)}_${Date.now()}`);
			yProto[kMap.get(yProto)] = true;
			if (MemoryFix_Flag002 & 32) {
				if (!yProto.dk322 && (yProto.__attachInstance || yProto.__detachInstance)) {
					fixDetachFn(yProto);
				}
			}
			if (MemoryFix_Flag002 & 128) {
				if (!yProto.__dataHostBinding374) {
					yProto.__dataHostBinding374 = true;
					Object.defineProperty(yProto, '__dataHost', {
						set(nv) {
							let dh = nv;
							if (dh && typeof dh === 'object' && !dh.deref) {
								const wr = dh[wk] || (dh[wk] = mWeakRef(dh));
								dh = wr;
							}
							this[symDH] = dh;
							return true;
						},
						get() {
							let wr = this[symDH];
							let obj = typeof wr === 'object' ? kRef(wr) : wr;
							return obj;
						},
						enumerable: false,
						configurable: true
					});
				}
				if (yProto._registerHost && yProto._enqueueClient && yProto.__enableOrFlushClients && !yProto._registerHostDX38__) {
					yProto._registerHostDX38__ = true;
					yProto.__enableOrFlushClients = function () {
						const c_ = this.__dataPendingClients;
						if (c_) {
							const c = c_.slice();
							c_.length = 0;
							for (let d = 0, l = c.length; d < l; d++) {
								let e = kRef(c[d]);
								if (e) {
									e.__dataEnabled ? e.__dataPending && e._flushProperties() : e._enableProperties()
								}
							}
						}
					}
					yProto._enqueueClient = function (c) {
						if (c === this || !c || typeof c !== 'object') return;
						if (c.deref) c = kRef(c);
						const m = this.__dataPendingClients || (this.__dataPendingClients = []);
						if (!c[wk]) c[wk] = mWeakRef(c);
						m.push(c[wk]);
					}
				}
			}
		}
		const setupRendering = function () {
			const cnt = this;
			const cProto = Reflect.getPrototypeOf(cnt);
			let yProto = Reflect.getPrototypeOf(cProto);
			const yProtos = new Set();
			if (!yMap.has(yProto)) {
				do {
					if (yProto === Object.prototype || yProto === null) break;
					if (yProto === Element.prototype || yProto === Node.prototype || yProto === EventTarget.prototype || yProto === HTMLElement_.prototype) break;
					yProtos.add(yProto);
					yProto = Reflect.getPrototypeOf(yProto);
				} while (!yProtos.has(yProto));
				for (const yProto of yProtos) {
					yMap.add(yProto);
					setupYProto(yProto)
				}
			}
			if (!cMap.has(cProto)) {
				cMap.add(cProto);
				setupCProto(cProto);
			}
		}
		const selfRef = {};
		let wm3 = new WeakMap();
		Object.defineProperty(Object.prototype, 'root', {
			get() {
				const p = this ? kRef(this) : null;
				const r = p ? wm3.get(p) : null;
				const r2 = r ? kRef(r) : null;
				if (r === selfRef) return p;
				return r2;
			},
			set(nv) {
				const p = this ? kRef(this) : null;
				const mv = nv ? kRef(nv) : null;
				if (typeof mv !== 'object') return;
				if (mv && (mv instanceof Node) && !p.__setupRendered399__) {
					p.__setupRendered399__ = true;
					setupRendering.call(p);
				}
				if (mv && mv.is && !mv.__setupRendered399__) {
					mv.__setupRendered399__ = true;
					setupRendering.call(mv);
				}
				if (mv === p) {
					wm3.set(p, selfRef)
					return true;
				}
				let gv = nv;
				if (nv && !nv[wk]) {
					gv = nv[wk] = mWeakRef(nv);
				}
				if (p) {
					wm3.set(p, gv);
				}
				return true;
			},
			enumerable: false,
			configurable: true
		});
	}
	function getTranslate() {
		pLoad.then(() => {
			let nonce = document.querySelector('style[nonce]');
			nonce = nonce ? nonce.getAttribute('nonce') : null;
			const st = document.createElement('style');
			if (typeof nonce === 'string') st.setAttribute('nonce', nonce);
			st.textContent = ".yt-formatted-string-block-line{display:block;}";
			let parent;
			if (parent = document.head) parent.appendChild(st);
			else if (parent = (document.body || document.documentElement)) parent.insertBefore(st, parent.firstChild);
		});
		const snCache = new Map();
		if (TRANSLATE_DEBUG) {
			console.log(11)
		}

		function _snippetText(str) {
			if (!str || typeof str !== 'string') return '';
			let res = snCache.get(str);
			if (res === undefined) {
				let b = false;
				res = str.replace(/[\s\u3000\u200b]*[\u200b\xA0\x20\n]+[\s\u3000\u200b]*/g, (m) => {
					b = true;
					return m.includes('\n') ? '\n' : m.replace(/\u200b/g, '').replace(/[\xA0\x20]+/g, ' ');
				});
				res = res.replace(/^[\s\u3000]+|[\u3000\s]+$/g, () => {
					b = true;
					return '';
				});
				if (b) {
					snCache.set(str, res);
					snCache.set(res, null);
				} else {
					res = null;
					snCache.set(str, null);
				}
			}
			return res === null ? str : res;
		}

		function snippetText(snippet) {
			let runs = snippet.runs;
			const n = runs.length;
			if (n === 1) return _snippetText(runs[0].text);
			let res = new Array(n);
			let ci = 0;
			for (const s of runs) {
				res[ci++] = _snippetText(s.text);
			}
			return res.join('\n');
		}
		const _DEBUG_szz = (t) => t.map(x => {
			const tsr = x.transcriptSegmentRenderer;
			return ({
				t: tsr.snippet.runs.map(x => x.text).join('//'),
				a: tsr.startMs,
				b: tsr.endMs
			});
		});
		const fixRuns = (runs) => {
			if (runs.length === 1 && runs[0]?.text?.includes('\n')) {
				const text = runs[0].text;
				const nlc = text.includes('\r\n') ? '\r\n' : text.includes('\n\r') ? '\n\r' : text.includes('\r') ? '\r' : '\n';
				const s = text.split(nlc);
				let bi = 0;
				runs.length = s.length;
				for (const text of s) {
					runs[bi++] = { ...runs[0], text, ...{ blockLine: true } };
				}
			}
			for (const s of runs) {
				s.text = _snippetText(s.text);
			}
		}
		function translate(initialSegments) {
			if (!initialSegments) return initialSegments;
			if (TRANSLATE_DEBUG) {
				console.log(12);
				Promise.resolve(JSON.stringify(initialSegments)).then((r) => {
					let obj = JSON.parse(r);
					console.log(7558, 1, obj)
					return obj;
				}).then(p => {
					let obj = _DEBUG_szz(p)
					console.log(7558, 2, obj)
				})
			}
			//let mapRej = new WeakSet();
			const n1 = initialSegments.length;
			if (!n1) return fRes;
			let n2 = 0;
			const fRes = new Array(n1);
			const s8 = Symbol();
			{

				let cacheTexts = new Map();
				for (const initialSegment of initialSegments) {
					const transcript = (initialSegment || 0).transcriptSegmentRenderer;
					if (!transcript) {
						fRes[n2++] = initialSegment;
						continue;
					}
					const runs = transcript.snippet.runs
					if (!runs || runs.length === 0) {
						initialSegment[s8] = true;
						continue;
					}
					let startMs = (+transcript.startMs || 0);
					let endMs = (+transcript.endMs || 0);
					if (startMs === endMs) {
						//mapRej.add(initialSegment)
						continue;
					}
					if (endMs - startMs < 30) {
						continue;
					}
					const text = snippetText(transcript.snippet);
					const hEntry = cacheTexts.get(text);
					const mh1e = hEntry === undefined ? 0 : hEntry === null ? 2 : 1;
					if (mh1e === 2) continue;
					const entry = {
						startMs,
						endMs,
						initialSegment,
						text
					};
					if (mh1e === 0) {
						if (/^[,.\x60\x27\x22\u200b\xA0\x20;-]*$/.test(text)) {
							initialSegment[s8] = true;
							cacheTexts.set(text, null);
							//effect only
							//mapRej.add(initialSegment)
							continue;
						}
					} else if (hEntry) {
						const timeDiff = entry.startMs - hEntry.endMs;
						let shouldMerge = false;
						if (timeDiff >= 0) {
							if (timeDiff < 25) {
								shouldMerge = true;
							} else if (timeDiff < 450 && entry.endMs - entry.startMs < 900) {
								shouldMerge = true;
							} else if (timeDiff < 150 && entry.endMs - entry.startMs > 800) {
								shouldMerge = true;
							}
							if (shouldMerge && hEntry.endMs <= endMs && startMs <= endMs) {
								hEntry.endMs = entry.endMs;
								hEntry.initialSegment.transcriptSegmentRenderer.endMs = entry.initialSegment.transcriptSegmentRenderer.endMs;
								//mapRej.add(entry.initialSegment);
								continue;
							}
						} else if (entry.startMs < hEntry.startMs && hEntry.startMs < entry.endMs) {
							if (entry.endMs > hEntry.endMs) {
								hEntry.endMs = entry.endMs;
								hEntry.initialSegment.transcriptSegmentRenderer.endMs = entry.initialSegment.transcriptSegmentRenderer.endMs;
							}
							//mapRej.add(entry.initialSegment);
							continue;
						}
					}
					//if not abandoned
					cacheTexts.set(text, entry);
					fixRuns(runs);
					fRes[n2++] = initialSegment;
				}
				cacheTexts = null;
			}
			const si_length = fRes.length = n2;
			const sj_length = n1;
			if (si_length !== sj_length) {
				let sj_start = 0;
				let invalid_sj = -1;
				for (let si = 0; si < si_length; si++) {
					const segment = fRes[si];
					let transcript = segment.transcriptSegmentRenderer;
					if (!transcript) continue;
					const runs = transcript.snippet.runs;
					if (runs.length > 1 || runs[0].text.includes('\n')) continue;
					const main_startMs = (+transcript.startMs || 0);
					const main_endMs = (+transcript.endMs || 0);
					transcript = null;

					let tMap = new Map();
					for (let sj = sj_start; sj < sj_length; sj++) {
						const initialSegment = initialSegments[sj];
						if (!initialSegment || initialSegment[s8]) continue;
						const tSegment = initialSegment.transcriptSegmentRenderer;
						if (!tSegment) {
							invalid_sj = sj;
							continue;
						}
						const startMs = (+tSegment.startMs || 0)
						const isStartValid = startMs >= main_startMs;
						if (!isStartValid) {
							invalid_sj = sj;
							continue;
						}
						if (startMs > main_endMs) {
							sj_start = invalid_sj + 1;
							break;
						}
						const endMs = (+tSegment.endMs || 0)
						if (endMs <= main_endMs) {
							const mt = snippetText(tSegment.snippet);
							const prev = tMap.get(mt);
							if (endMs >= startMs) {
								tMap.set(mt, (prev || 0) + 1 + (endMs - startMs));
							}
						}
					}
					if (tMap.size <= 1) continue;
					let rg = [...tMap.entries()];
					tMap = null;
					rg.sort((a, b) => b[1] - a[1]);
					let targetZ = rg[1][1];
					if (targetZ > 4) {
						let az = 0;
						let fail = false;
						for (let idx = 2, rgl = rg.length; idx < rgl; idx++) {
							az += rg[idx][1];
							if (az >= targetZ) {
								fail = true;
								break;
							}
						}
						if (!fail) {
							const rgA = rg[0][0];
							const rgB = rg[1][0];
							const isDiff = rgB.replace(/\s/g, '') !== rgA.replace(/\s/g, '');
							if (isDiff && rgA === _snippetText(runs[0].text)) {
								if (runs[0] && runs[0].text) runs[0].blockLine = true;
								runs.push({ text: rgB, blockLine: true });
							}
						}
					}
					rg = null;
				}
				TRANSLATE_DEBUG && Promise.resolve(fRes).then((r) => {
					let obj = r;
					console.log(7559, 1, obj)
					return obj;
				}).then(p => {
					let obj = _DEBUG_szz(p)
					console.log(7559, 2, obj)
				});
			}
			snCache.clear();
			return fRes;
		}
		return translate
	}
	let translateFn = null;
	FIX_TRANSCRIPT_SEGMENTS && !isChatRoomURL && (() => {
		const wmx = new WeakMap();
		function fixSegments(ytObj) {
			let a, b;
			let seg = ((a = ytObj.data) == null ? void 0 : a[b = 'searchResultSegments']) || ((a = ytObj.data) == null ? void 0 : a[b = 'initialSegments']) || [];
			if (!seg || !a || !b || typeof (seg || 0) !== 'object' || !Number.isFinite(seg.length * 1)) return;
			translateFn = translateFn || getTranslate();
			let cSeg;
			cSeg = wmx.get(seg);
			if (!cSeg) {
				let vSeg = null;
				try {
					vSeg = translateFn(seg);
				} catch (e) {
				}
				if (seg && typeof seg === 'object' && seg.length >= 1 && vSeg && typeof vSeg === 'object' && vSeg.length >= 1) {
					cSeg = vSeg;
					wmx.set(seg, cSeg);
					wmx.set(cSeg, cSeg);
				}
			}
			if (cSeg && cSeg !== seg) {
				a[b] = cSeg;
			}
		}
		const dfn = Symbol();
		const Object_ = Object;
		Object_[dfn] = Object_.defineProperties;
		let activation = true;
		Object_.defineProperties = function (obj, pds) {
			let segments, get_;
			if (activation && pds && (segments = pds.segments) && (get_ = segments.get)) {
				activation = false;
				segments.get = function () {
					fixSegments(this);
					return get_.call(this);
				};
			}
			return Object_[dfn](obj, pds);
		};
	})();
	let pf31 = new PromiseExternal();
	let __requestAnimationFrame__ = typeof webkitRequestAnimationFrame === 'function' ? window.webkitRequestAnimationFrame.bind(window) : window.requestAnimationFrame.bind(window);
	const baseRAF = (callback) => {
		return p59 ? __requestAnimationFrame__(callback) : __requestAnimationFrame__((hRes) => {
			pf31.then(() => {
				callback(hRes);
			});
		});
	};
	window.requestAnimationFrame = baseRAF;
	const insp = o => o ? (o.polymerController || o.inst || o || 0) : (o || 0);
	const indr = o => insp(o).$ || o.$ || 0;
	const prototypeInherit = (d, b) => {
		const m = Object.getOwnPropertyDescriptors(b);
		for (const p in m) {
			if (!Object.getOwnPropertyDescriptor(d, p)) {
				Object.defineProperty(d, p, m[p]);
			}
		}
	};
	const firstObjectKey = (obj) => {
		for (const key in obj) {
			if (obj.hasOwnProperty(key) && typeof obj[key] === 'object') return key;
		}
		return null;
	};
	function searchNestedObject(obj, predicate, maxDepth = 64) {
		const result = [];
		const visited = new WeakSet();
		function search(obj, depth) {
			visited.add(obj);
			for (const [key, value] of Object.entries(obj)) {
				if (value !== null && typeof value === 'object') {
					if (depth + 1 <= maxDepth && !visited.has(value)) {
						search(value, depth + 1);
					}
				} else if (predicate(value)) {
					result.push([obj, key]);
				}
			}
		}
		typeof (obj || 0) === 'object' && search(obj, 0);
		return result;
	}

	const mWeakRef = typeof WeakRef === 'function' ? (o => o ? new WeakRef(o) : null) : (o => o || null);

	const kRef = (wr => (wr && wr.deref) ? wr.deref() : wr);
	const isIterable = (obj) => (Symbol.iterator in Object_(obj));
	if (typeof Document.prototype.requestStorageAccessFor === 'function') {
		if (DENY_requestStorageAccess) {
			Document.prototype.requestStorageAccessFor = undefined;
			console.log('[yt-js-engine-tamer]', 'requestStorageAccessFor is removed.');
		} else if (DISABLE_IFRAME_requestStorageAccess && window !== top) {
			Document.prototype.requestStorageAccessFor = function () {
				return new Promise((resolve, reject) => {
					reject();
				});
			};
		}
	}
	const traceStack = (stack) => {
		let result = new Set();
		let p = new Set();
		let u = ''
		for (const s of stack.split('\n')) {
			if (s.split(':').length < 3) continue;
			let m = /(([\w-_\.]+):\d+:\d+)[^:\r\n]*/.exec(s);
			if (!m) continue;
			p.add(m[2]);
			if (p.size >= 3) break;
			if (!u) u = m[2];
			else if (p.size === 2 && u && u === m[2]) break;
			result.add(s);
		}
		return [...result].join('\n');
	}
	if (FIX_bind_self_this && !Function.prototype.bind488 && !Function.prototype.bind588) {
		const vmb = 'dtz02'
		const vmc = 'dtz04'
		const vmd = 'dtz08'
		const thisConversionFn = (thisArg) => {
			if (!thisArg) return null;
			const kThis = thisArg[vmb];
			if (kThis) {
				const ref = kThis.ref;
				return (ref ? kRef(ref) : null) || null;
			}
			return thisArg;
		}
		const pFnHandler2 = {
			get(target, prop) {
				if (prop === vmc) return target;
				return Reflect.get(target, prop);
			},
			apply(target, thisArg, argumentsList) {
				thisArg = thisConversionFn(thisArg);
				if (thisArg) return Reflect.apply(target, thisArg, argumentsList);
			}
		}
		const proxySelfHandler = {
			get(target, prop) {
				if (prop === vmb) return target;
				const ref = target.ref;
				const cnt = kRef(ref);
				if (!cnt) return;
				if (typeof cnt[prop] === 'function' && !cnt[prop][vmc] && !cnt[prop][vmb]) {
					if (!cnt[prop][vmd]) cnt[prop][vmd] = new Proxy(cnt[prop], pFnHandler2);
					return cnt[prop][vmd];
				}
				return cnt[prop];
			},
			set(target, prop, value) {
				const cnt = kRef(target.ref);
				if (!cnt) return true;
				if (value && (value[vmc] || value[vmb])) {
					cnt[prop] = value[vmc] || thisConversionFn(value);
					return true;
				}
				cnt[prop] = value;
				return true;
			}
		};
		const weakWrap = (thisArg) => {
			thisArg = thisConversionFn(thisArg);
			if (!thisArg) {
				console.error('thisArg is not found');
				return null;
			}
			return new Proxy({ ref: mWeakRef(thisArg) }, proxySelfHandler);
		}
		if (!window.getComputedStyle533 && typeof window.getComputedStyle === 'function') {
			window.getComputedStyle533 = window.getComputedStyle;
			window.getComputedStyle = function (a, ...args) {
				a = thisConversionFn(a);
				if (a) {
					return getComputedStyle533(a, ...args);
				}
				return null;
			}
		}
		Function._count_bind_00 = 0;
		const patchFn = (fn) => {
			let s = `${fn}`;
			if (s.length < 11 || s.includes('\n')) return false;
			if (s.includes('bind(this')) return true;
			if (s.includes('=this') && /[,\s][a-zA-Z_][a-zA-Z0-9_]*=this[;,]/.test(s)) return true;
			return false;
		}
		Function.prototype.bind488 = Function.prototype.bind;
		Function.prototype.bind = function (thisArg, ...args) {
			if (thisConversionFn(thisArg) !== thisArg) {
				return this.bind488(thisArg, ...args);
			}
			if (thisArg && patchFn(this)) {
				try {
					//
					//
					//
					//
					//
					//
					//
					const f = this;
					const ps = thisArg.__proxySelf0__ || (thisArg.__proxySelf0__ = weakWrap(thisArg));
					if (ps && ps[vmb]) {
						Function._count_bind_00++;
						return f.bind488(ps, ...args)
					}
				} catch (e) {
					console.warn(e)
				}
			}
			return this.bind488(thisArg, ...args);
		}
		Function.prototype.bind588 = 1;
	}
	if (FIX_weakMap_weakRef && !window.WeakMapOriginal && typeof window.WeakMap === 'function' && typeof WeakRef === 'function') {
		const WeakMapOriginal = window.WeakMapOriginal = window.WeakMap;
		const wm6 = new WeakMapOriginal();
		const skipW = new WeakSet();
		window.WeakMap = class WeakMap extends WeakMapOriginal {
			constructor(iterable = undefined) {
				super();
				if (iterable && iterable[Symbol.iterator]) {
					for (const entry of iterable) {
						entry && this.set(entry[0], entry[1]);
					}
				}
			}
			delete(a) {
				if (!this.has(a)) return false;
				super.delete(a);
				return true;
			}
			get(a) {
				const p = super.get(a);
				if (p && typeof p === 'object' && p.deref && !skipW.has(p)) {
					let v = kRef(p);
					if (!v) {
						super.delete(a);
					}
					return v || undefined;
				}
				return p;
			}
			has(a) {
				if (!super.has(a)) return false;
				const p = super.get(a);
				if (p && typeof p === 'object' && p.deref && !skipW.has(p)) {
					if (!kRef(p)) {
						super.delete(a);
						return false;
					}
				}
				return true;
			}
			set(a, b) {
				let wq = b;
				if (b && (typeof b === 'function' || typeof b === 'object')) {
					if (b.deref) {
						skipW.add(b);
						wq = b;
					} else {
						wq = wm6.get(b);
						if (!wq) {
							wq = mWeakRef(b);
							wm6.set(b, wq);
						}
					}
				}
				super.set(a, wq);
				return this;
			}
		}
		Object.defineProperty(window.WeakMap, Symbol.toStringTag, {
			configurable: true,
			enumerable: false,
			value: "WeakMap",
			writable: false
		});
	}
	const isWatchPageURL = (url) => {
		url = url || location;
		return location.pathname === '/watch' || location.pathname.startsWith('/live/')
	};
	const isCustomElementsProvided = typeof customElements !== "undefined" && typeof (customElements || 0).whenDefined === "function";
	const promiseForCustomYtElementsReady = isCustomElementsProvided ? Promise.resolve(0) : new Promise((callback) => {
		const EVENT_KEY_ON_REGISTRY_READY = "ytI-ce-registry-created";
		if (typeof customElements === 'undefined') {
			if (!('__CE_registry' in document)) {
				Object.defineProperty(document, '__CE_registry', {
					get() {
					},
					set(nv) {
						if (typeof nv == 'object') {
							delete this.__CE_registry;
							this.__CE_registry = nv;
							this.dispatchEvent(new CustomEvent(EVENT_KEY_ON_REGISTRY_READY));
						}
						return true;
					},
					enumerable: false,
					configurable: true
				})
			}
			let eventHandler = (evt) => {
				document.removeEventListener(EVENT_KEY_ON_REGISTRY_READY, eventHandler, false);
				const f = callback;
				callback = null;
				eventHandler = null;
				f();
			};
			document.addEventListener(EVENT_KEY_ON_REGISTRY_READY, eventHandler, false);
		} else {
			callback();
		}
	});
	const whenCEDefined = isCustomElementsProvided
		? (nodeName) => customElements.whenDefined(nodeName)
		: (nodeName) => promiseForCustomYtElementsReady.then(() => customElements.whenDefined(nodeName));
	FIX_perfNow && performance.timeOrigin > 9 && (() => {
		if (performance.now23 || performance.now16 || typeof Performance.prototype.now !== 'function') return;
		const f = performance.now23 = Performance.prototype.now;
		let k = 0;
		let u = 0;
		let s = ((performance.timeOrigin % 7) + 1) / 7 - 1e-2 / 7;
		performance.now = performance.now16 = function () {

			const v = typeof (this || 0).now23 === 'function' ? this.now23() + s : f.call(performance) + s;
			if (u + 0.0015 < (u = v)) k = 0;
			else if (k < 0.001428) k += 1e-6 / 7;
			else {

				k = 0;
				s += 1 / 7;
			}
			return v + k;
		}
		let loggerMsg = '';
		if (`${performance.now()}` === `${performance.now()}`) {
			const msg1 = 'performance.now is modified but performance.now() is not strictly increasing.';
			const msg2 = 'performance.now cannot be modified and performance.now() is not strictly increasing.';
			loggerMsg = performance.now !== performance.now16 ? msg1 : msg2;
		}
		loggerMsg && console.warn(loggerMsg);
	})();
	FIX_removeChild && (() => {
		if (typeof Node.prototype.removeChild === 'function' && typeof Node.prototype.removeChild062 !== 'function') {
			const fragD = document.createDocumentFragment();
			Node.prototype.removeChild062 = Node.prototype.removeChild;
			Node.prototype.removeChild = function (child) {
				if (typeof this.__shady_native_removeChild !== 'function' || ((child instanceof Node) && child.parentNode === this)) {
					let ok = false;
					try {
						this.removeChild062(child);
						ok = true;
					} catch (e) {
					}
					if (!ok) {
						try {
							fragD.appendChild(child)
						} catch (e) {
							console.warn(e);
						}
						try {
							child.remove();
						} catch (e) {
							console.warn(e);
						}
					}
				} else if ((child instanceof Element) && child.is === 'tp-yt-paper-tooltip') {
				} else {
					console.warn('[yt-js-engine-tamer] Node is not removed from parent', { parent: this, child: child })
				}
				return child;
			}
		}
	})();
	FIX_VIDEO_PLAYER_MOUSEHOVER_EVENTS && !isChatRoomURL && (() => {
		const [setIntervalX0, clearIntervalX0] = [setInterval, clearInterval];
		let mousemoveFn = null;
		let mousemoveDT = 0;
		let mousemoveCount = 0;
		const cif = () => {
			if (!mousemoveFn) return;
			const ct = Date.now();
			if (mousemoveDT + 1200 > ct) {
				mousemoveFn && mousemoveFn();
			}
			mousemoveFn = null;
		};
		let mousemoveCId = 0;
		let mouseoverFn = null;
		HTMLElement_.prototype.addEventListener4882 = HTMLElement_.prototype.addEventListener;
		HTMLElement_.prototype.addEventListener = function (a, b, c) {
			if (this.id == 'movie_player' && `${a}`.startsWith('mouse') && c === undefined) {
				const bt = `${b}`;
				if (bt.length >= 61 && bt.length <= 71 && bt.startsWith('function(){try{return ') && bt.includes('.apply(this,arguments)}catch(')) {
					b[`__$$${a}$$1926__`] = true;
					this[`__$$${a}$$1937__`] = (this[`__$$${a}$$1937__`] || 0) + 1;
					if (this[`__$$${a}$$1937__`] > 1073741823) this[`__$$${a}$$1937__`] -= 536870911;
					if (!this[`__$$${a}$$1938__`]) {
						this[`__$$${a}$$1938__`] = b;
						if (a === 'mousemove') {
							this.addEventListener4882('mouseenter', (evt) => {
								if (mousemoveCId) return;
								mousemoveCId = setIntervalX0(cif, 380);
							});
							this.addEventListener4882('mouseleave', (evt) => {
								clearIntervalX0(mousemoveCId);
								mousemoveCId = 0;
							});
						}
						this.addEventListener4882(a, (evt) => {
							const evt_ = evt;
							if (!this[`__$$${a}$$1937__`]) return;
							if (!this[`__$$${a}$$1938__`]) return;
							if (a === 'mousemove') {
								mouseoverFn && mouseoverFn();
								if (mousemoveDT + 350 > (mousemoveDT = Date.now())) {
									(++mousemoveCount > 1e9) && (mousemoveCount = 9);
								} else {
									mousemoveCount = 0;
								}
								const f = mousemoveFn = () => {
									if (f !== mousemoveFn) return;
									mousemoveFn = null;
									this[`__$$${a}$$1938__`](evt_);
								};
								if (mousemoveCount <= 1) mousemoveFn();
							} else {
								if (a === 'mouseout' || a === 'mouseleave') {
									mousemoveFn = null;
									mousemoveDT = 0;
									mousemoveCount = 0;
									this[`__$$${a}$$1938__`](evt_);
									mouseoverFn && mouseoverFn();
								} else {
									mousemoveFn = null;
									mousemoveDT = 0;
									mousemoveCount = 0;
									mouseoverFn && mouseoverFn();
									const f = mouseoverFn = () => {
										if (f !== mouseoverFn) return;
										mouseoverFn = null;
										this[`__$$${a}$$1938__`](evt_);
									}
									nextBrowserTick_(mouseoverFn);
								}
							}
						}, c);
						return;
					} else {
						return;
					}
				}
			}
			return this.addEventListener4882(a, b, c)
		}
		HTMLElement_.prototype.removeEventListener4882 = HTMLElement_.prototype.removeEventListener;
		HTMLElement_.prototype.removeEventListener = function (a, b, c) {
			if (this.id == 'movie_player' && `${a}`.startsWith('mouse') && c === undefined) {
				if (b[`__$$${a}$$1926__`]) {
					b[`__$$${a}$$1926__`] = false;
					if (this[`__$$${a}$$1937__`]) this[`__$$${a}$$1937__`] -= 1;
					return;
				}
			}
			return this.removeEventListener4882(a, b, c)
		}
	})();
	FIX_DOM_IF_REPEAT && (() => {

		const s81 = Symbol();
		const s83 = Symbol();
		const s84 = Symbol();
		const s85 = Symbol();
		const s85b = Symbol();
		const s85c = Symbol();
		let renderDebounceTs = null;
		let renderDebouncePromise = null;
		let qp;
		let cme = 0;
		const shadyFlushMO = new MutationObserver(() => {
			if (!renderDebounceTs) return;
			if (renderDebounceTs.size > 0) {
				console.warn('renderDebounceTs.size is incorect', renderDebounceTs.size);
				try {
					Polymer.flush();
					return;
				} catch (e) { }
			}
			renderDebouncePromise && Promise.resolve().then(() => {
				if (renderDebouncePromise) {
					renderDebouncePromise && renderDebouncePromise.resolve();
					renderDebouncePromise = null;
					DEBUG_DBR847 && console.log('__DBR847__ renderDebouncePromise.resolve by MutationObserver')
				}
			});
			window.ShadyDOM && ShadyDOM.flush();
			window.ShadyCSS && window.ShadyCSS.ScopingShim && window.ShadyCSS.ScopingShim.flush();
		});
		if (FIX_DOM_IFREPEAT_RenderDebouncerChange) {
			const observablePromise = (proc, timeoutPromise) => {
				let promise = null;
				return {
					obtain() {
						if (!promise) {
							promise = new Promise(resolve => {
								let mo = null;
								const f = () => {
									let t = proc();
									if (t) {
										mo.disconnect();
										mo.takeRecords();
										mo = null;
										resolve(t);
									}
								}
								mo = new MutationObserver(f);
								mo.observe(document, { subtree: true, childList: true })
								f();
								timeoutPromise && timeoutPromise.then(() => {
									resolve(null)
								});
							});
						}
						return promise
					}
				}
			}
			let p = 0;
			qp = observablePromise(() => {
				if (!(p & 1)) {
					if (window.ShadyDOM && ShadyDOM.flush) {
						p |= 1;
						if (!ShadyDOM.flush847) {
							ShadyDOM.flush847 = ShadyDOM.flush;
							ShadyDOM.flush = function () {
								DEBUG_xx847 && console.log('xx847 ShadyDOM.flush')
								renderDebouncePromise && Promise.resolve().then(() => {
									if (renderDebouncePromise) {
										renderDebouncePromise && renderDebouncePromise.resolve();
										renderDebouncePromise = null;
										DEBUG_DBR847 && console.log('__DBR847__ renderDebouncePromise.resolve by ShadyDOM.flush')
									}
								});
								let r = this.flush847(...arguments);
								if (r) {
									document.documentElement.setAttribute('nw3a24np', (cme = (cme % 511 + 1)));
								}
								return r
							}
						}
					}
				}
				if (!(p & 2)) {
					if (window.ShadyCSS && window.ShadyCSS.ScopingShim && window.ShadyCSS.ScopingShim.flush) {
						p |= 2;
						const ScopingShim = window.ShadyCSS && window.ShadyCSS.ScopingShim;
						if (!ScopingShim.flush848) {
							ScopingShim.flush848 = ScopingShim.flush;
							ScopingShim.flush = function () {
								DEBUG_xx847 && console.log('xx847 ScopingShim.flush')
								renderDebouncePromise && Promise.resolve().then(() => {
									if (renderDebouncePromise) {
										renderDebouncePromise && renderDebouncePromise.resolve();
										renderDebouncePromise = null;
										DEBUG_DBR847 && console.log('__DBR847__ renderDebouncePromise.resolve by ScopingShim.flush')
									}
								});
								return this.flush848(...arguments);
							}
						}
					}
				}
				if (p === 3) {
					p |= 8;
					let r = (window.ShadyDOM && ShadyDOM.flush && ShadyDOM.flush847
						&& window.ShadyCSS && window.ShadyCSS.ScopingShim &&
						window.ShadyCSS.ScopingShim.flush && window.ShadyCSS.ScopingShim.flush848);
					if (r) {
						let w = Set.prototype.add;
						let u = null;
						Set.prototype.add = function () {
							u = this;
							throw new Error();
						}
						try {
							Polymer.enqueueDebouncer()
						} catch (e) { }
						Set.prototype.add = w;
						if (u !== null) {
							renderDebounceTs = u;
							if (DEBUG_renderDebounceTs) {
								renderDebounceTs.add58438 = renderDebounceTs.add;
								renderDebounceTs.add = function () {
									console.log('renderDebounceTs.add')
									console.log(traceStack((new Error()).stack))
									return this.add58438(...arguments)
								}
								renderDebounceTs.delete58438 = renderDebounceTs.delete;
								renderDebounceTs.delete = function () {
									console.log('renderDebounceTs.delete')
									const stack = `${(new Error()).stack}`
									let isCallbackRemoval = false;
									if (stack) {
										let t = stack.replace(/[^\r\n]+renderDebounceTs\.delete[^\r\n]+/, '').replace('://', '');
										const s = t.split(':');
										if (s.length === 3 && +s[1] > 0 && +s[2] > 0) {
											isCallbackRemoval = true;
										}
									}
									if (isCallbackRemoval) {
										return this.delete58438(...arguments)
									}
									console.log(traceStack((new Error()).stack))
									return this.delete58438(...arguments)
								}
							}
							DEBUG_renderDebounceTs && (window.renderDebounceTs = renderDebounceTs);
							console.log('renderDebounceTs', renderDebounceTs, `debug=${DEBUG_renderDebounceTs}`);
						}
					}
					return true;
				}
			})
		}
		Object.defineProperty(Object.prototype, '_lastIf', {
			get() {
				return this[s81];
			},
			set(nv) {
				if (nv === false && this.nodeName === "DOM-IF" && this.__renderDebouncer === null && this[s81] === undefined) {
					nv = null;
					this.__xiWB8__ = 2;
					const cProto = this.__proto__;
					if (cProto && !cProto.__xiWB7__) {
						cProto.__xiWB7__ = 1;
						if (FIX_DOM_IF_TEMPLATE && !cProto.__template && !cProto.__template847) {
							cProto.__template847 = true;
							try {
								Object.defineProperty(cProto, '__template', {
									get() {
										const v = this[s84];
										return (typeof (v || 0) === 'object' && v.deref) ? kRef(v) : v;
									},
									set(nv) {
										if (typeof (nv || 0) === 'object' && !nv.deref) nv = mWeakRef(nv);
										this[s84] = nv;
										return true;
									}
								});
							} catch (e) {
								console.warn(e);
							}
							console.log('FIX_DOM_IF - __template')
						}
						if (FIX_DOM_IF_TEMPLATE && !cProto.__ensureTemplate847 && typeof cProto.__ensureTemplate === 'function' && cProto.__ensureTemplate.length === 0 && this instanceof HTMLElement_ && `${cProto.__ensureTemplate}`.length > 20) {
							cProto.__ensureTemplate847 = cProto.__ensureTemplate;
							cProto.__ensureTemplate = function () {
								if (!(this instanceof HTMLElement_) || arguments.length > 0) return this.__ensureTemplate847(...arguments);
								if (!this.__template) {
									let b;
									if (this._templateInfo) {
										b = this;
									} else {
										if (!this.__templateCollection011__) this.__templateCollection011__ = this.getElementsByTagName('template');
										b = this.__templateCollection011__[0];
										if (!b) {
											if (!this[wk]) this[wk] = mWeakRef(this);
											let a = this[wk];
											let c = new MutationObserver(function () {
												if (!this.__templateCollection011__[0]) throw Error("dom-if requires a <template> child");
												if (c && a) {
													c.disconnect();
													a = kRef(a);
													a && a.__render();
													a && (a.__templateCollection011__ = null);
												}
												c = null;
												a = null;
											});
											c && c.observe(this, {
												childList: !0
											});
											return !1
										} else {
											this.__templateCollection011__ = null;
										}
									}
									this.__template = b
								}
								return !0
							}
							console.log('FIX_DOM_IF - __ensureTemplate')
						}
						console.log('FIX_DOM_IF OK', Object.keys(cProto))
					}
					const f = () => {
						const __observeEffects = this.__observeEffects;
						if (__observeEffects && __observeEffects.if && isIterable(__observeEffects.if)) {
							for (const effect of __observeEffects.if) {
								const info = effect.info;
								if (info && typeof info.method === 'function') {
									if (info.method === this.__debounceRender847 || info.method === this.__debounceRender) {
										info.method = FIX_DOM_IFREPEAT_RenderDebouncerChange_SET_TO_PROPNAME ? '__debounceRender' : this.__debounceRender;
									}
								}
							}
						}
						if (__observeEffects && __observeEffects.restamp && isIterable(__observeEffects.restamp)) {
							for (const effect of __observeEffects.restamp) {
								const info = effect.info;
								if (info && typeof info.method === 'function') {
									if (info.method === this.__debounceRender847 || info.method === this.__debounceRender) {
										info.method = FIX_DOM_IFREPEAT_RenderDebouncerChange_SET_TO_PROPNAME ? '__debounceRender' : this.__debounceRender;
									}
								}
							}
						}
					}
					if (FIX_DOM_IFREPEAT_RenderDebouncerChange) {
						f();
						Promise.resolve().then(f);
					}
				}
				this[s81] = nv;
				return true;
			}
		});
		Object.defineProperty(Object.prototype, '__renderDebouncer', {
			get() {
				return this[s85];
			},
			set(nv) {
				if (nv === null && this[s85] === undefined) {
					const cProto = this.__proto__;
					if (qp) {
						qp.obtain();
						qp = null;
						shadyFlushMO.observe(document.documentElement, { attributes: ['nw3a24np'] });
					}
					if (FIX_DOM_IFREPEAT_RenderDebouncerChange && !cProto.__debounceRender847 && typeof cProto.__debounceRender === 'function' && !(`${cProto.__debounceRender}`.includes("{}"))) {
						cProto.__debounceRender847 = cProto.__debounceRender;
						if (cProto.__debounceRender.length === 2) {
							cProto.__debounceRender = function (a, b) {
								if (!renderDebounceTs) return this.__debounceRender847(a, b);
								b = b === void 0 ? 0 : b;

								this.__DBR848__ = this.__DBR848__ || `${Math.floor(Math.random() * 314159265359 + 314159265359).toString(36)}`;
								if (!renderDebouncePromise) {
									renderDebouncePromise = new PromiseExternal();
									document.documentElement.setAttribute('nw3a24np', (cme = (cme % 511 + 1)));
								}
								renderDebouncePromise.then(async () => {
									if (b > 0) await delayPn(b);
									const f = this.__dsIRYqw1__;
									if (f === cme) return;
									this.__dsIRYqw1__ = cme;
									a.call(this);
									DEBUG_DBR847 && console.log(`__DBR847__ done 01 (delay=${b})`, this.__DBR848__)
								});
								DEBUG_DBR847 && console.log(`__DBR847__ add 01 (delay=${b})`, this.__DBR848__)
							}
						} else if (cProto.__debounceRender.length === 0) {
							cProto.__debounceRender = function () {
								if (!renderDebounceTs) return this.__debounceRender847();
								this.__DBR848__ = this.__DBR848__ || `${Math.floor(Math.random() * 314159265359 + 314159265359).toString(36)}`;

								if (!renderDebouncePromise) {
									renderDebouncePromise = new PromiseExternal();
									document.documentElement.setAttribute('nw3a24np', (cme = (cme % 511 + 1)));
								}
								renderDebouncePromise.then(() => {
									const f = this.__dsIRYqw1__;
									if (f === cme) return;
									this.__dsIRYqw1__ = cme;
									this.__render()
									DEBUG_DBR847 && console.log('__DBR847__ done 02', this.__DBR848__)
								});
								DEBUG_DBR847 && console.log('__DBR847__ add 02', this.__DBR848__)
							}
						}
					}
				}
				this[s85] = nv;
				return true;
			}
		});
		Object.defineProperty(Object.prototype, 'JSC$10034_renderDebouncer', {
			get() {
				return this[s85b];
			},
			set(nv) {
				this[s85b] = nv;
				return true;
			}
		})
		Object.defineProperty(Object.prototype, 'JSC$10027_renderDebouncer', {
			get() {
				return this[s85c];
			},
			set(nv) {
				this[s85c] = nv;
				return true;
			}
		})
	})();
	const setupXdeadC = (cnt) => {
		let xdeadc = xdeadc00;
		if (!xdeadc) {
			setupSDomWrapper();
			const hostElement = cnt.hostElement;
			const el = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
			hostElement.insertAdjacentHTML('beforeend', ttpHTML('<!---->'));
			hostElement.lastChild.replaceWith(el);
			el.insertAdjacentHTML('afterbegin', ttpHTML(`<div></div>`));
			const rid = `xdead_${Math.floor(Math.random() * 314159265359 + 314159265359).toString(36)}`;
			el.firstElementChild.id = rid;
			cnt.$[rid] = el.firstElementChild;
			cnt.stampDomArray9682_(null, rid, null, false, false, false);
			xdeadc = cnt.getStampContainer_(rid);
			el.remove();
			xdeadc00 = xdeadc;
		}
		let xlivec = xlivec00;
		if (!xlivec) {
			setupSDomWrapper();
			const hostElement = cnt.hostElement;
			const el = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
			hostElement.insertAdjacentHTML('beforeend', ttpHTML('<!---->'));
			hostElement.lastChild.replaceWith(el);
			el.insertAdjacentHTML('afterbegin', ttpHTML(`<div></div>`));
			const rid = `xlive_${Math.floor(Math.random() * 314159265359 + 314159265359).toString(36)}`;
			el.firstElementChild.id = rid;
			cnt.$[rid] = el.firstElementChild;
			cnt.stampDomArray9682_(null, rid, null, false, false, false);
			xlivec = cnt.getStampContainer_(rid);
			xlivec00 = xlivec;
		}
		return xdeadc00;
	}
	let standardWrap_ = null;
	const setupSDomWrapper = () => {
		const sdwProto = ShadyDOM.Wrapper.prototype;
		if (sdwProto.__pseudo__isConnected__ !== null) {
			sdwProto.__pseudo__isConnected__ = null;
			const isConnectedPd = Object.getOwnPropertyDescriptor(sdwProto, 'isConnected');
			if (isConnectedPd && isConnectedPd.get && isConnectedPd.configurable === true) {
				const get = isConnectedPd.get;
				isConnectedPd.get = function () {
					const pseudoVal = this.__pseudo__isConnected__;
					return typeof pseudoVal === 'boolean' ? pseudoVal : get.call(this);
				}
				Object.defineProperty(sdwProto, 'isConnected', { ...isConnectedPd });
			}
		}
	}
	let domApiConstructor = null;
	const setupDomApi = (daProto) => {
		daProto.__daHook377__ = true;
		domApiConstructor = daProto.constructor;
	}
	MODIFY_ShadyDOM_OBJ && ((WeakRef) => {
		const setupPlainShadyDOM = (b) => {
			(OMIT_ShadyDOM_settings & 1) && (b.inUse === true) && (b.inUse = false);
			(OMIT_ShadyDOM_settings & 2) && (b.handlesDynamicScoping === true) && (b.handlesDynamicScoping = false);
			(OMIT_ShadyDOM_settings & 4) && (b.force === true) && (b.force = false);
			b.patchOnDemand = true;
			b.preferPerformance = true;
			b.noPatch = true;
		}
		const isPlainObject = (b, m) => {
			if (!b || typeof b !== 'object') return false;
			const e = Object.getOwnPropertyDescriptors(b);
			if (e.length <= m) return false;
			let pr = 0;
			for (const k in e) {
				const d = e[k];
				if (!d || d.get || d.set || !d.enumerable || !d.configurable) return false;
				if (!('value' in d) || typeof d.value === 'function') return false;
				pr++;
			}
			return pr > m;
		}
		let b;
		let lz = 0;
		const sdp = Object.getOwnPropertyDescriptor(window, 'ShadyDOM');
		if (sdp && sdp.configurable && sdp.value && sdp.enumerable && sdp.writable) {
			b = sdp.value;
			if (b && typeof b === 'object' && isPlainObject(b, 0)) {
				OMIT_ShadyDOM_EXPERIMENTAL && setupPlainShadyDOM(b);
				lz = 1;
			}
		}
		if (sdp && sdp.configurable && sdp.value && sdp.enumerable && sdp.writable && !sdp.get && !sdp.set) {
		} else if (!sdp) {
		} else {
			console.log(3719, '[yt-js-engine-tamer] FIX::ShadyDOM is not applied [ PropertyDescriptor issue ]', sdp);
			return;
		}
		const shadyDOMNodeWRM = new WeakMap();
		console.log(3719, '[yt-js-engine-tamer] FIX::ShadyDOM << 01 >>', b);
		const weakWrapperNodeHandlerFn = () => ({
			get() {
				const wv = this[wk];
				if (typeof wv === 'undefined') return undefined;
				let node = kRef(wv);
				if (!node) this[wk] = undefined;
				return node || undefined;
			},
			set(nv) {
				const wv = nv ? (nv[wk] || (nv[wk] = mWeakRef(nv))) : nv;
				this[wk] = wv;
				return true;
			},
			enumerable: true,
			configurable: true
		});
		function weakWrapper(_ShadyDOM) {
			const ShadyDOM = _ShadyDOM;
			if (WEAKREF_ShadyDOM && lz < 3 && typeof WeakRef === 'function' && typeof ShadyDOM.Wrapper === 'function' && ShadyDOM.Wrapper.length === 1 && typeof (ShadyDOM.Wrapper.prototype || 0) === 'object') {
				let nullElement = { node: null };
				Object.setPrototypeOf(nullElement, Element.prototype);
				let p = new ShadyDOM.Wrapper(nullElement);
				let d = Object.getOwnPropertyDescriptor(p, 'node');
				if (d.configurable && d.enumerable && !d.get && !d.set && d.writable && d.value === nullElement && !Object.getOwnPropertyDescriptor(ShadyDOM.Wrapper.prototype, 'node')) {
					Object.defineProperty(ShadyDOM.Wrapper.prototype, 'node', weakWrapperNodeHandlerFn());
					console.log('[yt-js-engine-tamer] FIX::ShadyDOM << WEAKREF_ShadyDOM >>')
				}
			}
			if (typeof (((ShadyDOM || 0).Wrapper || 0).prototype || 0) === 'object') {
				try {
					setupSDomWrapper();
				} catch (e) { }
			}
		}
		let previousWrapStore = null;
		const standardWrap = function (a) {
			if (!a) return a;
			if (a instanceof ShadowRoot || a instanceof ShadyDOM.Wrapper) return a;
			if (previousWrapStore) {
				const s = kRef(previousWrapStore.get(a));
				if (s) {
					previousWrapStore.delete(a);
					shadyDOMNodeWRM.set(a, mWeakRef(s));
				}
			}
			let u = kRef(shadyDOMNodeWRM.get(a));
			if (!u) {
				u = new ShadyDOM.Wrapper(a);
				shadyDOMNodeWRM.set(a, mWeakRef(u));
			}
			return u;
		}
		standardWrap_ = standardWrap;
		function setupWrapFunc(_ShadyDOM) {
			const ShadyDOM = _ShadyDOM;
			const wmPD = Object.getOwnPropertyDescriptor(WeakMap.prototype, 'get');
			if (!(wmPD && wmPD.writable && !wmPD.enumerable && wmPD.configurable && wmPD.value && !wmPD.get && !wmPD.set)) {
				return;
			}
			let mm = new Set();
			const pget = wmPD.value;
			WeakMap.prototype.get = function (a) {
				mm.add(this);
				return a;
			}
			try {
				let nullElement = { node: null };
				Object.setPrototypeOf(nullElement, Element.prototype);
				ShadyDOM.wrapIfNeeded(nullElement)
				ShadyDOM.wrap(nullElement)
			} catch (e) { }
			WeakMap.prototype.get = pget;
			if (mm.size !== 1) {
				mm.clear();
				return;
			}
			const p = mm.values().next().value;
			if (!(p instanceof WeakMap)) return;
			previousWrapStore = p;
			if (typeof ShadyDOM.wrap === 'function' && ShadyDOM.wrap.length === 1) {
				ShadyDOM.wrap = function (a) { 0 && console.log(3719, '[yt-js-engine-tamer] (OMIT_ShadyDOM) function call - wrap'); return standardWrap(a) }
			}
			if (typeof ShadyDOM.wrapIfNeeded === 'function' && ShadyDOM.wrapIfNeeded.length === 1) {
				ShadyDOM.wrapIfNeeded = function (a) { console.log(3719, '[yt-js-engine-tamer] (OMIT_ShadyDOM) function call - wrapIfNeeded'); return standardWrap(a) }
			}
		}
		function setupLZ3(nv) {
			const ShadyDOM = nv;
			const ShadyDOMSettings = ShadyDOM.settings;
			if (!(ShadyDOMSettings.inUse === true && ShadyDOM.inUse === true && (ShadyDOMSettings.handlesDynamicScoping || ShadyDOM.handlesDynamicScoping) === true)) {
				console.log(3719, '[yt-js-engine-tamer] OMIT_ShadyDOM is not applied [02]', window.ShadyDOM);
				return false;
			}
			weakWrapper(ShadyDOM);
			if (OMIT_ShadyDOM_EXPERIMENTAL && lz < 3) {
				setupPlainShadyDOM(ShadyDOMSettings);
				setupPlainShadyDOM(ShadyDOM);
				ShadyDOM.isShadyRoot = function () { console.log(3719, '[yt-js-engine-tamer] (OMIT_ShadyDOM) function call - isShadyRoot'); return false; }
				setupWrapFunc(ShadyDOM);
				ShadyDOM.patchElementProto = function () { console.log(3719, '[yt-js-engine-tamer] (OMIT_ShadyDOM) function call - patchElementProto') }
				ShadyDOM.patch = function () { console.log(3719, '[yt-js-engine-tamer] (OMIT_ShadyDOM) function call - patch') }
				if (OMIT_ShadyDOM_EXPERIMENTAL & 2) {
					ShadyDOM.composedPath = function (e) {
						const t = (e || 0).target || null;
						if (!(t instanceof HTMLElement_)) {
							console.log(3719, '[yt-js-engine-tamer] (OMIT_ShadyDOM&2) composedPath', t)
						}
						return t instanceof HTMLElement_ ? [t] : [];
					};
				}
			}
		}
		function setupLZ6(nv) {
			const ShadyDOM = nv;
			const ShadyDOMSettings = ShadyDOM.settings;
			if (!(ShadyDOMSettings.inUse === true && ShadyDOM.inUse === true && (ShadyDOMSettings.handlesDynamicScoping || ShadyDOM.handlesDynamicScoping) === true)) {
				console.log(3719, '[yt-js-engine-tamer] OMIT_ShadyDOM is not applied [02]', window.ShadyDOM);
				return false;
			}
			weakWrapper(ShadyDOM);
			if (OMIT_ShadyDOM_EXPERIMENTAL && lz < 3) {
				setupPlainShadyDOM(ShadyDOMSettings);
				setupPlainShadyDOM(ShadyDOM);
				setupWrapFunc(ShadyDOM);
			}
		}
		if (b && typeof b.Wrapper === 'function' && typeof b.settings === 'object' && typeof b.wrap === 'function') {
			const nv = b;
			if (setupLZ6(nv) === false) return;
			lz = 6;
			console.log(3719, '[yt-js-engine-tamer] FIX::ShadyDOM << 02b >>', nv)
			return;
		}
		delete window.ShadyDOM;
		Object.defineProperty(window, 'ShadyDOM', {
			get() {
				return b;
			},
			set(nv) {
				let ret = 0;
				try {
					do {
						if (!nv || !nv.settings) {
							if (lz < 1 && nv && typeof nv === 'object' && isPlainObject(nv, 0)) {
								OMIT_ShadyDOM_EXPERIMENTAL && setupPlainShadyDOM(nv);
								lz = 1;
								break;
							} else {
								console.log(3719, '[yt-js-engine-tamer] FIX::ShadyDOM is not applied [nv:null]', nv);
								break;
							}
						}
						const sdp = Object.getOwnPropertyDescriptor(this || {}, 'ShadyDOM');
						if (!(sdp && sdp.configurable && sdp.get && sdp.set)) {
							console.log(3719, '[yt-js-engine-tamer] OMIT_ShadyDOM is not applied [ incorrect PropertyDescriptor ]', nv);
							break;
						}
						if (setupLZ3(nv) === false) break;
						lz = 3;
						console.log(3719, '[yt-js-engine-tamer] FIX::ShadyDOM << 02a >>', nv)
						ret = 1;
					} while (0);
				} catch (e) {
					console.log('[yt-js-engine-tamer] FIX::ShadyDOM << ERROR >>', e)
				}
				if (!ret) b = nv;
				else {
					delete this.ShadyDOM;
					this.ShadyDOM = nv;
				}
				return true;
			},
			enumerable: false,
			configurable: true
		});
	})(typeof WeakRef !== 'undefined' ? WeakRef : function () { });
	if (ENABLE_ASYNC_DISPATCHEVENT) {
		const filter = new Set([
			'yt-action',
			'shown-items-changed',
			'can-show-more-changed', 'collapsed-changed',
			'yt-navigate', 'yt-navigate-start', 'yt-navigate-cache',
			'yt-player-updated', 'yt-page-data-fetched', 'yt-page-type-changed', 'yt-page-data-updated',
			'yt-navigate-finish',
		])
		EventTarget.prototype.dispatchEvent938 = EventTarget.prototype.dispatchEvent;
		EventTarget.prototype.dispatchEvent = function (event) {
			const type = (event || 0).type;
			if (typeof type === 'string' && event.isTrusted === false && (event instanceof CustomEvent) && event.cancelable === false) {
				if (!filter.has(type) && !type.endsWith('-changed')) {
					if (this instanceof Node || this instanceof Window) {
						nextBrowserTick_(() => this.dispatchEvent938(event));
						return true;
					}
				}
			}
			return this.dispatchEvent938(event);
		}
	}
	SCRIPTLET_REMOVE_PRUNE_propNeedles && (() => {
		const pdOri = Object.getOwnPropertyDescriptor(Map.prototype, 'size');
		if (!pdOri || pdOri.configurable !== true) return;
		let propNeedles = null;
		const pdNew = {
			configurable: true,
			enumerable: true,
			get: function () {
				propNeedles = this;
				if (DEBUG_removePrune) debugger;
				throw new Error();
			}
		}
		Object.defineProperty(Map.prototype, 'size', pdNew);
		try {
			XMLHttpRequest.prototype.open.call(0);
		} catch (e) { }
		Object.defineProperty(Map.prototype, 'size', pdOri);
		if (!propNeedles) return;
		const entries = [...propNeedles.entries()];
		propNeedles.clear();
		console.log('[yt-js-engine-tamer] propNeedles is cleared from scriptlet', entries, propNeedles);
	})();
	if (FIX_XHR_REQUESTING) {
		const URL = window.URL || new Function('return URL')();
		const createObjectURL = URL.createObjectURL.bind(URL);
		XMLHttpRequest = (() => {
			const XMLHttpRequest_ = XMLHttpRequest;
			if ('__xmMc8__' in XMLHttpRequest_.prototype) return XMLHttpRequest_;
			const url0 = createObjectURL(new Blob([], { type: 'text/plain' }));
			const c = class XMLHttpRequest extends XMLHttpRequest_ {
				constructor(...args) {
					super(...args);
				}
				open(method, url, ...args) {
					let skip = false;
					if (!url || typeof url !== 'string') skip = true;
					else if (typeof url === 'string') {
						let turl = url[0] === '/' ? `.youtube.com${url}` : `${url}`;
						if (turl.includes('googleads') || turl.includes('doubleclick.net')) {
							skip = true;
						} else if (turl.includes('.youtube.com/pagead/')) {
							skip = true;
						} else if (turl.includes('.youtube.com/ptracking')) {
							skip = true;
						} else if (turl.includes('.youtube.com/youtubei/v1/log_event?')) {
							skip = true;
						} else if (turl.includes('.youtube.com/api/stats/')) {
							if (turl.includes('.youtube.com/api/stats/qoe?')) {
								skip = true;
							} else if (turl.includes('.youtube.com/api/stats/ads?')) {
								skip = true;
							} else {
							}
						} else if (turl.includes('play.google.com/log')) {
							skip = true;
						} else if (turl.includes('.youtube.com//?')) {
							skip = true;
						}
					}
					if (!skip) {
						this.__xmMc8__ = 1;
						return super.open(method, url, ...args);
					} else {
						this.__xmMc8__ = 2;
						return super.open('GET', url0);
					}
				}
				send(...args) {
					if (this.__xmMc8__ === 1) {
						return super.send(...args);
					} else if (this.__xmMc8__ === 2) {
						return super.send();
					} else {
						console.log('[yt-js-engine-tamer]', 'xhr warning');
						return super.send(...args);
					}
				}
			}
			c.prototype.__xmMc8__ = 0;
			prototypeInherit(c.prototype, XMLHttpRequest_.prototype);
			return c;
		})();
	}
	if (DISABLE_COOLDOWN_SCROLLING && typeof EventTarget.prototype.addEventListener52178 !== 'function' && typeof EventTarget.prototype.addEventListener === 'function') {

		let wheelHandler = function (a) {
			if (window.Polymer && window.Polymer.Element) {
				let c;
				if (c = a.path || a.composedPath && a.composedPath()) {
					for (const e of c) {
						const cnt = insp(e);
						if (e.overscrollConfig) e.overscrollConfig = void 0;
						if (cnt.overscrollConfig) cnt.overscrollConfig = void 0;
					}
				}
			} else {
				let e = a.target;
				for (; e instanceof Element; e = e.parentElement) {
					const cnt = insp(e);
					if (e.overscrollConfig) e.overscrollConfig = void 0;
					if (cnt.overscrollConfig) cnt.overscrollConfig = void 0;
				}
			}
		};
		let checkWheelListenerObjs = null;
		let getObjsFn = () => {
			let euyVal = 0;
			const eukElm = {};
			Object.setPrototypeOf(eukElm, HTMLElement_.prototype);
			const euzObj = new Proxy(eukElm, {
				get(target, prop) {
					throw `ErrorF31.get(${prop})`
				},
				set(target, prop, value) {
					throw `ErrorF33.set(${prop}, ${value})`
				}
			});
			const euxElm = new Proxy(eukElm, {
				get(target, prop) {
					if (prop === 'scrollTop') {
						euyVal = euyVal | 8;
						return 0;
					}
					if (prop === 'overscrollConfig') {
						euyVal = euyVal | 16;
						return void 0;
					}
					if (prop === 'scrollHeight' || prop === 'clientHeight' || prop === 'offsetHeight') {
						return 640;
					}
					if (prop === 'scrollLeft') {
						euyVal = euyVal | 8;
						return 0;
					}
					if (prop === 'scrollWidth' || prop === 'clientWidth' || prop === 'offsetWidth') {
						return 800;
					}
					throw `ErrorF45.get(${prop})`
				},
				set(target, prop, value) {
					throw `ErrorF47.set(${prop}, ${value})`
				}
			});
			const eukEvt = {};
			Object.setPrototypeOf(eukEvt, WheelEvent.prototype);
			const euyEvt = new Proxy(eukEvt, {
				get(target, prop) {
					if (prop === 'deltaY' || prop === 'deltaX') {
						euyVal = euyVal | 1;
						return -999;
					}
					if (prop === 'target') {
						euyVal = euyVal | 2;
						return euxElm
					}
					if (prop === 'path' || prop === 'composedPath') {
						euyVal = euyVal | 2;
						return [euxElm]
					}
					throw `ErrorF51.get(${prop})`
				},
				set(target, prop, value) {
					throw `ErrorF53.set(${prop}, ${value})`
				}
			});
			const setVal = (v) => {
				euyVal = v;
			}
			const getVal = () => {
				return euyVal;
			}
			return { euzObj, euyEvt, setVal, getVal };
		}
		let checkWheelListener = (callback) => {
			let callbackIdentifier = '';
			let res = null;
			try {
				const { euzObj, euyEvt, getVal, setVal } = checkWheelListenerObjs || (checkWheelListenerObjs = getObjsFn());
				setVal(0);
				if (callback.call(euzObj, euyEvt) !== void 0) throw 'ErrorF99';
				throw `RESULT${getVal()}`;
			} catch (e) {
				res = e;
			}
			res = `${res}` || `${null}`;
			if (res.length > 20) res = `${res.substring(0, 20)}...`;
			callbackIdentifier = res;
			if (callbackIdentifier === 'RESULT27') 0;
			else if (callbackIdentifier === 'RESULT0') {
			} else if (callbackIdentifier.startsWith('RESULT')) {
				console.log('wheel eventListener - RESULT', callbackIdentifier, callback)
			}
			return callbackIdentifier;
		};
		let callbackFound = false;
		EventTarget.prototype.addEventListener52178 = EventTarget.prototype.addEventListener;
		EventTarget.prototype.addEventListener = function (type, callback, option = void 0) {
			if (type === 'wheel' && !option && typeof callback === 'function' && callback.length === 1) {
				const callbackIdentifier = callback.yaujmoms || (callbackFound ? 'IGNORE' : (callback.yaujmoms = checkWheelListener(callback)));
				if (callbackIdentifier === 'RESULT27') {
					this.overscrollConfigDisable = true;
					if (!callbackFound) {
						callbackFound = true;
						getObjsFn = checkWheelListener = null;
						checkWheelListenerObjs = null;
						wheelHandler = null;
					}
					return void 0;
				} else if (!callbackFound && !this.overscrollConfigDisable) {
					this.overscrollConfigDisable = true;
					this.addEventListener52178('wheel', wheelHandler, { passive: false });
				}
			}
			return this.addEventListener52178(type, callback, option);
		};
	}
	const { pageMediaWatcher, shortcutKeysFixer, keyboardController } = (() => {
		let p_a_objWR = null;
		let isSpaceKeyImmediate = false;
		let ytPageReady = 0;
		let isSpeedMastSpacebarControlEnabled = false;
		let isGlobalSpaceControl = true;
		let mediaPlayerElementWR = null;
		let focusedElementAtSelection = null;
		let spaceBarControl_keyG = '';
		let lastUserAction = 0;
		const wmKeyControlPhase = new WeakMap();
		let currentSelectionText = null;
		const getCurrentSelectionText = () => {
			if (currentSelectionText !== null) return currentSelectionText
			return (currentSelectionText = `${getSelection()}`)
		}
		const pageMediaWatcher = () => {
			document.addEventListener('yt-navigate', () => {
				ytPageReady = 0;
			});
			document.addEventListener('yt-navigate-start', () => {
				ytPageReady = 0;
			});
			document.addEventListener('yt-navigate-cache', () => {
				ytPageReady = 0;
			});
			document.addEventListener('yt-navigate-finish', () => {
				ytPageReady = 1;
			});
			document.addEventListener('durationchange', () => {
				for (const elm of document.querySelectorAll('#movie_player video[src], #movie_player audio[src]')) {
					if (elm.duration > 0.01) {
						if (elm.closest('[hidden]')) continue;
						mediaPlayerElementWR = mWeakRef(elm);
						return;
					}
				}
			}, { capture: true, passive: true });
			document.addEventListener('selectionchange', (evt) => {
				if (!evt || !evt.isTrusted || !(evt instanceof Event)) return;
				currentSelectionText = null;
				if (!(evt.target instanceof Node)) return;
				focusedElementAtSelection = evt.target;
			}, { capture: true, passive: true })
			document.addEventListener('pointerdown', (evt) => {
				if (evt.isTrusted && evt instanceof Event) lastUserAction = Date.now();
			}, { capture: true, passive: true });
			document.addEventListener('pointerup', (evt) => {
				if (evt.isTrusted && evt instanceof Event) lastUserAction = Date.now();
			}, { capture: true, passive: true });
			document.addEventListener('keydown', (evt) => {
				if (evt.isTrusted && evt instanceof Event) lastUserAction = Date.now();
			}, { capture: true, passive: true });
			document.addEventListener('keyup', (evt) => {
				if (evt.isTrusted && evt instanceof Event) lastUserAction = Date.now();
			}, { capture: true, passive: true });
		};
		const checkKeyB = (p_a_obj) => {
			const boolList = new Set();
			const p_a_obj_api = p_a_obj.api;
			const nilFunc0 = function () {
				return void 0
			};
			const mt = new Proxy({}, {
				get(target, prop) {
					if (prop === 'get') return nilFunc0;
					return mt;
				}
			});
			const nilFunc = function () {
				return mt
			};
			const mw = new Proxy({}, {
				get(target, prop) {
					if (prop in p_a_obj_api) {
						if (typeof p_a_obj_api.constructor.prototype[prop] === 'function') return nilFunc;
						let q = Object.getOwnPropertyDescriptor(p_a_obj_api, prop);
						if (q && q.value) {
							if (!q.writable) return q.value;
							if (typeof q.value === 'string') return '';
							if (typeof q.value === 'number') return 0;
							if (typeof q.value === 'boolean') return false;
							if (q.value && typeof q.value === 'object') return {};
						}
					}
					return undefined;
				},
				set(target, prop) {
					throw 'mwSet';
				}
			});
			const mq = new Proxy({}, {
				get(target, prop) {
					if (prop === 'api') return mw;
					if (prop in p_a_obj) {
						if (typeof p_a_obj.constructor.prototype[prop] === 'function') return nilFunc;
						let q = Object.getOwnPropertyDescriptor(p_a_obj, prop);
						if (q && q.value) {
							if (!q.writable) return q.value;
							if (typeof q.value === 'string') return '';
							if (typeof q.value === 'number') return 0;
							if (typeof q.value === 'boolean') return false;
							if (q.value && typeof q.value === 'object') return {};
						}
					}
					return undefined;
				},
				set(target, prop, val) {
					if (typeof val === 'boolean') boolList.add(prop)
					throw `mqSet(${prop},${val})`;
				}
			});
			let res = ''
			try {
				res = `RESULT::${p_a_obj.handleGlobalKeyUp.call(mq, 9, false, false, false, false, "Tab", "Tab")}`;
			} catch (e) {
				res = `ERROR::${e}`;
			}
			if (boolList.size === 1) {
				const value = boolList.values().next().value;
				if (res === `ERROR::mqSet(${value},${true})`) {
					p_a_obj.__uZWaD__ = value;
				}
			}
			console.log('[yt-js-engine-tamer] global shortcut control', { '__uZWaD__': p_a_obj.__uZWaD__ });
		}
		let pm_p_a = null;
		const p_a_init = function () {
			const r = this.init91();
			const keyBw = this.__cPzfo__ || '__NIL__';
			const p_a_obj = this[keyBw];
			if (!p_a_obj) return;
			try {
				checkKeyB(p_a_obj);
			} catch (e) { }
			p_a_objWR = mWeakRef(p_a_obj);
			if (FIX_SHORTCUTKEYS > 0) {
				if (p_a_obj && !p_a_obj.hVhtg) {
					p_a_obj.hVhtg = 1;
					p_a_obj.handleGlobalKeyUp91 = p_a_obj.handleGlobalKeyUp;
					p_a_obj.handleGlobalKeyUp = p_a_xt.handleGlobalKeyUp;
					p_a_obj.handleGlobalKeyDown91 = p_a_obj.handleGlobalKeyDown;
					p_a_obj.handleGlobalKeyDown = p_a_xt.handleGlobalKeyDown;
					p_a_obj.__handleGlobalKeyBefore__ = p_a_xt.__handleGlobalKeyBefore__;
					p_a_obj.__handleGlobalKeyAfter__ = p_a_xt.__handleGlobalKeyAfter__;
				}
			}
			if (pm_p_a) {
				pm_p_a.resolve();
				pm_p_a = null;
			}
			return r;
		};
		const p_a_xt = {
			__handleGlobalKeyBefore__(a, b, c, d, e, f, h, activeElement) {
				if (FIX_SHORTCUTKEYS === 2) {
					if (activeElement) {
						const controlPhaseCache = wmKeyControlPhase.get(activeElement);
						if (controlPhaseCache === 6 && getCurrentSelectionText() !== "") void 0;
						else if (controlPhaseCache === 1 || controlPhaseCache === 2 || controlPhaseCache === 5) return false;
						else if ((controlPhaseCache !== 6 || focusedElementAtSelection === document.activeElement) && getCurrentSelectionText() !== "") return false;
					}
					const isSpaceBar = a === 32 && b === false && c === false && d === false && e === false && f === ' ' && h === 'Space';
					const isDelayedSpaceBar = FIX_SHORTCUTKEYS === 2 && isSpaceBar && !isSpaceKeyImmediate && (isSpeedMastSpacebarControlEnabled = getSpeedMasterControlFlag());
					if (isDelayedSpaceBar) return void 0;
					if (activeElement && (h === 'Space' || h === 'Enter')) {
						const controlPhase = wmKeyControlPhase.get(activeElement);
						if (controlPhase === 4 || controlPhase === 5) return false;
					}
					if (focusedElementAtSelection === activeElement && getCurrentSelectionText() !== "") return false;
				}
			},
			__handleGlobalKeyAfter__(a, b, c, d, e, f, h, activeElement, ret) {
				if (FIX_SHORTCUTKEYS === 2 && ret && a >= 32 && ytPageReady === 1 && Date.now() - lastUserAction < 40 && activeElement === document.activeElement) {
					const isSpaceBar = a === 32 && b === false && c === false && d === false && e === false && f === ' ' && h === 'Space';
					const isDelayedSpaceBar = FIX_SHORTCUTKEYS === 2 && isSpaceBar && !isSpaceKeyImmediate && (isSpeedMastSpacebarControlEnabled = getSpeedMasterControlFlag());
					if (isDelayedSpaceBar) return void 0;
					const mediaPlayerElement = kRef(mediaPlayerElementWR);
					let mediaWorking = false;
					if (mediaPlayerElement && (mediaPlayerElement.readyState === 4 || mediaPlayerElement.readyState === 1) && mediaPlayerElement.networkState === 2 && mediaPlayerElement.duration > 0.01) {
						mediaWorking = true;
					} else if (mediaPlayerElement && !mediaPlayerElement.paused && !mediaPlayerElement.muted && mediaPlayerElement.duration > 0.01) {
						mediaWorking = true;
					}
					mediaWorking && Promise.resolve().then(() => {
						if (activeElement === document.activeElement) {
							return activeElement.blur()
						} else {
							return false
						}
					}).then((r) => {
						r !== false && mediaPlayerElement.focus();
					});
				}
			},
			handleGlobalKeyUp(a, b, c, d, e, f, h) {
				if (BY_PASS_KEYBOARD_CONTROL) return this.handleGlobalKeyUp91(a, b, c, d, e, f, h);
				const activeElement = document.activeElement;
				const allow = typeof this.__handleGlobalKeyBefore__ === 'function' ? this.__handleGlobalKeyBefore__(a, b, c, d, e, f, h, activeElement) : void 0;
				if (allow === false) return false;
				const ret = this.handleGlobalKeyUp91(a, b, c, d, e, f, h);
				typeof this.__handleGlobalKeyAfter__ === 'function' && this.__handleGlobalKeyAfter__(a, b, c, d, e, f, h, activeElement, ret);
				return ret;
			},
			handleGlobalKeyDown(a, b, c, d, e, f, h, l) {
				if (BY_PASS_KEYBOARD_CONTROL) return this.handleGlobalKeyDown91(a, b, c, d, e, f, h, l);
				const activeElement = document.activeElement;
				const allow = typeof this.__handleGlobalKeyBefore__ === 'function' ? this.__handleGlobalKeyBefore__(a, b, c, d, e, f, h, activeElement) : void 0;
				if (allow === false) return false;
				const ret = this.handleGlobalKeyDown91(a, b, c, d, e, f, h, l);
				typeof this.__handleGlobalKeyAfter__ === 'function' && this.__handleGlobalKeyAfter__(a, b, c, d, e, f, h, activeElement, ret);
				return ret;
			}
		};
		let flagSpeedMaster = null;
		const getSpeedMasterControlFlag = () => {
			const config = (win.yt || 0).config_ || (win.ytcfg || 0).data_ || 0;
			isSpeedMastSpacebarControlEnabled = false;
			if (config && config.EXPERIMENT_FLAGS && config.EXPERIMENT_FLAGS.web_speedmaster_spacebar_control) {
				isSpeedMastSpacebarControlEnabled = true;
			}
			if (config && config.EXPERIMENTS_FORCED_FLAGS && config.EXPERIMENTS_FORCED_FLAGS.web_speedmaster_spacebar_control) {
				isSpeedMastSpacebarControlEnabled = true;
			}
			if (flagSpeedMaster === null) {
				const p = (((config || 0).WEB_PLAYER_CONTEXT_CONFIGS || 0).WEB_PLAYER_CONTEXT_CONFIG_ID_KEVLAR_WATCH || 0).serializedExperimentFlags;
				if (!p) {
					flagSpeedMaster = false;
				} else {
					flagSpeedMaster = (p.includes('web_enable_speedmaster=true') && p.includes('web_speedmaster_spacebar_control=true') && p.includes('web_speedmaster_updated_edu=true'));
				}
			}
			if (!flagSpeedMaster) isSpeedMastSpacebarControlEnabled = false;
			return isSpeedMastSpacebarControlEnabled;
		}
		const getGlobalSpacebarControlFlag = () => {
			const config = (win.yt || 0).config_ || (win.ytcfg || 0).data_ || 0;
			isGlobalSpaceControl = false;
			if (config && config.EXPERIMENT_FLAGS && config.EXPERIMENT_FLAGS.global_spacebar_pause) {
				isGlobalSpaceControl = true;
			}
			if (config && config.EXPERIMENTS_FORCED_FLAGS && config.EXPERIMENTS_FORCED_FLAGS.global_spacebar_pause) {
				isGlobalSpaceControl = true;
			}
			return isGlobalSpaceControl;
		}
		const keyboardController = async (_yt_player) => {
			const keyQT = getQT(_yt_player);
			const keySV = getSV(_yt_player);
			const keyDX = getDX(_yt_player);
			console.log(`[QT,SV,DX]`, [keyQT, keySV, keyDX]);
			if (!keyDX) return;
			if (keyDX === keyQT || keyDX === keySV) return;
			if (typeof keyDX !== 'string') return;
			let lastAccessKey = '';
			let lastAccessKeyConfirmed = '';
			const mb = new Proxy({}, {
				get(target, prop) {
					if (prop === 'handleGlobalKeyUp') lastAccessKeyConfirmed = lastAccessKey;
					throw 'mbGet'
				},
				set(target, prop, val) {
					throw 'mbSet'
				}
			});
			const ma = new Proxy({}, {
				get(target, prop) {
					lastAccessKey = prop;
					return mb
				},
				set(target, prop, val) {
					throw 'maSet'
				}
			});
			let keyBw = '';
			try {
				_yt_player[keyDX].prototype.handleGlobalKeyUp.call(ma);
			} catch (e) {
				if (e === 'mbGet' && typeof lastAccessKeyConfirmed === 'string' && lastAccessKeyConfirmed.length > 0) {
					keyBw = lastAccessKeyConfirmed;
				}
			}
			if (!keyBw) return;
			if (typeof _yt_player[keyDX].prototype.init !== 'function' || _yt_player[keyDX].prototype.init.length !== 0) return;
			pm_p_a = new PromiseExternal();
			_yt_player[keyDX].prototype.__cPzfo__ = keyBw;
			_yt_player[keyDX].prototype.init91 = _yt_player[keyDX].prototype.init;
			_yt_player[keyDX].prototype.init = p_a_init;
			await pm_p_a.then();
			const p_a_obj = kRef(p_a_objWR);
			const isSpeedMastSpacebarControlEnabledA = getSpeedMasterControlFlag();
			if (CHANGE_SPEEDMASTER_SPACEBAR_CONTROL > 0) {
				isSpeedMastSpacebarControlEnabled = CHANGE_SPEEDMASTER_SPACEBAR_CONTROL == 1;
				if (!isSpeedMastSpacebarControlEnabled) {
					if (config && config.EXPERIMENT_FLAGS) {
						config.EXPERIMENT_FLAGS.web_speedmaster_spacebar_control = false;
					}
					if (config && config.EXPERIMENTS_FORCED_FLAGS) {
						config.EXPERIMENTS_FORCED_FLAGS.web_speedmaster_spacebar_control = false;
					}
				} else {
					if (config && config.EXPERIMENT_FLAGS) {
						config.EXPERIMENT_FLAGS.web_speedmaster_spacebar_control = true;
					}
					if (config && config.EXPERIMENTS_FORCED_FLAGS) {
						config.EXPERIMENTS_FORCED_FLAGS.web_speedmaster_spacebar_control = true;
					}
				}
			}
			const isSpeedMastSpacebarControlEnabledB = getSpeedMasterControlFlag();
			console.log('[yt-js-engine-tamer] speedmaster by space (yt setting)', isSpeedMastSpacebarControlEnabledA, isSpeedMastSpacebarControlEnabledB);
			console.log('[yt-js-engine-tamer] p_a', p_a_obj);


		};
		const ytResumeFn = function () {
			const p_a_obj = kRef(p_a_objWR);
			let boolList = null;
			let ret;
			isSpaceKeyImmediate = true;
			try {
				ret = 0;
				ret = ret | (p_a_obj.handleGlobalKeyDown(32, false, false, false, false, ' ', 'Space', false) ? 1 : 0);
				let p_a_objT;
				if (!spaceBarControl_keyG) {
					boolList = new Set();
					p_a_objT = new Proxy(p_a_obj, {
						get(target, prop, handler) {
							const val = target[prop];
							if (typeof val !== 'boolean') return val;
							boolList.add(prop);
							if (typeof prop === 'string' && prop.length <= 3 && val === true && boolList.length === 1) {
								spaceBarControl_keyG = prop;
								p_a_obj.__uZWaD__ = spaceBarControl_keyG;
								val = false;
							}
							return val;
						}
					});
				} else if (p_a_obj[spaceBarControl_keyG] === true) {
					p_a_obj[spaceBarControl_keyG] = false;
					p_a_objT = p_a_obj;
				} else {
					p_a_objT = p_a_obj;
				}
				ret = ret | (p_a_objT.handleGlobalKeyUp(32, false, false, false, false, ' ', 'Space') ? 2 : 0);
			} catch (e) {
				console.log(e)
			}
			isSpaceKeyImmediate = false;
			if (boolList && boolList.size === 1) {
				const value = boolList.values().next().value;
				spaceBarControl_keyG = value;
				p_a_obj.__uZWaD__ = spaceBarControl_keyG;
			}
			if (spaceBarControl_keyG && p_a_obj[spaceBarControl_keyG] === true) p_a_obj[spaceBarControl_keyG] = false;
			return ret;
		}
		const shortcutKeysFixer = () => {
			let pausePromiseControlJ = 0;
			const obtainCurrentControlPhase = (evt, mediaPlayerElement) => {
				let controlPhase = 0;
				const aElm = document.activeElement;
				if (aElm) {
					const controlPhaseCache = wmKeyControlPhase.get(aElm);
					if (typeof controlPhaseCache === 'number') {
						controlPhase = controlPhaseCache;
					} else {
						if (aElm instanceof HTMLInputElement) controlPhase = 1;
						else if (aElm instanceof HTMLTextAreaElement) controlPhase = 1;
						else if (aElm instanceof HTMLButtonElement) controlPhase = 2;
						else if (aElm instanceof HTMLIFrameElement) controlPhase = 2;
						else if (aElm instanceof HTMLImageElement) controlPhase = 2;
						else if (aElm instanceof HTMLEmbedElement) controlPhase = 2;
						else {
							if (aElm instanceof HTMLElement_ && aElm.closest('[role]')) controlPhase = 5;
							if (aElm instanceof HTMLDivElement) controlPhase = 2;
							else if (aElm instanceof HTMLAnchorElement) controlPhase = 2;
							else if (!(aElm instanceof HTMLElement_) && (aElm instanceof Element)) controlPhase = 2;
						}
						if ((controlPhase === 2 || controlPhase === 5) && (aElm instanceof HTMLElement_) && aElm.contains(mediaPlayerElement)) {
							controlPhase = 0;
						}
						if ((controlPhase === 2 || controlPhase === 5) && evt && evt.target && evt.target === aElm) {
							if (aElm.closest('[contenteditable], input, textarea')) {
								controlPhase = 5;
							} else if (aElm.closest('button')) {
								controlPhase = 4;
							}
						}
						if (aElm.closest('#movie_player')) controlPhase = 6;
						wmKeyControlPhase.set(aElm, controlPhase);
					}
				}
				return controlPhase;
			}
			const isStateControllable = (api) => {
				let appState = null;
				let playerState = null;
				let adState = null;
				try {
					appState = api.getAppState();
					playerState = api.getPlayerState();
					adState = api.getAdState();
				} catch (e) { }
				return appState === 5 && adState === -1 && (playerState === 1 || playerState === 2 || playerState === 3);
			};
			const keyEventListener = (evt) => {
				if (BY_PASS_KEYBOARD_CONTROL) return;
				if (evt.isTrusted && evt instanceof Event) lastUserAction = Date.now();
				if (isSpaceKeyImmediate || !evt.isTrusted || !(evt instanceof KeyboardEvent)) return;
				if (!ytPageReady) return;
				if (evt.defaultPrevented === true) return;
				const p_a_obj = kRef(p_a_objWR);
				if (!p_a_obj) return;
				const mediaPlayerElement = kRef(mediaPlayerElementWR);
				if (!mediaPlayerElement) return;
				const controlPhase = obtainCurrentControlPhase(evt, mediaPlayerElement);
				if (controlPhase === 6 && getCurrentSelectionText() !== "") void 0;
				else if (controlPhase === 1 || controlPhase === 2 || controlPhase === 5) return;
				else if ((controlPhase !== 6 || focusedElementAtSelection === document.activeElement) && getCurrentSelectionText() !== "") return;
				if (evt.code === 'Space' && !getGlobalSpacebarControlFlag()) return;
				spaceBarControl_keyG = spaceBarControl_keyG || p_a_obj.__uZWaD__ || ''
				if (spaceBarControl_keyG && p_a_obj[spaceBarControl_keyG] === true) p_a_obj[spaceBarControl_keyG] = false;
				if (FIX_SHORTCUTKEYS < 2) return;
				if (!(!evt.shiftKey && !evt.ctrlKey && !evt.altKey && !evt.metaKey)) return;
				let rr;
				const isSpaceBar = evt.code === 'Space' && !evt.shiftKey && !evt.ctrlKey && !evt.altKey && !evt.metaKey;
				let useImprovedPauseResume = false;
				if (USE_IMPROVED_PAUSERESUME_UNDER_NO_SPEEDMASTER && isSpaceBar && !(isSpeedMastSpacebarControlEnabled = getSpeedMasterControlFlag())) {
					const api = p_a_obj.api;
					const stateControllable = isStateControllable(api);
					if (stateControllable && isWatchPageURL() && mediaPlayerElement.duration > 0.01 && (mediaPlayerElement.readyState === 4 || mediaPlayerElement.readyState === 1) && mediaPlayerElement.networkState === 2) {
						useImprovedPauseResume = true;
					}
				}
				if (evt.type === 'keydown') {
					if (useImprovedPauseResume) {
						const isPaused = mediaPlayerElement.paused;
						const cj = ++pausePromiseControlJ;
						Promise.resolve().then(() => {
							if (cj !== pausePromiseControlJ) return;
							if (mediaPlayerElement.paused !== isPaused) return;
							const ret = ytResumeFn();
							if (!ret) {
								isPaused ? api.playVideo() : api.pauseVideo();
							}

						});
						rr = true;
					} else {
						isSpaceKeyImmediate = true;
						rr = p_a_obj.handleGlobalKeyDown(evt.keyCode, evt.shiftKey, evt.ctrlKey, evt.altKey, evt.metaKey, evt.key, evt.code, evt.repeat);
						isSpaceKeyImmediate = false;
						if (spaceBarControl_keyG && p_a_obj[spaceBarControl_keyG] === true) p_a_obj[spaceBarControl_keyG] = false;
					}
				} else if (evt.type === 'keyup') {
					if (isSpaceBar && useImprovedPauseResume && !(isSpeedMastSpacebarControlEnabled = getSpeedMasterControlFlag())) {
						rr = true;
					} else {
						isSpaceKeyImmediate = true;
						rr = p_a_obj.handleGlobalKeyUp(evt.keyCode, evt.shiftKey, evt.ctrlKey, evt.altKey, evt.metaKey, evt.key, evt.code);
						isSpaceKeyImmediate = false;
						if (spaceBarControl_keyG && p_a_obj[spaceBarControl_keyG] === true) p_a_obj[spaceBarControl_keyG] = false;
					}

				}
				if (rr) {
					evt.preventDefault();
					evt.stopImmediatePropagation();
					evt.stopPropagation();
				}
			};
			document.addEventListener('keydown', keyEventListener, { capture: true });
			document.addEventListener('keyup', keyEventListener, { capture: true });
		}
		return { pageMediaWatcher, shortcutKeysFixer, keyboardController };
	})();
	pageMediaWatcher();
	FIX_SHORTCUTKEYS > 0 && shortcutKeysFixer();
	const check_for_set_key_order = (() => {
		let mySet = new Set();
		mySet.add("value1");
		mySet.add("value2");
		mySet.add("value3");
		function getSetValues(set) {
			return Array.from(set.values());
		}
		function testSetOrder(set, expectedOrder) {
			let values = getSetValues(set);
			return expectedOrder.join(',') === values.join(',');
		}
		if (mySet.values().next().value !== "value1") return false;
		if (!testSetOrder(mySet, ["value1", "value2", "value3"])) return false;
		mySet.delete("value2");
		if (mySet.values().next().value !== "value1") return false;
		if (!testSetOrder(mySet, ["value1", "value3"])) return false;
		mySet.add("value2");
		if (mySet.values().next().value !== "value1") return false;
		if (!testSetOrder(mySet, ["value1", "value3", "value2"])) return false;
		mySet.add("value4");
		if (mySet.values().next().value !== "value1") return false;
		if (!testSetOrder(mySet, ["value1", "value3", "value2", "value4"])) return false;
		mySet.delete("value1");
		mySet.delete("value3");
		mySet.add("value3");
		mySet.add("value1");
		if (mySet.values().next().value !== "value2") return false;
		if (!testSetOrder(mySet, ["value2", "value4", "value3", "value1"])) return false;
		return true;
	})();
	const qm57 = Symbol();
	const qm53 = Symbol();
	const qn53 = Symbol();
	const ump3 = new WeakMap();
	const stp = document.createElement('noscript');
	stp.id = 'weakref-placeholder';
	PROP_OverReInclusion_AVOID && (() => {
		if (typeof HTMLElement_.prototype.hasOwnProperty72 === 'function' || typeof HTMLElement_.prototype.hasOwnProperty !== 'function') return;
		const f = HTMLElement_.prototype.hasOwnProperty72 = HTMLElement_.prototype.hasOwnProperty;
		let byPassVal = null;
		let byPassCount = 0;
		let mmw = new Set();
		HTMLElement_.prototype.hasOwnProperty = function (prop) {
			if (arguments.length !== 1) return f.apply(this, arguments);
			if (byPassVal !== null && typeof prop === 'string') {
				if (PROP_OverReInclusion_LIST.has(prop)) {
					byPassCount++;
					return byPassVal;
				}
				PROP_OverReInclusion_DEBUGLOG && mmw.add(prop);
			}
			return this.hasOwnProperty72(prop);
		};

		let byPassZeroShowed = false;
		const forwardDynamicPropsGeneral = function () {
			byPassVal = true;
			byPassCount = 0;
			PROP_OverReInclusion_DEBUGLOG && mmw.clear();
			const ret = this.forwardDynamicProps72();
			byPassVal = null;
			if (byPassCount === 0 && !byPassZeroShowed) {
				byPassZeroShowed = true;
				console.log('[yt-js-engine-tamer] byPassCount = 0 in forwardDynamicProps')
			}
			byPassCount = 0;
			if (PROP_OverReInclusion_DEBUGLOG && mmw.size > 0) {
				console.log(399, '[yt-js-engine-tamer]', [...mmw]);
				mmw.clear();
			}
			return ret;
		};
		const propCheck = (proto) => {
			if (typeof (proto || 0) == 'object' && typeof proto.forwardDynamicProps === 'function' && typeof proto.forwardDynamicProps72 !== 'function') {
				proto.forwardDynamicProps72 = proto.forwardDynamicProps;
				if (proto.forwardDynamicProps.length === 0) {
					proto.forwardDynamicProps = forwardDynamicPropsGeneral;
				}
			}
		};
		const valMap = new WeakMap();
		Object.defineProperty(HTMLElement_.prototype, 'didForwardDynamicProps', {
			get() {
				propCheck(this.constructor.prototype);
				return valMap.get(this);
			},
			set(nv) {
				propCheck(this.constructor.prototype);
				valMap.set(this, nv);
				return true;
			},
			enumerable: false,
			configurable: true
		});
		promiseForCustomYtElementsReady.then(() => {
			if (typeof customElements !== 'object' || typeof customElements.define72 === 'function' || typeof customElements.define !== 'function') return;
			if (customElements.define.length !== 2) return;
			customElements.define72 = customElements.define;
			customElements.define = function (b, w) {
				propCheck(w.prototype);
				const ret = this.define72(b, w);
				return ret;
			}
		});
	})();
	let marcoPr = new PromiseExternal();
	const trackMarcoCm = document.createComment('1');
	const trackMarcoCmObs = new MutationObserver(() => {
		marcoPr.resolve();
		marcoPr = new PromiseExternal();
	});
	trackMarcoCmObs.observe(trackMarcoCm, { characterData: true });
	const nativeNow = performance.constructor.prototype.now.bind(performance);
	const queueMicrotask_ = typeof queueMicrotask === 'function' ? queueMicrotask : (f) => (Promise.resolve().then(f), void 0);
	FIX_ICON_RENDER && whenCEDefined('yt-icon').then(async () => {
		dummy = document.createElement('yt-icon');
		let cProto;
		if (!(dummy instanceof Element)) return;
		cProto = insp(dummy).constructor.prototype;
		cProto.handlePropertyChange671 = cProto.handlePropertyChange;
		cProto.determineIconSet671 = cProto.determineIconSet;
		cProto.switchToYtSysIconset671 = cProto.switchToYtSysIconset;
		cProto.useYtSysIconsetForMissingIcons671 = cProto.useYtSysIconsetForMissingIcons;
		cProto.getIconManager671 = cProto.getIconManager;
		cProto.getIconShapeData671 = cProto.getIconShapeData;
		cProto.renderIcon671 = cProto.renderIcon;
		if (cProto.__renderIconFix__) return;
		cProto.__renderIconFix__ = true;
		let taskStack = [];
		const cmObs = new MutationObserver(() => {
			const tasks = taskStack.slice();
			taskStack.length = 0;
			for (const task of tasks) {
				task();
			}
		})
		const cm = document.createComment('1');
		const stackTask = (f) => {
			taskStack.push(f);
			cm.data = `${(cm.data & 7) + 1}`;
		}
		cmObs.observe(cm, { characterData: true });
		const setupYtIcon = (inst) => {
			if (inst.__ytIconSetup588__) return;
			const cProto = Reflect.getPrototypeOf(inst);
			cProto.__ytIconSetup588__ = true;
			const config = (win.yt || 0).config_ || (win.ytcfg || 0).data_ || 0;
			config.EXPERIMENT_FLAGS.wil_icon_render_when_idle = false;
			config.EXPERIMENT_FLAGS.wil_icon_load_immediately = true;
			config.EXPERIMENT_FLAGS.wil_icon_network_first = true;
		}
		cProto.handlePropertyChange = function (...a) {
			if (!this.__ytIconSetup588__) setupYtIcon(this);
			this.__resolved__ = {
			};
			const a01 = this.isAttached;
			let a02, a03;
			const t = this.__stackedKey3818__ = (this.__stackedKey3818__ & 1073741823) + 1;
			const stackFn = () => {
				if (t !== this.__stackedKey3818__) {
					return;
				}
				a03 = this.isAttached;
				if (a01 === false && a02 === false && a03 === false) return;
				if (a01 === true && a02 === true && a03 === true) {
				} else {
					if (a01 === undefined && a02 === undefined && a03 === undefined && (this.hostElement || this).isConnected === false) {
						return;
					} else {
						console.log('[yt-icon] debug', a01, a02, a03, this)
					}
				}
				this.handlePropertyChange671(...arguments);
			};
			Promise.resolve().then(() => {
				a02 = this.isAttached;
				stackTask(stackFn);
			});
		}
		cProto.determineIconSet = function (a, b, c, d) {
			if (!this.__ytIconSetup588__) setupYtIcon(this);
			const r = this.determineIconSet671(...arguments);
			return r;
		}
		cProto.switchToYtSysIconset = function (a, b, c, d) {
			if (!this.__ytIconSetup588__) setupYtIcon(this);
			return this.switchToYtSysIconset671(...arguments);
		}
		cProto.useYtSysIconsetForMissingIcons = function (a, b, c, d) {
			if (!this.__ytIconSetup588__) setupYtIcon(this);
			return this.useYtSysIconsetForMissingIcons671(...arguments);
		}
		cProto.getIconManager = function () {
			if (!this.__ytIconSetup588__) setupYtIcon(this);
			if (!this.__resolved__) this.__resolved__ = {};
			if (!this.__resolved__.getIconManager) this.__resolved__.getIconManager = this.getIconManager671(...arguments);
			const r = this.__resolved__.getIconManager;
			return r;
		}
		cProto.getIconShapeData = function () {
			if (!this.__ytIconSetup588__) setupYtIcon(this);
			if (!this.__resolved__) this.__resolved__ = {};
			if (!this.__resolved__.getIconShapeData) this.__resolved__.getIconShapeData = this.getIconShapeData671(...arguments);
			const r = this.__resolved__.getIconShapeData;
			return r
		}
		cProto.renderIcon = function (a, b) {
			if (!this.__ytIconSetup588__) setupYtIcon(this);
			return this.renderIcon671(...arguments);
		}
	});
	const createStampDomFnsB_ = () => {
		const config = ((win.yt || 0).config_ || (win.ytcfg || 0).data_ || 0);
		if (config.DEFERRED_DETACH === true) config.DEFERRED_DETACH = false;
		if (config.REUSE_COMPONENTS === true) config.REUSE_COMPONENTS = false;
		const rq0 = document.createElement('rp');
		rq0.setAttribute('yt-element-placholder', '');
		let activeStampContainerId = '';
		const componentBasedTaskPool = new WeakMap();
		Node.prototype.checkFF = function () {
			const pTask = componentBasedTaskPool.get(this);
			if (!pTask) return null;
			return [pTask, taskList.filter(e => e.taskId === pTask.taskId), taskList.filter(e => e.componentWr === this[wk])];
		}
		Node.prototype.checkGG = function () {
			const pTask = componentBasedTaskPool.get(this);
			if (!pTask) return null;
			window.me848 = pTask.taskId;
			debugger;
			loopTask();
		}
		NodeList.prototype.last = function () {
			return this[this.length - 1];
		}
		const getStampContainer_ = function (containerId) {
			this.__activeContainerId929__ = containerId;
			return this.getStampContainer7409_(containerId);
		}
		const it0 = Date.now() - 80000000000;
		const genId = () => `${Math.floor(Math.random() * 314159265359 + 314159265359).toString(36)}_${(Date.now() - it0).toString(36)}`;
		const createComponent_ = function (componentConfig, data, canReuse) {
			this.___lastCreate3311__ = data;
			if (this.__directProduction533__) {
				const cName = this.getComponentName_(componentConfig, data);
				return document.createElement(cName);
			}
			if (this.__byPass828__ || !this.__byPass348__) {
				return this.createComponent7409_(componentConfig, data, false);
			}
			const containerId = this.__activeContainerId929__;
			const r = rq0.cloneNode(false);
			r.is = 'aa-bb-cc-dd';
			return r;
		}
		const childrenObs = new MutationObserver((mutations) => {
			loopTask();
		});
		const taskList = [];
		let taskCounter = 0;
		const taskPush = (component, pTask0, pTask1) => {
			component = kRef(component);
			if (!component) return;
			if (!pTask0) pTask0 = pTask1; else Object.assign(pTask0, pTask1);
			componentBasedTaskPool.set(component, pTask0);
			const id = taskCounter = (taskCounter & 1073741823) + 1;
			pTask0.taskId = id;
			taskList.push({
				taskId: id,
				componentWr: component[wk]
			})
			return pTask0;
		}
		const domComment_ = document.createComment('y');
		const triggerDomChange = (node) => {
			node.appendChild(domComment_).remove();
		}
		const performTask = (component, pTask = undefined) => {
			if (pTask === undefined) pTask = componentBasedTaskPool.get(component);
			if (!pTask || !component) return;
			let { step, producer, containerId, typeOrConfig, data, flushing, selfProducer } = pTask;
			producer = kRef(producer);
			selfProducer = kRef(selfProducer);
			const resolveSelf = () => {
				const node = component;
				node.removeAttribute('ytx-flushing');
				if (selfProducer && flushing && flushing.length > 0 && selfProducer.hostElement) {
					const node = component;
					let shouldMarkDirty = false;
					const m = new Set();
					const producer = selfProducer;
					for (const [containerId, bEvent, hasData] of flushing) {
						if (hasData) {
							shouldMarkDirty = true;
							if (bEvent) {
								const container = producer.getStampContainer7409_(containerId);
								m.add(container);
							}
						}
					}
					flushing.length = 0;
					if (shouldMarkDirty) {
						producer.markDirty && producer.markDirty();
						let q = true;
						for (const container of m) {
							if (!q) producer.markDirty && producer.markDirty();
							q = false;
							dispatchYtEvent(producer.hostElement, "yt-rendererstamper-finished", {
								container
							});
						}
					}
				}
				const s = new Set();
				const parentComponent = node.closest('[ytx-flushing]');
				if (parentComponent && componentBasedTaskPool.has(parentComponent) && parentComponent[wk] && !parentComponent.querySelector('[ytx-flushing]')) {
					if (!s.has(parentComponent[wk])) {
						s.add(parentComponent[wk]);
					}
				}
				const producerElement = producer ? producer.hostElement : null;
				if (parentComponent && parentComponent !== producerElement) {
					const parentComponent = producerElement;
					if (parentComponent && componentBasedTaskPool.has(parentComponent) && parentComponent[wk] && !parentComponent.querySelector('[ytx-flushing]')) {
						if (!s.has(parentComponent[wk])) {
							s.add(parentComponent[wk])
						}
					}
				}
				for (const p of s) {
					const node = kRef(p);
					triggerDomChange(node);
				}
				if (!node.hasAttribute('ytx-flushing') && (!pTask.flushing || !pTask.flushing.length) && !pTask.typeOrConfig && !pTask.data) {
					componentBasedTaskPool.delete(node);
				}
				return [...s];
			}
			if (pTask.step === 'creation') {
				if (flushing) debugger;
				if (!producer || !typeOrConfig) return;
				if (component.parentNode && component.parentNode.id === containerId && component.parentNode === producer.getStampContainer7409_(containerId)) {
					pTask.step = 'flushStamper'; pTask.pq33 = 3;
					const pTaskId = pTask.taskId;
					const cName = producer.getComponentName_(typeOrConfig, data);
					const aNode = document.createElement(cName);
					const qNode = component;
					aNode.setAttribute('ytx-stamp', 'flusher');
					aNode.setAttribute('ytx-flushing', '2')
					componentBasedTaskPool.delete(qNode);
					componentBasedTaskPool.set(aNode, pTask);
					if (!aNode[wk]) aNode[wk] = mWeakRef(aNode);
					const container = component.parentNode;
					const containerApi = container.__domApi || container;
					const frag = document.createDocumentFragment();
					frag.appendChild(aNode);
					containerApi.insertBefore(frag, qNode);
					containerApi.removeChild(qNode);
					const pTaskN = componentBasedTaskPool.get(aNode);
					const pTaskNId = pTaskN.taskId;
					if (pTaskNId === pTaskId) {
						for (const task of taskList) {
							if (task.taskId === pTaskId) {
								task.componentWr = aNode[wk];
								break;
							}
						}
					}
					return true;
				}
			} else if (pTask.step === 'flushStamper') {
				if (flushing) debugger;
				if (!producer || !typeOrConfig) return;
				pTask.step = 'flushStamperWait';
				pTask.typeOrConfig = null;
				pTask.data = null;
				const node = component;
				node.setAttribute('ytx-flushing', '3');
				let taskB = { component: component, typeOrConfig: typeOrConfig, data: data };
				producer.deferredBindingTasks_.push(taskB);
				producer.flushRenderStamperComponentBindings7409_();
				return true;
			} else if (pTask.step === 'flushStamperWait') {
				if (flushing) debugger;
				if (!producer) return;
				const node = component;
				if (!node.querySelector('[ytx-flushing]')) {
					pTask.step = 'idleContainer';
					return resolveSelf();
				}
			} else if (pTask.step === 'mightFlushAndWaitContainersRenderFinish') {
				if (producer && typeOrConfig) {
					pTask.typeOrConfig = null;
					pTask.data = null;
					const node = component;
					node.setAttribute('ytx-flushing', '3');
					let taskB = { component: component, typeOrConfig: typeOrConfig, data: data };
					producer.deferredBindingTasks_.push(taskB);
					producer.flushRenderStamperComponentBindings7409_();
					return true;
				}
				const node = component;
				if (!node.querySelector('[ytx-flushing]')) {
					pTask.step = 'idleProducer';
					return resolveSelf();
				}
			}
		}
		let isLooping = false;
		const loopTask = () => {
			if (isLooping) return;
			isLooping = true;
			let i = 0, t0 = 0;
			const taskExec = () => {
				if (!t0) {
					t0 = nativeNow();
				}
				for (let j; (j = i++) < taskList.length;) {
					const task = taskList[j];
					const taskComponent = kRef(task.componentWr);
					if (taskComponent) {
						const pTask = componentBasedTaskPool.get(taskComponent);
						if (pTask) {
							if (pTask.taskId === task.taskId && task.taskId > 0 && pTask.taskId > 0) {
								if (pTask.taskId === window.me848) debugger;
								let shouldPerformTask = false;
								if (pTask.step === 'creation' && pTask.typeOrConfig) {
									shouldPerformTask = true;
								} else if (pTask.step === 'flushStamper' && pTask.typeOrConfig) {
									shouldPerformTask = true;
								} else if (pTask.step === 'flushStamperWait' && !taskComponent.querySelector('[ytx-flushing]')) {
									shouldPerformTask = true;
								} else if (pTask.step === 'mightFlushAndWaitContainersRenderFinish' && (pTask.typeOrConfig || !taskComponent.querySelector('[ytx-flushing]'))) {
									shouldPerformTask = true;
								}
								let b = shouldPerformTask && taskComponent.parentNode;
								if (b) {
									const result = performTask(taskComponent, pTask);
									if (result === true) i--;
									else if (result instanceof Array) {
										if (result.length >= 1) {
											const eSet = new Set(result);
											for (let k = 0, c = i; k < c; k++) {
												const task = taskList[k];
												const componentWr = task ? task.componentWr : null;
												if (componentWr && eSet.has(componentWr)) {
													i = k;
													break;
												}
											}
										}
									}
									if (nativeNow() - t0 > 10) {
										t0 = 0;
										nextBrowserTick_(taskExec);
									} else {
										queueMicrotask_(taskExec);
									}
									return;
								}
							}
						}
					}
				}
				if (taskList.length > 0) {
					let u = 0;
					for (let k = 0, l = taskList.length; k < l; k++) {
						let clear = true;
						const task = taskList[k];
						const taskComponent = kRef(task.componentWr);
						if (taskComponent) {
							const pTask = componentBasedTaskPool.get(taskComponent);
							if (pTask && (pTask.taskId === task.taskId || pTask.taskId === -1)) {
								clear = false;
							}
						}
						if (clear) continue;
						taskList[u++] = taskList[k];
					}
					taskList.length = u;
				}
				isLooping = false;
			};
			queueMicrotask_(taskExec);
		};
		const deferRenderStamperBinding_ = function (component, typeOrConfig, data) {
			const isLastCreate = this.___lastCreate3311__ === data;
			this.___lastCreate3311__ = -0.125;
			const containerId = this.__activeContainerId929__;
			if (!component[wk]) component[wk] = mWeakRef(component);
			if (!this[wk]) this[wk] = mWeakRef(this);
			const pTask = componentBasedTaskPool.get(component);
			const isSelfProducer = (pTask && pTask.selfProducer && pTask.flushing);
			const abandonUnreadySubtree = () => {
				for (const e of component.querySelectorAll('[ytx-flushing]')) {
					const pTask = componentBasedTaskPool.get(e);
					if (pTask) {
						pTask.step = 'abandon';
						pTask.taskId = 0;
						if (pTask.flushing) pTask.flushing.length = 0;
						pTask.flushing = null;
						pTask.typeOrConfig = null
						pTask.data = null
						componentBasedTaskPool.delete(e);
					}
					e.removeAttribute('ytx-flushing');
					if (e.nodeName === 'RP') e.remove();
				}
			}
			const flushNow = () => {
				const pTaskNew = taskPush(component, pTask, {
					step: isSelfProducer ? 'mightFlushAndWaitContainersRenderFinish' : 'flushStamper',
					producer: this[wk],
					containerId: containerId,
					typeOrConfig: typeOrConfig,
					data: data,
					pq33: 7
				});
				const pTaskId = pTaskNew.taskId;
				queueMicrotask_(() => {
					if (pTaskId !== pTaskNew.taskId) return;
					performTask(component);
				});
				loopTask();
			};
			if (!isLastCreate) {
				abandonUnreadySubtree();
				flushNow();
				return;
			} else {
				if (pTask) pTask.taskId = 0;
			}
			if (this.__byPass828__ || !this.__byPass348__) {
				return this.deferRenderStamperBinding7409_(component, typeOrConfig, data);
			}
			if (pTask && pTask.step !== 'creation') {
				if (!component.hasAttribute('ytx-flushing')) component.setAttribute('ytx-flushing', '2c');
				abandonUnreadySubtree();
				flushNow();
				return;
			} else {
				if (component.nodeName === "RP") {
					component.setAttribute('ytx-stamp', 'flusher');
					component.setAttribute('ytx-flushing', '1');
					taskPush(component, pTask, {
						step: 'creation',
						producer: this[wk],
						containerId: containerId,
						typeOrConfig: typeOrConfig,
						data: data
					});
					loopTask();
				} else {
					const aNode = component;
					if (!aNode[wk]) aNode[wk] = mWeakRef(aNode);
					aNode.setAttribute('ytx-stamp', 'flusher');
					aNode.setAttribute('ytx-flushing', '2');
					flushNow();
				}
			}
		}
		flushRenderStamperComponentBindings_ = function () {
			if (this.__byPass828__ || !this.__byPass348__) {
				return this.flushRenderStamperComponentBindings7409_();
			}
			throw new Error('5ii48')
		}
		const directComponentList = new Set([
			"YTD-STRUCTURED-DESCRIPTION-CONTENT-RENDERER",
			"YTD-VIDEO-DESCRIPTION-HEADER-RENDERER",
			"YTD-ENGAGEMENT-PANEL-SECTION-LIST-RENDERER",
		]);
		let kf33;
		let kf3b = 0;
		stampDomArraySplices_ = function (stampKey, containerId, indexSplicesObj) {
			const producer = this;
			const hostElement = producer.hostElement;
			let kf = false;
			const kf3t = nativeNow();
			const kf34 = Math.floor((kf3t - kf3b) / 8);
			if (!kf33 || kf34 !== kf33) {
				kf33 = kf34;
				kf3b = kf3t - kf34 * 8;
				kf = true;
			}
			const container = this.getStampContainer7409_(containerId);
			if (container && !container.__rk75401__) {
				container.__rk75401__ = true;
				childrenObs.observe(container, { subtree: false, childList: true });
			}
			if (kf) this.__directProduction533__ = true;
			else if (!this.isAttached) this.__directProduction533__ = true;
			else if (this.onYtRendererstamperFinished && this.updateChildVisibilityProperties) this.__directProduction533__ = true;
			else if (hostElement && directComponentList.has(hostElement.nodeName)) this.__directProduction533__ = true;
			else if (hostElement && hostElement.closest('ytd-engagement-panel-section-list-renderer, [hidden], defs, noscript')) this.__directProduction533__ = true;
			else this.__directProduction533__ = false;
			const bEventCb = this.stampDom[stampKey].events;
			this.__activeContainerId929__ = containerId;
			if (!this[wk]) this[wk] = mWeakRef(this);
			if (!hostElement[wk]) hostElement[wk] = mWeakRef(hostElement);
			if (hostElement.getAttribute('ytx-stamp') === 'flusher') {
				hostElement.setAttribute('ytx-stamp', 'flusher|producer');
			} else if (!hostElement.hasAttribute('ytx-stamp')) {
				hostElement.setAttribute('ytx-stamp', 'producer');
			}
			const pTask = componentBasedTaskPool.get(hostElement);
			const flushing = pTask ? (pTask.flushing || []) : [];
			flushing.push([containerId, bEventCb, null]);
			hostElement.setAttribute('ytx-flushing', 's-1');
			if (pTask) {
				pTask.taskId = -1;
			}
			if (hostElement && !hostElement.__rk75401__) {
				hostElement.__rk75401__ = true;
				childrenObs.observe(hostElement, { subtree: false, childList: true });
			}
			let r, e_
			try {
				this.__byPass348__ = true;
				this.stampDomArraySplices7409_(stampKey, containerId, indexSplicesObj);
			} catch (e) {
				e_ = e;
			}
			this.__byPass348__ = false;
			taskPush(hostElement, pTask, {
				step: 'mightFlushAndWaitContainersRenderFinish',
				selfProducer: this[wk],
				flushing
			});
			loopTask();
			triggerDomChange(container);
			triggerDomChange(hostElement);
			if (e_ && e_.message !== '5ii48') throw e_;
		}
		stampDomArray_ = function (dataList, containerId, typeOrConfig, bReuse, bEventCb, bStableList) {
			const producer = this;
			const hostElement = producer.hostElement;
			let kf = false;
			const kf3t = nativeNow();
			const kf34 = Math.floor((kf3t - kf3b) / 8);
			if (!kf33 || kf34 !== kf33) {
				kf33 = kf34;
				kf3b = kf3t - kf34 * 8;
				kf = true;
			}
			const container = this.getStampContainer7409_(containerId);
			if (container && !container.__rk75401__) {
				container.__rk75401__ = true;
				childrenObs.observe(container, { subtree: false, childList: true });
			}
			if (kf) this.__directProduction533__ = true;
			else if (!this.isAttached) this.__directProduction533__ = true;
			else if (this.onYtRendererstamperFinished && this.updateChildVisibilityProperties) this.__directProduction533__ = true;
			else if (hostElement && directComponentList.has(hostElement.nodeName)) this.__directProduction533__ = true;
			else if (hostElement && hostElement.closest('ytd-engagement-panel-section-list-renderer, [hidden], defs, noscript')) this.__directProduction533__ = true;
			else this.__directProduction533__ = false;
			bReuse = false;
			this.__activeContainerId929__ = containerId;
			if (!this[wk]) this[wk] = mWeakRef(this);
			if (!hostElement[wk]) hostElement[wk] = mWeakRef(hostElement);
			if (hostElement.getAttribute('ytx-stamp') === 'flusher') {
				hostElement.setAttribute('ytx-stamp', 'flusher|producer');
			} else if (!hostElement.hasAttribute('ytx-stamp')) {
				hostElement.setAttribute('ytx-stamp', 'producer');
			}
			const pTask = componentBasedTaskPool.get(hostElement);
			const flushing = pTask ? (pTask.flushing || []) : [];
			flushing.push([containerId, bEventCb, !!dataList]);
			hostElement.setAttribute('ytx-flushing', 's-1');
			if (pTask) {
				pTask.taskId = -1;
			}
			if (hostElement && !hostElement.__rk75401__) {
				hostElement.__rk75401__ = true;
				childrenObs.observe(hostElement, { subtree: false, childList: true });
			}
			let r, e_
			try {
				this.__byPass348__ = true;
				this.stampDomArray7409_(dataList, containerId, typeOrConfig, bReuse, bEventCb, bStableList);
			} catch (e) {
				e_ = e;
			}
			this.__byPass348__ = false;
			taskPush(hostElement, pTask, {
				step: 'mightFlushAndWaitContainersRenderFinish',
				selfProducer: this[wk],
				flushing
			});
			loopTask();
			triggerDomChange(container);
			triggerDomChange(hostElement);
			if (e_ && e_.message !== '5ii48') throw e_;
		}
		return { getStampContainer_, createComponent_, deferRenderStamperBinding_, flushRenderStamperComponentBindings_, stampDomArray_, stampDomArraySplices_ };
	}
	const setupDiscreteTasks = (h, rb) => {
		if (typeof h.onYtRendererstamperFinished === 'function' && !(h.onYtRendererstamperFinished.km34)) {
			const f = h.onYtRendererstamperFinished;
			const g = ump3.get(f) || function () {
				if (this.updateChildVisibilityProperties && !this.markDirty) {
					return f.apply(this, arguments);
				}
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onYtRendererstamperFinished = g;
		}
		if (typeof h.onYtUpdateDescriptionAction === 'function' && !(h.onYtUpdateDescriptionAction.km34)) {
			const f = h.onYtUpdateDescriptionAction;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onYtUpdateDescriptionAction = g;
		}
		if (typeof h.handleUpdateDescriptionAction === 'function' && !(h.handleUpdateDescriptionAction.km34)) {
			const f = h.handleUpdateDescriptionAction;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.handleUpdateDescriptionAction = g;
		}
		if (typeof h.handleUpdateLiveChatPollAction === 'function' && !(h.handleUpdateLiveChatPollAction.km34)) {
			const f = h.handleUpdateLiveChatPollAction;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.handleUpdateLiveChatPollAction = g;
		}
		if (typeof h.onTextChanged === 'function' && !(h.onTextChanged.km34)) {
			const f = h.onTextChanged;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onTextChanged = g;
		}
		if (typeof h.onVideoDataChange === 'function' && !(h.onVideoDataChange.km34)) {
			const f = h.onVideoDataChange;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onVideoDataChange = g;
		}
		if (typeof h.onVideoDataChange_ === 'function' && !(h.onVideoDataChange_.km34)) {
			const f = h.onVideoDataChange_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onVideoDataChange_ = g;
		}
		if (typeof h.addTooltips_ === 'function' && !(h.addTooltips_.km34)) {
			const f = h.addTooltips_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.addTooltips_ = g;
		}
		if (typeof h.updateRenderedElements === 'function' && !(h.updateRenderedElements.km34)) {
			const f = h.updateRenderedElements;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.updateRenderedElements = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 2) && typeof h.loadPage_ === 'function' && !(h.loadPage_.km34)) {
			const f = h.loadPage_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.loadPage_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 2) && typeof h.updatePageData_ === 'function' && !(h.updatePageData_.km34)) {
			const f = h.updatePageData_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.updatePageData_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.onFocus_ === 'function' && !(h.onFocus_.km34)) {
			const f = h.onFocus_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onFocus_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.onBlur_ === 'function' && !(h.onBlur_.km34)) {
			const f = h.onBlur_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onBlur_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.buttonClassChanged_ === 'function' && !(h.buttonClassChanged_.km34)) {
			const f = h.buttonClassChanged_;
			const g = ump3.get(f) || function (a, b) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.buttonClassChanged_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.buttonIconChanged_ === 'function' && !(h.buttonIconChanged_.km34)) {
			const f = h.buttonIconChanged_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.buttonIconChanged_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.dataChangedInBehavior_ === 'function' && !(h.dataChangedInBehavior_.km34)) {
			const f = h.dataChangedInBehavior_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.dataChangedInBehavior_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.continuationsChanged_ === 'function' && !(h.continuationsChanged_.km34)) {
			const f = h.continuationsChanged_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.continuationsChanged_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.forceChatPoll_ === 'function' && !(h.forceChatPoll_.km34)) {
			const f = h.forceChatPoll_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.forceChatPoll_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.onEndpointClick_ === 'function' && !(h.onEndpointClick_.km34)) {
			const f = h.onEndpointClick_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onEndpointClick_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.onEndpointTap_ === 'function' && !(h.onEndpointTap_.km34)) {
			const f = h.onEndpointTap_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onEndpointTap_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.handleClick_ === 'function' && !(h.handleClick_.km34)) {
			const f = h.handleClick_;
			const g = ump3.get(f) || function (a, b) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.handleClick_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.onReadyStateChange_ === 'function' && !(h.onReadyStateChange_.km34)) {
			const f = h.onReadyStateChange_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onReadyStateChange_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.onReadyStateChangeEntryPoint_ === 'function' && !(h.onReadyStateChangeEntryPoint_.km34)) {
			const f = h.onReadyStateChangeEntryPoint_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onReadyStateChangeEntryPoint_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.readyStateChangeHandler_ === 'function' && !(h.readyStateChangeHandler_.km34)) {
			const f = h.readyStateChangeHandler_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.readyStateChangeHandler_ = g;
		}
		if (typeof h.xmlHttpHandler_ === 'function' && !(h.xmlHttpHandler_.km34)) {
			const f = h.xmlHttpHandler_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.xmlHttpHandler_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.executeCallbacks_ === 'function' && !(h.executeCallbacks_.km34)) {
			const f = h.executeCallbacks_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.executeCallbacks_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.handleInvalidationData_ === 'function' && !(h.handleInvalidationData_.km34)) {
			const f = h.handleInvalidationData_;
			const g = ump3.get(f) || function (a, b) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.handleInvalidationData_ = g;
		}
		if (typeof h.onInput_ === 'function' && !(h.onInput_.km34)) {
			const f = h.onInput_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onInput_ = g;
		}
		if (typeof h.trigger_ === 'function' && !(h.trigger_.km34)) {
			const f = h.trigger_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.trigger_ = g;
		}
		if (typeof h.requestData_ === 'function' && !(h.requestData_.km34)) {
			const f = h.requestData_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.requestData_ = g;
		}
		if (typeof h.onLoadReloadContinuation_ === 'function' && !(h.onLoadReloadContinuation_.km34)) {
			const f = h.onLoadReloadContinuation_;
			const g = ump3.get(f) || function (a, b) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onLoadReloadContinuation_ = g;
		}
		if (typeof h.onLoadIncrementalContinuation_ === 'function' && !(h.onLoadIncrementalContinuation_.km34)) {
			const f = h.onLoadIncrementalContinuation_;
			const g = ump3.get(f) || function (a, b) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onLoadIncrementalContinuation_ = g;
		}
		if (typeof h.onLoadSeekContinuation_ === 'function' && !(h.onLoadSeekContinuation_.km34)) {
			const f = h.onLoadSeekContinuation_;
			const g = ump3.get(f) || function (a, b) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onLoadSeekContinuation_ = g;
		}
		if (typeof h.onLoadReplayContinuation_ === 'function' && !(h.onLoadReplayContinuation_.km34)) {
			const f = h.onLoadReplayContinuation_;
			const g = ump3.get(f) || function (a, b) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onLoadReplayContinuation_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.onNavigate_ === 'function' && !(h.onNavigate_.km34)) {
			const f = h.onNavigate_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onNavigate_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.ytRendererBehaviorDataObserver_ === 'function' && !(h.ytRendererBehaviorDataObserver_.km34)) {
			const f = h.ytRendererBehaviorDataObserver_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.ytRendererBehaviorDataObserver_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.ytRendererBehaviorTargetIdObserver_ === 'function' && !(h.ytRendererBehaviorTargetIdObserver_.km34)) {
			const f = h.ytRendererBehaviorTargetIdObserver_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.ytRendererBehaviorTargetIdObserver_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.unregisterRenderer_ === 'function' && !(h.unregisterRenderer_.km34)) {
			const f = h.unregisterRenderer_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.unregisterRenderer_ = g;
		}
		if ((WEAK_REF_BINDING_CONTROL & 1) && typeof h.textChanged_ === 'function' && !(h.textChanged_.km34)) {
			const f = h.textChanged_;
			const g = ump3.get(f) || function (a) {
				if (void 0 !== this.isAttached) {
					const hostElement = this.hostElement;
					if (!(hostElement instanceof Node) || hostElement.nodeName === 'NOSCRIPT') {
						return;
					}
				}
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.textChanged_ = g;
		}

		if (typeof h.searchChanged_ === 'function' && !(h.searchChanged_.km34)) {
			const f = h.searchChanged_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.searchChanged_ = g;
		}
		if (typeof h.skinToneChanged_ === 'function' && !(h.skinToneChanged_.km34)) {
			const f = h.skinToneChanged_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.skinToneChanged_ = g;
		}
		if (typeof h.onEmojiHover_ === 'function' && !(h.onEmojiHover_.km34)) {
			const f = h.onEmojiHover_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onEmojiHover_ = g;
		}
		if (typeof h.onSelectCategory_ === 'function' && !(h.onSelectCategory_.km34)) {
			const f = h.onSelectCategory_;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onSelectCategory_ = g;
		}
		if (typeof h.onShowEmojiVariantSelector === 'function' && !(h.onShowEmojiVariantSelector.km34)) {
			const f = h.onShowEmojiVariantSelector;
			const g = ump3.get(f) || function (a) {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onShowEmojiVariantSelector = g;
		}
		if (typeof h.updateCategoriesAndPlaceholder_ === 'function' && !(h.updateCategoriesAndPlaceholder_.km34)) {
			const f = h.updateCategoriesAndPlaceholder_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.updateCategoriesAndPlaceholder_ = g;
		}
		if (typeof h.watchPageActiveChanged_ === 'function' && !(h.watchPageActiveChanged_.km34)) {
			const f = h.watchPageActiveChanged_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.watchPageActiveChanged_ = g;
		}
		if (typeof h.activate_ === 'function' && !(h.activate_.km34)) {
			const f = h.activate_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.activate_ = g;
		}
		if (typeof h.onYtPlaylistDataUpdated_ === 'function' && !(h.onYtPlaylistDataUpdated_.km34)) {
			const f = h.onYtPlaylistDataUpdated_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onYtPlaylistDataUpdated_ = g;
		}

		if (typeof h.tryRenderChunk_ === 'function' && !(h.tryRenderChunk_.km34)) {
			const f = h.tryRenderChunk_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.tryRenderChunk_ = g;
		}
		if (typeof h.renderChunk_ === 'function' && !(h.renderChunk_.km34)) {
			const f = h.renderChunk_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.renderChunk_ = g;
		}
		if (typeof h.deepLazyListObserver_ === 'function' && !(h.deepLazyListObserver_.km34)) {
			const f = h.deepLazyListObserver_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.deepLazyListObserver_ = g;
		}
		if (typeof h.onItemsUpdated_ === 'function' && !(h.onItemsUpdated_.km34)) {
			const f = h.onItemsUpdated_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.onItemsUpdated_ = g;
		}
		if (typeof h.requestRenderChunk_ === 'function' && !(h.requestRenderChunk_.km34)) {
			const f = h.requestRenderChunk_;
			const g = ump3.get(f) || function () {
				Promise.resolve().then(() => f.apply(this, arguments)).catch(console.log);
			}
			ump3.set(f, g);
			g.km34 = 1;
			h.requestRenderChunk_ = g;
		}

	}
	const keyStConnectedCallback = Symbol();
	const dmf = new WeakMap();
	let nativeHTMLElement = Reflect.getPrototypeOf(HTMLFontElement);
	try {
		const q = document.createElement('template');
		q.innerHTML = '<ytz-null361></ytz-null361>';
		nativeHTMLElement = q.content.firstChild.constructor
	} catch (e) { }
	if (!nativeHTMLElement.prototype.connectedCallback) {
		nativeHTMLElement.prototype.connectedCallback79 = nativeHTMLElement.prototype.connectedCallback;
		nativeHTMLElement.prototype.connectedCallback = function () {
			let r;
			if (this.connectedCallback79) r = this.connectedCallback79.apply(this, arguments);
			return r;
		}
	}
	const pvr = Symbol()
	let stampDomArrayFnStore = null;
	const setupMap = new WeakSet();
	const setupYtComponent = (cnt) => {
		const cProto = Reflect.getPrototypeOf(cnt || 0) || 0;
		if (!cProto || setupMap.has(cProto)) return;
		setupMap.add(cProto);
		if (FIX_stampDomArray && !(cProto[pvr] & 1) && 'stampDomArray_' in cProto) {
			cProto[pvr] |= 1;
			if (FIX_stampDomArray && !location.pathname.startsWith('/live_chat') && cProto.stampDomArray_) {
				const b = cProto.stampDomArray_.length === 6
					&& cProto.getStampContainer_ && cProto.getStampContainer_.length === 1
					&& cProto.createComponent_ && cProto.createComponent_.length === 3
					&& cProto.deferRenderStamperBinding_ && cProto.deferRenderStamperBinding_.length === 3
					&& cProto.flushRenderStamperComponentBindings_ && cProto.flushRenderStamperComponentBindings_.length === 0
					&& cProto.deferRenderStamperBinding_ === cnt.deferRenderStamperBinding_
				if (!b) {
					console.warn("YouTube Coding Changed. createStampDomFns_() is not applied")
				} else if (!cProto.createComponent7409_ && !cProto.deferRenderStamperBinding7409_ && !cProto.flushRenderStamperComponentBindings7409_) {
					if (!stampDomArrayFnStore) stampDomArrayFnStore = createStampDomFnsB_();
					const { getStampContainer_, createComponent_, deferRenderStamperBinding_, flushRenderStamperComponentBindings_, stampDomArray_, stampDomArraySplices_ } = stampDomArrayFnStore;
					cProto.getStampContainer7409_ = cProto.getStampContainer_;
					cProto.createComponent7409_ = cProto.createComponent_;
					cProto.deferRenderStamperBinding7409_ = cProto.deferRenderStamperBinding_;
					cProto.flushRenderStamperComponentBindings7409_ = cProto.flushRenderStamperComponentBindings_;
					cProto.stampDomArray7409_ = cProto.stampDomArray_;
					cProto.stampDomArraySplices7409_ = cProto.stampDomArraySplices_;
					cProto.getStampContainer_ = getStampContainer_;
					cProto.createComponent_ = createComponent_;
					cProto.deferRenderStamperBinding_ = deferRenderStamperBinding_;
					cProto.flushRenderStamperComponentBindings_ = flushRenderStamperComponentBindings_;
					cProto.stampDomArray_ = stampDomArray_;
					cProto.stampDomArraySplices_ = stampDomArraySplices_;
				}
			}
			if (cProto._runEffectsForTemplate && !cProto._runEffectsForTemplate6344) {
				cProto._runEffectsForTemplate6344 = cProto._runEffectsForTemplate;
				if (cProto._runEffectsForTemplate6344.length === 4) {
					cProto._runEffectsForTemplate = function (c, d, e, g) {
						const cnt = this;
						const { propertyEffects, nodeList, firstChild } = c;
						cnt._runEffectsForTemplate6344({ propertyEffects, nodeList, firstChild }, d, e, g);
					}
				}
			}
		}
		if (ENABLE_discreteTasking && !(cProto[pvr] & 2) && (typeof (cProto.is || 0) === 'string' || ('attached' in cProto) || ('isAttached' in cProto))) {
			cProto[pvr] |= 2;
			setupDiscreteTasks(cProto);
		}
	};
	(ENABLE_discreteTasking || FIX_stampDomArray) && Object.defineProperty(Object.prototype, 'connectedCallback', {
		get() {
			const f = this[keyStConnectedCallback];
			if (this.is) {
				setupYtComponent(this);
			}
			return f;
		},
		set(nv) {
			let gv = nv;
			this[keyStConnectedCallback] = gv;
			return true;
		},
		enumerable: false,
		configurable: true
	});
	const pLoad = new Promise(resolve => {
		if (document.readyState !== 'loading') {
			resolve();
		} else {
			window.addEventListener("DOMContentLoaded", resolve, false);
		}
	});
	if (FIX_fix_requestIdleCallback_timing && !window.requestIdleCallback471 && typeof window.requestIdleCallback === 'function') {
		window.requestIdleCallback471 = window.requestIdleCallback;
		window.requestIdleCallback = function (f, ...args) {
			return (this || window).requestIdleCallback471(async function () {
				await pLoad.then();
				f.call(this, ...arguments)
			}, ...args);
		}
	}
	pLoad.then(() => {
		let nonce = document.querySelector('style[nonce]');
		nonce = nonce ? nonce.getAttribute('nonce') : null;
		const st = document.createElement('style');
		if (typeof nonce === 'string') st.setAttribute('nonce', nonce);
		st.textContent = "none-element-k47{order:0}";
		st.addEventListener('load', () => {
			pf31.resolve();
			p59 = 1;
		}, false);
		(document.body || document.head || document.documentElement).appendChild(st);
	});
	const prepareLogs = [];
	const skipAdsDetection = new Set(['/robots.txt', '/live_chat', '/live_chat_replay']);
	let winError00 = window.onerror;
	let fix_error_many_stack_state = !FIX_error_many_stack ? 0 : skipAdsDetection.has(location.pathname) ? 2 : 1;
	if (!JSON || !('parse' in JSON)) fix_error_many_stack_state = 0;
	; FIX_Iframe_NULL_SRC && !isChatRoomURL && typeof kagi === 'undefined' && (() => {
		const emptyBlobUrl = URL.createObjectURL(new Blob([], { type: 'text/html' }));
		const lcOpt = { sensitivity: 'base' };
		document.createElement24 = document.createElement;
		document.createElement = function (t) {
			if (typeof t === 'string' && t.length === 6) {
				if (t.localeCompare('iframe', undefined, lcOpt) === 0) {
					const p = this.createElement24(t);
					try {
						const stack = new Error().stack;
						const isSearchbox = stack.includes('initializeSearchbox');
						if (!isSearchbox) {
							p.src = emptyBlobUrl;
						}
					} catch (e) { }
					return p;
				}
			}
			return this.createElement24.apply(this, arguments);
		};
	})();
	; fix_error_many_stack_state === 1 && (() => {
		let p1 = winError00;
		let stackNeedleDetails = null;
		Object.defineProperty(Object.prototype, 'matchAll', {
			get() {
				stackNeedleDetails = this;
				return true;
			},
			enumerable: true,
			configurable: true
		});
		try {
			JSON.parse("{}");
		} catch (e) {
			console.warn(e)
			fix_error_many_stack_state = 0;
		}
		delete Object.prototype['matchAll'];
		let p2 = window.onerror;
		window.onerror = p1;
		if (fix_error_many_stack_state === 0) return;
		if (stackNeedleDetails) {
			JSON.parse.stackNeedleDetails = stackNeedleDetails;
			stackNeedleDetails.matchAll = true;
		}
		if (p1 === p2) return (fix_error_many_stack_state = 0);
		fix_error_many_stack_state = !stackNeedleDetails ? 4 : 3;
	})();
	; fix_error_many_stack_state === 2 && (() => {
		let p1 = winError00;
		let objectPrune = null;
		let stackNeedleDetails = null;
		Object.defineProperty(Function.prototype, 'findOwner', {
			get() {
				objectPrune = this;
				return this._findOwner;
			},
			set(nv) {
				this._findOwner = nv;
				return true;
			},
			enumerable: true,
			configurable: true
		});
		Object.defineProperty(Object.prototype, 'matchAll', {
			get() {
				stackNeedleDetails = this;
				return true;
			},
			enumerable: true,
			configurable: true
		});
		try {
			JSON.parse("{}");
		} catch (e) {
			console.warn(e)
			fix_error_many_stack_state = 0;
		}
		delete Function.prototype['findOwner'];
		delete Object.prototype['matchAll'];
		let p2 = window.onerror;
		if (p1 !== p2) return (fix_error_many_stack_state = 4);
		if (fix_error_many_stack_state == 0) return;
		prepareLogs.push("fix_error_many_stack_state NB")
		if (stackNeedleDetails) {
			stackNeedleDetails.pattern = null;
			stackNeedleDetails.re = null;
			stackNeedleDetails.expect = null;
			stackNeedleDetails.matchAll = true;
		}
		if (objectPrune) {
			objectPrune.findOwner = objectPrune.mustProcess = objectPrune.logJson = () => { }
			delete objectPrune._findOwner;
		}
		fix_error_many_stack_state = 3;
		JSON.parse.stackNeedleDetails = stackNeedleDetails;
		JSON.parse.objectPrune = objectPrune;
	})();
	; fix_error_many_stack_state === 3 && (() => {
		let p1 = winError00;
		try {
			JSON.parse("{}");
		} catch (e) {
			console.warn(e)
			fix_error_many_stack_state = 0;
		}
		let p2 = window.onerror;
		if (p1 === p2) return;
		window.onerror = p1;
		if (fix_error_many_stack_state === 0) return;
		fix_error_many_stack_state = 4;
	})();
	fix_error_many_stack_state === 4 && (() => {
		prepareLogs.push("fix_error_many_stack_state AB")
		JSON.parseProxy = JSON.parse;
		JSON.parse = ((parse) => {
			parse = parse.bind(JSON);
			return function (text, reviver) {
				const onerror = window.onerror;
				window.onerror = null;
				let r;
				try {
					r = parse(...arguments);
				} catch (e) {
					r = e;
				}
				window.onerror = onerror;
				if (r instanceof Error) {
					throw r;
				}
				return r;
			}
		})(JSON.parse);
	})();
	const PERF_471489_ = true;
	const steppingScaleN = 200;
	const nilFn = () => { };
	let isMainWindow = false;
	try {
		isMainWindow = window.document === window.top.document
	} catch (e) { }
	let NO_PRELOAD_GENERATE_204_BYPASS = NO_PRELOAD_GENERATE_204 ? false : true;
	let headLinkCollection = null;
	const fnIntegrity = (f, d) => {
		if (!f || typeof f !== 'function') {
			console.warn('f is not a function', f);
			return;
		}
		let p = `${f}`, s = 0, j = -1, w = 0;
		for (let i = 0, l = p.length; i < l; i++) {
			const t = p[i];
			if (((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z'))) {
				if (j < i - 1) w++;
				j = i;
			} else {
				s++;
			}
		}
		let itz = `${f.length}.${s}.${w}`;
		if (!d) {
			return itz;
		} else {
			return itz === d;
		}
	};
	const getZqOu = (_yt_player) => {
		const w = 'ZqOu';
		let arr = [];
		for (const [k, v] of Object.entries(_yt_player)) {
			const p = typeof v === 'function' ? v.prototype : 0;
			if (p
				&& typeof p.start === 'function' && p.start.length === 0
				&& typeof p.isActive === 'function' && p.isActive.length === 0
				&& typeof p.stop === 'function' && p.stop.length === 0
				&& !p.isComplete && !p.getStatus && !p.getResponseHeader && !p.getLastError
				&& !p.send && !p.abort
				&& !p.sample && !p.initialize && !p.fail && !p.getName
			) {
				arr = addProtoToArr(_yt_player, k, arr) || arr;
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0];
		}
	}
	const getZqQu = (_yt_player) => {
		const w = 'ZqQu';
		let arr = [];
		for (const [k, v] of Object.entries(_yt_player)) {
			const p = typeof v === 'function' ? v.prototype : 0;
			if (p
				&& typeof p.start === 'function' && p.start.length === 1
				&& typeof p.isActive === 'function' && p.isActive.length === 0
				&& typeof p.stop === 'function' && p.stop.length === 0
				&& !p.isComplete && !p.getStatus && !p.getResponseHeader && !p.getLastError
				&& !p.send && !p.abort
				&& !p.sample && !p.initialize && !p.fail && !p.getName
			) {
				arr = addProtoToArr(_yt_player, k, arr) || arr;
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0];
		}
	}
	const getVG = (_yt_player) => {
		const w = 'VG';
		let arr = [];
		for (const [k, v] of Object.entries(_yt_player)) {
			const p = typeof v === 'function' ? v.prototype : 0;
			if (p
				&& typeof p.show === 'function' && p.show.length === 1
				&& typeof p.hide === 'function' && p.hide.length === 0
				&& typeof p.stop === 'function' && p.stop.length === 0) {
				arr = addProtoToArr(_yt_player, k, arr) || arr;
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0];
		}
	}
	const getzo = (_yt_player) => {
		const w = 'zo';
		let arr = [];
		for (const [k, v] of Object.entries(_yt_player)) {
			if (
				typeof v === 'function' && v.length === 3 && k.length < 3
			) {
				const vt = `${v}`;
				if (vt.length >= 21 && vt.includes(".style[")) {
					if (/\((\w{1,3}),(\w{1,3}),(\w{1,3})\)\{[\s\S]*\1\.style\[\2\]=\3\W/.test(vt)) {
						arr.push(k);
					} else {
						console.warn('[yt-js-engine-tamer] unexpected zo::vt', vt);
					}
				}
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0];
		}
	}
	const addProtoToArr = (parent, key, arr) => {
		let isChildProto = false;
		for (const sr of arr) {
			if (parent[key].prototype instanceof parent[sr]) {
				isChildProto = true;
				break;
			}
		}
		if (isChildProto) return;
		arr = arr.filter(sr => {
			if (parent[sr].prototype instanceof parent[key]) {
				return false;
			}
			return true;
		});
		arr.push(key);
		return arr;
	}
	const getuG = (_yt_player) => {
		const w = 'uG';
		let arr = [];
		for (const [k, v] of Object.entries(_yt_player)) {
			const p = typeof v === 'function' ? v.prototype : 0;
			if (p
				&& typeof p.createElement === 'function' && p.createElement.length === 2
				&& typeof p.detach === 'function' && p.detach.length === 0
				&& typeof p.update === 'function' && p.update.length === 1
				&& typeof p.updateValue === 'function' && p.updateValue.length === 2
			) {
				arr = addProtoToArr(_yt_player, k, arr) || arr;
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0];
		}
	}
	const getQT = (_yt_player) => {
		const w = 'QT';
		let arr = [];
		let brr = new Map();
		for (const [k, v] of Object.entries(_yt_player)) {
			const p = typeof v === 'function' ? v.prototype : 0;
			if (p) {
				let q = 0;
				if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 7) q += 400;
				else if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 8) q += 300;
				else if (typeof p.handleGlobalKeyUp === 'function') q += 200;
				if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 0) q -= 600;
				if (q < 200) continue;
				if (typeof p.handleGlobalKeyDown === 'function' && p.handleGlobalKeyDown.length === 8) q += 80;
				if (typeof p.handleGlobalKeyDown === 'function' && p.handleGlobalKeyDown.length === 7) q += 30;
				if (typeof p.step === 'function' && p.step.length === 1) q += 10;
				if (typeof p.step === 'function' && p.step.length !== 1) q += 5;
				q += 280;
				if (typeof p.cueVideoByPlayerVars === 'function') q += 4;
				if (typeof p.loadVideoByPlayerVars === 'function') q += 4;
				if (typeof p.preloadVideoByPlayerVars === 'function') q += 4;
				if (typeof p.seekBy === 'function') q += 4;
				if (typeof p.seekTo === 'function') q += 4;
				if (typeof p.getStoryboardFormat === 'function') q += 4;
				if (typeof p.getDuration === 'function') q += 4;
				if (typeof p.loadModule === 'function') q += 4;
				if (typeof p.unloadModule === 'function') q += 4;
				if (typeof p.getOption === 'function') q += 4;
				if (typeof p.getOptions === 'function') q += 4;
				if (typeof p.setOption === 'function') q += 4;
				if (typeof p.addCueRange === 'function') q += 4;
				if (typeof p.getDebugText === 'function') q += 4;
				if (typeof p.getCurrentBroadcastId === 'function') q += 4;
				if (typeof p.setSizeStyle === 'function') q += 4;
				if (typeof p.showControls === 'function') q += 4;
				if (typeof p.hideControls === 'function') q += 4;
				if (typeof p.getVideoContentRect === 'function') q += 4;
				if (typeof p.toggleFullscreen === 'function') q += 4;
				if (typeof p.isFullscreen === 'function') q += 4;
				if (typeof p.cancelPlayback === 'function') q += 4;
				if (typeof p.getProgressState === 'function') q += 4;
				if (typeof p.isInline === 'function') q += 4;
				if (typeof p.setInline === 'function') q += 4;
				if (typeof p.toggleSubtitles === 'function') q += 4;
				if (typeof p.getPlayerSize === 'function') q += 4;
				if (typeof p.wakeUpControls === 'function') q += 4;
				if (typeof p.setCenterCrop === 'function') q += 4;
				if (typeof p.getLoopVideo === 'function') q += 4;
				if (typeof p.setLoopVideo === 'function') q += 4;
				if (q > 0) arr = addProtoToArr(_yt_player, k, arr) || arr;
				if (q > 0) brr.set(k, q);
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			arr = arr.map(key => [key, (brr.get(key) || 0)]);
			if (arr.length > 1) arr.sort((a, b) => b[1] - a[1]);
			if (arr.length > 2) console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0][0];
		}
	}
	const getSV = (_yt_player) => {
		const w = 'SV';
		let arr = [];
		let brr = new Map();
		for (const [k, v] of Object.entries(_yt_player)) {
			const p = typeof v === 'function' ? v.prototype : 0;
			if (p) {
				let q = 0;
				if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 7) q += 400;
				else if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 8) q += 300;
				else if (typeof p.handleGlobalKeyUp === 'function') q += 200;
				if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 0) q += 600;
				if (q < 200) continue;
				if (typeof p.handleGlobalKeyDown === 'function' && p.handleGlobalKeyDown.length === 8) q += 80;
				if (typeof p.handleGlobalKeyDown === 'function' && p.handleGlobalKeyDown.length === 7) q += 30;
				if (typeof p.step === 'function' && p.step.length === 1) q += 10;
				if (typeof p.step === 'function' && p.step.length !== 1) q += 5;
				q += 280;
				if (typeof p.cueVideoByPlayerVars === 'function') q -= 4;
				if (typeof p.loadVideoByPlayerVars === 'function') q -= 4;
				if (typeof p.preloadVideoByPlayerVars === 'function') q -= 4;
				if (typeof p.seekBy === 'function') q -= 4;
				if (typeof p.seekTo === 'function') q -= 4;
				if (typeof p.getStoryboardFormat === 'function') q -= 4;
				if (typeof p.getDuration === 'function') q -= 4;
				if (typeof p.loadModule === 'function') q -= 4;
				if (typeof p.unloadModule === 'function') q -= 4;
				if (typeof p.getOption === 'function') q -= 4;
				if (typeof p.getOptions === 'function') q -= 4;
				if (typeof p.setOption === 'function') q -= 4;
				if (typeof p.addCueRange === 'function') q -= 4;
				if (typeof p.getDebugText === 'function') q -= 4;
				if (typeof p.getCurrentBroadcastId === 'function') q -= 4;
				if (typeof p.setSizeStyle === 'function') q -= 4;
				if (typeof p.showControls === 'function') q -= 4;
				if (typeof p.hideControls === 'function') q -= 4;
				if (typeof p.getVideoContentRect === 'function') q -= 4;
				if (typeof p.toggleFullscreen === 'function') q -= 4;
				if (typeof p.isFullscreen === 'function') q -= 4;
				if (typeof p.cancelPlayback === 'function') q -= 4;
				if (typeof p.getProgressState === 'function') q -= 4;
				if (typeof p.isInline === 'function') q -= 4;
				if (typeof p.setInline === 'function') q -= 4;
				if (typeof p.toggleSubtitles === 'function') q -= 4;
				if (typeof p.getPlayerSize === 'function') q -= 4;
				if (typeof p.wakeUpControls === 'function') q -= 4;
				if (typeof p.setCenterCrop === 'function') q -= 4;
				if (typeof p.getLoopVideo === 'function') q -= 4;
				if (typeof p.setLoopVideo === 'function') q -= 4;
				if (q > 0) arr = addProtoToArr(_yt_player, k, arr) || arr;
				if (q > 0) brr.set(k, q);
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			arr = arr.map(key => [key, (brr.get(key) || 0)]);
			if (arr.length > 1) arr.sort((a, b) => b[1] - a[1]);
			if (arr.length > 2) console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0][0];
		}
	}
	const getDX = (_yt_player) => {
		const w = 'DX';
		let arr = [];
		let brr = new Map();
		for (const [k, v] of Object.entries(_yt_player)) {
			const p = typeof v === 'function' ? v.prototype : 0;
			if (p) {
				let q = 0;
				if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 7) q += 400;
				else if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 8) q += 300;
				else if (typeof p.handleGlobalKeyUp === 'function') q += 200;
				if (typeof p.handleGlobalKeyUp === 'function' && p.handleGlobalKeyUp.length === 0) q -= 600;
				if (!(typeof p.init === 'function' && p.init.length === 0)) q -= 300;
				if (q < 200) continue;
				if (typeof p.handleGlobalKeyDown === 'function' && p.handleGlobalKeyDown.length === 8) q += 80;
				if (typeof p.handleGlobalKeyDown === 'function' && p.handleGlobalKeyDown.length === 7) q += 30;
				if (typeof p.step === 'function' && p.step.length === 1) q += 10;
				if (typeof p.step === 'function' && p.step.length !== 1) q += 5;
				q += 280;
				if (typeof p.cueVideoByPlayerVars === 'function') q -= 4;
				if (typeof p.loadVideoByPlayerVars === 'function') q -= 4;
				if (typeof p.preloadVideoByPlayerVars === 'function') q -= 4;
				if (typeof p.seekBy === 'function') q -= 4;
				if (typeof p.seekTo === 'function') q -= 4;
				if (typeof p.getStoryboardFormat === 'function') q -= 4;
				if (typeof p.getDuration === 'function') q -= 4;
				if (typeof p.loadModule === 'function') q -= 4;
				if (typeof p.unloadModule === 'function') q -= 4;
				if (typeof p.getOption === 'function') q -= 4;
				if (typeof p.getOptions === 'function') q -= 4;
				if (typeof p.setOption === 'function') q -= 4;
				if (typeof p.addCueRange === 'function') q -= 4;
				if (typeof p.getDebugText === 'function') q -= 4;
				if (typeof p.getCurrentBroadcastId === 'function') q -= 4;
				if (typeof p.setSizeStyle === 'function') q -= 4;
				if (typeof p.showControls === 'function') q -= 4;
				if (typeof p.hideControls === 'function') q -= 4;
				if (typeof p.getVideoContentRect === 'function') q -= 4;
				if (typeof p.toggleFullscreen === 'function') q -= 4;
				if (typeof p.isFullscreen === 'function') q -= 4;
				if (typeof p.cancelPlayback === 'function') q -= 4;
				if (typeof p.getProgressState === 'function') q -= 4;
				if (typeof p.isInline === 'function') q -= 4;
				if (typeof p.setInline === 'function') q -= 4;
				if (typeof p.toggleSubtitles === 'function') q -= 4;
				if (typeof p.getPlayerSize === 'function') q -= 4;
				if (typeof p.wakeUpControls === 'function') q -= 4;
				if (typeof p.setCenterCrop === 'function') q -= 4;
				if (typeof p.getLoopVideo === 'function') q -= 4;
				if (typeof p.setLoopVideo === 'function') q -= 4;
				if (q > 0) arr = addProtoToArr(_yt_player, k, arr) || arr;
				if (q > 0) brr.set(k, q);
			}
		}
		if (arr.length === 0) {
			console.warn(`[yt-js-engine-tamer] (key-extraction) Key does not exist. [${w}]`);
		} else {
			arr = arr.map(key => [key, (brr.get(key) || 0)]);
			if (arr.length > 1) arr.sort((a, b) => b[1] - a[1]);
			if (arr.length > 2) console.log(`[yt-js-engine-tamer] (key-extraction) [${w}]`, arr);
			return arr[0][0];
		}
	}
	const isPrepareCachedV = (FIX_avoid_incorrect_video_meta ? true : false) && (window === top);
	let pageSetupVideoId = null;
	let pageSetupState = 0;
	isPrepareCachedV && (() => {
		pageSetupVideoId = '';
		const clearCachedV = () => {
			pageSetupVideoId = '';
			pageSetupState = 0;
		}
		document.addEventListener('yt-navigate-start', clearCachedV, false);
		document.addEventListener('yt-navigate-cache', clearCachedV, false);
		document.addEventListener('yt-page-data-fetched', clearCachedV, false);
		document.addEventListener('yt-navigate-finish', () => {
			pageSetupState = 1;
			try {
				const url = new URL(location.href);
				if (!url || !isWatchPageURL(url)) {
					pageSetupVideoId = '';
				} else {
					pageSetupVideoId = url.searchParams.get('v') || '';
				}
			} catch (e) {
				pageSetupVideoId = '';
			}
		}, false);
	})();
	let videoPlayingY = null;
	isPrepareCachedV && (() => {
		let getNext = true;
		let videoPlayingX = {
			get videoId() {
				if (getNext) {
					getNext = false;
					let elements = document.querySelectorAll('ytd-watch-flexy[video-id]');
					const arr = [];
					for (const element of elements) {
						if (!element.closest('[hidden]')) arr.push(element);
					}
					if (arr.length !== 1) this.__videoId__ = '';
					else {
						this.__videoId__ = arr[0].getAttribute('video-id');
					}
				}
				return this.__videoId__ || '';
			}
		}
		videoPlayingY = videoPlayingX;
		const handler = (evt) => {
			const target = (evt || 0).target;
			if (target instanceof HTMLVideoElement) {
				getNext = true;
			}
		}
		document.addEventListener('loadedmetadata', handler, true);
		document.addEventListener('durationchange', handler, true);
	})();
	const cleanContext = async (win) => {
		const waitFn = requestAnimationFrame;
		try {
			let mx = 16;
			const frameId = 'vanillajs-iframe-v1';

			let frame = document.getElementById(frameId);
			let removeIframeFn = null;
			if (!frame) {
				frame = document.createElement('iframe');
				frame.id = frameId;
				const blobURL = typeof webkitCancelAnimationFrame === 'function' && typeof kagi === 'undefined' ? (frame.src = URL.createObjectURL(new Blob([], { type: 'text/html' }))) : null;
				frame.sandbox = 'allow-same-origin';
				let n = document.createElement('noscript');
				n.appendChild(frame);
				while (!document.documentElement && mx-- > 0) await new Promise(waitFn);
				const root = document.documentElement;
				root.appendChild(n);
				if (blobURL) Promise.resolve().then(() => URL.revokeObjectURL(blobURL));
				removeIframeFn = (setTimeout) => {
					const removeIframeOnDocumentReady = (e) => {
						e && win.removeEventListener("DOMContentLoaded", removeIframeOnDocumentReady, false);
						e = n;
						n = win = removeIframeFn = 0;
						setTimeout ? setTimeout(() => e.remove(), 200) : e.remove();
					}
					if (!setTimeout || document.readyState !== 'loading') {
						removeIframeOnDocumentReady();
					} else {
						win.addEventListener("DOMContentLoaded", removeIframeOnDocumentReady, false);
					}
				}
			}
			while (!frame.contentWindow && mx-- > 0) await new Promise(waitFn);
			const fc = frame.contentWindow;
			if (!fc) throw "window is not found.";
			try {
				const { requestAnimationFrame, setTimeout, clearTimeout, cancelAnimationFrame, setInterval, clearInterval, requestIdleCallback, getComputedStyle } = fc;
				const res = { requestAnimationFrame, setTimeout, clearTimeout, cancelAnimationFrame, setInterval, clearInterval, requestIdleCallback, getComputedStyle };
				for (let k in res) res[k] = res[k].bind(win);
				if (removeIframeFn) Promise.resolve(res.setTimeout).then(removeIframeFn);
				res.animate = fc.HTMLElement.prototype.animate;
				res.perfNow = fc.performance.now;
				return res;
			} catch (e) {
				if (removeIframeFn) removeIframeFn();
				return null;
			}
		} catch (e) {
			console.warn(e);
			return null;
		}
	};
	const promiseForYtActionCalled = new Promise(resolve => {
		const appTag = isChatRoomURL ? 'yt-live-chat-app' : 'ytd-app';
		if (typeof AbortSignal !== 'undefined') {
			let hn = () => {
				if (!hn) return;
				hn = null;
				resolve(document.querySelector(appTag));
			};
			document.addEventListener('yt-action', hn, { capture: true, passive: true, once: true });
		} else {
			let hn = () => {
				if (!hn) return;
				document.removeEventListener('yt-action', hn, true);
				hn = null;
				resolve(document.querySelector(appTag));
			};
			document.addEventListener('yt-action', hn, true);
		}
	});
	cleanContext(window).then(__CONTEXT__ => {
		if (!__CONTEXT__) return null;
		const { requestAnimationFrame, setTimeout, clearTimeout, cancelAnimationFrame, setInterval, clearInterval, animate, requestIdleCallback, getComputedStyle, perfNow } = __CONTEXT__;
		performance.now17 = perfNow.bind(performance);
		__requestAnimationFrame__ = requestAnimationFrame;
		const isGPUAccelerationAvailable = (() => {
			try {
				const canvas = document.createElement('canvas');
				return !!(canvas.getContext('webgl') || canvas.getContext('experimental-webgl'));
			} catch (e) {
				return false;
			}
		})();
		const foregroundPromiseFn_noGPU = (() => {
			if (isGPUAccelerationAvailable) return null;
			const pd = Object.getOwnPropertyDescriptor(Document.prototype, 'visibilityState');
			if (!pd || typeof pd.get !== 'function') return null;
			const pdGet = pd.get;
			let pr = null;
			let hState = pdGet.call(document) === 'hidden';
			pureAddEventListener.call(document, 'visibilitychange', (evt) => {
				const newHState = pdGet.call(document) === 'hidden';
				if (hState !== newHState) {
					hState = newHState;
					if (!hState && pr) pr = pr.resolve();
				}
			});
			return (() => {
				if (pr) return pr;
				const w = ((!hState && setTimeout(() => {
					if (!hState && pr === w) pr = pr.resolve();
				})), (pr = new PromiseExternal()));
				return w;
			});
		})();
		let rafPromise = null;
		const getRafPromise = () => rafPromise || (rafPromise = new Promise(resolve => {
			requestAnimationFrame(hRes => {
				rafPromise = null;
				resolve(hRes);
			});
		}));
		const foregroundPromiseFn = foregroundPromiseFn_noGPU || getRafPromise;
		const wmComputedStyle = new WeakMap();
		if (!window.__native__getComputedStyle__ && !window.__jst__getComputedStyle__ && typeof window.getComputedStyle === 'function' && window.getComputedStyle.length === 1) {
			window.__native__getComputedStyle__ = getComputedStyle;
			if (ENABLE_COMPUTEDSTYLE_CACHE) {
				window.__original__getComputedStyle__ = window.getComputedStyle;
				window.getComputedStyle = function (elem) {
					if (!(elem instanceof Element) || (arguments.length === 2 && arguments[1]) || (arguments.length > 2)) {
						return window.__original__getComputedStyle__(...arguments);
					}
					let cs = wmComputedStyle.get(elem);
					if (!cs) {
						cs = window.__native__getComputedStyle__(elem);
						wmComputedStyle.set(elem, cs);
					}
					return cs;
				};
			} else {
				window.__original__getComputedStyle__ = null;
			}
			window.__jst__getComputedStyle__ = window.getComputedStyle;
		}
		NO_SCHEDULING_DUE_TO_COMPUTEDSTYLE && promiseForYtActionCalled.then(() => {
			if (typeof window.__jst__getComputedStyle__ === 'function' && window.__jst__getComputedStyle__.length === 1 && window.__jst__getComputedStyle__ !== window.getComputedStyle) {
				window.getComputedStyle = window.__jst__getComputedStyle__;
			}
		});
		const isUrlInEmbed = location.href.includes('.youtube.com/embed/');
		const isAbortSignalSupported = typeof AbortSignal !== "undefined";
		const promiseForTamerTimeout = new Promise(resolve => {
			!isUrlInEmbed && isAbortSignalSupported && document.addEventListener('yt-action', function () {
				setTimeout(resolve, 480);
			}, { capture: true, passive: true, once: true });
			!isUrlInEmbed && isAbortSignalSupported && typeof customElements === "object" && whenCEDefined('ytd-app').then(() => {
				setTimeout(resolve, 1200);
			});
			setTimeout(resolve, 3000);
		});
		const promiseForPageInitied = new Promise(resolve => {
			!isUrlInEmbed && isAbortSignalSupported && document.addEventListener('yt-action', function () {
				setTimeout(resolve, 450);
			}, { capture: true, passive: true, once: true });
			!isUrlInEmbed && isAbortSignalSupported && typeof customElements === "object" && whenCEDefined('ytd-app').then(() => {
				setTimeout(resolve, 900);
			});
			setTimeout(resolve, 1800);
		});
		NO_PRELOAD_GENERATE_204_BYPASS || promiseForPageInitied.then(() => {
			NO_PRELOAD_GENERATE_204_BYPASS = true;
			headLinkCollection = null;
		});
		NATIVE_CANVAS_ANIMATION && (() => {
			observablePromise(() => {
				HTMLCanvasElement.prototype.animate = animate;
			}, promiseForTamerTimeout).obtain();
		})();
		FIX_ytAction_ && (async () => {
			const appTag = isChatRoomURL ? 'yt-live-chat-app' : 'ytd-app';
			const ytdApp = await new Promise(resolve => {
				whenCEDefined(appTag).then(() => {
					const ytdApp = document.querySelector(appTag);
					if (ytdApp) {
						resolve(ytdApp);
						return;
					}
					let mo = new MutationObserver(() => {
						const ytdApp = document.querySelector(appTag);
						if (!ytdApp) return;
						if (mo) {
							mo.disconnect();
							mo.takeRecords();
							mo = null;
						}
						resolve(ytdApp);
					});
					mo.observe(document, { subtree: true, childList: true });
				});
			});
			if (!ytdApp) return;
			const cProto = insp(ytdApp).constructor.prototype;
			if (!cProto) return;
			let mbd = 0;
			const fixer = (_ytdApp) => {
				const ytdApp = insp(_ytdApp);
				if (ytdApp && typeof ytdApp.onYtActionBoundListener_ === 'function' && !ytdApp.onYtActionBoundListener57_) {
					ytdApp.onYtActionBoundListener57_ = ytdApp.onYtActionBoundListener_;
					ytdApp.onYtActionBoundListener_ = ytdApp.onYtAction_.bind(ytdApp);
					mbd++;
				}
			}
			observablePromise(() => {
				if (typeof cProto.created === 'function' && !cProto.created56) {
					cProto.created56 = cProto.created;
					cProto.created = function (...args) {
						const r = this.created56(...args);
						fixer(this);
						return r;
					};
					mbd++;
				}
				if (typeof cProto.onYtAction_ === 'function' && !cProto.onYtAction57_) {
					cProto.onYtAction57_ = cProto.onYtAction_;
					cProto.onYtAction_ = function (...args) {
						Promise.resolve().then(() => this.onYtAction57_(...args));
					};
					mbd++;
				}
				if (ytdApp) fixer(ytdApp);

				if (mbd >= 3) return 1;
			}, new Promise(r => setTimeout(r, 1000))).obtain();
		})();
		FORCE_NO_REUSEABLE_ELEMENT_POOL && promiseForYtActionCalled.then(async () => {
			const appTag = isChatRoomURL ? 'yt-live-chat-app' : 'ytd-watch-flexy';
			const app = await observablePromise(() => {
				return document.querySelector(appTag);
			}).obtain();
			if (!app) return;
			const appCnt = insp(app);
			FORCE_NO_REUSEABLE_ELEMENT_POOL_fn(appCnt);
		});
		const observablePromise = (proc, timeoutPromise) => {
			let promise = null;
			return {
				obtain() {
					if (!promise) {
						promise = new Promise(resolve => {
							let mo = null;
							const f = () => {
								let t = proc();
								if (t) {
									mo.disconnect();
									mo.takeRecords();
									mo = null;
									resolve(t);
								}
							}
							mo = new MutationObserver(f);
							mo.observe(document, { subtree: true, childList: true })
							f();
							timeoutPromise && timeoutPromise.then(() => {
								resolve(null)
							});
						});
					}
					return promise
				}
			}
		}

		const _yt_player_observable = observablePromise(() => {
			const _yt_player = (((window || 0)._yt_player || 0) || 0);
			if (_yt_player) {
				_yt_player[`__is_yt_player__${Date.now()}`] = 1;
				return _yt_player;
			}
		}, promiseForTamerTimeout);
		const polymerObservable = observablePromise(() => {
			const Polymer = window.Polymer;
			if (typeof Polymer !== 'function') return;
			if (!(Polymer.Base || 0).connectedCallback || !(Polymer.Base || 0).disconnectedCallback) return;
			return Polymer;
		}, promiseForTamerTimeout);
		const schedulerInstanceObservable = observablePromise(() => {
			return (((window || 0).ytglobal || 0).schedulerInstanceInstance_ || 0);
		}, promiseForTamerTimeout);
		const timelineObservable = observablePromise(() => {
			let t = (((document || 0).timeline || 0) || 0);
			if (t && typeof t._play === 'function') {
				return t;
			}
		}, promiseForTamerTimeout);
		const animationObservable = observablePromise(() => {
			let t = (((window || 0).Animation || 0) || 0);
			if (t && typeof t === 'function' && t.length === 2 && typeof t.prototype._updatePromises === 'function') {
				return t;
			}
		}, promiseForTamerTimeout);
		const getScreenInfo = {
			screenWidth: 0,
			screenHeight: 0,
			valueReady: false,
			onResize: () => {
				getScreenInfo.valueReady = false;
			},
			sizeProvided: () => {
				if (getScreenInfo.valueReady) return true;
				getScreenInfo.screenWidth = screen.width;
				getScreenInfo.screenHeight = screen.height;
				if (getScreenInfo.screenWidth * getScreenInfo.screenHeight > 1) {
					getScreenInfo.valueReady = true;
					return true;
				}
				return false;
			}
		};
		window.addEventListener('resize', getScreenInfo.onResize, true);
		const isNaNx = Number.isNaN;
		const hookLeftPD = {
			get() {
				const p = 'left';
				return this.getPropertyValue(p);
			},
			set(v) {
				const p = 'left';
				const cv = this.getPropertyValue(p);
				const sv = v;
				if (!cv && !sv) return true;
				if (cv === sv) return true;
				const qsv = `${sv}`.length >= 4 && `${sv}`.endsWith('px') ? +sv.slice(0, -2) : NaN;
				if (!isNaNx(qsv)) {
					const qcv = `${cv}`.length >= 4 && `${cv}`.endsWith('px') ? +cv.slice(0, -2) : NaN;
					if (!isNaNx(qcv) && getScreenInfo.sizeProvided()) {
						const { screenWidth, screenHeight } = getScreenInfo;
						let pWidth = screenWidth + 1024;
						let pHeight = screenHeight + 768;
						const minRatio = 0.003;
						const dw = pWidth * 0.0003;
						const dh = pHeight * 0.0003;
						if (Math.abs(qcv - qsv) < dw) return true;
					}
					v = `${qsv > -1e-5 && qsv < 1e-5 ? 0 : qsv.toFixed(4)}px`;
					if (`${v}`.length > `${sv}`.length) v = sv;
				}
				this.setProperty(p, v);
				return true;
			},
			enumerable: true,
			configurable: true
		};
		if (HOOK_CSSPD_LEFT) {
			Object.defineProperty(CSSStyleDeclaration.prototype, 'left', hookLeftPD);
		}
		const generalEvtHandler = async (_evKey, _fvKey, _debug) => {
			const evKey = `${_evKey}`;
			const fvKey = `${_fvKey}`;
			const debug = !!_debug;
			const _yt_player = await _yt_player_observable.obtain();
			if (!_yt_player || typeof _yt_player !== 'object') return;
			const getArr = (_yt_player) => {
				let arr = [];
				for (const [k, v] of Object.entries(_yt_player)) {
					const p = typeof v === 'function' ? v.prototype : 0;
					if (p
						&& typeof p[evKey] === 'function' && p[evKey].length >= 0 && !p[fvKey]
					) {
						arr = addProtoToArr(_yt_player, k, arr) || arr;
					}
				}
				if (arr.length === 0) {
					console.warn(`Key prop [${evKey}] does not exist.`);
				} else {
					return arr;
				}
			};
			const arr = getArr(_yt_player);
			if (!arr) return;
			debug && console.log(`FIX_${evKey}`, arr);
			const f = function (...args) {
				Promise.resolve().then(() => this[fvKey](...args));
			};
			for (const k of arr) {
				const g = _yt_player;
				const gk = g[k];
				const gkp = gk.prototype;
				debug && console.log(237, k, gkp)
				if (typeof gkp[evKey] == 'function' && !gkp[fvKey]) {
					gkp[fvKey] = gkp[evKey];
					gkp[evKey] = f;
				}
			}
		}
		if (!isChatRoomURL) {
			FIX_onVideoDataChange && generalEvtHandler('onVideoDataChange', 'onVideoDataChange57');
			FIX_onStateChange && generalEvtHandler('onStateChange', 'onStateChange57');
			FIX_onLoopRangeChange && generalEvtHandler('onLoopRangeChange', 'onLoopRangeChange57');
			if (FIX_VideoEVENTS_v2) {
				const FIX_VideoEVENTS_DEBUG = 0;
				generalEvtHandler('onVideoProgress', 'onVideoProgress57', FIX_VideoEVENTS_DEBUG);
				generalEvtHandler('onFullscreenChange', 'onFullscreenChange57', FIX_VideoEVENTS_DEBUG);
			}
		}
		let isAmended_Polymer_RenderStatus = false;
		(ENABLE_discreteTasking || FIX_Polymer_dom || FIX_Polymer_AF || FIX_stampDomArray) && (async () => {
			const Polymer = await polymerObservable.obtain();
			if (!Polymer) return;
			if (FIX_Polymer_AF && Polymer && Polymer.RenderStatus && !isAmended_Polymer_RenderStatus) {
				isAmended_Polymer_RenderStatus = true;
				if (typeof Polymer.RenderStatus.beforeNextRender === 'function' && typeof Polymer.RenderStatus.afterNextRender === 'function' && Polymer.RenderStatus.beforeNextRender.length === 3 && Polymer.RenderStatus.afterNextRender.length === 3) {
					let arrBefore = null, arrAfter = null;
					const push = Array.prototype.push;
					let arr = null;
					Array.prototype.push = function () {
						arr = this;
					}
					Polymer.RenderStatus.beforeNextRender({}, {}, {});
					if (arr) arrBefore = arr;
					arr = null;
					Polymer.RenderStatus.afterNextRender({}, {}, {});
					if (arr) arrAfter = arr;
					arr = null;
					Array.prototype.push = push;
					Polymer.RenderStatus.arrBefore = arrBefore;
					Polymer.RenderStatus.arrAfter = arrAfter;
					if (arrBefore && arrAfter) {
						Function.prototype.call7900 = Function.prototype.call;
						Function.prototype.apply7900 = Function.prototype.apply;
						Function.prototype.apply7948 = function (obj, args) {
							const f = this;
							let m = kRef(obj);
							if (!m) return;
							if (m.is && !m.nodeName) {
								if (!m.isAttached || !m.hostElement) {
									return;
								}
							}
							try {
								return !args ? f.call7900(m) : f.apply7900(m, args);
							} catch (e) {
								console.warn(e);
							}
							return null;
						}
						arrBefore.push = arrAfter.push = function (a) {
							if (arguments.length !== 1 || !a || a.length === 0 || !a[0]) return push.apply(this, arguments);
							if (a[0].deref) a[0] = kRef(a[0]);
							const f = a[1]
							const obj = a[0]
							const args = a[2];
							f.apply = f.apply7948;
							if (!obj[wk]) obj[wk] = mWeakRef(obj);
							a[0] = obj[wk]
							return push.call(this, a);
						}
					}
				}
			}
			if (FIX_Polymer_dom) {
				const checkPDFuncValue = (pd) => {
					return pd && pd.writable && pd.enumerable && pd.configurable && typeof pd.value == 'function'
				}
				const checkPDFuncValue2 = (pd) => {
					return pd && typeof pd.value == 'function'
				}
				const checkPDFuncGet = (pd) => {
					return pd && typeof pd.get == 'function'
				}
				const domX = Polymer.dom(document.createElement('null'));
				const domXP = (((domX || 0).constructor || 0).prototype || 0);
				const pd1 = Object.getOwnPropertyDescriptor(domXP, 'getOwnerRoot');
				const pd2 = Object.getOwnPropertyDescriptor(Node.prototype, 'parentElement');
				const pd3 = Object.getOwnPropertyDescriptor(domXP, 'querySelector');
				const pd4 = Object.getOwnPropertyDescriptor(Element.prototype, 'querySelector');
				const pd4b = Object.getOwnPropertyDescriptor(Document.prototype, 'querySelector');
				const pd5 = Object.getOwnPropertyDescriptor(domXP, 'querySelectorAll');
				const pd6 = Object.getOwnPropertyDescriptor(Element.prototype, 'querySelectorAll');
				const pd6b = Object.getOwnPropertyDescriptor(Document.prototype, 'querySelectorAll');
				if (0 && checkPDFuncValue(pd1) && checkPDFuncGet(pd2) && !domXP.getOwnerRoot15 && typeof domXP.getOwnerRoot === 'function') {
					domXP.getOwnerRoot15 = domXP.getOwnerRoot;
					domXP.getOwnerRoot = function () {
						try {
							const p = this.node;
							if (p instanceof HTMLElement_) {
								const pp = pd2.get.call(p);
								if (pp instanceof HTMLElement_ && pp.isConnected === true) {
									return pp.getRootNode();
								}
							}
						} catch (e) { }
						return this.getOwnerRoot15();
					}
					Polymer.__fixedGetOwnerRoot__ = 1;
				}
				if ((!pd3 || checkPDFuncValue(pd3)) && checkPDFuncValue2(pd4) && checkPDFuncValue2(pd4b) && !('querySelector15' in domXP)) {
					domXP.querySelector15 = domXP.querySelector;
					const querySelectorFn = function (query) {
						try {
							const p = this.node;
							if (p instanceof Document && p.isConnected === true) {
								return pd4b.value.call(p, query);
							}
						} catch (e) { }
						return this.querySelector15(query);
					}
					Object.defineProperty(domXP, 'querySelector', {
						get() {
							return querySelectorFn;
						},
						set(nv) {
							if (nv === querySelectorFn) return true;
							this.querySelector15 = nv;
							return true;
						},
						enumerable: false,
						configurable: true
					});
					Polymer.__fixedQuerySelector__ = 1;
				}
				if ((!pd5 || checkPDFuncValue(pd5)) && checkPDFuncValue2(pd6) && checkPDFuncValue2(pd6b) && !('querySelectorAll15' in domXP)) {
					domXP.querySelectorAll15 = domXP.querySelectorAll;
					const querySelectorAllFn = function (query) {
						try {
							const p = this.node;
							if (p instanceof Document && p.isConnected === true) {
								return pd6b.value.call(p, query);
							}
						} catch (e) {
						}
						return this.querySelectorAll15(query);
					}
					Object.defineProperty(domXP, 'querySelectorAll', {
						get() {
							return querySelectorAllFn;
						},
						set(nv) {
							if (nv === querySelectorAllFn) return true;
							this.querySelectorAll15 = nv;
							return true;
						},
						enumerable: false,
						configurable: true
					});
					Polymer.__fixedQuerySelectorAll__ = 1;
				}
			}
			if (ENABLE_discreteTasking || FIX_stampDomArray) {
				Polymer.Base.__connInit__ = function () {
					setupYtComponent(this);
				}

				const connectedCallbackK = function (...args) {
					!this.mh35 && typeof this.__connInit__ === 'function' && this.__connInit__();
					const r = this[qm53](...args);
					!this.mh35 && typeof this.__connInit__ === 'function' && this.__connInit__();
					this.mh35 = 1;
					return r;
				};
				connectedCallbackK.m353 = 1;
				const qt53 = Polymer.Base.connectedCallback;
				Polymer.Base[qm53] = dmf.get(qt53) || qt53;
				Polymer.Base.connectedCallback = connectedCallbackK;

				const createdK = function (...args) {
					!this.mh36 && typeof this.__connInit__ === 'function' && this.__connInit__();
					const r = this[qn53](...args);
					!this.mh36 && typeof this.__connInit__ === 'function' && this.__connInit__();
					this.mh36 = 1;
					return r;
				};
				createdK.m353 = 1;
				Polymer.Base[qn53] = Polymer.Base.created;
				Polymer.Base.created = createdK;
			}
		})();

		CHANGE_appendChild && !Node.prototype.appendChild73 && Node.prototype.appendChild && (() => {
			const f = Node.prototype.appendChild73 = Node.prototype.appendChild;
			if (f) Node.prototype.appendChild = function (a) {
				if (this instanceof Element) {
					try {
						let checkFragmentA = (a instanceof DocumentFragment);
						if (!NO_PRELOAD_GENERATE_204_BYPASS && document.head === this) {
							if (headLinkCollection === null) headLinkCollection = document.head.getElementsByTagName('LINK');
							for (const node of headLinkCollection) {
								if (node.rel === 'preload' && node.as === 'fetch') {
									node.rel = 'prefetch';
								}
							}
						} else if (checkFragmentA && this.nodeName.startsWith('YT-')) {
							checkFragmentA = false;
						}
						if (checkFragmentA && a.firstElementChild === null) {
							let doNormal = false;
							for (let child = a.firstChild; child instanceof Node; child = child.nextSibling) {
								if (child.nodeType === 3) { doNormal = true; break; }
							}
							if (!doNormal) return a;
						}
					} catch (e) {
						console.log(e);
					}
				}
				return arguments.length === 1 ? f.call(this, a) : f.apply(this, arguments);
			}
		})();
		if (FIX_Shady) {
			observablePromise(() => {
				const { ShadyDOM, ShadyCSS } = window;
				if (ShadyDOM) {
					ShadyDOM.handlesDynamicScoping = false;
					ShadyDOM.noPatch = true;
					ShadyDOM.patchOnDemand = false;
					ShadyDOM.preferPerformance = true;
					ShadyDOM.querySelectorImplementation = undefined;
				}
				if (ShadyCSS) {
					ShadyCSS.nativeCss = true;
					ShadyCSS.nativeShadow = true;
					ShadyCSS.cssBuild = undefined;
					ShadyCSS.disableRuntime = true;
				}
				if (ShadyDOM && ShadyCSS) return 1;
			}, promiseForTamerTimeout).obtain();
		}
		(FIX_schedulerInstanceInstance & 2) && (async () => {
			const schedulerInstanceInstance_ = await schedulerInstanceObservable.obtain();
			if (!schedulerInstanceInstance_) return;
			const checkOK = typeof schedulerInstanceInstance_.start === 'function' && !schedulerInstanceInstance_.start993 && !schedulerInstanceInstance_.stop && !schedulerInstanceInstance_.cancel && !schedulerInstanceInstance_.terminate && !schedulerInstanceInstance_.interupt;
			if (checkOK) {
				schedulerInstanceInstance_.start993 = schedulerInstanceInstance_.start;
				let requestingFn = null;
				let requestingArgs = null;
				const f = function () {
					requestingFn = this.fn;
					requestingArgs = [...arguments];
					return 12373;
				};
				const fakeFns = [
					f.bind({ fn: requestAnimationFrame }),
					f.bind({ fn: setInterval }),
					f.bind({ fn: setTimeout }),
					f.bind({ fn: requestIdleCallback })
				];
				let mzt = 0;
				let _fnSelectorProp = null;
				const mkFns = new Array(4);

				const startFnHandler = {
					get(target, prop, receiver) {
						if (prop === '$$12377$$') return true;
						if (prop === '$$12378$$') return target;
						return target[prop]
					},
					set(target, prop, value, receiver) {
						if (value >= 1 && value <= 4) _fnSelectorProp = prop;
						if (value === 12373 && _fnSelectorProp) {
							const schedulerTypeSelection = target[_fnSelectorProp];
							const timerIdProp = prop;
							if (schedulerTypeSelection === 3 && requestingFn === requestAnimationFrame) {
								target[timerIdProp] = baseRAF.apply(window, requestingArgs);
							} else if (schedulerTypeSelection === 2 && requestingFn === setTimeout) {
								target[timerIdProp] = mkFns[2].apply(window, requestingArgs);
							} else if (schedulerTypeSelection === 4 && requestingFn === setTimeout && !requestingArgs[1]) {
								if ((FIX_schedulerInstanceInstance & 4)) {
									const f = requestingArgs[0];
									const tir = ++mzt;
									nextBrowserTick_(() => {
										if (target[timerIdProp] === -tir) f();
									});
									target[_fnSelectorProp] = 940;
									target[timerIdProp] = -tir;
								} else {
									const f = requestingArgs[0];
									const tir = ++mzt;
									Promise.resolve().then(() => {
										if (target[timerIdProp] === -tir) f();
									});
									target[_fnSelectorProp] = 930;
									target[timerIdProp] = -tir;
								}
							} else if (schedulerTypeSelection === 1 && (requestingFn === requestIdleCallback || requestingFn === setTimeout)) {
								if (requestingFn === requestIdleCallback) {
									target[timerIdProp] = requestIdleCallback.apply(window, requestingArgs);
								} else {
									target[timerIdProp] = mkFns[2].apply(window, requestingArgs);
								}
							} else {
								target[_fnSelectorProp] = 0;
								target[timerIdProp] = 0;
							}
						} else {
							target[prop] = value;
						}
						return true;
					}
				};
				let startBusy = false;
				schedulerInstanceInstance_.start = function () {
					if (startBusy) return;
					startBusy = true;
					try {
						mkFns[0] = window.requestAnimationFrame;
						mkFns[1] = window.setInterval;
						mkFns[2] = window.setTimeout;
						mkFns[3] = window.requestIdleCallback;
						const tThis = this['$$12378$$'] || this;
						window.requestAnimationFrame = fakeFns[0]
						window.setInterval = fakeFns[1]
						window.setTimeout = fakeFns[2]
						window.requestIdleCallback = fakeFns[3]
						_fnSelectorProp = null;
						tThis.start993.call(new Proxy(tThis, startFnHandler));
						_fnSelectorProp = null;
						window.requestAnimationFrame = mkFns[0];
						window.setInterval = mkFns[1];
						window.setTimeout = mkFns[2];
						window.requestIdleCallback = mkFns[3];
					} catch (e) {
						console.warn(e);
					}
					startBusy = false;
				}
				schedulerInstanceInstance_.start.toString = schedulerInstanceInstance_.start993.toString.bind(schedulerInstanceInstance_.start993);
			}
		})();
		FIX_yt_player && !isChatRoomURL && (async () => {
			const fOption = 1 | 2 | 4;
			const _yt_player = await _yt_player_observable.obtain();
			if (!_yt_player || typeof _yt_player !== 'object') return;
			const g = _yt_player;
			let k;
			if (fOption & 1) {
				const keyZqOu = getZqOu(_yt_player);
				if (!keyZqOu) {
					console.warn('[yt-js-engine-tamer] FIX_yt_player::keyZqOu error');
					return;
				}
				k = keyZqOu
				const gk = g[k];
				if (typeof gk !== 'function') {
					console.warn('[yt-js-engine-tamer] FIX_yt_player::g[keyZqOu] error');
					return;
				}
				const gkp = gk.prototype;
				const dummyObject = new gk;
				const nilFunc = () => { };
				const nilObj = {};
				let keyBoolD = '';
				let keyWindow = '';
				let keyFuncC = '';
				let keyCidj = '';
				for (const [t, y] of Object.entries(dummyObject)) {
					if (y instanceof Window) keyWindow = t;
				}
				const dummyObjectProxyHandler = {
					get(target, prop) {
						let v = target[prop]
						if (v instanceof Window && !keyWindow) {
							keyWindow = t;
						}
						let y = typeof v === 'function' ? nilFunc : typeof v === 'object' ? nilObj : v;
						if (prop === keyWindow) y = {
							requestAnimationFrame(f) {
								return 3;
							},
							cancelAnimationFrame() {
							}
						}
						if (!keyFuncC && typeof v === 'function' && !(prop in target.constructor.prototype)) {
							keyFuncC = prop;
						}
						return y;
					},
					set(target, prop, value) {
						if (typeof value === 'boolean' && !keyBoolD) {
							keyBoolD = prop;
						}
						if (typeof value === 'number' && !keyCidj && value >= 2) {
							keyCidj = prop;
						}
						target[prop] = value;
						return true;
					}
				};
				dummyObject.start.call(new Proxy(dummyObject, dummyObjectProxyHandler));
				gkp._activation = false;
				gkp.start = function () {
					if (!this._activation) {
						this._activation = true;
						foregroundPromiseFn().then(() => {
							this._activation = false;
							if (this[keyCidj]) {
								Promise.resolve().then(this[keyFuncC]);
							}
						});
					}
					this[keyCidj] = 1;
					this[keyBoolD] = true;
				};
				gkp.stop = function () {
					this[keyCidj] = null;
				};

			}
			if (fOption & 2) {
				const keyzo = PERF_471489_ ? getzo(_yt_player) : null;
				if (keyzo) {
					k = keyzo;
					const attrUpdateFn = g[k];
					g['$$original$$' + k] = attrUpdateFn;
					const zoTransform = async (a, c) => {
						let transformType = '';
						let transformValue = 0;
						let transformUnit = '';
						let transformTypeI = 0;
						const aStyle = a.style;
						let cType = 0;
						const cl = c.length;
						if (cl >= 8) {
							if (c.startsWith('scale') && c.charCodeAt(6) === 40 && c.charCodeAt(cl - 1) === 41) {
								cType = 1;
								let t = c.charCodeAt(5);
								if (t === 88 || t === 120) cType = 1 | 4;
								if (t === 89 || t === 121) cType = 1 | 8;
							} else if (c.startsWith('translate') && c.charCodeAt(10) === 40 && c.charCodeAt(cl - 1) === 41) {
								cType = 2;
								let t = c.charCodeAt(9);
								if (t === 88 || t === 120) cType = 2 | 4;
								if (t === 89 || t === 121) cType = 2 | 8;
							}
							let w = 0;
							if (w = (cType === 5) ? 1 : (cType === 9) ? 2 : 0) {
								let p = c.substring(7, cl - 1);
								let q = p.length >= 1 ? parseFloat(p) : NaN;
								if (typeof q === 'number' && !isNaNx(q)) {
									transformType = w === 1 ? 'scaleX' : 'scaleY';
									transformValue = q;
									transformUnit = '';
									transformTypeI = 1;
								} else {
									cType = 256;
								}
							} else if (w = (cType === 6) ? 1 : (cType === 10) ? 2 : 0) {
								if (c.endsWith('px)')) {
									let p = c.substring(11, cl - 3);
									let q = p.length >= 1 ? parseFloat(p) : NaN;
									if (typeof q === 'number' && !isNaNx(q)) {
										transformType = w === 1 ? 'translateX' : 'translateY';
										transformValue = q;
										transformUnit = 'px';
										transformTypeI = 2;
									} else if (p === 'NaN') {
										return;
									}
								} else {
									cType = 256;
								}
							} else if (cType > 0) {
								cType = 256;
							}
						}
						if (cType === 256) {
							console.log('[yt-js-engine-tamer] zoTransform undefined', c);
						}
						if (transformTypeI === 1) {
							const q = Math.round(transformValue * steppingScaleN) / steppingScaleN;
							const vz = toFixed2(q, 3);
							c = `${transformType}(${vz})`;
							const cv = aStyle.transform;
							if (c === cv) return;
							aStyle.transform = c;
						} else if (transformTypeI === 2) {
							const q = transformValue;
							const vz = toFixed2(q, 1);
							c = `${transformType}(${vz}${transformUnit})`;
							const cv = aStyle.transform;
							if (c === cv) return;
							aStyle.transform = c;
						} else {
							const cv = aStyle.transform;
							if (!c && !cv) return;
							else if (c === cv) return;
							aStyle.transform = c;
						}
					};
					const elmTransformTemp = new WeakMap();
					const elmPropTemps = {
						'display': new WeakMap(),
						'width': new WeakMap(),
						'height': new WeakMap(),
						'outlineWidth': new WeakMap(),
						'position': new WeakMap(),
						'padding': new WeakMap(),
						"cssText": new WeakMap(),
						"right": new WeakMap(),
						"left": new WeakMap(),
						"top": new WeakMap(),
						"bottom": new WeakMap(),
						"transitionDelay": new WeakMap(),
						"marginLeft": new WeakMap(),
						"marginTop": new WeakMap(),
						"marginRight": new WeakMap(),
						"marginBottom": new WeakMap(),
					}
					const ns5 = Symbol();
					const nextModify = (a, c, m, f, immediate) => {
						const a_ = a;
						const m_ = m;
						const noKey = !m_.has(a_);
						if (immediate || noKey) {
							m_.set(a_, ns5);
							f(a_, c);
							noKey && nextBrowserTick_(() => {
								const d = m_.get(a_);
								if (d === undefined) return;
								m_.delete(a_);
								if (d !== ns5) f(a_, d);
							});
						} else {
							m_.set(a_, c);
						}
					};
					const set66 = new Set();
					const log77 = new Map();
					const modifiedFn = function (a, b, c, immediateChange = false) {
						if (typeof c === 'number' && typeof b === 'string' && a instanceof HTMLElement_) {
							const num = c;
							c = `${num}`;
							if (c.length > 5) c = (num < 10 && num > -10) ? toFixed2(num, 3) : toFixed2(num, 1);
						}
						if (typeof b === 'string' && typeof c === 'string' && a instanceof HTMLElement_) {
							let elmPropTemp = null;
							if (b === "transform") {
								nextModify(a, c, elmTransformTemp, zoTransform, immediateChange);
								return;
							} else if (elmPropTemp = elmPropTemps[b]) {
								const b_ = b;
								nextModify(a, c, elmPropTemp, (a, c) => {
									const style = a.style;
									const cv = style[b_];
									if (!cv && !c) return;
									if (cv === c) return;
									style[b_] = c;
								}, immediateChange);
								return;
							} else if (b === "outline-width") {
								const b_ = 'outlineWidth';
								elmPropTemp = elmPropTemps[b_];
								nextModify(a, c, elmPropTemp, (a, c) => {
									const style = a.style;
									const cv = style[b_];
									if (!cv && !c) return;
									if (cv === c) return;
									style[b_] = c;
								}, immediateChange);
								return;
							} else if (b === 'maxWidth' || b === 'maxHeight') {
								const b_ = b;
								const style = a.style;
								const cv = style[b_];
								if (!cv && !c) return;
								if (cv === c) return;
								style[b_] = c;
								return;
							} else {
								if (!set66.has(b)) {
									set66.add(b);
									nextBrowserTick_(() => {
										if (!a.classList.contains('caption-window') && !a.classList.contains('ytp-caption-segment')) {
											console.log(27304, a, b, c)
										}
									})
								}
							}
							attrUpdateFn.call(this, a, b, c);
							return;
						} else if (typeof (b || 0) === 'object') {
							const immediate = (a.id || 0).length > 14;
							for (const [k, v] of Object.entries(b)) {
								modifiedFn.call(this, a, k, v, immediate);
							}
						} else {
							if (typeof b === 'string') {
								let m = log77.get(b);
								if (!m) {
									m = [];
									console.log('attrUpdateFn.debug.27304', m);
									log77.set(b, m);
								}
								m.push([a, b, c]);
							} else {
								console.log('attrUpdateFn.debug.27306', a, b, c);
							}
							attrUpdateFn.call(this, a, b, c);
							return;
						}
					};
					g[k] = modifiedFn;

				}
			}
			if (fOption & 4) {
				const keyuG = PERF_471489_ ? getuG(_yt_player) : null;
				if (keyuG) {
					k = keyuG;
					const gk = g[k];
					const gkp = gk.prototype;

					const ntLogs = new Map();
					if (typeof gkp.updateValue === 'function' && gkp.updateValue.length === 2 && !gkp.updateValue31) {
						gkp.updateValue31 = gkp.updateValue;
						gkp.updateValue = function (a, b) {
							if (typeof a !== 'string') return this.updateValue31(a, b);
							const element = this.element;
							if (!(element instanceof HTMLElement_)) return this.updateValue31(a, b);
							let ntLog = ntLogs.get(a);
							if (!ntLog) ntLogs.set(a, (ntLog = new WeakMap()));
							let cache = ntLog.get(element);
							if (cache && cache.value === b) {
								return;
							}
							if (!cache) {
								this.__oldValueByUpdateValue__ = null;
								ntLog.set(element, cache = { value: b });
							} else {
								this.__oldValueByUpdateValue__ = cache.value;
								cache.value = b;
							}
							return this.updateValue31(a, b);
						}

					}
				}
			}
		})();
		FIX_yt_player && !isChatRoomURL && FIX_SHORTCUTKEYS > 0 && (async () => {
			const _yt_player = await _yt_player_observable.obtain();
			if (!_yt_player || typeof _yt_player !== 'object') return;
			keyboardController(_yt_player);
		})();
		FIX_yt_player && !isChatRoomURL && (async () => {
			const _yt_player = await _yt_player_observable.obtain();
			if (!_yt_player || typeof _yt_player !== 'object') return;
			let keyZqQu = getZqQu(_yt_player);
			if (!keyZqQu) return;
			const g = _yt_player
			let k = keyZqQu
			const gk = g[k];
			if (typeof gk !== 'function') return;
			const gkp = gk.prototype;
			const extractKeysZqQu = () => {
				let _keyeC = '';
				try {
					gkp.stop.call(new Proxy({
						isActive: () => { }
					}, {
						set(target, prop, value) {
							if (value === 0) _keyeC = prop;
							return true;
						}
					}));
				} catch (e) { }
				if (!_keyeC) return;
				const keyeC = _keyeC;
				let keyC = '';
				let keyhj = '';
				try {
					gkp.start.call(new Proxy({
						stop: () => { },
						[keyeC]: 0,
					}, {
						get(target, prop) {
							if (prop in target) return target[prop];
							if (!keyC) {
								keyC = prop;
								return null;
							}
							else if (!keyhj) {
								keyhj = prop;
							}
						}
					}));
				} catch (e) {
					if (!keyC || !keyhj) {
						console.log(e)
					}
				}
				if (!keyC || !keyhj) return;
				let keyST = '';
				let keyj = '';
				let keyB = '';
				let keyxa = '';
				const possibleKs = new Set();
				for (const [k, v] of Object.entries(gkp)) {
					if (k === 'stop' || k === 'start' || k === 'isActive' || k === 'constructor' || k === keyeC || k === keyC || k === keyhj) {
						continue;
					}
					if (typeof v === 'function') {
						const m = /this\.(\w+)\.call\(this\.(\w+)\)/.exec(v + '');
						if (m) {
							keyST = k;
							keyj = m[1];
							keyB = m[2];
						} else {
							possibleKs.add(k);
						}
					}
				}
				if (!keyST || !keyj || !keyB) return;
				for (const k of possibleKs) {
					if (k === keyST || k === keyj || k === keyB) {
						continue;
					}
					const v = gkp[k];
					if (typeof v === 'function' && (v + '').includes(`this.stop();delete this.${keyj};delete this.${keyB}`)) {
						keyxa = k;
					}
				}
				return [keyeC, keyC, keyhj, keyST, keyj, keyB, keyxa];
			}
			const keys = extractKeysZqQu();
			if (!keys || !keys.length) return;
			const [keyeC, keyC, keyhj, keyST, keyj, keyB, keyxa] = keys;
			if (!keyeC || !keyC || !keyhj || !keyST || !keyj || !keyB || !keyxa) return;
			let disposeKeys = null;
			gkp[keyxa] = function () {
				if (!disposeKeys) {
					disposeKeys = Object.getOwnPropertyNames(this).filter(key => {
						if (key != keyeC && key != keyC && key != keyhj && key != keyST && key != keyj && key != keyB && key != keyxa) {
							const t = typeof this[key];
							return t === 'undefined' || t === 'object'
						}
						return false;
					});
				}
				for (const key of disposeKeys) {
					const v = this[key];
					if ((v || 0).length >= 1) v.length = 0;
				}
				if (this[keyeC] > 0) this.stop();
				this[keyj] = null;
				this[keyB] = null;
			};
			gkp.start = function (a) {
				if (this[keyeC] > 0) this.stop();
				const delay = void 0 !== a ? a : this[keyhj];
				this[keyeC] = window.setTimeout(this[keyC], delay);
			};
			gkp.stop = function () {
				if (this[keyeC] > 0) {
					window.clearTimeout(this[keyeC]);
					this[keyeC] = 0;
				}
			};
			gkp.isActive = function () {
				return this[keyeC] > 0;
			};
			gkp[keyST] = function () {
				this.stop();
				const fn = this[keyj];
				const obj = this[keyB];
				let skip = false;
				if (!fn) skip = true;
				else if (IGNORE_bufferhealth_CHECK && obj) {
					let m;
					if ((m = obj[keyC]) instanceof Map || (m = obj[keyj]) instanceof Map) {
						if (m.has("bufferhealth")) skip = true;
					}
				}
				if (!skip) {
					fn.call(obj);
				}
			};

		})();
		FIX_Animation_n_timeline && (async () => {
			const [timeline, Animation] = await Promise.all([timelineObservable.obtain(), animationObservable.obtain()]);
			if (!timeline || !Animation) return;
			const aniProto = Animation.prototype;
			const getXroto = (x) => {
				try {
					return x.__proto__;
				} catch (e) { }
				return null;
			}
			const timProto = getXroto(timeline);
			if (!timProto) return;
			if (
				(
					typeof timProto.getAnimations === 'function' && typeof timProto.play === 'function' &&
					typeof timProto._discardAnimations === 'function' && typeof timProto._play === 'function' &&
					typeof timProto._updateAnimationsPromises === 'function' && !timProto.nofCQ &&
					typeof aniProto._updatePromises === 'function' && !aniProto.nofYH
				)
			) {
				timProto.nofCQ = 1;
				aniProto.nofYH = 1;
				const originalAnimationsWithPromises = ((_updateAnimationsPromises) => {

					const p = Array.prototype.filter;
					let res = null;
					Array.prototype.filter = function () {
						res = this;
						return this;
					};
					_updateAnimationsPromises.call({});
					Array.prototype.filter = p;
					if (res && typeof res.length === 'number') {

						const _res = res;
						return _res;
					}
					return null;
				})(timProto._updateAnimationsPromises);
				if (!originalAnimationsWithPromises || typeof originalAnimationsWithPromises.length !== 'number') return;
				aniProto._updatePromises31 = aniProto._updatePromises;

				aniProto._updatePromises = function () {
					var oldPlayState = this._oldPlayState;
					var newPlayState = this.playState;
					if (newPlayState !== oldPlayState) {
						this._oldPlayState = newPlayState;
						if (this._readyPromise) {
							if ("idle" == newPlayState) {
								this._rejectReadyPromise();
								this._readyPromise = void 0;
							} else if ("pending" == oldPlayState) {
								this._resolveReadyPromise();
							} else if ("pending" == newPlayState) {
								this._readyPromise = void 0;
							}
						}
						if (this._finishedPromise) {
							if ("idle" == newPlayState) {
								this._rejectFinishedPromise();
								this._finishedPromise = void 0;
							} else if ("finished" == newPlayState) {
								this._resolveFinishedPromise();
							} else if ("finished" == oldPlayState) {
								this._finishedPromise = void 0;
							}
						}
					}
					return this._readyPromise || this._finishedPromise;
				};
				let restartWebAnimationsNextTickFlag = false;
				const looperMethodT = () => {
					const runnerFn = (hRes) => {
						var b = timeline;
						b.currentTime = hRes;
						b._discardAnimations();
						if (0 == b._animations.length) {
							restartWebAnimationsNextTickFlag = false;
						} else {
							getRafPromise().then(runnerFn);
						}
					}
					const restartWebAnimationsNextTick = () => {
						if (!restartWebAnimationsNextTickFlag) {
							restartWebAnimationsNextTickFlag = true;
							getRafPromise().then(runnerFn);
						}
					}
					return { restartWebAnimationsNextTick }
				};
				const looperMethodN = () => {
					const acs = document.createElement('a-f');
					acs.id = 'a-f';
					if (!document.getElementById('afscript')) {
						const style = document.createElement('style');
						style.id = 'afscript';
						style.textContent = `
				@keyFrames aF1 {
				  0% {
					order: 0;
				  }
				  100% {
					order: 1;
				  }
				}
				#a-f[id] {
				  visibility: collapse !important;
				  position: fixed !important;
				  display: block !important;
				  top: -100px !important;
				  left: -100px !important;
				  margin:0 !important;
				  padding:0 !important;
				  outline:0 !important;
				  border:0 !important;
				  z-index:-1 !important;
				  width: 0px !important;
				  height: 0px !important;
				  contain: strict !important;
				  pointer-events: none !important;
				  animation: 1ms steps(2, jump-none) 0ms infinite alternate forwards running aF1 !important;
				}
			  `;
						(document.head || document.documentElement).appendChild(style);
					}
					document.documentElement.insertBefore(acs, document.documentElement.firstChild);
					const _onanimationiteration = function (evt) {
						const hRes = evt.timeStamp;
						var b = timeline;
						b.currentTime = hRes;
						b._discardAnimations();
						if (0 == b._animations.length) {
							restartWebAnimationsNextTickFlag = false;
							acs.onanimationiteration = null;
						} else {
							acs.onanimationiteration = _onanimationiteration;
						}
					}
					const restartWebAnimationsNextTick = () => {
						if (!restartWebAnimationsNextTickFlag) {
							restartWebAnimationsNextTickFlag = true;
							acs.onanimationiteration = _onanimationiteration;
						}
					}
					return { restartWebAnimationsNextTick }
				};
				const { restartWebAnimationsNextTick } = ('onanimationiteration' in document.documentElement) ? looperMethodN() : looperMethodT();
				timProto._play = function (c) {
					c = new Animation(c, this);
					this._animations.push(c);
					restartWebAnimationsNextTick();
					c._updatePromises();
					c._animation.play();
					c._updatePromises();
					return c
				}
				const animationsWithPromisesMap = new Set(originalAnimationsWithPromises);
				originalAnimationsWithPromises.length = 0;
				originalAnimationsWithPromises.push = null;
				originalAnimationsWithPromises.splice = null;
				originalAnimationsWithPromises.slice = null;
				originalAnimationsWithPromises.indexOf = null;
				originalAnimationsWithPromises.unshift = null;
				originalAnimationsWithPromises.shift = null;
				originalAnimationsWithPromises.pop = null;
				originalAnimationsWithPromises.filter = null;
				originalAnimationsWithPromises.forEach = null;
				originalAnimationsWithPromises.map = null;
				const _updateAnimationsPromises = () => {
					animationsWithPromisesMap.forEach(c => {
						if (!c._updatePromises()) animationsWithPromisesMap.delete(c);
					});

				}
				timProto._updateAnimationsPromises31 = timProto._updateAnimationsPromises;
				timProto._updateAnimationsPromises = _updateAnimationsPromises;
				delete timProto._updateAnimationsPromises;
				Object.defineProperty(timProto, '_updateAnimationsPromises', {
					get() {
						if (animationsWithPromisesMap.size === 0) return nilFn;
						return _updateAnimationsPromises;
					},
					set(nv) {
						delete this._updateAnimationsPromises;
						this._updateAnimationsPromises = nv;
					},
					enumerable: true,
					configurable: true,
				});
				let pdFinished = Object.getOwnPropertyDescriptor(aniProto, 'finished');
				aniProto.__finished_native_get__ = pdFinished.get;
				if (typeof pdFinished.get === 'function' && !pdFinished.set && pdFinished.configurable === true && pdFinished.enumerable === true) {
					Object.defineProperty(aniProto, 'finished', {
						get() {
							this._finishedPromise || (!animationsWithPromisesMap.has(this) && animationsWithPromisesMap.add(this),
								this._finishedPromise = new Promise((resolve, reject) => {
									this._resolveFinishedPromise = function () {
										resolve(this)
									};
									this._rejectFinishedPromise = function () {
										reject({
											type: DOMException.ABORT_ERR,
											name: "AbortError"
										})
									};
								}),
								"finished" == this.playState && this._resolveFinishedPromise());
							return this._finishedPromise
						},
						set: undefined,
						enumerable: true,
						configurable: true
					});
				}
				let pdReady = Object.getOwnPropertyDescriptor(aniProto, 'ready');
				aniProto.__ready_native_get__ = pdReady.get;
				if (typeof pdReady.get === 'function' && !pdReady.set && pdReady.configurable === true && pdReady.enumerable === true) {
					Object.defineProperty(aniProto, 'ready', {
						get() {
							this._readyPromise || (!animationsWithPromisesMap.has(this) && animationsWithPromisesMap.add(this),
								this._readyPromise = new Promise((resolve, reject) => {
									this._resolveReadyPromise = function () {
										resolve(this)
									};
									this._rejectReadyPromise = function () {
										reject({
											type: DOMException.ABORT_ERR,
											name: "AbortError"
										})
									};
								}),
								"pending" !== this.playState && this._resolveReadyPromise());
							return this._readyPromise
						},
						set: undefined,
						enumerable: true,
						configurable: true
					});
				}
				if (IGNORE_bindAnimationForCustomEffect && typeof aniProto._rebuildUnderlyingAnimation === 'function' && !aniProto._rebuildUnderlyingAnimation21 && aniProto._rebuildUnderlyingAnimation.length === 0) {
					aniProto._rebuildUnderlyingAnimation21 = aniProto._rebuildUnderlyingAnimation;
					const _rebuildUnderlyingAnimation = function () {
						this.effect && this.effect._onsample && (this.effect._onsample = null);
						return this._rebuildUnderlyingAnimation21();
					}
					aniProto._rebuildUnderlyingAnimation = _rebuildUnderlyingAnimation;
				}


			}
		})();
		!isUrlInEmbed && Promise.resolve().then(() => {
			class LimitedSizeSet extends Set {
				constructor(n) {
					super();
					this.limit = n;
				}
				add(key) {
					if (!super.has(key)) {
						super.add(key);
						let n = super.size - this.limit;
						if (n > 0) {
							const iterator = super.values();
							do {
								const firstKey = iterator.next().value;
								super.delete(firstKey);
							} while (--n > 0)
						}
					}
				}
				removeAdd(key) {
					super.delete(key);
					this.add(key);
				}
			}
			const mfvContinuationRecorded = new LimitedSizeSet(8);
			const mfyContinuationIgnored = new LimitedSizeSet(8);
			let mtzlastAllowedContinuation = '';
			let mtzCount = 0;
			let mjtRecordedPrevKey = '';
			let mjtLockPreviousKey = '';
			let mbCId322 = 0;
			let mbDelayBelowNCalls = 0;
			let mpKey22 = '';
			let mpUrl22 = '';
			let mpKey21 = '';
			let mpUrl21 = '';
			async function sha1Hex(message) {
				const msgUint8 = new TextEncoder().encode(message);
				const hashBuffer = await crypto.subtle.digest("SHA-1", msgUint8);
				const hashArray = Array.from(new Uint8Array(hashBuffer));
				const hashHex = hashArray
					.map((b) => b.toString(16).padStart(2, "0"))
					.join("");
				return hashHex;
			}
			async function continuationLog(a, ...args) {
				let b = a;
				try {
					if (advanceLogging) b = await sha1Hex(a);
					let c = args.map(e => {
						return e === a ? b : e
					});
					console.log(...c)
				} catch (e) { console.warn(e) }
			}
			function copyPreviousContiuationToIgnored374(toClearRecorded) {
				if (mfvContinuationRecorded.length > 0) {
					for (const [e, d] of mfvContinuationRecorded) {
						mfyContinuationIgnored.removeAdd(e);
					}
					toClearRecorded && mfvContinuationRecorded.clear();
				}
			}
			function setup_ytTaskEmitterBehavior_TaskMgr374(taskMgr) {
				const tmProto = taskMgr.constructor.prototype;
				if (tmProto && typeof tmProto.addJob === 'function' && tmProto.addJob.length === 3 && typeof tmProto.cancelJob === 'function' && tmProto.cancelJob.length === 1) {
					if (!tmProto.addJob714) {
						tmProto.addJob714 = tmProto.addJob;
						tmProto.addJob = function (a, b, c) {
							const jobId = this.addJob714(a, b, c);
							if (jobId > 0) {
								this.__lastJobId863__ = jobId;
							}
							return jobId;
						}
					}
					if (!tmProto.cancelJob714) {
						tmProto.cancelJob714 = tmProto.cancelJob;
						tmProto.cancelJob = function (a) {
							const res = this.cancelJob714(a);
							return res;
						}
					}
				}
			}
			const FIX_avoid_incorrect_video_meta_bool = FIX_avoid_incorrect_video_meta && isPrepareCachedV && check_for_set_key_order && !isChatRoomURL;
			FIX_avoid_incorrect_video_meta_bool && whenCEDefined('ytd-video-primary-info-renderer').then(() => {
				let dummy;
				let cProto;
				dummy = document.createElement('ytd-video-primary-info-renderer');
				if (!(dummy instanceof Element)) return;
				cProto = insp(dummy).constructor.prototype;
				cProto.__getEmittorTaskMgr859__ = function () {
					let taskMgr_ = null;
					try {
						taskMgr_ = (this.ytTaskEmitterBehavior || 0).getTaskManager() || null;
					} catch (e) { }
					return taskMgr_;
				}
				if (typeof cProto.fetchUpdatedMetadata === 'function' && cProto.fetchUpdatedMetadata.length === 1 && !cProto.fetchUpdatedMetadata717) {
					cProto.fetchUpdatedMetadata717 = cProto.fetchUpdatedMetadata;
					let c_;
					cProto.fetchUpdatedMetadata718 = function (a) {
						let doImmediately = false;
						if (a && typeof a === 'string' && mjtRecordedPrevKey && mjtRecordedPrevKey === mpKey22 && a === mpKey22 && (!pageSetupVideoId || pageSetupVideoId !== mpUrl22)) {
							if (!pageSetupVideoId && videoPlayingY.videoId === mpUrl22) doImmediately = true;
						} else if (typeof a !== 'string' || mbDelayBelowNCalls > 3 || !mpKey22 || (mpKey22 === a && mpKey22 !== mjtLockPreviousKey) || (mjtLockPreviousKey && mjtLockPreviousKey !== a)) {
							doImmediately = true;
						}
						if (mbCId322) {
							clearTimeout(mbCId322);
							mbCId322 = 0;
						}
						if (doImmediately) return this.fetchUpdatedMetadata717(a);
						let delay = mjtLockPreviousKey === a ? 8000 : 800;
						mbCId322 = setTimeout(() => {
							this.fetchUpdatedMetadata717(a);
						}, delay);
						console.log('[yt-js-engine-tamer]', '5190 delayed fetchUpdatedMetadata', delay);
					}
					cProto.fetchUpdatedMetadata = function (a) {
						if (!pageSetupState) {
							if (c_) clearTimeout(c_);
							c_ = setTimeout(() => {
								this.fetchUpdatedMetadata718(a);
							}, 300);
							return;
						}
						try {
							mbDelayBelowNCalls++;
							if (arguments.length > 1 || !(a === undefined || (typeof a === 'string' && a))) {
								console.warn("CAUTION: fetchUpdatedMetadata coding might have to be updated.");
							}
							if (typeof a === 'string' && mfyContinuationIgnored.has(a)) {
								console.log('[yt-js-engine-tamer]', '5040 skip fetchUpdatedMetadata', a);
								return;
							}
							if (!a && (this.data || 0).updatedMetadataEndpoint) {
								if (mjtRecordedPrevKey && mjtLockPreviousKey !== mjtRecordedPrevKey) {
									mjtLockPreviousKey = mjtRecordedPrevKey;
									LOG_FETCHMETA_UPDATE && continuationLog(mjtLockPreviousKey, '5150 Lock Key', mjtLockPreviousKey);
								}
								mtzlastAllowedContinuation = '';
								mtzCount = 0;
								copyPreviousContiuationToIgnored374(true);
							} else if (typeof a === 'string') {
								const videoPlayingId = videoPlayingY.videoId;
								let update21 = !!pageSetupVideoId;
								if (mpKey22 === a && mpUrl22 === videoPlayingId && mpUrl22 && videoPlayingId && (!pageSetupVideoId || pageSetupVideoId === videoPlayingId)) {
									update21 = true;
								} else if (mpKey22 === a && mpUrl22 !== pageSetupVideoId) {
									LOG_FETCHMETA_UPDATE && continuationLog(mpKey22, '5060 mpUrl22 mismatched', mpKey22, mpUrl22, pageSetupVideoId || '(null)', videoPlayingId || '(null)');
									return;
								}
								if (update21) {
									mpKey21 = a;
									mpUrl21 = pageSetupVideoId || videoPlayingId;
								}
								if (!mfvContinuationRecorded.has(a)) mfvContinuationRecorded.add(a);
							}
							LOG_FETCHMETA_UPDATE && continuationLog(a, '5180 fetchUpdatedMetadata\t', a, pageSetupVideoId || '(null)', videoPlayingY.videoId || '(null)');
							return this.fetchUpdatedMetadata718(a);
						} catch (e) {
							console.log('Code Error in fetchUpdatedMetadata', e);
						}
						return this.fetchUpdatedMetadata717(a)
					}
				}
				if (typeof cProto.scheduleInitialUpdatedMetadataRequest === 'function' && cProto.scheduleInitialUpdatedMetadataRequest.length === 0 && !cProto.scheduleInitialUpdatedMetadataRequest717) {
					cProto.scheduleInitialUpdatedMetadataRequest717 = cProto.scheduleInitialUpdatedMetadataRequest;
					let mJob = null;
					cProto.scheduleInitialUpdatedMetadataRequest = function () {
						try {
							if (arguments.length > 0) {
								console.warn("CAUTION: scheduleInitialUpdatedMetadataRequest coding might have to be updated.");
							}
							mtzlastAllowedContinuation = '';
							mtzCount = 0;
							if (mbCId322) {
								clearTimeout(mbCId322);
								mbCId322 = 0;
							}
							mbDelayBelowNCalls = 0;
							copyPreviousContiuationToIgnored374(true);
							const taskMgr = this.__getEmittorTaskMgr859__();
							if (FIX_avoid_incorrect_video_meta_emitterBehavior && taskMgr && !taskMgr.addJob714 && taskMgr.addJob && taskMgr.cancelJob) setup_ytTaskEmitterBehavior_TaskMgr374(taskMgr);
							if (FIX_avoid_incorrect_video_meta_emitterBehavior && taskMgr && !taskMgr.addJob714) {
								console.log('[yt-js-engine-tamer]', 'scheduleInitialUpdatedMetadataRequest error 507');
							}
							if (taskMgr && typeof taskMgr.addLowPriorityJob === 'function' && taskMgr.addLowPriorityJob.length === 2 && typeof taskMgr.cancelJob === 'function' && taskMgr.cancelJob.length === 1) {
								let res;
								if (mJob) {
									const job = mJob;
									mJob = null;
									console.log('cancelJob', job)
									taskMgr.cancelJob(job);
								}
								let pza = taskMgr.__lastJobId863__;
								try { res = this.scheduleInitialUpdatedMetadataRequest717(); } catch (e) { }
								let pzb = taskMgr.__lastJobId863__
								if (pza !== pzb) {
									mJob = pzb;
								}
								return res;
							} else {
								console.log('[yt-js-engine-tamer]', 'scheduleInitialUpdatedMetadataRequest error 601');
							}
						} catch (e) {
							console.log('Code Error in scheduleInitialUpdatedMetadataRequest', e);
						}
						return this.scheduleInitialUpdatedMetadataRequest717();
					}
				}
			});
			FIX_avoid_incorrect_video_meta_bool && promiseForYtActionCalled.then((ytAppDom) => {
				let dummy;
				let cProto;
				dummy = ytAppDom;
				if (!(dummy instanceof Element)) return;
				cProto = insp(dummy).constructor.prototype;
				if (typeof cProto.sendServiceAjax_ === 'function' && cProto.sendServiceAjax_.length === 4 && !cProto.sendServiceAjax717_) {
					function extraArguments322(a, b, c) {
						let is = (a || 0).is;
						let videoId = ((b || 0).updatedMetadataEndpoint || 0).videoId;
						let continuation = (c || 0).continuation;
						if (typeof is !== 'string') is = null;
						if (typeof videoId !== 'string') videoId = null;
						if (typeof continuation !== 'string') continuation = null;
						return { is, videoId, continuation };
					}
					cProto.sendServiceAjax717_ = cProto.sendServiceAjax_;
					cProto.sendServiceAjax_ = function (a, b, c, d) {
						try {
							const { is, videoId, continuation } = extraArguments322(a, b, c);
							if ((videoId || continuation) && (is !== 'ytd-video-primary-info-renderer')) {
								console.warn("CAUTION: sendServiceAjax_ coding might have to be updated.");
							}
							if (pageSetupVideoId && videoId && continuation) {
								if (mpKey21 && mpUrl21 && mpKey21 === continuation && mpUrl21 !== pageSetupVideoId) {
									mfyContinuationIgnored.removeAdd(continuation);
									mfvContinuationRecorded.delete(continuation);
									return;
								}
							}
							if (mjtLockPreviousKey && mjtLockPreviousKey !== continuation && continuation) {
								copyPreviousContiuationToIgnored374(false);
								mfyContinuationIgnored.delete(continuation);
								mfvContinuationRecorded.removeAdd(continuation);
								mfyContinuationIgnored.removeAdd(mjtLockPreviousKey);
								mfvContinuationRecorded.delete(mjtLockPreviousKey);
								mjtLockPreviousKey = '';
							}
							if (mfyContinuationIgnored && continuation) {
								if (mfyContinuationIgnored.has(continuation)) {
									LOG_FETCHMETA_UPDATE && continuationLog(continuation, '5260 matched01', continuation)
									return;
								}
							}
							if (is === 'ytd-video-primary-info-renderer' && videoId && continuation && !mfvContinuationRecorded.has(continuation)) {
								mfvContinuationRecorded.add(continuation);
							}
						} catch (e) {
							console.log('Coding Error in sendServiceAjax_', e)
						}
						return this.sendServiceAjax717_(a, b, c, d);
					}
				}
				function delayClearOtherKeys(lztContinuation) {
					//
					if (lztContinuation !== mtzlastAllowedContinuation) return;
					if (lztContinuation !== mpKey21 || lztContinuation !== mpKey22) return;
					if (!mfyContinuationIgnored.size) return;
					if (mfyContinuationIgnored.size > 1) {
						LOG_FETCHMETA_UPDATE && continuationLog(lztContinuation, 'delayClearOtherKeys, current = ', lztContinuation);
					}
					mfyContinuationIgnored.forEach((value, key) => {
						if (key !== lztContinuation) {
							mfyContinuationIgnored.delete(key);
							LOG_FETCHMETA_UPDATE && continuationLog(key, 'previous continuation removed from ignored store', key);
						}
					});
				}
				if (typeof cProto.getCancellableNetworkPromise_ === 'function' && cProto.getCancellableNetworkPromise_.length === 5 && !cProto.getCancellableNetworkPromise717_) {
					cProto.getCancellableNetworkPromise717_ = cProto.getCancellableNetworkPromise_;
					cProto.getCancellableNetworkPromise_ = function (a, b, c, d, e) {
						try {
							const { is, videoId, continuation } = extraArguments322(b, c, d);
							if ((videoId || continuation) && (is !== 'ytd-video-primary-info-renderer')) {
								console.warn("CAUTION: getCancellableNetworkPromise_ coding might have to be updated.");
							}
							if (pageSetupVideoId && videoId && continuation) {
								if (mpKey21 && mpUrl21 && mpKey21 === continuation && mpUrl21 !== pageSetupVideoId) {
									mfyContinuationIgnored.removeAdd(continuation);
									mfvContinuationRecorded.delete(continuation);
									return;
								}
							}
							if (mjtLockPreviousKey && mjtLockPreviousKey !== continuation && continuation) {
								copyPreviousContiuationToIgnored374(false);
								mfyContinuationIgnored.delete(continuation);
								mfvContinuationRecorded.removeAdd(continuation);
								mfyContinuationIgnored.removeAdd(mjtLockPreviousKey);
								mfvContinuationRecorded.delete(mjtLockPreviousKey);
								mjtLockPreviousKey = '';
							}
							const lztContinuation = continuation;
							if (mfyContinuationIgnored && lztContinuation && typeof lztContinuation === 'string') {
								if (mfyContinuationIgnored.has(lztContinuation)) {
									LOG_FETCHMETA_UPDATE && continuationLog(lztContinuation, '5360 matched02', lztContinuation)
									return;
								}
							}
							if (typeof lztContinuation === 'string' && mtzlastAllowedContinuation !== lztContinuation) {
								mtzlastAllowedContinuation = lztContinuation;
								LOG_FETCHMETA_UPDATE && continuationLog(lztContinuation, '5382 Continuation sets to\t', lztContinuation, `C${mtzCount}.R${mfvContinuationRecorded.size}.I${mfyContinuationIgnored.size}`);
								mjtRecordedPrevKey = lztContinuation;
								if (mjtLockPreviousKey === lztContinuation) mjtLockPreviousKey = '';
								mtzCount = 0;
							} else if (typeof lztContinuation === 'string' && mtzlastAllowedContinuation && mtzlastAllowedContinuation === lztContinuation) {
								if (++mtzCount > 1e9) mtzCount = 1e4;
								LOG_FETCHMETA_UPDATE && continuationLog(lztContinuation, '5386 Same Continuation\t\t', lztContinuation, `C${mtzCount}.R${mfvContinuationRecorded.size}.I${mfyContinuationIgnored.size}`);
								if (mtzCount >= 3 && mfyContinuationIgnored.size > 0) {
									Promise.resolve(lztContinuation).then(delayClearOtherKeys).catch(console.warn);
								}
								if (mtzCount === 5) {
									mfvContinuationRecorded.clear();
									mfvContinuationRecorded.add(lztContinuation);
								}
							}
							if (typeof lztContinuation === 'string' && lztContinuation && (pageSetupVideoId || videoPlayingY.videoId)) {
								mpKey22 = lztContinuation;
								mpUrl22 = pageSetupVideoId || videoPlayingY.videoId;
							}
							if (mbCId322) {
								clearTimeout(mbCId322);
								mbCId322 = 0;
							}
						} catch (e) {
							console.log('Coding Error in getCancellableNetworkPromise_', e)
						}
						return this.getCancellableNetworkPromise717_(a, b, c, d, e);
					}
				}
			});
			FIX_ytdExpander_childrenChanged && !isChatRoomURL && whenCEDefined('ytd-expander').then(() => {
				let dummy;
				let cProto;
				dummy = document.createElement('ytd-expander');
				cProto = insp(dummy).constructor.prototype;
				if (fnIntegrity(cProto.initChildrenObserver, '0.48.21') && fnIntegrity(cProto.childrenChanged, '0.40.22')) {
					cProto.initChildrenObserver14 = cProto.initChildrenObserver;
					cProto.childrenChanged14 = cProto.childrenChanged;
					cProto.initChildrenObserver = function () {
						var a = this;
						this.observer = new MutationObserver(function () {
							a.childrenChanged()
						}
						);
						this.observer.observe(this.content, {
							subtree: !0,
							childList: !0,
							attributes: !0,
							characterData: !0
						});
						this.childrenChanged()
					}
						;
					cProto.childrenChanged = function () {
						if (this.alwaysToggleable) {
							this.canToggle = this.alwaysToggleable;
						} else if (!this.canToggleJobId) {
							this.canToggleJobId = 1;
							foregroundPromiseFn().then(() => {
								this.canToggleJobId = 0;
								this.calculateCanCollapse()
							})
						}
					}
					console.debug('ytd-expander-fix-childrenChanged');
				}
			});
			FIX_paper_ripple_animate && whenCEDefined('paper-ripple').then(() => {
				let dummy;
				let cProto;
				dummy = document.createElement('paper-ripple');
				cProto = insp(dummy).constructor.prototype;
				if (fnIntegrity(cProto.animate, '0.74.5')) {
					cProto.animate34 = cProto.animate;
					cProto.animate = function () {
						if (this._animating) {
							var a;
							const ripples = this.ripples;
							for (a = 0; a < ripples.length; ++a) {
								var b = ripples[a];
								b.draw();
								this.$.background.style.opacity = b.outerOpacity;
								b.isOpacityFullyDecayed && !b.isRestingAtMaxRadius && this.removeRipple(b)
							}
							if ((this.shouldKeepAnimating || 0) !== ripples.length) {
								if (!this._boundAnimate38) this._boundAnimate38 = this.animate.bind(this);
								foregroundPromiseFn().then(this._boundAnimate38);
							} else {
								this.onAnimationComplete();
							}
						}
					}
					console.debug('FIX_paper_ripple_animate')
				}
			});
			if (FIX_doIdomRender) {
				const xsetTimeout = function (f, d) {
					if (xsetTimeout.m511 === 1 && !d) {
						xsetTimeout.m511 = 2;
						xsetTimeout.m568 = f;
					} else {
						return setTimeout.apply(window, arguments)
					}
				}

				const xrequestAnimationFrame = function (f) {
					const h = `${f}`;
					if (h.startsWith("function(){setTimeout(function(){") && h.endsWith("})}")) {
						let t = null;
						xsetTimeout.m511 = 1;
						f();
						if (xsetTimeout.m511 === 2) {
							t = xsetTimeout.m568;
							xsetTimeout.m568 = null;
						}
						xsetTimeout.m511 = 0;
						if (typeof t === 'function') {
							foregroundPromiseFn().then(t);
						}
					} else if (h.includes("requestAninmationFrameResolver")) {
						foregroundPromiseFn().then(f);
					} else {
						return requestAnimationFrame.apply(window, arguments);
					}
				}
				let busy = false;
				const doIdomRender = function () {
					if (!this) return;
					if (busy) {
						return this.doIdomRender13(...arguments);
					}
					busy = true;
					const { requestAnimationFrame, setTimeout } = window;
					window.requestAnimationFrame = xrequestAnimationFrame;
					window.setTimeout = xsetTimeout;
					let r = this.doIdomRender13(...arguments);
					window.requestAnimationFrame = requestAnimationFrame;
					window.setTimeout = setTimeout;
					busy = false;
					return r;
				};
				for (const ytTag of ['ytd-lottie-player', 'yt-attributed-string', 'yt-image', 'yt-icon-shape', 'yt-button-shape', 'yt-button-view-model', 'yt-icon-badge-shape']) {
					whenCEDefined(ytTag).then(() => {
						let dummy;
						let cProto;
						dummy = document.createElement(ytTag);
						cProto = insp(dummy).constructor.prototype;
						cProto.doIdomRender13 = cProto.doIdomRender;
						cProto.doIdomRender = doIdomRender;
						if (cProto.doIdomRender13 === cProto.templatingFn) cProto.templatingFn = doIdomRender;
						console.debug('[yt-js-engine-tamer] FIX_doIdomRender', ytTag)
					});
				}
			}
			FIX_POPUP_UNIQUE_ID && whenCEDefined('ytd-popup-container').then(async () => {
				const sMap = new Map();
				const ZTa = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".split("");
				const ZT = function () {
					for (var a = Array(36), b = 0, c, d = 0; d < 36; d++)
						d == 8 || d == 13 || d == 18 || d == 23 ? a[d] = "-" : d == 14 ? a[d] = "4" : (b <= 2 && (b = 33554432 + Math.random() * 16777216 | 0),
							c = b & 15,
							b >>= 4,
							a[d] = ZTa[d == 19 ? c & 3 | 8 : c]);
					return a.join("")
				};
				const popupContainerCollection = document.getElementsByTagName('ytd-popup-container');
				const popupContainer = await observablePromise(() => {
					return popupContainerCollection[0];
				}).obtain();
				let cProto;
				cProto = insp(popupContainer).constructor.prototype;
				if (!cProto || typeof cProto.handleOpenPopupAction !== 'function' || cProto.handleOpenPopupAction3868 || cProto.handleOpenPopupAction.length !== 2) {
					console.log('FIX_POPUP_UNIQUE_ID NG')
					return;
				}
				cProto.handleOpenPopupAction3868 = cProto.handleOpenPopupAction;
				cProto.handleOpenPopupAction = function (a, b) {
					if (typeof (a || 0) === 'object' && !a.__jOdQA__) {
						a.__jOdQA__ = true;
						try {
							const h = this.hostElement;
							if (h instanceof HTMLElement_) {
								const map = h.__skme44__ = h.__skme44__ || new Map();
								let mKey = '';
								const wKey = firstObjectKey(a);
								const wObj = wKey ? a[wKey] : null;
								if (wKey && wObj && typeof (wObj.popup || 0) === 'object') {
									const pKey = firstObjectKey(wObj.popup)
									const pObj = pKey ? wObj.popup[pKey] : null;
									let contentKey = '';
									let headerKey = '';
									if (pObj && pObj.identifier && pObj.content && pObj.header) {
										contentKey = firstObjectKey(pObj.content)
										headerKey = firstObjectKey(pObj.header)
									}
									if (contentKey && headerKey) {
										mKey = `${wKey}(popupType:${wObj.popupType},popup(${pKey}(content(${contentKey}:...),header(${headerKey}:...),identifer(surface:${pObj.identifier.surface}))))`
										if (mKey) {
											if (!wObj.uniqueId) {
												for (let i = 0; i < 8; i++) {
													wObj.uniqueId = ZT();
													if (!sMap.has(wObj.uniqueId)) break;
												}
											}
											const oId = wObj.uniqueId
											let nId_ = map.get(mKey);
											if (!nId_) {
												map.set(mKey, nId_ = oId);
											}
											wObj.uniqueId = nId_ || wObj.uniqueId;
											const nId = wObj.uniqueId
											sMap.set(oId, nId);
											sMap.set(nId, nId);
											wObj.uniqueId = nId;
											pObj.targetId = nId;
											pObj.identifier.tag = nId;
											if (oId !== nId) {
												console.log('FIX_POPUP_UNIQUE_ID', oId, nId);
											}
										}
									}
								}
							}
						} catch (e) {
							console.warn(e)
						}
						try {
							const results = searchNestedObject(a, (x) => {
								if (typeof x === 'string' && x.length === 36) {
									if (/[a-zA-Z\d]{8}-[a-zA-Z\d]{4}-[a-zA-Z\d]{4}-[a-zA-Z\d]{4}-[a-zA-Z\d]{12}/.test(x)) return true;
								}
								return false;
							});
							for (const [obj, key] of results) {
								const oId = obj[key];
								const nId = sMap.get(oId);
								if (nId) obj[key] = nId;
							}
						} catch (e) {
							console.warn(e)
						}
					}
					return this.handleOpenPopupAction3868(...arguments)
				}
				console.log('FIX_POPUP_UNIQUE_ID OK')
			});
			FIX_TRANSCRIPT_SEGMENTS && !isChatRoomURL && whenCEDefined('yt-formatted-string').then(async () => {
				let dummy;
				let cProto;
				dummy = document.createElement('yt-formatted-string');
				cProto = insp(dummy).constructor.prototype;
				if (!cProto || typeof cProto.setNodeStyle_ !== 'function' || cProto.setNodeStyle17_ || cProto.setNodeStyle_.length !== 2) {
					console.log('FIX_TRANSCRIPT_SEGMENTS(2) NG');
					return;
				}
				cProto.setNodeStyle17_ = cProto.setNodeStyle_;
				cProto.setNodeStyle_ = function (a, b) {
					if (b instanceof HTMLElement_ && typeof (a || 0) === 'object') b.classList.toggle('yt-formatted-string-block-line', !!a.blockLine);
					return this.setNodeStyle17_(a, b);
				}
				console.log('FIX_TRANSCRIPT_SEGMENTS(2) OK');
			});
		});
	});
	if (isMainWindow) {
		console.groupCollapsed(
			"%cYouTube JS Engine Tamer",
			"background-color: #EDE43B ; color: #000 ; font-weight: bold ; padding: 4px ;"
		);
		console.log("Script is loaded.");
		console.log("This script changes the core mechanisms of the YouTube JS engine.");
		console.log("This script is experimental and subject to further changes.");
		console.log("This might boost your YouTube performance.");
		console.log("CAUTION: This might break your YouTube.");
		if (prepareLogs.length >= 1) {
			console.log(" =========================================================================== ");
			for (const msg of prepareLogs) {
				console.log(msg)
			}
			console.log(" =========================================================================== ");
		}
		console.groupEnd();
	}
})();
((__CONTEXT__) => {
	'use strict';
	const win = this instanceof Window ? this : window;
	const hkey_script = 'nzsxclvflluv';
	if (win[hkey_script]) throw new Error('Duplicated Userscript Calling');
	win[hkey_script] = true;
	const Promise = (async () => { })().constructor;
	const PromiseExternal = ((resolve_, reject_) => {
		const h = (resolve, reject) => { resolve_ = resolve; reject_ = reject };
		return class PromiseExternal extends Promise {
			constructor(cb = h) {
				super(cb);
				if (cb === h) {
					this.resolve = resolve_;
					this.reject = reject_;
				}
			}
		};
	})();
	const isGPUAccelerationAvailable = (() => {
		try {
			const canvas = document.createElement('canvas');
			return !!(canvas.getContext('webgl') || canvas.getContext('experimental-webgl'));
		} catch (e) {
			return false;
		}
	})();
	if (!isGPUAccelerationAvailable) {
		throw new Error('Your browser does not support GPU Acceleration. YouTube CPU Tamer by AnimationFrame is skipped.');
	}
	const timeupdateDT = (() => {
		window.__j6YiAc__ = 1;
		document.addEventListener('timeupdate', () => {
			window.__j6YiAc__ = Date.now();
		}, true);
		let kz = -1;
		try {
			kz = top.__j6YiAc__;
		} catch (e) {
		}
		return kz >= 1 ? () => top.__j6YiAc__ : () => window.__j6YiAc__;
	})();
	const cleanContext = async (win) => {
		const waitFn = requestAnimationFrame;
		try {
			let mx = 16;
			const frameId = 'vanillajs-iframe-v1'
			let frame = document.getElementById(frameId);
			let removeIframeFn = null;
			if (!frame) {
				frame = document.createElement('iframe');
				frame.id = frameId;
				const blobURL = typeof webkitCancelAnimationFrame === 'function' && typeof kagi === 'undefined' ? (frame.src = URL.createObjectURL(new Blob([], { type: 'text/html' }))) : null;
				frame.sandbox = 'allow-same-origin';
				let n = document.createElement('noscript');
				n.appendChild(frame);
				while (!document.documentElement && mx-- > 0) await new Promise(waitFn);
				const root = document.documentElement;
				root.appendChild(n);
				if (blobURL) Promise.resolve().then(() => URL.revokeObjectURL(blobURL));
				removeIframeFn = (setTimeout) => {
					const removeIframeOnDocumentReady = (e) => {
						e && win.removeEventListener("DOMContentLoaded", removeIframeOnDocumentReady, false);
						e = n;
						n = win = removeIframeFn = 0;
						setTimeout ? setTimeout(() => e.remove(), 200) : e.remove();
					}
					if (!setTimeout || document.readyState !== 'loading') {
						removeIframeOnDocumentReady();
					} else {
						win.addEventListener("DOMContentLoaded", removeIframeOnDocumentReady, false);
					}
				}
			}
			while (!frame.contentWindow && mx-- > 0) await new Promise(waitFn);
			const fc = frame.contentWindow;
			if (!fc) throw "window is not found.";
			try {
				const { requestAnimationFrame, setInterval, setTimeout, clearInterval, clearTimeout } = fc;
				const res = { requestAnimationFrame, setInterval, setTimeout, clearInterval, clearTimeout };
				for (let k in res) res[k] = res[k].bind(win);
				if (removeIframeFn) Promise.resolve(res.setTimeout).then(removeIframeFn);
				return res;
			} catch (e) {
				if (removeIframeFn) removeIframeFn();
				return null;
			}
		} catch (e) {
			console.warn(e);
			return null;
		}
	};
	cleanContext(win).then(__CONTEXT__ => {
		if (!__CONTEXT__) return null;
		const { requestAnimationFrame, setTimeout, setInterval, clearTimeout, clearInterval } = __CONTEXT__;
		let afInterupter = null;
		const getRAFHelper = () => {
			const asc = document.createElement('a-f');
			if (!('onanimationiteration' in asc)) {
				return (resolve) => requestAnimationFrame(afInterupter = resolve);
			}
			asc.id = 'a-f';
			let qr = null;
			asc.onanimationiteration = function () {
				if (qr !== null) qr = (qr(), null);
			}
			if (!document.getElementById('afscript')) {
				const style = document.createElement('style');
				style.id = 'afscript';
				style.textContent = `
			@keyFrames aF1 {
			  0% {
				order: 0;
			  }
			  100% {
				order: 1;
			  }
			}
			#a-f[id] {
			  visibility: collapse !important;
			  position: fixed !important;
			  display: block !important;
			  top: -100px !important;
			  left: -100px !important;
			  margin:0 !important;
			  padding:0 !important;
			  outline:0 !important;
			  border:0 !important;
			  z-index:-1 !important;
			  width: 0px !important;
			  height: 0px !important;
			  contain: strict !important;
			  pointer-events: none !important;
			  animation: 1ms steps(2, jump-none) 0ms infinite alternate forwards running aF1 !important;
			}
		  `;
				(document.head || document.documentElement).appendChild(style);
			}
			document.documentElement.insertBefore(asc, document.documentElement.firstChild);
			return (resolve) => (qr = afInterupter = resolve);
		};
		const rafPN = getRAFHelper();
		(() => {
			let afPromiseP, afPromiseQ;
			afPromiseP = afPromiseQ = { resolved: true };
			let afix = 0;
			const afResolve = async (rX) => {
				await new Promise(rafPN);
				rX.resolved = true;
				const t = afix = (afix & 1073741823) + 1;
				return rX.resolve(t), t;
			};
			const eFunc = async () => {
				const uP = !afPromiseP.resolved ? afPromiseP : null;
				const uQ = !afPromiseQ.resolved ? afPromiseQ : null;
				let t = 0;
				if (uP && uQ) {
					const t1 = await uP;
					const t2 = await uQ;
					t = ((t1 - t2) & 536870912) === 0 ? t1 : t2;
				} else {
					const vP = !uP ? (afPromiseP = new PromiseExternal()) : null;
					const vQ = !uQ ? (afPromiseQ = new PromiseExternal()) : null;
					if (uQ) await uQ; else if (uP) await uP;
					if (vP) t = await afResolve(vP);
					if (vQ) t = await afResolve(vQ);
				}
				return t;
			}
			const inExec = new Set();
			const wFunc = async (handler, wStore) => {
				try {
					const ct = Date.now();
					if (ct - timeupdateDT() < 800 && ct - wStore.dt < 800) {
						const cid = wStore.cid;
						inExec.add(cid);
						const t = await eFunc();
						const didNotRemove = inExec.delete(cid);
						if (!didNotRemove || t === wStore.lastExecution) return;
						wStore.lastExecution = t;
					}
					wStore.dt = ct;
					handler();
				} catch (e) {
					console.error(e);
					throw e;
				}
			};
			const sFunc = (propFunc) => {
				return (func, ms = 0, ...args) => {
					if (typeof func === 'function') {
						const wStore = { dt: Date.now() };
						return (wStore.cid = propFunc(wFunc, ms, (args.length > 0 ? func.bind(null, ...args) : func), wStore));
					} else {
						return propFunc(func, ms, ...args);
					}
				};
			};
			win.setTimeout = sFunc(setTimeout);
			win.setInterval = sFunc(setInterval);
			const dFunc = (propFunc) => {
				return (cid) => {
					if (cid) inExec.delete(cid) || propFunc(cid);
				};
			};
			win.clearTimeout = dFunc(clearTimeout);
			win.clearInterval = dFunc(clearInterval);
			try {
				win.setTimeout.toString = setTimeout.toString.bind(setTimeout);
				win.setInterval.toString = setInterval.toString.bind(setInterval);
				win.clearTimeout.toString = clearTimeout.toString.bind(clearTimeout);
				win.clearInterval.toString = clearInterval.toString.bind(clearInterval);
			} catch (e) { console.warn(e) }
		})();
		let mInterupter = null;
		setInterval(() => {
			if (mInterupter === afInterupter) {
				if (mInterupter !== null) afInterupter = mInterupter = (mInterupter(), null);
			} else {
				mInterupter = afInterupter;
			}
		}, 125);
	});
})(null);
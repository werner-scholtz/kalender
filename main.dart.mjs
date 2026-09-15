// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            AB: x0 => new Int16Array(x0),
      AC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      AD: x0 => x0.getBoundingClientRect(),
      AE: x0 => x0.matches,
      AF: x0 => x0.tiltX,
      AG: x0 => x0.index,
      AH: x0 => x0.keyCode,
      AI: () => globalThis.WeakRef,
      AJ: x0 => x0.isComposing,
      B: s => printToConsole(s),
      BB: x0 => new Uint16Array(x0),
      BC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      BD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      BE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      BF: x0 => x0.pointerType,
      BG: x0 => x0.next(),
      BH: (x0,x1) => x0.scrollIntoView(x1),
      BI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      BJ: x0 => x0.code,
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: x0 => new Int32Array(x0),
      CC: (x0,x1) => x0.querySelector(x1),
      CD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      CE: f => f.dartFunction,
      CF: x0 => x0.pointerId,
      CG: x0 => x0.value,
      CH: x0 => x0.multiViewEnabled,
      CI: (a, s, e) => a.slice(s, e),
      CJ: x0 => x0.repeat,
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      DC: (x0,x1) => x0.item(x1),
      DD: Date.now,
      DE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      DF: x0 => x0.getCoalescedEvents(),
      DG: x0 => x0.done,
      DH: (x0,x1) => x0.replaceWith(x1),
      DI: x0 => x0.pop(),
      DJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: x0 => new Uint32Array(x0),
      EC: x0 => x0.length,
      ED: (handle) => clearTimeout(handle),
      EE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      EF: (x0,x1) => x0.getModifierState(x1),
      EG: (o, m, a) => o[m].apply(o, a),
      EH: (x0,x1) => { x0.type = x1 },
      EI: secondsSinceEpoch => {
        const date = new Date(secondsSinceEpoch * 1000);
        const match = /\((.*)\)/.exec(date.toString());
        if (match == null) {
            // This should never happen on any recent browser.
            return '';
        }
        return match[1];
      },
      EJ: x0 => x0.length,
      F: () => new Error().stack,
      FB: x0 => new Float32Array(x0),
      FC: (x0,x1) => x0.querySelectorAll(x1),
      FD: (x0,x1) => x0.closest(x1),
      FE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      FF: s => s.trimLeft(),
      FG: x0 => x0.iterator,
      FH: (x0,x1) => { x0.className = x1 },
      FI: (x0,x1,x2) => x0.insertBefore(x1,x2),
      FJ: x0 => x0.getReader(),
      G: s => JSON.stringify(s),
      GB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      GC: (x0,x1) => x0.getAttribute(x1),
      GD: x0 => x0.bottom,
      GE: (o, i) => o[i],
      GF: s => s.toUpperCase(),
      GG: () => globalThis.Symbol,
      GH: (x0,x1) => { x0.tabIndex = x1 },
      GI: x0 => x0.id,
      GJ: x0 => x0.value,
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: x0 => new Float64Array(x0),
      HC: x0 => x0.remove(),
      HD: x0 => x0.top,
      HE: o => o.length,
      HF: (x0,x1) => x0.test(x1),
      HG: (x0,x1) => new Intl.Segmenter(x0,x1),
      HH: (x0,x1) => { x0.name = x1 },
      HI: x0 => x0.offsetHeight,
      HJ: x0 => x0.done,
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      IC: (x0,x1) => x0.appendChild(x1),
      ID: x0 => x0.right,
      IE: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      IF: (x0,x1) => x0[x1],
      IG: x0 => x0.Segmenter,
      IH: (x0,x1) => { x0.placeholder = x1 },
      II: x0 => x0.offsetWidth,
      IJ: x0 => x0.read(),
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: x0 => new ArrayBuffer(x0),
      JC: (x0,x1) => x0.append(x1),
      JD: x0 => x0.left,
      JE: x0 => x0.language,
      JF: x0 => x0.length,
      JG: x0 => x0.buffer,
      JH: (x0,x1) => { x0.autocomplete = x1 },
      JI: x0 => x0.stopPropagation(),
      JJ: x0 => x0.body,
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      KC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      KD: x0 => x0.clientY,
      KE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      KF: (x0,x1) => x0.exec(x1),
      KG: x0 => x0.wasmMemory,
      KH: (x0,x1) => { x0.name = x1 },
      KI: x0 => x0.disabled,
      KJ: (x0,x1) => new OffscreenCanvas(x0,x1),
      L: o => o === undefined,
      LB: (x0,x1,x2) => new DataView(x0,x1,x2),
      LC: x0 => x0.style,
      LD: x0 => x0.clientX,
      LE: () => globalThis.window.FinalizationRegistry,
      LF: x0 => x0.index,
      LG: () => globalThis.window._flutter_skwasmInstance,
      LH: (x0,x1) => { x0.placeholder = x1 },
      LI: (x0,x1) => { x0.min = x1 },
      LJ: x0 => x0.assetBase,
      M: o => String(o),
      MB: (o, p) => o[p],
      MC: x0 => x0.debugShowSemanticsNodes,
      MD: x0 => x0.changedTouches,
      ME: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      MF: x0 => x0.flags,
      MG: () => new TextDecoder(),
      MH: (x0,x1) => { x0.action = x1 },
      MI: (x0,x1) => { x0.max = x1 },
      MJ: x0 => x0.loader,
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      NC: o => o,
      ND: x0 => x0.offsetY,
      NE: x0 => new window.FinalizationRegistry(x0),
      NF: (a, s) => a.join(s),
      NG: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      NH: (x0,x1) => { x0.method = x1 },
      NI: (x0,x1) => { x0.disabled = x1 },
      NJ: () => globalThis._flutter,
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      OC: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      OD: x0 => x0.offsetX,
      OE: (x0,x1) => x0.unregister(x1),
      OF: (x0,x1) => x0.error(x1),
      OG: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      OH: (x0,x1) => { x0.noValidate = x1 },
      OI: (x0,x1) => { x0.scrollLeft = x1 },
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: o => o.byteOffset,
      PC: (x0,x1) => x0.warn(x1),
      PD: x0 => x0.type,
      PE: (x0,x1) => x0.contains(x1),
      PF: () => globalThis.console,
      PG: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      PH: (x0,x1) => x0.removeAttribute(x1),
      PI: (x0,x1) => { x0.spellcheck = x1 },
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: o => o.buffer,
      QC: x0 => x0.console,
      QD: x0 => x0.maxTouchPoints,
      QE: (s) => +s,
      QF: s => s.trimRight(),
      QG: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      QH: x0 => x0.isConnected,
      QI: (x0,x1) => { x0.disabled = x1 },
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: Function.prototype.call.bind(DataView.prototype.getUint8),
      RC: () => globalThis.window,
      RD: x0 => x0.platform,
      RE: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      RF: x0 => x0.blur(),
      RG: x0 => x0.history,
      RH: x0 => x0.click(),
      RI: (x0,x1) => x0.transferFromImageBitmap(x1),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: (b, o) => new DataView(b, o),
      SC: (o, c) => o instanceof c,
      SD: x0 => x0.body,
      SE: s => s.trim(),
      SF: x0 => x0.button,
      SG: x0 => x0.search,
      SH: (x0,x1) => x0.getElementsByClassName(x1),
      SI: (x0,x1) => x0.getContext(x1),
      T: x0 => new Promise(x0),
      TB: (b, o, l) => new DataView(b, o, l),
      TC: (string, token) => string.split(token),
      TD: () => globalThis.document,
      TE: x0 => x0.classList,
      TF: x0 => x0.innerHeight,
      TG: x0 => x0.location,
      TH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      TI: (x0,x1) => { x0.height = x1 },
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      UC: o => o instanceof Array,
      UD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      UE: x0 => x0.preventDefault(),
      UF: x0 => x0.innerWidth,
      UG: x0 => x0.pathname,
      UH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      UI: (x0,x1) => { x0.width = x1 },
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      VC: (a, i) => a[i],
      VD: x0 => x0.hasFocus(),
      VE: x0 => x0.parent,
      VF: x0 => x0.height,
      VG: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      VH: (x0,x1) => x0.dispatchEvent(x1),
      VI: x0 => x0.height,
      W: x0 => new Array(x0),
      WB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      WC: a => a.length,
      WD: x0 => x0.relatedTarget,
      WE: x0 => x0.timeStamp,
      WF: x0 => x0.width,
      WG: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      WH: (x0,x1) => x0.createEvent(x1),
      WI: x0 => x0.width,
      X: o => [o],
      XB: (t, s) => t.set(s),
      XC: x0 => x0.userAgent,
      XD: x0 => x0.shiftKey,
      XE: (x0,x1) => x0.hasAttribute(x1),
      XF: x0 => x0.clientHeight,
      XG: o => Object.keys(o),
      XH: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      XI: x0 => x0.rasterEndMilliseconds,
      Y: (o0, o1) => [o0, o1],
      YB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      YC: x0 => x0.navigator,
      YD: (decoder, codeUnits) => decoder.decode(codeUnits),
      YE: x0 => x0.buttons,
      YF: x0 => x0.clientWidth,
      YG: x0 => x0.state,
      YH: x0 => x0.readText(),
      YI: x0 => x0.rasterStartMilliseconds,
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      ZC: Function.prototype.call.bind(String.prototype.toLowerCase),
      ZD: () => new TextDecoder("utf-8", {fatal: true}),
      ZE: x0 => x0.ctrlKey,
      ZF: (x0,x1) => { x0.content = x1 },
      ZG: x0 => x0.hash,
      ZH: x0 => x0.clipboard,
      ZI: x0 => x0.imageBitmaps,
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      aC: Object.is,
      aD: () => new TextDecoder("utf-8", {fatal: false}),
      aE: x0 => x0.y,
      aF: (x0,x1) => { x0.name = x1 },
      aG: x0 => x0.state,
      aH: (x0,x1) => x0.writeText(x1),
      aI: x0 => x0.canvasKitMaximumSurfaces,
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: Function.prototype.call.bind(DataView.prototype.getUint32),
      bC: x0 => x0.vendor,
      bD: (a, i, v) => a[i] = v,
      bE: x0 => x0.x,
      bF: x0 => x0.head,
      bG: (x0,x1) => x0.go(x1),
      bH: x0 => x0.unlock(),
      bI: x0 => x0.cancel(),
      c: o => o,
      cB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      cC: (x0,x1) => x0.createTextNode(x1),
      cD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      cE: x0 => x0.scrollTop,
      cF: (x0,x1) => x0.removeChild(x1),
      cG: x0 => x0.parentElement,
      cH: (x0,x1) => x0.lock(x1),
      cI: x0 => x0.name,
      d: (o, p) => o[p],
      dB: Function.prototype.call.bind(DataView.prototype.getInt32),
      dC: (x0,x1) => { x0.id = x1 },
      dD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      dE: x0 => x0.offsetTop,
      dF: x0 => x0.firstChild,
      dG: (x0,x1) => x0.querySelectorAll(x1),
      dH: x0 => x0.orientation,
      dI: x0 => x0.abort(),
      e: () => globalThis,
      eB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      eC: (x0,x1) => { x0.nonce = x1 },
      eD: x0 => x0.visibilityState,
      eE: x0 => x0.scrollLeft,
      eF: x0 => x0.viewConstraints,
      eG: (d, digits) => d.toFixed(digits),
      eH: (x0,x1) => x0.querySelector(x1),
      eI: () => new AbortController(),
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: o => o instanceof Uint16Array,
      fC: x0 => x0.nonce,
      fD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      fE: x0 => x0.offsetLeft,
      fF: x0 => x0.hostElement,
      fG: x0 => x0.maxHeight,
      fH: (x0,x1) => { x0.title = x1 },
      fI: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: Function.prototype.call.bind(DataView.prototype.getUint16),
      gC: () => globalThis.window.flutterConfiguration,
      gD: x0 => x0.disconnect(),
      gE: x0 => x0.offsetParent,
      gF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gG: x0 => x0.maxWidth,
      gH: (x0,x1) => x0.vibrate(x1),
      gI: (x0,x1) => globalThis.fetch(x0,x1),
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: o => o instanceof Int16Array,
      hC: (x0,x1) => x0.attachShadow(x1),
      hD: x0 => new Intl.Locale(x0),
      hE: (o, p, r) => o.replace(p, () => r),
      hF: x0 => ({runApp: x0}),
      hG: x0 => x0.minHeight,
      hH: x0 => x0.arrayBuffer(),
      hI: (x0,x1) => x0.get(x1),
      i: (l, r) => l === r,
      iB: Function.prototype.call.bind(DataView.prototype.getInt16),
      iC: (x0,x1) => x0.createElement(x1),
      iD: x0 => x0.region,
      iE: (x0,x1) => { x0.lastIndex = x1 },
      iF: () => typeof dartUseDateNowForTicks !== "undefined",
      iG: x0 => x0.minWidth,
      iH: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      iI: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      j: x0 => x0.random(),
      jB: o => o instanceof Uint8ClampedArray,
      jC: x0 => x0.scale,
      jD: x0 => x0.script,
      jE: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      jF: () => Date.now(),
      jG: (x0,x1) => x0.removeProperty(x1),
      jH: x0 => x0.status,
      jI: (x0,x1) => x0.forEach(x1),
      k: o => o,
      kB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      kC: x0 => x0.visualViewport,
      kD: x0 => x0.language,
      kE: o => o instanceof RegExp,
      kF: () => 1000 * performance.now(),
      kG: (x0,x1) => x0.add(x1),
      kH: (x0,x1) => x0.fetch(x1),
      kI: x0 => x0.statusText,
      l: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      lB: Function.prototype.call.bind(DataView.prototype.setInt32),
      lC: x0 => x0.devicePixelRatio,
      lD: x0 => x0.languages,
      lE: x0 => x0.dotAll,
      lF: (x0,x1) => x0.requestAnimationFrame(x1),
      lG: x0 => x0.data,
      lH: x0 => x0.content,
      lI: x0 => x0.url,
      m: () => globalThis.Math,
      mB: Function.prototype.call.bind(DataView.prototype.setUint32),
      mC: x0 => x0.height,
      mD: (x0,x1) => x0.observe(x1),
      mE: x0 => x0.unicode,
      mF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mG: (x0,x1) => { x0.scrollTop = x1 },
      mH: x0 => x0.document,
      mI: x0 => x0.status,
      n: (x0,x1) => x0.prepend(x1),
      nB: Function.prototype.call.bind(DataView.prototype.setInt16),
      nC: x0 => x0.width,
      nD: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      nE: x0 => x0.ignoreCase,
      nF: x0 => x0.now(),
      nG: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      nH: (a, i) => a.splice(i, 1),
      nI: x0 => x0.getReader(),
      o: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      oB: Function.prototype.call.bind(DataView.prototype.setUint16),
      oC: x0 => x0.screen,
      oD: x0 => new ResizeObserver(x0),
      oE: x0 => x0.multiline,
      oF: x0 => x0.performance,
      oG: (x0,x1) => { x0.value = x1 },
      oH: a => a.pop(),
      oI: x0 => x0.read(),
      p: b => !!b,
      pB: Function.prototype.call.bind(DataView.prototype.setUint8),
      pC: (string, times) => string.repeat(times),
      pD: (x0,x1) => x0.getPropertyValue(x1),
      pE: (o, p, r) => o.replaceAll(p, () => r),
      pF: x0 => new Uint8Array(x0),
      pG: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      pH: (map, o, v) => map.set(o, v),
      pI: x0 => x0.value,
      q: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qB: Function.prototype.call.bind(DataView.prototype.setInt8),
      qC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      qD: x0 => globalThis.parseFloat(x0),
      qE: x0 => x0.deltaMode,
      qF: (x0,x1,x2) => x0.slice(x1,x2),
      qG: (x0,x1) => { x0.value = x1 },
      qH: (map, o) => map.get(o),
      qI: x0 => x0.done,
      r: (x0,x1) => x0.focus(x1),
      rB: Function.prototype.call.bind(DataView.prototype.getInt8),
      rC: x0 => x0.tabIndex,
      rD: (x0,x1) => x0.getComputedStyle(x1),
      rE: x0 => x0.deltaY,
      rF: (x0,x1) => x0.decode(x1),
      rG: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      rH: () => new WeakMap(),
      rI: x0 => x0.body,
      s: () => ({}),
      sB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      sC: (x0,x1) => x0.contains(x1),
      sD: x0 => x0.documentElement,
      sE: x0 => x0.deltaX,
      sF: (x0,x1) => x0.adoptText(x1),
      sG: x0 => x0.value,
      sH: x0 => x0.debugSkipFontRetryDelay,
      sI: x0 => x0.headers,
      t: (o, p, v) => o[p] = v,
      tB: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      tC: x0 => x0.activeElement,
      tD: x0 => x0.computedStyleMap(),
      tE: x0 => x0.wheelDeltaY,
      tF: x0 => x0.first(),
      tG: x0 => x0.selectionDirection,
      tH: (x0,x1,x2) => x0.set(x1,x2),
      tI: x0 => x0.signal,
      u: () => [],
      uB: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      uC: x0 => x0.parentNode,
      uD: (x0,x1) => x0.get(x1),
      uE: x0 => x0.wheelDeltaX,
      uF: x0 => x0.next(),
      uG: x0 => x0.selectionStart,
      uH: x0 => x0.fontFallbackBaseUrl,
      uI: x0 => x0.hostElement,
      v: (a, i) => a.push(i),
      vB: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      vC: x0 => x0.tagName,
      vD: (o, p) => p in o,
      vE: x0 => x0.key,
      vF: x0 => x0.current(),
      vG: x0 => x0.selectionEnd,
      vH: (handle) => clearInterval(handle),
      vI: x0 => x0.location,
      w: x0 => new Int8Array(x0),
      wB: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      wC: x0 => x0.target,
      wD: (x0,x1) => { x0.textContent = x1 },
      wE: x0 => x0.identifier,
      wF: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      wG: x0 => x0.value,
      wH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      wI: (x0,x1) => x0.getModifierState(x1),
      x: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      xB: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      xC: x0 => x0.clientY,
      xD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      xE: x0 => x0.touches,
      xF: x0 => x0.v8BreakIterator,
      xG: x0 => x0.selectionDirection,
      xH: () => Date.now(),
      xI: x0 => x0.metaKey,
      y: x0 => new Uint8Array(x0),
      yB: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      yC: x0 => x0.clientX,
      yD: x0 => x0.matches,
      yE: x0 => x0.pressure,
      yF: () => globalThis.Intl,
      yG: x0 => x0.selectionStart,
      yH: x0 => new WeakRef(x0),
      yI: x0 => x0.altKey,
      z: x0 => new Uint8ClampedArray(x0),
      zB: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      zC: (x0,x1,x2) => x0.setAttribute(x1,x2),
      zD: (x0,x1) => x0.matchMedia(x1),
      zE: x0 => x0.tiltY,
      zF: (x0,x1) => x0.segment(x1),
      zG: x0 => x0.selectionEnd,
      zH: x0 => x0.deref(),
      zI: x0 => x0.ctrlKey,

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}

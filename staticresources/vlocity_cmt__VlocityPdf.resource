var buffer;
var pako;
var moment;

/** 'buffer' nodejs module minified for AMD, CommonJS & `window.buffer`. browserify v3.46.1 **/
!function(t){if("object"==typeof exports)module.exports=t();else if("function"==typeof define&&define.amd)define(t);else{var e;"undefined"!=typeof window?e=window:"undefined"!=typeof global?e=global:"undefined"!=typeof self&&(e=self),e.buffer=t()}}(function(){return function t(e,n,r){function i(a,u){if(!n[a]){if(!e[a]){var s="function"==typeof require&&require;if(!u&&s)return s(a,!0);if(o)return o(a,!0);throw new Error("Cannot find module '"+a+"'")}var f=n[a]={exports:{}};e[a][0].call(f.exports,function(t){var n=e[a][1][t];return i(n?n:t)},f,f.exports,t,e,n,r)}return n[a].exports}for(var o="function"==typeof require&&require,a=0;a<r.length;a++)i(r[a]);return i}({1:[function(t,e,n){function r(t,e,n){if(!(this instanceof r))return new r(t,e,n);var i=typeof t;if("base64"===e&&"string"===i)for(t=C(t);t.length%4!==0;)t+="=";var o;if("number"===i)o=T(t);else if("string"===i)o=r.byteLength(t,e);else{if("object"!==i)throw new Error("First argument needs to be a number, array or string.");o=T(t.length)}var a;r._useTypedArrays?a=r._augment(new Uint8Array(o)):(a=this,a.length=o,a._isBuffer=!0);var u;if(r._useTypedArrays&&"number"==typeof t.byteLength)a._set(t);else if(M(t))for(u=0;o>u;u++)a[u]=r.isBuffer(t)?t.readUInt8(u):t[u];else if("string"===i)a.write(t,0,e);else if("number"===i&&!r._useTypedArrays&&!n)for(u=0;o>u;u++)a[u]=0;return a}function i(t,e,n,i){n=Number(n)||0;var o=t.length-n;i?(i=Number(i),i>o&&(i=o)):i=o;var a=e.length;R(a%2===0,"Invalid hex string"),i>a/2&&(i=a/2);for(var u=0;i>u;u++){var s=parseInt(e.substr(2*u,2),16);R(!isNaN(s),"Invalid hex string"),t[n+u]=s}return r._charsWritten=2*u,u}function o(t,e,n,i){var o=r._charsWritten=W(x(e),t,n,i);return o}function a(t,e,n,i){var o=r._charsWritten=W(F(e),t,n,i);return o}function u(t,e,n,r){return a(t,e,n,r)}function s(t,e,n,i){var o=r._charsWritten=W(j(e),t,n,i);return o}function f(t,e,n,i){var o=r._charsWritten=W(D(e),t,n,i);return o}function l(t,e,n){return X.fromByteArray(0===e&&n===t.length?t:t.slice(e,n))}function h(t,e,n){var r="",i="";n=Math.min(t.length,n);for(var o=e;n>o;o++)t[o]<=127?(r+=q(i)+String.fromCharCode(t[o]),i=""):i+="%"+t[o].toString(16);return r+q(i)}function c(t,e,n){var r="";n=Math.min(t.length,n);for(var i=e;n>i;i++)r+=String.fromCharCode(t[i]);return r}function g(t,e,n){return c(t,e,n)}function d(t,e,n){var r=t.length;(!e||0>e)&&(e=0),(!n||0>n||n>r)&&(n=r);for(var i="",o=e;n>o;o++)i+=N(t[o]);return i}function p(t,e,n){for(var r=t.slice(e,n),i="",o=0;o<r.length;o+=2)i+=String.fromCharCode(r[o]+256*r[o+1]);return i}function y(t,e,n,r){r||(R("boolean"==typeof n,"missing or invalid endian"),R(void 0!==e&&null!==e,"missing offset"),R(e+1<t.length,"Trying to read beyond buffer length"));var i=t.length;if(!(e>=i)){var o;return n?(o=t[e],i>e+1&&(o|=t[e+1]<<8)):(o=t[e]<<8,i>e+1&&(o|=t[e+1])),o}}function v(t,e,n,r){r||(R("boolean"==typeof n,"missing or invalid endian"),R(void 0!==e&&null!==e,"missing offset"),R(e+3<t.length,"Trying to read beyond buffer length"));var i=t.length;if(!(e>=i)){var o;return n?(i>e+2&&(o=t[e+2]<<16),i>e+1&&(o|=t[e+1]<<8),o|=t[e],i>e+3&&(o+=t[e+3]<<24>>>0)):(i>e+1&&(o=t[e+1]<<16),i>e+2&&(o|=t[e+2]<<8),i>e+3&&(o|=t[e+3]),o+=t[e]<<24>>>0),o}}function b(t,e,n,r){r||(R("boolean"==typeof n,"missing or invalid endian"),R(void 0!==e&&null!==e,"missing offset"),R(e+1<t.length,"Trying to read beyond buffer length"));var i=t.length;if(!(e>=i)){var o=y(t,e,n,!0),a=32768&o;return a?-1*(65535-o+1):o}}function w(t,e,n,r){r||(R("boolean"==typeof n,"missing or invalid endian"),R(void 0!==e&&null!==e,"missing offset"),R(e+3<t.length,"Trying to read beyond buffer length"));var i=t.length;if(!(e>=i)){var o=v(t,e,n,!0),a=2147483648&o;return a?-1*(4294967295-o+1):o}}function m(t,e,n,r){return r||(R("boolean"==typeof n,"missing or invalid endian"),R(e+3<t.length,"Trying to read beyond buffer length")),Y.read(t,e,n,23,4)}function E(t,e,n,r){return r||(R("boolean"==typeof n,"missing or invalid endian"),R(e+7<t.length,"Trying to read beyond buffer length")),Y.read(t,e,n,52,8)}function I(t,e,n,r,i){i||(R(void 0!==e&&null!==e,"missing value"),R("boolean"==typeof r,"missing or invalid endian"),R(void 0!==n&&null!==n,"missing offset"),R(n+1<t.length,"trying to write beyond buffer length"),O(e,65535));var o=t.length;if(!(n>=o))for(var a=0,u=Math.min(o-n,2);u>a;a++)t[n+a]=(e&255<<8*(r?a:1-a))>>>8*(r?a:1-a)}function B(t,e,n,r,i){i||(R(void 0!==e&&null!==e,"missing value"),R("boolean"==typeof r,"missing or invalid endian"),R(void 0!==n&&null!==n,"missing offset"),R(n+3<t.length,"trying to write beyond buffer length"),O(e,4294967295));var o=t.length;if(!(n>=o))for(var a=0,u=Math.min(o-n,4);u>a;a++)t[n+a]=e>>>8*(r?a:3-a)&255}function A(t,e,n,r,i){i||(R(void 0!==e&&null!==e,"missing value"),R("boolean"==typeof r,"missing or invalid endian"),R(void 0!==n&&null!==n,"missing offset"),R(n+1<t.length,"Trying to write beyond buffer length"),J(e,32767,-32768));var o=t.length;n>=o||(e>=0?I(t,e,n,r,i):I(t,65535+e+1,n,r,i))}function U(t,e,n,r,i){i||(R(void 0!==e&&null!==e,"missing value"),R("boolean"==typeof r,"missing or invalid endian"),R(void 0!==n&&null!==n,"missing offset"),R(n+3<t.length,"Trying to write beyond buffer length"),J(e,2147483647,-2147483648));var o=t.length;n>=o||(e>=0?B(t,e,n,r,i):B(t,4294967295+e+1,n,r,i))}function L(t,e,n,r,i){i||(R(void 0!==e&&null!==e,"missing value"),R("boolean"==typeof r,"missing or invalid endian"),R(void 0!==n&&null!==n,"missing offset"),R(n+3<t.length,"Trying to write beyond buffer length"),P(e,3.4028234663852886e38,-3.4028234663852886e38));var o=t.length;n>=o||Y.write(t,e,n,r,23,4)}function S(t,e,n,r,i){i||(R(void 0!==e&&null!==e,"missing value"),R("boolean"==typeof r,"missing or invalid endian"),R(void 0!==n&&null!==n,"missing offset"),R(n+7<t.length,"Trying to write beyond buffer length"),P(e,1.7976931348623157e308,-1.7976931348623157e308));var o=t.length;n>=o||Y.write(t,e,n,r,52,8)}function C(t){return t.trim?t.trim():t.replace(/^\s+|\s+$/g,"")}function _(t,e,n){return"number"!=typeof t?n:(t=~~t,t>=e?e:t>=0?t:(t+=e,t>=0?t:0))}function T(t){return t=~~Math.ceil(+t),0>t?0:t}function k(t){return(Array.isArray||function(t){return"[object Array]"===Object.prototype.toString.call(t)})(t)}function M(t){return k(t)||r.isBuffer(t)||t&&"object"==typeof t&&"number"==typeof t.length}function N(t){return 16>t?"0"+t.toString(16):t.toString(16)}function x(t){for(var e=[],n=0;n<t.length;n++){var r=t.charCodeAt(n);if(127>=r)e.push(t.charCodeAt(n));else{var i=n;r>=55296&&57343>=r&&n++;for(var o=encodeURIComponent(t.slice(i,n+1)).substr(1).split("%"),a=0;a<o.length;a++)e.push(parseInt(o[a],16))}}return e}function F(t){for(var e=[],n=0;n<t.length;n++)e.push(255&t.charCodeAt(n));return e}function D(t){for(var e,n,r,i=[],o=0;o<t.length;o++)e=t.charCodeAt(o),n=e>>8,r=e%256,i.push(r),i.push(n);return i}function j(t){return X.toByteArray(t)}function W(t,e,n,r){for(var i=0;r>i&&!(i+n>=e.length||i>=t.length);i++)e[i+n]=t[i];return i}function q(t){try{return decodeURIComponent(t)}catch(e){return String.fromCharCode(65533)}}function O(t,e){R("number"==typeof t,"cannot write a non-number as a number"),R(t>=0,"specified a negative value for writing an unsigned value"),R(e>=t,"value is larger than maximum value for type"),R(Math.floor(t)===t,"value has a fractional component")}function J(t,e,n){R("number"==typeof t,"cannot write a non-number as a number"),R(e>=t,"value larger than maximum allowed value"),R(t>=n,"value smaller than minimum allowed value"),R(Math.floor(t)===t,"value has a fractional component")}function P(t,e,n){R("number"==typeof t,"cannot write a non-number as a number"),R(e>=t,"value larger than maximum allowed value"),R(t>=n,"value smaller than minimum allowed value")}function R(t,e){if(!t)throw new Error(e||"Failed assertion")}var X=t("base64-js"),Y=t("ieee754");n.Buffer=r,n.SlowBuffer=r,n.INSPECT_MAX_BYTES=50,r.poolSize=8192,r._useTypedArrays=function(){try{var t=new ArrayBuffer(0),e=new Uint8Array(t);return e.foo=function(){return 42},42===e.foo()&&"function"==typeof e.subarray}catch(n){return!1}}(),r.isEncoding=function(t){switch(String(t).toLowerCase()){case"hex":case"utf8":case"utf-8":case"ascii":case"binary":case"base64":case"raw":case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":return!0;default:return!1}},r.isBuffer=function(t){return!(null===t||void 0===t||!t._isBuffer)},r.byteLength=function(t,e){var n;switch(t+="",e||"utf8"){case"hex":n=t.length/2;break;case"utf8":case"utf-8":n=x(t).length;break;case"ascii":case"binary":case"raw":n=t.length;break;case"base64":n=j(t).length;break;case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":n=2*t.length;break;default:throw new Error("Unknown encoding")}return n},r.concat=function(t,e){if(R(k(t),"Usage: Buffer.concat(list, [totalLength])\nlist should be an Array."),0===t.length)return new r(0);if(1===t.length)return t[0];var n;if("number"!=typeof e)for(e=0,n=0;n<t.length;n++)e+=t[n].length;var i=new r(e),o=0;for(n=0;n<t.length;n++){var a=t[n];a.copy(i,o),o+=a.length}return i},r.prototype.write=function(t,e,n,r){if(isFinite(e))isFinite(n)||(r=n,n=void 0);else{var l=r;r=e,e=n,n=l}e=Number(e)||0;var h=this.length-e;n?(n=Number(n),n>h&&(n=h)):n=h,r=String(r||"utf8").toLowerCase();var c;switch(r){case"hex":c=i(this,t,e,n);break;case"utf8":case"utf-8":c=o(this,t,e,n);break;case"ascii":c=a(this,t,e,n);break;case"binary":c=u(this,t,e,n);break;case"base64":c=s(this,t,e,n);break;case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":c=f(this,t,e,n);break;default:throw new Error("Unknown encoding")}return c},r.prototype.toString=function(t,e,n){var r=this;if(t=String(t||"utf8").toLowerCase(),e=Number(e)||0,n=void 0!==n?Number(n):n=r.length,n===e)return"";var i;switch(t){case"hex":i=d(r,e,n);break;case"utf8":case"utf-8":i=h(r,e,n);break;case"ascii":i=c(r,e,n);break;case"binary":i=g(r,e,n);break;case"base64":i=l(r,e,n);break;case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":i=p(r,e,n);break;default:throw new Error("Unknown encoding")}return i},r.prototype.toJSON=function(){return{type:"Buffer",data:Array.prototype.slice.call(this._arr||this,0)}},r.prototype.copy=function(t,e,n,i){var o=this;if(n||(n=0),i||0===i||(i=this.length),e||(e=0),i!==n&&0!==t.length&&0!==o.length){R(i>=n,"sourceEnd < sourceStart"),R(e>=0&&e<t.length,"targetStart out of bounds"),R(n>=0&&n<o.length,"sourceStart out of bounds"),R(i>=0&&i<=o.length,"sourceEnd out of bounds"),i>this.length&&(i=this.length),t.length-e<i-n&&(i=t.length-e+n);var a=i-n;if(100>a||!r._useTypedArrays)for(var u=0;a>u;u++)t[u+e]=this[u+n];else t._set(this.subarray(n,n+a),e)}},r.prototype.slice=function(t,e){var n=this.length;if(t=_(t,n,0),e=_(e,n,n),r._useTypedArrays)return r._augment(this.subarray(t,e));for(var i=e-t,o=new r(i,void 0,!0),a=0;i>a;a++)o[a]=this[a+t];return o},r.prototype.get=function(t){return console.log(".get() is deprecated. Access using array indexes instead."),this.readUInt8(t)},r.prototype.set=function(t,e){return console.log(".set() is deprecated. Access using array indexes instead."),this.writeUInt8(t,e)},r.prototype.readUInt8=function(t,e){return e||(R(void 0!==t&&null!==t,"missing offset"),R(t<this.length,"Trying to read beyond buffer length")),t>=this.length?void 0:this[t]},r.prototype.readUInt16LE=function(t,e){return y(this,t,!0,e)},r.prototype.readUInt16BE=function(t,e){return y(this,t,!1,e)},r.prototype.readUInt32LE=function(t,e){return v(this,t,!0,e)},r.prototype.readUInt32BE=function(t,e){return v(this,t,!1,e)},r.prototype.readInt8=function(t,e){if(e||(R(void 0!==t&&null!==t,"missing offset"),R(t<this.length,"Trying to read beyond buffer length")),!(t>=this.length)){var n=128&this[t];return n?-1*(255-this[t]+1):this[t]}},r.prototype.readInt16LE=function(t,e){return b(this,t,!0,e)},r.prototype.readInt16BE=function(t,e){return b(this,t,!1,e)},r.prototype.readInt32LE=function(t,e){return w(this,t,!0,e)},r.prototype.readInt32BE=function(t,e){return w(this,t,!1,e)},r.prototype.readFloatLE=function(t,e){return m(this,t,!0,e)},r.prototype.readFloatBE=function(t,e){return m(this,t,!1,e)},r.prototype.readDoubleLE=function(t,e){return E(this,t,!0,e)},r.prototype.readDoubleBE=function(t,e){return E(this,t,!1,e)},r.prototype.writeUInt8=function(t,e,n){n||(R(void 0!==t&&null!==t,"missing value"),R(void 0!==e&&null!==e,"missing offset"),R(e<this.length,"trying to write beyond buffer length"),O(t,255)),e>=this.length||(this[e]=t)},r.prototype.writeUInt16LE=function(t,e,n){I(this,t,e,!0,n)},r.prototype.writeUInt16BE=function(t,e,n){I(this,t,e,!1,n)},r.prototype.writeUInt32LE=function(t,e,n){B(this,t,e,!0,n)},r.prototype.writeUInt32BE=function(t,e,n){B(this,t,e,!1,n)},r.prototype.writeInt8=function(t,e,n){n||(R(void 0!==t&&null!==t,"missing value"),R(void 0!==e&&null!==e,"missing offset"),R(e<this.length,"Trying to write beyond buffer length"),J(t,127,-128)),e>=this.length||(t>=0?this.writeUInt8(t,e,n):this.writeUInt8(255+t+1,e,n))},r.prototype.writeInt16LE=function(t,e,n){A(this,t,e,!0,n)},r.prototype.writeInt16BE=function(t,e,n){A(this,t,e,!1,n)},r.prototype.writeInt32LE=function(t,e,n){U(this,t,e,!0,n)},r.prototype.writeInt32BE=function(t,e,n){U(this,t,e,!1,n)},r.prototype.writeFloatLE=function(t,e,n){L(this,t,e,!0,n)},r.prototype.writeFloatBE=function(t,e,n){L(this,t,e,!1,n)},r.prototype.writeDoubleLE=function(t,e,n){S(this,t,e,!0,n)},r.prototype.writeDoubleBE=function(t,e,n){S(this,t,e,!1,n)},r.prototype.fill=function(t,e,n){if(t||(t=0),e||(e=0),n||(n=this.length),"string"==typeof t&&(t=t.charCodeAt(0)),R("number"==typeof t&&!isNaN(t),"value is not a number"),R(n>=e,"end < start"),n!==e&&0!==this.length){R(e>=0&&e<this.length,"start out of bounds"),R(n>=0&&n<=this.length,"end out of bounds");for(var r=e;n>r;r++)this[r]=t}},r.prototype.inspect=function(){for(var t=[],e=this.length,r=0;e>r;r++)if(t[r]=N(this[r]),r===n.INSPECT_MAX_BYTES){t[r+1]="...";break}return"<Buffer "+t.join(" ")+">"},r.prototype.toArrayBuffer=function(){if("undefined"!=typeof Uint8Array){if(r._useTypedArrays)return new r(this).buffer;for(var t=new Uint8Array(this.length),e=0,n=t.length;n>e;e+=1)t[e]=this[e];return t.buffer}throw new Error("Buffer.toArrayBuffer not supported in this browser")};var z=r.prototype;r._augment=function(t){return t._isBuffer=!0,t._get=t.get,t._set=t.set,t.get=z.get,t.set=z.set,t.write=z.write,t.toString=z.toString,t.toLocaleString=z.toString,t.toJSON=z.toJSON,t.copy=z.copy,t.slice=z.slice,t.readUInt8=z.readUInt8,t.readUInt16LE=z.readUInt16LE,t.readUInt16BE=z.readUInt16BE,t.readUInt32LE=z.readUInt32LE,t.readUInt32BE=z.readUInt32BE,t.readInt8=z.readInt8,t.readInt16LE=z.readInt16LE,t.readInt16BE=z.readInt16BE,t.readInt32LE=z.readInt32LE,t.readInt32BE=z.readInt32BE,t.readFloatLE=z.readFloatLE,t.readFloatBE=z.readFloatBE,t.readDoubleLE=z.readDoubleLE,t.readDoubleBE=z.readDoubleBE,t.writeUInt8=z.writeUInt8,t.writeUInt16LE=z.writeUInt16LE,t.writeUInt16BE=z.writeUInt16BE,t.writeUInt32LE=z.writeUInt32LE,t.writeUInt32BE=z.writeUInt32BE,t.writeInt8=z.writeInt8,t.writeInt16LE=z.writeInt16LE,t.writeInt16BE=z.writeInt16BE,t.writeInt32LE=z.writeInt32LE,t.writeInt32BE=z.writeInt32BE,t.writeFloatLE=z.writeFloatLE,t.writeFloatBE=z.writeFloatBE,t.writeDoubleLE=z.writeDoubleLE,t.writeDoubleBE=z.writeDoubleBE,t.fill=z.fill,t.inspect=z.inspect,t.toArrayBuffer=z.toArrayBuffer,t}},{"base64-js":2,ieee754:3}],2:[function(t,e,n){var r="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";!function(t){"use strict";function e(t){var e=t.charCodeAt(0);return e===a?62:e===u?63:s>e?-1:s+10>e?e-s+26+26:l+26>e?e-l:f+26>e?e-f+26:void 0}function n(t){function n(t){f[h++]=t}var r,i,a,u,s,f;if(t.length%4>0)throw new Error("Invalid string. Length must be a multiple of 4");var l=t.length;s="="===t.charAt(l-2)?2:"="===t.charAt(l-1)?1:0,f=new o(3*t.length/4-s),a=s>0?t.length-4:t.length;var h=0;for(r=0,i=0;a>r;r+=4,i+=3)u=e(t.charAt(r))<<18|e(t.charAt(r+1))<<12|e(t.charAt(r+2))<<6|e(t.charAt(r+3)),n((16711680&u)>>16),n((65280&u)>>8),n(255&u);return 2===s?(u=e(t.charAt(r))<<2|e(t.charAt(r+1))>>4,n(255&u)):1===s&&(u=e(t.charAt(r))<<10|e(t.charAt(r+1))<<4|e(t.charAt(r+2))>>2,n(u>>8&255),n(255&u)),f}function i(t){function e(t){return r.charAt(t)}function n(t){return e(t>>18&63)+e(t>>12&63)+e(t>>6&63)+e(63&t)}var i,o,a,u=t.length%3,s="";for(i=0,a=t.length-u;a>i;i+=3)o=(t[i]<<16)+(t[i+1]<<8)+t[i+2],s+=n(o);switch(u){case 1:o=t[t.length-1],s+=e(o>>2),s+=e(o<<4&63),s+="==";break;case 2:o=(t[t.length-2]<<8)+t[t.length-1],s+=e(o>>10),s+=e(o>>4&63),s+=e(o<<2&63),s+="="}return s}var o="undefined"!=typeof Uint8Array?Uint8Array:Array,a="+".charCodeAt(0),u="/".charCodeAt(0),s="0".charCodeAt(0),f="a".charCodeAt(0),l="A".charCodeAt(0);t.toByteArray=n,t.fromByteArray=i}("undefined"==typeof n?this.base64js={}:n)},{}],3:[function(t,e,n){n.read=function(t,e,n,r,i){var o,a,u=8*i-r-1,s=(1<<u)-1,f=s>>1,l=-7,h=n?i-1:0,c=n?-1:1,g=t[e+h];for(h+=c,o=g&(1<<-l)-1,g>>=-l,l+=u;l>0;o=256*o+t[e+h],h+=c,l-=8);for(a=o&(1<<-l)-1,o>>=-l,l+=r;l>0;a=256*a+t[e+h],h+=c,l-=8);if(0===o)o=1-f;else{if(o===s)return a?0/0:1/0*(g?-1:1);a+=Math.pow(2,r),o-=f}return(g?-1:1)*a*Math.pow(2,o-r)},n.write=function(t,e,n,r,i,o){var a,u,s,f=8*o-i-1,l=(1<<f)-1,h=l>>1,c=23===i?Math.pow(2,-24)-Math.pow(2,-77):0,g=r?0:o-1,d=r?1:-1,p=0>e||0===e&&0>1/e?1:0;for(e=Math.abs(e),isNaN(e)||1/0===e?(u=isNaN(e)?1:0,a=l):(a=Math.floor(Math.log(e)/Math.LN2),e*(s=Math.pow(2,-a))<1&&(a--,s*=2),e+=a+h>=1?c/s:c*Math.pow(2,1-h),e*s>=2&&(a++,s/=2),a+h>=l?(u=0,a=l):a+h>=1?(u=(e*s-1)*Math.pow(2,i),a+=h):(u=e*Math.pow(2,h-1)*Math.pow(2,i),a=0));i>=8;t[n+g]=255&u,g+=d,u/=256,i-=8);for(a=a<<i|u,f+=i;f>0;t[n+g]=255&a,g+=d,a/=256,f-=8);t[n+g-d]|=128*p}},{}],4:[function(t,e){e.exports=t("buffer")},{buffer:1}]},{},[4])(4)});

/* pako 0.2.6 nodeca/pako */
!function(t){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=t();else if("function"==typeof define&&define.amd)define([],t);else{var e;e="undefined"!=typeof window?window:"undefined"!=typeof global?global:"undefined"!=typeof self?self:this,e.pako=t()}}(function(){return function t(e,a,i){function n(s,o){if(!a[s]){if(!e[s]){var l="function"==typeof require&&require;if(!o&&l)return l(s,!0);if(r)return r(s,!0);var h=new Error("Cannot find module '"+s+"'");throw h.code="MODULE_NOT_FOUND",h}var d=a[s]={exports:{}};e[s][0].call(d.exports,function(t){var a=e[s][1][t];return n(a?a:t)},d,d.exports,t,e,a,i)}return a[s].exports}for(var r="function"==typeof require&&require,s=0;s<i.length;s++)n(i[s]);return n}({1:[function(t,e,a){"use strict";function i(t,e){var a=new p(e);if(a.push(t,!0),a.err)throw a.msg;return a.result}function n(t,e){return e=e||{},e.raw=!0,i(t,e)}function r(t,e){return e=e||{},e.gzip=!0,i(t,e)}var s=t("./zlib/deflate.js"),o=t("./utils/common"),l=t("./utils/strings"),h=t("./zlib/messages"),d=t("./zlib/zstream"),f=Object.prototype.toString,_=0,u=4,c=0,b=1,g=-1,m=0,w=8,p=function(t){this.options=o.assign({level:g,method:w,chunkSize:16384,windowBits:15,memLevel:8,strategy:m,to:""},t||{});var e=this.options;e.raw&&e.windowBits>0?e.windowBits=-e.windowBits:e.gzip&&e.windowBits>0&&e.windowBits<16&&(e.windowBits+=16),this.err=0,this.msg="",this.ended=!1,this.chunks=[],this.strm=new d,this.strm.avail_out=0;var a=s.deflateInit2(this.strm,e.level,e.method,e.windowBits,e.memLevel,e.strategy);if(a!==c)throw new Error(h[a]);e.header&&s.deflateSetHeader(this.strm,e.header)};p.prototype.push=function(t,e){var a,i,n=this.strm,r=this.options.chunkSize;if(this.ended)return!1;i=e===~~e?e:e===!0?u:_,n.input="string"==typeof t?l.string2buf(t):"[object ArrayBuffer]"===f.call(t)?new Uint8Array(t):t,n.next_in=0,n.avail_in=n.input.length;do{if(0===n.avail_out&&(n.output=new o.Buf8(r),n.next_out=0,n.avail_out=r),a=s.deflate(n,i),a!==b&&a!==c)return this.onEnd(a),this.ended=!0,!1;(0===n.avail_out||0===n.avail_in&&i===u)&&this.onData("string"===this.options.to?l.buf2binstring(o.shrinkBuf(n.output,n.next_out)):o.shrinkBuf(n.output,n.next_out))}while((n.avail_in>0||0===n.avail_out)&&a!==b);return i===u?(a=s.deflateEnd(this.strm),this.onEnd(a),this.ended=!0,a===c):!0},p.prototype.onData=function(t){this.chunks.push(t)},p.prototype.onEnd=function(t){t===c&&(this.result="string"===this.options.to?this.chunks.join(""):o.flattenChunks(this.chunks)),this.chunks=[],this.err=t,this.msg=this.strm.msg},a.Deflate=p,a.deflate=i,a.deflateRaw=n,a.gzip=r},{"./utils/common":3,"./utils/strings":4,"./zlib/deflate.js":8,"./zlib/messages":13,"./zlib/zstream":15}],2:[function(t,e,a){"use strict";function i(t,e){var a=new u(e);if(a.push(t,!0),a.err)throw a.msg;return a.result}function n(t,e){return e=e||{},e.raw=!0,i(t,e)}var r=t("./zlib/inflate.js"),s=t("./utils/common"),o=t("./utils/strings"),l=t("./zlib/constants"),h=t("./zlib/messages"),d=t("./zlib/zstream"),f=t("./zlib/gzheader"),_=Object.prototype.toString,u=function(t){this.options=s.assign({chunkSize:16384,windowBits:0,to:""},t||{});var e=this.options;e.raw&&e.windowBits>=0&&e.windowBits<16&&(e.windowBits=-e.windowBits,0===e.windowBits&&(e.windowBits=-15)),!(e.windowBits>=0&&e.windowBits<16)||t&&t.windowBits||(e.windowBits+=32),e.windowBits>15&&e.windowBits<48&&0===(15&e.windowBits)&&(e.windowBits|=15),this.err=0,this.msg="",this.ended=!1,this.chunks=[],this.strm=new d,this.strm.avail_out=0;var a=r.inflateInit2(this.strm,e.windowBits);if(a!==l.Z_OK)throw new Error(h[a]);this.header=new f,r.inflateGetHeader(this.strm,this.header)};u.prototype.push=function(t,e){var a,i,n,h,d,f=this.strm,u=this.options.chunkSize;if(this.ended)return!1;i=e===~~e?e:e===!0?l.Z_FINISH:l.Z_NO_FLUSH,f.input="string"==typeof t?o.binstring2buf(t):"[object ArrayBuffer]"===_.call(t)?new Uint8Array(t):t,f.next_in=0,f.avail_in=f.input.length;do{if(0===f.avail_out&&(f.output=new s.Buf8(u),f.next_out=0,f.avail_out=u),a=r.inflate(f,l.Z_NO_FLUSH),a!==l.Z_STREAM_END&&a!==l.Z_OK)return this.onEnd(a),this.ended=!0,!1;f.next_out&&(0===f.avail_out||a===l.Z_STREAM_END||0===f.avail_in&&i===l.Z_FINISH)&&("string"===this.options.to?(n=o.utf8border(f.output,f.next_out),h=f.next_out-n,d=o.buf2string(f.output,n),f.next_out=h,f.avail_out=u-h,h&&s.arraySet(f.output,f.output,n,h,0),this.onData(d)):this.onData(s.shrinkBuf(f.output,f.next_out)))}while(f.avail_in>0&&a!==l.Z_STREAM_END);return a===l.Z_STREAM_END&&(i=l.Z_FINISH),i===l.Z_FINISH?(a=r.inflateEnd(this.strm),this.onEnd(a),this.ended=!0,a===l.Z_OK):!0},u.prototype.onData=function(t){this.chunks.push(t)},u.prototype.onEnd=function(t){t===l.Z_OK&&(this.result="string"===this.options.to?this.chunks.join(""):s.flattenChunks(this.chunks)),this.chunks=[],this.err=t,this.msg=this.strm.msg},a.Inflate=u,a.inflate=i,a.inflateRaw=n,a.ungzip=i},{"./utils/common":3,"./utils/strings":4,"./zlib/constants":6,"./zlib/gzheader":9,"./zlib/inflate.js":11,"./zlib/messages":13,"./zlib/zstream":15}],3:[function(t,e,a){"use strict";var i="undefined"!=typeof Uint8Array&&"undefined"!=typeof Uint16Array&&"undefined"!=typeof Int32Array;a.assign=function(t){for(var e=Array.prototype.slice.call(arguments,1);e.length;){var a=e.shift();if(a){if("object"!=typeof a)throw new TypeError(a+"must be non-object");for(var i in a)a.hasOwnProperty(i)&&(t[i]=a[i])}}return t},a.shrinkBuf=function(t,e){return t.length===e?t:t.subarray?t.subarray(0,e):(t.length=e,t)};var n={arraySet:function(t,e,a,i,n){if(e.subarray&&t.subarray)return void t.set(e.subarray(a,a+i),n);for(var r=0;i>r;r++)t[n+r]=e[a+r]},flattenChunks:function(t){var e,a,i,n,r,s;for(i=0,e=0,a=t.length;a>e;e++)i+=t[e].length;for(s=new Uint8Array(i),n=0,e=0,a=t.length;a>e;e++)r=t[e],s.set(r,n),n+=r.length;return s}},r={arraySet:function(t,e,a,i,n){for(var r=0;i>r;r++)t[n+r]=e[a+r]},flattenChunks:function(t){return[].concat.apply([],t)}};a.setTyped=function(t){t?(a.Buf8=Uint8Array,a.Buf16=Uint16Array,a.Buf32=Int32Array,a.assign(a,n)):(a.Buf8=Array,a.Buf16=Array,a.Buf32=Array,a.assign(a,r))},a.setTyped(i)},{}],4:[function(t,e,a){"use strict";function i(t,e){if(65537>e&&(t.subarray&&s||!t.subarray&&r))return String.fromCharCode.apply(null,n.shrinkBuf(t,e));for(var a="",i=0;e>i;i++)a+=String.fromCharCode(t[i]);return a}var n=t("./common"),r=!0,s=!0;try{String.fromCharCode.apply(null,[0])}catch(o){r=!1}try{String.fromCharCode.apply(null,new Uint8Array(1))}catch(o){s=!1}for(var l=new n.Buf8(256),h=0;256>h;h++)l[h]=h>=252?6:h>=248?5:h>=240?4:h>=224?3:h>=192?2:1;l[254]=l[254]=1,a.string2buf=function(t){var e,a,i,r,s,o=t.length,l=0;for(r=0;o>r;r++)a=t.charCodeAt(r),55296===(64512&a)&&o>r+1&&(i=t.charCodeAt(r+1),56320===(64512&i)&&(a=65536+(a-55296<<10)+(i-56320),r++)),l+=128>a?1:2048>a?2:65536>a?3:4;for(e=new n.Buf8(l),s=0,r=0;l>s;r++)a=t.charCodeAt(r),55296===(64512&a)&&o>r+1&&(i=t.charCodeAt(r+1),56320===(64512&i)&&(a=65536+(a-55296<<10)+(i-56320),r++)),128>a?e[s++]=a:2048>a?(e[s++]=192|a>>>6,e[s++]=128|63&a):65536>a?(e[s++]=224|a>>>12,e[s++]=128|a>>>6&63,e[s++]=128|63&a):(e[s++]=240|a>>>18,e[s++]=128|a>>>12&63,e[s++]=128|a>>>6&63,e[s++]=128|63&a);return e},a.buf2binstring=function(t){return i(t,t.length)},a.binstring2buf=function(t){for(var e=new n.Buf8(t.length),a=0,i=e.length;i>a;a++)e[a]=t.charCodeAt(a);return e},a.buf2string=function(t,e){var a,n,r,s,o=e||t.length,h=new Array(2*o);for(n=0,a=0;o>a;)if(r=t[a++],128>r)h[n++]=r;else if(s=l[r],s>4)h[n++]=65533,a+=s-1;else{for(r&=2===s?31:3===s?15:7;s>1&&o>a;)r=r<<6|63&t[a++],s--;s>1?h[n++]=65533:65536>r?h[n++]=r:(r-=65536,h[n++]=55296|r>>10&1023,h[n++]=56320|1023&r)}return i(h,n)},a.utf8border=function(t,e){var a;for(e=e||t.length,e>t.length&&(e=t.length),a=e-1;a>=0&&128===(192&t[a]);)a--;return 0>a?e:0===a?e:a+l[t[a]]>e?a:e}},{"./common":3}],5:[function(t,e){"use strict";function a(t,e,a,i){for(var n=65535&t|0,r=t>>>16&65535|0,s=0;0!==a;){s=a>2e3?2e3:a,a-=s;do n=n+e[i++]|0,r=r+n|0;while(--s);n%=65521,r%=65521}return n|r<<16|0}e.exports=a},{}],6:[function(t,e){e.exports={Z_NO_FLUSH:0,Z_PARTIAL_FLUSH:1,Z_SYNC_FLUSH:2,Z_FULL_FLUSH:3,Z_FINISH:4,Z_BLOCK:5,Z_TREES:6,Z_OK:0,Z_STREAM_END:1,Z_NEED_DICT:2,Z_ERRNO:-1,Z_STREAM_ERROR:-2,Z_DATA_ERROR:-3,Z_BUF_ERROR:-5,Z_NO_COMPRESSION:0,Z_BEST_SPEED:1,Z_BEST_COMPRESSION:9,Z_DEFAULT_COMPRESSION:-1,Z_FILTERED:1,Z_HUFFMAN_ONLY:2,Z_RLE:3,Z_FIXED:4,Z_DEFAULT_STRATEGY:0,Z_BINARY:0,Z_TEXT:1,Z_UNKNOWN:2,Z_DEFLATED:8}},{}],7:[function(t,e){"use strict";function a(){for(var t,e=[],a=0;256>a;a++){t=a;for(var i=0;8>i;i++)t=1&t?3988292384^t>>>1:t>>>1;e[a]=t}return e}function i(t,e,a,i){var r=n,s=i+a;t=-1^t;for(var o=i;s>o;o++)t=t>>>8^r[255&(t^e[o])];return-1^t}var n=a();e.exports=i},{}],8:[function(t,e,a){"use strict";function i(t,e){return t.msg=N[e],e}function n(t){return(t<<1)-(t>4?9:0)}function r(t){for(var e=t.length;--e>=0;)t[e]=0}function s(t){var e=t.state,a=e.pending;a>t.avail_out&&(a=t.avail_out),0!==a&&(A.arraySet(t.output,e.pending_buf,e.pending_out,a,t.next_out),t.next_out+=a,e.pending_out+=a,t.total_out+=a,t.avail_out-=a,e.pending-=a,0===e.pending&&(e.pending_out=0))}function o(t,e){Z._tr_flush_block(t,t.block_start>=0?t.block_start:-1,t.strstart-t.block_start,e),t.block_start=t.strstart,s(t.strm)}function l(t,e){t.pending_buf[t.pending++]=e}function h(t,e){t.pending_buf[t.pending++]=e>>>8&255,t.pending_buf[t.pending++]=255&e}function d(t,e,a,i){var n=t.avail_in;return n>i&&(n=i),0===n?0:(t.avail_in-=n,A.arraySet(e,t.input,t.next_in,n,a),1===t.state.wrap?t.adler=R(t.adler,e,n,a):2===t.state.wrap&&(t.adler=C(t.adler,e,n,a)),t.next_in+=n,t.total_in+=n,n)}function f(t,e){var a,i,n=t.max_chain_length,r=t.strstart,s=t.prev_length,o=t.nice_match,l=t.strstart>t.w_size-ht?t.strstart-(t.w_size-ht):0,h=t.window,d=t.w_mask,f=t.prev,_=t.strstart+lt,u=h[r+s-1],c=h[r+s];t.prev_length>=t.good_match&&(n>>=2),o>t.lookahead&&(o=t.lookahead);do if(a=e,h[a+s]===c&&h[a+s-1]===u&&h[a]===h[r]&&h[++a]===h[r+1]){r+=2,a++;do;while(h[++r]===h[++a]&&h[++r]===h[++a]&&h[++r]===h[++a]&&h[++r]===h[++a]&&h[++r]===h[++a]&&h[++r]===h[++a]&&h[++r]===h[++a]&&h[++r]===h[++a]&&_>r);if(i=lt-(_-r),r=_-lt,i>s){if(t.match_start=e,s=i,i>=o)break;u=h[r+s-1],c=h[r+s]}}while((e=f[e&d])>l&&0!==--n);return s<=t.lookahead?s:t.lookahead}function _(t){var e,a,i,n,r,s=t.w_size;do{if(n=t.window_size-t.lookahead-t.strstart,t.strstart>=s+(s-ht)){A.arraySet(t.window,t.window,s,s,0),t.match_start-=s,t.strstart-=s,t.block_start-=s,a=t.hash_size,e=a;do i=t.head[--e],t.head[e]=i>=s?i-s:0;while(--a);a=s,e=a;do i=t.prev[--e],t.prev[e]=i>=s?i-s:0;while(--a);n+=s}if(0===t.strm.avail_in)break;if(a=d(t.strm,t.window,t.strstart+t.lookahead,n),t.lookahead+=a,t.lookahead+t.insert>=ot)for(r=t.strstart-t.insert,t.ins_h=t.window[r],t.ins_h=(t.ins_h<<t.hash_shift^t.window[r+1])&t.hash_mask;t.insert&&(t.ins_h=(t.ins_h<<t.hash_shift^t.window[r+ot-1])&t.hash_mask,t.prev[r&t.w_mask]=t.head[t.ins_h],t.head[t.ins_h]=r,r++,t.insert--,!(t.lookahead+t.insert<ot)););}while(t.lookahead<ht&&0!==t.strm.avail_in)}function u(t,e){var a=65535;for(a>t.pending_buf_size-5&&(a=t.pending_buf_size-5);;){if(t.lookahead<=1){if(_(t),0===t.lookahead&&e===I)return wt;if(0===t.lookahead)break}t.strstart+=t.lookahead,t.lookahead=0;var i=t.block_start+a;if((0===t.strstart||t.strstart>=i)&&(t.lookahead=t.strstart-i,t.strstart=i,o(t,!1),0===t.strm.avail_out))return wt;if(t.strstart-t.block_start>=t.w_size-ht&&(o(t,!1),0===t.strm.avail_out))return wt}return t.insert=0,e===D?(o(t,!0),0===t.strm.avail_out?vt:kt):t.strstart>t.block_start&&(o(t,!1),0===t.strm.avail_out)?wt:wt}function c(t,e){for(var a,i;;){if(t.lookahead<ht){if(_(t),t.lookahead<ht&&e===I)return wt;if(0===t.lookahead)break}if(a=0,t.lookahead>=ot&&(t.ins_h=(t.ins_h<<t.hash_shift^t.window[t.strstart+ot-1])&t.hash_mask,a=t.prev[t.strstart&t.w_mask]=t.head[t.ins_h],t.head[t.ins_h]=t.strstart),0!==a&&t.strstart-a<=t.w_size-ht&&(t.match_length=f(t,a)),t.match_length>=ot)if(i=Z._tr_tally(t,t.strstart-t.match_start,t.match_length-ot),t.lookahead-=t.match_length,t.match_length<=t.max_lazy_match&&t.lookahead>=ot){t.match_length--;do t.strstart++,t.ins_h=(t.ins_h<<t.hash_shift^t.window[t.strstart+ot-1])&t.hash_mask,a=t.prev[t.strstart&t.w_mask]=t.head[t.ins_h],t.head[t.ins_h]=t.strstart;while(0!==--t.match_length);t.strstart++}else t.strstart+=t.match_length,t.match_length=0,t.ins_h=t.window[t.strstart],t.ins_h=(t.ins_h<<t.hash_shift^t.window[t.strstart+1])&t.hash_mask;else i=Z._tr_tally(t,0,t.window[t.strstart]),t.lookahead--,t.strstart++;if(i&&(o(t,!1),0===t.strm.avail_out))return wt}return t.insert=t.strstart<ot-1?t.strstart:ot-1,e===D?(o(t,!0),0===t.strm.avail_out?vt:kt):t.last_lit&&(o(t,!1),0===t.strm.avail_out)?wt:pt}function b(t,e){for(var a,i,n;;){if(t.lookahead<ht){if(_(t),t.lookahead<ht&&e===I)return wt;if(0===t.lookahead)break}if(a=0,t.lookahead>=ot&&(t.ins_h=(t.ins_h<<t.hash_shift^t.window[t.strstart+ot-1])&t.hash_mask,a=t.prev[t.strstart&t.w_mask]=t.head[t.ins_h],t.head[t.ins_h]=t.strstart),t.prev_length=t.match_length,t.prev_match=t.match_start,t.match_length=ot-1,0!==a&&t.prev_length<t.max_lazy_match&&t.strstart-a<=t.w_size-ht&&(t.match_length=f(t,a),t.match_length<=5&&(t.strategy===P||t.match_length===ot&&t.strstart-t.match_start>4096)&&(t.match_length=ot-1)),t.prev_length>=ot&&t.match_length<=t.prev_length){n=t.strstart+t.lookahead-ot,i=Z._tr_tally(t,t.strstart-1-t.prev_match,t.prev_length-ot),t.lookahead-=t.prev_length-1,t.prev_length-=2;do++t.strstart<=n&&(t.ins_h=(t.ins_h<<t.hash_shift^t.window[t.strstart+ot-1])&t.hash_mask,a=t.prev[t.strstart&t.w_mask]=t.head[t.ins_h],t.head[t.ins_h]=t.strstart);while(0!==--t.prev_length);if(t.match_available=0,t.match_length=ot-1,t.strstart++,i&&(o(t,!1),0===t.strm.avail_out))return wt}else if(t.match_available){if(i=Z._tr_tally(t,0,t.window[t.strstart-1]),i&&o(t,!1),t.strstart++,t.lookahead--,0===t.strm.avail_out)return wt}else t.match_available=1,t.strstart++,t.lookahead--}return t.match_available&&(i=Z._tr_tally(t,0,t.window[t.strstart-1]),t.match_available=0),t.insert=t.strstart<ot-1?t.strstart:ot-1,e===D?(o(t,!0),0===t.strm.avail_out?vt:kt):t.last_lit&&(o(t,!1),0===t.strm.avail_out)?wt:pt}function g(t,e){for(var a,i,n,r,s=t.window;;){if(t.lookahead<=lt){if(_(t),t.lookahead<=lt&&e===I)return wt;if(0===t.lookahead)break}if(t.match_length=0,t.lookahead>=ot&&t.strstart>0&&(n=t.strstart-1,i=s[n],i===s[++n]&&i===s[++n]&&i===s[++n])){r=t.strstart+lt;do;while(i===s[++n]&&i===s[++n]&&i===s[++n]&&i===s[++n]&&i===s[++n]&&i===s[++n]&&i===s[++n]&&i===s[++n]&&r>n);t.match_length=lt-(r-n),t.match_length>t.lookahead&&(t.match_length=t.lookahead)}if(t.match_length>=ot?(a=Z._tr_tally(t,1,t.match_length-ot),t.lookahead-=t.match_length,t.strstart+=t.match_length,t.match_length=0):(a=Z._tr_tally(t,0,t.window[t.strstart]),t.lookahead--,t.strstart++),a&&(o(t,!1),0===t.strm.avail_out))return wt}return t.insert=0,e===D?(o(t,!0),0===t.strm.avail_out?vt:kt):t.last_lit&&(o(t,!1),0===t.strm.avail_out)?wt:pt}function m(t,e){for(var a;;){if(0===t.lookahead&&(_(t),0===t.lookahead)){if(e===I)return wt;break}if(t.match_length=0,a=Z._tr_tally(t,0,t.window[t.strstart]),t.lookahead--,t.strstart++,a&&(o(t,!1),0===t.strm.avail_out))return wt}return t.insert=0,e===D?(o(t,!0),0===t.strm.avail_out?vt:kt):t.last_lit&&(o(t,!1),0===t.strm.avail_out)?wt:pt}function w(t){t.window_size=2*t.w_size,r(t.head),t.max_lazy_match=E[t.level].max_lazy,t.good_match=E[t.level].good_length,t.nice_match=E[t.level].nice_length,t.max_chain_length=E[t.level].max_chain,t.strstart=0,t.block_start=0,t.lookahead=0,t.insert=0,t.match_length=t.prev_length=ot-1,t.match_available=0,t.ins_h=0}function p(){this.strm=null,this.status=0,this.pending_buf=null,this.pending_buf_size=0,this.pending_out=0,this.pending=0,this.wrap=0,this.gzhead=null,this.gzindex=0,this.method=J,this.last_flush=-1,this.w_size=0,this.w_bits=0,this.w_mask=0,this.window=null,this.window_size=0,this.prev=null,this.head=null,this.ins_h=0,this.hash_size=0,this.hash_bits=0,this.hash_mask=0,this.hash_shift=0,this.block_start=0,this.match_length=0,this.prev_match=0,this.match_available=0,this.strstart=0,this.match_start=0,this.lookahead=0,this.prev_length=0,this.max_chain_length=0,this.max_lazy_match=0,this.level=0,this.strategy=0,this.good_match=0,this.nice_match=0,this.dyn_ltree=new A.Buf16(2*rt),this.dyn_dtree=new A.Buf16(2*(2*it+1)),this.bl_tree=new A.Buf16(2*(2*nt+1)),r(this.dyn_ltree),r(this.dyn_dtree),r(this.bl_tree),this.l_desc=null,this.d_desc=null,this.bl_desc=null,this.bl_count=new A.Buf16(st+1),this.heap=new A.Buf16(2*at+1),r(this.heap),this.heap_len=0,this.heap_max=0,this.depth=new A.Buf16(2*at+1),r(this.depth),this.l_buf=0,this.lit_bufsize=0,this.last_lit=0,this.d_buf=0,this.opt_len=0,this.static_len=0,this.matches=0,this.insert=0,this.bi_buf=0,this.bi_valid=0}function v(t){var e;return t&&t.state?(t.total_in=t.total_out=0,t.data_type=W,e=t.state,e.pending=0,e.pending_out=0,e.wrap<0&&(e.wrap=-e.wrap),e.status=e.wrap?ft:gt,t.adler=2===e.wrap?0:1,e.last_flush=I,Z._tr_init(e),F):i(t,H)}function k(t){var e=v(t);return e===F&&w(t.state),e}function x(t,e){return t&&t.state?2!==t.state.wrap?H:(t.state.gzhead=e,F):H}function y(t,e,a,n,r,s){if(!t)return H;var o=1;if(e===K&&(e=6),0>n?(o=0,n=-n):n>15&&(o=2,n-=16),1>r||r>Q||a!==J||8>n||n>15||0>e||e>9||0>s||s>G)return i(t,H);8===n&&(n=9);var l=new p;return t.state=l,l.strm=t,l.wrap=o,l.gzhead=null,l.w_bits=n,l.w_size=1<<l.w_bits,l.w_mask=l.w_size-1,l.hash_bits=r+7,l.hash_size=1<<l.hash_bits,l.hash_mask=l.hash_size-1,l.hash_shift=~~((l.hash_bits+ot-1)/ot),l.window=new A.Buf8(2*l.w_size),l.head=new A.Buf16(l.hash_size),l.prev=new A.Buf16(l.w_size),l.lit_bufsize=1<<r+6,l.pending_buf_size=4*l.lit_bufsize,l.pending_buf=new A.Buf8(l.pending_buf_size),l.d_buf=l.lit_bufsize>>1,l.l_buf=3*l.lit_bufsize,l.level=e,l.strategy=s,l.method=a,k(t)}function z(t,e){return y(t,e,J,V,$,X)}function B(t,e){var a,o,d,f;if(!t||!t.state||e>U||0>e)return t?i(t,H):H;if(o=t.state,!t.output||!t.input&&0!==t.avail_in||o.status===mt&&e!==D)return i(t,0===t.avail_out?M:H);if(o.strm=t,a=o.last_flush,o.last_flush=e,o.status===ft)if(2===o.wrap)t.adler=0,l(o,31),l(o,139),l(o,8),o.gzhead?(l(o,(o.gzhead.text?1:0)+(o.gzhead.hcrc?2:0)+(o.gzhead.extra?4:0)+(o.gzhead.name?8:0)+(o.gzhead.comment?16:0)),l(o,255&o.gzhead.time),l(o,o.gzhead.time>>8&255),l(o,o.gzhead.time>>16&255),l(o,o.gzhead.time>>24&255),l(o,9===o.level?2:o.strategy>=q||o.level<2?4:0),l(o,255&o.gzhead.os),o.gzhead.extra&&o.gzhead.extra.length&&(l(o,255&o.gzhead.extra.length),l(o,o.gzhead.extra.length>>8&255)),o.gzhead.hcrc&&(t.adler=C(t.adler,o.pending_buf,o.pending,0)),o.gzindex=0,o.status=_t):(l(o,0),l(o,0),l(o,0),l(o,0),l(o,0),l(o,9===o.level?2:o.strategy>=q||o.level<2?4:0),l(o,xt),o.status=gt);else{var _=J+(o.w_bits-8<<4)<<8,u=-1;u=o.strategy>=q||o.level<2?0:o.level<6?1:6===o.level?2:3,_|=u<<6,0!==o.strstart&&(_|=dt),_+=31-_%31,o.status=gt,h(o,_),0!==o.strstart&&(h(o,t.adler>>>16),h(o,65535&t.adler)),t.adler=1}if(o.status===_t)if(o.gzhead.extra){for(d=o.pending;o.gzindex<(65535&o.gzhead.extra.length)&&(o.pending!==o.pending_buf_size||(o.gzhead.hcrc&&o.pending>d&&(t.adler=C(t.adler,o.pending_buf,o.pending-d,d)),s(t),d=o.pending,o.pending!==o.pending_buf_size));)l(o,255&o.gzhead.extra[o.gzindex]),o.gzindex++;o.gzhead.hcrc&&o.pending>d&&(t.adler=C(t.adler,o.pending_buf,o.pending-d,d)),o.gzindex===o.gzhead.extra.length&&(o.gzindex=0,o.status=ut)}else o.status=ut;if(o.status===ut)if(o.gzhead.name){d=o.pending;do{if(o.pending===o.pending_buf_size&&(o.gzhead.hcrc&&o.pending>d&&(t.adler=C(t.adler,o.pending_buf,o.pending-d,d)),s(t),d=o.pending,o.pending===o.pending_buf_size)){f=1;break}f=o.gzindex<o.gzhead.name.length?255&o.gzhead.name.charCodeAt(o.gzindex++):0,l(o,f)}while(0!==f);o.gzhead.hcrc&&o.pending>d&&(t.adler=C(t.adler,o.pending_buf,o.pending-d,d)),0===f&&(o.gzindex=0,o.status=ct)}else o.status=ct;if(o.status===ct)if(o.gzhead.comment){d=o.pending;do{if(o.pending===o.pending_buf_size&&(o.gzhead.hcrc&&o.pending>d&&(t.adler=C(t.adler,o.pending_buf,o.pending-d,d)),s(t),d=o.pending,o.pending===o.pending_buf_size)){f=1;break}f=o.gzindex<o.gzhead.comment.length?255&o.gzhead.comment.charCodeAt(o.gzindex++):0,l(o,f)}while(0!==f);o.gzhead.hcrc&&o.pending>d&&(t.adler=C(t.adler,o.pending_buf,o.pending-d,d)),0===f&&(o.status=bt)}else o.status=bt;if(o.status===bt&&(o.gzhead.hcrc?(o.pending+2>o.pending_buf_size&&s(t),o.pending+2<=o.pending_buf_size&&(l(o,255&t.adler),l(o,t.adler>>8&255),t.adler=0,o.status=gt)):o.status=gt),0!==o.pending){if(s(t),0===t.avail_out)return o.last_flush=-1,F}else if(0===t.avail_in&&n(e)<=n(a)&&e!==D)return i(t,M);if(o.status===mt&&0!==t.avail_in)return i(t,M);if(0!==t.avail_in||0!==o.lookahead||e!==I&&o.status!==mt){var c=o.strategy===q?m(o,e):o.strategy===Y?g(o,e):E[o.level].func(o,e);if((c===vt||c===kt)&&(o.status=mt),c===wt||c===vt)return 0===t.avail_out&&(o.last_flush=-1),F;if(c===pt&&(e===O?Z._tr_align(o):e!==U&&(Z._tr_stored_block(o,0,0,!1),e===T&&(r(o.head),0===o.lookahead&&(o.strstart=0,o.block_start=0,o.insert=0))),s(t),0===t.avail_out))return o.last_flush=-1,F}return e!==D?F:o.wrap<=0?L:(2===o.wrap?(l(o,255&t.adler),l(o,t.adler>>8&255),l(o,t.adler>>16&255),l(o,t.adler>>24&255),l(o,255&t.total_in),l(o,t.total_in>>8&255),l(o,t.total_in>>16&255),l(o,t.total_in>>24&255)):(h(o,t.adler>>>16),h(o,65535&t.adler)),s(t),o.wrap>0&&(o.wrap=-o.wrap),0!==o.pending?F:L)}function S(t){var e;return t&&t.state?(e=t.state.status,e!==ft&&e!==_t&&e!==ut&&e!==ct&&e!==bt&&e!==gt&&e!==mt?i(t,H):(t.state=null,e===gt?i(t,j):F)):H}var E,A=t("../utils/common"),Z=t("./trees"),R=t("./adler32"),C=t("./crc32"),N=t("./messages"),I=0,O=1,T=3,D=4,U=5,F=0,L=1,H=-2,j=-3,M=-5,K=-1,P=1,q=2,Y=3,G=4,X=0,W=2,J=8,Q=9,V=15,$=8,tt=29,et=256,at=et+1+tt,it=30,nt=19,rt=2*at+1,st=15,ot=3,lt=258,ht=lt+ot+1,dt=32,ft=42,_t=69,ut=73,ct=91,bt=103,gt=113,mt=666,wt=1,pt=2,vt=3,kt=4,xt=3,yt=function(t,e,a,i,n){this.good_length=t,this.max_lazy=e,this.nice_length=a,this.max_chain=i,this.func=n};E=[new yt(0,0,0,0,u),new yt(4,4,8,4,c),new yt(4,5,16,8,c),new yt(4,6,32,32,c),new yt(4,4,16,16,b),new yt(8,16,32,32,b),new yt(8,16,128,128,b),new yt(8,32,128,256,b),new yt(32,128,258,1024,b),new yt(32,258,258,4096,b)],a.deflateInit=z,a.deflateInit2=y,a.deflateReset=k,a.deflateResetKeep=v,a.deflateSetHeader=x,a.deflate=B,a.deflateEnd=S,a.deflateInfo="pako deflate (from Nodeca project)"},{"../utils/common":3,"./adler32":5,"./crc32":7,"./messages":13,"./trees":14}],9:[function(t,e){"use strict";function a(){this.text=0,this.time=0,this.xflags=0,this.os=0,this.extra=null,this.extra_len=0,this.name="",this.comment="",this.hcrc=0,this.done=!1}e.exports=a},{}],10:[function(t,e){"use strict";var a=30,i=12;e.exports=function(t,e){var n,r,s,o,l,h,d,f,_,u,c,b,g,m,w,p,v,k,x,y,z,B,S,E,A;n=t.state,r=t.next_in,E=t.input,s=r+(t.avail_in-5),o=t.next_out,A=t.output,l=o-(e-t.avail_out),h=o+(t.avail_out-257),d=n.dmax,f=n.wsize,_=n.whave,u=n.wnext,c=n.window,b=n.hold,g=n.bits,m=n.lencode,w=n.distcode,p=(1<<n.lenbits)-1,v=(1<<n.distbits)-1;t:do{15>g&&(b+=E[r++]<<g,g+=8,b+=E[r++]<<g,g+=8),k=m[b&p];e:for(;;){if(x=k>>>24,b>>>=x,g-=x,x=k>>>16&255,0===x)A[o++]=65535&k;else{if(!(16&x)){if(0===(64&x)){k=m[(65535&k)+(b&(1<<x)-1)];continue e}if(32&x){n.mode=i;break t}t.msg="invalid literal/length code",n.mode=a;break t}y=65535&k,x&=15,x&&(x>g&&(b+=E[r++]<<g,g+=8),y+=b&(1<<x)-1,b>>>=x,g-=x),15>g&&(b+=E[r++]<<g,g+=8,b+=E[r++]<<g,g+=8),k=w[b&v];a:for(;;){if(x=k>>>24,b>>>=x,g-=x,x=k>>>16&255,!(16&x)){if(0===(64&x)){k=w[(65535&k)+(b&(1<<x)-1)];continue a}t.msg="invalid distance code",n.mode=a;break t}if(z=65535&k,x&=15,x>g&&(b+=E[r++]<<g,g+=8,x>g&&(b+=E[r++]<<g,g+=8)),z+=b&(1<<x)-1,z>d){t.msg="invalid distance too far back",n.mode=a;break t}if(b>>>=x,g-=x,x=o-l,z>x){if(x=z-x,x>_&&n.sane){t.msg="invalid distance too far back",n.mode=a;break t}if(B=0,S=c,0===u){if(B+=f-x,y>x){y-=x;do A[o++]=c[B++];while(--x);B=o-z,S=A}}else if(x>u){if(B+=f+u-x,x-=u,y>x){y-=x;do A[o++]=c[B++];while(--x);if(B=0,y>u){x=u,y-=x;do A[o++]=c[B++];while(--x);B=o-z,S=A}}}else if(B+=u-x,y>x){y-=x;do A[o++]=c[B++];while(--x);B=o-z,S=A}for(;y>2;)A[o++]=S[B++],A[o++]=S[B++],A[o++]=S[B++],y-=3;y&&(A[o++]=S[B++],y>1&&(A[o++]=S[B++]))}else{B=o-z;do A[o++]=A[B++],A[o++]=A[B++],A[o++]=A[B++],y-=3;while(y>2);y&&(A[o++]=A[B++],y>1&&(A[o++]=A[B++]))}break}}break}}while(s>r&&h>o);y=g>>3,r-=y,g-=y<<3,b&=(1<<g)-1,t.next_in=r,t.next_out=o,t.avail_in=s>r?5+(s-r):5-(r-s),t.avail_out=h>o?257+(h-o):257-(o-h),n.hold=b,n.bits=g}},{}],11:[function(t,e,a){"use strict";function i(t){return(t>>>24&255)+(t>>>8&65280)+((65280&t)<<8)+((255&t)<<24)}function n(){this.mode=0,this.last=!1,this.wrap=0,this.havedict=!1,this.flags=0,this.dmax=0,this.check=0,this.total=0,this.head=null,this.wbits=0,this.wsize=0,this.whave=0,this.wnext=0,this.window=null,this.hold=0,this.bits=0,this.length=0,this.offset=0,this.extra=0,this.lencode=null,this.distcode=null,this.lenbits=0,this.distbits=0,this.ncode=0,this.nlen=0,this.ndist=0,this.have=0,this.next=null,this.lens=new m.Buf16(320),this.work=new m.Buf16(288),this.lendyn=null,this.distdyn=null,this.sane=0,this.back=0,this.was=0}function r(t){var e;return t&&t.state?(e=t.state,t.total_in=t.total_out=e.total=0,t.msg="",e.wrap&&(t.adler=1&e.wrap),e.mode=D,e.last=0,e.havedict=0,e.dmax=32768,e.head=null,e.hold=0,e.bits=0,e.lencode=e.lendyn=new m.Buf32(ct),e.distcode=e.distdyn=new m.Buf32(bt),e.sane=1,e.back=-1,A):C}function s(t){var e;return t&&t.state?(e=t.state,e.wsize=0,e.whave=0,e.wnext=0,r(t)):C}function o(t,e){var a,i;return t&&t.state?(i=t.state,0>e?(a=0,e=-e):(a=(e>>4)+1,48>e&&(e&=15)),e&&(8>e||e>15)?C:(null!==i.window&&i.wbits!==e&&(i.window=null),i.wrap=a,i.wbits=e,s(t))):C}function l(t,e){var a,i;return t?(i=new n,t.state=i,i.window=null,a=o(t,e),a!==A&&(t.state=null),a):C}function h(t){return l(t,mt)}function d(t){if(wt){var e;for(b=new m.Buf32(512),g=new m.Buf32(32),e=0;144>e;)t.lens[e++]=8;for(;256>e;)t.lens[e++]=9;for(;280>e;)t.lens[e++]=7;for(;288>e;)t.lens[e++]=8;for(k(y,t.lens,0,288,b,0,t.work,{bits:9}),e=0;32>e;)t.lens[e++]=5;k(z,t.lens,0,32,g,0,t.work,{bits:5}),wt=!1}t.lencode=b,t.lenbits=9,t.distcode=g,t.distbits=5}function f(t,e,a,i){var n,r=t.state;return null===r.window&&(r.wsize=1<<r.wbits,r.wnext=0,r.whave=0,r.window=new m.Buf8(r.wsize)),i>=r.wsize?(m.arraySet(r.window,e,a-r.wsize,r.wsize,0),r.wnext=0,r.whave=r.wsize):(n=r.wsize-r.wnext,n>i&&(n=i),m.arraySet(r.window,e,a-i,n,r.wnext),i-=n,i?(m.arraySet(r.window,e,a-i,i,0),r.wnext=i,r.whave=r.wsize):(r.wnext+=n,r.wnext===r.wsize&&(r.wnext=0),r.whave<r.wsize&&(r.whave+=n))),0}function _(t,e){var a,n,r,s,o,l,h,_,u,c,b,g,ct,bt,gt,mt,wt,pt,vt,kt,xt,yt,zt,Bt,St=0,Et=new m.Buf8(4),At=[16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15];if(!t||!t.state||!t.output||!t.input&&0!==t.avail_in)return C;a=t.state,a.mode===G&&(a.mode=X),o=t.next_out,r=t.output,h=t.avail_out,s=t.next_in,n=t.input,l=t.avail_in,_=a.hold,u=a.bits,c=l,b=h,yt=A;t:for(;;)switch(a.mode){case D:if(0===a.wrap){a.mode=X;break}for(;16>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(2&a.wrap&&35615===_){a.check=0,Et[0]=255&_,Et[1]=_>>>8&255,a.check=p(a.check,Et,2,0),_=0,u=0,a.mode=U;break}if(a.flags=0,a.head&&(a.head.done=!1),!(1&a.wrap)||(((255&_)<<8)+(_>>8))%31){t.msg="incorrect header check",a.mode=ft;break}if((15&_)!==T){t.msg="unknown compression method",a.mode=ft;break}if(_>>>=4,u-=4,xt=(15&_)+8,0===a.wbits)a.wbits=xt;else if(xt>a.wbits){t.msg="invalid window size",a.mode=ft;break}a.dmax=1<<xt,t.adler=a.check=1,a.mode=512&_?q:G,_=0,u=0;break;case U:for(;16>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(a.flags=_,(255&a.flags)!==T){t.msg="unknown compression method",a.mode=ft;break}if(57344&a.flags){t.msg="unknown header flags set",a.mode=ft;break}a.head&&(a.head.text=_>>8&1),512&a.flags&&(Et[0]=255&_,Et[1]=_>>>8&255,a.check=p(a.check,Et,2,0)),_=0,u=0,a.mode=F;case F:for(;32>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}a.head&&(a.head.time=_),512&a.flags&&(Et[0]=255&_,Et[1]=_>>>8&255,Et[2]=_>>>16&255,Et[3]=_>>>24&255,a.check=p(a.check,Et,4,0)),_=0,u=0,a.mode=L;case L:for(;16>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}a.head&&(a.head.xflags=255&_,a.head.os=_>>8),512&a.flags&&(Et[0]=255&_,Et[1]=_>>>8&255,a.check=p(a.check,Et,2,0)),_=0,u=0,a.mode=H;case H:if(1024&a.flags){for(;16>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}a.length=_,a.head&&(a.head.extra_len=_),512&a.flags&&(Et[0]=255&_,Et[1]=_>>>8&255,a.check=p(a.check,Et,2,0)),_=0,u=0}else a.head&&(a.head.extra=null);a.mode=j;case j:if(1024&a.flags&&(g=a.length,g>l&&(g=l),g&&(a.head&&(xt=a.head.extra_len-a.length,a.head.extra||(a.head.extra=new Array(a.head.extra_len)),m.arraySet(a.head.extra,n,s,g,xt)),512&a.flags&&(a.check=p(a.check,n,g,s)),l-=g,s+=g,a.length-=g),a.length))break t;a.length=0,a.mode=M;case M:if(2048&a.flags){if(0===l)break t;g=0;do xt=n[s+g++],a.head&&xt&&a.length<65536&&(a.head.name+=String.fromCharCode(xt));while(xt&&l>g);if(512&a.flags&&(a.check=p(a.check,n,g,s)),l-=g,s+=g,xt)break t}else a.head&&(a.head.name=null);a.length=0,a.mode=K;case K:if(4096&a.flags){if(0===l)break t;g=0;do xt=n[s+g++],a.head&&xt&&a.length<65536&&(a.head.comment+=String.fromCharCode(xt));while(xt&&l>g);if(512&a.flags&&(a.check=p(a.check,n,g,s)),l-=g,s+=g,xt)break t}else a.head&&(a.head.comment=null);a.mode=P;case P:if(512&a.flags){for(;16>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(_!==(65535&a.check)){t.msg="header crc mismatch",a.mode=ft;break}_=0,u=0}a.head&&(a.head.hcrc=a.flags>>9&1,a.head.done=!0),t.adler=a.check=0,a.mode=G;break;case q:for(;32>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}t.adler=a.check=i(_),_=0,u=0,a.mode=Y;case Y:if(0===a.havedict)return t.next_out=o,t.avail_out=h,t.next_in=s,t.avail_in=l,a.hold=_,a.bits=u,R;t.adler=a.check=1,a.mode=G;case G:if(e===S||e===E)break t;case X:if(a.last){_>>>=7&u,u-=7&u,a.mode=lt;break}for(;3>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}switch(a.last=1&_,_>>>=1,u-=1,3&_){case 0:a.mode=W;break;case 1:if(d(a),a.mode=et,e===E){_>>>=2,u-=2;break t}break;case 2:a.mode=V;break;case 3:t.msg="invalid block type",a.mode=ft}_>>>=2,u-=2;break;case W:for(_>>>=7&u,u-=7&u;32>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if((65535&_)!==(_>>>16^65535)){t.msg="invalid stored block lengths",a.mode=ft;break}if(a.length=65535&_,_=0,u=0,a.mode=J,e===E)break t;case J:a.mode=Q;case Q:if(g=a.length){if(g>l&&(g=l),g>h&&(g=h),0===g)break t;m.arraySet(r,n,s,g,o),l-=g,s+=g,h-=g,o+=g,a.length-=g;break}a.mode=G;break;case V:for(;14>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(a.nlen=(31&_)+257,_>>>=5,u-=5,a.ndist=(31&_)+1,_>>>=5,u-=5,a.ncode=(15&_)+4,_>>>=4,u-=4,a.nlen>286||a.ndist>30){t.msg="too many length or distance symbols",a.mode=ft;break}a.have=0,a.mode=$;case $:for(;a.have<a.ncode;){for(;3>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}a.lens[At[a.have++]]=7&_,_>>>=3,u-=3}for(;a.have<19;)a.lens[At[a.have++]]=0;if(a.lencode=a.lendyn,a.lenbits=7,zt={bits:a.lenbits},yt=k(x,a.lens,0,19,a.lencode,0,a.work,zt),a.lenbits=zt.bits,yt){t.msg="invalid code lengths set",a.mode=ft;break}a.have=0,a.mode=tt;case tt:for(;a.have<a.nlen+a.ndist;){for(;St=a.lencode[_&(1<<a.lenbits)-1],gt=St>>>24,mt=St>>>16&255,wt=65535&St,!(u>=gt);){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(16>wt)_>>>=gt,u-=gt,a.lens[a.have++]=wt;else{if(16===wt){for(Bt=gt+2;Bt>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(_>>>=gt,u-=gt,0===a.have){t.msg="invalid bit length repeat",a.mode=ft;break}xt=a.lens[a.have-1],g=3+(3&_),_>>>=2,u-=2}else if(17===wt){for(Bt=gt+3;Bt>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}_>>>=gt,u-=gt,xt=0,g=3+(7&_),_>>>=3,u-=3}else{for(Bt=gt+7;Bt>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}_>>>=gt,u-=gt,xt=0,g=11+(127&_),_>>>=7,u-=7}if(a.have+g>a.nlen+a.ndist){t.msg="invalid bit length repeat",a.mode=ft;break}for(;g--;)a.lens[a.have++]=xt}}if(a.mode===ft)break;if(0===a.lens[256]){t.msg="invalid code -- missing end-of-block",a.mode=ft;break}if(a.lenbits=9,zt={bits:a.lenbits},yt=k(y,a.lens,0,a.nlen,a.lencode,0,a.work,zt),a.lenbits=zt.bits,yt){t.msg="invalid literal/lengths set",a.mode=ft;break}if(a.distbits=6,a.distcode=a.distdyn,zt={bits:a.distbits},yt=k(z,a.lens,a.nlen,a.ndist,a.distcode,0,a.work,zt),
a.distbits=zt.bits,yt){t.msg="invalid distances set",a.mode=ft;break}if(a.mode=et,e===E)break t;case et:a.mode=at;case at:if(l>=6&&h>=258){t.next_out=o,t.avail_out=h,t.next_in=s,t.avail_in=l,a.hold=_,a.bits=u,v(t,b),o=t.next_out,r=t.output,h=t.avail_out,s=t.next_in,n=t.input,l=t.avail_in,_=a.hold,u=a.bits,a.mode===G&&(a.back=-1);break}for(a.back=0;St=a.lencode[_&(1<<a.lenbits)-1],gt=St>>>24,mt=St>>>16&255,wt=65535&St,!(u>=gt);){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(mt&&0===(240&mt)){for(pt=gt,vt=mt,kt=wt;St=a.lencode[kt+((_&(1<<pt+vt)-1)>>pt)],gt=St>>>24,mt=St>>>16&255,wt=65535&St,!(u>=pt+gt);){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}_>>>=pt,u-=pt,a.back+=pt}if(_>>>=gt,u-=gt,a.back+=gt,a.length=wt,0===mt){a.mode=ot;break}if(32&mt){a.back=-1,a.mode=G;break}if(64&mt){t.msg="invalid literal/length code",a.mode=ft;break}a.extra=15&mt,a.mode=it;case it:if(a.extra){for(Bt=a.extra;Bt>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}a.length+=_&(1<<a.extra)-1,_>>>=a.extra,u-=a.extra,a.back+=a.extra}a.was=a.length,a.mode=nt;case nt:for(;St=a.distcode[_&(1<<a.distbits)-1],gt=St>>>24,mt=St>>>16&255,wt=65535&St,!(u>=gt);){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(0===(240&mt)){for(pt=gt,vt=mt,kt=wt;St=a.distcode[kt+((_&(1<<pt+vt)-1)>>pt)],gt=St>>>24,mt=St>>>16&255,wt=65535&St,!(u>=pt+gt);){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}_>>>=pt,u-=pt,a.back+=pt}if(_>>>=gt,u-=gt,a.back+=gt,64&mt){t.msg="invalid distance code",a.mode=ft;break}a.offset=wt,a.extra=15&mt,a.mode=rt;case rt:if(a.extra){for(Bt=a.extra;Bt>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}a.offset+=_&(1<<a.extra)-1,_>>>=a.extra,u-=a.extra,a.back+=a.extra}if(a.offset>a.dmax){t.msg="invalid distance too far back",a.mode=ft;break}a.mode=st;case st:if(0===h)break t;if(g=b-h,a.offset>g){if(g=a.offset-g,g>a.whave&&a.sane){t.msg="invalid distance too far back",a.mode=ft;break}g>a.wnext?(g-=a.wnext,ct=a.wsize-g):ct=a.wnext-g,g>a.length&&(g=a.length),bt=a.window}else bt=r,ct=o-a.offset,g=a.length;g>h&&(g=h),h-=g,a.length-=g;do r[o++]=bt[ct++];while(--g);0===a.length&&(a.mode=at);break;case ot:if(0===h)break t;r[o++]=a.length,h--,a.mode=at;break;case lt:if(a.wrap){for(;32>u;){if(0===l)break t;l--,_|=n[s++]<<u,u+=8}if(b-=h,t.total_out+=b,a.total+=b,b&&(t.adler=a.check=a.flags?p(a.check,r,b,o-b):w(a.check,r,b,o-b)),b=h,(a.flags?_:i(_))!==a.check){t.msg="incorrect data check",a.mode=ft;break}_=0,u=0}a.mode=ht;case ht:if(a.wrap&&a.flags){for(;32>u;){if(0===l)break t;l--,_+=n[s++]<<u,u+=8}if(_!==(4294967295&a.total)){t.msg="incorrect length check",a.mode=ft;break}_=0,u=0}a.mode=dt;case dt:yt=Z;break t;case ft:yt=N;break t;case _t:return I;case ut:default:return C}return t.next_out=o,t.avail_out=h,t.next_in=s,t.avail_in=l,a.hold=_,a.bits=u,(a.wsize||b!==t.avail_out&&a.mode<ft&&(a.mode<lt||e!==B))&&f(t,t.output,t.next_out,b-t.avail_out)?(a.mode=_t,I):(c-=t.avail_in,b-=t.avail_out,t.total_in+=c,t.total_out+=b,a.total+=b,a.wrap&&b&&(t.adler=a.check=a.flags?p(a.check,r,b,t.next_out-b):w(a.check,r,b,t.next_out-b)),t.data_type=a.bits+(a.last?64:0)+(a.mode===G?128:0)+(a.mode===et||a.mode===J?256:0),(0===c&&0===b||e===B)&&yt===A&&(yt=O),yt)}function u(t){if(!t||!t.state)return C;var e=t.state;return e.window&&(e.window=null),t.state=null,A}function c(t,e){var a;return t&&t.state?(a=t.state,0===(2&a.wrap)?C:(a.head=e,e.done=!1,A)):C}var b,g,m=t("../utils/common"),w=t("./adler32"),p=t("./crc32"),v=t("./inffast"),k=t("./inftrees"),x=0,y=1,z=2,B=4,S=5,E=6,A=0,Z=1,R=2,C=-2,N=-3,I=-4,O=-5,T=8,D=1,U=2,F=3,L=4,H=5,j=6,M=7,K=8,P=9,q=10,Y=11,G=12,X=13,W=14,J=15,Q=16,V=17,$=18,tt=19,et=20,at=21,it=22,nt=23,rt=24,st=25,ot=26,lt=27,ht=28,dt=29,ft=30,_t=31,ut=32,ct=852,bt=592,gt=15,mt=gt,wt=!0;a.inflateReset=s,a.inflateReset2=o,a.inflateResetKeep=r,a.inflateInit=h,a.inflateInit2=l,a.inflate=_,a.inflateEnd=u,a.inflateGetHeader=c,a.inflateInfo="pako inflate (from Nodeca project)"},{"../utils/common":3,"./adler32":5,"./crc32":7,"./inffast":10,"./inftrees":12}],12:[function(t,e){"use strict";var a=t("../utils/common"),i=15,n=852,r=592,s=0,o=1,l=2,h=[3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258,0,0],d=[16,16,16,16,16,16,16,16,17,17,17,17,18,18,18,18,19,19,19,19,20,20,20,20,21,21,21,21,16,72,78],f=[1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577,0,0],_=[16,16,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28,29,29,64,64];e.exports=function(t,e,u,c,b,g,m,w){var p,v,k,x,y,z,B,S,E,A=w.bits,Z=0,R=0,C=0,N=0,I=0,O=0,T=0,D=0,U=0,F=0,L=null,H=0,j=new a.Buf16(i+1),M=new a.Buf16(i+1),K=null,P=0;for(Z=0;i>=Z;Z++)j[Z]=0;for(R=0;c>R;R++)j[e[u+R]]++;for(I=A,N=i;N>=1&&0===j[N];N--);if(I>N&&(I=N),0===N)return b[g++]=20971520,b[g++]=20971520,w.bits=1,0;for(C=1;N>C&&0===j[C];C++);for(C>I&&(I=C),D=1,Z=1;i>=Z;Z++)if(D<<=1,D-=j[Z],0>D)return-1;if(D>0&&(t===s||1!==N))return-1;for(M[1]=0,Z=1;i>Z;Z++)M[Z+1]=M[Z]+j[Z];for(R=0;c>R;R++)0!==e[u+R]&&(m[M[e[u+R]]++]=R);if(t===s?(L=K=m,z=19):t===o?(L=h,H-=257,K=d,P-=257,z=256):(L=f,K=_,z=-1),F=0,R=0,Z=C,y=g,O=I,T=0,k=-1,U=1<<I,x=U-1,t===o&&U>n||t===l&&U>r)return 1;for(var q=0;;){q++,B=Z-T,m[R]<z?(S=0,E=m[R]):m[R]>z?(S=K[P+m[R]],E=L[H+m[R]]):(S=96,E=0),p=1<<Z-T,v=1<<O,C=v;do v-=p,b[y+(F>>T)+v]=B<<24|S<<16|E|0;while(0!==v);for(p=1<<Z-1;F&p;)p>>=1;if(0!==p?(F&=p-1,F+=p):F=0,R++,0===--j[Z]){if(Z===N)break;Z=e[u+m[R]]}if(Z>I&&(F&x)!==k){for(0===T&&(T=I),y+=C,O=Z-T,D=1<<O;N>O+T&&(D-=j[O+T],!(0>=D));)O++,D<<=1;if(U+=1<<O,t===o&&U>n||t===l&&U>r)return 1;k=F&x,b[k]=I<<24|O<<16|y-g|0}}return 0!==F&&(b[y+F]=Z-T<<24|64<<16|0),w.bits=I,0}},{"../utils/common":3}],13:[function(t,e){"use strict";e.exports={2:"need dictionary",1:"stream end",0:"","-1":"file error","-2":"stream error","-3":"data error","-4":"insufficient memory","-5":"buffer error","-6":"incompatible version"}},{}],14:[function(t,e,a){"use strict";function i(t){for(var e=t.length;--e>=0;)t[e]=0}function n(t){return 256>t?st[t]:st[256+(t>>>7)]}function r(t,e){t.pending_buf[t.pending++]=255&e,t.pending_buf[t.pending++]=e>>>8&255}function s(t,e,a){t.bi_valid>G-a?(t.bi_buf|=e<<t.bi_valid&65535,r(t,t.bi_buf),t.bi_buf=e>>G-t.bi_valid,t.bi_valid+=a-G):(t.bi_buf|=e<<t.bi_valid&65535,t.bi_valid+=a)}function o(t,e,a){s(t,a[2*e],a[2*e+1])}function l(t,e){var a=0;do a|=1&t,t>>>=1,a<<=1;while(--e>0);return a>>>1}function h(t){16===t.bi_valid?(r(t,t.bi_buf),t.bi_buf=0,t.bi_valid=0):t.bi_valid>=8&&(t.pending_buf[t.pending++]=255&t.bi_buf,t.bi_buf>>=8,t.bi_valid-=8)}function d(t,e){var a,i,n,r,s,o,l=e.dyn_tree,h=e.max_code,d=e.stat_desc.static_tree,f=e.stat_desc.has_stree,_=e.stat_desc.extra_bits,u=e.stat_desc.extra_base,c=e.stat_desc.max_length,b=0;for(r=0;Y>=r;r++)t.bl_count[r]=0;for(l[2*t.heap[t.heap_max]+1]=0,a=t.heap_max+1;q>a;a++)i=t.heap[a],r=l[2*l[2*i+1]+1]+1,r>c&&(r=c,b++),l[2*i+1]=r,i>h||(t.bl_count[r]++,s=0,i>=u&&(s=_[i-u]),o=l[2*i],t.opt_len+=o*(r+s),f&&(t.static_len+=o*(d[2*i+1]+s)));if(0!==b){do{for(r=c-1;0===t.bl_count[r];)r--;t.bl_count[r]--,t.bl_count[r+1]+=2,t.bl_count[c]--,b-=2}while(b>0);for(r=c;0!==r;r--)for(i=t.bl_count[r];0!==i;)n=t.heap[--a],n>h||(l[2*n+1]!==r&&(t.opt_len+=(r-l[2*n+1])*l[2*n],l[2*n+1]=r),i--)}}function f(t,e,a){var i,n,r=new Array(Y+1),s=0;for(i=1;Y>=i;i++)r[i]=s=s+a[i-1]<<1;for(n=0;e>=n;n++){var o=t[2*n+1];0!==o&&(t[2*n]=l(r[o]++,o))}}function _(){var t,e,a,i,n,r=new Array(Y+1);for(a=0,i=0;H-1>i;i++)for(lt[i]=a,t=0;t<1<<$[i];t++)ot[a++]=i;for(ot[a-1]=i,n=0,i=0;16>i;i++)for(ht[i]=n,t=0;t<1<<tt[i];t++)st[n++]=i;for(n>>=7;K>i;i++)for(ht[i]=n<<7,t=0;t<1<<tt[i]-7;t++)st[256+n++]=i;for(e=0;Y>=e;e++)r[e]=0;for(t=0;143>=t;)nt[2*t+1]=8,t++,r[8]++;for(;255>=t;)nt[2*t+1]=9,t++,r[9]++;for(;279>=t;)nt[2*t+1]=7,t++,r[7]++;for(;287>=t;)nt[2*t+1]=8,t++,r[8]++;for(f(nt,M+1,r),t=0;K>t;t++)rt[2*t+1]=5,rt[2*t]=l(t,5);dt=new ut(nt,$,j+1,M,Y),ft=new ut(rt,tt,0,K,Y),_t=new ut(new Array(0),et,0,P,X)}function u(t){var e;for(e=0;M>e;e++)t.dyn_ltree[2*e]=0;for(e=0;K>e;e++)t.dyn_dtree[2*e]=0;for(e=0;P>e;e++)t.bl_tree[2*e]=0;t.dyn_ltree[2*W]=1,t.opt_len=t.static_len=0,t.last_lit=t.matches=0}function c(t){t.bi_valid>8?r(t,t.bi_buf):t.bi_valid>0&&(t.pending_buf[t.pending++]=t.bi_buf),t.bi_buf=0,t.bi_valid=0}function b(t,e,a,i){c(t),i&&(r(t,a),r(t,~a)),R.arraySet(t.pending_buf,t.window,e,a,t.pending),t.pending+=a}function g(t,e,a,i){var n=2*e,r=2*a;return t[n]<t[r]||t[n]===t[r]&&i[e]<=i[a]}function m(t,e,a){for(var i=t.heap[a],n=a<<1;n<=t.heap_len&&(n<t.heap_len&&g(e,t.heap[n+1],t.heap[n],t.depth)&&n++,!g(e,i,t.heap[n],t.depth));)t.heap[a]=t.heap[n],a=n,n<<=1;t.heap[a]=i}function w(t,e,a){var i,r,l,h,d=0;if(0!==t.last_lit)do i=t.pending_buf[t.d_buf+2*d]<<8|t.pending_buf[t.d_buf+2*d+1],r=t.pending_buf[t.l_buf+d],d++,0===i?o(t,r,e):(l=ot[r],o(t,l+j+1,e),h=$[l],0!==h&&(r-=lt[l],s(t,r,h)),i--,l=n(i),o(t,l,a),h=tt[l],0!==h&&(i-=ht[l],s(t,i,h)));while(d<t.last_lit);o(t,W,e)}function p(t,e){var a,i,n,r=e.dyn_tree,s=e.stat_desc.static_tree,o=e.stat_desc.has_stree,l=e.stat_desc.elems,h=-1;for(t.heap_len=0,t.heap_max=q,a=0;l>a;a++)0!==r[2*a]?(t.heap[++t.heap_len]=h=a,t.depth[a]=0):r[2*a+1]=0;for(;t.heap_len<2;)n=t.heap[++t.heap_len]=2>h?++h:0,r[2*n]=1,t.depth[n]=0,t.opt_len--,o&&(t.static_len-=s[2*n+1]);for(e.max_code=h,a=t.heap_len>>1;a>=1;a--)m(t,r,a);n=l;do a=t.heap[1],t.heap[1]=t.heap[t.heap_len--],m(t,r,1),i=t.heap[1],t.heap[--t.heap_max]=a,t.heap[--t.heap_max]=i,r[2*n]=r[2*a]+r[2*i],t.depth[n]=(t.depth[a]>=t.depth[i]?t.depth[a]:t.depth[i])+1,r[2*a+1]=r[2*i+1]=n,t.heap[1]=n++,m(t,r,1);while(t.heap_len>=2);t.heap[--t.heap_max]=t.heap[1],d(t,e),f(r,h,t.bl_count)}function v(t,e,a){var i,n,r=-1,s=e[1],o=0,l=7,h=4;for(0===s&&(l=138,h=3),e[2*(a+1)+1]=65535,i=0;a>=i;i++)n=s,s=e[2*(i+1)+1],++o<l&&n===s||(h>o?t.bl_tree[2*n]+=o:0!==n?(n!==r&&t.bl_tree[2*n]++,t.bl_tree[2*J]++):10>=o?t.bl_tree[2*Q]++:t.bl_tree[2*V]++,o=0,r=n,0===s?(l=138,h=3):n===s?(l=6,h=3):(l=7,h=4))}function k(t,e,a){var i,n,r=-1,l=e[1],h=0,d=7,f=4;for(0===l&&(d=138,f=3),i=0;a>=i;i++)if(n=l,l=e[2*(i+1)+1],!(++h<d&&n===l)){if(f>h){do o(t,n,t.bl_tree);while(0!==--h)}else 0!==n?(n!==r&&(o(t,n,t.bl_tree),h--),o(t,J,t.bl_tree),s(t,h-3,2)):10>=h?(o(t,Q,t.bl_tree),s(t,h-3,3)):(o(t,V,t.bl_tree),s(t,h-11,7));h=0,r=n,0===l?(d=138,f=3):n===l?(d=6,f=3):(d=7,f=4)}}function x(t){var e;for(v(t,t.dyn_ltree,t.l_desc.max_code),v(t,t.dyn_dtree,t.d_desc.max_code),p(t,t.bl_desc),e=P-1;e>=3&&0===t.bl_tree[2*at[e]+1];e--);return t.opt_len+=3*(e+1)+5+5+4,e}function y(t,e,a,i){var n;for(s(t,e-257,5),s(t,a-1,5),s(t,i-4,4),n=0;i>n;n++)s(t,t.bl_tree[2*at[n]+1],3);k(t,t.dyn_ltree,e-1),k(t,t.dyn_dtree,a-1)}function z(t){var e,a=4093624447;for(e=0;31>=e;e++,a>>>=1)if(1&a&&0!==t.dyn_ltree[2*e])return N;if(0!==t.dyn_ltree[18]||0!==t.dyn_ltree[20]||0!==t.dyn_ltree[26])return I;for(e=32;j>e;e++)if(0!==t.dyn_ltree[2*e])return I;return N}function B(t){bt||(_(),bt=!0),t.l_desc=new ct(t.dyn_ltree,dt),t.d_desc=new ct(t.dyn_dtree,ft),t.bl_desc=new ct(t.bl_tree,_t),t.bi_buf=0,t.bi_valid=0,u(t)}function S(t,e,a,i){s(t,(T<<1)+(i?1:0),3),b(t,e,a,!0)}function E(t){s(t,D<<1,3),o(t,W,nt),h(t)}function A(t,e,a,i){var n,r,o=0;t.level>0?(t.strm.data_type===O&&(t.strm.data_type=z(t)),p(t,t.l_desc),p(t,t.d_desc),o=x(t),n=t.opt_len+3+7>>>3,r=t.static_len+3+7>>>3,n>=r&&(n=r)):n=r=a+5,n>=a+4&&-1!==e?S(t,e,a,i):t.strategy===C||r===n?(s(t,(D<<1)+(i?1:0),3),w(t,nt,rt)):(s(t,(U<<1)+(i?1:0),3),y(t,t.l_desc.max_code+1,t.d_desc.max_code+1,o+1),w(t,t.dyn_ltree,t.dyn_dtree)),u(t),i&&c(t)}function Z(t,e,a){return t.pending_buf[t.d_buf+2*t.last_lit]=e>>>8&255,t.pending_buf[t.d_buf+2*t.last_lit+1]=255&e,t.pending_buf[t.l_buf+t.last_lit]=255&a,t.last_lit++,0===e?t.dyn_ltree[2*a]++:(t.matches++,e--,t.dyn_ltree[2*(ot[a]+j+1)]++,t.dyn_dtree[2*n(e)]++),t.last_lit===t.lit_bufsize-1}var R=t("../utils/common"),C=4,N=0,I=1,O=2,T=0,D=1,U=2,F=3,L=258,H=29,j=256,M=j+1+H,K=30,P=19,q=2*M+1,Y=15,G=16,X=7,W=256,J=16,Q=17,V=18,$=[0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],tt=[0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],et=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],at=[16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],it=512,nt=new Array(2*(M+2));i(nt);var rt=new Array(2*K);i(rt);var st=new Array(it);i(st);var ot=new Array(L-F+1);i(ot);var lt=new Array(H);i(lt);var ht=new Array(K);i(ht);var dt,ft,_t,ut=function(t,e,a,i,n){this.static_tree=t,this.extra_bits=e,this.extra_base=a,this.elems=i,this.max_length=n,this.has_stree=t&&t.length},ct=function(t,e){this.dyn_tree=t,this.max_code=0,this.stat_desc=e},bt=!1;a._tr_init=B,a._tr_stored_block=S,a._tr_flush_block=A,a._tr_tally=Z,a._tr_align=E},{"../utils/common":3}],15:[function(t,e){"use strict";function a(){this.input=null,this.next_in=0,this.avail_in=0,this.total_in=0,this.output=null,this.next_out=0,this.avail_out=0,this.total_out=0,this.msg="",this.state=null,this.data_type=2,this.adler=0}e.exports=a},{}],"/":[function(t,e){"use strict";var a=t("./lib/utils/common").assign,i=t("./lib/deflate"),n=t("./lib/inflate"),r=t("./lib/zlib/constants"),s={};a(s,i,n,r),e.exports=s},{"./lib/deflate":1,"./lib/inflate":2,"./lib/utils/common":3,"./lib/zlib/constants":6}]},{},[])("/")});

//! moment.js
//! version : 2.10.2
//! authors : Tim Wood, Iskren Chernev, Moment.js contributors
//! license : MIT
//! momentjs.com
!function(a,b){"object"==typeof exports&&"undefined"!=typeof module?module.exports=b():"function"==typeof define&&define.amd?define(b):a.moment=b()}(this,function(){"use strict";function a(){return Ac.apply(null,arguments)}function b(a){Ac=a}function c(){return{empty:!1,unusedTokens:[],unusedInput:[],overflow:-2,charsLeftOver:0,nullInput:!1,invalidMonth:null,invalidFormat:!1,userInvalidated:!1,iso:!1}}function d(a){return"[object Array]"===Object.prototype.toString.call(a)}function e(a){return"[object Date]"===Object.prototype.toString.call(a)||a instanceof Date}function f(a,b){var c,d=[];for(c=0;c<a.length;++c)d.push(b(a[c],c));return d}function g(a,b){return Object.prototype.hasOwnProperty.call(a,b)}function h(a,b){for(var c in b)g(b,c)&&(a[c]=b[c]);return g(b,"toString")&&(a.toString=b.toString),g(b,"valueOf")&&(a.valueOf=b.valueOf),a}function i(a,b,c,d){return ya(a,b,c,d,!0).utc()}function j(a){return null==a._isValid&&(a._isValid=!isNaN(a._d.getTime())&&a._pf.overflow<0&&!a._pf.empty&&!a._pf.invalidMonth&&!a._pf.nullInput&&!a._pf.invalidFormat&&!a._pf.userInvalidated,a._strict&&(a._isValid=a._isValid&&0===a._pf.charsLeftOver&&0===a._pf.unusedTokens.length&&void 0===a._pf.bigHour)),a._isValid}function k(a){var b=i(0/0);return null!=a?h(b._pf,a):b._pf.userInvalidated=!0,b}function l(a,b){var c,d,e;if("undefined"!=typeof b._isAMomentObject&&(a._isAMomentObject=b._isAMomentObject),"undefined"!=typeof b._i&&(a._i=b._i),"undefined"!=typeof b._f&&(a._f=b._f),"undefined"!=typeof b._l&&(a._l=b._l),"undefined"!=typeof b._strict&&(a._strict=b._strict),"undefined"!=typeof b._tzm&&(a._tzm=b._tzm),"undefined"!=typeof b._isUTC&&(a._isUTC=b._isUTC),"undefined"!=typeof b._offset&&(a._offset=b._offset),"undefined"!=typeof b._pf&&(a._pf=b._pf),"undefined"!=typeof b._locale&&(a._locale=b._locale),Cc.length>0)for(c in Cc)d=Cc[c],e=b[d],"undefined"!=typeof e&&(a[d]=e);return a}function m(b){l(this,b),this._d=new Date(+b._d),Dc===!1&&(Dc=!0,a.updateOffset(this),Dc=!1)}function n(a){return a instanceof m||null!=a&&g(a,"_isAMomentObject")}function o(a){var b=+a,c=0;return 0!==b&&isFinite(b)&&(c=b>=0?Math.floor(b):Math.ceil(b)),c}function p(a,b,c){var d,e=Math.min(a.length,b.length),f=Math.abs(a.length-b.length),g=0;for(d=0;e>d;d++)(c&&a[d]!==b[d]||!c&&o(a[d])!==o(b[d]))&&g++;return g+f}function q(){}function r(a){return a?a.toLowerCase().replace("_","-"):a}function s(a){for(var b,c,d,e,f=0;f<a.length;){for(e=r(a[f]).split("-"),b=e.length,c=r(a[f+1]),c=c?c.split("-"):null;b>0;){if(d=t(e.slice(0,b).join("-")))return d;if(c&&c.length>=b&&p(e,c,!0)>=b-1)break;b--}f++}return null}function t(a){var b=null;if(!Ec[a]&&"undefined"!=typeof module&&module&&module.exports)try{b=Bc._abbr,require("./locale/"+a),u(b)}catch(c){}return Ec[a]}function u(a,b){var c;return a&&(c="undefined"==typeof b?w(a):v(a,b),c&&(Bc=c)),Bc._abbr}function v(a,b){return null!==b?(b.abbr=a,Ec[a]||(Ec[a]=new q),Ec[a].set(b),u(a),Ec[a]):(delete Ec[a],null)}function w(a){var b;if(a&&a._locale&&a._locale._abbr&&(a=a._locale._abbr),!a)return Bc;if(!d(a)){if(b=t(a))return b;a=[a]}return s(a)}function x(a,b){var c=a.toLowerCase();Fc[c]=Fc[c+"s"]=Fc[b]=a}function y(a){return"string"==typeof a?Fc[a]||Fc[a.toLowerCase()]:void 0}function z(a){var b,c,d={};for(c in a)g(a,c)&&(b=y(c),b&&(d[b]=a[c]));return d}function A(b,c){return function(d){return null!=d?(C(this,b,d),a.updateOffset(this,c),this):B(this,b)}}function B(a,b){return a._d["get"+(a._isUTC?"UTC":"")+b]()}function C(a,b,c){return a._d["set"+(a._isUTC?"UTC":"")+b](c)}function D(a,b){var c;if("object"==typeof a)for(c in a)this.set(c,a[c]);else if(a=y(a),"function"==typeof this[a])return this[a](b);return this}function E(a,b,c){for(var d=""+Math.abs(a),e=a>=0;d.length<b;)d="0"+d;return(e?c?"+":"":"-")+d}function F(a,b,c,d){var e=d;"string"==typeof d&&(e=function(){return this[d]()}),a&&(Jc[a]=e),b&&(Jc[b[0]]=function(){return E(e.apply(this,arguments),b[1],b[2])}),c&&(Jc[c]=function(){return this.localeData().ordinal(e.apply(this,arguments),a)})}function G(a){return a.match(/\[[\s\S]/)?a.replace(/^\[|\]$/g,""):a.replace(/\\/g,"")}function H(a){var b,c,d=a.match(Gc);for(b=0,c=d.length;c>b;b++)d[b]=Jc[d[b]]?Jc[d[b]]:G(d[b]);return function(e){var f="";for(b=0;c>b;b++)f+=d[b]instanceof Function?d[b].call(e,a):d[b];return f}}function I(a,b){return a.isValid()?(b=J(b,a.localeData()),Ic[b]||(Ic[b]=H(b)),Ic[b](a)):a.localeData().invalidDate()}function J(a,b){function c(a){return b.longDateFormat(a)||a}var d=5;for(Hc.lastIndex=0;d>=0&&Hc.test(a);)a=a.replace(Hc,c),Hc.lastIndex=0,d-=1;return a}function K(a,b,c){Yc[a]="function"==typeof b?b:function(a){return a&&c?c:b}}function L(a,b){return g(Yc,a)?Yc[a](b._strict,b._locale):new RegExp(M(a))}function M(a){return a.replace("\\","").replace(/\\(\[)|\\(\])|\[([^\]\[]*)\]|\\(.)/g,function(a,b,c,d,e){return b||c||d||e}).replace(/[-\/\\^$*+?.()|[\]{}]/g,"\\$&")}function N(a,b){var c,d=b;for("string"==typeof a&&(a=[a]),"number"==typeof b&&(d=function(a,c){c[b]=o(a)}),c=0;c<a.length;c++)Zc[a[c]]=d}function O(a,b){N(a,function(a,c,d,e){d._w=d._w||{},b(a,d._w,d,e)})}function P(a,b,c){null!=b&&g(Zc,a)&&Zc[a](b,c._a,c,a)}function Q(a,b){return new Date(Date.UTC(a,b+1,0)).getUTCDate()}function R(a){return this._months[a.month()]}function S(a){return this._monthsShort[a.month()]}function T(a,b,c){var d,e,f;for(this._monthsParse||(this._monthsParse=[],this._longMonthsParse=[],this._shortMonthsParse=[]),d=0;12>d;d++){if(e=i([2e3,d]),c&&!this._longMonthsParse[d]&&(this._longMonthsParse[d]=new RegExp("^"+this.months(e,"").replace(".","")+"$","i"),this._shortMonthsParse[d]=new RegExp("^"+this.monthsShort(e,"").replace(".","")+"$","i")),c||this._monthsParse[d]||(f="^"+this.months(e,"")+"|^"+this.monthsShort(e,""),this._monthsParse[d]=new RegExp(f.replace(".",""),"i")),c&&"MMMM"===b&&this._longMonthsParse[d].test(a))return d;if(c&&"MMM"===b&&this._shortMonthsParse[d].test(a))return d;if(!c&&this._monthsParse[d].test(a))return d}}function U(a,b){var c;return"string"==typeof b&&(b=a.localeData().monthsParse(b),"number"!=typeof b)?a:(c=Math.min(a.date(),Q(a.year(),b)),a._d["set"+(a._isUTC?"UTC":"")+"Month"](b,c),a)}function V(b){return null!=b?(U(this,b),a.updateOffset(this,!0),this):B(this,"Month")}function W(){return Q(this.year(),this.month())}function X(a){var b,c=a._a;return c&&-2===a._pf.overflow&&(b=c[_c]<0||c[_c]>11?_c:c[ad]<1||c[ad]>Q(c[$c],c[_c])?ad:c[bd]<0||c[bd]>24||24===c[bd]&&(0!==c[cd]||0!==c[dd]||0!==c[ed])?bd:c[cd]<0||c[cd]>59?cd:c[dd]<0||c[dd]>59?dd:c[ed]<0||c[ed]>999?ed:-1,a._pf._overflowDayOfYear&&($c>b||b>ad)&&(b=ad),a._pf.overflow=b),a}function Y(b){a.suppressDeprecationWarnings===!1&&"undefined"!=typeof console&&console.warn&&console.warn("Deprecation warning: "+b)}function Z(a,b){var c=!0;return h(function(){return c&&(Y(a),c=!1),b.apply(this,arguments)},b)}function $(a,b){hd[a]||(Y(b),hd[a]=!0)}function _(a){var b,c,d=a._i,e=id.exec(d);if(e){for(a._pf.iso=!0,b=0,c=jd.length;c>b;b++)if(jd[b][1].exec(d)){a._f=jd[b][0]+(e[6]||" ");break}for(b=0,c=kd.length;c>b;b++)if(kd[b][1].exec(d)){a._f+=kd[b][0];break}d.match(Vc)&&(a._f+="Z"),sa(a)}else a._isValid=!1}function aa(b){var c=ld.exec(b._i);return null!==c?void(b._d=new Date(+c[1])):(_(b),void(b._isValid===!1&&(delete b._isValid,a.createFromInputFallback(b))))}function ba(a,b,c,d,e,f,g){var h=new Date(a,b,c,d,e,f,g);return 1970>a&&h.setFullYear(a),h}function ca(a){var b=new Date(Date.UTC.apply(null,arguments));return 1970>a&&b.setUTCFullYear(a),b}function da(a){return ea(a)?366:365}function ea(a){return a%4===0&&a%100!==0||a%400===0}function fa(){return ea(this.year())}function ga(a,b,c){var d,e=c-b,f=c-a.day();return f>e&&(f-=7),e-7>f&&(f+=7),d=za(a).add(f,"d"),{week:Math.ceil(d.dayOfYear()/7),year:d.year()}}function ha(a){return ga(a,this._week.dow,this._week.doy).week}function ia(){return this._week.dow}function ja(){return this._week.doy}function ka(a){var b=this.localeData().week(this);return null==a?b:this.add(7*(a-b),"d")}function la(a){var b=ga(this,1,4).week;return null==a?b:this.add(7*(a-b),"d")}function ma(a,b,c,d,e){var f,g,h=ca(a,0,1).getUTCDay();return h=0===h?7:h,c=null!=c?c:e,f=e-h+(h>d?7:0)-(e>h?7:0),g=7*(b-1)+(c-e)+f+1,{year:g>0?a:a-1,dayOfYear:g>0?g:da(a-1)+g}}function na(a){var b=Math.round((this.clone().startOf("day")-this.clone().startOf("year"))/864e5)+1;return null==a?b:this.add(a-b,"d")}function oa(a,b,c){return null!=a?a:null!=b?b:c}function pa(a){var b=new Date;return a._useUTC?[b.getUTCFullYear(),b.getUTCMonth(),b.getUTCDate()]:[b.getFullYear(),b.getMonth(),b.getDate()]}function qa(a){var b,c,d,e,f=[];if(!a._d){for(d=pa(a),a._w&&null==a._a[ad]&&null==a._a[_c]&&ra(a),a._dayOfYear&&(e=oa(a._a[$c],d[$c]),a._dayOfYear>da(e)&&(a._pf._overflowDayOfYear=!0),c=ca(e,0,a._dayOfYear),a._a[_c]=c.getUTCMonth(),a._a[ad]=c.getUTCDate()),b=0;3>b&&null==a._a[b];++b)a._a[b]=f[b]=d[b];for(;7>b;b++)a._a[b]=f[b]=null==a._a[b]?2===b?1:0:a._a[b];24===a._a[bd]&&0===a._a[cd]&&0===a._a[dd]&&0===a._a[ed]&&(a._nextDay=!0,a._a[bd]=0),a._d=(a._useUTC?ca:ba).apply(null,f),null!=a._tzm&&a._d.setUTCMinutes(a._d.getUTCMinutes()-a._tzm),a._nextDay&&(a._a[bd]=24)}}function ra(a){var b,c,d,e,f,g,h;b=a._w,null!=b.GG||null!=b.W||null!=b.E?(f=1,g=4,c=oa(b.GG,a._a[$c],ga(za(),1,4).year),d=oa(b.W,1),e=oa(b.E,1)):(f=a._locale._week.dow,g=a._locale._week.doy,c=oa(b.gg,a._a[$c],ga(za(),f,g).year),d=oa(b.w,1),null!=b.d?(e=b.d,f>e&&++d):e=null!=b.e?b.e+f:f),h=ma(c,d,e,g,f),a._a[$c]=h.year,a._dayOfYear=h.dayOfYear}function sa(b){if(b._f===a.ISO_8601)return void _(b);b._a=[],b._pf.empty=!0;var c,d,e,f,g,h=""+b._i,i=h.length,j=0;for(e=J(b._f,b._locale).match(Gc)||[],c=0;c<e.length;c++)f=e[c],d=(h.match(L(f,b))||[])[0],d&&(g=h.substr(0,h.indexOf(d)),g.length>0&&b._pf.unusedInput.push(g),h=h.slice(h.indexOf(d)+d.length),j+=d.length),Jc[f]?(d?b._pf.empty=!1:b._pf.unusedTokens.push(f),P(f,d,b)):b._strict&&!d&&b._pf.unusedTokens.push(f);b._pf.charsLeftOver=i-j,h.length>0&&b._pf.unusedInput.push(h),b._pf.bigHour===!0&&b._a[bd]<=12&&(b._pf.bigHour=void 0),b._a[bd]=ta(b._locale,b._a[bd],b._meridiem),qa(b),X(b)}function ta(a,b,c){var d;return null==c?b:null!=a.meridiemHour?a.meridiemHour(b,c):null!=a.isPM?(d=a.isPM(c),d&&12>b&&(b+=12),d||12!==b||(b=0),b):b}function ua(a){var b,d,e,f,g;if(0===a._f.length)return a._pf.invalidFormat=!0,void(a._d=new Date(0/0));for(f=0;f<a._f.length;f++)g=0,b=l({},a),null!=a._useUTC&&(b._useUTC=a._useUTC),b._pf=c(),b._f=a._f[f],sa(b),j(b)&&(g+=b._pf.charsLeftOver,g+=10*b._pf.unusedTokens.length,b._pf.score=g,(null==e||e>g)&&(e=g,d=b));h(a,d||b)}function va(a){if(!a._d){var b=z(a._i);a._a=[b.year,b.month,b.day||b.date,b.hour,b.minute,b.second,b.millisecond],qa(a)}}function wa(a){var b,c=a._i,e=a._f;return a._locale=a._locale||w(a._l),null===c||void 0===e&&""===c?k({nullInput:!0}):("string"==typeof c&&(a._i=c=a._locale.preparse(c)),n(c)?new m(X(c)):(d(e)?ua(a):e?sa(a):xa(a),b=new m(X(a)),b._nextDay&&(b.add(1,"d"),b._nextDay=void 0),b))}function xa(b){var c=b._i;void 0===c?b._d=new Date:e(c)?b._d=new Date(+c):"string"==typeof c?aa(b):d(c)?(b._a=f(c.slice(0),function(a){return parseInt(a,10)}),qa(b)):"object"==typeof c?va(b):"number"==typeof c?b._d=new Date(c):a.createFromInputFallback(b)}function ya(a,b,d,e,f){var g={};return"boolean"==typeof d&&(e=d,d=void 0),g._isAMomentObject=!0,g._useUTC=g._isUTC=f,g._l=d,g._i=a,g._f=b,g._strict=e,g._pf=c(),wa(g)}function za(a,b,c,d){return ya(a,b,c,d,!1)}function Aa(a,b){var c,e;if(1===b.length&&d(b[0])&&(b=b[0]),!b.length)return za();for(c=b[0],e=1;e<b.length;++e)b[e][a](c)&&(c=b[e]);return c}function Ba(){var a=[].slice.call(arguments,0);return Aa("isBefore",a)}function Ca(){var a=[].slice.call(arguments,0);return Aa("isAfter",a)}function Da(a){var b=z(a),c=b.year||0,d=b.quarter||0,e=b.month||0,f=b.week||0,g=b.day||0,h=b.hour||0,i=b.minute||0,j=b.second||0,k=b.millisecond||0;this._milliseconds=+k+1e3*j+6e4*i+36e5*h,this._days=+g+7*f,this._months=+e+3*d+12*c,this._data={},this._locale=w(),this._bubble()}function Ea(a){return a instanceof Da}function Fa(a,b){F(a,0,0,function(){var a=this.utcOffset(),c="+";return 0>a&&(a=-a,c="-"),c+E(~~(a/60),2)+b+E(~~a%60,2)})}function Ga(a){var b=(a||"").match(Vc)||[],c=b[b.length-1]||[],d=(c+"").match(qd)||["-",0,0],e=+(60*d[1])+o(d[2]);return"+"===d[0]?e:-e}function Ha(b,c){var d,f;return c._isUTC?(d=c.clone(),f=(n(b)||e(b)?+b:+za(b))-+d,d._d.setTime(+d._d+f),a.updateOffset(d,!1),d):za(b).local();return c._isUTC?za(b).zone(c._offset||0):za(b).local()}function Ia(a){return 15*-Math.round(a._d.getTimezoneOffset()/15)}function Ja(b,c){var d,e=this._offset||0;return null!=b?("string"==typeof b&&(b=Ga(b)),Math.abs(b)<16&&(b=60*b),!this._isUTC&&c&&(d=Ia(this)),this._offset=b,this._isUTC=!0,null!=d&&this.add(d,"m"),e!==b&&(!c||this._changeInProgress?Za(this,Ua(b-e,"m"),1,!1):this._changeInProgress||(this._changeInProgress=!0,a.updateOffset(this,!0),this._changeInProgress=null)),this):this._isUTC?e:Ia(this)}function Ka(a,b){return null!=a?("string"!=typeof a&&(a=-a),this.utcOffset(a,b),this):-this.utcOffset()}function La(a){return this.utcOffset(0,a)}function Ma(a){return this._isUTC&&(this.utcOffset(0,a),this._isUTC=!1,a&&this.subtract(Ia(this),"m")),this}function Na(){return this._tzm?this.utcOffset(this._tzm):"string"==typeof this._i&&this.utcOffset(Ga(this._i)),this}function Oa(a){return a=a?za(a).utcOffset():0,(this.utcOffset()-a)%60===0}function Pa(){return this.utcOffset()>this.clone().month(0).utcOffset()||this.utcOffset()>this.clone().month(5).utcOffset()}function Qa(){if(this._a){var a=this._isUTC?i(this._a):za(this._a);return this.isValid()&&p(this._a,a.toArray())>0}return!1}function Ra(){return!this._isUTC}function Sa(){return this._isUTC}function Ta(){return this._isUTC&&0===this._offset}function Ua(a,b){var c,d,e,f=a,h=null;return Ea(a)?f={ms:a._milliseconds,d:a._days,M:a._months}:"number"==typeof a?(f={},b?f[b]=a:f.milliseconds=a):(h=rd.exec(a))?(c="-"===h[1]?-1:1,f={y:0,d:o(h[ad])*c,h:o(h[bd])*c,m:o(h[cd])*c,s:o(h[dd])*c,ms:o(h[ed])*c}):(h=sd.exec(a))?(c="-"===h[1]?-1:1,f={y:Va(h[2],c),M:Va(h[3],c),d:Va(h[4],c),h:Va(h[5],c),m:Va(h[6],c),s:Va(h[7],c),w:Va(h[8],c)}):null==f?f={}:"object"==typeof f&&("from"in f||"to"in f)&&(e=Xa(za(f.from),za(f.to)),f={},f.ms=e.milliseconds,f.M=e.months),d=new Da(f),Ea(a)&&g(a,"_locale")&&(d._locale=a._locale),d}function Va(a,b){var c=a&&parseFloat(a.replace(",","."));return(isNaN(c)?0:c)*b}function Wa(a,b){var c={milliseconds:0,months:0};return c.months=b.month()-a.month()+12*(b.year()-a.year()),a.clone().add(c.months,"M").isAfter(b)&&--c.months,c.milliseconds=+b-+a.clone().add(c.months,"M"),c}function Xa(a,b){var c;return b=Ha(b,a),a.isBefore(b)?c=Wa(a,b):(c=Wa(b,a),c.milliseconds=-c.milliseconds,c.months=-c.months),c}function Ya(a,b){return function(c,d){var e,f;return null===d||isNaN(+d)||($(b,"moment()."+b+"(period, number) is deprecated. Please use moment()."+b+"(number, period)."),f=c,c=d,d=f),c="string"==typeof c?+c:c,e=Ua(c,d),Za(this,e,a),this}}function Za(b,c,d,e){var f=c._milliseconds,g=c._days,h=c._months;e=null==e?!0:e,f&&b._d.setTime(+b._d+f*d),g&&C(b,"Date",B(b,"Date")+g*d),h&&U(b,B(b,"Month")+h*d),e&&a.updateOffset(b,g||h)}function $a(a){var b=a||za(),c=Ha(b,this).startOf("day"),d=this.diff(c,"days",!0),e=-6>d?"sameElse":-1>d?"lastWeek":0>d?"lastDay":1>d?"sameDay":2>d?"nextDay":7>d?"nextWeek":"sameElse";return this.format(this.localeData().calendar(e,this,za(b)))}function _a(){return new m(this)}function ab(a,b){var c;return b=y("undefined"!=typeof b?b:"millisecond"),"millisecond"===b?(a=n(a)?a:za(a),+this>+a):(c=n(a)?+a:+za(a),c<+this.clone().startOf(b))}function bb(a,b){var c;return b=y("undefined"!=typeof b?b:"millisecond"),"millisecond"===b?(a=n(a)?a:za(a),+a>+this):(c=n(a)?+a:+za(a),+this.clone().endOf(b)<c)}function cb(a,b,c){return this.isAfter(a,c)&&this.isBefore(b,c)}function db(a,b){var c;return b=y(b||"millisecond"),"millisecond"===b?(a=n(a)?a:za(a),+this===+a):(c=+za(a),+this.clone().startOf(b)<=c&&c<=+this.clone().endOf(b))}function eb(a){return 0>a?Math.ceil(a):Math.floor(a)}function fb(a,b,c){var d,e,f=Ha(a,this),g=6e4*(f.utcOffset()-this.utcOffset());return b=y(b),"year"===b||"month"===b||"quarter"===b?(e=gb(this,f),"quarter"===b?e/=3:"year"===b&&(e/=12)):(d=this-f,e="second"===b?d/1e3:"minute"===b?d/6e4:"hour"===b?d/36e5:"day"===b?(d-g)/864e5:"week"===b?(d-g)/6048e5:d),c?e:eb(e)}function gb(a,b){var c,d,e=12*(b.year()-a.year())+(b.month()-a.month()),f=a.clone().add(e,"months");return 0>b-f?(c=a.clone().add(e-1,"months"),d=(b-f)/(f-c)):(c=a.clone().add(e+1,"months"),d=(b-f)/(c-f)),-(e+d)}function hb(){return this.clone().locale("en").format("ddd MMM DD YYYY HH:mm:ss [GMT]ZZ")}function ib(){var a=this.clone().utc();return 0<a.year()&&a.year()<=9999?"function"==typeof Date.prototype.toISOString?this.toDate().toISOString():I(a,"YYYY-MM-DD[T]HH:mm:ss.SSS[Z]"):I(a,"YYYYYY-MM-DD[T]HH:mm:ss.SSS[Z]")}function jb(b){var c=I(this,b||a.defaultFormat);return this.localeData().postformat(c)}function kb(a,b){return Ua({to:this,from:a}).locale(this.locale()).humanize(!b)}function lb(a){return this.from(za(),a)}function mb(a){var b;return void 0===a?this._locale._abbr:(b=w(a),null!=b&&(this._locale=b),this)}function nb(){return this._locale}function ob(a){switch(a=y(a)){case"year":this.month(0);case"quarter":case"month":this.date(1);case"week":case"isoWeek":case"day":this.hours(0);case"hour":this.minutes(0);case"minute":this.seconds(0);case"second":this.milliseconds(0)}return"week"===a&&this.weekday(0),"isoWeek"===a&&this.isoWeekday(1),"quarter"===a&&this.month(3*Math.floor(this.month()/3)),this}function pb(a){return a=y(a),void 0===a||"millisecond"===a?this:this.startOf(a).add(1,"isoWeek"===a?"week":a).subtract(1,"ms")}function qb(){return+this._d-6e4*(this._offset||0)}function rb(){return Math.floor(+this/1e3)}function sb(){return this._offset?new Date(+this):this._d}function tb(){var a=this;return[a.year(),a.month(),a.date(),a.hour(),a.minute(),a.second(),a.millisecond()]}function ub(){return j(this)}function vb(){return h({},this._pf)}function wb(){return this._pf.overflow}function xb(a,b){F(0,[a,a.length],0,b)}function yb(a,b,c){return ga(za([a,11,31+b-c]),b,c).week}function zb(a){var b=ga(this,this.localeData()._week.dow,this.localeData()._week.doy).year;return null==a?b:this.add(a-b,"y")}function Ab(a){var b=ga(this,1,4).year;return null==a?b:this.add(a-b,"y")}function Bb(){return yb(this.year(),1,4)}function Cb(){var a=this.localeData()._week;return yb(this.year(),a.dow,a.doy)}function Db(a){return null==a?Math.ceil((this.month()+1)/3):this.month(3*(a-1)+this.month()%3)}function Eb(a,b){if("string"==typeof a)if(isNaN(a)){if(a=b.weekdaysParse(a),"number"!=typeof a)return null}else a=parseInt(a,10);return a}function Fb(a){return this._weekdays[a.day()]}function Gb(a){return this._weekdaysShort[a.day()]}function Hb(a){return this._weekdaysMin[a.day()]}function Ib(a){var b,c,d;for(this._weekdaysParse||(this._weekdaysParse=[]),b=0;7>b;b++)if(this._weekdaysParse[b]||(c=za([2e3,1]).day(b),d="^"+this.weekdays(c,"")+"|^"+this.weekdaysShort(c,"")+"|^"+this.weekdaysMin(c,""),this._weekdaysParse[b]=new RegExp(d.replace(".",""),"i")),this._weekdaysParse[b].test(a))return b}function Jb(a){var b=this._isUTC?this._d.getUTCDay():this._d.getDay();return null!=a?(a=Eb(a,this.localeData()),this.add(a-b,"d")):b}function Kb(a){var b=(this.day()+7-this.localeData()._week.dow)%7;return null==a?b:this.add(a-b,"d")}function Lb(a){return null==a?this.day()||7:this.day(this.day()%7?a:a-7)}function Mb(a,b){F(a,0,0,function(){return this.localeData().meridiem(this.hours(),this.minutes(),b)})}function Nb(a,b){return b._meridiemParse}function Ob(a){return"p"===(a+"").toLowerCase().charAt(0)}function Pb(a,b,c){return a>11?c?"pm":"PM":c?"am":"AM"}function Qb(a){F(0,[a,3],0,"millisecond")}function Rb(){return this._isUTC?"UTC":""}function Sb(){return this._isUTC?"Coordinated Universal Time":""}function Tb(a){return za(1e3*a)}function Ub(){return za.apply(null,arguments).parseZone()}function Vb(a,b,c){var d=this._calendar[a];return"function"==typeof d?d.call(b,c):d}function Wb(a){var b=this._longDateFormat[a];return!b&&this._longDateFormat[a.toUpperCase()]&&(b=this._longDateFormat[a.toUpperCase()].replace(/MMMM|MM|DD|dddd/g,function(a){return a.slice(1)}),this._longDateFormat[a]=b),b}function Xb(){return this._invalidDate}function Yb(a){return this._ordinal.replace("%d",a)}function Zb(a){return a}function $b(a,b,c,d){var e=this._relativeTime[c];return"function"==typeof e?e(a,b,c,d):e.replace(/%d/i,a)}function _b(a,b){var c=this._relativeTime[a>0?"future":"past"];return"function"==typeof c?c(b):c.replace(/%s/i,b)}function ac(a){var b,c;for(c in a)b=a[c],"function"==typeof b?this[c]=b:this["_"+c]=b;this._ordinalParseLenient=new RegExp(this._ordinalParse.source+"|"+/\d{1,2}/.source)}function bc(a,b,c,d){var e=w(),f=i().set(d,b);return e[c](f,a)}function cc(a,b,c,d,e){if("number"==typeof a&&(b=a,a=void 0),a=a||"",null!=b)return bc(a,b,c,e);var f,g=[];for(f=0;d>f;f++)g[f]=bc(a,f,c,e);return g}function dc(a,b){return cc(a,b,"months",12,"month")}function ec(a,b){return cc(a,b,"monthsShort",12,"month")}function fc(a,b){return cc(a,b,"weekdays",7,"day")}function gc(a,b){return cc(a,b,"weekdaysShort",7,"day")}function hc(a,b){return cc(a,b,"weekdaysMin",7,"day")}function ic(){var a=this._data;return this._milliseconds=Od(this._milliseconds),this._days=Od(this._days),this._months=Od(this._months),a.milliseconds=Od(a.milliseconds),a.seconds=Od(a.seconds),a.minutes=Od(a.minutes),a.hours=Od(a.hours),a.months=Od(a.months),a.years=Od(a.years),this}function jc(a,b,c,d){var e=Ua(b,c);return a._milliseconds+=d*e._milliseconds,a._days+=d*e._days,a._months+=d*e._months,a._bubble()}function kc(a,b){return jc(this,a,b,1)}function lc(a,b){return jc(this,a,b,-1)}function mc(){var a,b,c,d=this._milliseconds,e=this._days,f=this._months,g=this._data,h=0;return g.milliseconds=d%1e3,a=eb(d/1e3),g.seconds=a%60,b=eb(a/60),g.minutes=b%60,c=eb(b/60),g.hours=c%24,e+=eb(c/24),h=eb(nc(e)),e-=eb(oc(h)),f+=eb(e/30),e%=30,h+=eb(f/12),f%=12,g.days=e,g.months=f,g.years=h,this}function nc(a){return 400*a/146097}function oc(a){return 146097*a/400}function pc(a){var b,c,d=this._milliseconds;if(a=y(a),"month"===a||"year"===a)return b=this._days+d/864e5,c=this._months+12*nc(b),"month"===a?c:c/12;switch(b=this._days+Math.round(oc(this._months/12)),a){case"week":return b/7+d/6048e5;case"day":return b+d/864e5;case"hour":return 24*b+d/36e5;case"minute":return 24*b*60+d/6e4;case"second":return 24*b*60*60+d/1e3;case"millisecond":return Math.floor(24*b*60*60*1e3)+d;default:throw new Error("Unknown unit "+a)}}function qc(){return this._milliseconds+864e5*this._days+this._months%12*2592e6+31536e6*o(this._months/12)}function rc(a){return function(){return this.as(a)}}function sc(a){return a=y(a),this[a+"s"]()}function tc(a){return function(){return this._data[a]}}function uc(){return eb(this.days()/7)}function vc(a,b,c,d,e){return e.relativeTime(b||1,!!c,a,d)}function wc(a,b,c){var d=Ua(a).abs(),e=ce(d.as("s")),f=ce(d.as("m")),g=ce(d.as("h")),h=ce(d.as("d")),i=ce(d.as("M")),j=ce(d.as("y")),k=e<de.s&&["s",e]||1===f&&["m"]||f<de.m&&["mm",f]||1===g&&["h"]||g<de.h&&["hh",g]||1===h&&["d"]||h<de.d&&["dd",h]||1===i&&["M"]||i<de.M&&["MM",i]||1===j&&["y"]||["yy",j];return k[2]=b,k[3]=+a>0,k[4]=c,vc.apply(null,k)}function xc(a,b){return void 0===de[a]?!1:void 0===b?de[a]:(de[a]=b,!0)}function yc(a){var b=this.localeData(),c=wc(this,!a,b);return a&&(c=b.pastFuture(+this,c)),b.postformat(c)}function zc(){var a=ee(this.years()),b=ee(this.months()),c=ee(this.days()),d=ee(this.hours()),e=ee(this.minutes()),f=ee(this.seconds()+this.milliseconds()/1e3),g=this.asSeconds();return g?(0>g?"-":"")+"P"+(a?a+"Y":"")+(b?b+"M":"")+(c?c+"D":"")+(d||e||f?"T":"")+(d?d+"H":"")+(e?e+"M":"")+(f?f+"S":""):"P0D"}var Ac,Bc,Cc=a.momentProperties=[],Dc=!1,Ec={},Fc={},Gc=/(\[[^\[]*\])|(\\)?(Mo|MM?M?M?|Do|DDDo|DD?D?D?|ddd?d?|do?|w[o|w]?|W[o|W]?|Q|YYYYYY|YYYYY|YYYY|YY|gg(ggg?)?|GG(GGG?)?|e|E|a|A|hh?|HH?|mm?|ss?|S{1,4}|x|X|zz?|ZZ?|.)/g,Hc=/(\[[^\[]*\])|(\\)?(LTS|LT|LL?L?L?|l{1,4})/g,Ic={},Jc={},Kc=/\d/,Lc=/\d\d/,Mc=/\d{3}/,Nc=/\d{4}/,Oc=/[+-]?\d{6}/,Pc=/\d\d?/,Qc=/\d{1,3}/,Rc=/\d{1,4}/,Sc=/[+-]?\d{1,6}/,Tc=/\d+/,Uc=/[+-]?\d+/,Vc=/Z|[+-]\d\d:?\d\d/gi,Wc=/[+-]?\d+(\.\d{1,3})?/,Xc=/[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+|[\u0600-\u06FF\/]+(\s*?[\u0600-\u06FF]+){1,2}/i,Yc={},Zc={},$c=0,_c=1,ad=2,bd=3,cd=4,dd=5,ed=6;F("M",["MM",2],"Mo",function(){return this.month()+1}),F("MMM",0,0,function(a){return this.localeData().monthsShort(this,a)}),F("MMMM",0,0,function(a){return this.localeData().months(this,a)}),x("month","M"),K("M",Pc),K("MM",Pc,Lc),K("MMM",Xc),K("MMMM",Xc),N(["M","MM"],function(a,b){b[_c]=o(a)-1}),N(["MMM","MMMM"],function(a,b,c,d){var e=c._locale.monthsParse(a,d,c._strict);null!=e?b[_c]=e:c._pf.invalidMonth=a});var fd="January_February_March_April_May_June_July_August_September_October_November_December".split("_"),gd="Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec".split("_"),hd={};a.suppressDeprecationWarnings=!1;var id=/^\s*(?:[+-]\d{6}|\d{4})-(?:(\d\d-\d\d)|(W\d\d$)|(W\d\d-\d)|(\d\d\d))((T| )(\d\d(:\d\d(:\d\d(\.\d+)?)?)?)?([\+\-]\d\d(?::?\d\d)?|\s*Z)?)?$/,jd=[["YYYYYY-MM-DD",/[+-]\d{6}-\d{2}-\d{2}/],["YYYY-MM-DD",/\d{4}-\d{2}-\d{2}/],["GGGG-[W]WW-E",/\d{4}-W\d{2}-\d/],["GGGG-[W]WW",/\d{4}-W\d{2}/],["YYYY-DDD",/\d{4}-\d{3}/]],kd=[["HH:mm:ss.SSSS",/(T| )\d\d:\d\d:\d\d\.\d+/],["HH:mm:ss",/(T| )\d\d:\d\d:\d\d/],["HH:mm",/(T| )\d\d:\d\d/],["HH",/(T| )\d\d/]],ld=/^\/?Date\((\-?\d+)/i;a.createFromInputFallback=Z("moment construction falls back to js Date. This is discouraged and will be removed in upcoming major release. Please refer to https://github.com/moment/moment/issues/1407 for more info.",function(a){a._d=new Date(a._i+(a._useUTC?" UTC":""))}),F(0,["YY",2],0,function(){return this.year()%100}),F(0,["YYYY",4],0,"year"),F(0,["YYYYY",5],0,"year"),F(0,["YYYYYY",6,!0],0,"year"),x("year","y"),K("Y",Uc),K("YY",Pc,Lc),K("YYYY",Rc,Nc),K("YYYYY",Sc,Oc),K("YYYYYY",Sc,Oc),N(["YYYY","YYYYY","YYYYYY"],$c),N("YY",function(b,c){c[$c]=a.parseTwoDigitYear(b)}),a.parseTwoDigitYear=function(a){return o(a)+(o(a)>68?1900:2e3)};var md=A("FullYear",!1);F("w",["ww",2],"wo","week"),F("W",["WW",2],"Wo","isoWeek"),x("week","w"),x("isoWeek","W"),K("w",Pc),K("ww",Pc,Lc),K("W",Pc),K("WW",Pc,Lc),O(["w","ww","W","WW"],function(a,b,c,d){b[d.substr(0,1)]=o(a)});var nd={dow:0,doy:6};F("DDD",["DDDD",3],"DDDo","dayOfYear"),x("dayOfYear","DDD"),K("DDD",Qc),K("DDDD",Mc),N(["DDD","DDDD"],function(a,b,c){c._dayOfYear=o(a)}),a.ISO_8601=function(){};var od=Z("moment().min is deprecated, use moment.min instead. https://github.com/moment/moment/issues/1548",function(){var a=za.apply(null,arguments);return this>a?this:a}),pd=Z("moment().max is deprecated, use moment.max instead. https://github.com/moment/moment/issues/1548",function(){var a=za.apply(null,arguments);return a>this?this:a});Fa("Z",":"),Fa("ZZ",""),K("Z",Vc),K("ZZ",Vc),N(["Z","ZZ"],function(a,b,c){c._useUTC=!0,c._tzm=Ga(a)});var qd=/([\+\-]|\d\d)/gi;a.updateOffset=function(){};var rd=/(\-)?(?:(\d*)\.)?(\d+)\:(\d+)(?:\:(\d+)\.?(\d{3})?)?/,sd=/^(-)?P(?:(?:([0-9,.]*)Y)?(?:([0-9,.]*)M)?(?:([0-9,.]*)D)?(?:T(?:([0-9,.]*)H)?(?:([0-9,.]*)M)?(?:([0-9,.]*)S)?)?|([0-9,.]*)W)$/;Ua.fn=Da.prototype;var td=Ya(1,"add"),ud=Ya(-1,"subtract");a.defaultFormat="YYYY-MM-DDTHH:mm:ssZ";var vd=Z("moment().lang() is deprecated. Instead, use moment().localeData() to get the language configuration. Use moment().locale() to change languages.",function(a){return void 0===a?this.localeData():this.locale(a)});F(0,["gg",2],0,function(){return this.weekYear()%100}),F(0,["GG",2],0,function(){return this.isoWeekYear()%100}),xb("gggg","weekYear"),xb("ggggg","weekYear"),xb("GGGG","isoWeekYear"),xb("GGGGG","isoWeekYear"),x("weekYear","gg"),x("isoWeekYear","GG"),K("G",Uc),K("g",Uc),K("GG",Pc,Lc),K("gg",Pc,Lc),K("GGGG",Rc,Nc),K("gggg",Rc,Nc),K("GGGGG",Sc,Oc),K("ggggg",Sc,Oc),O(["gggg","ggggg","GGGG","GGGGG"],function(a,b,c,d){b[d.substr(0,2)]=o(a)}),O(["gg","GG"],function(b,c,d,e){c[e]=a.parseTwoDigitYear(b)}),F("Q",0,0,"quarter"),x("quarter","Q"),K("Q",Kc),N("Q",function(a,b){b[_c]=3*(o(a)-1)}),F("D",["DD",2],"Do","date"),x("date","D"),K("D",Pc),K("DD",Pc,Lc),K("Do",function(a,b){return a?b._ordinalParse:b._ordinalParseLenient}),N(["D","DD"],ad),N("Do",function(a,b){b[ad]=o(a.match(Pc)[0],10)});var wd=A("Date",!0);F("d",0,"do","day"),F("dd",0,0,function(a){return this.localeData().weekdaysMin(this,a)}),F("ddd",0,0,function(a){return this.localeData().weekdaysShort(this,a)}),F("dddd",0,0,function(a){return this.localeData().weekdays(this,a)}),F("e",0,0,"weekday"),F("E",0,0,"isoWeekday"),x("day","d"),x("weekday","e"),x("isoWeekday","E"),K("d",Pc),K("e",Pc),K("E",Pc),K("dd",Xc),K("ddd",Xc),K("dddd",Xc),O(["dd","ddd","dddd"],function(a,b,c){var d=c._locale.weekdaysParse(a);null!=d?b.d=d:c._pf.invalidWeekday=a}),O(["d","e","E"],function(a,b,c,d){b[d]=o(a)});var xd="Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),yd="Sun_Mon_Tue_Wed_Thu_Fri_Sat".split("_"),zd="Su_Mo_Tu_We_Th_Fr_Sa".split("_");F("H",["HH",2],0,"hour"),F("h",["hh",2],0,function(){return this.hours()%12||12}),Mb("a",!0),Mb("A",!1),x("hour","h"),K("a",Nb),K("A",Nb),K("H",Pc),K("h",Pc),K("HH",Pc,Lc),K("hh",Pc,Lc),N(["H","HH"],bd),N(["a","A"],function(a,b,c){c._isPm=c._locale.isPM(a),c._meridiem=a}),N(["h","hh"],function(a,b,c){b[bd]=o(a),c._pf.bigHour=!0});var Ad=/[ap]\.?m?\.?/i,Bd=A("Hours",!0);F("m",["mm",2],0,"minute"),x("minute","m"),K("m",Pc),K("mm",Pc,Lc),N(["m","mm"],cd);var Cd=A("Minutes",!1);F("s",["ss",2],0,"second"),x("second","s"),K("s",Pc),K("ss",Pc,Lc),N(["s","ss"],dd);var Dd=A("Seconds",!1);F("S",0,0,function(){return~~(this.millisecond()/100)}),F(0,["SS",2],0,function(){return~~(this.millisecond()/10)}),Qb("SSS"),Qb("SSSS"),x("millisecond","ms"),K("S",Qc,Kc),K("SS",Qc,Lc),K("SSS",Qc,Mc),K("SSSS",Tc),N(["S","SS","SSS","SSSS"],function(a,b){b[ed]=o(1e3*("0."+a))});var Ed=A("Milliseconds",!1);F("z",0,0,"zoneAbbr"),F("zz",0,0,"zoneName");var Fd=m.prototype;Fd.add=td,Fd.calendar=$a,Fd.clone=_a,Fd.diff=fb,Fd.endOf=pb,Fd.format=jb,Fd.from=kb,Fd.fromNow=lb,Fd.get=D,Fd.invalidAt=wb,Fd.isAfter=ab,Fd.isBefore=bb,Fd.isBetween=cb,Fd.isSame=db,Fd.isValid=ub,Fd.lang=vd,Fd.locale=mb,Fd.localeData=nb,Fd.max=pd,Fd.min=od,Fd.parsingFlags=vb,Fd.set=D,Fd.startOf=ob,Fd.subtract=ud,Fd.toArray=tb,Fd.toDate=sb,Fd.toISOString=ib,Fd.toJSON=ib,Fd.toString=hb,Fd.unix=rb,Fd.valueOf=qb,Fd.year=md,Fd.isLeapYear=fa,Fd.weekYear=zb,Fd.isoWeekYear=Ab,Fd.quarter=Fd.quarters=Db,Fd.month=V,Fd.daysInMonth=W,Fd.week=Fd.weeks=ka,Fd.isoWeek=Fd.isoWeeks=la,Fd.weeksInYear=Cb,Fd.isoWeeksInYear=Bb,Fd.date=wd,Fd.day=Fd.days=Jb,Fd.weekday=Kb,Fd.isoWeekday=Lb,Fd.dayOfYear=na,Fd.hour=Fd.hours=Bd,Fd.minute=Fd.minutes=Cd,Fd.second=Fd.seconds=Dd,Fd.millisecond=Fd.milliseconds=Ed,Fd.utcOffset=Ja,Fd.utc=La,Fd.local=Ma,Fd.parseZone=Na,Fd.hasAlignedHourOffset=Oa,Fd.isDST=Pa,Fd.isDSTShifted=Qa,Fd.isLocal=Ra,Fd.isUtcOffset=Sa,Fd.isUtc=Ta,Fd.isUTC=Ta,Fd.zoneAbbr=Rb,Fd.zoneName=Sb,Fd.dates=Z("dates accessor is deprecated. Use date instead.",wd),Fd.months=Z("months accessor is deprecated. Use month instead",V),Fd.years=Z("years accessor is deprecated. Use year instead",md),Fd.zone=Z("moment().zone is deprecated, use moment().utcOffset instead. https://github.com/moment/moment/issues/1779",Ka);var Gd=Fd,Hd={sameDay:"[Today at] LT",nextDay:"[Tomorrow at] LT",nextWeek:"dddd [at] LT",lastDay:"[Yesterday at] LT",lastWeek:"[Last] dddd [at] LT",sameElse:"L"},Id={LTS:"h:mm:ss A",LT:"h:mm A",L:"MM/DD/YYYY",LL:"MMMM D, YYYY",LLL:"MMMM D, YYYY LT",LLLL:"dddd, MMMM D, YYYY LT"},Jd="Invalid date",Kd="%d",Ld=/\d{1,2}/,Md={future:"in %s",past:"%s ago",s:"a few seconds",m:"a minute",mm:"%d minutes",h:"an hour",hh:"%d hours",d:"a day",dd:"%d days",M:"a month",MM:"%d months",y:"a year",yy:"%d years"},Nd=q.prototype;Nd._calendar=Hd,Nd.calendar=Vb,Nd._longDateFormat=Id,Nd.longDateFormat=Wb,Nd._invalidDate=Jd,Nd.invalidDate=Xb,Nd._ordinal=Kd,Nd.ordinal=Yb,Nd._ordinalParse=Ld,
Nd.preparse=Zb,Nd.postformat=Zb,Nd._relativeTime=Md,Nd.relativeTime=$b,Nd.pastFuture=_b,Nd.set=ac,Nd.months=R,Nd._months=fd,Nd.monthsShort=S,Nd._monthsShort=gd,Nd.monthsParse=T,Nd.week=ha,Nd._week=nd,Nd.firstDayOfYear=ja,Nd.firstDayOfWeek=ia,Nd.weekdays=Fb,Nd._weekdays=xd,Nd.weekdaysMin=Hb,Nd._weekdaysMin=zd,Nd.weekdaysShort=Gb,Nd._weekdaysShort=yd,Nd.weekdaysParse=Ib,Nd.isPM=Ob,Nd._meridiemParse=Ad,Nd.meridiem=Pb,u("en",{ordinalParse:/\d{1,2}(th|st|nd|rd)/,ordinal:function(a){var b=a%10,c=1===o(a%100/10)?"th":1===b?"st":2===b?"nd":3===b?"rd":"th";return a+c}}),a.lang=Z("moment.lang is deprecated. Use moment.locale instead.",u),a.langData=Z("moment.langData is deprecated. Use moment.localeData instead.",w);var Od=Math.abs,Pd=rc("ms"),Qd=rc("s"),Rd=rc("m"),Sd=rc("h"),Td=rc("d"),Ud=rc("w"),Vd=rc("M"),Wd=rc("y"),Xd=tc("milliseconds"),Yd=tc("seconds"),Zd=tc("minutes"),$d=tc("hours"),_d=tc("days"),ae=tc("months"),be=tc("years"),ce=Math.round,de={s:45,m:45,h:22,d:26,M:11},ee=Math.abs,fe=Da.prototype;fe.abs=ic,fe.add=kc,fe.subtract=lc,fe.as=pc,fe.asMilliseconds=Pd,fe.asSeconds=Qd,fe.asMinutes=Rd,fe.asHours=Sd,fe.asDays=Td,fe.asWeeks=Ud,fe.asMonths=Vd,fe.asYears=Wd,fe.valueOf=qc,fe._bubble=mc,fe.get=sc,fe.milliseconds=Xd,fe.seconds=Yd,fe.minutes=Zd,fe.hours=$d,fe.days=_d,fe.weeks=uc,fe.months=ae,fe.years=be,fe.humanize=yc,fe.toISOString=zc,fe.toString=zc,fe.toJSON=zc,fe.locale=mb,fe.localeData=nb,fe.toIsoString=Z("toIsoString() is deprecated. Please use toISOString() instead (notice the capitals)",zc),fe.lang=vd,F("X",0,0,"unix"),F("x",0,0,"valueOf"),K("x",Uc),K("X",Wc),N("X",function(a,b,c){c._d=new Date(1e3*parseFloat(a,10))}),N("x",function(a,b,c){c._d=new Date(o(a))}),a.version="2.10.2",b(za),a.fn=Gd,a.min=Ba,a.max=Ca,a.utc=i,a.unix=Tb,a.months=dc,a.isDate=e,a.locale=u,a.invalid=k,a.duration=Ua,a.isMoment=n,a.weekdays=fc,a.parseZone=Ub,a.localeData=w,a.isDuration=Ea,a.monthsShort=ec,a.weekdaysMin=hc,a.defineLocale=v,a.weekdaysShort=gc,a.normalizeUnits=y,a.relativeTimeThreshold=xc;var ge=a;return ge});


if (buffer == null)
{
	buffer = require('buffer');
}
if (pako == null)
{
	 pako = require('pako');
}
if (moment == null)
{
	moment = require('moment');
}

var vlocityPdfWriter = (function () {

	var SUPPORTED_PDF_VERSION = 1.5;
	
	var vPdfWriter = {};
	
	var _cachedBuffers = {};

	function getBuffer(stringVal)
	{
		if (_cachedBuffers[stringVal] == null)
		{
			_cachedBuffers[stringVal] = new buffer.Buffer(stringVal);
		}

		return _cachedBuffers[stringVal];
	}

	var CARRIAGE_RETURN = new buffer.Buffer([13]);
	var OBJECT_IDENTIFIER = new buffer.Buffer(' obj');
	var OBJECT_END_IDENTIFIER = new buffer.Buffer('endobj');
	var XREF_IDENTIFIER_LONG = new buffer.Buffer('startxref');
	var XREF_IDENTIFIER = new buffer.Buffer('xref');
	var XREF_STREAM_IDENTIFIER = new buffer.Buffer('/XRef/');
	var EOF_IDENTIFIER = new buffer.Buffer('%%EOF');
	var FLATE_IDENTIFIER = new buffer.Buffer('FlateDecode');
	var ANNOTATION_OBJECT_TOKEN = new buffer.Buffer('<</AP');
	var WIDGET_IDENTIFIER = new buffer.Buffer('Widget');
	var OPEN_STREAM_IDENTIFIER = new buffer.Buffer('stream');
	var ENDOBJ = new buffer.Buffer('endobj');
	var ENDSTREAM = new buffer.Buffer('endstream');
                                                             
	var FULL_CHAR_MAP = { 'A':'101', 'Æ':'306', 'Á':'301', 'Â':'302', 'Ä':'304', 'À':'300', 'Å':'305', 'Ã':'303', 'B':'102', 'C':'103', 'Ç':'307', 'D':'104', 'E':'105', 'É':'311', 'Ê':'312', 'Ë':'313', 'È':'310', 'Ð':'320', '€':'240', 'F':'106', 'G':'107', 'H':'110', 'I':'111', 'Í':'315', 'Î':'316', 'Ï':'317', 'Ì':'314', 'J':'112', 'K':'113', 'L':'114', 'Ł':'225', 'M':'115', 'N':'116', 'Ñ':'321', 'O':'117', 'OE':'226', 'Ó':'323', 'Ô':'324', 'Ö':'326', 'Ò':'322', 'Ø':'330', 'Õ':'325', 'P':'120', 'Q':'121', 'R':'122', 'S':'123', 'Š':'227', 'T':'124', 'Þ':'336', 'U':'125', 'Ú':'332', 'Û':'333', 'Ü':'334', 'Ù':'331', 'V':'126', 'W':'127', 'X':'130', 'Y':'131', 'Ý':'335', 'Ÿ':'230', 'Z':'132', 'Ž':'231', 'a':'141', 'á':'341', 'â':'342', '´':'264', 'ä':'344', 'æ':'346', 'à':'340', '&':'046', 'å':'345', '^':'136', '~':'176', '*':'052', '@':'100', 'ã':'343', 'b':'142', '\\':'134', '|':'174', '{':'173', '}':'175', '[':'133', ']':'135', '˘':'030', '¦':'246', '•':'200', 'c':'143', 'ˇ':'031', 'ç':'347', '¸':'270', '¢':'242', 'ˆ':'032', ':':'072', ',':'054', '©':'251', '¤':'244', 'd':'144', '†':'201', '‡':'202', '°':'260', '¨':'250', '÷':'367', '$':'044', '˙':'033', 'ı':'232', 'e':'145', 'é':'351', 'ê':'352', 'ë':'353', 'è':'350', '8':'070', '…':'203', '—':'204', '–':'205', '=':'075', 'ð':'360', '!':'041', '¡':'241', 'f':'146', 'fi':'223', '5':'065', 'fl':'224', 'ƒ':'206', '4':'064', '⁄':'207', 'g':'147', 'ß':'337', '`':'140', '>':'076', '«':'253', '»':'273', '‹':'210', '›':'211', 'h':'150', '˝':'034', '-':'055', 'i':'151', 'í':'355', 'î':'356', 'ï':'357', 'ì':'354', 'j':'152', 'k':'153', 'l':'154', '<':'74', '¬':'254', 'ł':'233', 'm':'155', '¯':'257', '−':'212', 'μ':'265', '×':'327', 'n':'156', '9':'071', 'ñ':'361', '#':'043', 'o':'157', 'ó':'363', 'ô':'364', 'ö':'366', 'oe':'234', '˛':'035', 'ò':'362', '1':'061', '½':'275', '¼':'274', '¹':'271', 'ª':'252', 'º':'272', 'ø':'370', 'õ':'365', 'p':'160', '¶':'266', '(':'050', ')':'051', '%':'045', '.':'056', '·':'267', '‰':'213', '+':'053', '±':'261', 'q':'161', '?':'077', '¿':'277', 'r':'162', '®':'256', '°':'036', 's':'163', 'š':'235', '§':'247', ';':'073', '7':'067', '6':'066', '/':'057', '':'040', '£':'243', 't':'164', 'þ':'376', '3':'063', '¾':'276', '³':'263', '˜':'037', '™':'222', '2':'062', '²':'262', 'u':'165', 'ú':'372', 'û':'373', 'ü':'374', 'ù':'371', '_':'137', 'v':'166', 'w':'167', 'x':'170', 'y':'171', 'ý':'375', 'ÿ':'377', '¥':'245', 'z':'172', 'ž':'236', '0':'060' };                                                                                                                                                                

	// Utility Methods
	function inflate(streamInfo)
	{
		return new buffer.Buffer(pako.inflate(new Uint8Array(streamInfo)));
	}

	vPdfWriter.getAsDate = function(date, options)
	{
		if (date == null)
		{
			return null;
		}

		// http://stackoverflow.com/questions/3143070/javascript-regex-iso-datetime
		var matchArray = date.match(/\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d\.\d+([+-][0-2]\d:[0-5]\d|Z)/);

		if (matchArray != null)
		{
			// Default Date Time Formats from moment.js
			var DEFAULTS = { timeFormat: 'h:mm a' , dateFormat: 'MM/DD/YYYY', dateTimeFormat: 'MM/DD/YYYY h:mm a' };
			
			var momentDate = moment(date);

			var format = 'dateTimeFormat';

			if (momentDate.dayOfYear() == 1 && momentDate.year() == 1970)
			{
				 format = 'timeFormat';
			}
			else if (momentDate.hours() == 0 && momentDate.minutes() == 0 && momentDate.seconds() == 0 && momentDate.milliseconds() == 0)
			{
				format = 'dateFormat';
			}

			var stringFormat = options != null ? options[format] : null;

			if (!stringFormat)
			{
				stringFormat = DEFAULTS[format];
			}

			var returnFormatted = momentDate.format(stringFormat);

			if (returnFormatted == 'Invalid Date')
			{
				return date;
			}

			return String(returnFormatted);
		}
		else
		{
			return date;
		}
	}

	function sameBuffer(buff1, buff2) {

	    if (buff1.length != buff2.length) return false;

	    for (var i = 0; i < buff1.length; i++) {
	        if (buff1[i] != buff2[i]) {
	            return false;
	        }
	    }

	    return true;
	}

	function indexOf(source, finding, startIndex) {

	    for (var i = startIndex != null ? startIndex : 0; i < source.length; i++) {

	        //console.log(source.length);

			if (finding instanceof Number)
		    {
		    	if (source[i] == finding)
		    	{
		    		return i;
		    	}
		    }
		    else if (finding instanceof String)
		    {
		    	if (String.fromCharCode(source[i]) == finding)
		    	{
		    		return i;
		    	}
		    }
			else if (finding instanceof Array) {
				
	            for (var f = 0; f < finding.length; f++) {
	                if (sameBuffer(finding[f], source.slice(i, i + finding[f].length))) {
	                    return i;
	                }
	            }
	        } else if (sameBuffer(finding, source.slice(i, i + finding.length))) {
	            return i;
	        }
	    }

	    return -1;
	}

	function previousIndexOf(source, finding, startIndex) {

	    for (var i = startIndex != null ? startIndex : 0; i >= 0; i--) {
	        if (finding instanceof Array) {
	            for (var f = 0; f < finding.length; f++) {
	                if (sameBuffer(finding[f], source.slice(i, i + finding[f].length))) {
	                    return i;
	                }
	            }
	        } else if (sameBuffer(finding, source.slice(i, i + finding.length))) {
	            return i;
	        }
	    }

	    return -1;
	}

	function firstIndexAfter(source, finding, startIndex) {

	    for (var i = startIndex != null ? startIndex : 0; i < source.length; i++) {
	        //console.log(source.length);
	        if (finding instanceof Array) {
	            for (var f = 0; f < finding.length; f++) {
	                if (sameBuffer(finding[f], source.slice(i, i + finding[f].length))) {
	                    return i + finding[f].length + 1;
	                }
	            }
	        } else if (sameBuffer(finding, source.slice(i, i + finding.length))) {
	            return i + finding.length + 1;
	        }
	    }
	}

	function extractBetween(buff, startString, endString, startingIndex) {
	    var sliceStart = firstIndexAfter(buff, startString, startingIndex)-1;
	    var sliceEnd = indexOf(buff, endString, sliceStart);

	    return buff.slice(sliceStart, sliceEnd+1);
	}

	function getLine(buff, currentIndex) {
	    var lineStart = Math.max(0, previousIndexOf(buff, [getBuffer("\n"), CARRIAGE_RETURN], currentIndex));

	    var endOfLine = indexOf(buff, [getBuffer("\n"), CARRIAGE_RETURN], currentIndex);

	    if (endOfLine == -1) {
	        endOfLine = buff.length;
	    }

	    while (lineStart < endOfLine && (buff[lineStart] == 10 || buff[lineStart] == 13)) // \n and \r
	    {
	    	lineStart++;
	    }

	    return buff.slice(lineStart, endOfLine);
	}

	function rectangleToBBox(rect)
	{
		var bbox = [0, 0, ];

		bbox.push(rect[2]-rect[0]);
		bbox.push(rect[3]-rect[1]);

		return bbox; 
	}

	function getPDFVersion(parentBuffer) {

		try {
			var version = getLine(parentBuffer, 0).toString('ascii');

			if (version == undefined) return 0;

	    	return parseFloat(version.replace("%PDF-", ""));
		}
		catch (err)
		{
			console.log(err);
			return 0;
		}
	}

	// PNG Up Predictor - https://forums.adobe.com/thread/664902 and http://www.w3.org/TR/PNG-Filters.html
	function pngUp(objectInfo) {
	    var retArray = [];

	    var max = 0;

	    for (var i = 0; i < objectInfo.length; i++) {
	       max = Math.max(objectInfo[i].index, max);
	    }

	    var hexLength = Math.floor((max.toString(16).length + 1) / 2);

	    // First and Last values are always short, middle values are split hex string value of byte indecies of objects in pdf
	    var previousRow = [];

	    while (previousRow.length < hexLength + 2)
	    {
	    	 previousRow.push(0);
	    }
	    //console.log(previousRow);

	    for (var i = 0; i < objectInfo.length; i++) {

	        var asHex = (objectInfo[i].index).toString(16);

	        // Need to pad hex string with 0's
	        while (asHex.length < hexLength * 2) {
	            asHex = '0' + asHex;
	        }

	       //console.log(asHex);

	        var thisRow = [];
	        var nextPreviousRow = [];

	        // 0 is always type
	        thisRow.push(objectInfo[i].type - Math.abs(previousRow[0]));
	        nextPreviousRow.push(objectInfo[i].type);

	        var rowIndex = 1;

	        // The middle two variables are the index converted to hex then split into the columns
	        for (; rowIndex < hexLength+1; rowIndex++)
	        {
	        	var hexIndex = rowIndex*2;
	        	var hexIndex = parseInt(asHex.substring(hexIndex-2, hexIndex), 16);

	        	thisRow.push(hexIndex - Math.abs(previousRow[rowIndex]));
	        	nextPreviousRow.push(hexIndex);
	        }

	        previousRow = nextPreviousRow;

	        retArray.push(2); // Always first in PNG UP
	        retArray = retArray.concat(thisRow);
	    }

	    //console.log(retArray);

	    return { retArray: retArray, wLength: hexLength };
	}

	// Any keys that are added programatically should their separator listed here
	var seperatorTypesToKeys = {
		" ": ["Length", "Parent", "Root", "First", "Columns", "N", "Predictor", "Prev", "Size", "FormType", "P", "Ff"],
	    "/": ["Filter", "Type", "Subtype", "FT"],
	    "[": ["BBox", "W", "Rect", "Index", "Kids", "BC", "BG"],
	    "(": ["T", "V", "DA"],
	    "<": ["DecodeParms", "AP", "MK", "Resources", "Font"]
	}

	var nonHeirarchicalProperties = ["Type", "Subtype", "Parent"];

	function getSeperatorForKey(key)
	{
		for (var type in seperatorTypesToKeys)
		{
			if (seperatorTypesToKeys.hasOwnProperty(type))
			{
				if (seperatorTypesToKeys[type].indexOf(key) != -1)
				{
					return type;
				}
			}
		}

		return null;
	}

	function copyProperty(obj1, obj2, key)
	{
		if (obj2.propertyDictionary[key] != null)
		{
			obj1.propertyDictionary[key] = obj2.propertyDictionary[key];
		}
	}

	function PdfDictEntry(key, value, sep)
	{
		if (value instanceof PdfDictEntry)
		{
			this.key = key;
			this.value = value.value;
			this.seperatorChar = value.seperatorChar;
		}
		else
		{
			this.key = key;
			this.seperatorChar = sep;

			if (this.seperatorChar == "[")
			{
				if (Array.isArray(value))
				{
					this.value = value; 
				}
				else
				{
					this.value = value.substring(1, value.length-1).split(" ");
				}
			}
			else if (this.seperatorChar == "(")
			{
				if (value[0] == "(" && value[value.length-1] == ")")
				{
					this.value = value.substring(1, value.length-1);
				}
				else
				{
					this.value = value;
				}
			}
			else
			{
				this.value = value;
			}
		}
	}

	PdfDictEntry.prototype = {
		constructor: PdfDictEntry,

		getKey: function(atIndex, values)
		{
			if (this.seperatorChar == "<")
			{
				var currentKey = values[atIndex];

				if (currentKey == null) return this.value;

				if (this.value[currentKey] instanceof PdfDictEntry)
				{
					return this.value[currentKey].getKey(++atIndex, values);
				}

				if (this.value[currentKey] == null) return null;
	
				return this.value[currentKey].getKey(currentKey);
			}

			return this.value;
		},

		toStringPdf: function()
		{
			if (this.seperatorChar == "[")
			{
				if (this.value instanceof Array)
				{
					return this.key + "[" + this.value.join(" ") + "]"; 
				}

				return this.key + this.value; 
			}
			else if (this.seperatorChar == "(")
			{
				return this.key + "(" + this.value + ")"; 
			}
			else if (this.seperatorChar == "/")
			{
				return this.key + "/" + this.value; 
			}
			else if (this.seperatorChar == "<")
			{
				var fullString = "<<"; 

				if (this.value != null)
				{
					var propertyArray = Object.keys(this.value);

					for (var i = 0; i < propertyArray.length; i++)
					{	
						if (this.value[propertyArray[i]] != null)
						{
							fullString += "/";
							fullString += this.value[propertyArray[i]].toStringPdf();
						}
					}
				}

				return this.key + fullString + ">>";
			}
			else if (this.seperatorChar == " ")
			{
				return this.key + " " + this.value; 
			}
			else if (this.value instanceof Object)
			{
				var propertyArray = Object.keys(this.value);

				var fullString = this.key + "<<"; 

				for (var i = 0; i < propertyArray.length; i++)
				{	
					if (this.value[propertyArray[i]] != null)
					{
						fullString += "/";
						var pdfDictTemp = new PdfDictEntry(propertyArray[i], this.value[propertyArray[i]], getSeperatorForKey(propertyArray[i]));
						fullString += pdfDictTemp.toStringPdf();						
					}
				}


				return fullString + ">>";
			}

			return this.key + " " + this.value; 
		}
	}

	function getObjectsFromStream(firstObjectIndex, streamData) {
	  	
	  	firstObjectIndex = parseInt(firstObjectIndex);
	    var objectIdBuffer = streamData.slice(0, firstObjectIndex - 1);
	    var objectIdsAndIndex = objectIdBuffer.toString('utf8').split(' ');

	    var objectsInStream = [];

	    for (var i = 0; i < objectIdsAndIndex.length; i = i + 2) 
	    {
	    	var objectId = parseInt(objectIdsAndIndex[i]);
	    	var startOfObject = parseInt(objectIdsAndIndex[i + 1]) + firstObjectIndex;

	        var endOfObject;
	        if (i == objectIdsAndIndex.length - 2) {
	            endOfObject = streamData.length;
	        } else {
	            endOfObject = parseInt(objectIdsAndIndex[i + 3]) + firstObjectIndex - 1;
	        }
	 
	        objectsInStream.push(new StreamObject(objectId, streamData.slice(startOfObject, endOfObject)));
	    }
	    
	    return objectsInStream;
	}


	function escapeChar(char)
	{
		if (FULL_CHAR_MAP[char])
		{
			return '\\' + FULL_CHAR_MAP[char];
		}
		else
		{
			return char;
		}
	}

	function escapeTextForTextField(text)
	{	
		var pdfEncodedText = '';

		for (var i = 0; i < text.length; i++)
		{
			pdfEncodedText += escapeChar(text[i]);
		}
        
		return pdfEncodedText;
	}

	// Default Text Creation for a Field
	function getDefaultFieldText(fontInfo, bbox, text)
	{
		var bboxHeight = bbox[3]-bbox[1];

		var heightOffset = bboxHeight * .25;

		return "/Tx BMC \nBT\n" + fontInfo + "\n2 " + heightOffset + " Td\n(" + escapeTextForTextField(text) + ") Tj\nET\nEMC";
	}

	function TextObject(text)
	{
		// Example
		// "/Tx BMC \nBT\n0 0 0 rg /F3 11 Tf\n0 g\n2 2.106 Td\n(zzzzzzzzzz) Tj\nET\nEMC\n"

		this.properties = {};
		this.rawText = text;
		var textArray = text.split("\n");

		for (var i = 0; i < textArray.length; i++)
		{
			var textLineArray = textArray[i].split(" ");

			var key = textLineArray[textLineArray.length-1];

			this.properties[key] = textArray[i];
		}
	}

	TextObject.prototype = {
		constructor: TextObject,

		getProperty: function(property)
	    {
	    	return this.properties[key];
	    },

	    // TABLE 3.2 Escape sequences in literal strings
		// Need to Additionally Escape (, ), \

		replaceText: function(newText)
		{
			var openTextIndex;
			var closedTextIndex;

			for (var i = 1; i < this.rawText.length; i++)
			{
				if (this.rawText[i-1] != "\\")
				{
					if (this.rawText[i] == "(" && openTextIndex == null)
					{
						openTextIndex = i;
					}
					else if (this.rawText[i] == ")" && closedTextIndex == null)
					{
						closedTextIndex = i;
					}
				}
			}

			return this.rawText.substring(0, openTextIndex+1) + escapeTextForTextField(newText) + this.rawText.substring(closedTextIndex, this.rawText.length-1);
		}
	}

	function PdfObject(fullObject, indexOfObject) {

	    this.Id = getLine(fullObject, 0).toString();
	    this.indexOfObject = indexOfObject;

	    this.objectIdInt;
	    this.streamData = [];

	    if (this.Id.indexOf('obj') != -1)
	    {
			this.objectIdInt = this.Id.split(" ")[0];
	    }

	    var objectInfoEndIndex = indexOf(fullObject, [ OPEN_STREAM_IDENTIFIER, OBJECT_END_IDENTIFIER, XREF_IDENTIFIER ]);
		
		this.propertyDictionary = parseObjectData(fullObject.slice(0, objectInfoEndIndex)).obj;

	    var streamStart = firstIndexAfter(fullObject, [ OPEN_STREAM_IDENTIFIER ]);
		
		if (streamStart != -1)
		{
			while (fullObject[streamStart] == 13 || fullObject[streamStart] == 10) { // \n || \r
				streamStart++;
	        }

			var streamEnder = indexOf(fullObject, ENDSTREAM);

			if (this.getProperty("Filter") == "FlateDecode" || (Array.isArray(this.getProperty("Filter")) && this.getProperty("Filter")[0] == "/FlateDecode"))
			{
				var inflated = inflate(fullObject.slice(streamStart, streamEnder));

				if (this.getProperty("Type") == "ObjStm")
				{
					this.streamData = getObjectsFromStream(this.getProperty("First"), inflated);
				}
				else if (this.getProperty("Type") == "XRef")
				{
					// Not sure I care
					getXRefStreamInfo(this, inflated);
				}
				else
				{
					var streamBlob = inflated.toString('ascii');

					if (streamBlob.indexOf("BT") > -1)
					{
						this.textObject = new TextObject(streamBlob);
					}
				}
			}
			else
			{
				var streamBlob = fullObject.slice(streamStart, streamEnder).toString('ascii');

				if (streamBlob.indexOf("BT") > -1 && streamBlob.indexOf("ET") > -1 )
				{
					this.textObject = new TextObject(streamBlob);
				}
			}

		}
	}


	PdfObject.prototype = {
		constructor: PdfObject,

		getProperty: function(property, key)
	    {
	    	if (this.propertyDictionary[arguments[0]] == null) return null;

			return this.propertyDictionary[arguments[0]].getKey(1, arguments);
	    },

	    getPropertyKeys: function()
	    {
	    	return Object.keys(this.propertyDictionary);
	    },

	    getReferenceId: function()
	    {
	    	return this.objectIdInt + " 0 R";
	    },

		toStringPdf: function()
		{
			var ret = this.Id;

			ret += "\n<<";

			var propertyArray = Object.keys(this.propertyDictionary);

			for (var i = 0; i < propertyArray.length; i++)
			{
				if ( this.propertyDictionary[propertyArray[i]] != null)
				{
					ret += "/";
					ret += this.propertyDictionary[propertyArray[i]].toStringPdf();
				}
			}

			ret += ">>";

			ret += "stream\n";
			if (this.streamData)
			{
				for (var i = 0; i < this.streamData.length; i++)
				{
					ret += this.streamData[i].toStringPdf();
				}
				
			}

			if (this.textObject != null)
			{
				ret += this.textObject.rawText + "\n";
			}

			ret += "endstream";
			ret += "\nendobj\n";
			
			return ret;	
		}
	}

	function StreamObject(id, objectdata)
	{
		this.Id = id;
		this.propertyDictionary = parseObjectData(objectdata).obj;
	}

	StreamObject.prototype = new Object();
	StreamObject.prototype.constructor = StreamObject;

	StreamObject.prototype.getProperty = function()
	{
		if (this.propertyDictionary[arguments[0]] == null) return null;

		return this.propertyDictionary[arguments[0]].getKey(1, arguments);
	}

	StreamObject.prototype.getPropertyKeys = function()
    {
    	return Object.keys(this.propertyDictionary);
    }

    StreamObject.prototype.getReferenceId = function()
    {
    	return this.Id + " 0 R";
    }

	StreamObject.prototype.toStringPdf = function()
    {
    	var ret = "Stream " + this.Id;

		ret += " <<";

		var propertyArray = Object.keys(this.propertyDictionary);

		for (var i = 0; i < propertyArray.length; i++)
		{
			if (this.propertyDictionary[propertyArray[i]] != null)
			{
				ret += "/";
				ret += this.propertyDictionary[propertyArray[i]].toStringPdf();
			}
		}

		ret += ">>\n";

		return ret;

    }

	function addProperty(obj, key, value, sep)
	{
		if (sep == null)
		{
			sep = getSeperatorForKey(key);
		}

		obj[key] = new PdfDictEntry(key, value, sep);
	}

	function PdfWriteStreamBlob(textBlob)
	{
		this.blob = textBlob;
	}

	function PdfWriteStreamObject(copyObject)
	{
		this.Id = copyObject.Id;
		this.propertyDictionary = copyObject.propertyDictionary;
	}

	PdfWriteStreamObject.prototype = new Object();
	
	PdfWriteStreamObject.prototype.constructor = PdfWriteStreamObject;

	PdfWriteStreamObject.prototype.addProperty = function(key, value, sep)
	{
		if (value instanceof Object && !(value instanceof Array))
		{
			addProperty(this.propertyDictionary, key, parseObjectData(value).obj, sep);
		}
		else
		{
			addProperty(this.propertyDictionary, key, value, sep);
		}
	}

	PdfWriteStreamObject.prototype.removeProperty = function(key)
	{
		delete this.propertyDictionary[key];
	}

	PdfWriteStreamObject.prototype.getProperty = function(property, key)
	{
		if (this.propertyDictionary[arguments[0]] == null) return null;

		return this.propertyDictionary[arguments[0]].getKey(1, arguments);
	}

	PdfWriteStreamObject.prototype.toPdfBuffer = function()
	{
		var bufferArray = [new buffer.Buffer("<<")];

		var propertyArray = Object.keys(this.propertyDictionary);

		for (var i = 0; i < propertyArray.length; i++)
		{
			if (this.propertyDictionary[propertyArray[i]] != null)
			{
				bufferArray.push(new buffer.Buffer("/"));
				bufferArray.push(new buffer.Buffer(this.propertyDictionary[propertyArray[i]].toStringPdf()));
			}
		}

		bufferArray.push(new buffer.Buffer(">>"));

		return buffer.Buffer.concat(bufferArray);
	}

	function PdfWriteObject(id)
	{
		this.Id = id;
		this.propertyDictionary = {};
		this.stream = [];
		this.XRefObjectIds = [];
		this.asBuffer;
	}

	PdfWriteObject.prototype = new Object();
	
	PdfWriteObject.prototype.constructor = PdfWriteObject;

	PdfWriteObject.prototype.idObjString = function()
	{
		return this.Id + " 0 obj";
	}

	PdfWriteObject.prototype.addProperty =function(key, value)
	{
		if (value instanceof Object && !(value instanceof Array))
		{
			addProperty(this.propertyDictionary, key, parseObjectData(value).obj);
		}
		else
		{
			addProperty(this.propertyDictionary, key, value);
		}
	}

  	PdfWriteObject.prototype.getProperty = function(property, key)
    {
    	if (this.propertyDictionary[arguments[0]] == null) return null;

		return this.propertyDictionary[arguments[0]].getKey(1, arguments);
    }

	PdfWriteObject.prototype.addToStream = function(obj)
	{
		this.stream.push(obj);
	}

	PdfWriteObject.prototype.getXRefIds = function()
	{
		var xrefIds = [];

		for (var i = 0; i < this.stream.length; i++)
		{
			if (this.stream[i].Id != null)
			{
				// Parent or steam?
				xrefIds.push({type: 2, Id: this.Id, indexId: this.stream[i].Id });
			}
		}

		xrefIds.push({type: 1, Id: this.Id, indexId: this.Id });

		return xrefIds;
	}

	// Only supporting 1 object per stream for now.
	PdfWriteObject.prototype.getStreamBuffer = function()
	{
		if (this.stream.length != 0)
		{
			var streamObjectArray = 0;
			var streamData;

			if (this.stream[0].Id != null)
			{
				streamObjectArray = this.stream[0].Id + " 0 ";
				this.addProperty("First", streamObjectArray.length);
			}

			if (this.getProperty("Filter") != null)
			{
				var buffersToDeflateArray = [];

				if (this.getProperty("Type") == "ObjStm")
				{
					buffersToDeflateArray.push(new buffer.Buffer(streamObjectArray));
				}

				if (this.stream[0] instanceof PdfWriteStreamObject)
				{
					buffersToDeflateArray.push(this.stream[0].toPdfBuffer());
				}
				else
				{
					buffersToDeflateArray.push(this.stream[0]);
				}

				streamData = new buffer.Buffer(pako.deflate(new Uint8Array(buffer.Buffer.concat(buffersToDeflateArray))));
			}
			else
			{
				if (this.stream[0] instanceof PdfWriteStreamBlob)
				{
					streamData = new buffer.Buffer(this.stream[0].blob);
				}
				else
				{
					streamData = this.stream[0].toPdfBuffer();
				}
			}

			this.addProperty("Length", streamData.length);

			return streamData;
		}

		return null;
	}

	PdfWriteObject.prototype.toPdfBuffer = function()
	{
		if (this.asBuffer == null)
		{
			var bufferArray = [new buffer.Buffer(this.idObjString() + "\n<<")];
			var streamBuffer = this.getStreamBuffer();

			var propertyArray = Object.keys(this.propertyDictionary);

			for (var i = 0; i < propertyArray.length; i++)
			{
				if (this.propertyDictionary[propertyArray[i]] != null)
				{
					bufferArray.push(new buffer.Buffer("/"));
					bufferArray.push(new buffer.Buffer(this.propertyDictionary[propertyArray[i]].toStringPdf()));
				}
			}

			bufferArray.push(new buffer.Buffer(">>"));

			if (streamBuffer != null)
			{
				bufferArray.push(new buffer.Buffer("stream\n"));
				bufferArray.push(streamBuffer);
				bufferArray.push(new buffer.Buffer("\nendstream"));
			}

			bufferArray.push(new buffer.Buffer("\nendobj\n"));

			this.asBuffer = buffer.Buffer.concat(bufferArray);
		}

		return this.asBuffer;
	}

	function parseObjectData(objData)
	{
		var parsedObject = {};
		var finalIndex = 0;

		if (buffer.Buffer.isBuffer(objData))
		{
			var keyString;
			var valueObj;
			var seperatorChar;

			var openObject = false;

			while (finalIndex < objData.length)
			{
				var curChar = String.fromCharCode(objData[finalIndex]);
	
				if (keyString == null)
				{
					if (curChar == "<" || curChar == "/")
					{
						// DO NOTHING
						openObject = true;
					}
					else if (curChar == ">")
					{
						break;
					}
					else if (openObject)
					{
						keyString = curChar;
					}
				}
				else if (valueObj == null)
				{
					if (curChar == "<")
					{
						var parseReturn = parseObjectData(objData.slice(finalIndex));

						addProperty(parsedObject, keyString, parseReturn.obj, curChar);

						finalIndex += parseReturn.finalIndex + 1;

						keyString = null;
						valueObj = null;
						seperatorChar = null;
					}
					else if (curChar == "/" || curChar == " " || curChar == "[" || curChar == "(")
					{
						valueObj = "";

						if (curChar == "[" || curChar == "(")
						{
							valueObj += curChar;
						}

						seperatorChar = curChar;
					}
					else
					{
						keyString += curChar;
					}
				}
				else 
				{
					if (seperatorChar != "[" && seperatorChar != "(" && curChar == ">")
					{
						addProperty(parsedObject, keyString, valueObj, seperatorChar);

						break; 
					}
					else if ((seperatorChar == "[" && curChar == "]") 
						|| (seperatorChar == "(" && curChar == ")")
						|| ((seperatorChar == " " || seperatorChar == "/") && (curChar == "/")))
					{
						if (curChar == "]" || curChar == ")")
						{
							valueObj += curChar;
						}

						addProperty(parsedObject, keyString, valueObj, seperatorChar);

						keyString = null;
						valueObj = null;
						seperatorChar = null;
					}
					else
					{
						valueObj += curChar;
					}
				}

				finalIndex++;
			}
		}
		else if (objData instanceof Object)
		{
			Object.keys(objData).forEach(function (key) {
				addProperty(parsedObject, key, objData[key]);
			});	
		}

		return { obj: parsedObject, finalIndex: finalIndex };
	}

	function getXRefStreamInfo(header, xrefStream) {

	    var WArray = header.getProperty("W");

	    var bufferForXref = [];

	    var xrefObjs = [];

	    var types = [];
	    var offsets = '';
	    var row = 0;

	    var TColumns = parseInt(header.getProperty("DecodeParms", "Columns"))+1;

	    var splitBytesToColumns = [new Array(TColumns)];

	    for (var i = 0; i < xrefStream.length; i++) {
	        var row = Math.floor(i / TColumns);

	        var column = i % TColumns;

	        if (xrefObjs.length <= row) {
	            xrefObjs.push({
	                hex: ''
	            });
	        }

	        var currentByte = xrefStream[i];

	        if (column == 0) {
	            xrefObjs[row]['predictor'] = currentByte;
	            continue;
	        }

	        if (splitBytesToColumns.length <= row) {
	            splitBytesToColumns.push(new Array(TColumns));
	        }

	        var additionToBit = 0;

	        if (row != 0) {
	            additionToBit = splitBytesToColumns[row - 1][column];
	        }

	        var unpredicted = Math.abs(currentByte + additionToBit) % 256;

	        splitBytesToColumns[row][column] = unpredicted;

	        if (column <= parseInt(WArray[0])) {
	            xrefObjs[row]['type'] = unpredicted;
	        }
	        else if (column <= parseInt(WArray[0]) + parseInt(WArray[1])) {
	            xrefObjs[row]['hex'] += unpredicted.toString(16);
	        }
	        else 
	        {
	            xrefObjs[row]['flag'] = unpredicted;
	        }
	    }
	}

	function PdfDocument(fileBuffer)
	{
		this.pdfData = fileBuffer;

		this.allObjects = [];

		this.newObjectsToWrite = [];

		this.refreshObjectIndices();

		this.alreadyAddedParents = [];

		this.cachedObjectsById = {};

		this.cachedFontsByName = {};
		
		for (var index =  0; index < this.objectIndices.length; index++)
		{
			var pdfObject = this.objectIndices[index];

			// Get PDF Object or Chunk
			var currentBuffer = this.pdfData.slice(pdfObject.startObj, pdfObject.endObj);

			this.allObjects.push(new PdfObject(currentBuffer, pdfObject.startObj));
		}

		this.totalObjects = this.getHighestObjectId()+10; 
	}

	PdfDocument.prototype = {
		constructor: PdfDocument,

		refreshObjectIndices: function() {

		    this.objectIndices = [];
		    this.objectIndexMap = {};

		    var objStartIndex = 0;
		    var objectEndIndex = 0;

		    while (objStartIndex != -1) {
		        objStartIndex = indexOf(this.pdfData, [ XREF_IDENTIFIER, OBJECT_IDENTIFIER, XREF_IDENTIFIER_LONG ], objectEndIndex);

		        if (objStartIndex != -1) {
		            var lineBeginning = previousIndexOf(this.pdfData, [ getBuffer("\n"), CARRIAGE_RETURN ], objStartIndex) + 1;

		            objectEndIndex = indexOf(this.pdfData, [ OBJECT_END_IDENTIFIER, EOF_IDENTIFIER ], objStartIndex);

		            this.objectIndices.push({
		                startObj: lineBeginning,
		                endObj: objectEndIndex
		            });

		            var objectId = getLine(this.pdfData, lineBeginning).toString();

		           this.objectIndexMap[objectId] = lineBeginning;
		        }
		    }

		    //console.log(this.objectIndices);

		    return this.objectIndices;
		},

		// Not Sure if this is always true, but is for all linearized that I have seen
		getLinearXRefStreamIndex: function()
		{
			return this.allObjects[1].indexOfObject;
		},

		getRootId: function()
		{
			var rootObject = this.getMatchingObjects( { Type: "Catalog" } );
			
			//console.log(rootObject);

			if (rootObject.length == 1)
			{
				return rootObject[0].getReferenceId();
			}
		},

		// Get Property accounting for possible Parent / Kids Heirarchical Format
		getPropertyFromObject: function(obj, propertyKey, innerKey)
		{
			if (nonHeirarchicalProperties.indexOf(propertyKey) != -1)
			{
				return obj.getProperty(propertyKey, innerKey); 
			}
			else if (obj.getProperty("Parent") == null)
			{
				return obj.getProperty(propertyKey, innerKey);
			}
			else
			{
				var parentObj = this.getObjectById(obj.getProperty("Parent", innerKey));

				if (parentObj == null)
				{
					return null;
				}

				var parentData = this.getPropertyFromObject(parentObj, propertyKey, innerKey);

				if (parentData == null)
				{
					return obj.getProperty(propertyKey, innerKey);
				}
				else
				{
					if (obj.getProperty(propertyKey, innerKey) != null)
					{
						return this.getPropertyFromObject(parentObj, propertyKey, innerKey) + '.' + obj.getProperty(propertyKey, innerKey);
					}

					return this.getPropertyFromObject(parentObj, propertyKey, innerKey); 
				}

			}
		},

		// Get Objects that match criteria in objectMap Object from objectList. Null objectList gets from Parent PdfDoc 
		getMatchingObjects: function(objectMatch, objectList)
		{
			var matchingObjects = [];

			if (objectList == null)
			{
				objectList = this.allObjects;
			}
		
			var matchingKeys = Object.keys(objectMatch);

			for (var i = 0; i < objectList.length; i++)
			{
				var obj = objectList[i];

				var matches = true;

			//	console.log("Obj " + obj.Id);
			
				for (var j = 0; j < matchingKeys.length; j++)
				{
					var withParent = this.getPropertyFromObject(obj, matchingKeys[j]);
					
					if (withParent == null)
					{

					//	console.log("key: " +  matchingKeys[j] + " -- withParent: " + withParent + " looking for: " + objectMatch[matchingKeys[j]]);
						matches = false;
						break;
					}
					else if (objectMatch[matchingKeys[j]] != "ALL" && withParent != objectMatch[matchingKeys[j]])
					{
						matches = false;
						break;
					}
				}

				if (matches)
				{
					matchingObjects.push(obj);
				}

				if (obj.streamData != null && obj.streamData.length > 0)
				{
					matchingObjects = matchingObjects.concat(this.getMatchingObjects(objectMatch, obj.streamData));
				}
			}

			return matchingObjects;
		},

		writeNewObject: function(newObject)
		{
			this.pdfData = buffer.Buffer.concat([this.pdfData, new buffer.Buffer("\n"), newObject.toPdfBuffer() ]);
			this.newObjectsToWrite.push(newObject);
		},

		writeNewXrefStream: function()
		{
			var xRefBytePosition = this.pdfData.length + 1;

			this.refreshObjectIndices();

			var xrefObjects = [];
			var xrefIndexForStream = [];

			for (var i = 0; i < this.newObjectsToWrite.length; i++)
			{
				var xrefInfo = this.newObjectsToWrite[i].getXRefIds();

				//console.log(xrefInfo);

				for (var j = 0; j < xrefInfo.length; j++)
				{
					xrefIndexForStream.push(xrefInfo[j].indexId);
					xrefIndexForStream.push(1);

					var xrefObj = { type: xrefInfo[j].type };

					if (xrefInfo[j].type == 1)
					{
						xrefObj["index"] = this.objectIndexMap[xrefInfo[j].Id + " 0 obj"];
					}
					else if (xrefInfo[j].type == 2)
					{
						// Should I be sending the parent Id or the Child stream Id?
						xrefObj["index"] = xrefInfo[j].Id;
					}

					xrefObjects.push(xrefObj);
				}
			}
			var xrefWriteObject = new PdfWriteObject(this.getNextObjectId());

			xrefObjects.push({ type: 1, index: xRefBytePosition });
			xrefIndexForStream.push(xrefWriteObject.Id);
			xrefIndexForStream.push(1);

			var pngUpResult = pngUp(xrefObjects);
			var xrefBody = pngUpResult.retArray;
			xrefWriteObject.addProperty("W", "[1 " + pngUpResult.wLength + " 0]"); // Always using 1 X 0 when building XRef Stream 

			xrefWriteObject.addProperty("Type","XRef");
			xrefWriteObject.addProperty("Filter", "FlateDecode");

			xrefWriteObject.addProperty("Index", "[" + xrefIndexForStream.join(" ") + "]"); 
			xrefWriteObject.addProperty("DecodeParms", { Columns: pngUpResult.wLength+1, Predictor: 12 } ); 
			xrefWriteObject.addProperty("Prev", this.getLinearXRefStreamIndex()); 
			xrefWriteObject.addProperty("Size", this.getNextObjectId()); 
			xrefWriteObject.addProperty("Root", this.getRootId());

			xrefWriteObject.addToStream(xrefBody);

			this.writeNewObject(xrefWriteObject);

			this.pdfData = buffer.Buffer.concat([this.pdfData, new buffer.Buffer("startxref\n"+xRefBytePosition+"\n%%EOF\n") ]);
		
		},

		getHighestObjectId: function()
		{
			var max = 0;

			for (var i = 0; i < this.allObjects.length; i++)
			{
				var parsed = parseInt(this.allObjects[i].Id);

				max = Math.max(max, isNaN(parsed) ?  0 : parsed );

				if (this.allObjects[i].streamData != null && this.allObjects[i].streamData.length > 0)
				{
					for (var j = 0; j <  this.allObjects[i].streamData.length; j++)
					{
						var parsedStream = parseInt(this.allObjects[i].streamData[j].Id);

						max = Math.max(max, isNaN(parsed) ? 0 : parsedStream);
					}
				}
			}

			return max;
		},

		getNextObjectId: function()
		{
			return this.totalObjects++;
		},

		getFontFieldReference: function(fontInfo)
		{

			if (this.cachedFontsByName[fontInfo] == null)
			{
				// Find Font by Name/FontName --> Not sure about multiple fonts with same name.
				var obj = this.getMatchingObjects( { Name : fontInfo } );

				if (obj.length == 0)
				{
					this.cachedFontsByName[fontInfo] = "";
				}
				else
				{
					this.cachedFontsByName[fontInfo] = obj[0].getReferenceId();
				}
			}

			return this.cachedFontsByName[fontInfo];

		},

		fillField: function(fieldObject, fillData, options)
		{
			if (fillData == "true") fillData = "Yes";

			if (fillData == "false") fillData = "No";

			if (fillData == null) fillData = '';

			var writeObjects = [];

			// Create Copy of Stream Onbject for Field with new appearence object and new text in V
			var fieldObjectInStream = new PdfWriteStreamObject(fieldObject);
			var newParent;
			var appearenceObject;

			var fieldType = this.getPropertyFromObject(fieldObject, "FT");

			if (fieldType == "Tx" || fieldType == "Ch")
			{
				// Referenced by Form Field In Stream
				appearenceObject = new PdfWriteObject(this.getNextObjectId());

				// Create Text for Appearance Stream
				var fontInfo = this.getPropertyFromObject(fieldObject, "DA");

				var appearanceParentId = this.getPropertyFromObject(fieldObject, "AP", "N");

				var defaultResources = this.getPropertyFromObject(fieldObject, "DR");

				var parentApp = this.getObjectById(appearanceParentId);
				
				var text;

				var boundingBox = rectangleToBBox(fieldObject.getProperty("Rect"));

				if (parentApp != null && parentApp.textObject != null)
				{
					text = parentApp.textObject.replaceText(fillData);

					copyProperty(appearenceObject, parentApp, "Resources");
				}
				else
				{
	 				text = getDefaultFieldText(fontInfo, boundingBox, fillData);

	 				if (defaultResources != null)
	 				{
	 					appearenceObject.addProperty("Resources", defaultResources);
	 				}
	 				else 
	 				{
	 					if (fontInfo == null)
	 					{
	 						throw 'No Font Settings Found in PDF'; 
	 					}

		 				var fontName = fontInfo.slice(1, fontInfo.indexOf(" "));

		 				var fontReference = this.getFontFieldReference(fontName);

		 				if (fontReference != "")
		 				{
			 				var fontObject = {};

			 				fontObject[fontName] = fontReference;
			 				appearenceObject.addProperty("Resources", { "Font": new PdfDictEntry("Font", fontObject) });
		 				}
	 				}
				}

				appearenceObject.addToStream(new PdfWriteStreamBlob(text));

				// Add Relevant properties to Appearence Object
				appearenceObject.addProperty("BBox", boundingBox);
				appearenceObject.addProperty("Type", "XObject");
				appearenceObject.addProperty("Subtype", "Form");
				appearenceObject.addProperty("FormType", "1");

				writeObjects.push(appearenceObject);

				fieldObjectInStream.addProperty("AP", { "N": appearenceObject.Id + " 0 R" });				
			}

			//console.log(JSON.stringify(appearenceObject, null, 2));
			if (fieldObject.getProperty("Parent") != null)
			{
				var parentObj = this.getObjectById(fieldObject.getProperty("Parent"));

				newParent = new PdfWriteStreamObject(parentObj);

				if (parentObj instanceof StreamObject && this.alreadyAddedParents.indexOf(parentObj.Id) == -1)
				{
					// Create Copy of Stream Onbject for Field with new appearence object and new text in V
					var newParentformXObject = new PdfWriteObject(this.getNextObjectId());
					newParentformXObject.addProperty("Type","ObjStm");
					newParentformXObject.addProperty("Filter", "FlateDecode");
					newParentformXObject.addProperty("N", "1");

					newParentformXObject.addToStream(newParent);

					writeObjects.push(newParentformXObject);

					this.alreadyAddedParents.push(parentObj.Id);
				}
			}

			var fieldType = this.getPropertyFromObject(fieldObject, "FT");


			if (fieldType == "Ch")
			{
				// Might not be the best way, but this I is optional and easier this than parse for now
				fieldObjectInStream.removeProperty("I");				
			}

			// Add to Parent or Current Object depending on heriarachy. 
			// If the same field appears in 2 places it will have the V on the parent.
			var addValueToObject;

			if (fieldObject.getProperty("T") == null && newParent != null)
			{
				if (fieldType == "Btn")
				{
					newParent.addProperty("V", fillData, "/");

					if (newParent.getProperty("AS") != null)
					{
						newParent.addProperty("AS", fillData, "/");
					}
					else if (fieldObjectInStream.getProperty("AS") != null && fieldObjectInStream.getProperty("AP", "D", fillData) != null)
					{ 
						fieldObjectInStream.addProperty("AS", fillData, "/");
					}
				}
				else
				{
					newParent.addProperty("V", escapeTextForTextField(fillData));
				}
			}
			else if (fieldObject.getProperty("T") != null)
			{
				if (fieldType == "Btn")
				{
					fieldObjectInStream.addProperty("V", fillData, "/");

					if (fieldObjectInStream.getProperty("AS") != null)
					{
						fieldObjectInStream.addProperty("AS", fillData, "/");
					}
				}
				else
				{
					fieldObjectInStream.addProperty("V", escapeTextForTextField(fillData));
				}
			}

			var formXObject = new PdfWriteObject(this.getNextObjectId());
			formXObject.addProperty("Type","ObjStm");
			formXObject.addProperty("Filter", "FlateDecode");
			formXObject.addProperty("N", "1");

			formXObject.addToStream(fieldObjectInStream);
		
			writeObjects.push(formXObject);

			for (var i = 0; i < writeObjects.length; i++)
			{
				this.writeNewObject(writeObjects[i]);
			}
		},

		getXRefParent: function()
		{
			var rootObject = this.getMatchingObjects( { Type: "Catalog" } );

			if (rootObject.length == 1)
			{
				return rootObject[0].getReferenceId();
			}
		},

		getObjectById: function(id)
		{
			if (typeof id == "string")
			{
				id = id.replace("R", "obj");
			}

			if (this.cachedObjectsById[id] != null) 
			{
				return this.cachedObjectsById[id];
			}
			for (var i = 0; i < this.allObjects.length; i++)
			{
				if (this.allObjects[i].Id == id)
				{
					this.cachedObjectsById[id] = this.allObjects[i];
					return this.allObjects[i];
				}

				for (var j = 0; j < this.allObjects[i].streamData.length; j++)
				{
					if (this.allObjects[i].streamData[j].Id == id || this.allObjects[i].streamData[j].Id + " 0 obj" == id)
					{
						this.cachedObjectsById[id] = this.allObjects[i].streamData[j];
						return this.allObjects[i].streamData[j];
					}
				}
			}

			return null;
		}
	}

	var startTime = Date.now();

	function elapsed(message)
	{
		console.log(message + ": " + (Date.now() - startTime)); 
	}

	vPdfWriter.fillPdfForm = function(pdfData, formJson, options)
	{
		if (getPDFVersion(pdfData) < SUPPORTED_PDF_VERSION) return null;
		
		var pdfDoc = new PdfDocument(pdfData);

		if (options == null) options = {};

		if (options.debug) elapsed("Loaded Pdf");
	
		var allFormFields = pdfDoc.getMatchingObjects( { Type: "Annot" } );

		if (options.debug) elapsed("Found Form Fields");

		for (var i = 0; i < allFormFields.length; i++)
		{
			var formKey = pdfDoc.getPropertyFromObject(allFormFields[i], "T");

			var fieldData = formJson[formKey];

			if (fieldData != null)
			{
				fieldData = this.getAsDate(String(fieldData), options)
		
				pdfDoc.fillField(allFormFields[i], fieldData, options);
				if (options.debug) elapsed("Filled Field " + i);
			}
		}

		if (options.debug) elapsed("Writing Xref");

		pdfDoc.writeNewXrefStream();

		if (options != null && options.debug)
		{
			elapsed("Filled Form In");
		}

		return pdfDoc.pdfData;
	}

	vPdfWriter.getFormFields = function(pdfData)
	{
		var fields = this.getFormFieldsWithType(pdfData);

		if (fields != null)
		{
			fields = Object.keys(fields);
		}

		return fields;
	}

	vPdfWriter.getFormFieldsWithType = function(pdfData)
	{
		if (getPDFVersion(pdfData) < SUPPORTED_PDF_VERSION) return null;

		var pdfDoc = new PdfDocument(pdfData);

		var formFieldsObject = {};

		var formFields = pdfDoc.getMatchingObjects( { Type: "Annot", Subtype: "Widget", FT: "ALL" } ); 

		var fieldTypeLabels = { Tx: "Text", Ch: "Dropdown", Btn : "Checkbox / Radio Button" };

		formFields.forEach( function(field) {

			if (pdfDoc.getPropertyFromObject(field, "FT") != "Sig")
			{
				formFieldsObject[pdfDoc.getPropertyFromObject(field, "T")] = fieldTypeLabels[pdfDoc.getPropertyFromObject(field, "FT")];
			}
		});

		if (Object.keys(formFieldsObject).length == 0) return null;

	
		return formFieldsObject;
	}

	vPdfWriter.getMatchingFields = function(pdfData, matchingCriteria)
	{
		if (getPDFVersion(pdfData) < SUPPORTED_PDF_VERSION) return null;

		var pdfDoc = new PdfDocument(pdfData);

		var matchingFields = pdfDoc.getMatchingObjects( matchingCriteria ); 
	
		return matchingFields;
	}

	vPdfWriter.expand = function(pdfData)
	{
		if (getPDFVersion(pdfData) < SUPPORTED_PDF_VERSION) return null;

		var pdf = new PdfDocument(pdfData);

		var ret = '';

		for (var i = 0; i < pdf.allObjects.length; i++)
		{
			ret += pdf.allObjects[i].toStringPdf();
		}

		return ret;
	}

	vPdfWriter.getObject = function(pdfData, objId)
	{
		if (getPDFVersion(pdfData) < SUPPORTED_PDF_VERSION) return null;

		var pdf = new PdfDocument(pdfData);
		return pdf.getObjectById(objId);
	}
	
	return vPdfWriter;
}());

try {
if (module != undefined)
{
	module.exports = 
	{
		vlocityPdfWriter: vlocityPdfWriter
	};
}
}
catch(err)
{
	//console.log('Browser');
}
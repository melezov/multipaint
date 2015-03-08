/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var RGB = (function () {
        function RGB(r, g, b) {
            if (!(r >= 0 && r <= 0xff))
                throw "Invalid RGB value for r: " + r;
            if (!(g >= 0 && g <= 0xff))
                throw "Invalid RGB value for g: " + g;
            if (!(b >= 0 && b <= 0xff))
                throw "Invalid RGB value for b: " + b;
            this._r = r;
            this._g = g;
            this._b = b;
        }
        Object.defineProperty(RGB.prototype, "r", {
            get: function () {
                return this._r;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(RGB.prototype, "g", {
            get: function () {
                return this._g;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(RGB.prototype, "b", {
            get: function () {
                return this._b;
            },
            enumerable: true,
            configurable: true
        });
        // conversion adapted from http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
        RGB.prototype.toHSL = function () {
            var r = this._r / 0xff;
            var g = this._g / 0xff;
            var b = this._b / 0xff;
            var max = Math.max(r, g, b), min = Math.min(r, g, b);
            var h, s, l = (max + min) / 2;
            if (max == min) {
                h = s = 0; // achromatic
            }
            else {
                var d = max - min;
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
                switch (max) {
                    case r:
                        h = (g - b) / d + (g < b ? 6 : 0);
                        break;
                    case g:
                        h = (b - r) / d + 2;
                        break;
                    case b:
                        h = (r - g) / d + 4;
                        break;
                }
                h /= 6;
            }
            return new drawing.HSL(h, s, l);
        };
        RGB.fromHex = function (rgbHex) {
            if (/^#[0-9A-Fa-f]{6}$/.test(rgbHex)) {
                var r = parseInt(rgbHex.substr(1, 2), 16);
                var g = parseInt(rgbHex.substr(3, 2), 16);
                var b = parseInt(rgbHex.substr(5, 2), 16);
                return new RGB(r, g, b);
            }
            if (/^#[0-9A-Fa-f]{3}$/.test(rgbHex)) {
                var r = parseInt(rgbHex.charAt(1), 16) * 0x11;
                var g = parseInt(rgbHex.charAt(2), 16) * 0x11;
                var b = parseInt(rgbHex.charAt(3), 16) * 0x11;
                return new RGB(r, g, b);
            }
            throw "Color \"" + rgbHex + "\" was not in \"#rrggbb\" nor \"#rgb\" format!";
        };
        RGB.random = function () {
            return new RGB(Math.floor(Math.random() * 0x100), Math.floor(Math.random() * 0x100), Math.floor(Math.random() * 0x100));
        };
        RGB.prototype.toHex = function () {
            function byte2Hex(val) {
                val = Math.floor(val);
                var hex = Number(val).toString(16);
                return val < 16 ? "0" + hex : hex;
            }
            return "#" + byte2Hex(this._r) + byte2Hex(this._g) + byte2Hex(this._b);
        };
        return RGB;
    })();
    drawing.RGB = RGB;
})(drawing || (drawing = {}));

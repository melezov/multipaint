/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var HSL = (function () {
        function HSL(h, s, l) {
            if (!(h >= 0))
                throw "Hue value " + h + " was out of bounds [0,Inf>";
            if (!(s >= HSL.SaturationMin && s <= HSL.SaturationMax))
                throw "Saturation value " + s + " was out of bounds [" + HSL.SaturationMin + "," + HSL.SaturationMax + "]";
            if (!(l >= HSL.LigthnessMin && l <= HSL.LightnessMax))
                throw "Ligthness value " + l + " was out of bounds [" + HSL.LigthnessMin + "," + HSL.LightnessMax + "]";
            this._h = h;
            this._s = s;
            this._l = l;
        }
        Object.defineProperty(HSL.prototype, "h", {
            get: function () {
                return this._h;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(HSL.prototype, "s", {
            get: function () {
                return this._s;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(HSL.prototype, "l", {
            get: function () {
                return this._l;
            },
            enumerable: true,
            configurable: true
        });
        HSL.hue2rgb = function (p, q, t) {
            if (t < 0)
                t += 1;
            if (t > 1)
                t -= 1;
            if (t < 1 / 6)
                return p + (q - p) * 6 * t;
            if (t < 1 / 2)
                return q;
            if (t < 2 / 3)
                return p + (q - p) * (2 / 3 - t) * 6;
            return p;
        };
        // conversion adapted from http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
        HSL.prototype.toRGB = function () {
            var h = this._h;
            var s = this._s;
            var l = this._l;
            var r, g, b;
            if (s === 0) {
                r = g = b = l; // achromatic, RGB values set to L
            }
            else {
                var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
                var p = 2 * l - q;
                r = HSL.hue2rgb(p, q, h + 1 / 3);
                g = HSL.hue2rgb(p, q, h);
                b = HSL.hue2rgb(p, q, h - 1 / 3);
            }
            return new drawing.RGB(r * 0xff, g * 0xff, b * 0xff);
        };
        HSL.SaturationMax = 1;
        HSL.SaturationMin = 0;
        HSL.LightnessMax = 1;
        HSL.LigthnessMin = 0;
        return HSL;
    })();
    drawing.HSL = HSL;
})(drawing || (drawing = {}));

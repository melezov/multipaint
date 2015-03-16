/// <reference path='../all.ts' /> 

module drawing {
    'use strict';

    export class HSL {
        private _h: number;
        private _s: number;
        private _l: number;

        get h() { return this._h; }
        get s() { return this._s; }
        get l() { return this._l; }

        static SaturationMax = 1
        static SaturationMin = 0

        static LightnessMax = 1
        static LigthnessMin = 0

        constructor(h: number, s: number, l: number) {
            if (!(h >= 0)) throw "Hue value " + h + " was out of bounds [0,Inf>";
            if (!(s >= HSL.SaturationMin && s <= HSL.SaturationMax)) throw "Saturation value " + s + " was out of bounds [" + HSL.SaturationMin + "," + HSL.SaturationMax + "]";
            if (!(l >= HSL.LigthnessMin && l <= HSL.LightnessMax)) throw "Ligthness value " + l + " was out of bounds [" + HSL.LigthnessMin + "," + HSL.LightnessMax + "]";
            this._h = h;
            this._s = s;
            this._l = l;
        }

        private static hue2rgb(p: number, q: number, t: number): number {
            if (t < 0) t += 1;
            if (t > 1) t -= 1;
            if (t < 1 / 6) return p + (q - p) * 6 * t;
            if (t < 1 / 2) return q;
            if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
            return p;
        }

        // conversion adapted from http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
        toRGB(): RGB {
            var h = this._h;
            var s = this._s;
            var l = this._l;

            var r: number, g: number, b: number;

            if (s === 0) {
                r = g = b = l; // achromatic, RGB values set to L
            } else {
                var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
                var p = 2 * l - q;

                r = HSL.hue2rgb(p, q, h + 1 / 3);
                g = HSL.hue2rgb(p, q, h);
                b = HSL.hue2rgb(p, q, h - 1 / 3);
            }

            return new RGB(r * 0xff, g * 0xff, b * 0xff);
        }
    }
}
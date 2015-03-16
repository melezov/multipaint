/// <reference path='../all.ts' /> 

module drawing {
    'use strict';

    export class RGB {
        private _r: number;
        private _g: number;
        private _b: number;

        get r() { return this._r; }
        get g() { return this._g; }
        get b() { return this._b; }

        constructor(r: number, g: number, b: number) {
            if (!(r >= 0 && r <= 0xff)) throw "Invalid RGB value for r: " + r;
            if (!(g >= 0 && g <= 0xff)) throw "Invalid RGB value for g: " + g;
            if (!(b >= 0 && b <= 0xff)) throw "Invalid RGB value for b: " + b;
            this._r = r;
            this._g = g;
            this._b = b;
        }

        // conversion adapted from http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
        toHSL(): HSL {
            var r = this._r / 0xff;
            var g = this._g / 0xff;
            var b = this._b / 0xff;

            var max = Math.max(r, g, b), min = Math.min(r, g, b);
            var h: number, s: number, l = (max + min) / 2;

            if (max == min) {
                h = s = 0; // achromatic
            } else {
                var d = max - min;
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
                switch (max) {
                    case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                    case g: h = (b - r) / d + 2; break;
                    case b: h = (r - g) / d + 4; break;
                }
                h /= 6;
            }

            return new HSL(h, s, l);
        }

        static fromHex(rgbHex: string): RGB {
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
        }

        static random(): RGB {
            return new RGB(
                Math.floor(Math.random() * 0x100),
                Math.floor(Math.random() * 0x100),
                Math.floor(Math.random() * 0x100));
        }

        toHex(): string {
            function byte2Hex(val: number): string {
                val = Math.floor(val);
                var hex = Number(val).toString(16);
                return val < 16 ? "0" + hex : hex;
            }
            return "#" + byte2Hex(this._r) + byte2Hex(this._g) + byte2Hex(this._b);
        }
    }
}
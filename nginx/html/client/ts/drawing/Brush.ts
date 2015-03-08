/// <reference path='../all.ts' /> 

module drawing {
    'use strict';

    export class Brush {
        private _rgb: RGB;
        private _hsl: HSL;
        private _color: string;
        private _thickness: number;

        get rgb() { return this._rgb; }
        get hsl() { return this._hsl; }
        get color() { return this._color; }
        get thickness() { return this._thickness; }

        set rgb(rgb: RGB) {
            var newColor = rgb.toHex();
            if (this._color !== newColor) {
                this._rgb = rgb;
                this._hsl = rgb.toHSL();
                this._color = newColor;
                this._notifyChangeListeners();
            }
        }

        set hsl(hsl: HSL) {
            var newRGB = hsl.toRGB();
            var newColor = newRGB.toHex();
            if (this._color !== newColor) {
                this._rgb = hsl.toRGB();
                this._hsl = hsl;
                this._color = newColor;
                this._notifyChangeListeners();
            }
        }

        set color(newColor: string) {
            this.rgb = RGB.fromHex(newColor);
        }

        set thickness(newThickness: number) {
            newThickness = Math.floor(newThickness);
            if (!(newThickness >= Brush.ThicknessMin && newThickness <= Brush.ThicknessMax)) {
                throw "Thickness " + newThickness + " is out of range [" + Brush.ThicknessMin + "," + Brush.ThicknessMax + "]";
            }

            if (this._thickness !== newThickness) {
                this._thickness = newThickness;
                this._notifyChangeListeners();
            }
        }

        updateWith(brush: Brush) {
            if (this._color != brush._color || this._thickness != brush._thickness) {
                this._rgb = brush._rgb;
                this._hsl = brush._hsl;
                this._color = brush._color;
                this._thickness = brush._thickness;
                this._notifyChangeListeners();
            }
        }

        static ThicknessMin = 10;
        static ThicknessMax = 250;

        static ColorDefault = "#000000";
        static ThicknessDefault = 50;

        constructor() {
            this.color = Brush.ColorDefault;
            this.thickness = Brush.ThicknessDefault;
        }

        private _changeListeners: { (brush: Brush): void; }[] = [];

        addChangeListener(listener: { (brush: Brush): void; }) {
            this._changeListeners.push(listener);
        }

        private _notifyChangeListeners() {
            this._changeListeners.forEach(listener => {
                listener(this);
            });
        }
    }
}
/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var Brush = (function () {
        function Brush() {
            this._changeListeners = [];
            this.color = Brush.ColorDefault;
            this.thickness = Brush.ThicknessDefault;
        }
        Object.defineProperty(Brush.prototype, "rgb", {
            get: function () {
                return this._rgb;
            },
            set: function (rgb) {
                var newColor = rgb.toHex();
                if (this._color !== newColor) {
                    this._rgb = rgb;
                    this._hsl = rgb.toHSL();
                    this._color = newColor;
                    this._notifyChangeListeners();
                }
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Brush.prototype, "hsl", {
            get: function () {
                return this._hsl;
            },
            set: function (hsl) {
                var newRGB = hsl.toRGB();
                var newColor = newRGB.toHex();
                if (this._color !== newColor) {
                    this._rgb = hsl.toRGB();
                    this._hsl = hsl;
                    this._color = newColor;
                    this._notifyChangeListeners();
                }
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Brush.prototype, "color", {
            get: function () {
                return this._color;
            },
            set: function (newColor) {
                this.rgb = drawing.RGB.fromHex(newColor);
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Brush.prototype, "thickness", {
            get: function () {
                return this._thickness;
            },
            set: function (newThickness) {
                newThickness = Math.floor(newThickness);
                if (!(newThickness >= Brush.ThicknessMin && newThickness <= Brush.ThicknessMax)) {
                    throw "Thickness " + newThickness + " is out of range [" + Brush.ThicknessMin + "," + Brush.ThicknessMax + "]";
                }
                if (this._thickness !== newThickness) {
                    this._thickness = newThickness;
                    this._notifyChangeListeners();
                }
            },
            enumerable: true,
            configurable: true
        });
        Brush.prototype.updateWith = function (brush) {
            if (this._color != brush._color || this._thickness != brush._thickness) {
                this._rgb = brush._rgb;
                this._hsl = brush._hsl;
                this._color = brush._color;
                this._thickness = brush._thickness;
                this._notifyChangeListeners();
            }
        };
        Brush.prototype.addChangeListener = function (listener) {
            this._changeListeners.push(listener);
        };
        Brush.prototype._notifyChangeListeners = function () {
            var _this = this;
            this._changeListeners.forEach(function (listener) {
                listener(_this);
            });
        };
        Brush.ThicknessMin = 10;
        Brush.ThicknessMax = 250;
        Brush.ColorDefault = "#000000";
        Brush.ThicknessDefault = 50;
        return Brush;
    })();
    drawing.Brush = Brush;
})(drawing || (drawing = {}));

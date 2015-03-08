/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var BrushControl = (function () {
        function BrushControl(brush) {
            this._brush = brush;
        }
        Object.defineProperty(BrushControl.prototype, "brush", {
            get: function () {
                return this._brush;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(BrushControl.prototype, "color", {
            set: function (newColor) {
                this._brush.color = newColor;
            },
            enumerable: true,
            configurable: true
        });
        BrushControl.prototype.randomize = function () {
            var randomBrush = new drawing.Brush();
            randomBrush.rgb = drawing.RGB.random();
            randomBrush.thickness = BrushControl.randomThickness();
            this._brush.updateWith(randomBrush);
        };
        BrushControl.randomThickness = function () {
            var min = drawing.Brush.ThicknessMin;
            var max = drawing.Brush.ThicknessMax;
            var step = BrushControl.ThicknessStep;
            var range = max - min;
            var steps = Math.floor(range / step) + 1;
            return min + Math.floor(Math.random() * steps) * step;
        };
        BrushControl.prototype.thicken = function () {
            this._brush.thickness = Math.min(this._brush.thickness + BrushControl.ThicknessStep, drawing.Brush.ThicknessMax);
        };
        BrushControl.prototype.thin = function () {
            this._brush.thickness = Math.max(this._brush.thickness - BrushControl.ThicknessStep, drawing.Brush.ThicknessMin);
        };
        BrushControl.darken = function (hsl) {
            var newL = Math.max(hsl.l - BrushControl.LightnessStep, drawing.HSL.LigthnessMin);
            return new drawing.HSL(hsl.h, hsl.s, newL);
        };
        BrushControl.prototype.darken = function () {
            this._brush.hsl = BrushControl.darken(this._brush.hsl);
        };
        BrushControl.brighten = function (hsl) {
            var newL = Math.min(hsl.l + BrushControl.LightnessStep, drawing.HSL.LightnessMax);
            return new drawing.HSL(hsl.h, hsl.s, newL);
        };
        BrushControl.prototype.brighten = function () {
            this._brush.hsl = BrushControl.brighten(this._brush.hsl);
        };
        BrushControl.prototype.addChangeListener = function (listener) {
            this._brush.addChangeListener(listener);
        };
        BrushControl.ThicknessStep = 10;
        BrushControl.LightnessStep = 0.1;
        return BrushControl;
    })();
    drawing.BrushControl = BrushControl;
})(drawing || (drawing = {}));

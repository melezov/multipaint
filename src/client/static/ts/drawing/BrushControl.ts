/// <reference path='../all.ts' /> 

module drawing {
    'use strict';

    export class BrushControl {
        private _brush: Brush;

        get brush() { return this._brush; }

        constructor(brush: Brush) {
            this._brush = brush;
        }

        set color(newColor: string) {
            this._brush.color = newColor;
        }

        randomize() {
            var randomBrush = new Brush();
            randomBrush.rgb = RGB.random();
            randomBrush.thickness = BrushControl.randomThickness();
            this._brush.updateWith(randomBrush);
        }

        static ThicknessStep = 10;

        static randomThickness() {
            var min = Brush.ThicknessMin;
            var max = Brush.ThicknessMax;
            var step = BrushControl.ThicknessStep;
            var range = max - min;
            var steps = Math.floor(range / step) + 1;
            return min + Math.floor(Math.random() * steps) * step;
        }

        thicken() {
            this._brush.thickness = Math.min(this._brush.thickness + BrushControl.ThicknessStep, Brush.ThicknessMax);
        }

        thin() {
            this._brush.thickness = Math.max(this._brush.thickness - BrushControl.ThicknessStep, Brush.ThicknessMin);
        }

        static LightnessStep = 0.1;

        static darken(hsl: HSL) {
            var newL = Math.max(hsl.l - BrushControl.LightnessStep, HSL.LigthnessMin);
            return new HSL(hsl.h, hsl.s, newL);
        }

        darken() {
            this._brush.hsl = BrushControl.darken(this._brush.hsl);
        }

        static brighten(hsl: HSL) {
            var newL = Math.min(hsl.l + BrushControl.LightnessStep, HSL.LightnessMax);
            return new HSL(hsl.h, hsl.s, newL);
        }

        brighten() {
            this._brush.hsl = BrushControl.brighten(this._brush.hsl);
        }

        addChangeListener(listener: { (brush: Brush): void; }) {
            this._brush.addChangeListener(listener);
        }
    }
}
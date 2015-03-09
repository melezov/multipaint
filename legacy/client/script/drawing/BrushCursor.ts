/// <reference path='../all.ts' /> 

module drawing {
    'use strict';

    export class Point {
        private _x: number;
        private _y: number;

        get x() { return this._x; }
        get y() { return this._y; }

        constructor(x: number, y: number) {
            this._x = x;
            this._y = y;
        }
    }

    export class BrushCursor {
        private _brushDown: boolean;

        constructor() {
            this._brushDown = false;
        }

        documentBrushUp() {
            this._brushDown = false;
        }

        documentBrushDown() {
            this._brushDown = true;
        }

        brushHover(position: Point) {
            this._updateTracking(model.BrushState.Hover, position);
        }

        brushPress(position: Point) {
            this._updateTracking(model.BrushState.Press, position);
        }

        brushDraw(position: Point) {
            this._updateTracking(model.BrushState.Draw, position);
        }

        brushLift(position: Point) {
            this._updateTracking(model.BrushState.Lift, position);
        }

        brushEnter(position: Point) {
            if (this._brushDown) this.brushPress(position);
        }

        brushExit(position: Point) {
            if (this._brushDown) this.brushLift(position);
        }

        brushMove(position: Point) {
            if (this._brushDown) {
                this.brushDraw(position);
            }
            else {
                this.brushHover(position);
            }
        }

        brushUp(position: Point) {
            this._brushDown = false;
            this.brushLift(position);
        }

        brushDown(position: Point) {
            this._brushDown = true;
            this.brushPress(position);
        }

        private _changeListeners: { (brushTracking: model.BrushTracking): void; }[] = [];

        addChangeListener(listener: { (brushTracking: model.BrushTracking): void; }) {
            this._changeListeners.push(listener);
        }

        private _updateTracking(state: string, position: Point) {
            var tracking: model.BrushTracking = {
                State: state,
                X: position.x,
                Y: position.y
            }
            this._notifyChangeListeners(tracking);
        }

        private _notifyChangeListeners(brushTracking: model.BrushTracking) {
            this._changeListeners.forEach(listener => {
                listener(brushTracking);
            });
        }
    }
}
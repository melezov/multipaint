/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var Point = (function () {
        function Point(x, y) {
            this._x = x;
            this._y = y;
        }
        Object.defineProperty(Point.prototype, "x", {
            get: function () {
                return this._x;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Point.prototype, "y", {
            get: function () {
                return this._y;
            },
            enumerable: true,
            configurable: true
        });
        return Point;
    })();
    drawing.Point = Point;
    var BrushCursor = (function () {
        function BrushCursor() {
            this._changeListeners = [];
            this._brushDown = false;
        }
        BrushCursor.prototype.documentBrushUp = function () {
            this._brushDown = false;
        };
        BrushCursor.prototype.documentBrushDown = function () {
            this._brushDown = true;
        };
        BrushCursor.prototype.brushHover = function (position) {
            this._updateTracking(model.BrushState.Hover, position);
        };
        BrushCursor.prototype.brushPress = function (position) {
            this._updateTracking(model.BrushState.Press, position);
        };
        BrushCursor.prototype.brushDraw = function (position) {
            this._updateTracking(model.BrushState.Draw, position);
        };
        BrushCursor.prototype.brushLift = function (position) {
            this._updateTracking(model.BrushState.Lift, position);
        };
        BrushCursor.prototype.brushEnter = function (position) {
            if (this._brushDown)
                this.brushPress(position);
        };
        BrushCursor.prototype.brushExit = function (position) {
            if (this._brushDown)
                this.brushLift(position);
        };
        BrushCursor.prototype.brushMove = function (position) {
            if (this._brushDown) {
                this.brushDraw(position);
            }
            else {
                this.brushHover(position);
            }
        };
        BrushCursor.prototype.brushUp = function (position) {
            this._brushDown = false;
            this.brushLift(position);
        };
        BrushCursor.prototype.brushDown = function (position) {
            this._brushDown = true;
            this.brushPress(position);
        };
        BrushCursor.prototype.addChangeListener = function (listener) {
            this._changeListeners.push(listener);
        };
        BrushCursor.prototype._updateTracking = function (state, position) {
            var tracking = {
                State: state,
                X: position.x,
                Y: position.y
            };
            this._notifyChangeListeners(tracking);
        };
        BrushCursor.prototype._notifyChangeListeners = function (brushTracking) {
            this._changeListeners.forEach(function (listener) {
                listener(brushTracking);
            });
        };
        return BrushCursor;
    })();
    drawing.BrushCursor = BrushCursor;
})(drawing || (drawing = {}));

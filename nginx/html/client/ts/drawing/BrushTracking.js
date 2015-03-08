/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var BrushTracking = (function () {
        function BrushTracking() {
            this._changeListeners = [];
            this._brushDown = false;
        }
        BrushTracking.prototype.documentBrushUp = function () {
            this._brushDown = false;
        };
        BrushTracking.prototype.documentBrushDown = function () {
            this._brushDown = true;
        };
        BrushTracking.prototype.brushHover = function (position) {
            this._updateTracking(BrushState.Hover, position);
        };
        BrushTracking.prototype.brushPress = function (position) {
            this._updateTracking(BrushState.Press, position);
        };
        BrushTracking.prototype.brushDraw = function (position) {
            this._updateTracking(BrushState.Draw, position);
        };
        BrushTracking.prototype.brushLift = function (position) {
            this._updateTracking(BrushState.Lift, position);
        };
        BrushTracking.prototype.brushEnter = function (position) {
            if (this._brushDown)
                this.brushPress(position);
        };
        BrushTracking.prototype.brushExit = function (position) {
            if (this._brushDown)
                this.brushLift(position);
        };
        BrushTracking.prototype.brushMove = function (position) {
            if (this._brushDown) {
                this.brushDraw(position);
            }
            else {
                this.brushHover(position);
            }
        };
        BrushTracking.prototype.brushUp = function (position) {
            this._brushDown = false;
            this.brushLift(position);
        };
        BrushTracking.prototype.brushDown = function (position) {
            this._brushDown = true;
            this.brushPress(position);
        };
        BrushTracking.prototype.addChangeListener = function (listener) {
            this._changeListeners.push(listener);
        };
        BrushTracking.prototype._updateTracking = function (state, position) {
            var action = new BrushAction(state, position);
            this._notifyChangeListeners(action);
        };
        BrushTracking.prototype._notifyChangeListeners = function (brushAction) {
            this._changeListeners.forEach(function (listener) {
                listener(brushAction);
            });
        };
        return BrushTracking;
    })();
    drawing.BrushTracking = BrushTracking;
})(drawing || (drawing = {}));

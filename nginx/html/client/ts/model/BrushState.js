/// <reference path='../all.ts' /> 
var model;
(function (model) {
    'use strict';
    var BrushState = (function () {
        function BrushState() {
        }
        BrushState.Hover = 'Hover';
        BrushState.Press = 'Press';
        BrushState.Draw = 'Draw';
        BrushState.Lift = 'Lift';
        return BrushState;
    })();
    model.BrushState = BrushState;
    ;
})(model || (model = {}));

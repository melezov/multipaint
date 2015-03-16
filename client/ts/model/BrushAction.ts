/// <reference path='../all.ts' /> 

module model {
    'use strict'; 
    
    export interface BrushAction {
        BrushID: number;
        Index: number;
        Tracking: BrushTracking;
    }
}

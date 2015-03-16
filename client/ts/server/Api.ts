/// <reference path='../all.ts' /> 

module server {
    'use strict';

    export class Api {
        private _send(type: string, url: string, data: any, callback: (result: any) => void) {
            $.ajax({
                type: type,
                url: url,
                data: JSON.stringify(data),
                success: callback,
                dataType: 'json'
            });
        }
            
        protected _post(url: string, data: any, callback: (result: any) => void) {
            this._send('POST', url, data, callback);
        }

        /* Sends new brush parameters, returns the newly created brushID */
        changeBrush(data: model.ChangeBrush, callback: (brushID: number) => void) {
            this._post(
                "/api/Domain.svc/submit/MultiPaint.ChangeBrush?result=instance",
                data,
                response => callback((<model.ChangeBrush> response).BrushID));
        }

        /* Sends a brush action domain event, void return (async event) */
        brushAction(data: model.BrushAction, callback: () => void) {
            this._post(
                "/api/Domain.svc/submit/MultiPaint.BrushAction",
                data,
                response => callback());
        }
    }
}
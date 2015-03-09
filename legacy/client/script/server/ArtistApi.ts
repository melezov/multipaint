/// <reference path='../all.ts' /> 

module server {
    'use strict';

    export class ArtistApi extends Api {
        constructor(token: string) {
            super();
            this._addPreProcessor(request => {
                request.headers['Authorization'] = 'Basic ' + token;
            });
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

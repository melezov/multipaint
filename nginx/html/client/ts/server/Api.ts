/// <reference path='../all.ts' /> 

module server {
    'use strict';

    export class Api {
        private _preProcessors: ((settings: JQueryAjaxSettings) => void)[] = [];

        private _preProcess(request: JQueryAjaxSettings) {
            for (var i = 0; i < this._preProcessors.length; i++) {
                this._preProcessors[i](request);
            }
        }

        protected _addPreProcessor(preProcessor: (settings: JQueryAjaxSettings) => void) {
            this._preProcessors.push(preProcessor);
        }

        private _send(type: string, url: string, data: any, callback: (result: any) => void) {
            var request: JQueryAjaxSettings = {
                type: type,
                url: url,
                data: JSON.stringify(data),
                headers: {},
                success: callback,
                dataType: 'json'
            };

            this._preProcess(request);
            $.ajax(request);
        }

        protected _post(url: string, data: any, callback: (result: any) => void) {
            this._send('POST', url, data, callback);
        }
    } 
}
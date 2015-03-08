/// <reference path='../all.ts' /> 
var server;
(function (server) {
    'use strict';
    var Api = (function () {
        function Api() {
            this._preProcessors = [];
        }
        Api.prototype._preProcess = function (request) {
            for (var i = 0; i < this._preProcessors.length; i++) {
                this._preProcessors[i](request);
            }
        };
        Api.prototype._addPreProcessor = function (preProcessor) {
            this._preProcessors.push(preProcessor);
        };
        Api.prototype._send = function (type, url, data, callback) {
            var request = {
                type: type,
                url: url,
                data: JSON.stringify(data),
                headers: {},
                success: callback,
                dataType: 'json'
            };
            this._preProcess(request);
            $.ajax(request);
        };
        Api.prototype._post = function (url, data, callback) {
            this._send('POST', url, data, callback);
        };
        return Api;
    })();
    server.Api = Api;
})(server || (server = {}));

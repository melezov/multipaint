/// <reference path='../all.ts' /> 
var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var server;
(function (server) {
    'use strict';
    var ArtistApi = (function (_super) {
        __extends(ArtistApi, _super);
        function ArtistApi(token) {
            _super.call(this);
            this._addPreProcessor(function (request) {
                request.headers['Authorization'] = 'Basic ' + token;
            });
        }
        /* Sends new brush parameters, returns the newly created brushID */
        ArtistApi.prototype.changeBrush = function (data, callback) {
            this._post("/api/Domain.svc/submit/MultiPaint.ChangeBrush?result=instance", data, function (response) { return callback(response.BrushID); });
        };
        /* Sends a brush action domain event, void return (async event) */
        ArtistApi.prototype.brushAction = function (data, callback) {
            this._post("/api/Domain.svc/submit/MultiPaint.BrushAction", data, function (response) { return callback(); });
        };
        return ArtistApi;
    })(server.Api);
    server.ArtistApi = ArtistApi;
})(server || (server = {}));

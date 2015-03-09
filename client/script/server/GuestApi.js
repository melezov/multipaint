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
    var GuestApi = (function (_super) {
        __extends(GuestApi, _super);
        function GuestApi() {
            _super.apply(this, arguments);
        }
        /* Send a preferred Artist name to register, returns a String with an authentication token */
        GuestApi.prototype.registerArtist = function (name, callback) {
            this._post("/api/Commands.svc/execute/MultiPaint.RegisterArtist", name, callback);
        };
        return GuestApi;
    })(server.Api);
    server.GuestApi = GuestApi;
})(server || (server = {}));

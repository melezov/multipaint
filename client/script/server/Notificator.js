/// <reference path='../all.ts' /> 
var server;
(function (server) {
    'use strict';
    var Notificator = (function () {
        function Notificator() {
            var _this = this;
            this._changeListeners = {};
            var con = $.connection;
            $.connection.hub.url = "/signalr/hubs";
            $.connection.hub.start().done(function () {
                con.notifyHub.server.listen('MultiPaint.Artist');
                con.notifyHub.server.listen('MultiPaint.Brush');
            });
            con.notifyHub.client.notify = function (id, uris) {
                _this._processNotification(id, uris);
            };
        }
        Notificator.prototype.addArtistChangeListener = function (callback) {
            this.addChangeListener('MultiPaint.Artist', callback);
        };
        Notificator.prototype.addBrushChangeListener = function (callback) {
            this.addChangeListener('MultiPaint.Brush', callback);
        };
        Notificator.prototype.addChangeListener = function (id, callback) {
            if (this._changeListeners[id] === undefined) {
                this._changeListeners[id] = [callback];
            }
            else {
                this._changeListeners[id].push(callback);
            }
        };
        Notificator.prototype._processNotification = function (id, uris) {
            var listeners = this._changeListeners[id];
            if (listeners !== undefined) {
                for (var i = 0; i < listeners.length; i++) {
                    listeners[i](uris);
                }
            }
        };
        return Notificator;
    })();
    server.Notificator = Notificator;
})(server || (server = {}));

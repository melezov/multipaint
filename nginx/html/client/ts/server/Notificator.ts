/// <reference path='../all.ts' /> 

module server {
    'use strict';

    export class Notificator {
        constructor() {
            var con: any = $.connection;
            $.connection.hub.url = "/signalr/hubs";
            $.connection.hub.start().done(() => {
                con.notifyHub.server.listen('MultiPaint.Artist');
                con.notifyHub.server.listen('MultiPaint.Brush');
            });
            con.notifyHub.client.notify = (id, uris) => {
                this._processNotification(id, uris);
            }
        }

        addArtistChangeListener(callback: (uris: string[]) => void) {
            this.addChangeListener('MultiPaint.Artist', callback);
        }

        addBrushChangeListener(callback: (uris: string[]) => void) {
            this.addChangeListener('MultiPaint.Brush', callback);
        }

        private addChangeListener(id: string, callback: (uris: string[]) => void) {
            if (this._changeListeners[id] === undefined) {
                this._changeListeners[id] = [callback];
            }
            else {
                this._changeListeners[id].push(callback);
            }
        }

        private _changeListeners: { [id: string]: ((uris: string[]) => void)[] } = {};

        private _processNotification(id: string, uris: string[]) {
            var listeners = this._changeListeners[id];
            if (listeners !== undefined) {
                for (var i = 0; i < listeners.length; i++) {
                    listeners[i](uris);
                }
            }
        }
    }
}
/// <reference path='../all.ts' /> 

module server {
    'use strict';

    export class GuestApi extends Api {
        /* Send a preferred Artist name to register, returns a String with an authentication token */
        registerArtist(name: string, callback: (token: string) => void) {
            this._post("/api/Commands.svc/execute/MultiPaint.RegisterArtist", name, callback);
        }
    }
}
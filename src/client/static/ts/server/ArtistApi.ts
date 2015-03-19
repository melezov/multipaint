/// <reference path='../all.ts' /> 

module server {
    'use strict';

    export class ArtistApi {
        private _userID: string;
        private _password: string;

        public constructor(userID: string, password: string) {
            this._userID = userID;
            this._password = password;
        }

        protected _post(path: string, data: any, callback: (result: any) => void) {
            $.ajax({
                type: 'POST',
                url: '/canvas/' + this._userID + '/' + this._password + '/' + path,
                data: JSON.stringify(data),
                success: callback,
                dataType: 'json'
            });
        }

        changeArtistName(data: model.ChangeArtistName, callback: () => void) {
            this._post('change-artist-name', data, callback);
        }

        ///* Sends new brush parameters, returns the newly created brushID */
        //changeBrush(data: model.ChangeBrush, callback: (brushID: number) => void) {
        //    this._post(
        //        canvasUrl('change-brush'),
        //        data,
        //        callback);               
        //}

        ///* Sends a brush action domain event, void return (async event) */
        //brushAction(data: model.BrushAction, callback: () => void) {
        //    this._post(
        //        "/api/Domain.svc/submit/MultiPaint.BrushAction",
        //        data,
        //        response => callback());
        //}
    }
}
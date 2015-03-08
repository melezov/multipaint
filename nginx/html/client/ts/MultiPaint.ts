/// <reference path='all.ts' /> 

class MultiPaint {
    constructor() {
        this._notificator = new server.Notificator();
        this._guestApi = new server.GuestApi();
    }    
    
    private _notificator: server.Notificator;
    private _guestApi: server.GuestApi;

    private _artistName: string;
    private _artistApi: server.ArtistApi;

    private _localBrush: drawing.Brush;
    private _localBrushID: number;
    private _localIndex: number;
    private _brushControl: drawing.BrushControl;
    private _brushCursor: drawing.BrushCursor;

    registerArtist(name: string) {
        this._guestApi.registerArtist(name, token => {
            this._artistName = name;
            this._artistApi = new server.ArtistApi(token);

            this._initBrush();
        });
    }

    private _persistBrush() {
        this._artistApi.changeBrush({
            Color: this._localBrush.color,
            Thickness: this._localBrush.thickness
        }, brushID => {
            this._localBrushID = brushID;
            this._localIndex = 0;
        });
    }

    private _initBrush() {
        var brush = new drawing.Brush();
        this._localBrush = brush;
        this._brushControl = new drawing.BrushControl(brush);
        this._brushCursor = new drawing.BrushCursor();

        this._notificator.addBrushChangeListener(uris => {
            console.log("brush", uris);
        });

        this._notificator.addArtistChangeListener(uris => {
            console.log("artist", uris);
        });

        this._brushCursor.addChangeListener(brushTracking => {
            this._artistApi.brushAction({
                BrushID: this._localBrushID,
                Index: this._localIndex,
                Tracking: brushTracking
            }, () => { });
        });

        var $colorpicker: any = $('#colorPicker');
        $colorpicker.tinycolorpicker();

        var colorBox = $colorpicker.data("plugin_tinycolorpicker")
        $colorpicker.bind("change", c => {
            this._brushControl.color = colorBox.colorHex;
        });

        $('#brush-thicken').repeatedclick(() => this._brushControl.thicken());
        $('#brush-thin').repeatedclick(() => this._brushControl.thin());
        $('#brush-random').mousedown(() => this._brushControl.randomize());
        $('#brush-brighten').repeatedclick(() => this._brushControl.brighten());
        $('#brush-darken').repeatedclick(() => this._brushControl.darken());

        this._brushControl.addChangeListener(brush => {
            if (brush.color !== colorBox.colorHex) {
                colorBox.setColor(brush.color);

                var brightenColor = drawing.BrushControl.brighten(brush.hsl);
                var darkenColor = drawing.BrushControl.darken(brush.hsl);
                $('#brush-darken span').css('color', darkenColor.toRGB().toHex());
                $('#brush-brighten span').css('color', brightenColor.toRGB().toHex());
            }

            $('#brush-thickness').text(brush.thickness / 10);
            this._persistBrush();
        });

        this._brushControl.randomize();

        var $drawing = $('#drawing');
        var scalePoint = (e: JQueryMouseEventObject) => {
            var pos = $drawing.position();
            var relX = (e.clientX - pos.left) / $drawing.width();
            var relY = (e.clientY - pos.top) / $drawing.height();
            return new drawing.Point(relX, relY);
        };

        $(document).mousedown(e => {
            if (e.which === 1) this._brushCursor.documentBrushDown();
        });

        $(document).mouseup(e => {
            if (e.which === 1) this._brushCursor.documentBrushUp();
        });

        $drawing.mousedown(e => {
            if (e.which === 1) this._brushCursor.brushDown(scalePoint(e));
        });

        $drawing.mouseup(e => {
            if (e.which === 1) this._brushCursor.brushUp(scalePoint(e));
        });

        $drawing.mousemove(e => {
            this._brushCursor.brushMove(scalePoint(e));
        });

        $drawing.hover(e => {
            this._brushCursor.brushEnter(scalePoint(e));
        }, e => {
            this._brushCursor.brushExit(scalePoint(e));
        });
    }
}

$(document).ready(() => {

    var mp = new MultiPaint()
    mp.registerArtist('Guest');





    //guestApi.registerArtist('Behro', token => {
    //    var api = new server.ArtistApi(token);
       
    //    var brush = new drawing.Brush();

    //    api.changeBrush({
    //        Color: brush.color,
    //        Thickness: brush.thickness
    //    }, brushID => {

    //        var index = 0;

    //        $(document).click(e => {

    //            api.brushAction({
    //                BrushID: brushID,
    //                Index: index++,
    //                Tracking: {
    //                    State: model.BrushState.Hover,
    //                    X: 100,
    //                    Y: 100
    //                }
    //            },() => {
    //                    console.log("Persisted move to 100");
    //                });

    //            api.brushAction({
    //                BrushID: brushID,
    //                Index: index++,
    //                Tracking: {
    //                    State: model.BrushState.Hover,
    //                    X: 200,
    //                    Y: 200
    //                }
    //            },() => {
    //                    console.log("Persisted move to 200");
    //                });

    //        });
            
    //    });
        
    //});

});

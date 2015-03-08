/// <reference path='all.ts' /> 
var MultiPaint = (function () {
    function MultiPaint() {
        this._notificator = new server.Notificator();
        this._guestApi = new server.GuestApi();
    }
    MultiPaint.prototype.registerArtist = function (name) {
        var _this = this;
        this._guestApi.registerArtist(name, function (token) {
            _this._artistName = name;
            _this._artistApi = new server.ArtistApi(token);
            _this._initBrush();
        });
    };
    MultiPaint.prototype._persistBrush = function () {
        var _this = this;
        this._artistApi.changeBrush({
            Color: this._localBrush.color,
            Thickness: this._localBrush.thickness
        }, function (brushID) {
            _this._localBrushID = brushID;
            _this._localIndex = 0;
        });
    };
    MultiPaint.prototype._initBrush = function () {
        var _this = this;
        var brush = new drawing.Brush();
        this._localBrush = brush;
        this._brushControl = new drawing.BrushControl(brush);
        this._brushCursor = new drawing.BrushCursor();
        this._notificator.addBrushChangeListener(function (uris) {
            console.log("brush", uris);
        });
        this._notificator.addArtistChangeListener(function (uris) {
            console.log("artist", uris);
        });
        this._brushCursor.addChangeListener(function (brushTracking) {
            _this._artistApi.brushAction({
                BrushID: _this._localBrushID,
                Index: _this._localIndex,
                Tracking: brushTracking
            }, function () {
            });
        });
        var $colorpicker = $('#colorPicker');
        $colorpicker.tinycolorpicker();
        var colorBox = $colorpicker.data("plugin_tinycolorpicker");
        $colorpicker.bind("change", function (c) {
            _this._brushControl.color = colorBox.colorHex;
        });
        $('#brush-thicken').repeatedclick(function () { return _this._brushControl.thicken(); });
        $('#brush-thin').repeatedclick(function () { return _this._brushControl.thin(); });
        $('#brush-random').mousedown(function () { return _this._brushControl.randomize(); });
        $('#brush-brighten').repeatedclick(function () { return _this._brushControl.brighten(); });
        $('#brush-darken').repeatedclick(function () { return _this._brushControl.darken(); });
        this._brushControl.addChangeListener(function (brush) {
            if (brush.color !== colorBox.colorHex) {
                colorBox.setColor(brush.color);
                var brightenColor = drawing.BrushControl.brighten(brush.hsl);
                var darkenColor = drawing.BrushControl.darken(brush.hsl);
                $('#brush-darken span').css('color', darkenColor.toRGB().toHex());
                $('#brush-brighten span').css('color', brightenColor.toRGB().toHex());
            }
            $('#brush-thickness').text(brush.thickness / 10);
            _this._persistBrush();
        });
        this._brushControl.randomize();
        var $drawing = $('#drawing');
        var scalePoint = function (e) {
            var pos = $drawing.position();
            var relX = (e.clientX - pos.left) / $drawing.width();
            var relY = (e.clientY - pos.top) / $drawing.height();
            return new drawing.Point(relX, relY);
        };
        $(document).mousedown(function (e) {
            if (e.which === 1)
                _this._brushCursor.documentBrushDown();
        });
        $(document).mouseup(function (e) {
            if (e.which === 1)
                _this._brushCursor.documentBrushUp();
        });
        $drawing.mousedown(function (e) {
            if (e.which === 1)
                _this._brushCursor.brushDown(scalePoint(e));
        });
        $drawing.mouseup(function (e) {
            if (e.which === 1)
                _this._brushCursor.brushUp(scalePoint(e));
        });
        $drawing.mousemove(function (e) {
            _this._brushCursor.brushMove(scalePoint(e));
        });
        $drawing.hover(function (e) {
            _this._brushCursor.brushEnter(scalePoint(e));
        }, function (e) {
            _this._brushCursor.brushExit(scalePoint(e));
        });
    };
    return MultiPaint;
})();
$(document).ready(function () {
    var mp = new MultiPaint();
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

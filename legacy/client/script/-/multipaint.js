
$(function () {
    var brushModel = new BrushModel();
    var colorPicker = new ColorPicker(brushModel);
    var brushTracking = new BrushTracking('drawing');
    var canvasModel = new CanvasModel('drawing');

    new MultiPaintApi().registerArtist("Krezubica", function (api) {
        var brushID = null;

        brushModel.addChangeListener(function (brush) {
            api.changeBrush(brush.color, brush.thickness, function (_brushID) {
                brushID = _brushID;

                canvasModel.addBrush(brushID, brush);
            });
        });

        brushTracking.addChangeListener(function (action, x, y, elapsed) {
            console.log([action, x, y, elapsed]);
        });
    });
});

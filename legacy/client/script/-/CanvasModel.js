function CanvasModel(id) {
    var self = this;

    var _canvas = document.getElementById(id);
    var _ctx = _canvas.getContext("2d");

    var _clean = function() {
        _ctx.clearRect(0, 0, _canvas.width, _canvas.height);
    }

    var _brushes = {};

    this.addBrush = function (brushID, brush) {
        _brushes[brushID] = brush;
        console.log(_brushes);
    };

    this.draw = function () {
    };
}

    //var _strokes = [];
    //for (var i = 0; i < 1000; i++) {
    //    var randomBrush = {
    //        color: randomColor(),
    //        thickness: Math.floor(Math.random() * 100) + 1
    //    };

    //    var b = [];
    //    for (var r = 0; r < 20; r++) {
    //        var x = Math.floor(Math.random() * 512);
    //        var y = Math.floor(Math.random() * 512);
    //        b.push([x, y]);
    //    }
    //    _brushes.push([randomBrush, b]);
    //}

    /* points is an array of two-member integer array containing [x, y] points */
    //this.drawPath = function (brush, points) {
    //    if (points.length >= 2) {
    //        _ctx.beginPath();
    //        _ctx.strokeStyle = brush.color;
    //        _ctx.lineWidth = brush.thickness / 10;
    //        _ctx.lineCap = "round";
    //        _ctx.lineJoin = "round";
    //        _ctx.moveTo(points[0][0], points[0][1]);
    //        for (var i = 1; i < points.length; i++) {
    //            _ctx.lineTo(points[i][0], points[i][1]);
    //        }
    //        _ctx.stroke();
    //    }
    //}

    //var cache = null

    /* point is an integer array containing an [x, y] pair */
//    this.drawCursor = function (brush, point) {
//        var a = Date.now();
//        //if (cache === null) {
//        //    _clean();
//        //    for (var i = 0; i < _brushes.length; i++) {
//        //        self.drawPath(_brushes[i][0], _brushes[i][1]);
//        //    }
//        //    cache = _ctx.getImageData(0, 0, _canvas.width, _canvas.height);
//        //}
//        //else {
//        //    _ctx.putImageData(cache, 0, 0);
//        //}
//        //self.drawPath(brush, [point, point]);
//        console.log("took", Date.now() - a);
//    }
//}

//}
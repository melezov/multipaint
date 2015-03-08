//var brushModel = new BrushModel();

//function CanvasModel(id) {
//    var self = this;

//    var _canvas = document.getElementById(id);
//    var _ctx = _canvas.getContext("2d");

//    var _clean = function() {
//        _ctx.clearRect(0, 0, _canvas.width, _canvas.height);
//    }
    

//    var _strokes = [];
//    //for (var i = 0; i < 1000; i++) {
//    //    var randomBrush = {
//    //        color: randomColor(),
//    //        thickness: Math.floor(Math.random() * 100) + 1
//    //    };

//    //    var b = [];
//    //    for (var r = 0; r < 20; r++) {
//    //        var x = Math.floor(Math.random() * 512);
//    //        var y = Math.floor(Math.random() * 512);
//    //        b.push([x, y]);
//    //    }
//    //    _brushes.push([randomBrush, b]);
//    //}

//    /* points is an array of two-member integer array containing [x, y] points */
//    //this.drawPath = function (brush, points) {
//    //    if (points.length >= 2) {
//    //        _ctx.beginPath();
//    //        _ctx.strokeStyle = brush.color;
//    //        _ctx.lineWidth = brush.thickness / 10;
//    //        _ctx.lineCap = "round";
//    //        _ctx.lineJoin = "round";
//    //        _ctx.moveTo(points[0][0], points[0][1]);
//    //        for (var i = 1; i < points.length; i++) {
//    //            _ctx.lineTo(points[i][0], points[i][1]);
//    //        }
//    //        _ctx.stroke();
//    //    }
//    //}

//    //var cache = null
    
//    /* point is an integer array containing an [x, y] pair */
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

//    var mouseDown = false;
//    $(document).mousedown(function (e) {
//        if (e.which === 1) mouseDown = true;
//    });

//    $(document).mouseup(function (e) {
//        if (e.which === 1) mouseDown = false;
//    });

//    var initTime = Date.now();

//    var updateMouse = function (action, mouseEvent) {
//        var box = drawing.position();
//        var x = Math.floor(mouseEvent.clientX - box.left);
//        var y = Math.floor(mouseEvent.clientY - box.top);
//        var elapsed = Date.now() - initTime;
//        canvasModel.drawCursor(brushModel.brush(), [x, y]);
//    }

//    var drawing = $("#drawing");
//    drawing.mousemove(function (e) {
//        updateMouse(mouseDown ? MouseAction.Drag : MouseAction.Move, e);
//        return false;
//    });

//    drawing.mousedown(function (e) {
//        if (e.which === 1) {
//            mouseDown = true;
//            updateMouse(MouseAction.Press, e);
//        }
//        return false;
//    });

//    drawing.mouseup(function (e) {
//        if (mouseDown && e.which === 1) {
//            mouseDown = false;
//            updateMouse(MouseAction.Release, e);
//        }
//        return false;
//    });

//    drawing.hover(function (e) {
//        if (mouseDown) updateMouse(MouseAction.Press, e);
//        return false;
//    }, function (e) {
//        if (mouseDown) sendMouse(MouseAction.Release, e);
//        return false;
//    });


/////*
////    function searchDrawings(lastID, callback) {
////        return $.ajax({
////            url: '/api/Domain.svc/search/MultiPaint.Drawing?specification=GetFromID&order=BrushID,Index',
////            type: 'PUT',
////            success: callback,
////            data: JSON.stringify({ lastID: lastID }),
////            contentType: 'json'
////        });
////    }




////    function paint(drawing) {
////        var drawing = document.getElementById('drawing');
////        var ctx = drawing.getContext("2d");

////        var lastBrushID = -1;
////        for (i = 0; i < drawing.length; i++) {
////            var current = drawing[i];
////            if (current.BrushID !== lastBrushID) {
////                if (lastBrushID !== -1) ctx.stroke();
////                ctx.strokeStyle = current.Color;
////                ctx.beginPath();
////                lastBrushID = current.BrushID;
////            }
////            if (current.State === 'Press') {
////                ctx.moveTo(current.Position.X, current.Position.Y);
////            }
////            else if (current.State === 'Drag') {
////                ctx.lineTo(current.Position.X, current.Position.Y)
////            }
////            else if (current.State === 'Release') {
////                ctx.stroke();
////            }
////        }
////        ctx.stroke();
////    };
    
////    searchDrawings(-1, function (data) {
////        paint(data);
////    });

//    $.connection.hub.start().done(function() {
//    $.connection.notifyHub.server.listen('MultiPaint.Segment') });
//    $.connection.hub.url = '/signalr/hubs';
//    $.connection.notifyHub.client.notify = function (root, uris) {

////        var minUri = Number.MAX_VALUE;
////        for (i = 0; i < uris; i++) {
////            var uri = parseInt(uris[i], 10)
////            if (minUri > uri) minUri = uri;
////        }

////        searchDrawings(minUri, function (data) {
////            paint(data);
////        });
////    };

////    var name = 'Guest';
////    registerArtist(name, function(data) {
////        var session = data;



////        function sendMouse(state, mouseEvent) {
////            var box = drawing.position();
////            var x = mouseEvent.clientX - Math.floor(box.left);
////            var y = mouseEvent.clientY - Math.floor(box.top);
////            mouseAction(session, brushID, index++, state, x, y);
////        }

////        var drawing = $("#drawing");
////        drawing.mousedown(function (e) {
////            if (e.which === 1) {
////                mouseDown = true;
////                sendMouse('Press', e);
////            }
////            return false;
////        });

////        drawing.mousemove(function (e) {
////            if (mouseDown) {
////                sendMouse('Drag', e);
////            }
////            return false;
////        });

////        drawing.mouseup(function (e) {
////            if (mouseDown && e.which === 1) {
////                mouseDown = false;
////                sendMouse('Release', e);
////            }
////            return false;
////        });

////        drawing.hover(function (e) {
////            if (mouseDown) sendMouse('Press', e);
////            return false;
////        }, function (e) {
////            if (mouseDown) sendMouse('Release', e);
////            return false;
////        });
////    });
////*/

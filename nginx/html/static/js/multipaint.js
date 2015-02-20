$(function () {
    function searchDrawings(lastID, callback) {
        return $.ajax({
            url: '/api/Domain.svc/search/MultiPaint.Drawing?specification=GetFromID&order=BrushID,Index',
            type: 'PUT',
            success: callback,
            data: JSON.stringify({ lastID: lastID }),
            contentType: 'json'
        });
    }

    function registerArtist(name, callback) {
        $.post('/api/Commands.svc/execute/MultiPaint.RegisterArtist', JSON.stringify(name), callback, 'json');
    }

    function changeBrush(session, color, callback) {
        $.post('/api/Domain.svc/submit/MultiPaint.ChangeBrush?result=instance', JSON.stringify({
                Session: session,
                Color: color
            }), callback, 'json');
    }

    function mouseAction(session, brushID, index, state, X, Y, callback) {
        $.post('/api/Domain.svc/submit/MultiPaint.MouseAction', JSON.stringify({
                Session: session,
                BrushID: brushID,
                Index: index,
                State: state,
                Position: { "X": X, "Y": Y }
            }), callback, 'json');
    }


    var mouseDown = false;
    $(document).mousedown(function (e) {
        if (e.which === 1) mouseDown = true;
    });

    $(document).mouseup(function (e) {
        if (e.which === 1) mouseDown = false;
    });

    function paint(drawing) {
        var sandbox = document.getElementById('sandbox');
        var ctx = sandbox.getContext("2d");

        var lastBrushID = -1;
        for (i = 0; i < drawing.length; i++) {
            var current = drawing[i];
            if (current.BrushID !== lastBrushID) {
                if (lastBrushID !== -1) ctx.stroke();
                ctx.strokeStyle = current.Color;
                ctx.beginPath();
                lastBrushID = current.BrushID;
            }
            if (current.State === 'Press') {
                ctx.moveTo(current.Position.X, current.Position.Y);
            }
            else if (current.State === 'Drag') {
                ctx.lineTo(current.Position.X, current.Position.Y)
            }
            else if (current.State === 'Release') {
                ctx.stroke();
            }
        }
        ctx.stroke();
    };
    
    searchDrawings(-1, function (data) {
        paint(data);
    });

    $.connection.hub.start().done(function() {
    $.connection.notifyHub.server.listen('MultiPaint.Segment') });
    $.connection.hub.url = '/signalr/hubs';
    $.connection.notifyHub.client.notify = function (root, uris) {

        var minUri = Number.MAX_VALUE;
        for (i = 0; i < uris; i++) {
            var uri = parseInt(uris[i], 10)
            if (minUri > uri) minUri = uri;
        }

        searchDrawings(minUri, function (data) {
            paint(data);
        });
    };

    var name = 'Guest';
    registerArtist(name, function(data) {
        var session = data;

        var $box = $('#colorPicker');
        $box.tinycolorpicker();
        var box = $box.data("plugin_tinycolorpicker")
        box.setColor("#007f7f");

        var brushID = null;
        var index = null;
        function changeColor() {
            changeBrush(session, box.colorHex, function (data) {
                    brushID = data.BrushID;
                    index = 0;
                }, true);
        }

        changeColor();
        $box.bind("change", changeColor);

        function sendMouse(state, mouseEvent) {
            var box = sandbox.position();
            var x = mouseEvent.clientX - Math.floor(box.left);
            var y = mouseEvent.clientY - Math.floor(box.top);
            mouseAction(session, brushID, index++, state, x, y);
        }

        var sandbox = $("#sandbox");
        sandbox.mousedown(function (e) {
            if (e.which === 1) {
                mouseDown = true;
                sendMouse('Press', e);
            }
            return false;
        });

        sandbox.mousemove(function (e) {
            if (mouseDown) {
                sendMouse('Drag', e);
            }
            return false;
        });

        sandbox.mouseup(function (e) {
            if (mouseDown && e.which === 1) {
                mouseDown = false;
                sendMouse('Release', e);
            }
            return false;
        });

        sandbox.hover(function (e) {
            if (mouseDown) sendMouse('Press', e);
            return false;
        }, function (e) {
            if (mouseDown) sendMouse('Release', e);
            return false;
        });
    });
});
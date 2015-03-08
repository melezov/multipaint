function BrushTracking(id) {
    var _initTime = Date.now();
    var self = this;

    var _mouseDown = false;
    $(document).mousedown(function (e) {
        if (e.which === 1) _mouseDown = true;
    });

    $(document).mouseup(function (e) {
        if (e.which === 1) _mouseDown = false;
    });

    var _drawing = $("#" + id);

    this.BrushState = {
        Hover: "Hover",
        Press: "Press",
        Draw: "Draw",
        Lift: "Lift"
    };

    _drawing.mousemove(function (e) {
        _updateBrush(_mouseDown ? self.BrushState.Draw : self.BrushState.Hover, e);
        return false;
    });

    _drawing.mousedown(function (e) {
        if (e.which === 1) {
            _mouseDown = true;
            _updateBrush(self.BrushState.Press, e);
        }
        return false;
    });

    _drawing.mouseup(function (e) {
        if (_mouseDown && e.which === 1) {
            _mouseDown = false;
            _updateBrush(self.BrushState.Lift, e);
        }
        return false;
    });

    _drawing.hover(function (e) {
        if (_mouseDown) _updateBrush(self.BrushState.Press, e);
        return false;
    }, function (e) {
        if (_mouseDown) _updateBrush(self.BrushState.Lift, e);
        return false;
    });

    var _updateBrush = function (action, mouseEvent) {
        var box = _drawing.position();
        var x = Math.floor(mouseEvent.clientX - box.left);
        var y = Math.floor(mouseEvent.clientY - box.top);
        var elapsed = Date.now() - _initTime;

        for (var i = 0; i < _changeListeners.length; i++) {
            _changeListeners[i](action, x, y, elapsed);
        }
    };

    var _changeListeners = [];
    this.addChangeListener = function (listener) {
        if (typeof (listener) !== "function") {
            return false;
        }

        _changeListeners.push(listener);
        return true;
    };
}
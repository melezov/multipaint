function BrushModel() {
    var _color = "#007f7f";
    var _thickness = 250;

    this.brush = function () {
        return {
            color: _color,
            thickness: _thickness
        };
    };

    /* expects '#rrggbb', a 6 hex digit color string */
    this.color = function (newColor) {
        if (newColor === undefined) {
            return _color;
        }

        if (typeof newColor !== "string" || !(/^#[0-9A-Fa-f]{6}$/.test(newColor))) {
            // invalid color, set default
            newColor = "#007f7f";
        }

        return updateBrush({ color: newColor });
    };

    /* expects an integer in range of [1..250] */
    this.thickness = function (newThickness) {
        if (newThickness === undefined) {
            return _thickness;
        }

        newThickness = parseInt(newThickness, 10);
        if (newThickness > 250) {
            // set max
            newThickness = 250;
        } else if (newThickness >= 10) {
            // ok
        } else {
            // catchall (NaN, 0, -1), set default
            newThickness = 10;
        }

        return updateBrush({ thickness: newThickness });
    };

    var updateBrush = function (brush) {
        var updated = false;

        if (brush.color === undefined) {
            brush.color = _color;
        }
        else if (brush.color !== _color) {
            updated = true;
            _color = brush.color;
        }

        if (brush.thickness === undefined) {
            brush.thickness = _thickness;
        }
        else if (brush.thickness !== _thickness) {
            updated = true;
            _thickness = brush.thickness;
        }

        if (updated) {
            _notifyChange(brush);
        }

        return updated;
    };

    var _changeListeners = [];
    var _notifyChange = function () {
        var brush = {
            color: _color,
            thickness: _thickness
        };

        for (var i = 0; i < _changeListeners.length; i++) {
            _changeListeners[i](brush);
        }
    };

    this.addChangeListener = function (listener) {
        if (typeof (listener) !== "function") {
            return false;
        }

        _changeListeners.push(listener);
        return true;
    };

    var _int2Hex = function (val) {
        var str = Number(val).toString(16);
        return str.length === 1 ? "0" + str : str;
    };

    this.getRandomColor = function () {
        return '#' +
        _int2Hex(Math.floor(Math.random() * 256)) +
        _int2Hex(Math.floor(Math.random() * 256)) +
        _int2Hex(Math.floor(Math.random() * 256));
    };
}
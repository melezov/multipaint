var Point = (function () {
    function Point(x, y) {
        this._x = x;
        this._y = y;
    }
    Object.defineProperty(Point.prototype, "x", {
        get: function () {
            return this._x;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Point.prototype, "y", {
        get: function () {
            return this._y;
        },
        enumerable: true,
        configurable: true
    });
    return Point;
})();
var ArtistBrush = (function () {
    function ArtistBrush(name, brush, lastAction) {
        this._name = name;
        this._brush = brush;
        this._lastAction = lastAction;
    }
    Object.defineProperty(ArtistBrush.prototype, "name", {
        get: function () {
            return this._name;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(ArtistBrush.prototype, "brush", {
        get: function () {
            return this._brush;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(ArtistBrush.prototype, "lastAction", {
        get: function () {
            return this._lastAction;
        },
        set: function (newLastAction) {
            this._lastAction = newLastAction;
        },
        enumerable: true,
        configurable: true
    });
    return ArtistBrush;
})();
var Canvas = (function () {
    function Canvas(canvas) {
        this._canvas = canvas;
        this._context = canvas.getContext('2d');
    }
    Canvas.prototype.clean = function () {
        this._context.clearRect(0, 0, this._canvas.width, this._canvas.height);
    };
    Canvas.prototype._toAbs = function (position) {
        var w = this._canvas.width;
        var h = this._canvas.height;
        return new Point(position.x * w, position.y * h);
    };
    Canvas.prototype._drawArtistBrush = function (artistBrush) {
        var ctx = this._context;
        ctx.beginPath();
        var pos = this._toAbs(artistBrush.lastAction.position);
        console.log(pos);
        ctx.arc(pos.x, pos.y, artistBrush.brush.thickness / 10, 0, 2 * Math.PI, false);
        ctx.fillStyle = artistBrush.brush.color;
        ctx.fill();
        ctx.stroke();
    };
    Canvas.prototype.drawArtistBrushes = function (artistBrushes) {
        for (var name in artistBrushes) {
            if (name !== Drawing.LocalName) {
                var artistBrush = artistBrushes[name];
                this._drawArtistBrush(artistBrush);
            }
        }
        this._drawArtistBrush(artistBrushes[Drawing.LocalName]);
    };
    return Canvas;
})();
var Drawing = (function () {
    function Drawing(canvas, brushControl, brushTracking) {
        var _this = this;
        this._artistBrushes = {};
        this._canvas = canvas;
        this._brushControl = brushControl;
        this._brushTracking = brushTracking;
        this._localBrush = new ArtistBrush(Drawing.LocalName, brushControl.brush, new BrushAction(BrushState.Hover, new Point(0.5, 0.5)));
        this.addArtistBrush(this._localBrush);
        brushControl.addChangeListener(function (_) {
            _this.draw();
        });
        brushTracking.addChangeListener(function (brushAction) {
            _this._localBrush.lastAction = brushAction;
            //            this.draw();
        });
    }
    Drawing.prototype.addArtistBrush = function (artistBrush) {
        this._artistBrushes[artistBrush.name] = artistBrush;
        this.draw();
    };
    Drawing.prototype.draw = function () {
        //        this._canvas.clean();
        this._canvas.drawArtistBrushes(this._artistBrushes);
    };
    Drawing.LocalName = 'Local';
    return Drawing;
})();

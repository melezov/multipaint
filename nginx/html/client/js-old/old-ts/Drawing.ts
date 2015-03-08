class Point {
    private _x: number;
    private _y: number;

    get x() { return this._x; }
    get y() { return this._y; }

    constructor(x: number, y: number) {
        this._x = x;
        this._y = y;
    }
}

class ArtistBrush {
    private _name: string;
    private _brush: Brush;
    private _lastAction: BrushAction;

    get name() { return this._name; }
    get brush() { return this._brush; }
    get lastAction() { return this._lastAction; }

    set lastAction(newLastAction: BrushAction) {
        this._lastAction = newLastAction;
    }

    constructor(name: string, brush: Brush, lastAction: BrushAction) {
        this._name = name;
        this._brush = brush;
        this._lastAction = lastAction;
    }
}

class Canvas {
    private _canvas: HTMLCanvasElement;
    private _context: CanvasRenderingContext2D;

    clean() {
        this._context.clearRect(0, 0, this._canvas.width, this._canvas.height);
    }

    constructor(canvas: HTMLCanvasElement) {
        this._canvas = canvas;
        this._context = canvas.getContext('2d');
    }

    private _toAbs(position: Point) {
        var w = this._canvas.width;
        var h = this._canvas.height;
        return new Point(position.x * w, position.y * h); 
    }

    private _drawArtistBrush(artistBrush: ArtistBrush) {
        var ctx = this._context;
        ctx.beginPath();
        var pos = this._toAbs(artistBrush.lastAction.position);
        console.log(pos);
        ctx.arc(pos.x, pos.y, artistBrush.brush.thickness / 10, 0, 2 * Math.PI, false);
        ctx.fillStyle = artistBrush.brush.color;
        ctx.fill();
        ctx.stroke();
    }

    drawArtistBrushes(artistBrushes: { [artistName: string]: ArtistBrush; }) {
        for (var name in artistBrushes) {
            if (name !== Drawing.LocalName) {
                var artistBrush = artistBrushes[name];
                this._drawArtistBrush(artistBrush);
            }
        }
        this._drawArtistBrush(artistBrushes[Drawing.LocalName]);
    }
}

class Drawing {
    private _canvas: Canvas;
    private _brushControl: BrushControl;
    private _brushTracking: BrushTracking;

    private _localBrush: ArtistBrush;
    private _artistBrushes: { [artistName: string]: ArtistBrush } = {};

    static LocalName = 'Local';

    constructor(
            canvas: Canvas,
            brushControl: BrushControl,
            brushTracking: BrushTracking) {
        this._canvas = canvas;
        this._brushControl = brushControl;
        this._brushTracking = brushTracking;

        this._localBrush = new ArtistBrush(
            Drawing.LocalName,
            brushControl.brush,
            new BrushAction(BrushState.Hover, new Point(0.5, 0.5)));

        this.addArtistBrush(this._localBrush);

        brushControl.addChangeListener(_ => {
            this.draw();
        });

        brushTracking.addChangeListener(brushAction => {
            this._localBrush.lastAction = brushAction;
//            this.draw();
        });
    }

    addArtistBrush(artistBrush: ArtistBrush) {
        this._artistBrushes[artistBrush.name] = artistBrush;
        this.draw();
    }

    draw() {
//        this._canvas.clean();
        this._canvas.drawArtistBrushes(this._artistBrushes);
    }
}

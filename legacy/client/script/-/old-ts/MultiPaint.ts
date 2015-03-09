///<reference path="../d.ts/jquery.d.ts" />

$(document).ready(() => {

    var $canvas = <HTMLCanvasElement> document.getElementById('drawing')
    var canvas = new Canvas($canvas);

    var localBrush = new Brush();
    var brushControl = new BrushControl(localBrush);
    var brushTracking = new BrushTracking();

    var drawing = new Drawing(canvas, brushControl, brushTracking);

    for (var index = 0; index < 200; index++) {
        (function () {
            var brush = new Brush();
            var rgb = RGB.random();
            var hsl = rgb.toHSL();
            brush.rgb = rgb;
            brush.thickness = 100 + Math.random() * 100;

            var artistBrush = new ArtistBrush("#" + index, brush,
                new BrushAction(BrushState.Hover, new Point(0, 0)));

            drawing.addArtistBrush(artistBrush);

            var x = 0.5;
            var y = 0.5;
            var stepX = 0.01;
            var stepY = 0.01;

            setInterval(function () {
                x += stepX;
                y += stepY;
                if (x < 0) {
                    x = 0;
                    stepX = Math.random() * 0.01 + 0.01;
                } else if (x > 1) {
                    x = 1;
                    stepX = Math.random() * -0.01 - 0.01;
                }

                if (y < 0) {
                    y = 0;
                    stepY = Math.random() * 0.01 + 0.01;
                } else if (y > 1) {
                    y = 1;
                    stepY = Math.random() * -0.01 - 0.01;
                }

                artistBrush.brush.rgb =
                    new HSL(hsl.h, Math.min(1, hsl.s + x), hsl.l).toRGB();

                artistBrush.lastAction =
                    new BrushAction(BrushState.Hover, new Point(x, y));
            }, 50);
        })();
    }

    setInterval(function () { drawing.draw(); }, 50);

});

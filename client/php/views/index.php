<!DOCTYPE html>
<html>
    <title>MultiPaint</title>
    <head>
        <meta charset="utf-8">
        <link rel="stylesheet" href="/static/css/multipaint.css?ver=<?php echo VERSION; ?>"/>
        <link rel="stylesheet" href="/static/css/colorpicker.css"/>
    </head>

<body>
    <h1>MultiPaint - Click and drag!</h1>
    <div id="colorPicker">
        <a class="color"><div class="colorInner"></div></a>
        <div class="track"></div>
        <ul class="dropdown"><li></li></ul>
        <input type="hidden" class="colorInput" />
    </div>
    <div id="brush-control" class="noselect">
        <span id="brush-thin">[&#x2212;]</span>&nbsp;
        <span id="brush-thickness">5</span>&nbsp;
        <span id="brush-thicken">[+]</span>&nbsp;
        <span id="brush-random">[random]</span>&nbsp;
        <span id="brush-brighten">[<span>&#x258A;</span>]</span>&nbsp;
        <span id="brush-darken">[<span>&#x258A;</span>]</span>
    </div>
    <div id="drawing-area">
        <canvas id="drawing" width="512" height="512"/>
    </div>
    <div id="signature">
        Drawing by <span id="artist-name">Guest</span>
    </div>

    <script type="text/javascript" src="/static/js/jquery-2.1.3.min.js"></script>
    <script type="text/javascript" src="/static/js/jquery.repeatedclick-1.0.5.min.js"></script>
    <script type="text/javascript" src="/static/js/jquery.tinycolorpicker-0.0.7.min.js"></script>
    <script type="text/javascript" src="/static/js/jquery.signalr-2.1.0.min.js"></script>
    <script type="text/javascript" src="/static/js/multipaint.js?ver=<?php echo VERSION; ?>"></script>
    <script type="text/javascript" src="/signalr/hubs"></script>
</body>
</html>

/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var Brush = (function () {
        function Brush() {
            this._changeListeners = [];
            this.color = Brush.ColorDefault;
            this.thickness = Brush.ThicknessDefault;
        }
        Object.defineProperty(Brush.prototype, "rgb", {
            get: function () {
                return this._rgb;
            },
            set: function (rgb) {
                var newColor = rgb.toHex();
                if (this._color !== newColor) {
                    this._rgb = rgb;
                    this._hsl = rgb.toHSL();
                    this._color = newColor;
                    this._notifyChangeListeners();
                }
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Brush.prototype, "hsl", {
            get: function () {
                return this._hsl;
            },
            set: function (hsl) {
                var newRGB = hsl.toRGB();
                var newColor = newRGB.toHex();
                if (this._color !== newColor) {
                    this._rgb = hsl.toRGB();
                    this._hsl = hsl;
                    this._color = newColor;
                    this._notifyChangeListeners();
                }
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Brush.prototype, "color", {
            get: function () {
                return this._color;
            },
            set: function (newColor) {
                this.rgb = drawing.RGB.fromHex(newColor);
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(Brush.prototype, "thickness", {
            get: function () {
                return this._thickness;
            },
            set: function (newThickness) {
                newThickness = Math.floor(newThickness);
                if (!(newThickness >= Brush.ThicknessMin && newThickness <= Brush.ThicknessMax)) {
                    throw "Thickness " + newThickness + " is out of range [" + Brush.ThicknessMin + "," + Brush.ThicknessMax + "]";
                }
                if (this._thickness !== newThickness) {
                    this._thickness = newThickness;
                    this._notifyChangeListeners();
                }
            },
            enumerable: true,
            configurable: true
        });
        Brush.prototype.updateWith = function (brush) {
            if (this._color != brush._color || this._thickness != brush._thickness) {
                this._rgb = brush._rgb;
                this._hsl = brush._hsl;
                this._color = brush._color;
                this._thickness = brush._thickness;
                this._notifyChangeListeners();
            }
        };
        Brush.prototype.addChangeListener = function (listener) {
            this._changeListeners.push(listener);
        };
        Brush.prototype._notifyChangeListeners = function () {
            var _this = this;
            this._changeListeners.forEach(function (listener) {
                listener(_this);
            });
        };
        Brush.ThicknessMin = 10;
        Brush.ThicknessMax = 250;
        Brush.ColorDefault = "#000000";
        Brush.ThicknessDefault = 50;
        return Brush;
    })();
    drawing.Brush = Brush;
})(drawing || (drawing = {}));
/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var BrushControl = (function () {
        function BrushControl(brush) {
            this._brush = brush;
        }
        Object.defineProperty(BrushControl.prototype, "brush", {
            get: function () {
                return this._brush;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(BrushControl.prototype, "color", {
            set: function (newColor) {
                this._brush.color = newColor;
            },
            enumerable: true,
            configurable: true
        });
        BrushControl.prototype.randomize = function () {
            var randomBrush = new drawing.Brush();
            randomBrush.rgb = drawing.RGB.random();
            randomBrush.thickness = BrushControl.randomThickness();
            this._brush.updateWith(randomBrush);
        };
        BrushControl.randomThickness = function () {
            var min = drawing.Brush.ThicknessMin;
            var max = drawing.Brush.ThicknessMax;
            var step = BrushControl.ThicknessStep;
            var range = max - min;
            var steps = Math.floor(range / step) + 1;
            return min + Math.floor(Math.random() * steps) * step;
        };
        BrushControl.prototype.thicken = function () {
            this._brush.thickness = Math.min(this._brush.thickness + BrushControl.ThicknessStep, drawing.Brush.ThicknessMax);
        };
        BrushControl.prototype.thin = function () {
            this._brush.thickness = Math.max(this._brush.thickness - BrushControl.ThicknessStep, drawing.Brush.ThicknessMin);
        };
        BrushControl.darken = function (hsl) {
            var newL = Math.max(hsl.l - BrushControl.LightnessStep, drawing.HSL.LigthnessMin);
            return new drawing.HSL(hsl.h, hsl.s, newL);
        };
        BrushControl.prototype.darken = function () {
            this._brush.hsl = BrushControl.darken(this._brush.hsl);
        };
        BrushControl.brighten = function (hsl) {
            var newL = Math.min(hsl.l + BrushControl.LightnessStep, drawing.HSL.LightnessMax);
            return new drawing.HSL(hsl.h, hsl.s, newL);
        };
        BrushControl.prototype.brighten = function () {
            this._brush.hsl = BrushControl.brighten(this._brush.hsl);
        };
        BrushControl.prototype.addChangeListener = function (listener) {
            this._brush.addChangeListener(listener);
        };
        BrushControl.ThicknessStep = 10;
        BrushControl.LightnessStep = 0.1;
        return BrushControl;
    })();
    drawing.BrushControl = BrushControl;
})(drawing || (drawing = {}));
/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
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
    drawing.Point = Point;
    var BrushCursor = (function () {
        function BrushCursor() {
            this._changeListeners = [];
            this._brushDown = false;
        }
        BrushCursor.prototype.documentBrushUp = function () {
            this._brushDown = false;
        };
        BrushCursor.prototype.documentBrushDown = function () {
            this._brushDown = true;
        };
        BrushCursor.prototype.brushHover = function (position) {
            this._updateTracking(model.BrushState.Hover, position);
        };
        BrushCursor.prototype.brushPress = function (position) {
            this._updateTracking(model.BrushState.Press, position);
        };
        BrushCursor.prototype.brushDraw = function (position) {
            this._updateTracking(model.BrushState.Draw, position);
        };
        BrushCursor.prototype.brushLift = function (position) {
            this._updateTracking(model.BrushState.Lift, position);
        };
        BrushCursor.prototype.brushEnter = function (position) {
            if (this._brushDown)
                this.brushPress(position);
        };
        BrushCursor.prototype.brushExit = function (position) {
            if (this._brushDown)
                this.brushLift(position);
        };
        BrushCursor.prototype.brushMove = function (position) {
            if (this._brushDown) {
                this.brushDraw(position);
            }
            else {
                this.brushHover(position);
            }
        };
        BrushCursor.prototype.brushUp = function (position) {
            this._brushDown = false;
            this.brushLift(position);
        };
        BrushCursor.prototype.brushDown = function (position) {
            this._brushDown = true;
            this.brushPress(position);
        };
        BrushCursor.prototype.addChangeListener = function (listener) {
            this._changeListeners.push(listener);
        };
        BrushCursor.prototype._updateTracking = function (state, position) {
            var tracking = {
                State: state,
                X: position.x,
                Y: position.y
            };
            this._notifyChangeListeners(tracking);
        };
        BrushCursor.prototype._notifyChangeListeners = function (brushTracking) {
            this._changeListeners.forEach(function (listener) {
                listener(brushTracking);
            });
        };
        return BrushCursor;
    })();
    drawing.BrushCursor = BrushCursor;
})(drawing || (drawing = {}));
/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var HSL = (function () {
        function HSL(h, s, l) {
            if (!(h >= 0))
                throw "Hue value " + h + " was out of bounds [0,Inf>";
            if (!(s >= HSL.SaturationMin && s <= HSL.SaturationMax))
                throw "Saturation value " + s + " was out of bounds [" + HSL.SaturationMin + "," + HSL.SaturationMax + "]";
            if (!(l >= HSL.LigthnessMin && l <= HSL.LightnessMax))
                throw "Ligthness value " + l + " was out of bounds [" + HSL.LigthnessMin + "," + HSL.LightnessMax + "]";
            this._h = h;
            this._s = s;
            this._l = l;
        }
        Object.defineProperty(HSL.prototype, "h", {
            get: function () {
                return this._h;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(HSL.prototype, "s", {
            get: function () {
                return this._s;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(HSL.prototype, "l", {
            get: function () {
                return this._l;
            },
            enumerable: true,
            configurable: true
        });
        HSL.hue2rgb = function (p, q, t) {
            if (t < 0)
                t += 1;
            if (t > 1)
                t -= 1;
            if (t < 1 / 6)
                return p + (q - p) * 6 * t;
            if (t < 1 / 2)
                return q;
            if (t < 2 / 3)
                return p + (q - p) * (2 / 3 - t) * 6;
            return p;
        };
        // conversion adapted from http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
        HSL.prototype.toRGB = function () {
            var h = this._h;
            var s = this._s;
            var l = this._l;
            var r, g, b;
            if (s === 0) {
                r = g = b = l; // achromatic, RGB values set to L
            }
            else {
                var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
                var p = 2 * l - q;
                r = HSL.hue2rgb(p, q, h + 1 / 3);
                g = HSL.hue2rgb(p, q, h);
                b = HSL.hue2rgb(p, q, h - 1 / 3);
            }
            return new drawing.RGB(r * 0xff, g * 0xff, b * 0xff);
        };
        HSL.SaturationMax = 1;
        HSL.SaturationMin = 0;
        HSL.LightnessMax = 1;
        HSL.LigthnessMin = 0;
        return HSL;
    })();
    drawing.HSL = HSL;
})(drawing || (drawing = {}));
/// <reference path='../all.ts' /> 
var drawing;
(function (drawing) {
    'use strict';
    var RGB = (function () {
        function RGB(r, g, b) {
            if (!(r >= 0 && r <= 0xff))
                throw "Invalid RGB value for r: " + r;
            if (!(g >= 0 && g <= 0xff))
                throw "Invalid RGB value for g: " + g;
            if (!(b >= 0 && b <= 0xff))
                throw "Invalid RGB value for b: " + b;
            this._r = r;
            this._g = g;
            this._b = b;
        }
        Object.defineProperty(RGB.prototype, "r", {
            get: function () {
                return this._r;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(RGB.prototype, "g", {
            get: function () {
                return this._g;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(RGB.prototype, "b", {
            get: function () {
                return this._b;
            },
            enumerable: true,
            configurable: true
        });
        // conversion adapted from http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
        RGB.prototype.toHSL = function () {
            var r = this._r / 0xff;
            var g = this._g / 0xff;
            var b = this._b / 0xff;
            var max = Math.max(r, g, b), min = Math.min(r, g, b);
            var h, s, l = (max + min) / 2;
            if (max == min) {
                h = s = 0; // achromatic
            }
            else {
                var d = max - min;
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
                switch (max) {
                    case r:
                        h = (g - b) / d + (g < b ? 6 : 0);
                        break;
                    case g:
                        h = (b - r) / d + 2;
                        break;
                    case b:
                        h = (r - g) / d + 4;
                        break;
                }
                h /= 6;
            }
            return new drawing.HSL(h, s, l);
        };
        RGB.fromHex = function (rgbHex) {
            if (/^#[0-9A-Fa-f]{6}$/.test(rgbHex)) {
                var r = parseInt(rgbHex.substr(1, 2), 16);
                var g = parseInt(rgbHex.substr(3, 2), 16);
                var b = parseInt(rgbHex.substr(5, 2), 16);
                return new RGB(r, g, b);
            }
            if (/^#[0-9A-Fa-f]{3}$/.test(rgbHex)) {
                var r = parseInt(rgbHex.charAt(1), 16) * 0x11;
                var g = parseInt(rgbHex.charAt(2), 16) * 0x11;
                var b = parseInt(rgbHex.charAt(3), 16) * 0x11;
                return new RGB(r, g, b);
            }
            throw "Color \"" + rgbHex + "\" was not in \"#rrggbb\" nor \"#rgb\" format!";
        };
        RGB.random = function () {
            return new RGB(Math.floor(Math.random() * 0x100), Math.floor(Math.random() * 0x100), Math.floor(Math.random() * 0x100));
        };
        RGB.prototype.toHex = function () {
            function byte2Hex(val) {
                val = Math.floor(val);
                var hex = Number(val).toString(16);
                return val < 16 ? "0" + hex : hex;
            }
            return "#" + byte2Hex(this._r) + byte2Hex(this._g) + byte2Hex(this._b);
        };
        return RGB;
    })();
    drawing.RGB = RGB;
})(drawing || (drawing = {}));
/// <reference path='../all.ts' /> 
var model;
(function (model) {
    'use strict';
})(model || (model = {}));
/// <reference path='../all.ts' /> 
var model;
(function (model) {
    'use strict';
    var BrushState = (function () {
        function BrushState() {
        }
        BrushState.Hover = 'Hover';
        BrushState.Press = 'Press';
        BrushState.Draw = 'Draw';
        BrushState.Lift = 'Lift';
        return BrushState;
    })();
    model.BrushState = BrushState;
    ;
})(model || (model = {}));
/// <reference path='../all.ts' /> 
var model;
(function (model) {
    'use strict';
})(model || (model = {}));
/// <reference path='../all.ts' /> 
var model;
(function (model) {
    'use strict';
})(model || (model = {}));
/// <reference path='../all.ts' /> 
var server;
(function (server) {
    'use strict';
    var Api = (function () {
        function Api() {
        }
        Api.prototype._send = function (type, url, data, callback) {
            $.ajax({
                type: type,
                url: url,
                data: JSON.stringify(data),
                success: callback,
                dataType: 'json'
            });
        };
        Api.prototype._post = function (url, data, callback) {
            this._send('POST', url, data, callback);
        };
        /* Sends new brush parameters, returns the newly created brushID */
        Api.prototype.changeBrush = function (data, callback) {
            this._post("/api/Domain.svc/submit/MultiPaint.ChangeBrush?result=instance", data, function (response) { return callback(response.BrushID); });
        };
        /* Sends a brush action domain event, void return (async event) */
        Api.prototype.brushAction = function (data, callback) {
            this._post("/api/Domain.svc/submit/MultiPaint.BrushAction", data, function (response) { return callback(); });
        };
        return Api;
    })();
    server.Api = Api;
})(server || (server = {}));
/// <reference path='../all.ts' /> 
var server;
(function (server) {
    'use strict';
    var Notificator = (function () {
        function Notificator() {
            var _this = this;
            this._changeListeners = {};
            var con = $.connection;
            $.connection.hub.url = "/signalr/hubs";
            $.connection.hub.start().done(function () {
                con.notifyHub.server.listen('MultiPaint.Artist');
                con.notifyHub.server.listen('MultiPaint.Brush');
            });
            con.notifyHub.client.notify = function (id, uris) {
                _this._processNotification(id, uris);
            };
        }
        Notificator.prototype.addArtistChangeListener = function (callback) {
            this.addChangeListener('MultiPaint.Artist', callback);
        };
        Notificator.prototype.addBrushChangeListener = function (callback) {
            this.addChangeListener('MultiPaint.Brush', callback);
        };
        Notificator.prototype.addChangeListener = function (id, callback) {
            if (this._changeListeners[id] === undefined) {
                this._changeListeners[id] = [callback];
            }
            else {
                this._changeListeners[id].push(callback);
            }
        };
        Notificator.prototype._processNotification = function (id, uris) {
            var listeners = this._changeListeners[id];
            if (listeners !== undefined) {
                for (var i = 0; i < listeners.length; i++) {
                    listeners[i](uris);
                }
            }
        };
        return Notificator;
    })();
    server.Notificator = Notificator;
})(server || (server = {}));
/// <reference path='all.ts' /> 
/*

class MultiPaint {
    constructor() {
        this._notificator = new server.Notificator();
    }
    
    private _notificator: server.Notificator;

    private _artistName: string;
    private _artistApi: server.Api;

    private _localBrush: drawing.Brush;
    private _localBrushID: number;
    private _localIndex: number;
    private _brushControl: drawing.BrushControl;
    private _brushCursor: drawing.BrushCursor;

    private _persistBrush() {
        this._artistApi.changeBrush({
            Color: this._localBrush.color,
            Thickness: this._localBrush.thickness
        }, brushID => {
            this._localBrushID = brushID;
            this._localIndex = 0;
        });
    }

    private _initBrush() {
        var brush = new drawing.Brush();
        this._localBrush = brush;
        this._brushControl = new drawing.BrushControl(brush);
        this._brushCursor = new drawing.BrushCursor();

        this._notificator.addBrushChangeListener(uris => {
            console.log("brush", uris);
        });

        this._notificator.addArtistChangeListener(uris => {
            console.log("artist", uris);
        });

        this._brushCursor.addChangeListener(brushTracking => {
            this._artistApi.brushAction({
                BrushID: this._localBrushID,
                Index: this._localIndex,
                Tracking: brushTracking
            }, () => { });
        });

        var $colorpicker: any = $('#colorPicker');
        $colorpicker.tinycolorpicker();

        var colorBox = $colorpicker.data("plugin_tinycolorpicker")
        $colorpicker.bind("change", c => {
            this._brushControl.color = colorBox.colorHex;
        });

        $('#brush-thicken').repeatedclick(() => this._brushControl.thicken());
        $('#brush-thin').repeatedclick(() => this._brushControl.thin());
        $('#brush-random').mousedown(() => this._brushControl.randomize());
        $('#brush-brighten').repeatedclick(() => this._brushControl.brighten());
        $('#brush-darken').repeatedclick(() => this._brushControl.darken());

        this._brushControl.addChangeListener(brush => {
            if (brush.color !== colorBox.colorHex) {
                colorBox.setColor(brush.color);

                var brightenColor = drawing.BrushControl.brighten(brush.hsl);
                var darkenColor = drawing.BrushControl.darken(brush.hsl);
                $('#brush-darken span').css('color', darkenColor.toRGB().toHex());
                $('#brush-brighten span').css('color', brightenColor.toRGB().toHex());
            }

            $('#brush-thickness').text(brush.thickness / 10);
            this._persistBrush();
        });

        this._brushControl.randomize();

        var $drawing = $('#drawing');
        var scalePoint = (e: JQueryMouseEventObject) => {
            var pos = $drawing.position();
            var relX = (e.clientX - pos.left) / $drawing.width();
            var relY = (e.clientY - pos.top) / $drawing.height();
            return new drawing.Point(relX, relY);
        };

        $(document).mousedown(e => {
            if (e.which === 1) this._brushCursor.documentBrushDown();
        });

        $(document).mouseup(e => {
            if (e.which === 1) this._brushCursor.documentBrushUp();
        });

        $drawing.mousedown(e => {
            if (e.which === 1) this._brushCursor.brushDown(scalePoint(e));
        });

        $drawing.mouseup(e => {
            if (e.which === 1) this._brushCursor.brushUp(scalePoint(e));
        });

        $drawing.mousemove(e => {
            this._brushCursor.brushMove(scalePoint(e));
        });

        $drawing.hover(e => {
            this._brushCursor.brushEnter(scalePoint(e));
        }, e => {
            this._brushCursor.brushExit(scalePoint(e));
        });
    }
}
*/
$(document).ready(function () {
    var api = new server.Api();
    /*    $('#artist-name').click(e => {
            prompt('Enter artist name: ',
        });
    */
    //   alert('aoeu');
    //    var mp = new MultiPaint();
    //guestApi.registerArtist('Behro', token => {
    //    var api = new server.ArtistApi(token);
    //    var brush = new drawing.Brush();
    //    api.changeBrush({
    //        Color: brush.color,
    //        Thickness: brush.thickness
    //    }, brushID => {
    //        var index = 0;
    //        $(document).click(e => {
    //            api.brushAction({
    //                BrushID: brushID,
    //                Index: index++,
    //                Tracking: {
    //                    State: model.BrushState.Hover,
    //                    X: 100,
    //                    Y: 100
    //                }
    //            },() => {
    //                    console.log("Persisted move to 100");
    //                });
    //            api.brushAction({
    //                BrushID: brushID,
    //                Index: index++,
    //                Tracking: {
    //                    State: model.BrushState.Hover,
    //                    X: 200,
    //                    Y: 200
    //                }
    //            },() => {
    //                    console.log("Persisted move to 200");
    //                });
    //        });
    //    });
    //});
});
/// <reference path='definitions/jquery.d.ts' />
/// <reference path='definitions/jquery.repeatedclick.d.ts' />
/// <reference path='definitions/signalr.d.ts' />
/// <reference path='drawing/Brush.ts' />
/// <reference path='drawing/BrushControl.ts' />
/// <reference path='drawing/BrushCursor.ts' />
/// <reference path='drawing/HSL.ts'/>
/// <reference path="drawing/RGB.ts" />
/// <reference path='model/BrushAction.ts' />
/// <reference path='model/BrushState.ts' />
/// <reference path='model/BrushTracking.ts' />
/// <reference path='model/ChangeBrush.ts' />
/// <reference path='server/Api.ts' />
/// <reference path='server/Notificator.ts' />
/// <reference path='MultiPaint.ts' />  

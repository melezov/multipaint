function MultiPaintApi() {
    var _restUrl = "/api/";
    var _signalrUrl = "/signalr/";

    var _sendRequest = function (type, url, data, callback, auth) {
        var request = {
            type: type,
            url: _restUrl + url,
            data: JSON.stringify(data),
            success: callback,
            dataType: "json"
        };

        if (typeof (auth) === 'string')
            request.headers = { Authorization: "Basic " + auth };

        $.ajax(request);
    };

    /* Send a preferred Artist name to register, returns a String with an authentication token */
    this.registerArtist = function (name, callback) {
        _sendRequest("POST", "Commands.svc/execute/MultiPaint.RegisterArtist", name, function (auth) {
            callback(new _makeAuthApi(auth));
        });
    };

    function _makeAuthApi(auth) {
        /* Sends new brush parameters, returns the newly created brushID */
        this.changeBrush = function (color, thickness, callback) {
            _sendRequest("POST", "Domain.svc/submit/MultiPaint.ChangeBrush?result=instance", {
                Color: color,
                Thickness: thickness
            }, function (data) { callback(data.BrushID); }, auth);
        };

        /* Sends a mouse action domain event, void return (async event) */
        this.mouseAction = function (brushID, index, state, x, y) {
            _sendRequest("POST", "Domain.svc/submit/MultiPaint.BrushAction", {
                BrushID: brushID,
                Index: index,
                State: state,
                Position: { "X": x, "Y": y }
            }, null, auth);
        };

        this.addChangeListener = function (name, callback) {
            $.connection.hub.start().done(function () {
                $.connection.notifyHub.server.listen(name);
            });

            $.connection.hub.url = _signalrUrl + "hubs";
            $.connection.notifyHub.client.notify = function (id, uris) {
                callback(uris);
            };
        };
    };
};


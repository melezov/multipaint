function ColorPicker(brushModel) {
    var $colorpicker = $('#colorPicker');
    $colorpicker.tinycolorpicker();
    var colorBox = $colorpicker.data("plugin_tinycolorpicker")
    colorBox.setColor(brushModel.color());

    $colorpicker.bind("change", function () {
        brushModel.color(colorBox.colorHex);
    });

    $('#thickness-inc').click(function () {
        brushModel.thickness(brushModel.thickness() + 10);
    });

    $('#thickness-dec').click(function () {
        brushModel.thickness(brushModel.thickness() - 10);
    });

    $('#random-color').click(function () {
        colorBox.setColor(brushModel.getRandomColor());
        brushModel.color(colorBox.colorHex);
    });
};

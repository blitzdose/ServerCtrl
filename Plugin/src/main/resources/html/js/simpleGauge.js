(function($) {

    $.fn.simpleGauge = function(options) {

        // Defaults

        var defaults = {
            width: '200',
            hueLow: '119', // Choose the starting hue for the active color (for value 0)
            hueHigh: '119', // Choose the ending hue for the active color (for value 100)
            saturation: '44%', // Saturation for active color
            lightness: '35%', // Lightness for active color
            gaugeBG: '#383838', // Background color of Gauge
            parentBG: '#ffffff' // This color should match the parent div of the gauge (or beyond)
        };

        var settings = $.extend({}, defaults, options);

        $(this).each(function(){

            // Color & Data Settings

            var value = $(this).data('value');
            var activeColor = '';

            if ( settings.hueHigh >= settings.hueLow ) {
                activeColor = ( ( settings.hueHigh - settings.hueLow ) * ( value / 100 ) ) + settings.hueLow;
            } else {
                activeColor = ( ( settings.hueLow - settings.hueHigh ) * ( value / 100 ) ) + settings.hueHigh;
            }

            // Add DOM to allow for CSS3 Elements (would have been more elegant to use :before & :after pseudo-elements, but jQuery doesn't support them)

            $(this).prepend('<div class="gauge-wrap-before"></div><div class="gauge-core"><div class="gauge-bg"></div><div class="gauge-active-wrap"><div class="gauge-active"><div class="gauge-active-before"></div></div></div><div class="gauge-cap"></div></div><div class="gauge-wrap-after"></div>');

            // Set Colors

            if ( value ) {
                $(this).find('.gauge-active, .gauge-wrap-before').css('background-color', 'hsla(' + Math.round(activeColor) + ', ' + settings.saturation + ', ' + settings.lightness + ', 1)');

                let r = document.querySelector(':root');
                let color = getComputedStyle(r).getPropertyValue('--bs-primary');

                $(this).find('.gauge-active, .gauge-wrap-before').css('background-color', color);
            } else {
                $(this).find('.gauge-active, .gauge-wrap-before').hide();
            }

            $(this).find('.gauge-bg, .gauge-wrap-after').css('background-color', settings.gaugeBG);
            $(this).find('.gauge-cap').css({
                'background-color': settings.parentBG,
                'text-align': 'center',
                'line-height': '140px',
                'font-size': 'x-large',
                'font-weight': '600'
            });

            $(this).find('.gauge-cap').text(value + "%");

            // Fill Gauge to match value

            $(this).find('.gauge-active-wrap').css({
                '-webkit-transform': 'rotate(' + (value * 1.8) + 'deg)',
                '-moz-transform': 'rotate(' + (value * 1.8) + 'deg)',
                '-ms-transform': 'rotate(' + (value * 1.8) + 'deg)',
                '-o-transform': 'rotate(' + (value * 1.8) + 'deg)',
                'transform': 'rotate(' + (value * 1.8) + 'deg)',
                'transition': 'transform 1000ms ease-in-out',
            });
        });

        return $(this);

    };
})(jQuery);

function updateGauge(element, value) {
    element.find('.gauge-cap').text(value + "%");
    element.find('.gauge-active-wrap').css({
        '-webkit-transform': 'rotate(' + (value * 1.8) + 'deg)',
        '-moz-transform': 'rotate(' + (value * 1.8) + 'deg)',
        '-ms-transform': 'rotate(' + (value * 1.8) + 'deg)',
        '-o-transform': 'rotate(' + (value * 1.8) + 'deg)',
        'transform': 'rotate(' + (value * 1.8) + 'deg)',
    });
}
(function (window, document, undefined) {
    "use strict";
    /*
     * Leaflet.AwesomeMarkers assumes that you have already included the Leaflet library and Leaflet.AwesomeMarkers too.
     */

    L.OxianaMarkers = {};

    L.OxianaMarkers.version = '0.0.1';

    L.OxianaMarkers.Icon = L.AwesomeMarkers.Icon.extend({
        _createInner: function() {
            var iconClass, iconSpinClass = "", iconColorClass = "", iconColorStyle = "", options = this.options;

	    if (options.number > 0) {
		return '<div style="font-size:12pt;color:white;font-family:Ubuntu,Tahoma,Helvetica Neue;padding-top:6px">' + options.number + '</div>';
	    }
	    if (null !== options.poi_type ) {
		return '<img style="padding-top:9px" src="' + '/static/glyphicons/glyphicons_288_scissors.png' + '">';
	    }

            if(options.icon.slice(0, options.prefix.length + 1) === options.prefix + "-") {
                iconClass = options.icon;
            } else {
                iconClass = options.prefix + "-" + options.icon;
            }

            if(options.spin && typeof options.spinClass === "string") {
                iconSpinClass = options.spinClass;
            }

            if(options.iconColor) {
                if(options.iconColor === 'white' || options.iconColor === 'black') {
                    iconColorClass = "icon-" + options.iconColor;
                } else {
                    iconColorStyle = "style='color: " + options.iconColor + "' ";
                }
            }
            return "<i " + iconColorStyle + "class='" + options.extraClasses + " " + options.prefix + " " + iconClass + " " + iconSpinClass + " " + iconColorClass + "'></i>";
        },

    });
        
    L.OxianaMarkers.icon = function (options) {
        return new L.OxianaMarkers.Icon(options);
    };

}(this, document));

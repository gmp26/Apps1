(angular.module 'app', ['ngResource', 'app.templates'])

	#
	# create svgXXX attributes for use in svg to avoid chrome errors
	# Chrome checks svg attribute syntax before angular gets a chance to interpolate {{values}}
	# So we insert svg-width="{{foo}}", and get this directive to convert it to width="fooval"
	#
	# At least, that's the theory. Interpolated values cause more trouble and need a
	# patch to the angular compiler itself.
	#
	# See https://github.com/angular/angular.js/issues/1050
	# and https://github.com/angular/angular.js/issues/1925
	#
.config () ->
	for name in ['width', 'height', 'x1', 'x2', 'y1', 'y2']
		svgName = 'svg' + name[0].toUpperCase() + name.slice(1)
		angular.module('app').directive svgName, () ->
			link: (scope, element, attrs) ->
				attrs.$observe ngName, (value) ->
					# NB watch can fail initially if attribute value is interpolated
					if(value)
						attrs.$set(name, value)
angular.module('app', ['ngResource', 'app.templates']).config () ->

	app = angular.module('app')
	#
	# create ngXXX attributes for use in svg to avoid chrome errors
	# Chrome checks svg attribute syntax before angular gets a chance to interpolate {{values}}
	# So we insert svg-width="{{foo}}", and get this directive to convert it to width="fooval"
	#
	# At least, that's the theory. See https://github.com/angular/angular.js/issues/1050
	#
	angular.forEach ['width', 'height', 'x1', 'x2', 'y1', 'y2'], (name) ->
		ngName = 'svg' + name[0].toUpperCase() + name.slice(1)
		console.log('adding ',ngName, " directive")
		app.directive ngName, () ->
			restrict: 'A'
			replace: false
			compile: (element, attrs, transclude) ->
				console.log('observing ', ngName)
				attrs.$observe ngName, (value) ->
					attrs.$set(name, value)
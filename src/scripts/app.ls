(angular.module 'app', ['ngResource', 'ui.bootstrap'])
.run ['$rootScope', '$log', ($rootScope, $log) ->

	# fire an event related to the current route
	$rootScope.$on '$routeChangeSuccess', (event, currentRoute, priorRoute) ->
		$rootScope.$broadcast "#{currentRoute.controller}$routeChangeSuccess", currentRoute, priorRoute

]

/*
	See https://github.com/angular/angular.js/issues/1050
	and https://github.com/angular/angular.js/issues/1925

	The code below is based on suggestions in 1050, but these
	still fail when the svg attributes contain interpolate values.

	So instead use gmp26 angular patch to Angular v1.0.4 documented
	in 1925. Hopefully the Chrome/Angular teams will sort this out.

.config () ->
	for name in ['width', 'height', 'x1', 'x2', 'y1', 'y2']
		svgName = 'svg' + name[0].toUpperCase() + name.slice(1)
		angular.module('app').directive svgName, () ->
			link: (scope, element, attrs) ->
				attrs.$observe ngName, (value) ->
					# NB watch can fail initially if attribute value is interpolated
					if(value)
						attrs.$set(name, value)
*/
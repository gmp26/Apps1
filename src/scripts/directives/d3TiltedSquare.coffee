#
# Tilted Square in d3 using svg.
#
# This directive supplies the square with its controls,
# and it needs to sit inside a d3DotGrid which is itself 
# inside a d3Vis.
#
angular.module('app').directive 'd3TiltedSquare', 
[
	'$timeout' 
	($timeout) ->
		restrict: 'A'
		link: (scope, element, attrs) ->
			1
]
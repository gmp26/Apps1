###
 	Tilted Square in d3 using svg.

	This directive supplies the square with its controls,
	and it needs to sit inside a d3DotGrid which is itself 
	inside a d3Vis.

	attributes
  	ax, ay define the initial position of the control point A.
  	bx, by define the initial position of the control point B.
    The square appears to the left of edge AB when facing B from A.
###
angular.module('app').directive 'd3TiltedSquare', 
[
	'$timeout' 
	($timeout) ->
		restrict: 'A'
		scope: {
			ax: '@'
			ay: '@'
			bx: '@'
			by:	'@'
		}
		link: (scope, element, attrs) ->

			scope.$watch 'ax', (val) ->
				scope.ax = ~~val || 2

			scope.$watch 'bx', (val) ->
				scope.bx = ~~val || 6

			scope.$watch 'ay', (val) ->
				scope.ay = ~~val || 9

			scope.$watch 'by', (val) ->
				scope.by = ~~val || 8

			# listen for dotGridUpdated events before redrawing
			scope.$on 'dotGridUpdated', (gridScope) ->

				console.log 'dotGridUpdated'
				console.log 'gridScope = ', gridScope.$id

]
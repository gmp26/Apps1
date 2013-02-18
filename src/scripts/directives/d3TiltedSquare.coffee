#
# Tilted Square in d3 using svg
#
angular.module('app').directive 'd3TiltedSquare', ['$timeout', ($timeout) ->


	directiveDef = {
		controller: 'd3TiltedController'
		scope:
			spacing: '@'	# pixels between grid points
			along: '@' 		# grid points along
			down: '@'		# grid points down
			radius: '@'		# radius of grid point
			color: '@'		# colour of grid point
			fill: '@'		# fill colour of square
			ax: '@'			# control point a start position
			ay: '@'
			bx: '@'			# control point b start position
			bx: '@'
	
		restrict: 'A'
		templateUrl: 'src/views/directives/d3TiltedSquare.html'
		#replace: true

		link: (scope, element, attrs) ->

			valid = true

			invalidate = ->
				console.log("invalidate: ", valid)
				if valid
					$timeout () ->
						valid = true
						redraw()
				valid = false

			redraw = ->
				scope.setDimensions()
				#drawGridDots()

			scope.$watch 'spacing', (val) ->
				console.log("scope-spacing = ", val)
				invalidate()

			invalidate()

			g = d3.select('svg').select(".space")

			$timeout () ->
				g.append("g")
				.attr("class", "x axis axisHelp")
				.attr("transform", "translate(0," + scope.height + ")")
				.call(scope.xAxis)

				g.append("g")
				.attr("class", "y axis axisHelp")
				.attr("transform", "translate(0,0)")
				.call(scope.yAxis)
			, 2

	}
	return directiveDef
]
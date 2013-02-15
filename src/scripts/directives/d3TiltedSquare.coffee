#
# Tilted Square in d3 using svg
#
angular.module('app').directive 'd3TiltedSquare', () ->

	directiveDef = {
		scope:
			along: '@' 		# grid points along
			down: '@'		# grid points down
			spacing: '@'	# pixels between grid points
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

			# default values ($observe to cope with any interpolation inside attributes)
			attrs.$observe 'along', (val) ->
				scope.along = ~~val || 10
				scope.setWidth()
			
			attrs.$observe 'down', (val) ->
				scope.down = ~~val || 10
				scope.setWidth()
				scope.setHeight()
			
			attrs.$observe 'spacing', (val) ->
				scope.spacing = ~~val || 50
				scope.setHeight()
			
			attrs.$observe 'radius', (val) ->
				scope.radius = ~~val || 5

			attrs.$observe 'color', (val) ->
				scope.color = val || '#a04'

			attrs.$observe 'fill', (val) ->
				scope.fill = val || '#c66'

			attrs.$observe 'ax', (val) ->
				scope.ax = ~~val || 2

			attrs.$observe 'bx', (val) ->
				scope.bx = ~~val || 6

			attrs.$observe 'ay', (val) ->
				scope.ay = ~~val || 9

			attrs.$observe 'by', (val) ->
				scope.by = ~~val || 8

			attrs.$observe 'tiltedSquare', (val) ->
				scope.tiltedSquare = val

			console.log('d3 active')

			#scope.height = scope.down * scope.spacing

			g = d3.select('svg').select(".space")

			g.append("g")
			.attr("class", "x axis axisHelp")
			.attr("transform", "translate(0," + scope.height + ")")
			.call(scope.xAxis)

			g.append("g")
			.attr("class", "y axis axisHelp")
			.attr("transform", "translate("+scope.width+",0)")
			.call(scope.yAxis)


	}
	return directiveDef
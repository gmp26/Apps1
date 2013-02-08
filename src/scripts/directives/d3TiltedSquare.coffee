#
# Tilted Square in d3 using svg
#
angular.module('app').directive 'd3TiltedSquare', ()->

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
		#templateUrl: 'src/views/directives/d3tiltedSquare.html'
		#replace: true

		link: (scope, element, attrs) ->

			# default values ($observe to cope with any interpolation inside attributes)
			attrs.$observe 'along', (val) ->
				scope.along = ~~val || 10
			
			attrs.$observe 'down', (val) ->
				scope.down = ~~val || 10
			
			attrs.$observe 'spacing', (val) ->
				scope.spacing = ~~val || 50
			
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

			margin =
				top: 20
				right: 20
				bottom: 20
				left: 20

			padding =
	    	top: 60
	    	right: 60
	    	bottom: 60
	    	left: 60

			outerWidth = 768
			outerHeight = 1024
			innerWidth = outerWidth - margin.left - margin.right
			innerHeight = outerHeight - margin.top - margin.bottom
			width = innerWidth - padding.left - padding.right
			height = innerHeight - padding.top - padding.bottom

			x = d3.scale.identity()
			.domain([0, width])

			y = d3.scale.identity()
			.domain([0, height])

			xAxis = d3.svg.axis()
    	.scale(x)
    	.orient("bottom")

			yAxis = d3.svg.axis()
    	.scale(y)
    	.orient("right")

			svg = d3.select("body").append("svg")
    	.attr("width", outerWidth)
    	.attr("height", outerHeight)
  		.append("g")
    	.attr("transform", "translate(" + margin.left + "," + margin.top + ")")

			defs = svg.append("defs")

			defs.append("marker")
	    .attr("id", "triangle-start")
	    .attr("viewBox", "0 0 10 10")
	    .attr("refX", 10)
	    .attr("refY", 5)
	    .attr("markerWidth", -6)
	    .attr("markerHeight", 6)
	    .attr("orient", "auto")
	  	.append("path")
	    .attr("d", "M 0 0 L 10 5 L 0 10 z")

			defs.append("marker")
	    .attr("id", "triangle-end")
	    .attr("viewBox", "0 0 10 10")
	    .attr("refX", 10)
	    .attr("refY", 5)
	    .attr("markerWidth", 6)
	    .attr("markerHeight", 6)
	    .attr("orient", "auto")
	  	.append("path")
	    .attr("d", "M 0 0 L 10 5 L 0 10 z")

			svg.append("rect")
	    .attr("class", "outer")
	    .attr("width", innerWidth)
	    .attr("height", innerHeight)

			g = svg.append("g")
	    .attr("transform", "translate(" + padding.left + "," + padding.top + ")")

			g.append("rect")
	    .attr("class", "inner")
	    .attr("width", width)
	    .attr("height", height)

			g.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(xAxis)

			g.append("g")
	    .attr("class", "y axis")
	    .attr("transform", "translate(" + width + ",0)")
	    .call(yAxis)

			svg.append("line")
	    .attr("class", "arrow")
	    .attr("x2", padding.left)
	    .attr("y2", padding.top)
	    .attr("marker-end", "url(#triangle-end)")

			svg.append("line")
	    .attr("class", "arrow")
	    .attr("x1", innerWidth / 2)
	    .attr("x2", innerWidth / 2)
	    .attr("y2", padding.top)
	    .attr("marker-end", "url(#triangle-end)")

			svg.append("line")
	    .attr("class", "arrow")
	    .attr("x1", innerWidth / 2)
	    .attr("x2", innerWidth / 2)
	    .attr("y1", innerHeight - padding.bottom)
	    .attr("y2", innerHeight)
	    .attr("marker-start", "url(#triangle-start)")

			svg.append("line")
	    .attr("class", "arrow")
	    .attr("x2", padding.left)
	    .attr("y1", innerHeight / 2)
	    .attr("y2", innerHeight / 2)
	    .attr("marker-end", "url(#triangle-end)")

			svg.append("line")
	    .attr("class", "arrow")
	    .attr("x1", innerWidth)
	    .attr("x2", innerWidth - padding.right)
	    .attr("y1", innerHeight / 2)
	    .attr("y2", innerHeight / 2)
	    .attr("marker-end", "url(#triangle-end)")

			svg.append("text")
	    .text("origin")
	    .attr("y", -8)

			svg.append("circle")
	    .attr("class", "origin")
	    .attr("r", 4.5)

			g.append("text")
	    .text("translate(margin.left, margin.top)")
	    .attr("y", -8)

	}
	return directiveDef
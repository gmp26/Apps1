###
 	Tilted Square in d3 using svg.

	This directive supplies the square with its controls,
	and it needs to sit inside a d3DotGrid which is itself
	inside a d3Vis.

	attributes:
  	ax, ay define the initial position of the control point A.
  	bx, by define the initial position of the control point B.
    The square appears to the left of edge AB when facing B from A.
    radius defines the radius of the control circles.

  styles:
  	see AppTiltedSquares.less

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
			radius: '@'
		}
		link: (scope, element, attrs) ->

			# The corners of the square
			scope.a = {}
			scope.b = {}
			scope.c = {}
			scope.d = {}

			scope.$watch 'ax', (val) ->
				scope.a.x = ~~val || 2

			scope.$watch 'bx', (val) ->
				scope.b.x = ~~val || 6

			scope.$watch 'ay', (val) ->
				scope.a.y = ~~val || 9

			scope.$watch 'by', (val) ->
				scope.b.y = ~~val || 8

			scope.$watch 'radius', (val) ->
				scope.radius = ~~val || 22

			scope.squareDots = () ->
				dx = @b.x - @a.x
				dy = @b.y - @a.y
				@c = {x: @b.x + dy, y:@b.y - dx}
				@d = {x: @c.x - dx, y:@c.y - dy}
				console.log "square = ", [@a, @b, @c, @d]
				return [@a, @b, @c, @d]

			# listen for dotGrid events before redrawing
			scope.$on 'dotGridUpdated', (event, gridScope) ->

				console.log 'dotGridUpdated', gridScope
				console.log 'gridScope = ', gridScope.$id

				squareOutline = d3.svg.line()
				.x((d) -> gridScope.X(d.x))
				.y((d) -> gridScope.Y(d.y))

				corners = [scope.squareDots()]

				# create square
				square = gridScope.container.selectAll("#square"+scope.$id)
				square
				.data(corners)
				.enter().append("path")
				.attr("id", "square"+scope.$id)
				.attr("class", "tilted")
				.attr("d", (d) -> squareOutline(d) + "Z")

				# create controls
				controls = gridScope.container.selectAll(".control")
				controls
				.data(scope.squareDots().slice(0,2))
				.enter().append("circle")
				.attr("class", (d,i) -> "control tilted-control"+i)
				.attr("r", scope.radius)
				.attr("cx", (d) -> gridScope.X(d.x))
				.attr("cy", (d) -> gridScope.Y(d.y))
				###
				.call(
					d3.behavior.drag()
				  .on "dragstart", (d) ->
				  	@__origin__ = [gridScope.X(d.x), gridScope.Y(d.y)])
				  .on "drag", (d) ->
						d.x = Math.min(w, Math.max(0, @__origin__[0] += d3.event.dx));
						d.y = Math.min(h, Math.max(0, @__origin__[1] += d3.event.dy));
						update()
						gridScope.container.selectAll(".control")
						.attr("cx", x)
						.attr("cy", y);
					.on "dragend", -> delete @__origin__
				###

				#update position of square
				square
				.attr("d", (d) -> squareOutline(d) + "Z")

				#and its controls
				controls
				.attr("cx", (d) -> gridScope.X(d.x))
				.attr("cy", (d) -> gridScope.Y(d.y))

]
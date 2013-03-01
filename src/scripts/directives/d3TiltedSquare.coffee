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

				dragMove = (d) ->
					console.log("dragging")
					_control = d3.select(@)
						.attr("cx", d.x = Math.max(scope.radius, Math.min(gridScope.width - scope.radius, d3.event.x)))
						.attr("cy", d.y = Math.max(scope.radius, Math.min(gridScope.height - scope.radius, d3.event.y)))

					if _control.classed("tilted-control0")
						scope.a = {x: gridScope.COL(d.x), y: gridScope.ROW(d.y)}
						console.log "A = ", scope.a
					if _control.classed("tilted-control1")
						scope.b = {x: gridScope.COL(d.x), y: gridScope.ROW(d.y)}
						console.log "B = ", scope.b

					scope.update()

				drag = d3.behavior.drag()
					.origin((d) ->
						origin = { x: gridScope.X(d.x), y: gridScope.Y(d.y)	}
						console.log("origin=", origin)
						return origin
					)
					.on("dragstart", (d) ->
						console.log("dragstart")
					)
					.on("drag", dragMove)
					.on("dragend", ->
						console.log("dragend")
					)
				
				corners = [scope.squareDots()]

				# create square
				scope.square = gridScope.container.selectAll("#square"+scope.$id)
				scope.square
				.data(corners)
				.enter().append("path")
				.attr("id", "square"+scope.$id)
				.attr("class", "tilted")
				.attr("d", (d) -> squareOutline(d) + "Z")

				# create controls
				scope.controls = gridScope.container.selectAll(".control")
				scope.controls
				.data(scope.squareDots().slice(0,2))
				.enter().append("circle")
				.attr("class", (d,i) -> "tilted-control"+i)
				.classed("control", true)
				.attr("r", scope.radius)
				.attr("cx", (d) -> gridScope.X(d.x))
				.attr("cy", (d) -> gridScope.Y(d.y))
				
				.call(drag)

				#update position of square
				scope.update = ->
					gridScope.container.selectAll("#square"+scope.$id)
					.data([scope.squareDots()])
					.attr("d", (d) -> squareOutline(d) + "Z")

					#and its controls
				scope.updateControls = ->
					gridScope.container.selectAll(".control")
					.attr("cx", (d) -> gridScope.X(d.x))
					.attr("cy", (d) -> gridScope.Y(d.y))

				scope.update()
				scope.updateControls()

]
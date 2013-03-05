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

				# setup control dragging behaviour
				drag = d3.behavior.drag()
					.origin((d) ->
						origin = { x: gridScope.X(d.x), y: gridScope.Y(d.y)	}
						return origin
					)
					.on("drag", (d) ->
						_control = d3.select(@)
							.attr("cx", _x = Math.max(0, Math.min(gridScope.width, d3.event.x)))
							.attr("cy", _y = Math.max(0, Math.min(gridScope.height, d3.event.y)))

						if _control.classed("tilted-control0")
							scope.a = {x: gridScope.COL(_x), y: gridScope.ROW(_y)}
						if _control.classed("tilted-control1")
							scope.b = {x: gridScope.COL(_x), y: gridScope.ROW(_y)}

						scope.update()
					)
					.on("dragend", ->
						scope.a.x = Math.round(scope.a.x)
						scope.a.y = Math.round(scope.a.y)
						scope.b.x = Math.round(scope.b.x)
						scope.b.y = Math.round(scope.b.y)
						scope.update()
					)
				
				scope.createSquaresLayer = ->
					# create if necessary
					scope.squaresLayer = gridScope.container.selectAll("#tiltedSquares")
					.data([gridScope])

					scope.squaresLayer
					.enter().append("g")
					.attr("id", "tiltedSquares")

				scope.createControlsLayer = ->
					# create controls if necessary
					scope.controlsLayer = gridScope.container.selectAll("#tiltedControls")
					.data([gridScope])

					scope.controlsLayer
					.enter().append("g")
					.attr("id", "tiltedControls")

				scope.createControls = ->
					scope.controls = scope.controlsLayer.selectAll(".control"+scope.$id)
					scope.controls
					.data(scope.squareDots().slice(0,2))
					.enter().append("circle")
					.attr("class", (d,i) -> "tilted-control"+i)
					.classed("control"+scope.$id, true)
					.attr("r", scope.radius)
					.attr("cx", (d) -> gridScope.X(d.x))
					.attr("cy", (d) -> gridScope.Y(d.y))
					.call(drag)

				scope.update = ->
					#update position of square
					scope.squaresLayer.selectAll("#square"+scope.$id)
					.data([scope.squareDots()])
					.attr("d", (d) -> squareOutline(d) + "Z")

					#and its controls
					scope.controlsLayer.selectAll(".control"+scope.$id)
					.data(scope.squareDots().slice(0,2))
					.attr("cx", (d) -> gridScope.X(d.x))
					.attr("cy", (d) -> gridScope.Y(d.y))


				# create squares and controls layers 
				# these are to ensure controls are always above squares
				scope.createSquaresLayer()
				scope.createControlsLayer()

				# create square if necessary
				scope.square = scope.squaresLayer.selectAll("#square"+scope.$id)
				scope.square
				.data([scope.squareDots()])
				.enter().append("path")
				.attr("id", "square"+scope.$id)
				.attr("class", "tilted")
				.attr("d", (d) -> squareOutline(d) + "Z")
				scope.createControls()

				# update all if necessary
				scope.update()
]
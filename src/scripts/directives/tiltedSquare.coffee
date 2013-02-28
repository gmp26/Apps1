# tilted square directive
#
angular.module('app').directive 'tiltedSquare', ['$timeout', ($timeout) ->


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
			by: '@'

		restrict: 'A'
		templateUrl: 'src/views/directives/tiltedSquare.html'
		replace: true

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

			# transforms for top/left page position to/from dot row/col
			TOP = (row) -> Math.round((row+0.5)*scope.spacing - scope.radius/2)
			LEFT = (col) -> Math.round((col+0.5)*scope.spacing - scope.radius/2)
			ROW = (top) -> Math.max(0, Math.min(scope.down - 1, Math.round((top + scope.radius/2)/scope.spacing - 0.5)))
			COL = (left) -> Math.max(0, Math.min(scope.along - 1, Math.round((left + scope.radius/2)/scope.spacing - 0.5)))

			# generic make dot
			makeDot = (col, row, options) ->
				options.col = col
				options.row = row
				options.left = LEFT(col)
				options.top = TOP(row)
				new fabric.Circle (options)

			# make a background grid dot
			makeGridDots = () ->
				dots = []
				for row in [0..scope.down-1] by 1
					for col in [0..scope.along-1] by 1
						dot = makeDot col, row, {
							debug: false
							selectable: false
							radius: scope.radius
							fill: scope.color
						}
						dots.push(dot)
				return dots
		
			squareDots = () ->
				a = scope.fixedDot
				b = scope.activeDot
				throw new Error('control dots outside canvas') unless (
					0 <= a.col < scope.along &&
					0 <= a.row < scope.down &&
					0 <= b.col < scope.along &&
					0 <= b.row < scope.down
				)
				dx = b.col - a.col
				dy = b.row - a.row
				c = {col: b.col + dy, row:b.row - dx}
				d = {col: c.col - dx, row:c.row - dy}
				return [a, b, c, d]

			#
			# make a filled tilted square given a set of dots with rows and cols
			#
			makeSquare = (dots) ->
				points = (new fabric.Point LEFT(dot.col), TOP(dot.row) \
					for dot in dots)
				return new fabric.Polygon(points, {
					fill: scope.fill
					opacity:0.5
					selectable: false
				})

			draw = () ->

				return if scope.canvas?

				# attach fabric display tree to the canvas
				# the tiltedSquare attribute gets interpolated into the canvas id in templateURL
				scope.canvas = new fabric.Canvas attrs.tiltedSquare

				# prevent default screen touch action
				angular.element()
					.find('body')
					.bind 'touchmove', (event) -> event.preventDefault()
					.bind 'scroll', (event) ->
						console.log "scrolled"

				# we don't want group selection on this canvas
				scope.canvas.selection = false

				# not sure we will ever need to change these at run time, so watch is probably unnecessary
				# we are already running one clock cycle after post link $digest has happened
				scope.$watch 'down', (newVal) ->
					scope.canvas.setHeight (scope.spacing * newVal) if newVal > 0

				scope.$watch 'along', (newVal) ->
					scope.canvas.setWidth (scope.spacing * newVal) if newVal > 0

				# make the control discs
				scope.fixedDot = makeDot scope.ax, scope.ay, {
					selectable: true
					radius: 25,
					fill: '#048'
					opacity: 0.5
					hasControls: false
					hasBorders: false
				}

				scope.activeDot = makeDot scope.bx, scope.by, {
					selectable: true
					radius: 25,
					fill: '#f00'
					opacity: 0.5
					hasControls: false
					hasBorders: false
				}

				# add everything to the canvas
				scope.dots = makeGridDots()
				scope.canvas.add dot for dot in scope.dots
				scope.square = makeSquare(squareDots())
				scope.canvas.add scope.square
				scope.canvas.add scope.fixedDot
				scope.canvas.add scope.activeDot

				scope.canvas.on 'object:moved', (event) ->
					scope.canvas.calcOffset()

				# add control disc drag behaviour
				scope.canvas.on 'object:moving', (event) ->
					dot = event.target
					if dot == scope.activeDot || dot == scope.fixedDot
						left = LEFT(dot.col = COL(dot.left))
						top = TOP(dot.row = ROW(dot.top))
						dot.setLeft(left)
						dot.setTop(top)
						squareDots().forEach (d, index) ->
							p = scope.square.points[index]
							p.x = LEFT(d.col)
							p.y = TOP(d.row)
						scope.canvas.renderAll()


			# draw one cycle after current $digest
			$timeout draw, 0

	}
]

# tilted square directive
#
angular.module('app').directive 'tiltedSquare', ['$timeout', ($timeout) ->


	directiveDef = {
		scope:
			along: '@'
			down: '@'
			spacing: '@'
			radius: '@'
			color: '@'
			fill: '@'
			ax: '@'
			ay: '@'
			bx: '@'
			bx: '@'

		restrict: 'A'
		templateUrl: '/views/directives/tiltedSquare.html'
		replace: true

		link: (scope, element, attrs) ->

			# default values
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

			# top/left page position to/from dot row/col
			TOP = (row) -> Math.round((row+0.5)*scope.spacing - scope.radius/2)
			LEFT = (col) -> Math.round((col+0.5)*scope.spacing - scope.radius/2)
			ROW = (top) -> Math.max(0, Math.min(scope.down - 1, Math.round((top + scope.radius/2)/scope.spacing - 0.5)))
			COL = (left) -> Math.max(0, Math.min(scope.along - 1, Math.round((left + scope.radius/2)/scope.spacing - 0.5)))

			makeDot = (col, row, options) ->
				if options.debug
					console.log('makeDot: ', col, row)
				options.col = col
				options.row = row
				options.left = LEFT(col)
				options.top = TOP(row)
				new fabric.Circle (options)

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
		
			# attach fabric to the canvas
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

				scope.canvas = new fabric.Canvas attrs.tiltedSquare

				scope.$watch 'down', (newVal) ->
					scope.canvas.setHeight (scope.spacing * newVal) if newVal > 0

				scope.$watch 'along', (newVal) ->
					scope.canvas.setWidth (scope.spacing * newVal) if newVal > 0

				scope.fixedDot = makeDot scope.ax, scope.ay, {
					debug: true
					selectable: true
					radius: 25,
					fill: '#048'
					opacity: 0.5
					hasControls: false
					hasBorders: false
				}

				scope.activeDot = makeDot scope.bx, scope.by, {
					debug:true
					selectable: true
					radius: 25,
					fill: '#f00'
					opacity: 0.5
					hasControls: false
					hasBorders: false
				}

				scope.dots = makeGridDots()
				scope.canvas.add dot for dot in scope.dots

				scope.square = makeSquare(squareDots())

				scope.canvas.add scope.square
				scope.canvas.add scope.fixedDot
				scope.canvas.add scope.activeDot

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

			# kick things off after current $digest
			$timeout draw, 0
	}
]

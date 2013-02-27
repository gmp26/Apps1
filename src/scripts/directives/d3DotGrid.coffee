angular.module('app').directive 'd3DotGrid',
[
	'$timeout'
	($timeout) ->

		data = {}

		return {
			restrict: 'A'
			replace: true
			template: '<span></span>'

			link: (scope, element, attrs) ->

				scope.$on 'draw', (event, container, width, height) ->
					scope.setSpacing(container, width, height)
					draw()

				scope.$on 'resize', (event, container, width, height) ->
					scope.setSpacing(container, width, height)
					draw()
					console.log "update"
					update()


				draw = ->

					# Warning: not for livescript. We want coffescript's array nesting here.
					data = ({x:c, y:r} for r in [0..scope.rows-1] for c in [0..scope.cols-1])

					col = (colData) ->
						circles = d3.select(this).selectAll("circle")
						.data(colData)

						circles.enter().append("circle")
						.data((d, i, j)->d)
						.attr("r", scope.radius)
						.attr("class", "origin")
						.attr("cx", (d)->x(d.x))
						.attr("cy", (d)->y(d.y))

						circles.exit().remove()

					columns = scope.container.selectAll("g")
					.data(data)

					columns.enter().append("g")
					.each(col)

					columns.exit().remove()

				# update
				update = ->
					scope.container.selectAll("g circle").each(updateGrid) 

				updateGrid = (data) ->
					d3.select(this)
					.attr("cx", (d) -> x(d.x))
					.attr("cy", (d) -> y(d.y))

				x = (col) -> (col)*scope._hspace
				y = (row) -> (row)*scope._vspace

				scope.setSpacing = (container, width, height) ->
					@container = container
					@width = width
					@height = height
					
					@rows = @down
					@cols = @along
					@_vspace = @vspace
					@_hspace = @hspace

					if @vspace == "auto"
						@_vspace = @height / (@rows - 1)
						@rows = Math.floor(@height/@_vspace + 1)

					if @hspace == "auto"
						@_hspace = @width / (@cols - 1)
						@cols = Math.floor(@width/@_hspace + 1)

					if !isNaN(@minspace)
						@_vspace = Math.max(@_vspace, @minspace)
						@_hspace = Math.max(@_hspace, @minspace)

					if @square
						space = Math.min(@_vspace, @_hspace)
						@_vspace = @_hspace = space
					

				attrs.$observe 'along', (val) ->
					scope.along = if val? then ~~val else 10
					console.log "along = ", scope.along

				attrs.$observe 'down', (val) ->
					scope.down = if val? then ~~val else 10
					console.log "down = ", scope.down

				attrs.$observe 'hspace', (val) ->
					scope.hspace = if val=="auto" then "auto" else if val? then ~~val else 10
					console.log "hspace = ", scope.hspace

				attrs.$observe 'vspace', (val) ->
					scope.vspace = if val=="auto" then "auto" else if val? then ~~val else 10
					console.log "vspace = ", scope.vspace

				attrs.$observe 'radius', (r) ->
					scope.radius = if r? then ~~r else 3

				attrs.$observe 'square', (val) ->
					scope.square = val? and val != "false"
		}
]
angular.module('app').directive 'd3DotGrid', ->

	data = {}

	return {
		restrict: 'A'

		link: (scope, element, attrs) ->

			# 
			# The parent container (e.g. d3Vis) issues draw
			# and resize events
			#
			scope.$on 'draw', (event, container, width, height) ->
				scope.draw(container, width, height)

			scope.$on 'resize', (event, container, width, height) ->
				scope.draw(container, width, height)

			scope.draw = (container, width, height) ->

				#set spacing
				@container = container
				@width = width
				@height = height
				
				@rows = @down
				@cols = @along
				@_vspace = @vspace
				@_hspace = @hspace

				if @vspace == "auto"
					@_vspace = height / (@rows - 1)
					if !isNaN(@minspace) and @_vspace < @minspace
						@_vspace = @minspace
					@rows = Math.floor(height/@_vspace + 1)

				if @hspace == "auto"
					@_hspace = width / (@cols - 1)
					if !isNaN(@minspace) and @_hspace < @minspace
						@_hspace = @minspace
					@cols = Math.floor(width/@_hspace + 1)
				
				if @square
					space = Math.min(@_vspace, @_hspace)
					@_vspace = @_hspace = space

				X = (col) -> (col)*scope._hspace
				Y = (row) -> (row)*scope._vspace

				console.log "rows=", @rows, "cols=", @cols

				# Warning: not for livescript. We want coffescript's array nesting here.
				data = ({x:c, y:r} for r in [0..scope.rows-1] for c in [0..scope.cols-1])

				#
				# d3 magic starts here
				#
				columns = scope.container.selectAll("g")
				.data(data)

				columns.enter().append("g")

				columns.exit().remove()

				circles = columns.selectAll("circle")
				.data((d)->d)
				.each ->
					d3.select(this)
					.attr("cx", (d)->X(d.x))
					.attr("cy", (d)->Y(d.y))

				circles.enter().append("circle")
					.data((d)->d)
					.attr("r", scope.radius)
					.attr("class", "grid-dot")
					.attr("cx", (d)->X(d.x))
					.attr("cy", (d)->Y(d.y))
				circles .exit().remove()

				# tell any child directives that the grid has been redrawn
				scope.$broadcast('dotGridUpdated')

			#
			# attributes must be observed in case they are interpolated
			#
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

			attrs.$observe 'minspace', (val) ->
				scope.minspace = if val=="auto" then "auto" else if val? then ~~val else 10
				console.log "minspace = ", scope.minspace

			attrs.$observe 'radius', (r) ->
				scope.radius = if r? then ~~r else 3

			attrs.$observe 'square', (val) ->
				scope.square = val? and val != "false"
	}
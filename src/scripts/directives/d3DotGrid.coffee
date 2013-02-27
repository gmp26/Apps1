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
				console.log('dot-grid')

				scope.$on 'draw', (event, container, width, height) ->
					#event.stopPropagation()
					console.log "drawing"
					scope.setSpacing(container, width, height)
					#scope.data = [{x:0,y:0},{x:20,y:20},{x:40,y:40}]
					draw()

				scope.$on 'resize', (event, container, width, height) ->
					console.log "redrawing"
					scope.setSpacing(container, width, height)
					draw()

				draw = ->

					data = ({
						x:col*scope._hspace
						y:row*scope._vspace
					} for row in [0..scope.rows-1] for col in [0..scope.cols-1])

					columns = scope.container.selectAll("g")
					.data(data)
					.enter().append("g")
					
					circles = columns.selectAll("circle")
					.data((d) -> d)

					circles.enter().append("circle")
					.attr("r", scope.radius)
					.attr("class", "origin")
					.attr("cx", (d)->d.x)
					.attr("cy", (d)->d.y)

					circles.exit().remove()

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

					#console.log @_hspace, @width, @cols
					#console.log scope.data

				###
				draw = ->
					[0..scope.down-1].forEach (row) -> drawRow(row)

				drawRow = (row) ->
					[0..scope.along-1].forEach (col) ->
						scope.container.append("circle")
						.attr("r", scope.radius)
						.attr("class", "origin")
						.attr("transform", "translate(" + col*scope.hspace + "," + row*scope.vspace + ")")

				scope.$on 'resize', (event, container, width, height) ->
					console.log "drawing"
					scope.setSpacing(container, width, height)
					resize()


				resize = ->
					[0..scope.down-1].forEach (row) -> resizeRow(row)

				resizeRow = ->
					[0..scope.along-1].forEach (col) ->
						circle
				###

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
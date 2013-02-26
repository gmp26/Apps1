angular.module('app').directive 'd3DotGrid',
[
	'$timeout'
	($timeout) ->
		controller: 'd3VisController'
		priority: 1
		restrict: 'A'

		link: (scope, element, attrs) ->
			console.log('dot-grid')

			scope.$on 'draw', (event, g) ->
				event.stopPropagation()
				draw(g) if g?

			draw = (g) ->
				g.append("circle")
				.attr("r", 45)
				.attr("class", "origin")

				attrs.$observe 'along', ->
					console.log "along = ", attrs.along

				attrs.$observe 'down', ->
					console.log "down = ", attrs.down

]
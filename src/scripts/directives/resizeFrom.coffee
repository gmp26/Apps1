angular.module('app').directive 'resizeFrom', [
	'$window'
	'$timeout'
	($window, $timeout) ->
		link: (scope, element, attr) ->

			win = angular.element($window)

			# default pixelwidth is window innerwidth if it's defined, else 100
			scope.pixelWidth = $window.innerWidth ? 100
			console.log "pixelWidth = ", scope.pixelWidth

			scope.$watch attr.resizeFrom,(val) ->
				console.log("val =", val)
				w = ~~val
				if !isNaN(w)
					scope.pixelWidth = Math.max(100, w)

			  console.log "pixelWidth = ", scope.pixelWidth
			  resize()


			zoom = 1

			resize = ->
				#console.log("zoom = ", zoom)
				#ow = element[0].offsetWidth * zoom
				#zoom = ow / scope.pixelWidth

				zoom = 1 if zoom <= 0

				zoom *= (element[0].offsetWidth / scope.pixelWidth)

				element.css("zoom", zoom)

			win.bind "resize", resize

			$timeout resize, 0
]

angular.module('app').directive 'resizeFrom', [
	'$window'
	'$timeout'
	($window, $timeout) ->
		link: (scope, element, attr) ->

			win = angular.element($window)

			# this becomes a model where children can write 
			# to change their container requirements - like width
			scope.container ?= {}

			# default requiredWidth is window innerwidth if it's defined,
			# else it's 300
			scope.container.width = $window.innerWidth ? 300
			console.log "container.width = ", scope.container.width

			scope.$watch attr.resizeFrom,(val) ->
				console.log("val =", val)
				w = ~~val
				if !isNaN(w)
					scope.container.width = Math.max(100, w)

			  console.log "container.width = ", scope.container.width
			  resize()

			rescale = (winSize) ->
				zoom = winSize/scope.container.width
				#console.log "zoom=", zoom
				element.css("zoom", zoom)

			resizeHandler = ->
				#console.log "innerWidth =", $window.innerWidth
				rescale($window.innerWidth)

			scope.$watch 'container.width', ->
				#console.log("pads =", val.length)
				rescale($window.innerWidth)
				
			#console.log("scope=",scope.$id)
			#console.log("window=", $window)

			win = angular.element($window)
			win.bind "resize", resizeHandler


]

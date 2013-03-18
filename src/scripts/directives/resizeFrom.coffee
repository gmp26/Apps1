angular.module('app').directive 'resizeFrom', [
	'$window'
	($window) ->
		link: (scope, element, attr) ->

			###
			#
			# Almost working but behaves strangely around iPad - desktop transition
			#
			###
			win = angular.element($window)

			# this becomes a model where children can write
			# to change their container width requirement
			scope.container ?= {}

			# default requiredWidth is a proportion of window innerwidth if it's defined,
			# else it's 300
			scope.container.width = 3*($window.innerWidth ? 400)/4
			console.log "container.width = ", scope.container.width

			woff = 20
			attr.$observe 'woff', (val) ->
				woff = ~~val
				woff = 20 if woff == 0 or isNaN(woff)

			scope.$watch attr.resizeFrom,(val) ->
				console.log("resizeFrom = ", val)
				w = ~~val
				if !isNaN(w)
					scope.container.width = Math.max(300, w)
				element.css "width", w+"px"
				rescale($window.innerWidth)

			rescale = (winSize) ->
				zoom = (winSize - woff)/scope.container.width
				console.log "winsize-woff/container=zoom", (winSize - woff), "/", scope.container.width, "=", zoom
				element.css("zoom", zoom)

			resizeHandler = ->
				scope.$apply ->
				  console.log "resize $window.innerWidth = ", $window.innerWidth
					rescale($window.innerWidth)

			scope.$watch 'container.width', (val) ->
				console.log("container.width =", val)
				element.css "width", val+"px"
				rescale($window.innerWidth)
				
			#console.log("scope=",scope.$id)
			#console.log("window=", $window)

			win.bind "resize", resizeHandler

]

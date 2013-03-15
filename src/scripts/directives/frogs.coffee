angular.module('app').directive 'frogs', [
	'$window'
	($window) ->
		template: '<frog ng-repeat="f in frogs" frog-index="{{$index}}" f="f"></frog>'
		replace: false
		link: (scope,element,attrs) ->

			console.log "woff=", ~~attrs.woff

			rescale = (winSize, padCount) ->
				zoom = (winSize - ~~attrs.woff)/(110*padCount)
				#console.log "zoom=", zoom
				element.css("zoom", Math.min(1, zoom))

			resizeHandler = (event) ->
				#console.log "innerWidth =", $window.innerWidth
				rescale($window.innerWidth, scope.padIndexes.length)

			scope.$watch 'padIndexes', (val) ->
				#console.log("pads =", val.length)
				rescale($window.innerWidth, val.length)
				
			console.log("scope=",scope.$id)
			console.log("window=", $window)

			win = angular.element($window)
			win.bind "resize", resizeHandler

]


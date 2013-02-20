#
# d3 visualisation wrapper
#
(angular.module('app')
.controller 'd3VisController', ['$scope', ($scope) ->
	#console.log "controller scope is ", $scope.$id

	$scope.defaultWidth  = 550
	$scope.defaultHeight = 400
	$scope.ready = false

])
.directive 'd3Vis', ['$timeout', ($timeout) ->

	return {
		restrict: 'A'
		transclude: false
		replace: true
		controller: 'd3VisController'

		scope: {
			width: '@'
			height: '@'
			margin: '@'
			padding: '@'
			responsive: '@'
			visible: '@'
		}

		link: (scope, element, attrs) ->
			#console.log("directive scope is ", scope.$id)
			#console.log("element ", element[0].localName)

			# define handler for different window widths
			resizeHandler = (event) =>
				scope.setWindowWidth event.target.innerWidth

			scope.svgResize = (svg, w, h) ->
				svg.attr 'width', w
				svg.attr 'height', h
				console.log "svg(", w, h, ")"

			scope.setWindowWidth = (ww) ->
				@outerWidth = @width
				if(@outerWidth <= ww)
					@outerHeight = @height
				else
					@outerHeight = Math.round(@height * ww / @width)
					@outerWidth = ww

			scope.$watch 'width', (val) ->
				scope.width = if val? then ~~val else scope.defaultWidth
				console.log 'new width=', scope.width

			scope.$watch 'height', (val) ->
				scope.height = if val? then ~~val else scope.defaultHeight
				console.log 'new height=', scope.height

			scope.$watch 'responsive', (val) ->
				win = angular.element(window)
				if(val? && win?)
					console.log 'responsive'
					win.bind "resize", resizeHandler
				else
					win.unbind "resize", resizeHandler

			#
			# wait a tick to ensure scope watches have fired.
			#
			$timeout =>
				svg = d3.select(element[0]).append("svg")
				scope.setWindowWidth angular.element(window).innerWidth()
				scope.svgResize(svg, scope.outerWidth, scope.outerHeight)

	}
]




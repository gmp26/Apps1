#
# d3 visualisation wrapper
#
(angular.module('app')
.controller 'd3VisController', ['$scope', ($scope) ->
	#console.log "controller scope is ", $scope.$id

	$scope.defaultWidth  = 550
	$scope.defaultHeight = 400
	$scope.defaultWoff = 41

	$scope.ready = false

	#console.log $scope.$id
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
			woff: '@' #width offset to allow for inherited margins & borders
			padding: '@'
			responsive: '@'
			visible: '@'
		}

		link: (scope, element, attrs) ->
			#console.log("directive scope is ", scope.$id)
			#console.log("element ", element[0].localName)

			# define handler for different window widths
			resizeHandler = (event) =>
				#console.log "resizing"
				scope.setWindowWidth event.target.innerWidth

			scope.svgResize = ->
				@svg.attr 'width', @outerWidth + 1
				@svg.attr 'height', @outerHeight + 1
				#console.log "svg(", @outerWidth, @outerHeight, ")"

				g = @svg.select("g > rect")
				.attr("class", "outer")
				.attr("width", scope.outerWidth)
				.attr("height", scope.outerHeight)

			scope.setWindowWidth = (ww) ->
				w = ww - @woff
				@outerWidth = @width
				if(@outerWidth <= w)
					@outerHeight = @height
				else
					@outerHeight = Math.round(@height * w / @width)
					@outerWidth = w
				@svgResize()

				#console.log "ow,oh=", @outerWidth, @outerHeight

			scope.$watch 'width', (val) ->
				scope.width = if val? then ~~val else scope.defaultWidth
				#console.log 'new width=', scope.width

			scope.$watch 'height', (val) ->
				scope.height = if val? then ~~val else scope.defaultHeight
				#console.log 'new height=', scope.height

			scope.$watch 'woff', (val) ->
				scope.woff = if val? then ~~val else scope.defaultWoff

			scope.$watch 'responsive', (val) ->
				win = angular.element(window)
				if(val? && win?)
					#console.log 'responsive'
					win.bind "resize", resizeHandler


			#
			# wait a tick to ensure scope watches have fired.
			#
			$timeout =>
				scope.svg = d3.select(element[0])
				.append("svg")

				scope.svg
				.append("g")
				.append("rect")
				.attr("class", "outer")
	
				scope.setWindowWidth angular.element(window).innerWidth()
				scope.svgResize()

				console.log "SVG created"
			, 1

	}
]




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

	$scope._margin = $scope._padding = {top:0, right:0, bottom:0; left: 0}

	#console.log $scope.$id
])
.directive 'd3Vis', ['$timeout', ($timeout) ->

	return {
		restrict: 'A'
		transclude: true
		replace: true
		controller: 'd3VisController'

		scope: {
			width: '@'
			height: '@'
			woff: '@' #width offset to allow for inherited margins & borders
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
				#console.log "resizing"
				scope.setWindowWidth event.target.innerWidth

			parseBorderList = (dimensionList) ->
				obj = {top:0, right:0, bottom:0, left:0}
				if dimensionList?

					list = dimensionList.split ///
						\s+ 				# one or more whitespace chars
						| \s*,\s* 	#	a comma inside optional whitespace
					///

					# convert strings to numbers
					list = list.map (val) -> ~~val

					switch list.length
						when 1 then obj.top = obj.right = obj.left = obj.bottom = list[0]
						when 2 then [obj.top, obj.right] = [obj.bottom, obj.left] = list
						when 3 then [obj.top, obj.right, obj.bottom] = list; obj.left = obj.right
						when 4 then [obj.top, obj.right, obj.bottom, obj.left] = list
				return obj

			scope.svgResize = ->
				@svg.attr 'width', @outerWidth + 1
				@svg.attr 'height', @outerHeight + 1
				#console.log "svg(", @outerWidth, @outerHeight, ")"

				g = @svg.select("g")

				g.select("rect")
				.attr("class", "outer")
				.attr("width", @innerWidth)
				.attr("height", @innerHeight)
				.attr("transform", "translate(" + @_margin.left + "," + @_margin.top + ")")

				g.select("g > rect")
				.attr("class", "inner")
				.attr("width", @width)
				.attr("height", @height)
				.attr("transform", "translate(" + @_padding.left + "," + @_padding.top + ")")


			scope.setWindowWidth = (ww) ->
				w = ww - @woff
				@outerWidth = ~~@outerWidth
				if(@outerWidth <= w)
					@outerHeight = ~~@outerHeight
				else
					@outerHeight = Math.round(~~@outerHeight * w / @outerWidth)
					@outerWidth = w

				@innerWidth = @outerWidth - @_margin.left - @_margin.right
				@innerHeight = @outerHeight - @_margin.top - @_margin.bottom

				console.log('iw=', scope.innerWidth)

				@width = @innerWidth - @_padding.left - @_padding.right
				@height = @innerHeight - @_padding.top - @_padding.bottom

				console.log('w=', @width)

				@svgResize()

				#console.log "ow,oh=", @outerWidth, @outerHeight

			scope.$watch 'outerWidth', (val) ->
				scope.outerWidth = if val? then ~~val else scope.defaultWidth
				console.log 'new outerWidth=', scope.outerWidth

			scope.$watch 'outerHeight', (val) ->
				scope.outerHeight = if val? then ~~val else scope.defaultHeight
				#console.log 'new outerHeight=', scope.height

			scope.$watch 'woff', (val) ->
				scope.woff = if val? then ~~val else scope.defaultWoff

			scope.$watch 'responsive', (val) ->
				win = angular.element(window)
				if(val? && win?)
					#console.log 'responsive'
					win.bind "resize", resizeHandler

			scope.$watch 'margin', (val) ->
				if val?
					scope._margin = parseBorderList(val)

			scope.$watch 'padding', (val) ->
				if val?
					scope._padding = parseBorderList(val)

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

				g = scope.svg.append("g")
					.attr("transform", "translate(" + scope._padding.left + "," + scope._padding.top + ")")

				g.append("rect")
					.attr("class", "inner")

	
				scope.setWindowWidth angular.element(window).innerWidth()
				scope.svgResize()

				console.log "SVG created"
			, 1

	}
]




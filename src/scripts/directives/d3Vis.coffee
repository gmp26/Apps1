#
# d3 visualisation wrapper
#
(angular.module('app')
.controller 'd3VisController',
[
	'$scope'
	'$transclude'
	($scope, $transclude) ->
		$scope.defaultWidth  = 550
		$scope.defaultHeight = 400

		$scope.defaultWoff = 41
		$scope.ready = false
		$scope._margin = {top:0, right:0, bottom:0; left: 0}
		$scope._padding = {top:0, right:0, bottom:0; left: 0}

])
.directive 'd3Vis',
[
	'$timeout', '$window'
	($timeout, $window) ->
		restrict: 'A'
		transclude: false
		replace: false
		priority: 1000
		controller: 'd3VisController'

		scope: {
			fullwidth: '@'
			fullheight: '@'
			woff: '@' #width offset to allow for inherited margins & borders
			margin: '@'
			padding: '@'
			responsive: '@'
			type:'@'
			visible: '@'
		}

		link: (scope, element, attrs) ->

			console.log('d3Vis')

			# define handler for different window widths
			resizeHandler = (event) =>
				scope.setWindowWidth event.target.innerWidth

			parseBorderList = (dimensionList) ->
				obj = {top:0, right:0, bottom:0, left:0}
				if dimensionList?

					list = dimensionList.split ///
						\s+ 				# on one or more whitespace chars
						| \s*,\s* 	#	or a comma inside optional whitespace
					///

					# convert strings to numbers
					list = list.map (val) -> ~~val

					switch list.length
						when 1 then obj.top = obj.right = obj.left = obj.bottom = list[0]
						when 2 then [obj.top, obj.right] = [obj.bottom, obj.left] = list
						when 3 then [obj.top, obj.right, obj.bottom] = list; obj.left = obj.right
						when 4 then [obj.top, obj.right, obj.bottom, obj.left] = list
				return obj

			scope.setWindowWidth = (ww) ->
				w = ww - @woff
				@outerWidth = ~~@fullWidth
				if(@outerWidth <= w)
					@outerHeight = ~~@fullHeight
				else
					@outerHeight = Math.round(~~@fullHeight * w / @fullWidth)
					@outerWidth = w

				@innerWidth = @outerWidth - @_margin.left - @_margin.right
				@innerHeight = @outerHeight - @_margin.top - @_margin.bottom

				@width = @innerWidth - @_padding.left - @_padding.right
				@height = @innerHeight - @_padding.top - @_padding.bottom

				@svgResize()

			scope.svgResize = ->
				@svg.attr 'width', @outerWidth + 1
				@svg.attr 'height', @outerHeight + 1

				g = @svg.select("g")
				.attr("transform", "translate(" + @_margin.left + "," + @_margin.top + ")")

				g.select("rect")
				.attr("class", "outer")
				.attr("width", @innerWidth)
				.attr("height", @innerHeight)

				g.select("g")
				.attr("transform", "translate(" + @_padding.left + "," + @_padding.top + ")")
				.select("rect")
				.attr("class", "inner")
				.attr("width", @width)
				.attr("height", @height)



			scope.$watch 'fullwidth', (val, old) ->
				scope.fullWidth = if val? then ~~val else scope.defaultWidth

			scope.$watch 'fullheight', (val) ->
				scope.fullHeight = if val? then ~~val else scope.defaultHeight

			scope.$watch 'woff', (val) ->
				scope.woff = if val? then ~~val else scope.defaultWoff

			scope.$watch 'responsive', (val) ->
				win = angular.element($window)
				if(val? && win?)
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
			$timeout ->
				scope.svg = d3.select(element[0])
				.append("svg")

				g = scope.svg
				.append("g")

				g.append("rect")
				.attr("class", "outer")

				g.append("g")
				.append("rect")
					.attr("class", "inner")

				scope.$emit("draw", g)

				scope.setWindowWidth angular.element($window).innerWidth()
				scope.svgResize()
			,1
]



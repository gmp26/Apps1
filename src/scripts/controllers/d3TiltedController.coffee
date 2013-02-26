angular.module('app').controller 'd3TiltedController', ['$scope', ($scope) ->

	$scope.setMaxWidth = (maxWidth = 600) ->
		@outerWidth = @preferredWidth
		if(@outerWidth <= maxWidth)
			@outerWidth = @preferredHeight
		else
			@outerHeight = Math.floor(@preferredHeight * maxWidth / @preferredWidth)
			@outerWidth = maxWidth

	$scope.setDimensions = (
		preferredWidth = 550,
		preferredHeight = 400,
		radius = 5,
		spotRadius = 25,
		spacing = 40,
		margin = {top: 20, right: 20, bottom: 20, left: 20}
	) ->

		m = @margin

		@outerWidth = @preferredWidth = ~~preferredWidth
		@outerHeight = @preferredHeight = ~~preferredHeight

		iw = @innerWidth = @outerWidth - ~~m.left - ~~m.right
		ih = @innerHeight = @outerHeight - ~~m.top - ~~m.bottom

		@radius = ~~radius
		@spotRadius = ~~spotRadius

		@padding = {top: @radius, right: @radius, bottom: @radius, left: @radius}
		d = @radius * 2
		@width = iw - d
		@height = ih - d
		s = ~~@spacing

		@along = Math.floor(@width / s)
		@down = Math.floor(@height / s)

		# So we calculate the outer bounds again
		@halfInnerWidth = iw / 2
		@halfInnerHeight = ih / 2

		@x = d3.scale.identity()
			.domain([0, @width])

		@y = d3.scale.identity()
			.domain([0, @height])

		@xAxis = d3.svg.axis()
			.scale(@x)
			.orient("bottom")

		@yAxis = d3.svg.axis()
			.scale(@y)
			.orient("left")

		console.log("a,d = ", @along, @down)
		console.log("w,h = ", @width, @height)
]





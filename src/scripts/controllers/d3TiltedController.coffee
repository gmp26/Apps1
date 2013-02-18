angular.module('app').controller 'd3TiltedController', ($scope) ->
	
	$scope.setDefaults = () ->
		@outerWidth = 320
		@outerHeight = 180
		@radius = 5
		@spotRadius = 25
		@spacing = 40
		@margin = {top: 20, right: 20, bottom: 20, left: 20}
		@padding = {top: @radius, right: @radius, bottom: @radius, left: @radius}

	$scope.setDimensions = (maxWidth = 600) ->
		@setDefaults unless @margin?
		m = @margin
		@outerWidth = ~~@outerWidth
		if(@outerWidth > ~~maxWidth)
			@outerHeight = ~~@outerHeight * maxWidth/@outerWidth
			@outerWidth = maxWidth

		iw = @outerWidth - m.left - m.right
		ih = @outerHeight - m.top - m.bottom

		d = ~~@radius * 2
		w = iw - d
		h = ih - d

		s = ~~@spacing

		@along = Math.floor(w / s)
		@down = Math.floor(h / s)
		@spacing = s = Math.floor(Math.min(w / @along, h / @down))
		@along = Math.floor(w / s)
		@down = Math.floor(h / s)
		
		# We've now decided how big our display really is
		@width = @along * s
		@height = @down * s

		# So we calculate the outer bounds again
		@innerWidth = w + d
		@innerHeight = h + d
		@halfInnerWidth = iw / 2
		@halfInnerHeight = ih / 2
		@outerWidth = iw + m.left + m.right
		@outerHeight = ih + m.top + m.bottom

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

	$scope.setDefaults()
	$scope.setDimensions()
	



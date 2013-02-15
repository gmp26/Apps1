angular.module('app').controller 'd3TiltedController', ($scope) ->
	


	$scope.x = d3.scale.identity()
	.domain([0, $scope.width])

	$scope.y = d3.scale.identity()
		.domain([0, $scope.height])

	$scope.xAxis = d3.svg.axis()
		.scale($scope.x)
		.orient("bottom")

	$scope.yAxis = d3.svg.axis()
		.scale($scope.y)
		.orient("right")

	$scope.along = 10
	$scope.down = 10
	$scope.spacing = 50

	$scope.setDimensions = ->
		margin = {top: 20, right: 20, bottom: 20, left: 20}
		padding = {top: 10, right:10, bottom: 10, left: 10}
		
		outerWidth = 300 #768
		outerHeight = 300 #1024 - 100
		innerWidth = outerWidth - margin.left - margin.right
		innerHeight = outerHeight - margin.top - margin.bottom
		width = innerWidth - padding.left - padding.right
		height = innerHeight - padding.top - padding.bottom

		$scope.margin = margin
		$scope.padding = padding
		$scope.outerWidth = outerWidth
		$scope.outerHeight = outerHeight
		$scope.innerWidth = innerWidth
		$scope.innerHeight = innerHeight
		$scope.halfInnerWidth = innerWidth / 2
		$scope.halfInnerHeight = innerHeight / 2
		$scope.width = width
		$scope.height = height

	$scope.setWidth = ->
		$scope.width = $scope.along * $scope.spacing

	$scope.setHeight = ->
		$scope.height = $scope.down * $scope.spacing

	console.log("w,h = ", $scope.width, $scope.height)

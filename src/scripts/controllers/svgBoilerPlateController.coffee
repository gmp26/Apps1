#
# You probably want to take a copy of this and edit it to taste
#
angular.module('app').controller 'svgBoilerPlateController', ($scope) ->
	
	margin = {top: 20, right: 20, bottom: 20, left: 20}
	padding = {top: 40, right: 40, bottom: 40, left: 40}
	
	outerWidth = 400 #768
	outerHeight = 400 #1024 - 100
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

	$scope.x = d3.scale.identity()
	.domain([0, width])

	$scope.y = d3.scale.identity()
		.domain([0, height])

	$scope.xAxis = d3.svg.axis()
		.scale($scope.x)
		.orient("bottom")

	$scope.yAxis = d3.svg.axis()
		.scale($scope.y)
		.orient("right")


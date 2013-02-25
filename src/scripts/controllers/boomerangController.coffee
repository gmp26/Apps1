# First Pass

angular.module('app')
.controller 'boomerangController', ($scope) ->

	$scope.small = 1
	$scope.large = 1

	$scope.decTime = () -> @small + @large

	$scope.carveTime = () -> 2 * @small + 3 * @large

	$scope.decTimeOK = () -> if 0 <= @decTime() <= 10 then "good" else "bad"

	$scope.carveTimeOK = () -> if 0 <= @carveTime() <= 24 then "good" else "bad"


	$scope.totalIncome = () -> @small * 8 + @large * 10

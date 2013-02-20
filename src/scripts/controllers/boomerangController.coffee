angular.module('app').controller 'boomerangController', ['$scope', ($scope) ->
	
	$scope.decTime = () ->
		@small + @large

	$scope.carveTime = () ->
		2 * @small + 3 * @large

	$scope.total = () ->
		@small * 8 + @large * 10

	$scope.decTimeOK = () ->
		if @decTime() <= 10 then "good" else "bad"

	$scope.carveTimeOK = () ->
		if @carveTime() <= 24 then "good" else "bad"

]
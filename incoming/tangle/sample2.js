angular.module('sample2', ['tangle'])
.controller('Sample2', function ($scope) {

	$scope.cookies = 4;
	$scope.caloriesPerCookie = 50;
	$scope.calories = function () {
		return $scope.cookies * $scope.caloriesPerCookie;
	};

});

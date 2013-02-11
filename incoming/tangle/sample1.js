angular.module('sample1', [])

.controller('Sample1', function ($scope) {

	$scope.cookies = 4;
	$scope.caloriesPerCookie = 50;
	$scope.calories = function () {
			return $scope.cookies * $scope.caloriesPerCookie;
	};

});

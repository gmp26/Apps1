angular.module('app').controller('boomerangController', function($scope) {
  $scope.small = 1;
  $scope.large = 1;
  $scope.decTime = function() {
    return this.small + this.large;
  };
  $scope.carveTime = function() {
    return 2 * this.small + 3 * this.large;
  };
  $scope.decTimeOK = function() {
    var _ref;

    if ((0 <= (_ref = this.decTime()) && _ref <= 10)) {
      return "good";
    } else {
      return "bad";
    }
  };
  $scope.carveTimeOK = function() {
    var _ref;

    if ((0 <= (_ref = this.carveTime()) && _ref <= 24)) {
      return "good";
    } else {
      return "bad";
    }
  };
  return $scope.totalIncome = function() {
    return this.small * 8 + this.large * 10;
  };
});

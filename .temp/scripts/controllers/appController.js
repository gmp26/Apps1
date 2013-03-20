angular.module('app').controller('appController', [
  '$scope', '$location', '$resource', '$rootScope', function($scope, $location, $resource, $rootScope) {
    $scope.$location = $location;
    $scope.$watch('$location.path()', function(path) {
      console.log('path=', path);
      return $scope.activeNavId = path || '/';
    });
    return $scope.getClass = function(id) {
      if ($scope.activeNavId && $scope.activeNavId.indexOf(id) === 0) {
        return 'active';
      } else {
        return '';
      }
    };
  }
]);

angular.module('app').config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    return $routeProvider.when('/tiltedApp', {
      templateUrl: '/views/tilted1.html'
    }).when('/d3Tilted', {
      templateUrl: '/views/d3Tilted.html'
    }).when('/todo', {
      templateUrl: '/views/todo.html'
    }).when('/svgMargins', {
      templateUrl: '/views/svgMargins.html'
    }).when('/frogs', {
      templateUrl: '/views/frogs.html'
    }).when('/boomerangs', {
      templateUrl: '/views/boomerangs.html'
    }).otherwise({
      redirectTo: '/d3Tilted'
    });
  }
]);

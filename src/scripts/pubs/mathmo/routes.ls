angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    $routeProvider
    .when '/mathmo/:help' templateUrl: '/views/mathmo.html'
    .when '/mathmo/:cmd/:x/:t/:q' templateUrl: '/views/mathmo.html'
    .when '/mathmo', templateUrl: '/views/mathmo.html'
    .otherwise redirectTo: '/mathmo'

]
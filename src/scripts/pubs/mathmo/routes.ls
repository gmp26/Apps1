angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    $routeProvider
    .when '/mathmo', templateUrl: '/views/mathmo.html'
    .otherwise redirectTo: '/mathmo'

]
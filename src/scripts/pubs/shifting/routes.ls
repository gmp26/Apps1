angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    $routeProvider
    .when '/shifting', templateUrl: '/views/shifting.html'
    .otherwise redirectTo: '/shifting'

]
angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    $routeProvider
    .when '/<%= mask %>', templateUrl: '/views/<%= mask %>.html'
    .otherwise redirectTo: '/<%= mask %>'

]
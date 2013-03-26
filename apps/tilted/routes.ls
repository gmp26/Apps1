angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    # use /tiltedApp rather than #/tiltedApp
    #$locationProvider.html5Mode true

    $routeProvider
    .when '/d3Tilted', templateUrl: '/views/d3Tilted.html'
    .otherwise redirectTo: '/d3Tilted'

]
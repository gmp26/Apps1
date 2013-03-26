angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    # use /tiltedApp rather than #/tiltedApp
    #$locationProvider.html5Mode true

    $routeProvider
    .when '/boomerangs', templateUrl: '/views/boomerangs.html'
    .otherwise redirectTo: '/boomerangs'

]
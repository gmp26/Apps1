angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    # use /tiltedApp rather than #/tiltedApp
    #$locationProvider.html5Mode true

    $routeProvider
    .when '/spinners', templateUrl: '/views/spinners.html'
    .when '/prob9546', templateUrl: '/views/prob9546.html'
    .otherwise redirectTo: '/spinners'

]
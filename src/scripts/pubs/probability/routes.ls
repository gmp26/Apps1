angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    # use /tiltedApp rather than #/tiltedApp
    #$locationProvider.html5Mode true

    $routeProvider
    #.when '/spinners', templateUrl: '/views/spinners.html'
    .when '/prob9546', templateUrl: '/views/prob9546.html'
    .when '/prob9525', templateUrl: '/views/prob9525.html'
    .otherwise redirectTo: '/prob9546'

]
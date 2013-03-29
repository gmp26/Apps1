angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    # use /tiltedApp rather than #/tiltedApp
    #$locationProvider.html5Mode true

    $routeProvider
    .when '/tilted', templateUrl: '/views/tilted.html'
    .when '/todo', templateUrl: '/views/todo.html'
    .when '/spinners', templateUrl: '/views/spinners.html'
    .when '/prob9546', templateUrl: '/views/prob9546.html'
    .when '/boomerangs', templateUrl: '/views/boomerangs.html'
    .when '/frogs/:users/:id/:reds/:blues' templateUrl: '/views/frogs.html'
    .otherwise redirectTo: '/tilted'

]
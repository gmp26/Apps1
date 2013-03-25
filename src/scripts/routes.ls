angular.module('app').config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->

    # use /tiltedApp rather than #/tiltedApp
    #$locationProvider.html5Mode true

    $routeProvider
    .when '/tiltedApp', templateUrl: '/views/tilted1.html'
    .when '/d3Tilted', templateUrl: '/views/d3Tilted.html'
    .when '/todo', templateUrl: '/views/todo.html'
    .when '/svgMargins', templateUrl: '/views/svgMargins.html'
    .when '/spinners', templateUrl: '/views/spinners.html'
    .when '/boomerangs', templateUrl: '/views/boomerangs.html'
    .when '/frogs/:users/:id/:reds/:blues' templateUrl: '/views/frogs.html'
    .otherwise redirectTo: '/d3Tilted'

]
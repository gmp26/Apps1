angular.module('app')
  .config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

    # use /tiltedApp rather than #/tiltedApp
    #$locationProvider.html5Mode true

    $routeProvider
      .when '/student' templateUrl: '/views/frogs/student.html'
      .when '/student/:reds/:blues' templateUrl: '/views/frogs/student.html'
      .when '/teacher' templateUrl: '/views/frogs/teacher.html'
      .when '/teacher/:reds/:blues' templateUrl: '/views/frogs/teacher.html'
      .otherwise redirectTo: '/student'
  ]
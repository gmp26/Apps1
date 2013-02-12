angular.module('app')
	.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

		# use /tiltedApp rather than #/tiltedApp
		#$locationProvider.html5Mode true

		$routeProvider
			.when '/tiltedApp'
				templateUrl: 'src/views/tilted1.html'
			.when '/todo'
				templateUrl: 'src/views/todo.html'
			.when '/view1'
				templateUrl: 'src/views/partial1.html'
			.when '/view2'
				templateUrl: 'src/views/partial2.html'
			.otherwise redirectTo: '/tiltedApp'
]
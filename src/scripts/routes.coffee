angular.module('app')
	.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

		# use /tiltedApp rather than #/tiltedApp
		#$locationProvider.html5Mode true

		$routeProvider
			.when '/tiltedApp'
				templateUrl: 'src/views/tilted1.html'
			.when '/todo'
				templateUrl: 'src/views/todo.html'
			.when '/svgMargins'
				templateUrl: 'src/views/svgMargins.html'
			.when '/frogs'
				templateUrl: 'src/views/frogs.html'
			.otherwise redirectTo: '/tiltedApp'
]
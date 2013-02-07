angular.module('app')
	.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

		# use /tiltedApp rather than #/tiltedApp
		#$locationProvider.html5Mode true

		$routeProvider
			.when '/tiltedApp'
				templateUrl: 'src/views/tilted1.html'
			.otherwise redirectTo: '/tiltedApp'
]
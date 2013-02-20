angular.module('app')
	.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

		# use /tiltedApp rather than #/tiltedApp
		#$locationProvider.html5Mode true

		$routeProvider
			.when '/tiltedApp'
				templateUrl: 'src/views/tilted1.html'
			.when '/d3Tilted'
				templateUrl: 'src/views/d3Tilted.html'
			.when '/todo'
				templateUrl: 'src/views/todo.html'
			.when '/svgMargins'
				templateUrl: 'src/views/svgMargins.html'
			.when '/frogs'
				templateUrl: 'src/views/frogs.html'
			.when '/boomerangs'
				templateUrl: 'src/views/boomerangs.html'
			.otherwise redirectTo: '/tiltedApp'
]
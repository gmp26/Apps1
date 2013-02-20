require
	shim:
		'templates':
			deps: [
				'libs/angular'
				'libs/bootstrap'
				'app'
				'controllers/appController'
				'controllers/todoController'
				'controllers/frogController'
				'controllers/svgBoilerPlateController'
				'controllers/d3TiltedController'
				'controllers/boomerangController'
				'directives/appVersion'
				'directives/svgMarginConvention'
				'directives/d3Vis'
				'directives/d3TiltedSquare'
				'directives/tiltedSquare'
				'directives/stepper'
			]
		'controllers/appController':
			deps: [
				'libs/angular'
				'app'
			]
		'controllers/todoController':
			deps: [
				'libs/angular'
				'app'
			]
		'controllers/frogController':
			deps: [
				'libs/angular'
				'app'
			]
		'controllers/svgBoilerPlateController':
			deps: [
				'libs/angular'
				'app'
			]
		'controllers/d3TiltedController':
			deps: [
				'libs/angular'
				'app'
			]
		'controllers/boomerangController':
			deps: [
				'libs/angular'
				'app'
			]
		'directives/svgMarginConvention':
			deps: [
				'libs/angular'
				'app'
			]
		'directives/d3TiltedSquare':
			deps: [
				'libs/angular'
				'app'
				'libs/d3.v3'
			]
		'directives/tiltedSquare':
			deps: [
				'libs/angular'
				'app'
				'libs/fabric'
			]
		'directives/d3Vis':
			deps: [
				'libs/angular'
				'app'
				'libs/fabric'
			]
		'directives/appVersion':
			deps: [
				'libs/angular'
				'app'
				'services/semver'
			]
		'directives/stepper':
			deps: [
				'libs/angular'
				'app'
			]
		'services/semver': deps: ['libs/angular', 'app']
		'libs/angular': deps: ['libs/jquery']
		'libs/bootstrap': deps: ['libs/jquery']
		'libs/angular-resource': deps: ['libs/angular']
		'app': deps: [
				'libs/angular'
				'libs/angular-resource'
			]
		'bootstrap': deps: ['app']
		'routes': deps: ['app', 'templates']
	[
		'require'
		'routes'
	], (require) ->
		require ['bootstrap']
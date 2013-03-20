shim = 
	shim:
		'controllers/appController':
			deps: [
				'app'
			]
		'controllers/todoController':
			deps: [
				'app'
			]
		'controllers/frogController':
			deps: [
				'app'
			]
		'controllers/boomerangController':
			deps: [
				'app'
			]
		'directives/frogs':
			deps: [
				'app'
			]
		'directives/frog':
			deps: [
				'app'
			]
		'directives/tiltedSquare':
			deps: [
				'app'
				'libs/fabric'
			]
		'directives/d3Vis':
			deps: [
				'app'
				'libs/d3.v3'
				'directives/svgCheck'
			]
		'directives/d3DotGrid':
			deps: [
				'app'
				'directives/d3Vis'
			]
		'directives/d3TiltedSquare':
			deps: [
				'app'
				'directives/d3DotGrid'
			]
		'directives/svgCheck':
			deps: [
				'app'
				'libs/d3.v3'
			]
		'directives/appVersion':
			deps: [
				'app'
				'services/semver'
			]
		'services/semver': deps: ['libs/angular', 'app']
		'bootstrap': deps: ['app']
		'libs/bootstrap': deps: ['libs/jquery']
		'libs/angular-resource': deps: ['libs/angular']
		'libs/ui-bootstrap-tpls': deps: ['libs/angular']
		'app': 
			deps: [
				'libs/angular'
				'libs/angular-resource'
				'libs/ui-bootstrap-tpls'
			]
		'routes': deps: ['app']
		'views': deps: ['app']

configure = [
	'require'
	'controllers/appController'
	'controllers/todoController'
	'controllers/frogController'
	'controllers/boomerangController'
	'directives/appVersion'
	'directives/d3Vis'
	'directives/d3DotGrid'
	'directives/d3TiltedSquare'
	'directives/tiltedSquare'
	'directives/frogs'
	'directives/frog'
	'directives/svgCheck'
	'routes'
	'views'
]

require shim, configure, (require) -> require ['bootstrap']
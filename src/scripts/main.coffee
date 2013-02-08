require
	shim:
		'templates':
			deps: [
				'libs/angular'
				'app'
				'controllers/svgBoilerPlateController'
				'directives/svgMarginConvention'
				'directives/d3TiltedSquare'
				'directives/tiltedSquare'
			]
		'controllers/svgBoilerPlateController':
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
		'libs/angular-resource':
			deps: ['libs/angular']
		'app':
			deps: [
				'libs/angular'
				'libs/angular-resource'
			]
		'bootstrap':
			deps: [
				'app'
			]
		'routes':
			deps: [
				'app'
				'templates'
			]
		'run':
			deps: [
				'app'
			]
	[
		'require'
		'routes'
		'run'
	], (require) ->
		require ['bootstrap']
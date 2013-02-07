require
	shim:
		'directives/tiltedSquare':
			deps: [
				'libs/angular'
				'app'
				'libs/fabric'
			]
		'libs/angular-resource':
			deps: ['libs/angular']
		'templates':
			deps: [
				'libs/angular'
				'app'
				'directives/tiltedSquare'
			]
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
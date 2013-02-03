require
	shim:
		'directives/tiltedSquare':
			deps: [
				'app'
			]
		'libs/angular-resource':
			deps: [
				'libs/angular'
			]
		'app':
			deps: [
				'libs/angular'
				'libs/angular-resource'
				'libs/fabric'
			]
		'bootstrap':
			deps: [
				'app'
			]
		'routes':
			deps: [
				'app'
			]
		'run':
			deps: [
				'app'
			]
	[
		'require'
		'directives/tiltedSquare'
		'routes'
		'run'
	], (require) ->
		require ['bootstrap']
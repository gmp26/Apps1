beforeEach module 'app'

describe 'App', () ->

	# we want to make the scope available generally
	scope = {}

	beforeEach inject ($controller, $rootScope) ->

		scope = $rootScope.$new()

		$controller 'd3TiltedController',
			$scope: scope

	describe 'd3 tiltedSquare Controller', () ->

		xit 'should set default values on scope', ()->
			expect(scope.radius).toBeUndefined()
			scope.setDefaults()
			expect(scope.outerWidth).toBeDefined()
			expect(scope.outerHeight).toBeDefined()
			expect(scope.spacing).toBeDefined()
			expect(scope.margin).toBeDefined()
			expect(scope.radius).toBeDefined()
			expect(scope.spotRadius).toBeDefined()

		xit 'should calculate along and down', ()->
			scope.setDimensions()
			expect(scope.along).toBeDefined()
			expect(scope.down).toBeDefined()


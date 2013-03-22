beforeEach module 'app'

describe 'App', (_) ->

	# we want to make the scope available generally
	scope = null
	timeout = null

	beforeEach inject ($controller, $rootScope, $timeout) ->

		scope := $rootScope.$new()
		$controller 'frogController', $scope: scope
		timeout := $timeout

	describe 'frogspawn', (_) ->

		it 'should start with 2 red, 2 blue', ->
			expect(scope._red).toBe 2
			expect(scope._blue).toBe 2

		it 'should put them in a frog array', ->
			expect(scope.frogs.length).toBe 5

		it 'should make a move list', ->
			expect(scope.moves).toBeDefined()
			expect(scope.moves.red).toBe 2
			expect(scope.moves.list.length).toBe 0

	describe 'hopping', (_) ->

		it 'should allow hops to space', ->
			scope.hop(scope.frogs[0], scope.frogs[2])
			expect(scope.frogs[0].x).toBe 2
			expect(scope.frogs[2].x).toBe 0

		it 'should save moves', ->
			scope.hop(scope.frogs[0], scope.frogs[2])
			expect(scope.moves.list.length).toBe 1
			expect(scope.moves.list.0).toEqual(frogx: 0, spacex: 2)


	describe 'replaying', (_) ->

		it 'should first reset to start', ->
			scope.hop(scope.frogs[0], scope.frogs[2])
			scope.replay(null)
			expect(scope.frogs[0].x).toBe 0
			expect(scope.frogs[2].x).toBe 2

		it 'should return to final state after 1s', ->
			scope.hop(scope.frogs[0], scope.frogs[2])
			scope.replay(null)
			timeout.flush()
			timeout.flush()
			expect(scope.frogs[0].x).toBe 2
			expect(scope.frogs[2].x).toBe 0





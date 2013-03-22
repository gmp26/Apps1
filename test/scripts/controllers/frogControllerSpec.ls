import prelude

beforeEach module 'app'

describe 'App', (_) ->

	# we want to make the scope available generally
	scope = null
	timeout = null

	beforeEach inject ($controller, $rootScope, $timeout) ->
		scope := $rootScope.$new()
		$controller 'frogController', $scope: scope
		timeout := $timeout

	describe 'spawning', (_) ->

		it 'should start with 2 red, 2 blue', ->
			expect scope._red .toBe 2
			expect scope._blue .toBe 2

		it 'should put them in a frog array', ->
			expect scope.frogs.length .toBe 5

		it 'should make a move list', ->
			expect scope.moves .toBeDefined()
			expect scope.moves.red .toBe 2
			expect scope.moves.list.length .toBe 0

	describe 'hopping', (_) ->

		it 'should allow hops to space', ->
			scope.hop scope.frogs.0, scope.frogs.2
			expect scope.frogs.0.x .toBe 2
			expect scope.frogs.2.x .toBe 0

		it 'should save moves', ->
			scope.hop scope.frogs.0, scope.frogs.2
			expect scope.moves.list.length .toBe 1
			expect scope.moves.list.0 .toEqual frogx: 0, spacex: 2

		it 'should check whether for completion and minimum moves' ->
			scope._red = 1
			scope._blue = 1
			scope.reset()

			expect scope.done .toBe false

			# Make enough moves to swap frogs
			scope.hop scope.frogs.0, scope.frogs.1
			scope.hop scope.frogs.2, scope.frogs.1
			scope.hop scope.frogs.1, scope.frogs.0

			expect scope.done .toBe true
			expect scope.minimum .toBe true

			scope.hop scope.frogs.0, scope.frogs.1
			scope.hop scope.frogs.1, scope.frogs.0

			expect scope.minimum .toBe false


	describe 'replay', (_) ->

		it 'should reset then return to final state after 1s', ->
			scope.hop scope.frogs.0, scope.frogs.2
			scope.replay(null)
			expect scope.frogs.0.x .toBe 0
			expect scope.frogs.2.x .toBe 2
			timeout.flush()
			expect scope.frogs.0.x .toBe 2
			expect scope.frogs.2.x .toBe 0

	describe 'save', (_) ->

		it 'should save the last set of moves', ->
			scope.hop scope.frogs.0, scope.frogs.2
			scope.hop scope.frogs.1, scope.frogs.0
			scope.hop scope.frogs.2, scope.frogs.1
			expect scope.moves.list.length .toBe 3

			scope.save()
			scope.save()

			expect scope.savedMoves.length .toEqual 2

			# patch in the tag, which should have changed
			scope.savedMoves.map (.tag = void)

			expect scope.savedMoves.0 .toEqual(scope.moves)
			expect scope.savedMoves.1 .toEqual(scope.moves)

	describe 'forget', (_) ->

		it 'should delete a saved move', ->
			# save a 3 hop sequence
			scope.hop scope.frogs.0, scope.frogs.2
			scope.hop scope.frogs.1, scope.frogs.0
			scope.hop scope.frogs.2, scope.frogs.1
			expect scope.moves.list.length .toBe 3
			scope.save!

			# reset and save a 2 hop sequence
			scope.reset!
			scope.hop scope.frogs.0, scope.frogs.2
			scope.hop scope.frogs.1, scope.frogs.0
			expect scope.moves.list.length .toBe 2
			scope.save()

			# should have 2 saves
			expect scope.savedMoves.length .toBe 2

			# forget the first
			scope.forget 0

			# check that the right one went
			expect scope.savedMoves.length .toBe 1
			expect scope.savedMoves.0.list.length .toBe 2

	describe 'reset', (_) ->

		beforeEach ->
			scope._red = 3
			scope._blue = 4			
			scope.hop scope.frogs.0, scope.frogs.2
			scope.hop scope.frogs.1, scope.frogs.0
			scope.hop scope.frogs.2, scope.frogs.1
			scope.reset()

		it 'should reset to the current initial counts', ->
			expect scope.frogs.length .toBe 8

			reds = take 3, scope.frogs
			expect reds.every (.colour == 0) .toBe true

			blues = drop 4, scope.frogs
			expect blues.every (.colour == 2) .toBe true

		it 'should calculate minimum moves', ->
			expect scope.minMove .toBe 19














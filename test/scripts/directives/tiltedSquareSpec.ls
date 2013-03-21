#
# 'it' is a reserved word in livescript - it means the value of a dummy argument.
# So we need to insert a real argument '_' to decsribe to avoid 'it' being inserted there.
# Mildly yukky.
#
describe 'tiltedSquare directive', (_) ->

	# set these up before each call
	$compile = null
	$httpBackend = null
	$scope = null

	beforeEach module 'app'

	beforeEach inject ($injector) ->
		$httpBackend := $injector.get '$httpBackend'
		$scope := $injector.get('$rootScope').$new()
		$compile := $injector.get '$compile'
		$httpBackend.whenGET('/views/directives/tiltedSquare.html').respond('<div>foo</div>')

	afterEach ->
		$httpBackend.verifyNoOutstandingExpectation()
		$httpBackend.verifyNoOutstandingRequest()

	it 'should pull in the template from the templateUrl file', ->
		element = $compile('<div tilted-square="ts1"></div>')($scope)
		$httpBackend.flush()
		expect(element.text()).toBe('foo')




describe 'tiltedSquare directive', ()->

	# set these up before each call
	[$compile, $httpBackend, $scope] = []

	beforeEach module 'app'

	beforeEach inject ($injector) ->
		$httpBackend = $injector.get '$httpBackend'
		$scope = $injector.get('$rootScope').$new()
		$compile = $injector.get '$compile'
		$httpBackend.whenGET('/views/directives/tiltedSquare.html').respond('<div>foo</div>')

	afterEach () ->
		$httpBackend.verifyNoOutstandingExpectation()
		$httpBackend.verifyNoOutstandingRequest()

	it 'should pull in the template from the templateUrl file', () ->
		element = $compile('<div tilted-square="ts1"></div>')($scope)
		$httpBackend.flush()
		expect(element.text()).toBe('foo')




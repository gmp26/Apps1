describe 'd3Vis directive', () ->

	beforeEach module('app')
  
	#width="550" height="400" margin="20 20 20 20" padding="5 5 5 5" responsive="true"

	scope={}
	compile={}
	rootScope={}
	element={}
	el = {}

	#Get hold of a scope and create a helper function for setting up tests
	beforeEach(inject( ($rootScope, $compile) ->
		scope = $rootScope
		compile = $compile
		#el = angular.element('<d3-vis></d3-vis>')
		el = angular.element('<div d3-vis></div>')
		$compile(el)(scope)
		scope.$digest()
	))

	it "should compile", () ->
		expect(angular.isElement(el)).toBeTruthy()

	it "should insert an svg element", () ->
		expect(el.find('svg').length).toBe 1

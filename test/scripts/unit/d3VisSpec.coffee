describe 'd3Vis directive', () ->

	beforeEach module('app')
  
	#width="550" height="400" margin="20 20 20 20" padding="5 5 5 5" responsive="true"

	scope={}
	compile={}
	el = {}

	#Get hold of a scope and create a helper function for setting up tests
	beforeEach(inject( ($rootScope, $compile) ->
		scope = $rootScope
		compile = $compile
		el = angular.element('<div d3-vis width="600"></div>')
		$compile(el)(scope)
		scope.$digest()
	))

	afterEach ->
		el.remove()

	it "should compile", () ->
		expect(angular.isElement(el)).toBeTruthy()

	it "should insert an svg element", () ->
		svg = el.find('svg')
		expect(svg.length).toBe 1

	describe 'inserted svg', () ->

		svg = {}
		beforeEach ->
			svg = el.find('svg')
			#console.log("el scope is ", el.scope().$id)

		it "should have a width", ->
			expect(svg.attr("width")).toBeDefined()

		it "should have a height", ->
			expect(svg.attr("height")).toBeDefined()

		it "has a default height set in the controller", ->
			expect(svg.attr("height")).toBe '400'

		it "width can be set as attribute", ->
			expect(svg.attr("width")).toBe '600'

		it "should call makeResponsive if responsive is set", ->
			#recompile with responsive
			svg.remove()
			el.remove()
			el = angular.element('<div d3-vis width="550" responsive></div>')
			compile(el)(scope)
			scope.$digest()

			svg = el.find('svg')

			el.scope()
			compile(el)(scope)
			spyOn(el.scope(), 'makeResponsive');
			scope.$digest()
			expect(el.scope().makeResponsive).toHaveBeenCalled();







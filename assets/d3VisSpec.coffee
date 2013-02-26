describe 'd3Vis directive', () ->

	beforeEach module('app')
  
	#width="550" height="400" margin="20 20 20 20" padding="5 5 5 5" responsive="true"

	scope={}
	compile={}
	el = {}
	svg = null

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

	describe "svg creation", ->

		beforeEach(inject( ($rootScope, $compile) ->
			scope = $rootScope
			compile = $compile
			el = angular.element('<div d3-vis width="600"></div>')
			$compile(el)(scope)
			scope.$digest()
		))

		waitsFor (() -> svg = el.find 'svg'),
			"svg should be ready in 10ms",
			10
	
		runs ->
			#expect(svg.length).toBe 1
		
			describe "after svg made", ->
				it "should compile", ->
					expect(angular.isElement(el)).toBeTruthy()

				it "should insert an svg element", () ->
					expect(svg.length).toBe 1

				it "should have a width", ->
					expect(svg.attr("width")).toBeDefined()

				it "should have a height", ->
					expect(svg.attr("height")).toBeDefined()

				it "has a default height set in the controller", ->
					expect(svg.attr("height")).toBe '400'

				it "width can be set as attribute", ->
					expect(svg.attr("width")).toBe '600'
			###





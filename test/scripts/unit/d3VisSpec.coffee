
describe 'd3Vis directive', () ->

	scope={}
	compile={}
	el = {}
	svg = null
	flag = false

	beforeEach module 'app'

	beforeEach inject ($rootScope, $compile) ->
		scope = $rootScope
		compile = $compile

  
	#width="550" height="400" margin="20 20 20 20" padding="5 5 5 5" responsive="true"

	it "should compile", ->
		el = angular.element('<div d3-vis width="600"></div>')
		compile(el)(scope)
		scope.$digest()
		expect(angular.isElement(el)).toBeTruthy()

	it "should wait before running tests", ->

		runs ->
			el = angular.element('<div d3-vis width="600" responsive></div>')
			compile(el)(scope)
			scope.$digest()

		waits 5000

		runs ->
			expect(el).toBeDefined()
			expect(el.scope()).toBeDefined()
			console.log(el.html())
			expect(el.find('svg').length).toBe 100
			svg = el.find('svg').eq(0)
			expect(svg.attr("width")).toBeDefined()


			###
			it "should have a height", ->
				svg = el.scope().svg
				expect(svg.attr("height")).toBeDefined()

			it "has a default height set in the controller", ->
				svg = el.scope().svg
				expect(svg.attr("height")).toBe '400'

			it "width can be set as attribute", ->
				svg = el.scope().svg
				expect(svg.attr("width")).toBe '600'
			###








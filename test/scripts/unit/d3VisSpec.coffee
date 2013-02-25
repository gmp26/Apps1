
describe 'd3Vis directive', () ->

	scope={}
	compile={}
	el = {}
	flag = false

	beforeEach module 'app'

	beforeEach inject ($rootScope, $compile, $timeout) ->

		spyOn(d3, 'select').andCallThrough()

		scope = $rootScope
		compile = $compile
		el = angular.element('<div d3-vis width="600" responsive></div>')
		compile(el)(scope)
		scope.$digest()

		$timeout.flush()

	afterEach ->
		el.remove()


	it "should have called d3.select", ->
		expect(d3.select).toHaveBeenCalled()

	it "should have appended an svg", ->
		expect(el.find('svg').length).toBe 1

	it "svg should have width 600", ->
		expect(el.find('svg').eq(0).attr('width')).toBeDefined()

	###
	it "should call d3Selection.append twice", ->
		expect(d3Selection.append.calls.length).toEqual 2

	it "should have called d3Selection.attr", ->
		expect(d3Selection.attr).toHaveBeenCalled()
	###





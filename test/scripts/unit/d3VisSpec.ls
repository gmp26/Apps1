#
# 'it' is a reserved word in livescript - it means the value of a dummy argument.
# So we need to insert a real argument '_' to decsribe to avoid 'it' being inserted there.
# Mildly yukky.
#
describe 'd3Vis directive', (_) ->

	scope={}
	compile={}
	el = {}
	flag = false
	window = {}

	beforeEach module 'app'

	beforeEach inject ($rootScope, $compile, $timeout, $window) ->

		spyOn(d3, 'select').andCallThrough()

		scope := $rootScope
		compile := $compile
		el := angular.element('<div d3-vis fullwidth="600" responsive></div>')
		compile(el)(scope)
		scope.$digest()
		$timeout.flush()
		window := $window


	afterEach ->
		el.remove()


	it "should have called d3.select", ->
		expect(d3.select).toHaveBeenCalled()

	it "should have appended an svg", ->
		expect(el.find('svg').length).toBe 1

	describe "svg width", (_) ->

		it "should be defined", ->
			expect(el.find('svg').eq(0).attr('width')).toBeDefined()

		it "should be window width - woff + 1", ->
			w = ~~el.find('svg').eq(0).attr('width')
			ww = window.innerWidth
			woff = 41
			expected = if(w <= ww - woff) then 601 else (ww-woff+1)
			expect(w).toBe expected

	describe "border defaults", (_) ->
		s = {}

		beforeEach ->
			s := el.scope()

		it "for margins should be zero", ->
			expect(s._margin.top == s._margin.bottom).toBe true
			expect(s._margin.left == s._margin.right).toBe true

		it "for padding should be zero", ->
			expect(s._padding.top == s._padding.bottom).toBe true
			expect(s._padding.left == s._padding.right).toBe true

	describe "borders", (_) ->

		s = {}

		beforeEach inject ($timeout) ->
			el.remove()
			el := angular.element('<div d3-vis fullwidth="600" margin="1 2 3 4" padding="5,6"></div>')
			compile(el)(scope)
			scope.$digest()
			s := el.scope()
			$timeout.flush()

		it "can be set from attribute list", ->
			expect(s._margin.top).toBe 1
			expect(s._margin.right).toBe 2
			expect(s._margin.bottom).toBe 3
			expect(s._margin.left).toBe 4
			expect(s._padding.top).toBe 5
			expect(s._padding.right).toBe 6
			expect(s._padding.bottom).toBe 5
			expect(s._padding.left).toBe 6

	describe "margins and padding", (_) ->
		s = {}

		beforeEach inject ($timeout) ->
			el.remove()
			el := angular.element('<div d3-vis fullwidth="600" margin="10 20 30 40" padding="5 5 5 5"></div>')
			compile(el)(scope)
			scope.$digest()
			s := el.scope()
			$timeout.flush()

		it "affect the width and innerWidth", ->
			###
			console.log "width", s.width
			console.log "innerwidth", s.innerWidth
			console.log "m.left", s._margin.left
			console.log "m.right", s._margin.right
			console.log "s.outerWidth", s.outerWidth
			###

			expect(s.innerWidth + s._margin.left + s._margin.right == s.outerWidth).toBe true
			expect(s.width + s._padding.left + s._padding.right == s.innerWidth).toBe true

	describe "visibility", (_) ->
		s = {}

		beforeEach inject ($timeout) ->
			el.remove()
			el := angular.element('<div d3-vis fullwidth="600" visible="false"></div>')
			compile(el)(scope)
			scope.$digest()
			s := el.scope()
			$timeout.flush()

		it "is hidden if visible is false", ->
			r1 = s.svg.select("g > rect")
			c1 = r1.attr("class")
			expect(c1).toBe "hide"







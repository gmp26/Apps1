angular.module('app').directive 'frog', ->
	restrict: 'E'
	link: (scope, element, attrs) ->

		state = null

		console.log "froggy element ", element

		X = (x) -> 100*x + "px"

		jump = (me) ->
			emptyPad = (scope.frogs.filter (d) -> d.colour == 1)[0]
			diff = Math.abs(me.x - emptyPad.x)
			if diff == 1 or diff == 2 then scope.hop(me, emptyPad)
			element.css("left", X(me.x))
			emptyPad.element.css("left", X(emptyPad.x))

			console.log scope.frogs
			scope.$digest()

		element.bind "click", (event) ->
			console.log event
			jump(state)
			scope.$apply()

		classBy = (colour) ->
			switch colour
				when 0 then "pad redfrog"
				when 1 then "pad"
				when 2 then "pad bluefrog"
				else throw new Error("invalid frog state")

		attrs.$observe 'frogIndex', (index) ->
			state = scope.frogs[index]
			state.element = element
			element.addClass(classBy(state.colour))
			element.css("left", X(state.x))


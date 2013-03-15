angular.module('app').directive 'frog', ->
	restrict: 'E'
	link: (scope, element, attrs) ->

		state = null

		console.log "froggy element ", element

		# we forgot the "px"; and browsers simply ignore unitless properties!!!
		X = (x) -> 100*x + "px"

		# $apply and $digest deleted since there are no longer any watches
		# otherwise code as before except for z-index addition
		jump = (me) ->

			#ground all the frogs while filtering out the space
			emptyPad = (scope.frogs.filter (d) ->
				d.element.css("z-index", 0)	
				d.colour == 1)[0]

			# can we hop?
			diff = Math.abs(me.x - emptyPad.x)
			if diff == 1 or diff == 2

				# yes! update the model
				scope.hop(me, emptyPad)

				# update the screen
				element.css("left", X(me.x))
				element.css("z-index", 1)
				emptyPad.element.css("left", X(emptyPad.x))

		# set up a click handler
		element.bind "click", (event) -> jump(state)

		# map colour to css class 
		classBy = (colour) ->
			switch colour
				when 0 then "frog redfrog"
				when 1 then "frog"
				when 2 then "frog bluefrog"
				else throw new Error("invalid frog state")

		# see observing attributes in angular directives guide
		attrs.$observe 'frogIndex', (index) ->
			state = scope.frogs[index]
			state.element = element
			element.addClass(classBy(state.colour))

			# added to put frogs in right place on startup
			element.css("left", X(state.x))

			# see frogs.less for position and transitions


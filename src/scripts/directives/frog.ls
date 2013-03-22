angular.module('app').directive 'frog', [
  '$timeout'
  ($timeout) ->
    restrict: 'EA'
    link: (scope, element, attrs) ->

      # console.log "froggy element ", element

      # we forgot the "px"; and browsers simply ignore unitless properties!!!
      X = (x) -> 100*x + "px"

      scope.$watch 'frog.x', (newX, oldX) ->
        # console.log "moving #oldX to #newX"
        element.css("left", X(newX))
        element.css("z-index", 1)

      # respond to a click on a frog
      jump = (me) ->
        # currently in browser event context

        # apply this function in angular context
        # remove this line and moveCount fails to update
        scope.$apply ->

          # ground all the frogs while filtering for the empty pad
          emptyPad = (scope.frogs.filter (d) ->
            d.element.css("z-index", 0)
            d.colour == 1
          )[0]

          # can we hop?
          diff = Math.abs(me.x - emptyPad.x)
          if diff == 1 or diff == 2

            # yes! update the model
            scope.hop(me, emptyPad)

            # & update the screen
            #me.move(emptyPad)


      # map colour to css class
      classBy = (colour) ->
        switch colour
        | 0 => "frog red"
        | 1 => "frog"
        | 2 => "frog blue"
        default throw new Error("invalid frog colour")

      element.addClass(classBy(scope.frog.colour))

      # added to put frogs in right place on startup
      element.css("left", X(scope.frog.x))

      # set up a click handler on the frog
      element.bind "click", (event) -> jump(scope.frog)

      scope.frog.element = element

]

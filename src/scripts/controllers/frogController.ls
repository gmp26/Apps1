angular.module('app').controller 'frogController', [
  '$scope'
  '$timeout'
  ($scope, $timeout) ->

    $scope._red = 2
    $scope._blue = 2
    $scope.container.width = 650 if $scope.container?
    $scope.minMove = 8
    $scope.savedMoves = []
    $scope.showReplay = false

    # spawn an array of frog objects containing colour and pad index
    spawn = (red,blue) ->
      [-red to blue].map (d,i) ->
        colour: if d < 0 then 0 else if d == 0 then 1 else 2
        x: i

    initialState = null
    #promises = []

    ###
    # class MoveList
    #   an easy to clone list of moves annotated with a tag string
    #   and the current red and blue counts.
    ###
    class MoveList
      (@list, @tag, @red, @blue) ->
      clone: ->
        new MoveList @list.concat(), @tag, @red, @blue

    reset = ->

      # this will be constant
      initialState := spawn($scope._red, $scope._blue)

      # this will change
      $scope.frogs = spawn($scope._red, $scope._blue)

      # tell the container how much room we need
      # $scope.container.width = 130*$scope.frogs.length if $scope.container?

      # create a move list for current frog counts
      $scope.moves = new MoveList(
        [],
        void,
        $scope._red,
        $scope._blue
      )

      $scope.minMove = $scope._red*$scope._blue+$scope._red+$scope._blue
      $scope.done = false
      $scope.minimum = false
      $scope.showReplay = $scope.savedMoves.length > 0

      # cancel any moves that are outstanding
      # promises.forEach (p) -> $timeout.cancel p
      $scope.moves.list.forEach (d) -> $timeout.cancel d.promisedHop

    reset()

    # check whether frog states a and b are mirrored
    reversed = (a, b) ->
      a.every (d, i) ->
        mirrorx = a.length - d.x - 1
        d.colour == b[mirrorx].colour

    resetIfChanged = (newVal, oldVal) -> reset() if(newVal != oldVal)
    $scope.$watch "_red", resetIfChanged
    $scope.$watch "_blue", resetIfChanged

    $scope.reset = reset

    $scope.hop = (frog, space) ->
      #console.log frog.x, space.x

      # save the move
      $scope.moves.list.push {frogx: frog.x, spacex: space.x}

      # and swap places
      [frog.x, space.x] = [space.x, frog.x]

      # check for end
      $scope.done = reversed($scope.frogs, initialState)
      $scope.minimum = $scope.done && $scope.moves.list.length == $scope.minMove
      $scope.showReplay ||= $scope.done

    $scope.replay = (index = null) ->
      #console.log "replay(", index, ")"

      # replay saved moves if indicated, or the current moves
      if index?
        moves = $scope.savedMoves[index].clone()
      else
        moves = $scope.moves.clone()

      # reset before replay using saved frog counts
      $scope._red = moves.red
      $scope._blue = moves.blue
      reset()

      moves.list.forEach (d, i) ->
        # schedule each hop for playback, saving
        # the promises in case we have to cancel them
        d.promisedHop = $timeout ->
          frog = [f for f in $scope.frogs when f.x == d.frogx][0]
          space = [f for f in $scope.frogs when f.x == d.spacex][0]
          $scope.hop(frog, space)
        , 800*(i+0.2)

    newTag = ->
      "try " + ($scope.savedMoves.length + 1)

    $scope.save = ->
      saved = $scope.moves.clone()
      saved.tag = if $scope.moves.tag then $scope.moves.tag else newTag()
      $scope.moves.tag = void
      $scope.savedMoves.push(saved)

    $scope.forget = (index) ->
      $scope.savedMoves.splice(index, 1)

    $scope.clear = ->
      $scope.savedMoves = []
      reset()

]


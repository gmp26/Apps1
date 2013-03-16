angular.module('app').controller 'frogController', [
  '$scope'
  '$timeout'
  ($scope, $timeout) ->
    $scope._red = 2
    $scope._blue = 2

  	# spawn an array of frog objects containing colour and pad index
    spawn = (red,blue) ->
      [-red..blue].map (d,i) ->
      	colour: if d < 0 then 0 else if d == 0 then 1 else 2
      	x: i

    $scope.minMove = $scope._red*$scope._blue+$scope._red+$scope._blue
    doneState = []

    # promises stores timeouts that are currently playing
    promises = []

    reset = ->
      $scope.frogs = spawn($scope._red,$scope._blue)
      initialState = (d.colour for d in $scope.frogs)

      $scope.padIndexes = initialState.concat()
      doneState = initialState.concat().reverse()

      # create a move stack
      $scope.moves = []

      $scope.moveCount = 0
      $scope.minMove = $scope._red*$scope._blue+$scope._red+$scope._blue
      $scope.done = false
      $scope.minimum = false
      $scope.fewer = false

      # cancel any ongoing playback
      promises.forEach (d) -> $timeout.cancel(d)

    reset()

    equals = (a,b) ->
      a.length == b.length && a.every (aVal, i) -> aVal == b[i]

    $scope.$watch "_red", reset
    $scope.$watch "_blue", reset
    $scope.reset = reset

    $scope.hop = (frog, space) ->
      console.log frog.x, space.x
      # save the move
      $scope.moves.push
        frog: frog
        frogx: frog.x
        space: space
        spacex: space.x

      # and swap places
      [frog.x, space.x] = [space.x, frog.x]


    $scope.replay = ->
      console.log "replay"
      moves = $scope.moves.concat()
      reset()

      moves.forEach (d, i) ->
        promises.push $timeout ->
          $scope.hop(frog, space)
          frog.move(space)
        , 1000*(i+0.2)

    # savedMoves stores moves saved for later playback
    $scope.savedMoves = [0,1,2,3]

    ###
  	#
  	# no longer called
  	#
    swap = (x,y) ->
      temp = $scope.padIndexes[x]
      $scope.padIndexes[x] = $scope.padIndexes[y]
      $scope.padIndexes[y] = temp
      $scope.moveCount++
      $scope.done = equals($scope.padIndexes,doneState)
      if $scope.done == true && $scope.moveCount == $scope.minMove then $scope.minimum = true
      else if $scope.done == true && $scope.moveCount != $scope.minMove then $scope.fewer = true

    $scope.jump = (index) ->
      state = $scope.padIndexes[index]
      emptyPad = $scope.padIndexes.indexOf(1)
      diff = Math.abs(index - emptyPad)
      if diff == 1 or diff == 2 then swap(index, emptyPad)

    $scope.getFrog = (index) ->
      switch $scope.padIndexes[index]
        when 0 then "pad redfrog"
        when 1 then "pad"
        when 2 then "pad bluefrog"
        else throw new Error("invalid frog state")
     ###

]


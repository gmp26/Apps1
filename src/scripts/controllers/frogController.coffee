(angular.module 'app')
.controller('frogController', [
  '$scope'

($scope) ->
  $scope._red = 2
  $scope._blue = 2


  ### - coffeescript comprehension
  frog = (z) -> if z < 0 then 0 else if z == 0 then 1 else 2
  spawn = (red, blue) -> (frog(z) for z in [-red..blue])
  ###
  
  # javascript array handling 2
  frog = (z) -> if z < 0 then 0 else if z == 0 then 1 else 2
  spawn = (red,blue) -> [-red..blue].map frog

  ### javascript array handling 1
  spawn = (red,blue) ->
    [1..red].map(()-> 0).concat([1]).concat([1..blue].map(()-> 2))
  ###

  ### - simple loop
  spawn = (red,blue) ->
    ar = []
    i=0
    while i<red
      ar.push(0)
      ++i
    ar.push(1)
    i=0
    while i<blue
      ar.push(2)
      ++i
    return ar
  ###
  $scope.minMove = $scope._red*$scope._blue+$scope._red+$scope._blue
  doneState = []
  redraw = ->
    initialState = spawn($scope._red,$scope._blue)

    $scope.padIndexes = initialState.concat()
    doneState = initialState.concat().reverse()
    $scope.moveCount = 0
    $scope.minMove = $scope._red*$scope._blue+$scope._red+$scope._blue
  redraw()

  equals = (a,b) ->
    a.length == b.length && a.every (aVal, i) -> aVal == b[i]

  $scope.done = false

  swap = (x,y) ->
    temp = $scope.padIndexes[x]
    $scope.padIndexes[x] = $scope.padIndexes[y]
    $scope.padIndexes[y] = temp
    $scope.moveCount++
    $scope.done = equals($scope.padIndexes,doneState)
    console.log "done=", $scope.done

  $scope.$watch "_red", -> redraw()
  $scope.$watch "_blue", -> redraw()

  $scope.jump = (index) ->
    console.log("You clicked ", index)
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

])


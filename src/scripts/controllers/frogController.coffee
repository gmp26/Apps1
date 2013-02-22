(angular.module 'app')
.controller('frogController', [
  '$scope'

($scope) ->
  initialState = [0,0,0,1,2,2,2]
  $scope.padIndexes = initialState.concat()
  doneState = initialState.concat().reverse()
  $scope.moveCount = 0

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


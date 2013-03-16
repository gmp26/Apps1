(angular.module 'app')
.controller('frogController', [
  '$scope'

($scope) ->
  $scope._red = 2
  $scope._blue = 2

  ###
  frog = (z) -> if z < 0 then {colour:0} else if z == 0 then {colour:1} else {colour:2}
  spawn = (red,blue) ->
    s = [-red..blue].map(frog)
    s.map (z, i) ->
      z.x = i
      return z
	###

	# spawn an array of frog objects containing colour and pad index
  spawn = (red,blue) ->
    [-red..blue].map (d,i) ->
    	colour: if d < 0 then 0 else if d == 0 then 1 else 2
    	x: i

  $scope.minMove = $scope._red*$scope._blue+$scope._red+$scope._blue
  doneState = []

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
  reset()

  equals = (a,b) ->
    a.length == b.length && a.every (aVal, i) -> aVal == b[i]

  $scope.$watch "_red", reset
  $scope.$watch "_blue", reset

  $scope.reset = reset

  $scope.hop = (frog, space) ->
    console.log frog.x, space.x
    t = frog.x
    frog.x = space.x
    space.x = t
    $scope.moves.push
    	frog: frog
    	from: frog.x
    	space: space
    	to: space.x    


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

])


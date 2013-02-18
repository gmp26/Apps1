(angular.module 'app')
.controller('frogController', [
  '$scope'

($scope) ->

	$scope.padIndexes = [0,1,2,3,4,5]

	$scope.jump = (index) ->
		console.log("You clicked ", index)

	$scope.getFrog = (index) ->
		if index < 3 then "pad redfrog" else "pad bluefrog"




	### copied from todoController

  $scope.todos = [
    text: "learn angular"
    done: true
  ,
    text: "build an angular app"
    done: false
  ]

  $scope.addTodo = () ->
    $scope.todos.push {
      text: $scope.todoText
      done: false
    }

    $scope.todoText = ""

  $scope.remaining = ->
    count = 0
    angular.forEach $scope.todos, (todo) ->
      count += (if todo.done then 0 else 1)

    count

  $scope.archive = ->
    oldTodos = $scope.todos
    $scope.todos = []
    angular.forEach oldTodos, (todo) ->
      $scope.todos.push todo  unless todo.done
	###

])


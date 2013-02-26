#abstract

angular.module('app')
.controller 'boomerangController', ($scope) ->
  
  $scope.x = 2
  $scope.y = 2

  $scope.smallTime = (x) -> 2*x

  $scope.largeTime = (x) -> 3*x

  $scope.smallIncome = (x) -> 8*x

  $scope.largeIncome = (x) -> 10*x

  $scope.decTime = (x,y) -> x + y

  $scope.carveTime = (x,y) -> @smallTime(x) + @largeTime(y)

  $scope.totalIncome = (x,y) -> @smallIncome(x) + @largeIncome(y)


  $scope.decTimeOK = (x,y) -> if 0 <= @decTime(x,y) <= 10 then "good" else "bad"

  $scope.carveTimeOK = (x,y) -> if 0 <= @carveTime(x,y) <= 24 then "good" else "bad"

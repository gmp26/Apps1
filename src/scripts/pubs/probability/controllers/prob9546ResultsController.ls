import prelude

angular.module('app').controller 'prob9546ResultsController', [
  '$scope'
  ($scope) ->
    console.log "results controller scope = #{$scope.$id}"

    $scope.spinnerConfigs = 
      goal1: # an array of spinner configurations
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \B
          "weight": 10
          "fill" : \#6af
        * "label": \B
          "weight": 10
          "fill" : \#4af

      goal2:
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \Y
          "weight": 10
          "fill" : \#fe2
        * "label": \B
          "weight": 10
          "fill" : \#6af
        * "label": \B
          "weight": 10
          "fill" : \#4af

    $scope.model =
      goal1: 1
      goal2: 1

    $scope.runOptions =
      repeats: 1
      delay: 1000
      parallel: false
      spinners: [ \goal1, \goal2 ]
      resultHandler: -> 
        console.log "resultHandled"

    $scope.summary = 
      wonByB:0
      wonByY:0
      drawn:0

    $scope.matches = []

    goalScorers =
      goal1: []
      goal2: []

    $scope.reset = ->
      $scope.matches = []
      goalScorers.goal1 = []
      goalScorers.goal2 = []

    logMatch = (goal1Scorer, goal2Scorer) ->
      yGoals = +(goal1Scorer == \Y) + +(goal2Scorer == \Y)
      bGoals = 2 - yGoals
      s = $scope.summary
      $scope.matches.unshift {
        number: @length
        goal1: goal1Scorer
        goal2: goal2Scorer
        score: "Y: #yGoals, B: #bGoals"
        result: switch yGoals
        | 0 => s.wonByB++; "B win"
        | 1 => s.drawn++; "draw"
        | 2 => s.wonByY++; "Y win"
      }

    # called by spinner when spin stops to log the result
    $scope.spinLog = (name, sectorIndex, label) ->
      goalScorers[name].push label
      lastx = goalScorers.goal1.length - 1
      if lastx == goalScorers.goal2.length - 1
        logMatch goalScorers.goal1[lastx], goalScorers.goal2[lastx]

]
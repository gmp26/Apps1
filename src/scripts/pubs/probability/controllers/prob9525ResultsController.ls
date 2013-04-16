angular.module('app').controller 'prob9525ResultsController', [
  '$scope'
  ($scope) ->
    console.log "results controller scope = #{$scope.$id}"

    $scope.spinnerConfigs =
      triggers:
        excuse:
          "T": \accuse
          "L": \alwaysA

      excuse: # an array of spinner configurations
        * "label": \T
          "weight": 10
          "fill" : \#6af
          
        * "label": \T
          "weight": 10
          "fill" : \#6af

        * "label": \T
          "weight": 10
          "fill" : \#6af

        * "label": \T
          "weight": 10
          "fill" : \#6af

        * "label": \T
          "weight": 10
          "fill" : \#6af
 
        * "label": \L
          "weight": 10
          "fill" : \#f88

      accuse:
        * "label": \A
          "weight": 10
          "fill" : \#fe2
        * "label": \B
          "weight": 10
          "fill" : \#4f6
        * "label": \B
          "weight": 10
          "fill" : \#4f6
        * "label": \B
          "weight": 10
          "fill" : \#4f6
        * "label": \B
          "weight": 10
          "fill" : \#4f6
        * "label": \B
          "weight": 10
          "fill" : \#4f6

      alwaysA:
        * "label": \A
          "weight": 10
          "fill" : \#fe2
        ...


    $scope.model =
      excuse: 0
      accuse: 0
      alwaysA: 0

    $scope.summary = {}
    $scope.lessons = []
    decisions = {}

    reset = ->
      $scope.summary :=
        LA:0
        LB:0
        LTotal:0
        TA:0
        TB:0
        TTotal:0
        ATotal:0
        BTotal:0
        Total:0
      $scope.lessons := []
      decisions :=
        excuse: []
        accuse: []
      $scope.model =
        excuse: 0
        accuse: 0

    $scope.$on "resetSpinners", reset

    # initial view setup
    reset()

    # view update
    logEncounter = (excuseResult, accuseResult) ->

      # ignore accuse spinner if lying
      if excuseResult == \L
        accuseResult = \A        

      s = $scope.summary
      number = $scope.lessons.length + 1
      abbrOutcome = excuseResult + accuseResult
      s[abbrOutcome]++
      if excuseResult == \T
        s.TTotal++
      else
        s.LTotal++
      if accuseResult == \A
        s.ATotal++
      else
        s.BTotal++
      s.Total++
       
      $scope.lessons.unshift {
        number: number
        excuse: excuseResult
        accuse: accuseResult
        outcome: abbrOutcome
      }

    # watch for single spinner settle events
    $scope.$on "spinDone", (event, name, sectorIndex, label) ->
      event.stopPropagation()
      decisions[name].push label unless name == \alwaysA

    # and all spinners finished
    $scope.$on "spinGroupDone", (event) ->
      event.stopPropagation()

      # update the view with this result
      lastx = decisions.excuse.length - 1
      if lastx == decisions.accuse.length - 1
        logEncounter decisions.excuse[lastx], decisions.accuse[lastx]

]
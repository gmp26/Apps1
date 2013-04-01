angular.module('app').controller 'sampleSpinController', [
  '$scope'
  ($scope) ->
    console.log "results controller scope = #{$scope.$id}"

    $scope.spinnerConfigs = 
      spin1: # an array of spinner configurations
        * "label": \r
          "weight": 10
          "fill" : \red
        * "label": \b
          "weight": 10
          "fill" : \blue
        * "label": \y
          "weight": 10
          "fill" : \yellow
        * "label": \g
          "weight": 10
          "fill" : \green
        * "label": \p
          "weight": 10
          "fill" : \pink
        * "label": \g
          "weight": 10
          "fill" : \grey

      spin2:
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
      spin1: 0
      spin2: 0

    $scope.reset = !->

    # called by spinner when spin stops to log the result
    $scope.spinLog = (name, sectorIndex, label) ->
      console.log "name [#sectorIndex] -> #label" 

]
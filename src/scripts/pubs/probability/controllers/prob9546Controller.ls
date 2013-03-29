angular.module('app').controller('prob9546Controller', [
  '$scope'
  '$timeout'
  ($scope, $timeout) ->

    t = 0

    #
    # Put into a spin configuration service!
    #


    /*
     * array of spin amounts
     */
    $scope.spinVar = 
      * spinning: false
        duration: 0
        turns: 0
        snapAngle: Math.PI/1000
        value: 0      # spin in radians
        random: 0      # value normalised to [0..1]
      * spinning: false
        duration: 0
        turns: 0
        snapAngle: Math.PI/1000
        value: 0      # spin in radians
        random: 0      # value normalised to [0..1]

    $scope.getSpinVar = (x) -> $scope.spinVar[x]

    /*
     * array of spinners
     */
    $scope.spinner =
      * spinVarIndex: 0
        resultx: 0
        results: []
        data:
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \beaver
            "weight": 10
            "fill" : \#6af
          * "label": \beaver
            "weight": 10
            "fill" : \#4af
      * spinVarIndex: 1
        resultx: 1
        results: []
        data:
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \yeti
            "weight": 10
            "fill" : \#fe2
          * "label": \beaver
            "weight": 10
            "fill" : \#6af
          * "label": \beaver
            "weight": 10
            "fill" : \#4af

])
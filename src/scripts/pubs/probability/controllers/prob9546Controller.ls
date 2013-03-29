angular.module('app').controller('prob9546Controller', [
  '$scope'
  '$timeout'
  'spinnerConfigs'
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
    totalWeight = (weights) ->
      weights.reduce (prev, d) ->
        prev + d.weight
      ,0

    normalise = (weights) ->
      total = totalWeight(weights)
      weights.forEach (d, i) ->
        d.probability = d.weight/total

    $scope.spinner.forEach (d, i) -> normalise(d.data)

    getResultAt = (weights, d, i) ->
      return i if d < 0 or i == weights.length or d <= (p = weights[i].probability)
      getResultAt(weights, d - p, i+1)

    saveResult = (spinVarIndex) ->
      #console.log "saveResult ", spinVarIndex
      $scope.spinner.forEach (d,i) ->
        if d.spinVarIndex == spinVarIndex
          spin = $scope.getSpinVar(spinVarIndex)
          d.result = spin.random
          randx = getResultAt d.data, spin.random, 0
          d.results.push(randx)
          console.log "result[",i,"]= ", d.data[randx].label

    $scope.getLabel = (value, spinner) ->
      spinner.result.label


    randomise = ->
      $scope.spinVar.forEach (d, i) ->
        d.duration = 1000*(1+Math.random())
        d.turns = Math.PI*(d.duration/50 + 2*Math.random())
        d.spinning = true

    $scope.msPerFrame = 20

    tween = (spin, t) ->
      spin.turns*(1-Math.exp(t*Math.log(spin.snapAngle)/spin.duration))

    # contains a $timeout promise if we are timing
    timing = null

    # repeatedly set the spinVars
    setSpinVars = ~>
      spinning = false
      t := t + $scope.msPerFrame

      $scope.spinVar.forEach (d, i) ->
        if d.spinning
          theta = (d.value = tween(d, t)) / (2*Math.PI)
          d.random = theta - Math.floor(theta)
          if (t < d.duration)
            spinning := true
          else
            d.spinning = false
            saveResult(i)

      # if someone is spinning, schedule another timeout
      if spinning
        timing := $timeout setSpinVars, $scope.msPerFrame, true
      else
        $timeout.cancel(timing)
        timing := null

    $scope.go = ->
      return unless timing == null
      t := 0
      randomise()
      setSpinVars()

])
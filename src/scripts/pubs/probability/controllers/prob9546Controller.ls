angular.module('app').controller('prob9546Controller', [
  '$scope'
  '$timeout'
  '$parse'
  'spinnerConfigs'
  ($scope, $timeout, $parse, spinnerConfigs) ->

    t = 0

    #
    # Put into a spin configuration service!
    #
    $scope.spinnerConfigs = spinnerConfigs


    $scope.model =
      goal1: 30
      goal2: 50

    $scope.addSpinner = (name, model) ->
      return unless spinnerConfigs[name]? && model?

      expr = $parse(model)
      spinState = 
        expr: expr
        spinning: false
        duration: 0
        turns: 0
        snapAngle: Math.PI/1000
        random: 0      # value normalised to [0..1]
      ($scope.spinState ?= []).push spinState

      config = spinnerConfigs[name]
      spinner =
        spinState: spinState
        resultx: 0
        results: []
        data: config.concat()
      normalise(spinner.data) 
      ($scope.spinner ?= []).push spinner
      return spinner.data

    totalWeight = (weights) ->
      weights.reduce (prev, d) ->
        prev + d.weight
      ,0

    normalise = (weights) ->
      total = totalWeight(weights)
      weights.forEach (d, i) ->
        d.probability = d.weight/total

    getResultAt = (weights, d, i) ->
      return i if d < 0 or i == weights.length or d <= (p = weights[i].probability)
      getResultAt(weights, d - p, i+1)

    saveResult = (spinState) ->
      #console.log "saveResult ", spinStateIndex
      $scope.spinner.forEach (d,i) ->
        if d.spinState == spinState
          d.result = spinState.random
          randx = getResultAt d.data, spinState.random, 0
          d.results.push(randx)
          console.log "result[",i,"]= ", d.data[randx].label

    $scope.getLabel = (value, spinner) ->
      spinner.result.label

    randomise = ->
      $scope.spinState.forEach (d, i) ->
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

      $scope.spinState.forEach (d, i) ->
        if d.spinning
          value = tween d, t
          d.expr.assign($scope, value)
          theta = value / (2*Math.PI)
          d.random = theta - Math.floor(theta)
          if (t < d.duration)
            spinning := true
          else
            d.spinning = false
            saveResult(d)

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
import prelude

angular.module('app').controller 'spinGroupController', [
  '$scope'
  '$timeout'
  '$parse'
  ($scope, $timeout, $parse) ->

    t = 0
    #
    # Add a spinner to the spin group.
    #
    # This is normally called by an in-scope d3Spinner element.
    #
    # Spinners have a spinState which binds arrow angle to a 
    # random model variable and determines whether it's spinning.
    #
    # They are configured by a named object provided by the 
    # apinnerConfigs service.
    #
    $scope.addSpinner = (name, model) ->

      config = $scope.spinnerConfigs[name]
      unless config? && model?
        throw new Error("undefined spinner #name and/or model #model")
 
      spinState = 
        expr: $parse(model)
        spinning: false
        duration: 0
        turns: 0
        snapAngle: Math.PI/1000
        random: 0      # model value normalised to [0..1]
      ($scope.spinStates ?= []).push spinState

      spinner =
        spinState: spinState
        name: name
        data: config.concat()
      normalise(spinner.data) 
      ($scope.spinner ?= []).push spinner
      return spinner

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
          #d.results.push(randx)
          $scope.$emit "spinDone", d.name, randx, d.data[randx].label
          console.log "result[",d.name,"]= ", randx, " -> ", d.data[randx].label

    startOneSpin = (spinState) ->
      spinState.duration = 1000*(1+Math.random())
      spinState.turns = Math.PI*(spinState.duration/50 + 2*Math.random())
      spinState.spinning = true

    startSpinners = ->
      $scope.spinStates.forEach (d) -> startOneSpin(d)

    $scope.msPerFrame = 20

    tween = (spin, t) ->
      spin.turns*(1-Math.exp(t*Math.log(spin.snapAngle)/spin.duration))

    # contains a $timeout promise if we are timing
    timing = null

    # repeatedly set the spinVars
    setSpinVars = ~>
      spinning = false
      t := t + $scope.msPerFrame

      $scope.spinStates.forEach (d) ->
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
        $scope.$emit "spinGroupDone"


    # Start spinners. 
    $scope.go = (spinState, options) ->
      return unless timing == null
      t := 0
      startSpinners()
      setSpinVars()

    $scope.sequence = (repeatCount) ->
      console.log "sequence #repeatCount"


]
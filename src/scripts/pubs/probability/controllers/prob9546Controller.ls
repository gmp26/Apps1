import prelude

angular.module('app').controller('prob9546Controller', [
  '$scope'
  '$timeout'
  '$parse'
  'spinnerConfigs'
  ($scope, $timeout, $parse, spinnerConfigs) ->

    console.log take 2, [1,2,3,4]

    t = 0

    #
    # Put into a spin configuration service!
    #
    $scope.spinnerConfigs = spinnerConfigs

    $scope.model =
      goal1: 30
      goal2: 50

    #
    # Spinners have a spinstate which binds arrow angle to a 
    # random model variable and determines whether it's spinning.
    #
    # They are configured by a named object provided by the 
    # apinnerConfigs service.
    #
    $scope.addSpinner = (name, model) ->
      return unless spinnerConfigs[name]? && model?

      spinState = 
        expr: $parse(model)
        spinning: false
        duration: 0
        turns: 0
        snapAngle: Math.PI/1000
        random: 0      # model value normalised to [0..1]
      ($scope.spinStates ?= []).push spinState

      config = spinnerConfigs[name]
      spinner =
        spinState: spinState
        resultx: 0
        results: []
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
          d.results.push(randx)
          console.log "result[",i,"]= ", d.data[randx].label

    $scope.getLabel = (value, spinner) ->
      spinner.result.label

    class SpinManager
      (spinState, options) ->
        @spinStates = if spinState then [].concat(spinState) else [].concat($scope.spinStates)

        # set up default values in this, 
        # then import any options to overwrite
        @repeats = 1
        @delay = 0
        @parallel = true
        @results = $parse($scope, "results")
        if options?
          import options
          

      # Start spinning specifying a location to store results in scope 
      start: (resultExpr) ->
        @results = $parse($scope, resultExpr)


    startSpin = (spinState, options) ->
      spinStates = if spinState? then [spinState] else $scope.spinStates
      spinStates.forEach (d) ->
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


    # Start spinners. NB spinners spin if their spinStates change. 
    # If no spinState is given, start all.
    # If spinState is an array, start just those in the array
    # if options.parallel, start all, but stagger by options.delay * i
    # if not parallel, spinner i+1 starts when spinner i finishes + options.delay
    # options.delay is milliseconds of stagger or gap between sequenced runs
    # options.repeats is a repeat count for the whole sequence
    # options.results is a $parsed accessor function for results in $scope 
    $scope.go = (spinState, options) ->
      return unless timing == null
      t := 0
      startSpin(spinState, options)
      setSpinVars()

])
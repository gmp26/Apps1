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


    repeats = 1
    sequential = false

    speedFactor = 1000

    startOneSpin = (spinState) ->
      spinState.duration = speedFactor*(1+Math.random())
      spinState.turns = Math.PI*(spinState.duration/50 + 2*Math.random())
      spinState.spinning = true

    startSpinners =  ->
      $scope.spinStates.forEach (d) -> startOneSpin(d)

    saveResult = (spinState) ->
      #console.log "saveResult ", spinStateIndex
      $scope.spinner.forEach (d,i) ->
        if d.spinState == spinState
          d.result = spinState.random
          randx = getResultAt d.data, spinState.random, 0
          #d.results.push(randx)
          $scope.$emit "spinDone", d.name, randx, d.data[randx].label
          console.log "result[",d.name,"]= ", randx, " -> ", d.data[randx].label

          # check whether we should start the next spinner
          if sequential && i+1 < $scope.spinStates.length
            t := 0
            startOneSpin $scope.spinStates[i+1]

    $scope.speedCheck = 
      value: false

    $scope.msPerFrame = 30

    $scope.change = ->
      speedFactor := if $scope.speedCheck.value then 100 else 1000
      $scope.spinStates.forEach (d) ->
        d.duration = speedFactor*(1+Math.random())
      console.log "$scope.speedCheck: #{$scope.speedCheck.value}" 

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

      # if someone is still spinning, schedule another timeout
      if spinning
        timing := $timeout setSpinVars, $scope.msPerFrame, true
      else
        $timeout.cancel timing
        timing := null
        $scope.$emit "spinGroupDone"
        if --repeats == 0
          $scope.$emit "spinRepeatsDone"
        else
          $scope.go repeats, sequential

    $scope.stop = ->
      event.stopPropagation()
      repeats := 1
      if timing
        $timeout.cancel timing
        timing := null

    $scope.reset = ->
      $scope.stop()
      $scope.$emit "resetSpinners"

    /*
    # Start spinners. 
    $scope.go = ->
      return unless timing == null
      t := 0
      repeats := 1
      startSpinners()
      setSpinVars()
    */

    $scope.go = (repeatCount = 1, sequence = true) ->
      console.log "sequence #repeatCount"
      return unless timing == null
      t := 0
      repeats := repeatCount
      sequential := sequence
      if sequential
        startOneSpin $scope.spinStates[0]
      else
        startSpinners()
      setSpinVars()

    # Start a run where each spinner in the group
    # starts after the previous has settled
    $scope.goSeq = (repeatCount = 1) ->
      $scope.go repeatCount, true

    # Start a run where all spinners start at same time
    $scope.goPar = (repeatCount = 1) ->
      $scope.go repeatCount, false

    getSpinnerByName = (name) ->
      sps = $scope.spinner.filter (.name == name)
      if sps.length > 0 then sps[0] else void

    # Remove a sector from the spinner
    $scope.delArc = (name, label)->
      return if timing or repeats > 1
      spinner = getSpinnerByName(name)
      if spinner
        arcIndex = -1
        return if spinner.data.length < 2
        foundLabels = 0
        spinner.data.forEach (d,i) ->
          if d.label==label
            foundLabels++
            if arcIndex < 0
              arcIndex := i
        if arcIndex >= 0 && foundLabels > 1
          spinner.data.splice arcIndex, 1
          normalise(spinner.data)
          spinner.data.forEach (d)->
            console.log d.label, " ", d.probability
          $scope.$broadcast "resize"

    # Add a sector to the spinner
    $scope.addArc = (name, label)->
      return if timing or repeats > 1
      spinner = getSpinnerByName(name)
      if spinner
        arcIndex = -1
        addItem = null
        return if spinner.data.length > 19
        spinner.data.forEach (d,i) ->
          if arcIndex < 0 && d.label==label
            arcIndex := i
            addItem := angular.copy d
        if arcIndex >= 0
          spinner.data.splice arcIndex, 0, addItem
          normalise(spinner.data) 
          spinner.data.forEach (d)->
            console.log d.label, " ", d.probability
          $scope.$broadcast "resize"
]
(angular.module 'app')
.controller 'mathmoController', [
  '$scope'
  '$window'
  'config'
  'questionStore'
  '$timeout'
  '$routeParams'
  '$location'
  ($scope, $window, config, qStore, $timeout, $routeParams, $location) ->

    #
    # Exercise tab panes
    #
    $scope.panes = []

    #
    # topic group selection
    #
    $scope.groups = config.groups

    #
    # question store
    #
    $scope.qStore = qStore

    #
    # maker functions return this when the answer is a graph sketch
    #
    gPrefix = '%GRAPH%'

    #
    # question seeding
    #
    topicCounts = {}
    startQNumber = 1000

    #
    # shared topics are ExerciseName:TopicId:QNo
    # other topics consist solely of the TopicId
    #
    topicParts = (topic) -> topic.split \:
    isShared = (parts) -> parts.length == 3
    sharedTopicId = (parts) -> parts[0]
    sharedQNo = (parts) -> parts[1]
    sharedExercise = (parts) -> parts[2]


    $scope.renderMath = ->
      $timeout ->
        MathJax.Hub.Queue ["Typeset", MathJax.Hub]
      , 10

    retrieveQ = (topicId, pane) ->

      name = pane.name
      qNo = startQNumber

      # some questions may have 2 or 3 part ids
      parts = topicId.split \:
      if parts.length == 2
        [topicId, qNo] = parts
        qNo = +qNo
      else
        if parts.length == 3
          [topicId, qNo, name] = parts
          qNo = +qNo

      topicCounts[name] ||= {}
      topicCounts[name][topicId] = qNo


      seed = name+'/'+topicId+'/'+topicCounts[name][topicId]

      console.log "seed = #seed"

      Math.seedrandom seed

      maker = config.topicMakerById topicId
      qa = maker()

      console.log "q=", qa[0]
      console.log "a=", qa[1]

      path = if ('' + $location.port() == '80') then '/mathmoApp' else ''

      question = {
        exName: name
        topicId: topicId
        topic: config.topicTitleById topicId
        seed: seed
        url: 'http://' + $location.host() + ':' + $location.port() + path + '/#/mathmo/share/' + seed
        graph: if maker.fn? then maker.fn.toString() else 'no fn'
        q:qa[0]
        a:qa[1]
        f:qa[2]
        g:qa[3]
        isCollapsed: true
        toggle: ->
          @isCollapsed = !@isCollapsed
        isGraph: ->
          if @a.indexOf(gPrefix) == 0 then 'graph' else 'html'
      }
      question.graphData = qa[2](qa[3]) if question.isGraph()=='graph'
      pane.questions.push question
      $scope.renderMath()


    # testQ is a stripped out version of retrieveQ that gets called in unit testing
    $scope.testQ = (topicId, qNo = 1) ->

      name = "unit-test"

      # some questions may have 2 or 3 part ids
      parts = topicId.split \:
      if parts.length == 2
        [topicId, qNo] = parts
        qNo = +qNo
      else
        if parts.length == 3
          [topicId, qNo, name] = parts
          qNo = +qNo

      topicCounts[name] ||= {}

      seed = name+'/'+topicId+'/'+qNo

      Math.seedrandom seed

      maker = config.topicMakerById topicId
      qa = maker()

      [qa[0], qa[1]]

    similarQ = (question, inc) ->
      name = question.exName
      topicId = question.topicId

      topicCounts[name] ||= {}
      topicCounts[name][topicId] ||= startQNumber

      j = (topicCounts[name][topicId] += inc)

      qStore.updateQ(name, topicId, j)
      seed = name+'/'+topicId+'/'+j

      console.log "similar seed = #seed"

      Math.seedrandom seed

      maker = config.topicMakerById topicId
      qa = maker()

      console.log "q=", qa[0]
      console.log "a=", qa[1]

      question.graph = if maker.fn? then maker.fn.toString() else 'no fn'
      question.url = $location.absUrl() + '/' + seed
      question.seed = seed
      question.q = qa[0]
      question.a = qa[1]
      question.f = qa[2]
      question.g = qa[3]
      question.graphData = qa[2](qa[3]) if question.isGraph()=='graph'

      $scope.renderMath()

    $scope.prevOnTopic = (qa) ->
      similarQ(qa, -1)

    $scope.nextOnTopic = (qa) ->
      similarQ(qa, +1)

    $scope.topicAvailable = (topicId) ->
      pane = $scope.activePane
      return not topicCounts[pane.name]?[topicId]?

    $scope.appendQ = (topicId, pane = null) ->
      if pane == null
        pane = $scope.activePane
      qStore.appendQ pane.name, topicId
      retrieveQ(topicId, pane)

    qStore.list().forEach (name) ->
      p = {
        name: name
        qSet: qStore.getQSet(name)
        questions: []
        active: false
      }
      $scope.panes.push p

      p.qSet.forEach (topicId) ->
        retrieveQ topicId, p unless (topicId.split \:).length == 3

    $scope.exercise = {name:""}

    $scope.addQSet = (name = $scope.exercise.name) ->
      if qStore.getQSet name
        return ($scope.panes.filter (.name == name))[0]
      pane = {
        name: name
        qSet: qStore.newQSet(name)
        questions: []
        active: true
      }
      $scope.panes.push pane
      $scope.exercise.name = "" if name == $scope.exercise.name
      return pane

    $scope.delQSet = (paneIndex) ->
      pane = $scope.panes[paneIndex]
      qStore.remove(pane.name)
      $scope.panes.splice paneIndex, 1
      delete topicCounts[name]

    $scope.clearAll = ->
      qStore.clear()
      $scope.panes = []
      topicCounts := {}

    $scope.topicTitleById = (id) -> config.topicById(id)[0]

    #
    # Set up share tab to view shared Qs
    #
    addSharingTab = ($routeParams) ->

      # Parse the url route parameters
      cmd = null
      ex = null
      topic = null
      qNo = 0
      if $routeParams
        $scope.resourceId = $routeParams.id ? 7088
        $scope.single = $routeParams.users != "class"
        if $routeParams.cmd?
          cmd = $routeParams.cmd
        if $routeParams.x?
          ex = $routeParams.x
        if $routeParams.t?
          topic = $routeParams.t
        if $routeParams.q?
          qNo = +$routeParams.q

        # if we have a shared question in the url
        switch cmd
        case 'help'
          help = angular.element 'helpTab'
          help.active = true

        case 'share'
          if ex && topic && !isNaN(qNo)

            # create a shared pane unless it already exists
            pane = $scope.addQSet('shared')

            pane.active = true

            # append the shared question to it unless it already exists
            # note that the full form of a topic is TopicId[:qNo:ExerciseName]
            topicId = "#{topic}:#{qNo}:#{ex}"
            if (pane.qSet.indexOf(topicId) < 0)
              $scope.appendQ topicId, pane

            # now retrieve any previously shared questions, suppressing any
            pane.qSet.forEach (topic) ->
              retrieveQ topic, pane


    #
    # set up sharing tab if needed
    #
    addSharingTab($routeParams)

    #
    # Sharing dialog
    #
    $scope.openShare = (qa) ->
      $scope.currentQuestion = qa
      $scope.shareOpen = true
      $scope.shareText = '#mathmo #nrichmaths Working on '+qa.url

    $scope.closeShare = -> $scope.shareOpen = false;

    $scope.shareOpts =
      backdropFade: true
      dialogFade:true

    $scope.encodeURI = $window.encodeURIComponent

    #
    # About dialog
    #
    $scope.openAbout = -> $scope.aboutOpen = true
    $scope.closeAbout = -> $scope.aboutOpen = false;

    $scope.aboutOpts =
      backdropFade: true
      dialogFade:true

    #
    # AddQ dialog
    #
    $scope.openAddQ = (pane) ->
      $scope.activePane = pane
      $scope.addQOpen = true

    $scope.closeAddQ = ->
      $scope.addQOpen = false

    $scope.addQOpts =
      backdropFade: true
      dialogFade:true

    # Control visibility of sketch warnings
    # Close box is a 'do not show me again'
    swarnings = true
    $scope.closeSketchWarning = ->
      swarnings := false

    $scope.showSketchWarning = -> swarnings
]


(angular.module 'app')
.controller 'mathmoController', [
  '$scope'
  '$window'
  'config'
  'questionStore'
  '$timeout'
  '$routeParams'
  ($scope, $window, config, qStore, $timeout, $routeParams) ->

    $scope._exName = null
    $scope._topic = null
    $scope._qNo = 0

    if $routeParams
      $scope.resourceId = $routeParams.id ? 7088
      $scope.single = $routeParams.users != "class" 
      if $routeParams.ex?
        $scope._exName = $routeParams.x
      if $routeParams.topic?
        $scope._topic = $routeParams.t
      if $routeParams.qNo?
        $scope._qNo = $routeParams.q


    $scope.renderMath = ->
      $timeout ->
        MathJax.Hub.Queue ["Typeset", MathJax.Hub]
      , 10

    #
    # topic group selection
    #
    $scope.groups = config.groups

    #
    # Exercise tab panes
    #
    $scope.panes = []

    $scope.qStore = qStore

    gPrefix = '%GRAPH%'

    retrieveQ = (topicId, pane) ->
      name = pane.name
      Math.seedrandom(name+topicId+pane.questions.length)
      maker = config.topicMakerById topicId
      qa = maker()

      console.log "q=", qa[0]
      console.log "a=", qa[1]

      pane.questions.push {
        topic: config.topicById(topicId)[0]
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
        graphData: ->
          @f(@g)
      }
      $scope.renderMath()
    
    $scope.appendQ = (topicId, pane = null) ->
      if pane == null
        pane = $scope.activePane
      qStore.appendQ pane.name, topicId
      retrieveQ(topicId, pane)
     
    qStore.list().forEach (name) ->
      p = {
        name: name
        qStore: qStore.getQSet(name)
        questions: []
        active: false
      }
      $scope.panes.push p

      p.qStore.forEach (topicId) ->
        retrieveQ topicId, p    

    $scope.newData = {name:""}

    $scope.addQSet = ->
      $scope.panes.push {
        name: $scope.newData.name
        qStore: qStore.newQSet($scope.newData.name)
        questions: []
        active: true
      }
      $scope.newData.name = ""

    $scope.delQSet = (paneIndex) ->
      pane = $scope.panes[paneIndex]
      qStore.remove(pane.name)
      $scope.panes.splice paneIndex, 1

    $scope.clearAll = ->
      qStore.clear()
      $scope.panes = []

    $scope.topicTitleById = (id) -> config.topicById(id)[0]


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

    swarnings = true
    $scope.closeSketchWarning = ->
      swarnings := false

    $scope.showSketchWarning = -> swarnings
]


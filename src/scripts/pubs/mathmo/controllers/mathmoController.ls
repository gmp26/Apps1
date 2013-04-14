(angular.module 'app')
.controller 'mathmoController', [
  '$scope'
  '$window'
  'config'
  'questionStore'
  '$timeout'

  ($scope, $window, config, qStore, $timeout) ->


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
    $scope.panes = {}

    $scope.qStore = qStore


    retrieveQ = (topicId, pane) ->
      name = pane.name
      Math.seedrandom(name+topicId+pane.questions.length)
      maker = config.topicMakerById topicId
      qa = maker()
      console.log "q=", qa[0]
      console.log "a=", qa[1]
      pane.questions.push {
        topic: config.topicById(topicId)[0]
        q:qa[0]
        a:qa[1]
        isCollapsed: true
        toggleText: "Show answer"
        toggle: ->
          @isCollapsed = !@isCollapsed
          @toggleText = (if @isCollapsed then "Show" else "Hide") + " answer"
      }
      $scope.renderMath()
     
    $scope.appendQ = (topicId, pane = null) ->
      if pane == null
        pane = $scope.activePane
      qStore.appendQ pane.name, topicId
      retrieveQ(topicId, pane)
     
    qStore.list().forEach (name) ->
      p = $scope.panes[name] = 
        name: name
        qStore: qStore.getQSet(name)

      p.questions = []

      p.qStore.forEach (topicId) ->
        retrieveQ topicId, p    

    $scope.newName = ""

    $scope.addQSet = ->
      $scope.panes[$scope.newName] =
        name: $scope.newName
        qStore: qStore.newQSet($scope.newName)
        questions: []
        active: true
      $scope.newName = ""

    $scope.delQSet = (name) ->
      qStore.remove(name)
      delete $scope.panes[name]

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

]


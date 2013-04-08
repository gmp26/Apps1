(angular.module 'app')
.controller 'mathmoController', [
  '$scope'
  '$window'
  'config'

  ($scope, $window, config) ->

    #
    # topic group selection
    #
    $scope.groups = config.groups

    $scope.questions = []

    #topicById = (id) -> config.topics[id]
    #topicMakerById = (id) -> topicById(id)[1]

    $scope.topicTitleById = (id) -> config.topicById(id)[0]

    $scope.getQA = (id) ->
      maker = config.topicMakerById id
      qid = Math.random()
      $scope.questions.push maker.call this


    #
    # Local storage test
    #
    localStore = $window.localStorage
    save = (key, value) -> localStore[key] = value
    restore = (key) -> localStore[key]
    #console.log "Saving foo=bar"
    #save "foo", "bar"
    console.log "Restoring foo =", restore "foo"

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
    $scope.openAddQ = -> $scope.addQOpen = true
    $scope.closeAddQ = -> $scope.addQOpen = false;
    $scope.addQOpts =
      backdropFade: true
      dialogFade:true

]


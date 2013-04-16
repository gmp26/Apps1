angular.module('app').factory 'questionStore', [
  '$window'
  'semver'
  ($window, semver) ->

    localStore = $window.localStorage

    # Clear the question store
    # NB we store question topicIds and seeds, trusting that
    # given the same seed we can regenerate the same question.
    #
    # We store the mathmo version number in case a future version needs
    # to update the stored data
    #
    clear = ->
      localStore.qSets = JSON.stringify {mathmo:semver}

    # constructor
    init = ->
      try
        qSets = JSON.parse @localStore.qSets
      catch e
        qSets = {}

      # clear it unless it's already initialised for mathmo
      clear() unless qSets?.mathmo

    init()

    # append a question
    appendQ = (name, topicId) ->
      qSets = JSON.parse localStore.qSets
      qSets = {} unless angular.isObject qSets
      qSets[name].push topicId
      localStore.qSets = JSON.stringify qSets

    # Save this question set in local storage by name
    # We have to serialise and deserialise using JSON
    # since localStorage only saves strings.
    saveAs = (name, topicIds) ->
      qSets = JSON.parse localStore.qSets
      qSets = {} unless angular.isObject qSets
      qSets["mathmo"] = semver
      qSets[name] = topicIds
      localStore.qSets = JSON.stringify qSets

    newQSet = (name) ->
      saveAs(name, [])

    getQSet = (name) ->
      qSets = JSON.parse localStore.qSets
      return qSets[name]

    # forget about a saved question set
    remove = (name) -> 
      qSets = JSON.parse localStore.qSets
      delete qSets[name]
      localStore.qSets = JSON.stringify qSets

    # list all stored qSets by name
    list = ->
      qSets = JSON.parse localStore.qSets
      [name for name of qSets when name != 'mathmo']

    return
      init: init
      clear: clear
      appendQ: appendQ
      saveAs: saveAs
      newQSet: newQSet
      getQSet: getQSet
      remove: remove
      list: list

]
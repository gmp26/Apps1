angular.module('app').factory 'shareStore', [
  '$window'
  'semver'
  ($window, semver) ->

    localStore = $window.localStorage

    # Clear the shared store
    #
    # All data is stored in localStore.shared - keyed by exercise name.
    #
    # NB we store question topicIds and seeds, trusting that
    # given the same seed we can regenerate the same question.
    #
    # We store the mathmo version number in case a future version needs
    # to update the stored data
    #
    clear = ->
      localStore.shared = JSON.stringify {mathmo:semver}

    # constructor
    init = ->
      try
        shared = JSON.parse localStore.shared
      catch e
        shared = {}

      # clear it unless it's already initialised for mathmo
      if not shared? or not shared.mathmo
        clear()

    init()

    # append a question
    appendQ = (name, topicId) ->
      shared = JSON.parse localStore.shared
      shared = {} unless angular.isObject shared
      shared[name].push topicId
      localStore.shared = JSON.stringify shared

    # Save this question set in local storage by name
    # We have to serialise and deserialise using JSON
    # since localStorage only saves strings.
    saveAs = (name, topicIds) ->
      shared = JSON.parse localStore.shared
      shared = {} unless angular.isObject shared
      shared["mathmo"] = semver
      shared[name] = topicIds
      localStore.shared = JSON.stringify shared

    newShared = (name) ->
      saveAs(name, [])

    getShared = (name) ->
      shared = JSON.parse localStore.shared
      return shared[name]

    # forget about a saved question set
    remove = (name) -> 
      shared = JSON.parse localStore.shared
      delete shared[name]
      localStore.shared = JSON.stringify shared

    # list all stored shared by name
    list = ->
      shared = JSON.parse localStore.shared
      [name for name of shared when name != 'mathmo']

    return
      init: init
      clear: clear
      appendQ: appendQ
      saveAs: saveAs
      newShared: newShared
      getShared: getShared
      remove: remove
      list: list

]
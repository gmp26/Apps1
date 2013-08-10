angular.module('app').factory 'questionStore', [
  '$window'
  'semver'
  ($window, semver) ->

    localStore = $window.localStorage

    # Clear the question store
    #
    # All data is stored in localStore.qSets - keyed by exercise name.
    #
    # NB we store question topicIds and seeds, trusting that
    # given the same seed we can regenerate the same question.
    #
    # We store the mathmo version number in case a future version needs
    # to update the stored data
    #

    save = (qSets) -> 
      localStore.setItem "qSets", JSON.stringify qSets

    load = -> JSON.parse localStore.getItem "qSets"

    clear = ->
      localStore.setItem "qSets", JSON.stringify {mathmo:semver}

    # constructor
    init = ->
      try
        qSets = load!
      catch e
        qSets = {}

      # clear it unless it's already initialised for mathmo
      if not qSets? or not qSets.mathmo
        clear()

    init()

    # append a question
    appendQ = (name, topicId) ->
      qSets = load!
      qSets = {} unless angular.isObject qSets
      qSets[name].push topicId
      save(qSets)

    # update a question number after prev or next
    updateQ = (name, topicId, qNo) ->
      qSets = JSON.parse localStore.getItem "qSets"
      set = qSets[name]
      if set
        # copy the exercise, while editing qNo for question at topicId
        qSets[name] = set.map (q) ->
          if q.indexOf(topicId) == 0
            parts = q.split \:
            parts[1] = qNo
            q = parts.join \:
          return q
        save(qSets)

    # Save this question set in local storage by name
    # We have to serialise and deserialise using JSON
    # since localStorage only saves strings.
    saveAs = (name, topicIds) ->
      qSets = JSON.parse localStore.getItem "qSets"
      qSets = {} unless angular.isObject qSets
      qSets["mathmo"] = semver
      qSets[name] = topicIds
      save(qSets)
      return topicIds

    newQSet = (name) ->
      return saveAs(name, [])

    getQSet = (name) ->
      qSets = JSON.parse localStore.getItem "qSets"
      return qSets[name]

    # forget about a saved question set
    remove = (name) -> 
      qSets = JSON.parse localStore.getItem "qSets"
      delete qSets[name]
      save(qSets)

    # list all stored qSets by name
    list = ->
      qSets = JSON.parse localStore.getItem "qSets"
      [name for name of qSets when name != 'mathmo']

    return
      init: init
      clear: clear
      appendQ: appendQ
      updateQ: updateQ
      saveAs: saveAs
      newQSet: newQSet
      getQSet: getQSet
      remove: remove
      list: list

]
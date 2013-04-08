#
# This depends on lib/seedrandom.js for a seedable monkey patch of Math.random() 
#
angular.module('app').factory 'questionSet',
  'config'
  '$window'
  (config, $window) ->

    localStore = $window.localStorage
    localStore.qSets = [] if localStore.qSets?

    class QSet
      ->
        @topics = []
        @deletes = {}
        @seed = Math.random()

      /*
       * Append a new question on a topic
       */
      appendTopicId: (topicId) -> @topics.push topicId

      /*
       * Delete a question. Deletions suppress QA output, but not QA generation.
       * We must go through the motions for every QA to ensure 
       * Math.random always generates the same sequence.
       */
      deleteTopicId: (topicId) -> @deletes[topicId] = true

      /*
       * Restore all deleted questions
       */
      undeleteAll: -> @deletes = {}

      /*
       * save this question set in local storage keyed on name
       */
      save: (name) ->
        @date = new Date()
        value = localStore.qSets[name]
        if value && name != "" && !overwrite
          throw new Error("Question set #\name already exists")
        localStore.qSets[name] = @ if angular.isString(name) and name.length > 0

      /*
       * forget named question set
       */
      remove = (name) -> localStore.qSets[name] = void

      /*
       * list all stored qSets by name
       */
      list: -> [[name, qSet.date] for name, qSet of localStore.qSets]

      /*
       * get all QA pairs by regenerating them from the original seed
       */
      getQAs: ->
        Math.random(@seed)
        QAs = []
        @topics.forEach (id) ->
          maker = config.topicMakerById(id)
          QAs.push maker() unless @deletes[id]? 
        return QAs
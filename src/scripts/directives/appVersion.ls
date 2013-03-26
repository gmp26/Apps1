angular.module('app').directive 'appVersion', ['semver', (semver) ->

  (scope, elm, attrs) ->
    elm.text(semver)
]
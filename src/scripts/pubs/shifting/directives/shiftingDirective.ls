angular.module('app').directive 'shiftingDirective', [
  '$timeout'
  ($timeout) ->
    restrict: 'EA'
    link: (scope, element, attrs) ->
      console.log 'shiftingDirective'
]

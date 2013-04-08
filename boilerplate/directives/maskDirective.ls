angular.module('app').directive '<%= mask %>Directive', [
  '$timeout'
  ($timeout) ->
    restrict: 'EA'
    link: (scope, element, attrs) ->
      console.log '<%= mask %>Directive'
]

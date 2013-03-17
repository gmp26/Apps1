angular.module('app').directive 'svgCheck',
[
  '$timeout', '$window'
  ($timeout, $window) ->

    restrict: 'A'
    templateUrl: 'src/views/directives/svgCheck.html'
    replace: false
    transclude: true

    link: (scope, element, attrs) ->

      # check that browser is SVG capable.
      scope.svgOK = $window.document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1")
      console.log("svgCheck scope = ", scope.$id)
]
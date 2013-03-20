angular.module('app').directive('svgCheck', [
  '$timeout', '$window', function($timeout, $window) {
    return {
      restrict: 'A',
      templateUrl: 'src/views/directives/svgCheck.html',
      replace: false,
      transclude: true,
      link: function(scope, element, attrs) {
        scope.svgOK = $window.document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
        return console.log("svgCheck scope = ", scope.$id);
      }
    };
  }
]);

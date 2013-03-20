angular.module("app").directive("stepper", [
  '$compile', '$timeout', function($compile, $timeout) {
    return {
      template: '<input type="number" min="0">',
      replace: true,
      restrict: 'E',
      scope: {
        name: '@',
        val: '@'
      },
      link: function(scope, element, attrs) {
        console.log("A transcluded link function maybe?");
        element.attr('ng-model', attrs.name);
        element.attr('ng-init', attrs.name + '=' + attrs.val);
        $compile(element)(scope);
        return $timeout(function() {
          return scope.$digest();
        });
      }
    };
  }
]);

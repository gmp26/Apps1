angular.module('app').directive('frogs', [
  '$window', function($window) {
    return {
      template: '<div frog ng-repeat="frog in frogs"></div>',
      replace: false,
      link: function(scope, element, attrs) {
        var rescale, resizeHandler, win;

        rescale = function(winSize, padCount) {
          var zoom;

          zoom = winSize / (130 * padCount);
          return element.css("zoom", zoom);
        };
        resizeHandler = function(event) {
          return rescale($window.innerWidth, scope.frogs.length);
        };
        scope.$watch('frogs', function(val) {
          return rescale($window.innerWidth, val.length);
        });
        win = angular.element($window);
        return win.bind("resize", resizeHandler);
      }
    };
  }
]);

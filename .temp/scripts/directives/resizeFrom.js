angular.module('app').directive('resizeFrom', [
  '$window', function($window) {
    return {
      link: function(scope, element, attr) {
        /*
        			#
        			# Almost working but behaves strangely around iPad - desktop transition
        			#
        */

        var rescale, resizeHandler, win, woff, _ref, _ref1;

        win = angular.element($window);
        if ((_ref = scope.container) == null) {
          scope.container = {};
        }
        scope.container.width = 3 * ((_ref1 = $window.innerWidth) != null ? _ref1 : 400) / 4;
        console.log("container.width = ", scope.container.width);
        woff = 20;
        attr.$observe('woff', function(val) {
          woff = ~~val;
          if (woff === 0 || isNaN(woff)) {
            return woff = 20;
          }
        });
        scope.$watch(attr.resizeFrom, function(val) {
          var w;

          console.log("resizeFrom = ", val);
          w = ~~val;
          if (!isNaN(w)) {
            scope.container.width = Math.max(300, w);
          }
          element.css("width", w + "px");
          return rescale($window.innerWidth);
        });
        rescale = function(winSize) {
          var zoom;

          zoom = (winSize - woff) / scope.container.width;
          console.log("winsize-woff/container=zoom", winSize - woff, "/", scope.container.width, "=", zoom);
          return element.css("zoom", zoom);
        };
        resizeHandler = function() {
          scope.$apply(function() {
            return console.log("resize $window.innerWidth = ", $window.innerWidth);
          });
          return rescale($window.innerWidth);
        };
        scope.$watch('container.width', function(val) {
          console.log("container.width =", val);
          element.css("width", val + "px");
          return rescale($window.innerWidth);
        });
        return win.bind("resize", resizeHandler);
      }
    };
  }
]);

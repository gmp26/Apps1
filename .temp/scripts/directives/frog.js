angular.module('app').directive('frog', [
  '$timeout', function($timeout) {
    return {
      restrict: 'EA',
      link: function(scope, element, attrs) {
        var X, classBy, jump;

        X = function(x) {
          return 100 * x + "px";
        };
        scope.frog.move = function(space) {
          element.css("left", X(this.x));
          element.css("z-index", 1);
          return space.element.css("left", X(space.x));
        };
        jump = function(me) {
          return scope.$apply(function() {
            var diff, emptyPad;

            emptyPad = (scope.frogs.filter(function(d) {
              d.element.css("z-index", 0);
              return d.colour === 1;
            }))[0];
            diff = Math.abs(me.x - emptyPad.x);
            if (diff === 1 || diff === 2) {
              scope.hop(me, emptyPad);
              return me.move(emptyPad);
            }
          });
        };
        classBy = function(colour) {
          switch (colour) {
            case 0:
              return "frog red";
            case 1:
              return "frog";
            case 2:
              return "frog blue";
            default:
              throw new Error("invalid frog colour");
          }
        };
        element.addClass(classBy(scope.frog.colour));
        element.css("left", X(scope.frog.x));
        element.bind("click", function(event) {
          return jump(scope.frog);
        });
        scope.frog = scope.frog;
        return scope.frog.element = element;
      }
    };
  }
]);

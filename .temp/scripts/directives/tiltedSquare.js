angular.module('app').directive('tiltedSquare', [
  '$timeout', function($timeout) {
    var directiveDef;

    return directiveDef = {
      scope: {
        along: '@',
        down: '@',
        spacing: '@',
        radius: '@',
        color: '@',
        fill: '@',
        ax: '@',
        ay: '@',
        bx: '@',
        by: '@'
      },
      restrict: 'A',
      templateUrl: '/views/directives/tiltedSquare.html',
      replace: true,
      link: function(scope, element, attrs) {
        var COL, LEFT, ROW, TOP, draw, makeDot, makeGridDots, makeSquare, squareDots;

        attrs.$observe('along', function(val) {
          return scope.along = ~~val || 10;
        });
        attrs.$observe('down', function(val) {
          return scope.down = ~~val || 10;
        });
        attrs.$observe('spacing', function(val) {
          return scope.spacing = ~~val || 50;
        });
        attrs.$observe('radius', function(val) {
          return scope.radius = ~~val || 5;
        });
        attrs.$observe('color', function(val) {
          return scope.color = val || '#a04';
        });
        attrs.$observe('fill', function(val) {
          return scope.fill = val || '#c66';
        });
        attrs.$observe('ax', function(val) {
          return scope.ax = ~~val || 2;
        });
        attrs.$observe('bx', function(val) {
          return scope.bx = ~~val || 6;
        });
        attrs.$observe('ay', function(val) {
          return scope.ay = ~~val || 9;
        });
        attrs.$observe('by', function(val) {
          return scope.by = ~~val || 8;
        });
        attrs.$observe('tiltedSquare', function(val) {
          return scope.tiltedSquare = val;
        });
        TOP = function(row) {
          return Math.round((row + 0.5) * scope.spacing - scope.radius / 2);
        };
        LEFT = function(col) {
          return Math.round((col + 0.5) * scope.spacing - scope.radius / 2);
        };
        ROW = function(top) {
          return Math.max(0, Math.min(scope.down - 1, Math.round((top + scope.radius / 2) / scope.spacing - 0.5)));
        };
        COL = function(left) {
          return Math.max(0, Math.min(scope.along - 1, Math.round((left + scope.radius / 2) / scope.spacing - 0.5)));
        };
        makeDot = function(col, row, options) {
          options.col = col;
          options.row = row;
          options.left = LEFT(col);
          options.top = TOP(row);
          return new fabric.Circle(options);
        };
        makeGridDots = function() {
          var col, dot, dots, row, _i, _j, _ref, _ref1;

          dots = [];
          for (row = _i = 0, _ref = scope.down - 1; _i <= _ref; row = _i += 1) {
            for (col = _j = 0, _ref1 = scope.along - 1; _j <= _ref1; col = _j += 1) {
              dot = makeDot(col, row, {
                debug: false,
                selectable: false,
                radius: scope.radius,
                fill: scope.color
              });
              dots.push(dot);
            }
          }
          return dots;
        };
        squareDots = function() {
          var a, b, c, d, dx, dy, _ref, _ref1, _ref2, _ref3;

          a = scope.fixedDot;
          b = scope.activeDot;
          if (!((0 <= (_ref = a.col) && _ref < scope.along) && (0 <= (_ref1 = a.row) && _ref1 < scope.down) && (0 <= (_ref2 = b.col) && _ref2 < scope.along) && (0 <= (_ref3 = b.row) && _ref3 < scope.down))) {
            throw new Error('control dots outside canvas');
          }
          dx = b.col - a.col;
          dy = b.row - a.row;
          c = {
            col: b.col + dy,
            row: b.row - dx
          };
          d = {
            col: c.col - dx,
            row: c.row - dy
          };
          return [a, b, c, d];
        };
        makeSquare = function(dots) {
          var dot, points;

          points = (function() {
            var _i, _len, _results;

            _results = [];
            for (_i = 0, _len = dots.length; _i < _len; _i++) {
              dot = dots[_i];
              _results.push(new fabric.Point(LEFT(dot.col), TOP(dot.row)));
            }
            return _results;
          })();
          return new fabric.Polygon(points, {
            fill: scope.fill,
            opacity: 0.5,
            selectable: false
          });
        };
        draw = function() {
          var dot, _i, _len, _ref;

          if (scope.canvas != null) {
            return;
          }
          scope.canvas = new fabric.Canvas(attrs.tiltedSquare);
          angular.element().find('body').bind('touchmove', function(event) {
            return event.preventDefault().bind('scroll', function(event) {
              return console.log("scrolled");
            });
          });
          scope.canvas.selection = false;
          scope.$watch('down', function(newVal) {
            if (newVal > 0) {
              return scope.canvas.setHeight(scope.spacing * newVal);
            }
          });
          scope.$watch('along', function(newVal) {
            if (newVal > 0) {
              return scope.canvas.setWidth(scope.spacing * newVal);
            }
          });
          scope.fixedDot = makeDot(scope.ax, scope.ay, {
            selectable: true,
            radius: 25,
            fill: '#048',
            opacity: 0.5,
            hasControls: false,
            hasBorders: false
          });
          scope.activeDot = makeDot(scope.bx, scope.by, {
            selectable: true,
            radius: 25,
            fill: '#f00',
            opacity: 0.5,
            hasControls: false,
            hasBorders: false
          });
          scope.dots = makeGridDots();
          _ref = scope.dots;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            dot = _ref[_i];
            scope.canvas.add(dot);
          }
          scope.square = makeSquare(squareDots());
          scope.canvas.add(scope.square);
          scope.canvas.add(scope.fixedDot);
          scope.canvas.add(scope.activeDot);
          scope.canvas.on('object:moved', function(event) {
            return scope.canvas.calcOffset();
          });
          return scope.canvas.on('object:moving', function(event) {
            var left, top;

            dot = event.target;
            if (dot === scope.activeDot || dot === scope.fixedDot) {
              left = LEFT(dot.col = COL(dot.left));
              top = TOP(dot.row = ROW(dot.top));
              dot.setLeft(left);
              dot.setTop(top);
              squareDots().forEach(function(d, index) {
                var p;

                p = scope.square.points[index];
                p.x = LEFT(d.col);
                return p.y = TOP(d.row);
              });
              return scope.canvas.renderAll();
            }
          });
        };
        return $timeout(draw, 0);
      }
    };
  }
]);

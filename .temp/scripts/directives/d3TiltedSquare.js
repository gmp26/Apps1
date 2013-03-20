/*
 	Tilted Square in d3 using svg.

	This directive supplies the square with its controls,
	and it needs to sit inside a d3DotGrid which is itself
	inside a d3Vis.

	attributes:
  	ax, ay define the initial position of the control point A.
  	bx, by define the initial position of the control point B.
    The square appears to the left of edge AB when facing B from A.
    radius defines the radius of the control circles.

  styles:
  	see AppTiltedSquares.less
*/
angular.module('app').directive('d3TiltedSquare', [
  '$timeout', function($timeout) {
    return {
      restrict: 'A',
      scope: {
        ax: '@',
        ay: '@',
        bx: '@',
        by: '@',
        radius: '@'
      },
      link: function(scope, element, attrs) {
        scope.a = {};
        scope.b = {};
        scope.c = {};
        scope.d = {};
        scope.$watch('ax', function(val) {
          return scope.a.x = ~~val || 2;
        });
        scope.$watch('bx', function(val) {
          return scope.b.x = ~~val || 6;
        });
        scope.$watch('ay', function(val) {
          return scope.a.y = ~~val || 9;
        });
        scope.$watch('by', function(val) {
          return scope.b.y = ~~val || 8;
        });
        scope.$watch('radius', function(val) {
          return scope.radius = ~~val || 22;
        });
        scope.squareDots = function() {
          var dx, dy;

          dx = this.b.x - this.a.x;
          dy = this.b.y - this.a.y;
          this.c = {
            x: this.b.x + dy,
            y: this.b.y - dx
          };
          this.d = {
            x: this.c.x - dx,
            y: this.c.y - dy
          };
          console.log("square = ", [this.a, this.b, this.c, this.d]);
          return [this.a, this.b, this.c, this.d];
        };
        return scope.$on('dotGridUpdated', function(event, gridScope) {
          var drag, squareOutline;

          console.log('dotGridUpdated', gridScope);
          console.log('gridScope = ', gridScope.$id);
          squareOutline = d3.svg.line().x(function(d) {
            return gridScope.X(d.x);
          }).y(function(d) {
            return gridScope.Y(d.y);
          });
          drag = d3.behavior.drag().origin(function(d) {
            var origin;

            origin = {
              x: gridScope.X(d.x),
              y: gridScope.Y(d.y)
            };
            return origin;
          }).on("drag", function(d) {
            var _control, _x, _y;

            _control = d3.select(this).attr("cx", _x = Math.max(0, Math.min(gridScope.width, d3.event.x))).attr("cy", _y = Math.max(0, Math.min(gridScope.height, d3.event.y)));
            if (_control.classed("tilted-control0")) {
              scope.a = {
                x: gridScope.COL(_x),
                y: gridScope.ROW(_y)
              };
            }
            if (_control.classed("tilted-control1")) {
              scope.b = {
                x: gridScope.COL(_x),
                y: gridScope.ROW(_y)
              };
            }
            return scope.update();
          }).on("dragend", function() {
            scope.a.x = Math.round(scope.a.x);
            scope.a.y = Math.round(scope.a.y);
            scope.b.x = Math.round(scope.b.x);
            scope.b.y = Math.round(scope.b.y);
            return scope.update();
          });
          scope.createSquaresLayer = function() {
            scope.squaresLayer = gridScope.container.selectAll("#tiltedSquares").data([gridScope]);
            return scope.squaresLayer.enter().append("g").attr("id", "tiltedSquares");
          };
          scope.createControlsLayer = function() {
            scope.controlsLayer = gridScope.container.selectAll("#tiltedControls").data([gridScope]);
            return scope.controlsLayer.enter().append("g").attr("id", "tiltedControls");
          };
          scope.createControls = function() {
            scope.controls = scope.controlsLayer.selectAll(".control" + scope.$id);
            return scope.controls.data(scope.squareDots().slice(0, 2)).enter().append("circle").attr("class", function(d, i) {
              return "tilted-control" + i;
            }).classed("control" + scope.$id, true).attr("r", scope.radius).attr("cx", function(d) {
              return gridScope.X(d.x);
            }).attr("cy", function(d) {
              return gridScope.Y(d.y);
            }).call(drag);
          };
          scope.update = function() {
            scope.squaresLayer.selectAll("#square" + scope.$id).data([scope.squareDots()]).attr("d", function(d) {
              return squareOutline(d) + "Z";
            });
            return scope.controlsLayer.selectAll(".control" + scope.$id).data(scope.squareDots().slice(0, 2)).attr("cx", function(d) {
              return gridScope.X(d.x);
            }).attr("cy", function(d) {
              return gridScope.Y(d.y);
            });
          };
          scope.createSquaresLayer();
          scope.createControlsLayer();
          scope.square = scope.squaresLayer.selectAll("#square" + scope.$id);
          scope.square.data([scope.squareDots()]).enter().append("path").attr("id", "square" + scope.$id).attr("class", "tilted").attr("d", function(d) {
            return squareOutline(d) + "Z";
          });
          scope.createControls();
          return scope.update();
        });
      }
    };
  }
]);

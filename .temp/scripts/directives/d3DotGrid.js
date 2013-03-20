/*
# d3-dot-grid draws a rectangular grid of dots.
*/
angular.module('app').directive('d3DotGrid', function() {
  var data;

  data = {};
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      attrs.$observe('along', function(val) {
        scope.along = val != null ? ~~val : 10;
        return console.log("along = ", scope.along);
      });
      attrs.$observe('down', function(val) {
        scope.down = val != null ? ~~val : 10;
        return console.log("down = ", scope.down);
      });
      attrs.$observe('hspace', function(val) {
        scope.hspace = val === "auto" ? "auto" : val != null ? ~~val : 10;
        return console.log("hspace = ", scope.hspace);
      });
      attrs.$observe('vspace', function(val) {
        scope.vspace = val === "auto" ? "auto" : val != null ? ~~val : 10;
        return console.log("vspace = ", scope.vspace);
      });
      attrs.$observe('minspace', function(val) {
        scope.minspace = val === "auto" ? "auto" : val != null ? ~~val : 10;
        return console.log("minspace = ", scope.minspace);
      });
      attrs.$observe('radius', function(r) {
        return scope.radius = r != null ? ~~r : 3;
      });
      attrs.$observe('square', function(val) {
        return scope.square = (val != null) && val !== "false";
      });
      scope.$on('draw', function(event, container, width, height) {
        return scope.draw(container, width, height);
      });
      scope.$on('resize', function(event, container, width, height) {
        return scope.draw(container, width, height);
      });
      return scope.draw = function(container, width, height) {
        var c, circles, columns, gridData, r, space, theGrid;

        this.container = container;
        this.rows = this.down;
        this.cols = this.along;
        this._vspace = this.vspace;
        this._hspace = this.hspace;
        if (this.vspace === "auto") {
          this._vspace = height / (this.rows - 1);
          if (!isNaN(this.minspace) && this._vspace < this.minspace) {
            this._vspace = this.minspace;
          }
          this.rows = Math.floor(height / this._vspace + 1);
        }
        if (this.hspace === "auto") {
          this._hspace = width / (this.cols - 1);
          if (!isNaN(this.minspace) && this._hspace < this.minspace) {
            this._hspace = this.minspace;
          }
          this.cols = Math.floor(width / this._hspace + 1);
        }
        this.width = (this.cols - 1) * this._hspace;
        this.height = (this.rows - 1) * this._vspace;
        console.log("w:h = ", this.width, ":", this.height);
        if (this.square) {
          space = Math.min(this._vspace, this._hspace);
          this._vspace = this._hspace = space;
        }
        this.X = function(col) {
          return col * scope._hspace;
        };
        this.Y = function(row) {
          return row * scope._vspace;
        };
        this.COL = function(x) {
          return x / scope._hspace;
        };
        this.ROW = function(y) {
          return y / scope._vspace;
        };
        console.log("rows=", this.rows, "cols=", this.cols);
        data = (function() {
          var _i, _ref, _results;

          _results = [];
          for (c = _i = 0, _ref = this.cols - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; c = 0 <= _ref ? ++_i : --_i) {
            _results.push((function() {
              var _j, _ref1, _results1;

              _results1 = [];
              for (r = _j = 0, _ref1 = this.rows - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; r = 0 <= _ref1 ? ++_j : --_j) {
                _results1.push({
                  x: c,
                  y: r
                });
              }
              return _results1;
            }).call(this));
          }
          return _results;
        }).call(this);
        gridData = [scope.$id];
        theGrid = this.container.selectAll("#grid").data(gridData);
        theGrid.enter().append("g").attr("id", "grid");
        columns = theGrid.selectAll("g").data(data);
        columns.enter().append("g");
        columns.exit().remove();
        circles = columns.selectAll("circle").data(function(d) {
          return d;
        }).each(function() {
          return d3.select(this).attr("cx", function(d) {
            return scope.X(d.x);
          }).attr("cy", function(d) {
            return scope.Y(d.y);
          });
        });
        circles.enter().append("circle").data(function(d) {
          return d;
        }).attr("r", this.radius).attr("class", "grid-dot").attr("cx", function(d) {
          return scope.X(d.x);
        }).attr("cy", function(d) {
          return scope.Y(d.y);
        });
        circles.exit().remove();
        console.log("dotGRid scope =", scope.$id);
        return this.$broadcast('dotGridUpdated', scope);
      };
    }
  };
});

(angular.module('app').controller('d3VisController', [
  '$scope', '$transclude', function($scope, $transclude) {
    $scope.defaultWidth = 550;
    $scope.defaultHeight = 400;
    $scope.defaultWoff = 41;
    $scope._margin = {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    };
    $scope._padding = {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    };
    $scope.container;
    $scope.width = $scope.defaultWidth - $scope.defaultWoff;
    -$scope._margin.left - $scope._margin.right - $scope._padding.left - $scope._padding.right;
    $scope.height = $scope.defaultHeight;
    return -$scope._margin.top - $scope._margin.bottom - $scope._padding.top - $scope._padding.bottom;
  }
])).directive('d3Vis', [
  '$timeout', '$window', function($timeout, $window) {
    return {
      restrict: 'A',
      transclude: false,
      replace: false,
      controller: 'd3VisController',
      scope: {
        fullwidth: '@',
        fullheight: '@',
        woff: '@',
        margin: '@',
        padding: '@',
        responsive: '@',
        type: '@',
        visible: '@'
      },
      link: function(scope, element, attrs) {
        var parseBorderList, resizeHandler,
          _this = this;

        resizeHandler = function(event) {
          if (scope.resizing) {
            return;
          }
          scope.resizing = true;
          return $timeout(function() {
            scope.resizing = false;
            scope.svgResize(event.target.innerWidth);
            return scope.$broadcast("resize", scope.container, scope.width, scope.height);
          }, 100);
        };
        parseBorderList = function(dimensionList) {
          var list, obj, _ref;

          obj = {
            top: 0,
            right: 0,
            bottom: 0,
            left: 0
          };
          if (dimensionList != null) {
            list = dimensionList.split(/\s+|\s*,\s*/);
            list = list.map(function(val) {
              return ~~val;
            });
            switch (list.length) {
              case 1:
                obj.top = obj.right = obj.left = obj.bottom = list[0];
                break;
              case 2:
                _ref = (obj.bottom = list[0], obj.left = list[1], list), obj.top = _ref[0], obj.right = _ref[1];
                break;
              case 3:
                obj.top = list[0], obj.right = list[1], obj.bottom = list[2];
                obj.left = obj.right;
                break;
              case 4:
                obj.top = list[0], obj.right = list[1], obj.bottom = list[2], obj.left = list[3];
            }
          }
          return obj;
        };
        scope.svgResize = function(ww) {
          var g, r1, r2, visible, w;

          w = ww - this.woff;
          this.outerWidth = ~~this.fullWidth;
          if (this.outerWidth <= w) {
            this.outerHeight = ~~this.fullHeight;
          } else {
            this.outerHeight = Math.round(~~this.fullHeight * w / this.fullWidth);
            this.outerWidth = w;
          }
          this.innerWidth = this.outerWidth - this._margin.left - this._margin.right;
          this.innerHeight = this.outerHeight - this._margin.top - this._margin.bottom;
          this.width = this.innerWidth - this._padding.left - this._padding.right;
          this.height = this.innerHeight - this._padding.top - this._padding.bottom;
          this.svg.attr('width', this.outerWidth + 1);
          this.svg.attr('height', this.outerHeight + 1);
          g = this.svg.select("g").attr("transform", "translate(" + this._margin.left + "," + this._margin.top + ")");
          visible = scope.visible && scope.visible !== "false";
          r1 = g.select("rect").attr("width", this.innerWidth).attr("height", this.innerHeight);
          r1.attr("class", visible ? "outer" : "hide");
          r2 = g.select("g").attr("transform", "translate(" + this._padding.left + "," + this._padding.top + ")").select("rect").attr("width", this.width).attr("height", this.height);
          return r2.attr("class", visible ? "inner" : "hide");
        };
        scope.$watch('fullwidth', function(val) {
          return scope.fullWidth = val != null ? ~~val : scope.defaultWidth;
        });
        scope.$watch('fullheight', function(val) {
          return scope.fullHeight = val != null ? ~~val : scope.defaultHeight;
        });
        scope.$watch('woff', function(val) {
          return scope.woff = val != null ? ~~val : scope.defaultWoff;
        });
        scope.$watch('responsive', function(val) {
          var win;

          win = angular.element($window);
          if ((val != null) && val !== "false" && (win != null)) {
            return win.bind("resize", resizeHandler);
          }
        });
        scope.$watch('margin', function(val) {
          if (val != null) {
            return scope._margin = parseBorderList(val);
          }
        });
        scope.$watch('padding', function(val) {
          if (val != null) {
            return scope._padding = parseBorderList(val);
          }
        });
        return $timeout(function() {
          var g;

          scope.svg = d3.select(element[0]).append("svg");
          g = scope.svg.append("g");
          g.append("rect").attr("class", "outer");
          scope.container = g.append("g");
          scope.container.append("rect").attr("class", "inner");
          scope.svgResize($window.innerWidth);
          return scope.$broadcast("draw", scope.container, scope.width, scope.height);
        }, 1);
      }
    };
  }
]);

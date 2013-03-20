angular.module('app').controller('d3TiltedController', [
  '$scope', function($scope) {
    $scope.setMaxWidth = function(maxWidth) {
      if (maxWidth == null) {
        maxWidth = 600;
      }
      this.outerWidth = this.preferredWidth;
      if (this.outerWidth <= maxWidth) {
        return this.outerWidth = this.preferredHeight;
      } else {
        this.outerHeight = Math.floor(this.preferredHeight * maxWidth / this.preferredWidth);
        return this.outerWidth = maxWidth;
      }
    };
    return $scope.setDimensions = function(preferredWidth, preferredHeight, radius, spotRadius, spacing, margin) {
      var d, ih, iw, m, s;

      if (preferredWidth == null) {
        preferredWidth = 550;
      }
      if (preferredHeight == null) {
        preferredHeight = 400;
      }
      if (radius == null) {
        radius = 5;
      }
      if (spotRadius == null) {
        spotRadius = 25;
      }
      if (spacing == null) {
        spacing = 40;
      }
      if (margin == null) {
        margin = {
          top: 20,
          right: 20,
          bottom: 20,
          left: 20
        };
      }
      m = this.margin;
      this.outerWidth = this.preferredWidth = ~~preferredWidth;
      this.outerHeight = this.preferredHeight = ~~preferredHeight;
      iw = this.innerWidth = this.outerWidth - ~~m.left - ~~m.right;
      ih = this.innerHeight = this.outerHeight - ~~m.top - ~~m.bottom;
      this.radius = ~~radius;
      this.spotRadius = ~~spotRadius;
      this.padding = {
        top: this.radius,
        right: this.radius,
        bottom: this.radius,
        left: this.radius
      };
      d = this.radius * 2;
      this.width = iw - d;
      this.height = ih - d;
      s = ~~this.spacing;
      this.along = Math.floor(this.width / s);
      this.down = Math.floor(this.height / s);
      this.halfInnerWidth = iw / 2;
      this.halfInnerHeight = ih / 2;
      this.x = d3.scale.identity().domain([0, this.width]);
      this.y = d3.scale.identity().domain([0, this.height]);
      this.xAxis = d3.svg.axis().scale(this.x).orient("bottom");
      this.yAxis = d3.svg.axis().scale(this.y).orient("left");
      console.log("a,d = ", this.along, this.down);
      return console.log("w,h = ", this.width, this.height);
    };
  }
]);

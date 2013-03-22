#
# d3 visualisation wrapper
#
(angular.module('app')
.controller 'd3VisController',
[
  '$scope'
  '$transclude'
  ($scope, $transclude) ->
    $scope.defaultWidth  = 550
    $scope.defaultHeight = 400

    #
    # Woff (Width offset) is an amount subtracted from the actual window width
    # to compensate for CSS margins, padding and border applied somewhere above
    # this directive
    #
    $scope.defaultWoff = 41

    #
    # These margin and padding specs operate inside SVG space.
    # They move the origin to the top left corner of the container
    #
    $scope._margin = {top:0, right:0, bottom:0; left: 0}
    $scope._padding = {top:0, right:0, bottom:0; left: 0}

    #
    # the container is a d3 selection of the SVG (group) element to
    # which transcluded directives can append further stuff.
    #
    # i.e. if we have
    # <div d3-vis ...>
    #   <div d3-dot-grid></div>
    # </div>
    #
    # then the d3-dot-grid gets to add its SVG to this container element
    #
    $scope.container

    #
    # The width and height of the container.
    # These update to reflect fullWidth and fullHeight attributes
    # also if responsive is set and the window is not wide enough, they reduce to fit.
    #
    $scope.width = $scope.defaultWidth - $scope.defaultWoff
    - $scope._margin.left - $scope._margin.right - $scope._padding.left - $scope._padding.right

    $scope.height = $scope.defaultHeight
    - $scope._margin.top - $scope._margin.bottom - $scope._padding.top - $scope._padding.bottom


])
.directive 'd3Vis',
[
  '$timeout', '$window'
  ($timeout, $window) ->
    restrict: 'A'
    transclude: false
    replace: false
    controller: 'd3VisController'

    scope: {
      fullwidth: '@'
      fullheight: '@'
      woff: '@' #width offset to allow for inherited margins & borders
      margin: '@'
      padding: '@'
      responsive: '@'
      type:'@'
      visible: '@'
    }

    link: (scope, element, attrs) ->

      #console.log('d3Vis')

      # define handler for different window widths
      # use timer to avoid too many redraws
      resizeHandler = (event) ->
        if scope.resizing
          return
        scope.resizing = true
        $timeout ->
          scope.resizing = false
          scope.svgResize event.target.innerWidth
          scope.$broadcast "resize", scope.container, scope.width, scope.height
        ,100

      parseBorderList = (dimensionList) ->
        obj = {top:0, right:0, bottom:0, left:0}
        if dimensionList?

          list = dimensionList.split //
            \s+         # on one or more whitespace chars
            | \s*,\s*   #  or a comma inside optional whitespace
          //

          # convert strings to numbers
          list = list.map (val) -> ~~val

          switch list.length
            when 1 then obj.top = obj.right = obj.left = obj.bottom = list[0]
            when 2 then [obj.top, obj.right] = [obj.bottom, obj.left] = list
            when 3 then [obj.top, obj.right, obj.bottom] = list; obj.left = obj.right
            when 4 then [obj.top, obj.right, obj.bottom, obj.left] = list
        return obj

      scope.svgResize = (ww) ->
        w = ww - @woff
        @outerWidth = ~~@fullWidth
        if(@outerWidth <= w)
          @outerHeight = ~~@fullHeight
        else
          @outerHeight = Math.round(~~@fullHeight * w / @fullWidth)
          @outerWidth = w

        @innerWidth = @outerWidth - @_margin.left - @_margin.right
        @innerHeight = @outerHeight - @_margin.top - @_margin.bottom

        @width = @innerWidth - @_padding.left - @_padding.right
        @height = @innerHeight - @_padding.top - @_padding.bottom

        @svg.attr 'width', @outerWidth + 1
        @svg.attr 'height', @outerHeight + 1

        g = @svg.select("g")
        .attr("transform", "translate(" + @_margin.left + "," + @_margin.top + ")")

        visible = scope.visible and scope.visible != "false"

        r1 = g.select("rect")
        .attr("width", @innerWidth)
        .attr("height", @innerHeight)
        r1.attr("class", if visible then "outer" else "hide")

        r2 = g.select("g")
        .attr("transform", "translate(" + @_padding.left + "," + @_padding.top + ")")
        .select("rect")
        .attr("width", @width)
        .attr("height", @height)
        r2.attr("class", if visible then "inner" else "hide")

      scope.$watch 'fullwidth', (val) ->
        scope.fullWidth = if val? then ~~val else scope.defaultWidth

      scope.$watch 'fullheight', (val) ->
        scope.fullHeight = if val? then ~~val else scope.defaultHeight

      scope.$watch 'woff', (val) ->
        scope.woff = if val? then ~~val else scope.defaultWoff

      scope.$watch 'responsive', (val) ->
        win = angular.element($window)
        if(val? && val != "false" && win?)
          win.bind "resize", resizeHandler

      scope.$watch 'margin', (val) ->
        if val?
          scope._margin = parseBorderList(val)

      scope.$watch 'padding', (val) ->
        if val?
          scope._padding = parseBorderList(val)




      #
      # wait a tick to ensure scope watches have fired.
      #
      $timeout ->
        scope.svg = d3.select(element[0])
        .append("svg")

        g = scope.svg
        .append("g")

        g.append("rect")
        .attr("class", "outer")

        scope.container = g.append("g")
        scope.container.append("rect")
          .attr("class", "inner")

        scope.svgResize $window.innerWidth

        scope.$broadcast "draw", scope.container, scope.width, scope.height

      ,1
]



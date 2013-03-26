###
# d3-dot-grid draws a rectangular grid of dots.
###
angular.module('app').directive 'd3DotGrid', ->

  data = {}

  return {
    restrict: 'A'


    link: (scope, element, attrs) ->

      #
      # attributes must be observed in case they are interpolated
      #

      # along is the preferred number of columns along
      attrs.$observe 'along', (val) ->
        scope.along = if val? then ~~val else 10
        console.log "along = ", scope.along

      #down is the preferred number of rows down
      attrs.$observe 'down', (val) ->
        scope.down = if val? then ~~val else 10
        console.log "down = ", scope.down

      # hspace is the preferred horizontal space between dot centres
      # Set to "auto" to calculate this from available width and column count.
      # Set to a number otherwise.
      # The default is 10.
      attrs.$observe 'hspace', (val) ->
        scope.hspace = if val=="auto" then "auto" else if val? then ~~val else 10
        console.log "hspace = ", scope.hspace

      # vspace is the preferred vertical space between dot centres.
      # Set to "auto" to calculate this from available height and row count.
      # Set to a number otherwise.
      # The default is 10.
      attrs.$observe 'vspace', (val) ->
        scope.vspace = if val=="auto" then "auto" else if val? then ~~val else 10
        console.log "vspace = ", scope.vspace

      # minspace is the minimum space allowed between dot centres
      attrs.$observe 'minspace', (val) ->
        scope.minspace = if val=="auto" then "auto" else if val? then ~~val else 10
        console.log "minspace = ", scope.minspace

      # radius is the radius of each dot
      attrs.$observe 'radius', (r) ->
        scope.radius = if r? then ~~r else 3

      # If square is truthy then vspace and hspace are set to
      # whichever is lowest.
      attrs.$observe 'square', (val) ->
        scope.square = val? and val != "false"

      #
      # The parent container (e.g. d3Vis) issues draw
      # and resize events
      #
      scope.$on 'draw', (event, container, width, height) ->
        scope.draw(container, width, height)

      scope.$on 'resize', (event, container, width, height) ->
        scope.draw(container, width, height)

      scope.draw = (container, width, height) ->

        #set spacing
        @container = container
        #@width = width
        #@height = height
        
        @rows = @down
        @cols = @along
        @_vspace = @vspace
        @_hspace = @hspace

        if @vspace == "auto"
          @_vspace = height / (@rows - 1)
          if !isNaN(@minspace) and @_vspace < @minspace
            @_vspace = @minspace
          @rows = Math.floor(height/@_vspace + 1)

        if @hspace == "auto"
          @_hspace = width / (@cols - 1)
          if !isNaN(@minspace) and @_hspace < @minspace
            @_hspace = @minspace
          @cols = Math.floor(width/@_hspace + 1)

        @width = (@cols - 1)*@_hspace
        @height = (@rows - 1)*@_vspace

        console.log("w:h = ", @width, ":", @height)
        
        if @square
          space = Math.min(@_vspace, @_hspace)
          @_vspace = @_hspace = space

        @X = (col) -> (col)*scope._hspace
        @Y = (row) -> (row)*scope._vspace
        @COL = (x) -> (x)/scope._hspace
        @ROW = (y) -> (y)/scope._vspace

        console.log "rows=", @rows, "cols=", @cols

        # We want array nesting here.
        data = [[{x:c, y:r} for r in [0 til @rows]] for c in [0 til @cols]]

        #
        # d3 magic starts here
        #
        gridData = [scope.$id]

        theGrid = @container.selectAll(\#grid)
        .data(gridData)

        theGrid.enter().append("g")
        .attr("id", "grid")

        columns = theGrid.selectAll("g")
          .data(data)
          
        columns.enter()
          .append("g")

        columns.exit()
          .remove()

        circles = columns.selectAll("circle")
        .data((d)->d)
        .each -> d3.select(this)
          .attr("cx", (d)->scope.X(d.x))
          .attr("cy", (d)->scope.Y(d.y))

        circles.enter().append("circle")
          .data((d)->d)
          .attr("r", @radius)
          .attr("class", "grid-dot")
          .attr("cx", (d)->scope.X(d.x))
          .attr("cy", (d)->scope.Y(d.y))
        circles .exit().remove()

        # tell any child directives that the grid has been redrawn
        console.log "dotGRid scope =", scope.$id
        @$broadcast 'dotGridUpdated', scope


  }
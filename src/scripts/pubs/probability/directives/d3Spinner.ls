angular.module('app').directive 'd3Spinner', [
  '$timeout'
  ($timeout) ->
    restrict: 'A'
    require: '?ngModel'
    link: (scope, element, attrs, ngModel) ->

      return unless ngModel?

      rad2deg = 180/Math.PI

      # will point to this spinners data
      spinner = scope.$parent.addSpinner attrs.spinner, attrs.ngModel

      # remember last draw space
      savedContainer = null
      savedWidth = 100
      savedHeight = 100

      # listen for redraw events
      scope.$on 'draw', draw
      scope.$on 'resize', resize

      spinGroup = null;
      arc = null
      pie = null
      arcs = null

      arrowPath = (r) ->
        u = r/6
        u3 = 3*u
        u_2 = u/2
        u_2r2= u_2/Math.sqrt(2)
        return [
          [0,u_2]
          [-u_2r2,u_2r2]
          [-u_2,0]
          [-u_2,-u3]
          [-2*u,-u3]
          [0,-u3*2]
          [2*u,-u3]
          [u_2,-u3]
          [u/2,0]
          [u_2r2,u_2r2]
          [0,u_2]
        ]

      r0 = 0

      # named function syntax allows forward reference to 'draw'
      function draw(event, container, width, height)

        console.log "spinner scope = ", scope.$id
        console.log "spinner = ", attrs.spinner

        return unless attrs.spinner

        savedContainer := container
        savedWidth := width
        savedHeight := height

        # Calculate radius of spinner and new origin
        r = Math.min(width, height)/2
        r0 := r if r0 == 0
        origin = {x:r, y:r}

        # Establish a group with origin at the spinner centre
        spinGroup := container.selectAll ".spin-group"
        .data [scope.$id]
        .enter().append("g")
        .attr "class", "spin-group"
        .attr "transform", "translate(#r , #r)"

        arc := d3.svg.arc()
        .innerRadius r/2
        .outerRadius r

        pie := d3.layout.pie()
        .sort null
        .value (d) -> d.weight

        arcs := spinGroup.selectAll "g.slice"
        .data pie spinner.data
        
        arcs.enter().append "g"
        .attr "class", "slice"

        arcs.append "path"
        .style "fill", (d) -> d.data.fill
        .style "stroke-width", "1px"
        .style "stroke", \#888
        .attr "d", arc

        arcs.append "text"
        .attr "transform", (d) -> 'translate(' + arc.centroid(d) + ')'
        .attr "text-anchor", "middle"
        .attr "dy", "0.35em"
        .text (d, i) -> d.data.label

        line = d3.svg.line()

        arrowGroup = container.selectAll ".arrow-group"
        .data ["arrow"]
        .enter().append "g"
        .attr "class", "arrow-group"
        .attr "transform", "translate(#r , #r)"

        arrow = arrowGroup.append "g"

        arrow.attr "class", "arrow"

        # define arrow path

        arrow.append "path"
        .datum arrowPath(r)
        .attr "stroke", \#fff
        .attr "stroke-width", 1
        .attr "stroke-linejoin", "round"
        .attr "stroke-linecap", "round"
        .attr "fill", \#000
        .attr "d", line
        .attr "opacity", "0.3"

        hub = arrow.append "circle"
        .attr "fill", \#fff
        .attr "opacity", 0.7
        .attr "r", r/2

        hub.on "click", (d, i)->scope.$parent.go spinner.spinState

        scope.$parent.$watch attrs.ngModel, (newVal) ->
          arrow.attr "transform", "rotate(#{newVal*rad2deg})"

      # named function syntax allows forward reference to 'draw'
      function resize(event, container=savedContainer, width=savedWidth, height=savedHeight)

        savedContainer := container
        savedWidth := width
        savedHeight := height

        # Calculate radius of spinner and new origin
        r = Math.min(width, height)/2
        scale = r/r0

        spinGroup = container.selectAll ".spin-group"
        .attr "transform", "scale(#{scale}) translate(#r0 , #r0)"

        arcs.selectAll("path").remove()
        arcs.selectAll("text").remove()

        arcs := arcs
        .data pie spinner.data

        arcs.attr "d", arc

        arcs.enter().append "g"
        .attr "class", "slice"

        arcs.append "path"
        .style "fill", (d) -> d.data.fill
        .style "stroke-width", "1px"
        .style "stroke", \#888
        .attr "d", arc

        arcs.append "text"
        .attr "transform", (d) -> 'translate(' + arc.centroid(d) + ')'
        .attr "text-anchor", "middle"
        .attr "dy", "0.35em"
        .text (d, i) -> d.data.label

        leaving = arcs.exit()
        leaving.selectAll("path").remove()
        leaving.selectAll("text").remove()
        leaving.remove()


]
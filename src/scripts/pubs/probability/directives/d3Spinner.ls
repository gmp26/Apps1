angular.module('app').directive 'd3Spinner', ->
  restrict: 'A'
  require: '?ngModel'
  link: (scope, element, attrs, ngModel) ->

    return unless ngModel?

    rad2deg = 180/Math.PI

    # will point to this spinners data
    spinner = scope.$parent.addSpinner attrs.spinner, attrs.ngModel

    draw = (event, container, width, height) ->

      console.log "spinner scope = ", scope.$id
      console.log "spinner = ", attrs.spinner

      return unless attrs.spinner

      console.log "ngModel.$viewValue = ", ngModel.$viewValue
      console.log "ngModel.$modelValue = ", ngModel.$modelValue

      # create spinner
      #spinner = scope.$parent.spinner[attrs.spinner]

      # Calculate radius of spinner and new origin
      r = Math.min(width, height)/2
      origin = {x:r, y:r}

      # Establish a group with origin at the spinner centre
      spinGroup = container.selectAll(".spin-group")
      .data([scope.$id])

      spinGroup
      .enter().append("g")
      .attr("class", "spin-group")
      .attr("transform", "translate(" + r + "," + r + ")")

      arc = d3.svg.arc()
      .innerRadius(r/2)
      .outerRadius(r)

      pie = d3.layout.pie()
      .sort(null)
      .value((d) -> d.weight)

      arcs = spinGroup.selectAll("g.slice")
      .data(pie(spinner))

      arcs.enter().append("g")
      .attr("class", "slice")

      arcs.append("path")
      .style("fill", (d) -> d.data.fill)
      .style("stroke-width", "1px")
      .style("stroke", \#888)
      .attr("d", arc)

      arcs.append("text")
      .attr("transform", (d) -> 'translate(' + arc.centroid(d) + ')')
      .attr("text-anchor", "middle")
      .attr("dy", "0.35em")
      .text((d, i) -> d.data.label)

      line = d3.svg.line()

      arrow = spinGroup
      .append("g")

      # define arrow path
      u = r/6
      u3 = 3*u
      u_2 = u/2
      u_2r2= u_2/Math.sqrt(2)
      pointer = [
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
      arrow.append("path")
      .datum(pointer)
      .attr("stroke", \#fff)
      .attr("stroke-width", 1)
      .attr("stroke-linejoin", "round")
      .attr("stroke-linecap", "round")
      .attr("fill", \#000)
      .attr("d", line)
      .attr("opacity", "0.3")

      hub = arrow.append("circle")
      .attr("fill", \#fff)
      .attr("opacity", 0.7)
      .attr("r", r/2)

      hub.on "click", (d, i)->scope.$parent.go(d3.event)
      /*
      ngModel.$render = ->
        x = ngModel.$viewValue
        arrow.attr("transform", "rotate(" + (x*rad2deg) + ")")
      */
      scope.$parent.$watch attrs.ngModel, (newVal, oldVal) ->
        x = newVal
        arrow.attr("transform", "rotate(" + (x*rad2deg) + ")")

    # listen for redraw events
    scope.$on 'draw', draw
    scope.$on 'resize', draw




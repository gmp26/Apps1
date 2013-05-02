angular.module('app').factory 'd3LineChart', ->
  lineChart = ->
    chart = (selection) ->
      selection.each (data) ->
        
        # Convert data to standard representation greedily;
        # this is needed for nondeterministic accessors.
        data = data.map((d, i) ->
          [xValue.call(data, d, i), yValue.call(data, d, i)]
        )
        
        # Update the x-scale.
        xScale.domain(d3.extent(data, (d) -> d[0])).range [0, width - margin.left - margin.right]
        
        # Update the y-scale.
        yScale.domain(d3.extent(data, (d) -> d[1])).range [height - margin.top - margin.bottom, 0]
        
        # Select the svg element, if it exists.
        gplot = d3.select(this).selectAll("g.plot")
        .data([data])

        gPlotEnter = gplot.enter().append("g").attr "class", "plot"

        # Otherwise, create the skeletal chart.
        gEnter = gPlotEnter.append("g")
        gEnter.append("path").attr "class", "line"
        gEnter.append("g").attr "class", "x axis"
        gEnter.append("g").attr "class", "y axis"
        
        # Update the plot space. 
        gplot
        .attr "width", width
        .attr "height", height
        
        # Update the inner dimensions.
        g = gplot.select("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
        
        # Update the line path. Note that isNaN(null) is weirdly false in javascript.
        line.defined (d) -> !(d[0]==null or d[1]==null or isNaN(d[0]) or isNaN(d[1]))
        g.select(".line").attr "d", line
        
        # Update the axes.
        g.select(".x.axis").attr("transform", "translate(0," + yScale.range()[0] + ")").call xAxis
        g.select(".y.axis").attr("transform", "translate(" + xScale.range()[0] + ", 0)").call yAxis

    
    # The x-accessor for the path generator; xScale ∘ xValue.
    X = (d) -> xScale d[0]
    
    # The x-accessor for the path generator; yScale ∘ yValue.
    Y = (d) -> yScale d[1]

    margin =
      top: 0
      right: 0
      bottom: 0
      left: 0

    width = 300
    height = 250
    xValue = (d) ->
      d[0]

    yValue = (d) ->
      d[1]

    xScale = d3.scale.linear()
    yScale = d3.scale.linear()
    xAxis = d3.svg.axis().scale(xScale).orient("bottom").tickSize(6, 0)
    yAxis = d3.svg.axis().scale(yScale).orient("left").tickSize(6,0)

    line = d3.svg.line().x(X).y(Y)

    chart.margin = (_) ->
      return margin  unless arguments.length
      margin = _
      chart

    chart.width = (_) ->
      return width  unless arguments.length
      width := _
      chart

    chart.height = (_) ->
      return height  unless arguments.length
      height := _
      chart

    chart.x = (_) ->
      return xValue  unless arguments.length
      xValue := _
      chart

    chart.y = (_) ->
      return yValue  unless arguments.length
      yValue := _
      chart

    chart
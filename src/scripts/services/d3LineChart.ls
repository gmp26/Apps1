angular.module('app').factory 'd3LineChart', ->
  lineChart = ->
    chart = (selection) ->
      selection.each (data) ->
        
        # Convert data to standard representation greedily;
        # this is needed for nondeterministic accessors.
        data = data.map (d, i) -> [xValue.call(data, d, i), yValue.call(data, d, i)]
        
        # Update the x-scale.
        xScale.domain(d3.extent(data, (d) -> d[0])).range [0, width]
        
        # Update the y-scale.
        yScale.domain(d3.extent(data, (d) -> d[1])).range [height, 0]
        
        # Select the svg element, if it exists.
        gplot = d3.select(this).selectAll("g.plot")
        .data([data])
        .attr "width", width
        .attr "height", height

        gPlotEnter = gplot.enter().append("g").attr "class", "plot"

        # Otherwise, create the skeletal chart.
        #gEnter = gPlotEnter.append("g")
        gPlotEnter.append("path").attr "class", "line"
        gPlotEnter.append("g").attr "class", "x axis"
        gPlotEnter.append("g").attr "class", "y axis"
        
        # Update the line path. 
        gplot.select(".line").attr "d", line
        
        # Update the axes.
        gplot.select(".x.axis").attr("transform", "translate(0," + yScale.range()[0] + ")").call xAxis
        gplot.select(".y.axis").attr("transform", "translate(" + xScale.range()[0] + ", 0)").call yAxis

    
    # The x-accessor for the path generator; xScale ∘ xValue.
    X = (d) -> xScale d[0]
    
    # The x-accessor for the path generator; yScale ∘ yValue.
    Y = (d) -> yScale d[1]

    width = 300
    height = 250
    xValue = (d) -> d[0]
    yValue = (d) -> d[1]
    xScale = d3.scale.linear()
    yScale = d3.scale.linear()
    xAxis = d3.svg.axis().scale(xScale).orient("bottom").tickSize(6, 0)
    yAxis = d3.svg.axis().scale(yScale).orient("left").tickSize(6,0)

    # Note that isNaN(null) is weirdly false in javascript.
    line = d3.svg.line()
    .x(X)
    .y(Y)
    .defined (d) -> !(d[0]==null or d[1]==null or isNaN(d[0]) or isNaN(d[1]))

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
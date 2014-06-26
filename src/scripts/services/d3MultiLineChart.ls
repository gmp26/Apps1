angular.module('app').factory 'd3MultiLineChart', ->

  /*

   multiLineChart returns a function that plots dataSeries in a line plot on a d3 selection.
   Data is joined to the selection and contains an array of data series - one for each line
   Each dataSeries is an array of [x,y] values to join.

   Undefined x and y values cause breaks in the plot (Pen up events) 

  */
  multiLineChart = ->

    # Return the total extent of data in all the series for a given accessor function
    # Used to define the axis ranges as these are common to all series.
    seriesExtent = (series, accessor) ->
      extent = [1e12,-1e12]
      series.forEach (data) ->
        [min, max] = d3.extent(data, accessor)
        extent[0] = min if min < extent[0]
        extent[1] = max if max > extent[1]
      extent[0] = Math.floor(extent[0]) - 0.5 # nearest integer below plus padding
      extent[1] = Math.ceil(extent[1]) + 0.5  # nearest integer above plus padding
      return extent

    # sets the axes of the graph to use the same pixel scale
    normaliseExtent = (xExtent, yExtent) ->
      # work out pixel size of one unit in each of x and y axes
      xSpan = xExtent[1] - xExtent[0]
      xUnit = width / xSpan
      ySpan = yExtent[1] - yExtent[0]
      yUnit = height / ySpan

      if yUnit > xUnit
        yExtra = (height / xUnit) - ySpan
        yExtent[0] = yExtent[0] - yExtra / 2
        yExtent[1] = yExtent[1] + yExtra / 2
      else if xUnit > yUnit
        xExtra = (width / yUnit) - xSpan
        xExtent[0] = xExtent[0] - xExtra / 2
        xExtent[1] = xExtent[1] + xExtra / 2

    chart = (selection) ->

      selection.each (series) ->
        
        # Convert data to standard representation greedily;
        # this is needed for nondeterministic accessors.
        series = series.map (data) ->
          data.map (d, i) -> [xValue.call(data, d, i), yValue.call(data, d, i)]

        # get axes extent from plot co-ordinates
        xExtent = seriesExtent series, (d) -> d[0]
        yExtent = seriesExtent series, (d) -> d[1]

        # set axes to use the same pixel scale
        normaliseExtent(xExtent, yExtent)

        # Update the axes ranges
        xScale.domain(xExtent).range [0, width]
        yScale.domain(yExtent).range [height, 0]
        
        # Select the plot element, if it exists, and join it with the data series
        gplot = d3.select(this).selectAll("g.plot")
        .data(series)
        .attr "width", width
        .attr "height", height

        gPlotEnter = gplot.enter().append("g").attr "class", "plot"

        firstPlot = gPlotEnter.filter (d, i) -> i == 0

        firstPlot.append('rect')
        .attr 'class', 'ground'
        .attr 'width', width
        .attr 'height', height
        .style 'fill', '#ffffff'
        .style 'stroke', '#000000'
        .style 'stroke-width', 0.5
        .style 'stroke-opacity', 0.3

        firstPlot.append('clipPath')
        .attr "id" "clip"
        .append("rect")
        .attr "width" width
        .attr "height" height

        gPlotEnter.append("path")
        .attr "class", "line"
        .style "stroke", (d, i)->color(i)
        .attr "clip-path", 'url(#clip)'

        # We are plotting all series on the same axes
        firstPlot.append("g").attr "class", "x axis"
        firstPlot.append("g").attr "class", "y axis"

        # Update the axes.
        gplot.select(".x.axis").attr("transform", "translate(0," + yScale.range()[0] + ")").call xAxis
        gplot.select(".y.axis").attr("transform", "translate(" + xScale.range()[0] + ", 0)").call yAxis
        
        # Update the ground
        gplot.select('rect.ground')
        .attr "width" width
        .attr "height" height

        # Update the clip path
        gplot.select('#clip rect')
        .attr "width" width
        .attr "height" height

        # Update the line path. 
        gplot.select(".line").attr "d", line
                
    
    # The x-accessor for the path generator; xScale ∘ xValue.
    X = (d) -> xScale d[0]
    
    # The x-accessor for the path generator; yScale ∘ yValue.
    Y = (d) -> yScale d[1]

    width = 300
    height = 250
    yMax = 0 # class variable. Initialise to prevent chart.yMax throwing a wobbly.
    xValue = (d) -> d[0]
    yValue = (d) -> d[1]

    xScale = d3.scale.linear()
    yScale = d3.scale.linear()
    xAxis = d3.svg.axis().scale(xScale).orient("bottom").tickSize(6, 0)
    yAxis = d3.svg.axis().scale(yScale).orient("left").tickSize(6, 0)
    color = d3.scale.category10()
    line = d3.svg.line().x(X).y(Y)

    # Chop the line path into defined sub paths
    # Note that isNaN(null) is weirdly false in javascript.
    line.defined (d) -> not (d[0] is null or d[1] is null or isNaN d[0] or isNaN d[1])

    chart.width = (_) ->
      return width  unless arguments.length
      width := _
      return chart

    chart.height = (_) ->
      return height  unless arguments.length
      height := _
      return chart

    chart.x = (_) ->
      return xValue  unless arguments.length
      xValue := _
      return chart

    chart.y = (_) ->
      return yValue  unless arguments.length
      yValue := _
      return chart

    # TODO: refactor x and y extents so we can drag the chart around and
    # regenerate the plot area appropriately.
    # Currently this isn't used usefully - chart bounds are selected from the
    # extent of the input data.
    chart.yMax = (_) ->
      return yMax  unless arguments.length
      yMax := _
      return chart

    return chart

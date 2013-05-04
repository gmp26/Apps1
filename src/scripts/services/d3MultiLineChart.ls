angular.module('app').factory 'd3MultiLineChart', ->

  /*

   multiLineChart returns a function that plots dataSeries in a line plot on a d3 selection.
   Data is joined to the selection and contains an array of data series - one for each line
   Each dataSeries is an array of [x,y] values to join.

   Undefined x and y values cause breaks in the plot (Pen up events) 

  */
  multiLineChart = ->

    # Return the total extent of data in all the series for a given accessor function
    # Used to define the axis ranges
    seriesExtent = (series, accessor) ->
      extent = [1e12,-1e12]
      series.forEach (data) ->
        [min, max] = d3.extent(data, accessor)
        extent[0] = min if min < extent[0]
        extent[1] = max if max > extent[1]
      return extent

    chart = (selection) ->
      selection.each (series) ->
        
        # Convert data to standard representation greedily;
        # this is needed for nondeterministic accessors.
        series = series.map (data) ->
          data.map (d, i) -> [xValue.call(data, d, i), yValue.call(data, d, i)]
        
        xExtent = seriesExtent series, (d) -> d[0]
        xScale.domain(xExtent).range [0, width]
        
        # Update the y-scale.
        yExtent = seriesExtent series, (d) -> d[1]
        yScale.domain(yExtent).range [height, 0]
        
        # Select the plot element, if it exists, and join it with the data series
        container = d3.select()
        gplot = d3.select(this).selectAll("g.plot")
        .data(series)
        .attr "width", width
        .attr "height", height
        #.data([data])

        selection.append("g").attr "class", "x axis"
        gplot.append("g").attr "class", "y axis"

        gPlotEnter = gplot.enter().append("g").attr "class", "plot"
        gPlotEnter.append("path").attr "class", "line"
        
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

    line = d3.svg.line().x(X).y(Y)

    # Chop the line path into defined sub paths
    # Note that isNaN(null) is weirdly false in javascript.
    line.defined (d) -> !(d[0]==null or d[1]==null or isNaN(d[0]) or isNaN(d[1]))

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

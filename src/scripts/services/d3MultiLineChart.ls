angular.module('app').factory 'd3MultiLineChart', ->

  /*

   multiLineChart returns a function that plots dataSeries in a line plot on a d3 selection.
   Data is joined to the selection and contains an array of data series - one for each line
   Each dataSeries is an array of [x,y] values to join.

   Undefined x and y values cause breaks in the plot (Pen up events) 

  */
  multiLineChart = ->

    # Return the total extent of data in all the series for a given accessor function
    seriesExtent = (series, accessor) ->
      allData = []
      series.forEach(data) ->
        allData.concat(data)
      d3.extent(allData, accessor)

    chart = (selection) ->
      selection.each (series) ->
        
        # Convert data to standard representation greedily;
        # this is needed for nondeterministic accessors.
        series = series.map (data) ->
          data.map (d, i) -> [xValue.call(data, d, i), yValue.call(data, d, i)]
        
        xScale.domain(seriesExtent(series, (d) -> d[0])).range [0, width - margin.left - margin.right]
        
        # Update the y-scale.
        yScale.domain(seriesExtent(series, (d) -> d[1])).range [height - margin.top - margin.bottom, 0]
        
        # Select the plot element, if it exists, and join it with the data series
        gplot = d3.select(this).selectAll("g.plot")
        .data(series)
        #.data([data])

        gPlotEnter = gplot.enter().append("g").attr "class", "plot"
        gPlotEnter.append("g").attr "class", "x axis"
        gPlotEnter.append("g").attr "class", "y axis"

        # One line for each series        
        gSeries = gplot.selectAll ".line"
        .data (d,i) -> d
        .enter().append("g").attr "class", "line"

        # Update the plot space. 
        gplot
        .attr "width", width
        .attr "height", height
                
        # Update the line path. Note that isNaN(null) is weirdly false in javascript.
        line.defined (d) -> !(d[0]==null or d[1]==null or isNaN(d[0]) or isNaN(d[1]))
        gplot.select(".line").attr "d", line
        
        # Update the axes.
        gplot.select(".x.axis").attr("transform", "translate(0," + yScale.range()[0] + ")").call xAxis
        gplot.select(".y.axis").attr("transform", "translate(" + xScale.range()[0] + ", 0)").call yAxis

    
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

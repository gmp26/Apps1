angular.module('app').directive 'mathmoPlot' [
  '$parse'
  'd3LineChart'
  ($parse, d3LineChart) ->
    return
      restrict: 'A'
      /*
      controller: [
        '$scope'
        '$element'
        (scope, element) ->
          html = "<div style='width:100%;height:40px'>"
          scope.$parent.alerts.forEach (alert, i) ->
            html += "<div alert type='#{alert.type}' close='closeAlert(#i)'>#{alert.msg}</div>"
          element.html html+'</div>'
      ]
      */
      link: (scope, element, attrs) ->

        console.log 'mathmoPlot'

        # remember last draw space
        savedContainer = null
        savedWidth = 400
        savedHeight = 300

        chart = null
        data = null

        draw = (event, container, width, height) ->
          console.log 'draw'

          savedContainer := container
          savedWidth := width
          savedHeight := height

          # since we're nested in d3Vis scope, must evaluate attributes on parent scope
          getData = $parse(attrs.data)
          data := getData(scope.$parent)
          console.log data

          chart := d3LineChart().width(width).height(height)
            .x((d) -> d[0])
            .y((d) -> d[1])

          container.datum(data[0]).call(chart)

        resize = (event, container = savedContainer, width = savedWidth, height = savedHeight) ->
          console.log 'resize'

          savedContainer := container
          savedWidth := width
          savedHeight := height

          chart.width(width).height(height)
          container.datum(data[0]).call(chart)

        # listen for redraw events
        scope.$on 'draw', draw
        scope.$on 'resize', resize

]

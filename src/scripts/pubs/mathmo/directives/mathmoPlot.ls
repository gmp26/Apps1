angular.module('app').directive 'mathmoPlot' [
  '$parse'
  'd3MultiLineChart'
  ($parse, chartFactory) ->
    return
      restrict: 'A'

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
          /*
          attrs.$observe 'data', (val) ->
            console.log 'attr changed'
            console.log val
            scope.$parent.$watch val, (data) ->
              console.log 'data changed'
              console.log val
              scope.$broadcast 'resize', container, width, height
          */
          scope.$parent.$watch attrs.data, (data) ->
            console.log 'data changed'
            console.log data
            scope.$broadcast 'resize', container, width, height

          # since we're nested in d3Vis scope, must evaluate attributes on parent scope
          getData = $parse(attrs.data)
          data := getData(scope.$parent)

          chart := chartFactory()
          .width(width)
          .height(height)
          .x((d) -> d[0])
          .y((d) -> d[1])

          container.datum(data).call(chart)

        resize = (event, container = savedContainer, width = savedWidth, height = savedHeight) ->
          console.log 'resize'

          savedContainer := container
          savedWidth := width
          savedHeight := height

         # since we're nested in d3Vis scope, must evaluate attributes on parent scope
          getData = $parse(attrs.data)
          data := getData(scope.$parent)

          chart.width(width).height(height)
          container.datum(data).call(chart)

        # listen for redraw events
        scope.$on 'draw', draw
        scope.$on 'resize', resize

]

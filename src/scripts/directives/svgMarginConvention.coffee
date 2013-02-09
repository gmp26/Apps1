#
# This displays the d3 margin convention using Angular controls
# It's useful for getting your head round the coordinate system
#
angular.module('app').directive 'svgMarginConvention', ($compile) ->
	templateUrl: 'src/views/directives/svgMarginConvention.html'
	replace: false
	restrict: 'A'
	compile: (element, attrs) ->
		
		post: (scope, element, attrs) ->


			g = d3.select('svg').select(".space")

			g.append("g")
			.attr("class", "x axis axisHelp")
			.attr("transform", "translate(0," + scope.height + ")")
			.call(scope.xAxis)

			g.append("g")
			.attr("class", "y axis axisHelp")
			.attr("transform", "translate("+scope.width+",0)")
			.call(scope.yAxis)

	
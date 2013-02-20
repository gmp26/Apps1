#
# d3 visualisation wrapper
#
(angular.module('app')
.controller 'd3VisController', ['$scope', ($scope) ->
	#console.log "controller scope is ", $scope.$id

	$scope.width = 550
	$scope.height= 400

	$scope.makeResponsive = ->
		console.log "responsive"

])
.directive 'd3Vis', ['$timeout', ($timeout) ->
	return {
		restrict: 'A'
		transclude: false
		replace: true
		controller: 'd3VisController'

		scope: {
			width: '@'
			height: '@'
			margin: '@'
			padding: '@'
			responsive: '@'
			visible: '@'
		}

		link: (scope, element, attrs) ->
			#console.log("directive scope is ", scope.$id)
			#console.log("element ", element[0].localName)

			svg = d3.select(element[0]).append("svg")
				
			svg.attr('height', 400)

			scope.$watch 'width', ->
				svg.attr('width', scope.width)

			scope.$watch 'height', (val) ->
				svg.attr('height', val) if val?

			scope.$watch 'responsive', (val) ->
				if(val?) 
					console.log 'responsive'
					scope.makeResponsive()
	}
]




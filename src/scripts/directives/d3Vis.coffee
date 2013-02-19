#
# d3 visualisation wrapper
#
angular.module('app').directive 'd3Vis', ['$timeout', ($timeout) ->
	return {
		restrict: 'A'
		transclude: false
		template: '<svg></svg>'
		replace: false

		scope: {
			width: '@'
			height: '@'
			margin: '@'
			padding: '@'
			responsive: '@'
			visible: '@'
		}

		link: (scope, element, attrs) ->
			console.log("###########")
	}
]



angular.module("app").directive "stepper", ['$compile', '$timeout', ($compile, $timeout) ->
	template: '<input type="number" min="0">'
	replace: true
	restrict:'E'
	scope: {
		name: '@'
		val: '@'
	}
	link: (scope, element, attrs) ->
		console.log attrs
		element.attr('ng-model', attrs.name)
		element.attr('ng-init', attrs.name+'='+attrs.val)
		$compile(element)(scope)
		$timeout -> scope.$digest()
]

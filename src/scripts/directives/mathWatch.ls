#
# Apply the math-watch attribute to any element that contains TeX that
# is inserted programmatically. It triggers a MathJax render on creation
# and on update.
#
angular.module('app').directive 'mathWatch', [
  '$timeout'
  '$window'
  ($timeout, $window) ->

    restrict: 'A'
    replace: false
    transclude: false

    link: (scope, element, attrs) ->

      #
      # The timeout is necessary to prevent a race between mathJAX and
      # any bindings injecting TeX to be rendered.
      #
      # MathJax appears to be undefined after a code change. Not sure why we
      # are executing before the page is loaded - but we are. 
      # 
      _renderMath = ->
        MathJax.Hub.Queue ["Typeset", MathJax.Hub, element.0]

      renderMath = ->
        console.log "rendering #{scope.$id}"

        if MathJax?
          $timeout _renderMath, 1
        else
          $window.addEventListener "load", _renderMath

      # 
      # Trigger a MathJax render on the watched element on creation
      # 
      # renderMath!

      scope.$watch attrs.mathWatch, renderMath, false
]
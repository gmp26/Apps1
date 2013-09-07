#
# do this once only!
#
# TODO: duplicate in pubs and remove prelude from any that don't need it.
#
# import prelude

angular.module 'app' .controller 'appController', <[$scope $location $resource $rootScope]> ++ ($scope, $location, $resource, $rootScope) ->

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location

  $scope.$watch '$location.path()', (path) ->
  
    #console.log 'path=', path
    $scope.activeNavId = path || '/'
  

  # getClass compares the current url with the id.
  # If the current url starts with the id it returns 'active'
  # otherwise it will return '' an empty string. E.g.
  #
  #   # current url = '/products/1'
  #   getClass('/products') # returns 'active'
  #   getClass('/orders') # returns ''
  #
  $scope.getClass = (id) ->

    if $scope.activeNavId && $scope.activeNavId.indexOf(id) == 0
      return 'active'
    else
      return ''



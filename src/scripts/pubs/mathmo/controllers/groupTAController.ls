/*
 * Type Ahead controller for selecting a topic group
 */
angular.module('app').controller 'groupTAController', [
  '$scope'
  'config'
  ($scope, config) ->

    $scope.selected = undefined;
    $scope.groups = config.groups.map (.title)
]
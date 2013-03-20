angular.module('app').directive('appVersion', [
  'semver', function(semver) {
    return function(scope, elm, attrs) {
      return elm.text(semver);
    };
  }
]);

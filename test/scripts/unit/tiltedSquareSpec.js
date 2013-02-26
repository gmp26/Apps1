
beforeEach(module('app'));

describe('App', function() {
  var scope;
  scope = {};
  beforeEach(inject(function($controller, $rootScope) {
    scope = $rootScope.$new();
    return $controller('d3TiltedController', {
      $scope: scope
    });
  }));
  return describe('d3 tiltedSquare Controller', function() {
    xit('should set default values on scope', function() {
      expect(scope.radius).toBeUndefined();
      scope.setDefaults();
      expect(scope.outerWidth).toBeDefined();
      expect(scope.outerHeight).toBeDefined();
      expect(scope.spacing).toBeDefined();
      expect(scope.margin).toBeDefined();
      expect(scope.radius).toBeDefined();
      return expect(scope.spotRadius).toBeDefined();
    });
    return xit('should calculate along and down', function() {
      scope.setDimensions();
      expect(scope.along).toBeDefined();
      return expect(scope.down).toBeDefined();
    });
  });
});

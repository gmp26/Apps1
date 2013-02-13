
describe('tiltedSquare directive', function() {
  var $compile, $httpBackend, $scope, _ref;
  _ref = [], $compile = _ref[0], $httpBackend = _ref[1], $scope = _ref[2];
  beforeEach(module('app'));
  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get('$httpBackend');
    $scope = $injector.get('$rootScope').$new();
    $compile = $injector.get('$compile');
    return $httpBackend.whenGET('/views/directives/tiltedSquare.html').respond('<div>foo</div>');
  }));
  afterEach(function() {
    $httpBackend.verifyNoOutstandingExpectation();
    return $httpBackend.verifyNoOutstandingRequest();
  });
  return it('should pull in the template from the templateUrl file', function() {
    var element;
    element = $compile('<div tilted-square="ts1"></div>')($scope);
    $httpBackend.flush();
    return expect(element.text()).toBe('foo');
  });
});

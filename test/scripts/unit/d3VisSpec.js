
describe('d3Vis directive', function() {
  var compile, el, element, rootScope, scope;
  beforeEach(module('app'));
  scope = {};
  compile = {};
  rootScope = {};
  element = {};
  el = {};
  beforeEach(inject(function($rootScope, $compile) {
    scope = $rootScope;
    compile = $compile;
    el = angular.element('<div d3-vis></div>');
    $compile(el)(scope);
    return scope.$digest();
  }));
  it("should compile", function() {
    return expect(angular.isElement(el)).toBeTruthy();
  });
  return it("should insert an svg element", function() {
    return expect(el.find('svg').length).toBe(1);
  });
});

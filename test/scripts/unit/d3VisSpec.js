
describe('d3Vis directive', function() {
  var compile, el, flag, scope, svg;
  scope = {};
  compile = {};
  el = {};
  svg = null;
  flag = false;
  beforeEach(module('app'));
  beforeEach(inject(function($rootScope, $compile) {
    scope = $rootScope;
    return compile = $compile;
  }));
  it("should compile", function() {
    el = angular.element('<div d3-vis width="600"></div>');
    compile(el)(scope);
    scope.$digest();
    return expect(angular.isElement(el)).toBeTruthy();
  });
  return it("should wait before running tests", function() {
    runs(function() {
      el = angular.element('<div d3-vis width="600" responsive></div>');
      compile(el)(scope);
      return scope.$digest();
    });
    waits(5000);
    return runs(function() {
      expect(el).toBeDefined();
      expect(el.scope()).toBeDefined();
      console.log(el.html());
      expect(el.find('svg').length).toBe(100);
      svg = el.find('svg').eq(0);
      return expect(svg.attr("width")).toBeDefined();
      /*
      			it "should have a height", ->
      				svg = el.scope().svg
      				expect(svg.attr("height")).toBeDefined()
      
      			it "has a default height set in the controller", ->
      				svg = el.scope().svg
      				expect(svg.attr("height")).toBe '400'
      
      			it "width can be set as attribute", ->
      				svg = el.scope().svg
      				expect(svg.attr("width")).toBe '600'
      */

    });
  });
});


describe('d3Vis directive', function() {
  var compile, el, scope;
  beforeEach(module('app'));
  scope = {};
  compile = {};
  el = {};
  beforeEach(inject(function($rootScope, $compile) {
    scope = $rootScope;
    compile = $compile;
    el = angular.element('<div d3-vis width="600"></div>');
    $compile(el)(scope);
    return scope.$digest();
  }));
  afterEach(function() {
    return el.remove();
  });
  it("should compile", function() {
    return expect(angular.isElement(el)).toBeTruthy();
  });
  it("should insert an svg element", function() {
    var svg;
    svg = el.find('svg');
    return expect(svg.length).toBe(1);
  });
  return describe('inserted svg', function() {
    var svg;
    svg = {};
    beforeEach(function() {
      return svg = el.find('svg');
    });
    it("should have a width", function() {
      return expect(svg.attr("width")).toBeDefined();
    });
    it("should have a height", function() {
      return expect(svg.attr("height")).toBeDefined();
    });
    it("has a default height set in the controller", function() {
      return expect(svg.attr("height")).toBe('400');
    });
    it("width can be set as attribute", function() {
      return expect(svg.attr("width")).toBe('600');
    });
    return it("should call makeResponsive if responsive is set", function() {
      svg.remove();
      el.remove();
      el = angular.element('<div d3-vis width="550" responsive></div>');
      compile(el)(scope);
      scope.$digest();
      svg = el.find('svg');
      el.scope();
      compile(el)(scope);
      spyOn(el.scope(), 'makeResponsive');
      scope.$digest();
      return expect(el.scope().makeResponsive).toHaveBeenCalled();
    });
  });
});

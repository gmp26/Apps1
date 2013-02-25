
describe('d3Vis directive', function() {
  var compile, el, flag, scope;
  scope = {};
  compile = {};
  el = {};
  flag = false;
  beforeEach(module('app'));
  beforeEach(inject(function($rootScope, $compile, $timeout) {
    spyOn(d3, 'select').andCallThrough();
    scope = $rootScope;
    compile = $compile;
    el = angular.element('<div d3-vis width="600" responsive></div>');
    compile(el)(scope);
    scope.$digest();
    return $timeout.flush();
  }));
  afterEach(function() {
    return el.remove();
  });
  it("should have called d3.select", function() {
    return expect(d3.select).toHaveBeenCalled();
  });
  it("should have appended an svg", function() {
    return expect(el.find('svg').length).toBe(1);
  });
  return it("svg should have width 600", function() {
    return expect(el.find('svg').eq(0).attr('width')).toBeDefined();
  });
  /*
  	it "should call d3Selection.append twice", ->
  		expect(d3Selection.append.calls.length).toEqual 2
  
  	it "should have called d3Selection.attr", ->
  		expect(d3Selection.attr).toHaveBeenCalled()
  */

});

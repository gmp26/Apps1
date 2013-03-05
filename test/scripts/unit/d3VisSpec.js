
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
    el = angular.element('<div d3-vis fullwidth="600" responsive></div>');
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
  describe("svg width", function() {
    it("should be defined", function() {
      return expect(el.find('svg').eq(0).attr('width')).toBeDefined();
    });
    return it("should be window width - woff + 1", function() {
      var expected, w, woff, ww;
      w = ~~el.find('svg').eq(0).attr('width');
      ww = angular.element(window).innerWidth();
      woff = 41;
      expected = w <= ww - woff ? 601 : ww - woff + 1;
      return expect(w).toBe(expected);
    });
  });
  describe("border defaults", function() {
    var s;
    s = {};
    beforeEach(function() {
      return s = el.scope();
    });
    it("for margins should be zero", function() {
      expect(s._margin.top === s._margin.bottom).toBe(true);
      return expect(s._margin.left === s._margin.right).toBe(true);
    });
    return it("for padding should be zero", function() {
      expect(s._padding.top === s._padding.bottom).toBe(true);
      return expect(s._padding.left === s._padding.right).toBe(true);
    });
  });
  describe("borders", function() {
    var s;
    s = {};
    beforeEach(inject(function($timeout) {
      el.remove();
      el = angular.element('<div d3-vis fullwidth="600" margin="1 2 3 4" padding="5,6"></div>');
      compile(el)(scope);
      scope.$digest();
      s = el.scope();
      return $timeout.flush();
    }));
    return it("can be set from attribute list", function() {
      expect(s._margin.top).toBe(1);
      expect(s._margin.right).toBe(2);
      expect(s._margin.bottom).toBe(3);
      expect(s._margin.left).toBe(4);
      expect(s._padding.top).toBe(5);
      expect(s._padding.right).toBe(6);
      expect(s._padding.bottom).toBe(5);
      return expect(s._padding.left).toBe(6);
    });
  });
  describe("margins and padding", function() {
    var s;
    s = {};
    beforeEach(inject(function($timeout) {
      el.remove();
      el = angular.element('<div d3-vis fullwidth="600" margin="10 20 30 40" padding="5 5 5 5"></div>');
      compile(el)(scope);
      scope.$digest();
      s = el.scope();
      return $timeout.flush();
    }));
    return it("affect the width and innerWidth", function() {
      /*
      			console.log "width", s.width
      			console.log "innerwidth", s.innerWidth
      			console.log "m.left", s._margin.left
      			console.log "m.right", s._margin.right
      			console.log "s.outerWidth", s.outerWidth
      */
      expect(s.innerWidth + s._margin.left + s._margin.right === s.outerWidth).toBe(true);
      return expect(s.width + s._padding.left + s._padding.right === s.innerWidth).toBe(true);
    });
  });
  return describe("visibility", function() {
    var s;
    s = {};
    beforeEach(inject(function($timeout) {
      el.remove();
      el = angular.element('<div d3-vis fullwidth="600" visible="false"></div>');
      compile(el)(scope);
      scope.$digest();
      s = el.scope();
      return $timeout.flush();
    }));
    return it("is hidden if visible is false", function() {
      var c1, r1;
      r1 = s.svg.select("g > rect");
      c1 = r1.attr("class");
      return expect(c1).toBe("hide");
    });
  });
});

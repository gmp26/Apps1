'use strict';

/* jasmine specs for controllers go here */
describe("mathmoController", function() {

  beforeEach(module('app'));

  var scope;
  beforeEach(inject(function($rootScope, $controller) {
    scope = $rootScope.$new();
    $controller("mathmoController", {
      $scope: scope
    });

    var pane = scope.addQSet('unit-test')
  }));



  describe("makePartial1", function() {

    var mypane = {"name": "unit-test"};

    it("should produce lists", function() {
      expect(scope.testQ("C11", mypane)[0]).toBe("By completing the square, find (for real \\(x\\)) the minimum value of$$x^2 + 4x + 9.$$");
    });

  });

});


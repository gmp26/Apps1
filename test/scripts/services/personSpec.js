
beforeEach(module('app'));

beforeEach(function() {
  return this.addMatchers({
    toEqualData: function(expected) {
      return angular.equals(this.actual, expected);
    }
  });
});

describe('person service', function() {
  var $httpBackend, personService;
  personService = {};
  $httpBackend = {};
  beforeEach(inject(function(_$httpBackend_, $injector) {
    $httpBackend = _$httpBackend_;
    $httpBackend.expectGET('./people').respond([
      {
        name: 'Bob'
      }
    ]);
    return personService = $injector.get('personService');
  }));
  return it('should query for people at /people and receive an array', function() {
    var failure, success;
    success = function(result) {
      return expect(result).toEqualData([
        {
          name: 'Bob'
        }
      ]);
    };
    failure = function() {
      return expect(true).toBe(false);
    };
    personService.get(success, failure);
    return $httpBackend.flush();
  });
});

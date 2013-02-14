
beforeEach(module('app'));

describe('App', function() {
  var scope;
  scope = {};
  beforeEach(inject(function($controller, $rootScope) {
    scope = $rootScope.$new();
    return $controller('todoController', {
      $scope: scope
    });
  }));
  describe('add', function() {
    it('should add new todo', function() {
      scope.todos = [];
      scope.todoText = 'FAKE TODO';
      scope.addTodo();
      expect(scope.todos.length).toBe(1);
      return expect(scope.todos[0].text).toBe('FAKE TODO');
    });
    return it('should reset newText', function() {
      scope.todos = [];
      scope.todoText = 'SOME TEXT';
      scope.addTodo();
      return expect(scope.todoText).toBe('');
    });
  });
  describe('remaining', function() {
    return it('should return number of todos that are not done', function() {
      scope.todos = [
        {
          done: false
        }, {
          done: false
        }, {
          done: false
        }, {
          done: false
        }
      ];
      expect(scope.remaining()).toBe(4);
      scope.todos[0].done = true;
      return expect(scope.remaining()).toBe(3);
    });
  });
  return describe('archive', function() {
    return it('should remove todos that are done', function() {
      scope.todos = [
        {
          done: false
        }, {
          done: true
        }, {
          done: false
        }
      ];
      expect(scope.todos.length).toBe(3);
      scope.archive();
      return expect(scope.todos.length).toBe(2);
    });
  });
});

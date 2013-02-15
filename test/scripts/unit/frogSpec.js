
beforeEach(module('app'));

describe('App', function() {
  var scope;
  scope = {};
  return beforeEach(inject(function($controller, $rootScope) {
    scope = $rootScope.$new();
    return $controller('frogController', {
      $scope: scope
    });
  }));
  /*
  	describe 'add', () ->
  
  		it 'should add new todo', () ->
  			scope.todos = []
  			scope.todoText = 'FAKE TODO'
  
  			scope.addTodo()
  
  			expect(scope.todos.length).toBe 1
  			expect(scope.todos[0].text).toBe 'FAKE TODO'
  
  
  		it 'should reset newText', () ->
  			scope.todos = []
  			scope.todoText = 'SOME TEXT'
  			scope.addTodo()
  
  			expect(scope.todoText).toBe ''
  
  
  	describe 'remaining', () ->
  
  		it 'should return number of todos that are not done', () ->
  			scope.todos = [
  				{done: false}
  				{done: false}
  				{done: false}
  				{done: false}
  			]
  			expect(scope.remaining()).toBe 4
  
  			scope.todos[0].done = true
  			expect(scope.remaining()).toBe 3
  
  	describe 'archive', () ->
  
  		it 'should remove todos that are done', () ->
  			scope.todos = [
  				{done: false}
  				{done: true}
  				{done: false}
  			]
  
  			expect(scope.todos.length).toBe 3
  
  			scope.archive()
  			expect(scope.todos.length).toBe 2
  */

});

'use strict'

# jasmine specs for controllers go here

describe "mathmoController", ->
  beforeEach(module "app")

  scope = {} # We need this declared outside the scope of beforeEach

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    $controller("mathmoController", {
      $scope: scope
    })

  describe 'dummy', (_) ->

    it 'should pass', ->
      expect true .toBe true


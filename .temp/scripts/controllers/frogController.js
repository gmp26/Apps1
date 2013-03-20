angular.module('app').controller('frogController', [
  '$scope', '$timeout', function($scope, $timeout) {
    var MoveList, doneState, initialState, newTag, promises, reset, reversed, spawn;

    $scope._red = 2;
    $scope._blue = 2;
    if ($scope.container != null) {
      $scope.container.width = 650;
    }
    $scope.minMove = 8;
    $scope.savedMoves = [];
    $scope.showReplay = false;
    spawn = function(red, blue) {
      var _i, _results;

      return (function() {
        _results = [];
        for (var _i = -red; -red <= blue ? _i <= blue : _i >= blue; -red <= blue ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this).map(function(d, i) {
        return {
          colour: d < 0 ? 0 : d === 0 ? 1 : 2,
          x: i
        };
      });
    };
    initialState = null;
    doneState = [];
    promises = [];
    /*
    # class MoveList
    #   an easy to clone list of moves annotated with a tag string
    #   and the current red and blue counts.
    */

    MoveList = (function() {
      function MoveList(list, tag, red, blue) {
        this.list = list;
        this.tag = tag;
        this.red = red;
        this.blue = blue;
      }

      MoveList.prototype.clone = function() {
        return new MoveList(this.list.concat(), this.tag, this.red, this.blue);
      };

      return MoveList;

    })();
    reset = function() {
      initialState = spawn($scope._red, $scope._blue);
      $scope.frogs = spawn($scope._red, $scope._blue);
      $scope.moves = new MoveList([], void 0, $scope._red, $scope._blue);
      $scope.minMove = $scope._red * $scope._blue + $scope._red + $scope._blue;
      $scope.done = false;
      $scope.minimum = false;
      $scope.showReplay = $scope.savedMoves.length > 0;
      return promises.forEach(function(p) {
        return $timeout.cancel(p);
      });
    };
    reset();
    reversed = function(a, b) {
      return a.every(function(d, i) {
        var mirrorx;

        mirrorx = a.length - d.x - 1;
        return d.colour === b[mirrorx].colour;
      });
    };
    $scope.$watch("_red", reset);
    $scope.$watch("_blue", reset);
    $scope.reset = reset;
    $scope.hop = function(frog, space) {
      var _ref;

      $scope.moves.list.push({
        frogx: frog.x,
        spacex: space.x
      });
      _ref = [space.x, frog.x], frog.x = _ref[0], space.x = _ref[1];
      $scope.done = reversed($scope.frogs, initialState);
      $scope.minimum = $scope.done && $scope.moves.list.length === $scope.minMove;
      return $scope.showReplay || ($scope.showReplay = $scope.done);
    };
    $scope.replay = function(index) {
      var moves;

      if (index == null) {
        index = null;
      }
      if (index != null) {
        moves = $scope.savedMoves[index].clone();
      } else {
        moves = $scope.moves.clone();
      }
      $scope._red = moves.red;
      $scope._blue = moves.blue;
      reset();
      return $timeout(function() {
        return moves.list.forEach(function(d, i) {
          return promises.push($timeout(function() {
            var f, frog, space;

            frog = ((function() {
              var _i, _len, _ref, _results;

              _ref = $scope.frogs;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                f = _ref[_i];
                if (f.x === d.frogx) {
                  _results.push(f);
                }
              }
              return _results;
            })())[0];
            space = ((function() {
              var _i, _len, _ref, _results;

              _ref = $scope.frogs;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                f = _ref[_i];
                if (f.x === d.spacex) {
                  _results.push(f);
                }
              }
              return _results;
            })())[0];
            $scope.hop(frog, space);
            return frog.move(space);
          }, 800 * (i + 0.2)));
        });
      }, 0);
    };
    newTag = function() {
      return "try " + ($scope.savedMoves.length + 1);
    };
    $scope.save = function() {
      var saved;

      saved = $scope.moves.clone();
      saved.tag = $scope.moves.tag ? $scope.moves.tag : newTag();
      $scope.moves.tag = void 0;
      return $scope.savedMoves.push(saved);
    };
    $scope.forget = function(index) {
      return $scope.savedMoves.splice(index, 1);
    };
    return $scope.clear = function() {
      $scope.savedMoves = [];
      return reset();
    };
  }
]);

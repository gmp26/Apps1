/**
 * Inspired by AngularJS' implementation of "click dblclick mousedown..." and this gist: https://gist.github.com/3298323 
 *
 * This ties in touch events to attributes like:
 * 
 *   te-touchstart="add_something()"
 * 
 * Add in a script tag, then add to your app's dependencies.
 *
 * Copyright (c) 2012 Randall Bennett
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/

var teTouchevents = angular.module('teTouchevents', []);
angular.forEach('teTouchstart:touchstart teTouchend:touchend teTouchmove:touchmove teTouchcancel:touchcancel'.split(' '), function(name) {
  var directive = name.split(':');
  var directiveName = directive[0];
  var eventName = directive[1];
  teTouchevents.directive(directiveName, ['$parse', function($parse) {
    return function(scope, element, attr) {
      var fn = $parse(attr[directiveName]);
      var opts = $parse(attr[directiveName + 'Opts'])(scope, {});
      element.bind(eventName, function(event) {
        scope.$apply(function() {
          fn(scope, {$event: event});
        });
      });
    };
  }]);
});

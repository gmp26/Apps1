'use strict';

/**
 * @ngdoc directive
 * @name mgc.directive:mgcEval
 *
 * @description
 *
 * Evaluate a numerical expression as defined in a sanitised javascript syntax. 
 * Use * for multiply, / for divide, () for grouping. Results are rounded to 
 * the nearest integer, or to a number of decimal places (e.g. fixed="3") 
 * or to a certain precision (e.g. sigfigs="2").
 *
 * Expressions can use functions and constants defined in
 * {@link //developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Math Math},
 * or in the Controller $scope, or named in another mgcEval directive. See examples below.
 *
 * @element ANY
 * @example
   <doc:example module="mgc">
     <doc:source>

     <script>
       function Ctrl($scope) {
           // Variables defined within this scope may be used to evaluate functions
           // defined within the same scope. So here, we can define functions of
           // x, of y, or of (x,y). 
           $scope.x = 0;
           $scope.y = 0;

           // Functions defined within scope are available for use in expressions
           $scope.cube = function(x) {return x*x*x;};
       };
     </script>
     <div ng-controller="Ctrl">
     <dl>
     <dt>Define 'square'</dt>
     <dl> 
        If <i>x</i> is <input type="number" min="-10" max="10" ng-model="x">
        then <i>x</i><sup>2</sup> is: <span class="mgc-eval" fname="square" f="x->x*x" sigfigs="3"> </span>
     </dl>
     <dt>Use 'cube' defined in script.js</dt>
     <dl>
        The function 'cube' is defined in the controller scope and can be accessed via 'this'.
        e.g. <i>x</i><sup>3</sup> is 
        <span id="mgcEval2" class="mgc-eval" f="(x)->this.cube(x)" sigfigs="3"> </span>
     </dl>
     <dt>Use Math.sin</dt>
     <dl>
        Standard Math functions can be used without the Math prefix.
        e.g. sin(π<i>x</i>/10) is 
        <span id="mgcEval2" class="mgc-eval" f="(x)->sin(PI*x/10)" fixed="2"> </span>
     </dl>
     <dt>Use a function of 2 variables</dt>
     <dl> 
        <i>x</i> as before, with <i>y</i> as <input type="number" min="-10" max="10" ng-model="y">
        <i>xy</i> is <span class="mgc-eval" f="(x,y)->x*y" > </span>
     </dl>
     </dt>
    
     </div>
     </doc:source>

     <doc:scenario>
       it('should evaluate functions of x and (x,y)', function() {
         expect(element('.doc-example-live span:first').html()).toEqual("0.00");
         expect(element('#mgcEval2').html()).toEqual("0.00");
         expect(element('.doc-example-live span:last').html()).toEqual("0");

         input('x').enter(2);
         input('y').enter(5);

         expect(element('.doc-example-live span:first').html()).toEqual("4.00");
         expect(element('#mgcEval2').html()).toEqual("8.00");
         expect(element('.doc-example-live span:last').html()).toEqual("10");
       });
     </doc:scenario>

   </doc:example>
   */
  angular.module('mgc').directive('mgcEval', ['mgc.funcGen', function($funcGen) {
    var fg = $funcGen;

    return {
      restrict: 'C', // 
      scope: true,	
      link: function (scope, element, attrs) {


        var f = fg.define(attrs.f);

        if(attrs.fname) {
          scope.$parent[attrs.fname] = f;
        }

        scope.$watch(function (scope) {

          // collect arguments to f from the scope
          var args = f.params.map(function(p) {return scope[p];});

          // There may be functions defined on the parent scope
          var result = f.apply(scope.$parent, args);

          if(attrs.fixed) {
            element.html(result.toFixed(attrs.fixed));
          }
          else if(attrs.sigfigs) {
            element.html(result.toPrecision(attrs.sigfigs));
          } else {
            element.html(Math.round(result).toFixed(0).replace('.0',''));
          }
        });

      }
    };
  }
]);

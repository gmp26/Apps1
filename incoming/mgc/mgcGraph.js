/**
 * @ngdoc directive
 * @name mgc.directive:mgcSpace
 *
 * @description
 *  Create a rectangular space for vector graphics
 *
 * @element ANY
 * @example
   <doc:example module="mgc">

     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.sw = 300;
           $scope.sh = 200;
         };
       </script>
       <div ng-controller="Ctrl">
         <dl>
           <dt>Make a space for vector graphics</dt>
             <dd> 
              Set the width: <input type="number" min="100" max="600" value="300" ng-model="sw"><br />
              Set the height: <input type="number" min="100" max="600" value="200" ng-model="sh"><br />
              <mgc-space>
             </dd>
           </dt>
         </dl>   
       </div>
     </doc:source>
     <doc:scenario>
       it('should do something', function() {
       });
     </doc:scenario>
   </doc:example>
   */
angular.module('mgc').directive('mgcSpace', function() {
  return {
    restrict: 'EA',
    template: '<div style="width:{{sw}}px; height:{{sh}}px; border:1px solid black"></div>',
    replace: true
  };
});

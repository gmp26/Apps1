/**
 * @ngdoc directive
 * @name mgc.directive:mgcSortable
 *
 * @description
 * Apply mgc-sortable attribute to a container element to make it sortable in place by drag and drop.
 * Use with the {@link mgc.directive:mgcOrderCheck mgc-order-check} attribute if you also 
 * wish to provide the user with feedback on the correct order.
 * 
 * This directive uses jQuery-ui sortable. You can pass [options to jQuery-ui sortable](http://api.jqueryui.com/sortable/)
 * through the value of this attribute or globally via mgcConfig. e.g.
 * 
 * ````
 *     mgc-sortable = "{ appendTo: document.body }"
 * ````
 *
 * @element CONTAINER
 * @example
   <example module="mgc">

     <file name="index.html">
     <!-- a simple sortable container -->
     <div mgc-sortable>
      <div>item 2 - sortme</div>
      <div>item 3 - sortme</div>
      <div>item 1 - sortme</div>
      <div>item 4 - sortme</div>
     </div>
     <hr />
     <!-- a sortable list where the list is in a model in MyItemController -->
     <div ng-controller="MyItemController">
       <ul mgc-sortable ng-model="items">
         <li ng-repeat="item in items">{{item}}</li>
       </ul>
     <p>
     <!-- The model should change with any reordering. -->
     The first item is {{items | limitTo:1}}, and the last item is {{items | limitTo: -1}}.
     </p>
     </div>
     </file>

     <file name="script.js">
       angular.module('mgc').controller("MyItemController", ['$scope', function($scope) {
         $scope.items = ["Two", "Three", "One", "Four", "Five"];
       }]);
     </file>

     <file name="scenario.js">
       it('should allow user to sort a container', function() {
       });
     </file>
   </example>
   **/
angular.module('mgc').directive('mgcSortable', [
  'mgc.config', function(mgcConfig) {
    var options;
    options = {};
    if (mgcConfig.sortable != null) {
      angular.extend(options, mgcConfig.sortable);
    }
    return {
      require: '?ngModel',
      link: function(scope, element, attrs, ngModel) {
        var onStart, onUpdate, opts, _start, _update;
        opts = angular.extend({}, options, scope.$eval(attrs.mgcOptions));
        if (ngModel != null) {
          onStart = function(e, mgc) {
            return mgc.item.data('mgc-sortable-start', mgc.item.index());
          };
          onUpdate = function(e, mgc) {
            var end, start;
            start = mgc.item.data('mgc-sortable-start');
            end = mgc.item.index();
            ngModel.$modelValue.splice(end, 0, ngModel.$modelValue.splice(start, 1)[0]);
            return scope.$apply();
          };
          _start = opts.start;
          opts.start = function(e, mgc) {
            onStart(e, mgc);
            if (typeof _start === "function") {
              _start(e, mgc);
            }
            return scope.$apply();
          };
          _update = opts.update;
          opts.update = function(e, mgc) {
            onUpdate(e, mgc);
            if (typeof _update === "function") {
              _update(e, mgc);
            }
            return scope.$apply();
          };
        }
        return element.sortable(opts);
      }
    };
  }
]);

/**
 * @ngdoc directive
 * @name mgc.directive:mgcDraggable
 *
 * @description
 * Apply mgc-draggable attribute to an element to make it draggable.
 * 
 * This directive uses jQuery-ui draggable. You can pass [options to jQuery-ui draggable](http://api.jqueryui.com/draggable/)
 * through the value of this attribute or globally via mgcConfig. e.g.
 * 
 * ````
 *     mgc-draggable = "{ appendTo: document.body }"
 * ````
 * 
 *
 * @element CONTAINER
 * @example
   <example module="mgc">
     <file name="index.html">
      <div mgc-draggable class="special">item 2 - droppable</div>
      <div mgc-draggable class="special">item 3 - droppable</div>
      <div mgc-draggable>item 1 - drag me</div>
      <div mgc-draggable>item 4 - drag me</div>
      <div mgc-draggable>
        <img src="http://angularjs.org/img/AngularJS-small.png">
      </div>
      <div mgc-droppable style="width:300px; height:100px; background-color:#fff">
        drop here.
      <div>
     </file>
     <file name="style.css">
       .dragover {
         border: 2px solid #fc0;
       }
       .special {
         background-color: #faf;
         width:120px;
       }
     </file>
     <file name="script.js">
       angular.module('mgc').value('mgc.config', {
         draggable: {
           stack: '*' // option which causes all dragged item to rise to top.
         },
         droppable: {
           accept: '.special', 
           hoverClass: 'dragover',
           drop: function(event, ui) {
             ui.draggable.removeClass("special");
             ui.draggable.draggable("disable");
           }
         }
       });
     </file>
     <file name="scenario.js">
       it('should allow user to drag the items', function() {
       });
     </file>
   </example>
   **/
angular.module('mgc').directive('mgcDraggable', [
  'mgc.config', function(mgcConfig) {
    var options = {};
    if (mgcConfig.draggable != null) {
      angular.extend(options, mgcConfig.draggable);
    }
    return {
      link: function(scope, element, attrs, ngModel) {
        var opts;
        opts = angular.extend({}, options, scope.$eval(attrs.mgcOptions));
        return element.draggable(opts);
      }
    };
  }
])
.directive('mgcDroppable', [
  'mgc.config', function(mgcConfig) {
    var options = {};
    if (mgcConfig.droppable != null) {
      angular.extend(options, mgcConfig.droppable);
    }
    return {
      link: function(scope, element, attrs, ngModel) {
        var opts;
        opts = angular.extend({}, options, scope.$eval(attrs.mgcOptions));
        angular.forEach(opts, function(val, key) {console.log("opts["+key+"]="+val);});
        return element.droppable(opts);
      }
    };
  }
]);

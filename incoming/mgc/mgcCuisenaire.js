'use strict';

/**
 * @ngdoc directive
 * @name mgc.directive:mgcCuisenaire
 *
 * @description
 * Creates a cuisenaire rod manipulative.
 *
 * @element ANY
 * @example
   <example module="mgc">
     <file name="script.js">
       function RodCtrl($scope) {
           // Variables that control the rod model
           $scope.number = 5; // length of the factory rod is initially 5
           $scope.rodUnit = 30; // pixels
           $scope.rods = []; // array of rods on stage
       };
     </file>
     <file name="style.css">

       .cloner.vertical {
         min-height:300px;
         vertical-align:top;
         display:inline-block;
       }
       .cloner.horizontal {
         min-width: 300px;
       }
       .space {
         background-color: #fffffb;
         position: relative;
         min-width:300px;
         min-height:300px;
         vertical-align:top;
         display:inline-block;
         border:3px solid #ccc;
       }
       .clipped {
         overflow:hidden;
       }
       .board-hover {
         border:3px dashed #58f;
       }
       .board-active {
         border:3px solid #f85;
       }
       .rod {
         height: 26px;
         border: 2px solid #888;
         -webkit-border-radius: 3px;
         -moz-border-radius: 3px;
         -ms-border-radius: 3px;
         border-radius: 3px;
         position:absolute;

         transition: -transform 0.25s;
         -moz-transition: -moz-transform 0.25s;
         -webkit-transition: -webkit-transform 0.25s;
         -o-transition: -o-transform 0.25s;

         -webkit-transform-origin:50% 50%; 

         cursor: move;
       }
       .factory {
         position:relative;
         z-index: 100;
       }

       .n1 {
         height: 26px;
         width: 26px;
         background-color: #ffffff;
       }
       .n2 {
         height: 56px;
         width: 56px;
         background-color: #ee0033;
       }
       .n3 {
         height: 86px;
         width: 86px;
         background-color: #88cc44;
       }       
       .n4 {
         height: 116px;
         width: 116px;
         background-color: #aa2266;
       }
       .n5 {
         height: 146px;
         width: 146px;
         background-color: #ffd124;
       }    
       .n6 {
         height: 176px;
         width: 176px;
         background-color: #338877;
       }
       .n7 {
         height: 206px;
         width: 206px;
         background-color: #000000;
       }
       .n8 {
         height: 236px;
         width: 236px;
         background-color: #884422;
       }
       .n9 {
         height: 266px;
         width: 266px;
         background-color: #3355dd;
       }
       .n10 {
         height: 296px;
         width: 296px;
         background-color: #ff6600;
       }
       .rod.horizontal {
         height:26px;
       }  
       .rod.vertical {
         width: 26px;
       }


     </file>
     <file name="index.html">
       <div ng-controller="RodCtrl">
         <div class="well horizontal cloner">
           <div>Drag out a new <input type="number" ng-model="number" min="1" max="10" ng-value="5"> rod</div>
           <div mgc-rod-factory="{{number}}" axis="x"></div>
         </div>
         <div class="well vertical cloner" >
            <div mgc-rod-factory="{{number}}" axis="y"></div>
        </div>
         <div mgc-cuisenaire-board class="well space" >
           <div ng-repeat="rod in rods" mgc-rod="{{$index}}" class="rod n{{rod.number}} {{rod.horizontal}}" style="top:{{rodUnit*rod.y}}px; left:{{rodUnit*rod.x}}px">
           </div>
         </div>
       </div>

     </file>
     <file name="scenario.js">
       it('should display a stack of rods', function() {
       });
     </file>
   </example>
   **/
angular.module('mgc')
  .directive('mgcRodFactory', function() {

    var options = {};
    return {
      link: function(scope, element, attrs) {
        /*
        element.bind("dragstart", function(e) {
          scope.dragSource = element;
          e.dataTransfer.setData('text/plain', ""+scope.number);
        });
        */
        attrs.$observe('mgcRodFactory', function(number) {
          //scope.$apply(function() {
            element.removeClass("rod n1 n2 n3 n4 n5 n6 n7 n8 n9 n10"); //remove all classes
            element.addClass("rod");
            element.addClass("factory");
            element.addClass("n"+number);
          //});
        });

        attrs.$observe('axis', function(value) {
          //scope.$apply(function() {
            if(value === "y")
              element.addClass("vertical");
            else
              element.addClass("horizontal");
          //});
        });
      
        return element.draggable({
          helper: 'clone', 
          appendTo:"[mgc-cuisenaire-board]",
          stack: '.rod',
          start: function(event, ui) {
            $("[mgc-cuisenaire-board]").removeClass("clipped");
          }
        });
        
      }
    };
  })
  .directive('mgcCuisenaireBoard', function() {
    var getNumber = function(el) {
      for(var i=1; i <= 10; i++) {
        if(el.hasClass("n"+i)) return i;
      }
      return null;
    };
    var border = 2;
    return {
      link: function(scope, element, attrs) {
        var offset = element.offset();
        element.addClass("clipped");
        return element.droppable({
          accept: ".rod",
          activeClass: "board-hover",
          hoverClass: "board-active",
          snap: true,
          snapMode: "outer",
          snapTolerance: scope.rodUnit / 2,
          drop: function( event, ui ) {
            scope.$apply(function() {
              var n = getNumber(ui.helper);
              var x = Math.round(2 * ui.position.left / scope.rodUnit)/2;
              var y = Math.round(2 * ui.position.top / scope.rodUnit)/2;
              var rod, nw, nh;
              if(ui.helper.hasClass("horizontal")) {
                rod = {number: n, x:x, y:y, horizontal:"horizontal"};
                nh = 2;
                nw = n+1;
              }
              else {
                rod = {number: n, x:x, y:y, horizontal:"vertical"};
                nh = n+1;
                nw = 2;
              }
              element.width(Math.max(element.width(), (x+nw)*scope.rodUnit));
              element.height(Math.max(element.height(), (y+nh)*scope.rodUnit));

              element.addClass("clipped");
              console.log("dropped at: "+x+", "+y);

              if(ui.helper.hasClass('factory')) {
                scope.rods.push(rod);
              }
              else {
                var id = ui.draggable.attr("mgc-rod");
                scope.rods[id] = rod;
              }
            });
          }
        });
      }
    }; 
  })
  .directive('mgcRod', function() {

    var options = {};
    return {
      restrict: 'A',
      scope: false,
      link: function(scope, element, attrs) {
        
        var rod = scope.rod;
        var el = element;
        /*
        scope.$apply(function() {
          if(rod.horizontal)
            element.addClass("horizontal")
        });
        */
        console.log("number = "+rod.number+" x="+rod.x+" y="+rod.y+" horiz="+rod.horizontal);

        attrs.$observe('mgcRod', function(value) {
          console.log('mgcRod = '+value);
        });


      return element.draggable({
        stack: '.rod',
        snap: true,
        snapMode: "outer",
        snapTolerance: scope.rodUnit / 2,
        appendTo:"[mgc-cuisenaire-board]"
      });
    }
  };
});

angular.module('tangle', [])
.directive('adjustable', function() {

  'use strict';

  var isAnyAdjustableNumberDragging = false;  // hack for dragging one value over another one

  return {
    restrict: 'E',

    template:'<span class="TKAdjustableNumber" ng-transclude ' +
      'ng-mouseenter="showHelp()" ' +
      'ng-mouseleave="hideHelp()" ' + 
       '></span>',
    replace: true,
    transclude: true,

    // 'adjustable' directive controller
    controller: ['$scope', '$element', '$attrs',  function($scope, $element, $attrs) {

      var isHovering = false;
      var isDragging;
      var helpElement;
      var isActive = function () {
        return isDragging || (isHovering && !isAnyAdjustableNumberDragging);
      };
      var valueAtMouseDown;
      var body = angular.element(document.getElementsByTagName("body")[0]);

      var updateRolloverEffects = function () {
        updateStyle();
        updateCursor();
        updateHelp();
      };
        
      var updateStyle = function () {
        if (isDragging) { $element.addClass("TKAdjustableNumberDown"); }
        else { $element.removeClass("TKAdjustableNumberDown"); }
        
        if (isDragging && isActive()) { 
          $element.addClass("TKAdjustableNumberHover"); 
        }
        else {
          $element.removeClass("TKAdjustableNumberHover"); 
        }
      };

      var updateCursor = function () {
        if (isActive()) { body.addClass("TKCursorDragHorizontal"); }
        else { body.removeClass("TKCursorDragHorizontal"); }
      };

      var updateHelp = function () {
        var top = (7 - $element[0].offsetHeight) + "px";
        var left = (Math.round(0.5 * ($element[0].offsetWidth - 20))) + "px";
        var display = (isHovering && !isAnyAdjustableNumberDragging) ? "block" : "none";
        helpElement.css({ left:left, top:top, display:display });
      };

      var initializeHelp = function () {
        helpElement = angular.element(document.createElement('div')).addClass("TKAdjustableNumberHelp");
        helpElement.css("display", "none");
        helpElement.text("drag");
        $element.append(helpElement);
      };
        
      $scope.showHelp = function() {
        isHovering = true;  
        updateRolloverEffects();        
      };

      $scope.hideHelp = function() {
        isHovering = false; 
        updateRolloverEffects();           
      };

      // drag
        
      var initializeDrag = function() {
        isDragging = false;

        $element.bind("mousedown", mouseDown);
        $element.bind("touchstart", touchStart);

      };
      
      /////////// derivative events

      var mouseDown = function(e) {
        e.stopPropagation();

        body.bind('mousemove', mouseMove);
        body.bind('mouseup', mouseUp);
      
        $scope.mouser = touches(e);
        touchDidGoDown($scope.mouser);
      };

      var mouseMove = function(e) {
        e.stopPropagation();
        $scope.mouser._updateWithEvent(e);
        touchDidMove($scope.mouser);
      };

      var mouseUp = function(e) {
        e.stopPropagation();
        $scope.mouser._goUpWithEvent(e);
        touchDidGoUp($scope.mouser);
        
        body.unbind('mousemove', mouseMove);
        body.unbind('mouseup', mouseUp);
      };

      var touchStart = function(e) {
        e.stopPropagation();

        if ($scope.toucher || e.length > 1) { 
          $scope.touchCancel(e); return; 
        }
    
        body.bind('touchmove', touchMove);
        body.bind('touchend', touchEnd);
        body.bind('touchcancel', touchEnd);
      
        $scope.toucher = touches(event);
        touchDidGoDown($scope.toucher);
      };
      
      var touchMove = function (e) {
        e.stopPropagation();
        if (!$scope.toucher) { return; }

        $scope.toucher._updateWithEvent(e);
        this.touchDidMove($scope.toucher);
      };
      
      var touchEnd = function (e) {
        e.stopPropagation();
        if (!$scope.toucher) { return; }

        $scope.toucher._goUpWithEvent(e);
        this.touchDidGoUp($scope.toucher);
        
        body.unbind('touchmove', touchMove);
        body.unbind('touchend', touchEnd);
        body.unbind('touchcancel', touchEnd);
      };

      var touches = function (event) {

        var ts = event.timeStamp;

        return {
          globalPoint : { x:event.pageX, y:-event.pageY },
          translation : { x:0, y:0 },
          deltaTranslation : { x:0, y:0 },
          velocity : { x:0, y:0 },
          count : 1,
          event : event,
          timestamp : event.timeStamp,
          downTimestamp : event.timeStamp,

          _updateWithEvent: function (event, isRemoving) {
            var dx, dy, dt, timestamp, isSamePoint, isStopped;
            this.event = event;
            if (!isRemoving) {
              dx = event.pageX - this.globalPoint.x;  // todo, transform to local coordinate space?
              dy = -event.pageY - this.globalPoint.y;
              this.translation.x += dx;
              this.translation.y += dy;
              this.deltaTranslation.x += dx;
              this.deltaTranslation.y += dy;
              this.globalPoint.x = event.pageX;
              this.globalPoint.y = -event.pageY;
            }
            timestamp = event.timeStamp;
            dt = timestamp - this.timestamp;
            isSamePoint = isRemoving || (dx === 0 && dy === 0);
            isStopped = (isSamePoint && dt > 150);
            
            this.velocity.x = isStopped ? 0 : (isSamePoint || dt === 0) ? this.velocity.x : (dx / dt * 1000);
            this.velocity.y = isStopped ? 0 : (isSamePoint || dt === 0) ? this.velocity.y : (dy / dt * 1000);
            this.timestamp = timestamp;
          },

          _goUpWithEvent: function (event) {
            this._updateWithEvent(event, true);
            this.count = 0;
            
            var didMove = Math.abs(this.translation.x) > 10 || Math.abs(this.translation.y) > 10;
            var wasMoving = Math.abs(this.velocity.x) > 400 || Math.abs(this.velocity.y) > 400;
            this.wasTap = !didMove && !wasMoving && (this.getTimeSinceGoingDown() < 300);
          },
          getTimeSinceGoingDown: function () {
            return this.timestamp - this.downTimestamp;
          },
          resetDeltaTranslation: function () {
            this.deltaTranslation.x = 0;
            this.deltaTranslation.y = 0;
          }
        };
      };

      ///////////// Delegates

      var touchDidGoDown = function (touches) {
        valueAtMouseDown = $scope.value;
        isDragging = true;
        isAnyAdjustableNumberDragging = true;
        updateRolloverEffects();
      };
      
      var touchDidMove = function (touches) {
        var value = valueAtMouseDown + touches.translation.x / 5 * $scope.step;
        value = (Math.round(value / $scope.step) * $scope.step);
        $scope.$apply(function() {
          $scope.value = Math.max($scope.min, Math.min($scope.max, value));
          $scope[$scope.varName] = $scope.value;
        });
        updateHelp();
      };
      
      var touchDidGoUp = function (touches) {
        isDragging = false;
        isAnyAdjustableNumberDragging = false;
        updateRolloverEffects();
        helpElement.css({display: touches.wasTap ? "block" : "none"});
      };

      initializeHelp();
      initializeDrag();

    }],

    link: function(scope, element, attrs) {

      element.css({'pointer-events' : 'auto'});
      attrs.$observe('min', function(val) {
        scope.min = (val !== undefined) ? parseFloat(val) : 0;
      });

      attrs.$observe('max', function(val) {
        scope.max = (val !== undefined) ? parseFloat(val) : 1e100;
      });

      attrs.$observe('step', function(val) {
        scope.step = (val !== undefined) ? parseFloat(val) : 1;
      });

      attrs.$observe('number', function(val) {
        scope.varName = val;
        scope.$watch(val.toString(), function(newVal) {
          scope.value = newVal;
        });
      });

    }
  
  };

});
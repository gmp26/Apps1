app.directive('mgcDotplot', function factory(funcGen, settings) {
  // define constants and helpers used for the directive
  // ...

	var dump = function(name, obj) {
		angular.forEach(obj, function(value, key) {
			console.log(name+"."+key+"="+value);
		});
	};

	var fg = funcGen;

	var fillClasses = ["less", "equal", "more"];

	var fill = function(p, f) {
		var x = p[0];
		var y = p[1];
		return fillClasses[fCompare(f, x, y) + 1];
	};

	var fCompare = function(f, x, y) {
			if (Math.abs(y - f(x)) < 1e-4) return 0;
			if (y > f(x)) return 1;
			else return -1;
		};

	var plotWidth = 380;
	var plotHeight = 380;

	var leftOffset = 20;
	var topOffset = 20;

	var toPlot = function(p) {
			return [toX(p[0]), toY(p[1])];
		};
		
	var fromPlot = function(p) {
			return [fromX(p[0]), fromY(p[1])];
		};

	// data to X axis 
	var toX = d3.scale.linear().domain([settings.xMin, settings.xMax]).range([leftOffset, leftOffset + plotWidth]);

	// X axis to data
	var fromX = toX.invert;

	// data to Y axis 
	var toY = d3.scale.linear().domain([settings.yMin, settings.yMax]).range([topOffset + plotHeight, topOffset]);

	// data from Y axis 
	var fromY = toY.invert;

	var redraw = function(dot, element, f) {
		var pot = toPlot(dot); 
		element.addClass("dot");
		element.removeClass("more less equal");
		element.addClass(fill(dot, f));
		element.css({left:pot[0]+"px",top:pot[1]+"px"});
	};

  var dirdef = {
    restrict: 'E', // the directive can be invoked only by using  tag in the template
    scope: false,
		compile: function(tElement, tAttrs, transclude) {
			//dump("tElement", tElement);
			//dump("tAttrs", tAttrs);
			//dump("transclude", transclude);
			//tElement.html(fg.define(tAttrs.f).f);
			
			
			return function (scope, element, attrs) {
		    // initialization, done once per my-directive tag in template. If my-directive is within an
		    // ng-repeat-ed template then it will be called every time ngRepeat creates a new copy of the template.

				var f = fg.define(scope.f);

		    //dump("scope", scope);
				//dump("element", element);
				//dump("attrs", attrs);
				//console.log(fg.define(scope.f).f);

				//var f = fg.define(attrs.f);

				//console.log(element.html());
				//element.html("foo");

				scope.$watch('f', function(newVal, oldVal) {
					//console.log("newVal="+f);
					try {
						f = fg.define(scope.f);
						redraw(scope.dot, element, f);
					}
					catch(e) {};
				});

		    // whenever the bound 'exp' expression changes, execute this 
		    scope.$watch('x', function (newVal, oldVal) {
		      // ...
					var pot = toPlot(scope.dot); 
					element.addClass("dot");
					element.addClass(fill(scope.dot, f));
					element.css({left:pot[0]+"px",top:pot[1]+"px"});
		    });
		  };
			
		}
  };

	return dirdef;
});
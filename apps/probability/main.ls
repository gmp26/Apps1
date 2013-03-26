require {
  shim:
    'controllers/appController':
      deps:
        * 'app'
        ...
    'controllers/todoController':
      deps:
        * 'app'
        ...
    'controllers/frogController':
      deps:
        * 'app'
        ...
    'controllers/boomerangController':
      deps:
        * 'app'
        ...
    'controllers/spinController':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'directives/frogs':
      deps:
        * 'app'
        ...
    'directives/frog':
      deps:
        * 'app'
        ...
    'directives/d3Spinner':
      deps:
        * 'app'
          'directives/d3Vis'
          'libs/d3.v3'
    'directives/tiltedSquare':
      deps:
        * 'app'
          'libs/fabric'
    'directives/d3Vis':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'directives/d3DotGrid':
      deps:
        * 'app'
          'directives/d3Vis'
    'directives/d3TiltedSquare':
      deps:
        * 'app'
          'directives/d3DotGrid'
    'directives/svgCheck':
      deps:
        * 'app'
          'libs/d3.v3'
    'directives/appVersion':
      deps:
        * 'app'
          'services/semver'
    'services/semver':
      deps:
        * 'app'
        ...
    'bootstrap':
      deps:
        * 'app'
          'libs/angular'
    'libs/bootstrap':
      deps:
        * 'libs/jquery'
        ...
    'libs/angular-resource':
      deps:
        * 'libs/angular'
        ...
    'libs/ui-bootstrap-tpls':
      deps:
        * 'libs/angular'
        ...
    'app': 
      deps:
        * 'libs/angular'
          'libs/angular-resource'
          'libs/ui-bootstrap-tpls'
    'routes':
      deps:
        * 'app'
        ...
    'views':
      deps:
        * 'app'
        ...
},
  * 'require'
    'controllers/appController'
    'controllers/spinController'
    'directives/appVersion'
    'directives/d3Vis'
    'directives/d3DotGrid'
    'directives/d3TiltedSquare'
    'directives/d3Spinner'
    'routes'
    'views'
, (require) -> require ['bootstrap']
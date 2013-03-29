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
    'pubs/frogs/controllers/frogController':
      deps:
        * 'app'
        ...
    'pubs/boomerangs/controllers/boomerangController':
      deps:
        * 'app'
        ...
    'pubs/probability/controllers/spinController':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'pubs/probability/controllers/prob9546Controller':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'pubs/frogs/directives/frogs':
      deps:
        * 'app'
        ...
    'pubs/frogs/directives/frog':
      deps:
        * 'app'
        ...
    'pubs/probability/directives/d3Spinner':
      deps:
        * 'app'
          'directives/d3Vis'
          'libs/d3.v3'
    'directives/d3Vis':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'directives/d3DotGrid':
      deps:
        * 'app'
          'directives/d3Vis'
    'pubs/tilted/directives/d3TiltedSquare':
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
    'pubs/probability/controllers/spinController'
    'pubs/probability/controllers/prob9546Controller'
    'pubs/probability/directives/d3Spinner'
    'directives/appVersion'
    'routes'
    'views'
, (require) -> require ['bootstrap']
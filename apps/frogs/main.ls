shim = 
  shim:
    'controllers/appController':
      deps:
        * 'app'
        ...
    'controllers/todoController':
      deps:
        * 'app'
        ...
    'frog-controller':
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
    'frogs-directive':
      deps:
        * 'app'
        ...
    'frog-directive':
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
        ...
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

configure = [
  'require'
  'controllers/appController'
  'frog-controller'
  'frogs-directive'
  'frog-directive'
  'directives/appVersion'
  'routes'
  'views'
]

config =
  paths: 
    'frog-controller': '../../apps/frogs/controllers/frogController'
    'frogs-directive': '../../apps/frogs/directives/frogs'
    'frog-directive': '../../apps/frogs/directives/frog'

require.config config

require shim, configure, (require) -> require ['bootstrap']
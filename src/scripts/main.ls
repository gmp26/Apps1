require {
  shim:
    'libs/qa/helpers':
      deps:
        * 'libs/seedrandom'
        ...

    'libs/qa/helpers2':
      deps:
        * 'libs/seedrandom'
        ...

    'libs/qa/complex':
      deps:
        * 'libs/seedrandom'
          'libs/qa/polys'
          'libs/qa/guessExact'
          'libs/qa/helpers'
          'libs/qa/helpers2'

    'libs/qa/fractions':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
          'libs/qa/helpers2'

    'libs/qa/polys':
      deps:
        * 'libs/seedrandom'
          'libs/qa/guessExact'
          'libs/qa/helpers'
          'libs/qa/helpers2'

    'libs/qa/fpolys':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
          'libs/qa/helpers2'
          'libs/qa/fractions'

    'libs/qa/guessExact':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
          'libs/qa/helpers2'
          'libs/qa/fractions'

    'libs/qa/stats':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
          'libs/qa/helpers2'

    'libs/qa/geometry':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
          'libs/qa/helpers2'

    'libs/qa/problems':
      deps:
        * 'libs/seedrandom'
          'libs/qa/complex'
          'libs/qa/fpolys'
          'libs/qa/fractions'
          'libs/qa/guessExact'
          'libs/qa/helpers'
          'libs/qa/helpers2'
          'libs/qa/polys'
          'libs/qa/stats'
          'libs/qa/geometry'

    'pubs/mathmo/services/config':
      deps:
        * 'app'
          'libs/qa/problems'

    'pubs/mathmo/services/questionStore':
      deps:
        * 'app'
          'libs/seedrandom'

    'pubs/mathmo/controllers/mathmoController':
      deps:
        * 'app'
          'pubs/mathmo/services/config'
          'pubs/mathmo/services/questionStore'

    'pubs/mathmo/directives/mathmoPlot':
      deps:
        * 'app'
          'pubs/mathmo/controllers/mathmoController'
          'directives/d3Vis'
          'services/d3LineChart'
          'libs/d3.v3'

    'controllers/appController':
      deps:
        * 'app'
        ...
    'pubs/todo/controllers/todoController':
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
    'pubs/probability/controllers/prob9546ResultsController':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'pubs/probability/controllers/prob9525ResultsController':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'pubs/probability/controllers/sampleSpinController':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'pubs/probability/controllers/spinGroupController':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'
    'controllers/mathmoController':
      deps:
        * 'app'
        ...
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
    'services/d3LineChart':
      deps:
        * 'app'
        'libs/d3.v3'
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
},
  * 'require'
    'controllers/appController'
    'pubs/todo/controllers/todoController'
    'pubs/frogs/controllers/frogController'
    'pubs/frogs/directives/frogs'
    'pubs/frogs/directives/frog'
    'pubs/boomerangs/controllers/boomerangController'
    'pubs/probability/controllers/sampleSpinController'
    'pubs/probability/controllers/spinGroupController'
    'pubs/probability/controllers/prob9546ResultsController'
    'pubs/probability/controllers/prob9525ResultsController'
    'pubs/probability/directives/d3Spinner'
    'pubs/tilted/directives/d3TiltedSquare'
    'pubs/mathmo/controllers/mathmoController'
    'pubs/mathmo/directives/mathmoPlot'
    'directives/appVersion'
    'routes'
    'views'
, (require) -> require ['bootstrap']

require {
  shim:
    'libs/qa/helpers':
      deps:
        * 'libs/seedrandom'
        ...

    'libs/qa/complex':
      deps:
        * 'libs/seedrandom'
          'libs/qa/polys'
          'libs/qa/guessExact'
          'libs/qa/helpers'

    'libs/qa/fractions':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
        
    'libs/qa/polys':
      deps:
        * 'libs/seedrandom'
          'libs/qa/guessExact'
          'libs/qa/helpers'

    'libs/qa/fpolys':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
          'libs/qa/fractions'

    'libs/qa/guessExact':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'
          'libs/qa/fractions'

    'libs/qa/stats':
      deps:
        * 'libs/seedrandom'
          'libs/qa/helpers'


    'libs/qa/problems':
      deps:
        * 'libs/seedrandom'
          'libs/qa/complex'
          'libs/qa/fpolys'
          'libs/qa/fractions'
          'libs/qa/guessExact'
          'libs/qa/helpers'
          'libs/qa/polys'
          'libs/qa/stats'

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

    'controllers/appController':
      deps:
        * 'app'
        ...

    'directives/d3Vis':
      deps:
        * 'app'
          'libs/d3.v3'
          'directives/svgCheck'

    'directives/d3DotGrid':
      deps:
        * 'app'
          'directives/d3Vis'

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
},
  * 'require'
    'controllers/appController'
    'pubs/mathmo/controllers/mathmoController'
    'directives/appVersion'
    'routes'
    'views'
, (require) -> require ['bootstrap']
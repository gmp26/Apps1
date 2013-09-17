require {
  shim:
    'pubs/mathmo/services/config':
      deps:
        * 'app'
        'libs/qalib'

    'pubs/mathmo/services/questionStore':
      deps:
        * 'app'
        ...

    'pubs/mathmo/controllers/mathmoController':
      deps:
        * 'app'
          'pubs/mathmo/services/config'
          'pubs/mathmo/services/questionStore'
          'directives/mathWatch'

    'pubs/mathmo/directives/mathmoPlot':
      deps:
        * 'app'
          'pubs/mathmo/controllers/mathmoController'
          'directives/d3Vis'
          'services/d3MultiLineChart'
          'libs/d3.v3'

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
          
    'directives/mathWatch':
      deps:
        * 'app'
        ...

    'directives/appVersion':
      deps:
        * 'app'
          'services/semver'

    'services/semver':
      deps:
        * 'app'
        ...

    'services/d3MultiLineChart':
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
    'pubs/mathmo/controllers/mathmoController'
    'pubs/mathmo/directives/mathmoPlot'
    'directives/appVersion'
    'routes'
    'views'
, (require) -> require ['bootstrap']

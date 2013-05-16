require {
  shim:
    'controllers/appController':
      deps:
        * 'app'
        ...
    'controllers/shiftingController':
      deps:
        * 'app'
        ...
    'controllers/shiftingDirective':
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
    'pubs/shifting/controllers/shiftingController'
    'pubs/shifting/directives/shiftingDirective'
    'directives/appVersion'
    'routes'
    'views'
, (require) -> require ['bootstrap']
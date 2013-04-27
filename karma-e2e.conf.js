basePath = './';

files = [
  ANGULAR_SCENARIO,
  ANGULAR_SCENARIO_ADAPTER,
  './dist/scripts/libs/jquery.js',
  './dist/scripts/libs/d3.v3.js',
  './dist/scripts/libs/angular.js',
  './dist/scripts/libs/angular-resource.js',
  './test/scripts/libs/angular-mocks.js',
  './dist/scripts/app.js',
  './dist/scripts/templates.js',
  './dist/scripts/controllers/*.js',
  './dist/scripts/directives/*.js',
//  './dist/scripts/filters/*.js',
  './dist/scripts/services/*.js',

  './test/scripts/e2e/**/*.js'
  /*,
  './test/scripts/directives/*.js',
  './test/scripts/filters/*.js',
  './test/scripts/services/*.js',
  */
];

autoWatch = false;

browsers = ['Chrome'];

singleRun = true;

proxies = {
  '/': 'http://localhost:3005/'
};

junitReporter = {
  outputFile: 'test_out/e2e.xml',
  suite: 'e2e'
};
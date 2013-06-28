// list of files / patterns to load in the browser
files = [
	JASMINE,
	JASMINE_ADAPTER,
	'./dist/scripts/libs/angular.js',
	'./dist/scripts/libs/angular-resource.js',
	'./dist/scripts/libs/ui-bootstrap-tpls.js',
	'./dist/scripts/libs/d3.v3.js',
	'./test/scripts/libs/angular-mocks.js',
	'./test/scripts/libs/prelude-browser-min.js',

	/* things under test */
	'./dist/scripts/app.js',
	'./dist/scripts/**/controllers/*.js',
	'./dist/scripts/**/directives/*.js',
	'./dist/scripts/**/filters/*.js',
	'./dist/scripts/**/responseInterceptors/*.js',
	'./dist/scripts/**/services/*.js',

	/* test scripts */
	'./dist_test/scripts/controllers/*.js',
	'./dist_test/scripts/directives/*.js',
	'./dist_test/scripts/filters/*.js',
	'./dist_test/scripts/services/*.js',

	'./dist_test/pubs/**/*.js',

  /* This line needs to be specific or bootstrap.js throws an error */
  /* http://stackoverflow.com/questions/9227406/ */
  './dist_test/scripts/libs/qa/*.js',

  /* Added by Alex */
  // './dist/scripts/*.js',
  // './dist/scripts/pubs/mathmo/**/*.js',
  './dist/scripts/pubs/mathmo/services/*.js',
  // './dist/scripts/pubs/mathmo/services/*.js',
  './dist/scripts/libs/seedrandom.js',
  './test/unit/**/*.js'
];

// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;

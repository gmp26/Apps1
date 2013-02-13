# Apps1
A collection of Apps for [NRICH](http://nrich.maths.org)
Originally based on AngularFun
*By [@CaryLandholt](https://twitter.com/carylandholt)*

The aim is to make this app host a few related apps and for the basis for similar collections.

Templates are handled via the templateCache and the grunt-angular-templates task.
This simplfies directive testing when templateURL is used.

## About
TiltedSquares is an [AngularJS](http://angularjs.org/) large application Reference Architecture.  The intent is to provide a base for creating your own AngularJS applications with minimal boilerplate setup and ceremony.

Simply follow the patterns and you'll get a complete development workflow, including:

* file organization
* compilation of [CoffeeScript](http://coffeescript.org/) files
* compilation of [LESS](http://lesscss.org/) files
* three build configurations
	* **default** - compilation with no optimizations
	* **dev** - compilation with no optimizations but includes file watching to monitor changes and build changed files on-the-fly
	* **prod** - compilation with all optimizations, including concatenation and minification of JavaScript, CSS, and HTML
* full dependency management (file loading and dependency resolution)
* an in-browser unit testing strategy
* a server to run the application

## Prerequisites
* Must have [Git](http://git-scm.com/) installed
* Must have [node.js (at least v0.8.1)](http://nodejs.org/) installed with npm (Node Package Manager)
* Must have [CoffeeScript](https://npmjs.org/package/coffee-script) node package installed globally.  `npm install -g coffee-script`
* Must have [Grunt](https://github.com/gruntjs/grunt) node package installed globally.  `npm install -g grunt`

## Install Apps1
Enter the following commands in the terminal.

1. `git clone git://github.com/gmp26/Apps1.git`
1. `cd Apps1`
1. `git checkout d3`
1. `npm install`

## Compile Apps1
You have three options.

1. `grunt` - will compile the app preserving individual files (when run, files will be loaded on-demand)
2. `grunt dev` - same as `grunt` but will watch for file changes and recompile on-the-fly
3. `grunt prod` - will compile using optimizations.  This will create one JavaScript file and one CSS file to demonstrate the power of [r.js](http://requirejs.org/docs/optimization.html), the build optimization tool for RequireJS.  And take a look at the index.html file.  Yep - it's minified too.

## Run It
1. Navigate to the root of the project
2. `grunt server`
3. Open the [app](http://localhost:3005/) in your browser to run the app

## Making Changes
* `grunt dev` will watch for any CoffeeScript (.coffee), Less (.less), or .template file changes.  When changes are detected, the files will be linted, compiled, and ready for you to refresh the browser.

## Running Tests
You have two options.

1. [Jasmine](http://pivotal.github.com/jasmine/) HTML runner -  run `grunt` - Then open /test/runner.html in your browser to run the unit tests using Jasmine.
2. [Testacular](http://vojtajina.github.com/testacular/) - `grunt test` -  Defaults to running the tests in chrome, but you can easily change this in testacular.conf.js browsers section as required.


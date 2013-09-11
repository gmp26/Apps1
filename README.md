# DO NOT USE FOR NEW APPS

Instead use [yeoman](http://yeoman.io) and our [LiveScript app generator](http://github.com/gmp26/generator-angular-ls).

The result is much easier to update and maintain - and it's much better if each app has its own repo rather than
have them all piled in here.

You will need to install angular-ui/bootstrap from bower if you need it.
You may want then want to remove jQuery from the generated app.


# Apps1
A collection of Apps for [NRICH](http://nrich.maths.org)
*By [@grumplet](https://twitter.com/grumplet)*

Derived from AngularFun
*By [@CaryLandholt](https://twitter.com/carylandholt)*

The aim is to make this app host a few related apps and form the basis of similar collections. 

Added some grunt tasks:

* `grunt mask:<appname>` causes only the named app to be generated in the final dist.
* `grunt unmask` causes all apps to be present. Useful for test purposes.

Converted codebase to [LiveScript](http://livescript.net).

Updated to grunt-0.4 in all but the playlist branch which is
still at grunt-0.3.

## Now using grunt-lsc updated to LiveScript 1.2.0

Until npm module grunt-lsc is published at v1.0.1 - the one that uses Livescript 1.2.0 - use [this trick](http://www.devthought.com/2012/02/17/npm-tricks/) to link it from a copy cloned from the github repo which is already at v1.0.1:


```
$ git clone https://github.com/gwwfps/grunt-lsc.git
$ cd grunt-lsc
$ npm link
$ cd ~/angular/Apps1

# this will install your local version of grunt-lsc
$ npm link grunt-lsc

# since grunt-lsc is now installed, npm install will ignore it:
$ npm install

``` 


## About
Apps1 is an [AngularJS](http://angularjs.org/) app collection.

Follow the patterns and you'll get a complete development workflow, including:

* file organization
* transpilation of [CoffeeScript](http://coffeescript.org/) files (_if you prefer plain JavaScript, see [JS Love](#js-love)_)
* transpilation of [LESS](http://lesscss.org/) files
* three build configurations
	* **default** - compilation with no optimizations
	* **dev** - compilation with no optimizations but includes file watching to monitor changes and build changed files on-the-fly
	* **prod** - compilation with all optimizations, including concatenation and minification of PNG, JavaScript, CSS, and HTML files.
* full dependency management (file loading and dependency resolution)
* an in-browser unit testing strategy
* a server to run the application

## Prerequisites
* Text editor - preferably TextMate or Sublime Text, set to translate tabs
  to 2 spaces. We use 2 spaces per indent for LiveScript. If using these
  editors, install the [livescript.tmbundle](https://github.com/paulmillr/livescript.tmbundle) for syntax checking.

* Must have [Git](http://git-scm.com/) installed
* Must have [node.js (at least v0.8.1)](http://nodejs.org/) installed with npm (Node Package Manager)
* Must have [CoffeeScript](https://npmjs.org/package/coffee-script) node package installed globally.  `npm install -g coffee-script`
* Must have [Grunt](https://github.com/gruntjs/grunt) node package installed globally.  `npm install -g grunt-cli`

## Install Apps1
Enter the following commands at a command line:

    git clone git://github.com/gmp26/Apps1.git
    cd Apps1
    npm install

## Compile Apps1
You have three options.

1. `grunt` - will compile the app preserving individual files (when run, files will be loaded on-demand)
2. `grunt dev` - same as `grunt` but will watch for file changes and recompile on-the-fly
3. `grunt prod` - will compile using optimizations.  This will create one JavaScript file and one CSS file to demonstrate the power of [r.js](http://requirejs.org/docs/optimization.html), the build optimization tool for RequireJS.  And take a look at the `index.html` file.  Yep - it's minified too.

## Using Javascript instead of Coffeescript
To work with plain old JavaScript run the following grunt task.
`grunt jslove` - it will transpile all of the CoffeeScript files to JavaScript and throw out the Coffee.

## Run It
1. Navigate to the root of the project
2. `grunt server`
3. Open the [app](http://localhost:3005/) in your browser to run the app

## Making Changes
* `grunt dev` will watch for any CoffeeScript (`.coffee`), Less (`.less`), or `.template` file changes.  When changes are detected, the files will be linted, compiled, and ready for you to refresh the browser.

## Running Tests
You have two options.

1. [Jasmine](http://pivotal.github.com/jasmine/) HTML runner -  run `grunt` - Then open `/test/runner.html` in your browser to run the unit tests using Jasmine.
2. [Karma](http://vojtajina.github.com/karma/) - `grunt test` -  Defaults to running the tests in Chrome, but you can easily change this in `karma.conf.js` browsers section as required.

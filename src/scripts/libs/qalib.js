require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"HU2YCy":[function(require,module,exports){
// seedrandom.js version 2.1.
// Author: David Bau
// Date: 2013 Mar 16
//
// Defines a method Math.seedrandom() that, when called, substitutes
// an explicitly seeded RC4-based algorithm for Math.random().  Also
// supports automatic seeding from local or network sources of entropy.
//
// http://davidbau.com/encode/seedrandom.js
// http://davidbau.com/encode/seedrandom-min.js
//
// Usage:
//
//   <script src=http://davidbau.com/encode/seedrandom-min.js></script>
//
//   Math.seedrandom('yay.');  Sets Math.random to a function that is
//                             initialized using the given explicit seed.
//
//   Math.seedrandom();        Sets Math.random to a function that is
//                             seeded using the current time, dom state,
//                             and other accumulated local entropy.
//                             The generated seed string is returned.
//
//   Math.seedrandom('yowza.', true);
//                             Seeds using the given explicit seed mixed
//                             together with accumulated entropy.
//
//   <script src="https://jsonlib.appspot.com/urandom?callback=Math.seedrandom">
//   </script>                 Seeds using urandom bits from a server.
//
// More advanced examples:
//
//   Math.seedrandom("hello.");           // Use "hello." as the seed.
//   document.write(Math.random());       // Always 0.9282578795792454
//   document.write(Math.random());       // Always 0.3752569768646784
//   var rng1 = Math.random;              // Remember the current prng.
//
//   var autoseed = Math.seedrandom();    // New prng with an automatic seed.
//   document.write(Math.random());       // Pretty much unpredictable x.
//
//   Math.random = rng1;                  // Continue "hello." prng sequence.
//   document.write(Math.random());       // Always 0.7316977468919549
//
//   Math.seedrandom(autoseed);           // Restart at the previous seed.
//   document.write(Math.random());       // Repeat the 'unpredictable' x.
//
//   function reseed(event, count) {      // Define a custom entropy collector.
//     var t = [];
//     function w(e) {
//       t.push([e.pageX, e.pageY, +new Date]);
//       if (t.length < count) { return; }
//       document.removeEventListener(event, w);
//       Math.seedrandom(t, true);        // Mix in any previous entropy.
//     }
//     document.addEventListener(event, w);
//   }
//   reseed('mousemove', 100);            // Reseed after 100 mouse moves.
//
// Version notes:
//
// The random number sequence is the same as version 1.0 for string seeds.
// Version 2.0 changed the sequence for non-string seeds.
// Version 2.1 speeds seeding and uses window.crypto to autoseed if present.
//
// The standard ARC4 key scheduler cycles short keys, which means that
// seedrandom('ab') is equivalent to seedrandom('abab') and 'ababab'.
// Therefore it is a good idea to add a terminator to avoid trivial
// equivalences on short string seeds, e.g., Math.seedrandom(str + '\0').
// Starting with version 2.0, a terminator is added automatically for
// non-string seeds, so seeding with the number 111 is the same as seeding
// with '111\0'.
//
// When seedrandom() is called with zero args, it uses a seed
// drawn from the browser crypto object if present.  If there is no
// crypto support, seedrandom() uses the current time, the native rng,
// and a walk of several DOM objects to collect a few bits of entropy.
//
// Each time the one- or two-argument forms of seedrandom are called,
// entropy from the passed seed is accumulated in a pool to help generate
// future seeds for the zero- and two-argument forms of seedrandom.
//
// On speed - This javascript implementation of Math.random() is about
// 3-10x slower than the built-in Math.random() because it is not native
// code, but that is typically fast enough.  Some details (timings on
// Chrome 25 on a 2010 vintage macbook):
//
// seeded Math.random()          - avg less than 0.0002 milliseconds per call
// seedrandom('explicit.')       - avg less than 0.2 milliseconds per call
// seedrandom('explicit.', true) - avg less than 0.2 milliseconds per call
// seedrandom() with crypto      - avg less than 0.2 milliseconds per call
// seedrandom() without crypto   - avg about 12 milliseconds per call
//
// On a 2012 windows 7 1.5ghz i5 laptop, Chrome, Firefox 19, IE 10, and
// Opera have similarly fast timings.  Slowest numbers are on Opera, with
// about 0.0005 milliseconds per seeded Math.random() and 15 milliseconds
// for autoseeding.
//
// LICENSE (BSD):
//
// Copyright 2013 David Bau, all rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   1. Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//
//   2. Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
//   3. Neither the name of this module nor the names of its contributors may
//      be used to endorse or promote products derived from this software
//      without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
/**
 * All code is in an anonymous closure to keep the global namespace clean.
 */
(function (
    global, pool, math, width, chunks, digits) {

//
// The following constants are related to IEEE 754 limits.
//
var startdenom = math.pow(width, chunks),
    significance = math.pow(2, digits),
    overflow = significance * 2,
    mask = width - 1;

//
// seedrandom()
// This is the seedrandom function described above.
//
math['seedrandom'] = function(seed, use_entropy) {
  var key = [];

  // Flatten the seed string or build one from local entropy if needed.
  var shortseed = mixkey(flatten(
    use_entropy ? [seed, tostring(pool)] :
    0 in arguments ? seed : autoseed(), 3), key);

  // Use the seed to initialize an ARC4 generator.
  var arc4 = new ARC4(key);

  // Mix the randomness into accumulated entropy.
  mixkey(tostring(arc4.S), pool);

  // Override Math.random

  // This function returns a random double in [0, 1) that contains
  // randomness in every bit of the mantissa of the IEEE 754 value.

  math['random'] = function() {         // Closure to return a random double:
    var n = arc4.g(chunks),             // Start with a numerator n < 2 ^ 48
        d = startdenom,                 //   and denominator d = 2 ^ 48.
        x = 0;                          //   and no 'extra last byte'.
    while (n < significance) {          // Fill up all significant digits by
      n = (n + x) * width;              //   shifting numerator and
      d *= width;                       //   denominator and generating a
      x = arc4.g(1);                    //   new least-significant-byte.
    }
    while (n >= overflow) {             // To avoid rounding up, before adding
      n /= 2;                           //   last byte, shift everything
      d /= 2;                           //   right using integer math until
      x >>>= 1;                         //   we have exactly the desired bits.
    }
    return (n + x) / d;                 // Form the number within [0, 1).
  };

  // Return the seed that was used
  return shortseed;
};

//
// ARC4
//
// An ARC4 implementation.  The constructor takes a key in the form of
// an array of at most (width) integers that should be 0 <= x < (width).
//
// The g(count) method returns a pseudorandom integer that concatenates
// the next (count) outputs from ARC4.  Its return value is a number x
// that is in the range 0 <= x < (width ^ count).
//
/** @constructor */
function ARC4(key) {
  var t, keylen = key.length,
      me = this, i = 0, j = me.i = me.j = 0, s = me.S = [];

  // The empty key [] is treated as [0].
  if (!keylen) { key = [keylen++]; }

  // Set up S using the standard key scheduling algorithm.
  while (i < width) {
    s[i] = i++;
  }
  for (i = 0; i < width; i++) {
    s[i] = s[j = mask & (j + key[i % keylen] + (t = s[i]))];
    s[j] = t;
  }

  // The "g" method returns the next (count) outputs as one number.
  (me.g = function(count) {
    // Using instance members instead of closure state nearly doubles speed.
    var t, r = 0,
        i = me.i, j = me.j, s = me.S;
    while (count--) {
      t = s[i = mask & (i + 1)];
      r = r * width + s[mask & ((s[i] = s[j = mask & (j + t)]) + (s[j] = t))];
    }
    me.i = i; me.j = j;
    return r;
    // For robust unpredictability discard an initial batch of values.
    // See http://www.rsa.com/rsalabs/node.asp?id=2009
  })(width);
}

//
// flatten()
// Converts an object tree to nested arrays of strings.
//
function flatten(obj, depth) {
  var result = [], typ = (typeof obj)[0], prop;
  if (depth && typ == 'o') {
    for (prop in obj) {
      if (obj.hasOwnProperty(prop)) {
        try { result.push(flatten(obj[prop], depth - 1)); } catch (e) {}
      }
    }
  }
  return (result.length ? result : typ == 's' ? obj : obj + '\0');
}

//
// mixkey()
// Mixes a string seed into a key that is an array of integers, and
// returns a shortened string seed that is equivalent to the result key.
//
function mixkey(seed, key) {
  var stringseed = seed + '', smear, j = 0;
  while (j < stringseed.length) {
    key[mask & j] =
      mask & ((smear ^= key[mask & j] * 19) + stringseed.charCodeAt(j++));
  }
  return tostring(key);
}

//
// autoseed()
// Returns an object for autoseeding, using window.crypto if available.
//
/** @param {Uint8Array=} seed */
function autoseed(seed) {
  try {
    global.crypto.getRandomValues(seed = new Uint8Array(width));
    return tostring(seed);
  } catch (e) {
    return [+new Date, global.document, global.history,
            global.navigator, global.screen, tostring(pool)];
  }
}

//
// tostring()
// Converts an array of charcodes to a string
//
function tostring(a) {
  return String.fromCharCode.apply(0, a);
}

//
// When seedrandom.js is loaded, we immediately mix a few bits
// from the built-in RNG into the entropy pool.  Because we do
// not want to intefere with determinstic PRNG state later,
// seedrandom will not call math.random on its own again after
// initialization.
//
mixkey(math.random(), pool);

// End anonymous scope, and pass initial values.
})(
  this,   // global window object
  [],     // pool: entropy pool starts empty
  Math,   // math: package containing random, pow, and seedrandom
  256,    // width: each RC4 output is 0 <= x < 256
  6,      // chunks: at least six RC4 outputs for each double
  52      // digits: there are 52 significant digits in a double
);

},{}],"seedrandom":[function(require,module,exports){
module.exports=require('HU2YCy');
},{}],3:[function(require,module,exports){
module.exports = function(cplex){
  var stats, rand, gx, guessExact, helpers, ascoeff, complex, Complex, c_poly;
  stats = require('./stats')(cplex);
  rand = stats.rand;
  gx = require('./guessExact')(cplex);
  guessExact = gx.guessExact;
  helpers = require('./helpers')(cplex);
  ascoeff = helpers.ascoeff;
  cplex.complex = complex = (function(){
    complex.displayName = 'complex';
    var prototype = complex.prototype, constructor = complex;
    function complex(Re, Im){
      this.Re = Re;
      this.Im = Im;
    }
    prototype.set = function(Re, Im){
      this.Re = Re;
      this.Im = Im;
      return this;
    };
    prototype.ptoc = function(Mod, Arg){
      var z;
      z = new complex;
      z.Re = Mod * Math.cos(Arg);
      z.Im = Mod * Math.sin(Arg);
      return z;
    };
    prototype.random = function(maxentry, rad){
      var z;
      z = new complex;
      z = Complex.ptoc(rand(0, maxentry), Math.PI * rand(0, rad * 2) / rad);
      return z;
    };
    prototype.randnz = function(maxentry, rad){
      var z;
      z = new complex;
      z = Complex.ptoc(rand(1, maxentry), Math.PI * rand(0, rad * 2) / rad);
      return z;
    };
    prototype.ctop = function(z){
      var Mod, Arg;
      z == null && (z = this);
      Mod = Math.sqrt(Math.pow(z.Re, 2) + Math.pow(z.Im, 2));
      Arg = Math.atan2(z.Im, z.Re);
      return [Mod, Arg];
    };
    prototype.isnull = function(){
      return !(this.Re || this.Im);
    };
    prototype.write = function(){
      var u;
      u = [guessExact(this.Re), guessExact(this.Im)];
      if (u[1] === 0) {
        return u[0];
      } else if (u[0] === 0) {
        return ascoeff(u[1]) + "i";
      } else {
        return (u[0] + " + " + ascoeff(u[1]) + "i").replace(/\+ \-/g, '-');
      }
    };
    prototype.add = function(u, v){
      var w;
      w = new complex(this.Re + u, this.Im + v);
      return w;
    };
    prototype.times = function(u, v){
      var w;
      w = new complex(this.Re * u - this.Im * v, this.Re * v + this.Im * u);
      return w;
    };
    prototype.divide = function(u, v){
      var d, w;
      d = Math.pow(u, 2) + Math.pow(v, 2);
      w = new complex((u * this.Re + v * this.Im) / d, (u * this.Im - v * this.Re) / d);
      return w;
    };
    prototype.equals = function(u, v){
      return this.Re === u && this.Im === v;
    };
    return complex;
  }());
  cplex.Complex = Complex = new complex;
  cplex.c_poly = c_poly = (function(){
    c_poly.displayName = 'c_poly';
    var prototype = c_poly.prototype, constructor = c_poly;
    function c_poly(rank){
      this.rank;
    }
    prototype.terms = function(){
      var n, i$, to$, i;
      n = 0;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        if (!this[i].isnull) {
          n++;
        }
      }
      return n;
    };
    prototype.set = function(){
      var i$, to$, i, results$ = [];
      this.rank = this.set.arguments.length - 1;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i] = this.set.arguments.argument[i]);
      }
      return results$;
    };
    prototype.setrand = function(maxentry, rad){
      var i$, to$, i;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        this[i] = Complex.random(maxentry, rad);
      }
      if (this[this.rank].isnull) {
        return this[this.rank].set(1, 0);
      }
    };
    prototype.compute = function(z){
      var y, zp, i$, to$, i, zi;
      y = new complex(0, 0);
      zp = z.ctop();
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        zi = Complex.ptoc(Math.pow(zp[0], i), zp[1] * i);
        y = y.add(zi[0], zi[1]);
      }
      return y;
    };
    prototype.xthru = function(x){
      var i$, to$, i, results$ = [];
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i] = this[i].times(z.Re, z.Im));
      }
      return results$;
    };
    prototype.addp = function(x){
      var i$, to$, i, results$ = [];
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i] = this[i].add(x[i].Re, x[i].Im));
      }
      return results$;
    };
    prototype.diff = function(d){
      var i$, to$, i;
      d.rank = rank - 1;
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        d[i] = this[i + 1].times(i + 1, 0);
      }
      return d;
    };
    prototype.integ = function(d){
      var i$, to$, i;
      d.rank = rank + 1;
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        d[i + 1] = this[i].divide(i + 1, 0);
      }
      return d;
    };
    prototype.write = function(l){
      var q, j, i$, i;
      l == null && (l = "z");
      q = "";
      j = false;
      for (i$ = this.rank; i$ >= 0; --i$) {
        i = i$;
        if (!this[i].isnull()) {
          if (j) {
            if ((this[i].Im === 0 && this[i].Re < 0) || (this[i].Re === 0 && this[i].Im < 0)) {
              q += " - ";
            } else {
              q += " + ";
            }
            j = false;
          }
          switch (i) {
          case 0:
            q += this[i].write();
            j = true;
            break;
          case 1:
            if (this[i].equals(1, 0) || this[i].equals(-1, 0)) {
              q += l;
            } else if (this[i].equals(0, 1) || this[i].equals(0, -1)) {
              q += "i" + l;
            } else if (this[i].Im === 0 && this[i].Re < 0) {
              q += Math.abs(this[i].Re) + l;
            } else if (this[i].Re === 0 && this[i].Im < 0) {
              q += Math.abs(this[i].Im) + "i" + l;
            } else {
              q += "(" + this[i].write() + ")" + l;
            }
            j = true;
            break;
          default:
            if (this[i].equals(1, 0) || this[i].equals(-1, 0)) {
              q += l + "^" + i;
            } else if (this[i].equals(0, 1) || this[i].equals(0, -1)) {
              q += "i" + l + "^" + i;
            } else if (this[i].Im === 0 && this[i].Re < 0) {
              q += Math.abs(this[i].Re) + l + "^" + i;
            } else if (this[i].Re === 0 && this[i].Im < 0) {
              q += Math.abs(this[i].Im) + "i" + l + "^" + i;
            } else {
              q += "(" + this[i].write() + ")" + l + "^" + i;
            }
            j = true;
          }
        }
      }
      return q;
    };
    prototype.rwrite = function(l){
      var q, j, i$, to$, i;
      l == null && (l = "z");
      q = "";
      j = false;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        if (!this[i].isnull()) {
          if (j) {
            if ((this[i].Im === 0 && this[i].Re < 0) || (this[i].Re === 0 && this[i].Im < 0)) {
              q += " - ";
            } else {
              q += " + ";
            }
            j = false;
          }
          switch (i) {
          case 0:
            q += this[i].write();
            j = true;
            break;
          case 1:
            if (this[i].equals(1, 0) || this[i].equals(-1, 0)) {
              q += l;
            } else if (this[i].equals(0, 1) || this[i].equals(0, -1)) {
              q += "i" + l;
            } else if (this[i].Im === 0 && this[i].Re < 0) {
              q += Math.abs(this[i].Re) + l;
            } else if (this[i].Re === 0 && this[i].Im < 0) {
              q += Math.abs(this[i].Im) + "i" + l;
            } else {
              q += "(" + this[i].write() + ")" + l;
            }
            j = true;
            break;
          default:
            if (this[i].equals(1, 0) || this[i].equals(-1, 0)) {
              q += l + "^" + i;
            } else if (this[i].equals(0, 1) || this[i].equals(0, -1)) {
              q += "i" + l + "^" + i;
            } else if (this[i].Im === 0 && this[i].Re < 0) {
              q += Math.abs(this[i].Re) + l + "^" + i;
            } else if (this[i].Re === 0 && this[i].Im < 0) {
              q += Math.abs(this[i].Im) + "i" + l + "^" + i;
            } else {
              q += "(" + this[i].write() + ")" + l + "^" + i;
            }
            j = true;
          }
        }
      }
      return q;
    };
    return c_poly;
  }());
  return cplex;
};
},{"./guessExact":8,"./helpers":9,"./stats":14}],4:[function(require,module,exports){
/*
 * mathmo question/answer configuration
 */
module.exports = function(config){
  var m, k, v, results$ = [];
  require('./problems')(config);
  m = {
    topicById: function(id){
      return this.topics[id];
    },
    topicTitleById: function(id){
      return this.topics[id][0];
    },
    topicMakerById: function(id){
      return this.topics[id][1];
    },
    groups: [
      {
        title: "Algebraic",
        topicIds: ["C11", "C7", "C9", "C1", "C30", "C13", "C17", "C35", "C36", "C37"]
      }, {
        title: "Curve sketching",
        topicIds: ["C24", "C25", "C26", "C270", "C27"]
      }, {
        title: "Geometry",
        topicIds: ["C15", "C16", "C6", "C31", "C32", "C33", "C34", "C38", "C39"]
      }, {
        title: "Sequences & series",
        topicIds: ["C8", "C12", "C23", "C2"]
      }, {
        title: "Vectors",
        topicIds: ["C5", "C18"]
      }, {
        title: "Differentiation",
        topicIds: ["C14", "C20", "C21", "C22", "C19"]
      }, {
        title: "Integration",
        topicIds: ["C28", "C3", "C4"]
      }, {
        title: "Differential equations",
        topicIds: ["C29", "F3a"]
      }, {
        title: "Further Topics",
        topicIds: ["F1", "F2", "F4", "F5", "F7", "F8", "F9", "F10", "F11", "F12", "F13"]
      }, {
        title: "Statistics Topics",
        topicIds: ["S1", "S2", "S3", "S4", "S5", "S6"]
      }
    ],
    topics: {
      "C1": ["Partial fractions", config.makePartial],
      "C2": ["Binomial theorem", config.makeBinomial2],
      "C3": ["Polynomial integration", config.makePolyInt],
      "C4": ["Trig integration", config.makeTrigInt],
      "C5": ["Scalar products", config.makeVector],
      "C6": ["3D Lines", config.makeLines],
      "C7": ["Inequalities", config.makeIneq],
      "C8": ["Arithmetic progressions", config.makeAP],
      "C9": ["Factor theorem", config.makeFactor],
      "C10": ["Quadratics", config.makeQuadratic],
      "C11": ["Completing the square", config.makeComplete],
      "C12": ["Binomial expansion", config.makeBinExp],
      "C13": ["Logarithms", config.makeLog],
      "C14": ["Stationary points", config.makeStationary],
      "C15": ["Triangles", config.makeTriangle],
      "C16": ["Circles", config.makeCircle],
      "C17": ["Trig equations", config.makeSolvingTrig],
      "C18": ["Vector equations", config.makeVectorEq],
      "C19": ["Implicit differentiation", config.makeImplicit],
      "C20": ["The chain rule", config.makeChainRule],
      "C21": ["The product rule", config.makeProductRule],
      "C22": ["The quotient rule", config.makeQuotientRule],
      "C23": ["Geometric progressions", config.makeGP],
      "C24": ["Modulus function", config.makeModulus],
      "C25": ["Transforms of functions", config.makeTransformation],
      "C26": ["Composition of functions", config.makeComposition],
      "C27": ["Parametric functions", config.makeParametric],
      "C270": ["Implicit functions", config.makeImplicitFunction],
      "C28": ["Integration", config.makeIntegration],
      "C29": ["Differential equations", config.makeDE],
      "C30": ["Powers", config.makePowers],
      "C31": ["Equations of 2D lines", config.makeLinesEq],
      "C32": ["Equations of circles", config.makeCircleEq],
      "C33": ["Parallel and perpendicular lines", config.makeLineParPerp],
      "C34": ["Intersections of circles and lines", config.makeCircLineInter],
      "C35": ["Highest common factors", config.makeHCF],
      "C36": ["Least common multiples", config.makeLCM],
      "C37": ["Integer solutions to equations", config.makeDiophantine],
      "C38": ["Distance between points", config.makeDistance],
      "C39": ["Circle passing through three points", config.makeCircumCircle],
      "F1": ["Complex Arithmetic", config.makeCArithmetic],
      "F2": ["Modulus Argument", config.makeCPolar],
      "F3a": ["2nd order DEs", config.makeDETwoHard],
      "F4": ["Rank 2 matrices", config.makeMatrix2],
      "F5": ["Taylor Series", config.makeTaylor],
      "F6": ["Polar Coordinates", config.makePolarSketch],
      "F7": ["Rank 3 matrices", config.makeMatrix3],
      "F8": ["Further vectors", config.makeFurtherVector],
      "F9": ["Newton-Raphson", config.makeNewtonRaphson],
      "F10": ["Further inequalities", config.makeFurtherIneq],
      "F11": ["Integration by substitution", config.makeSubstInt],
      "F12": ["Figures of revolution", config.makeRevolution],
      "F13": ["Matrix transformations", config.makeMatXforms],
      'S1': ["Discrete Distributions", config.makeDiscreteDistn],
      'S2': ["Continuous Distributions", config.makeContinDistn],
      'S3': ["Hypothesis Testing", config.makeHypTest],
      'S4': ["Confidence Intervals", config.makeConfidInt],
      'S5': ["Chi Squared", config.makeChiSquare],
      'S6': ["Product Moments", config.makeProductMoment]
    }
  };
  for (k in m) {
    v = m[k];
    results$.push(config[k] = v);
  }
  return results$;
};
},{"./problems":11}],5:[function(require,module,exports){
module.exports = function(fpolys){
  var fractions, frac, toFrac, fcoeff, fbcoeff, fpoly;
  fractions = require('./fractions')(fpolys);
  frac = fractions.frac;
  toFrac = fractions.toFrac;
  fpolys.fcoeff = fcoeff = function(f, t){
    if (f.top === f.bot) {
      return t;
    } else if (f.top + f.bot === 0) {
      return "-" + t;
    } else if (f.top === 0) {
      return "";
    } else {
      return f.write() + t;
    }
  };
  fpolys.fbcoeff = fbcoeff = function(f, t){
    var g;
    g = new frac(Math.abs(f.top), Math.abs(f.bot));
    if (g.top === g.bot) {
      return t;
    } else if (g.top === 0) {
      return "";
    } else {
      return g.write() + t;
    }
  };
  fpolys.fpoly = fpoly = (function(){
    fpoly.displayName = 'fpoly';
    var prototype = fpoly.prototype, constructor = fpoly;
    function fpoly(rank){
      this.rank = rank;
    }
    prototype.terms = function(){
      var n, i$, to$, i;
      n = 0;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        if (this[i]) {
          n++;
        }
      }
      return n;
    };
    prototype.set = function(){
      var i$, to$, i, results$ = [];
      this.rank = this.set.arguments.length - 1;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i] = toFrac(this.set.arguments[i]));
      }
      return results$;
    };
    prototype.setrand = function(maxentry){
      var i$, to$, i;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        this[i] = randfrac(12);
      }
      if (this[this.rank].top === 0) {
        this[this.rank].top = maxentry;
      }
      return this[this.rank].reduce();
    };
    prototype.setpoly = function(a){
      var i$, to$, i, results$ = [];
      this.rank = a.rank;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i] = new frac(a[i], 1));
      }
      return results$;
    };
    prototype.compute = function(x){
      var y, i$, to$, i;
      x = toFrac(x);
      y = new frac(0, 1);
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        y.add(this[i].top * Math.pow(x.top, i), this[i].bot * Math.pow(x.bot, i));
      }
      y.reduce();
      return y;
    };
    prototype.gcd = function(){
      var g, i$, to$, i, a;
      g = new frac(0, 1);
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        g.bot *= this[i].bot;
      }
      a = this[this.rank].top * g.bot / this[this.rank].bot;
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        a = gcd(a, this[i].top * g.bot / this[i].bot);
      }
      return g.reduce();
    };
    prototype.xthru = function(x){
      var i$, to$, i, results$ = [];
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i].prod(x));
      }
      return results$;
    };
    prototype.diff = function(d){
      var i$, to$, i;
      d.rank = rank - 1;
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        d[i] = this[i + 1];
        d[i].prod(frac(i + 1, 1));
      }
      return d;
    };
    prototype.integ = function(d){
      var i$, to$, i;
      d.rank = this.rank + 1;
      d[0] = new frac();
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        d[i + 1] = this[i];
        d[i + 1].bot *= i + 1;
        d[i + 1].reduce();
      }
      return d;
    };
    prototype.write = function(){
      var q, j, i$, i, val, a;
      q = "";
      j = false;
      for (i$ = this.rank; i$ >= 0; --i$) {
        i = i$;
        val = this[i].top / this[i].bot;
        if (val < 0) {
          if (j) {
            q += " ";
          }
          q += "- ";
          j = false;
        } else if (j && val) {
          q += " + ";
          j = false;
        }
        if (val) {
          a = new frac(Math.abs(this[i].top, this[i].bot));
          switch (i) {
          case 0:
            q += a.write();
            j = true;
            break;
          case 1:
            if (a.top === a.bot) {
              q += "x";
            } else {
              q += a.write() + "x";
            }
            j = true;
            break;
          default:
            if (a.top === a.bot) {
              q += "x^" + i;
            } else {
              q += a.write() + "x^" + i;
            }
            j = true;
          }
        }
        return q;
      }
    };
    prototype.rwrite = function(){
      var q, j, i$, to$, i, val, a;
      q = "";
      j = false;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        val = this[i].top / this[i].bot;
        if (val < 0) {
          if (j) {
            q += " ";
          }
          q += "- ";
          j = false;
        } else if (j && val) {
          q += " + ";
          j = false;
        }
        if (val) {
          a = new frac(Math.abs(this[i].top), Math.abs(this[i].bot));
          switch (i) {
          case 0:
            q += a.write();
            j = true;
            break;
          case 1:
            if (a.top === a.bot) {
              q += "x";
            } else {
              q += a.write() + "x";
            }
            j = true;
            break;
          default:
            if (a.top === a.bot) {
              q += "x^" + i;
            } else {
              q += a.write() + "x^" + i;
            }
            j = true;
          }
        }
      }
      return q;
    };
    return fpoly;
  }());
  return fpolys;
};
},{"./fractions":6}],6:[function(require,module,exports){
module.exports = function(fractions){
  var helpers, gcd, lcm, stats, rand, randnz, frac, toFrac, randfrac, fmatrix;
  fractions.fractionsLoaded = true;
  if (!fractions.helpersLoaded) {
    helpers = require('./helpers')(fractions);
  } else {
    helpers = fractions;
  }
  gcd = helpers.gcd;
  lcm = helpers.lcm;
  stats = require('./stats')(fractions);
  rand = stats.rand;
  randnz = stats.randnz;
  fractions.frac = frac = (function(){
    frac.displayName = 'frac';
    var prototype = frac.prototype, constructor = frac;
    function frac(top, bot){
      if (typeof top === "undefined") {
        this.top = 0;
      } else {
        this.top = top;
      }
      if (typeof bot === "undefined") {
        this.bot = 1;
      } else {
        this.bot = bot;
      }
      this.reduce();
    }
    prototype.write = function(){
      if (this.bot === 1) {
        return this.top;
      }
      if (this.top === 0) {
        return "0";
      } else if (this.top > 0) {
        return "\\frac{" + this.top + "}{" + this.bot + "}";
      } else {
        return "-\\frac{" + Math.abs(this.top) + "}{" + this.bot + "}";
      }
    };
    prototype.reduce = function(){
      var c;
      if (this.bot < 0) {
        this.top *= -1;
        this.bot *= -1;
      }
      c = gcd(Math.abs(this.top), this.bot);
      this.top /= c;
      return this.bot /= c;
    };
    prototype.set = function(a, b){
      this.top = a;
      this.bot = b;
      return this.reduce();
    };
    prototype.clone = function(){
      var f;
      f = new frac(this.top, this.bot);
      return f;
    };
    prototype.equals = function(b){
      this.reduce();
      b.reduce();
      if (this.top === b.top && this.bot === b.bot) {
        return 1;
      } else {
        return 0;
      }
    };
    prototype.add = function(c, d){
      d == null && (d = 1);
      this.set(this.top * d + this.bot * c, this.bot * d);
      this.reduce();
      return this;
    };
    prototype.prod = function(c){
      c = toFrac(c);
      this.set(this.top * c.top, this.bot * c.bot);
      this.reduce();
      return this;
    };
    return frac;
  }());
  fractions.toFrac = toFrac = function(n){
    if (typeof n === "number") {
      return new frac(n, 1);
    } else if (n instanceof frac) {
      return n.clone();
    } else {
      throw new Error("toFrac received " + typeof n + " expecting number or frac");
    }
  };
  fractions.randfrac = randfrac = function(max){
    var f;
    f = new frac(rand(max), randnz(max));
    f.reduce();
    return f;
  };
  fractions.fmatrix = fmatrix = (function(){
    fmatrix.displayName = 'fmatrix';
    var prototype = fmatrix.prototype, constructor = fmatrix;
    function fmatrix(dim){
      this.dim = dim;
    }
    prototype.zero = function(){
      var i$, to$, i, lresult$, j$, to1$, j, results$ = [];
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        lresult$ = [];
        this[i] = new Array(this.dim);
        for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
          j = j$;
          lresult$.push(this[i][j] = new frac(0));
        }
        results$.push(lresult$);
      }
      return results$;
    };
    prototype.clone = function(){
      var r, i$, to$, i, j$, to1$, j;
      r = new fmatrix(this.dim);
      r.zero();
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
          j = j$;
          r[i][j] = this[i][j].clone();
        }
      }
      return r;
    };
    prototype.set = function(){
      var args, n, i$, to$, i, lresult$, j$, to1$, j, results$ = [];
      args = this.set.arguments;
      n = this.dim;
      if (args.length === Math.pow(n, 2)) {
        this.zero();
        for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
          i = i$;
          lresult$ = [];
          for (j$ = 0, to1$ = n - 1; j$ <= to1$; ++j$) {
            j = j$;
            lresult$.push(this[i][j] = toFrac(args[i * n + j]));
          }
          results$.push(lresult$);
        }
        return results$;
      } else {
        throw new Error("Wrong number of elements sent to fmatrix.set()");
      }
    };
    prototype.setrand = function(maxentry){
      var i$, to$, i, lresult$, j$, to1$, j, results$ = [];
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        lresult$ = [];
        this[i] = new Array(this.dim);
        for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
          j = j$;
          lresult$.push(this[i][j] = toFrac(rand(maxentry)));
        }
        results$.push(lresult$);
      }
      return results$;
    };
    prototype.add = function(a){
      var s, i$, to$, i, j$, to1$, j;
      if (this.dim !== a.dim) {
        throw new Error("Size mismatch matrices sent to matrix.add()");
      } else {
        s = new fmatrix(this.dim);
        for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
          i = i$;
          s[i] = new Array(this.dim);
          for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
            j = j$;
            s[i][j] = this[i][j].clone().add(a[i][j].top, a[i][j].bot);
          }
        }
        return s;
      }
    };
    prototype.times = function(a){
      var s, i$, to$, i, j$, to1$, j, k$, to2$, k, f;
      if (this.dim !== a.dim) {
        throw new Error("Size mismatch matrices sent to matrix.times()");
      } else {
        s = new fmatrix(this.dim);
        for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
          i = i$;
          s[i] = new Array(this.dim);
          for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
            j = j$;
            s[i][j] = toFrac(0);
          }
        }
        for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
          i = i$;
          for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
            j = j$;
            for (k$ = 0, to2$ = this.dim - 1; k$ <= to2$; ++k$) {
              k = k$;
              f = this[i][j].clone().prod(a[j][k]);
              s[i][k].add(f.top, f.bot);
            }
          }
        }
        return s;
      }
    };
    prototype.det = function(){
      var f, g, res, i$, to$, i, minor, j$, to1$, j, k$, to2$, k;
      if (this.dim === 1) {
        return this[0][0].clone();
      } else if (this.dim === 2) {
        f = this[0][1].clone().prod(this[1][0]).prod(-1);
        g = this[0][0].clone().prod(this[1][1]).add(f.top, f.bot);
        return g.clone();
      } else {
        res = new frac(0, 1);
        for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
          i = i$;
          minor = new fmatrix(this.dim - 1);
          for (j$ = 0, to1$ = this.dim - 2; j$ <= to1$; ++j$) {
            j = j$;
            minor[j] = new Array(this.dim - 1);
            for (k$ = 0, to2$ = this.dim - 2; k$ <= to2$; ++k$) {
              k = k$;
              if (k >= i) {
                minor[j][k] = this[j + 1][k + 1].clone();
              } else {
                minor[j][k] = this[j + 1][k].clone();
              }
            }
          }
          if (i % 2 === 1) {
            f = minor.det().prod(-1).prod(this[0][i]);
          } else {
            f = minor.det().prod(this[0][i]);
          }
          res = res.add(f.top, f.bot);
        }
        return res;
      }
    };
    prototype.T = function(){
      var res, i$, to$, i, j$, to1$, j;
      res = new fmatrix(this.dim);
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        res[i] = new Array(this.dim);
        for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
          j = j$;
          res[i][j] = this[j][i].clone();
        }
      }
      return res;
    };
    prototype.inv = function(){
      var d, res, cof, i$, to$, i, j$, to1$, j, minor, k$, to2$, k, l$, to3$, l, kk, ll, f;
      d = this.det();
      if (d.top === 0) {
        throw new Error("Singular matrix sent to matrix.inv()");
      } else if (this.dim === 2) {
        res = new fmatrix(2);
        res.set(new frac(this[1][1].top * d.bot, this[1][1].bot * d.top), new frac(-this[0][1].top * d.bot, this[0][1].bot * d.top), new frac(-this[1][0].top * d.bot, this[1][0].bot * d.top), new frac(this[0][0].top * d.bot, this[0][0].bot * d.top));
        return res;
      } else {
        cof = new fmatrix(this.dim);
        for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
          i = i$;
          cof[i] = new Array(this.dim);
          for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
            j = j$;
            minor = new fmatrix(this.dim - 1);
            for (k$ = 0, to2$ = this.dim - 2; k$ <= to2$; ++k$) {
              k = k$;
              minor[k] = new Array(this.dim);
              for (l$ = 0, to3$ = this.dim - 2; l$ <= to3$; ++l$) {
                l = l$;
                if (k >= i) {
                  kk = k + 1;
                } else {
                  kk = k;
                }
                if (l >= j) {
                  ll = l + 1;
                } else {
                  ll = l;
                }
                minor[k][l] = this[kk][ll].clone();
              }
            }
            if ((i + j) % 2 === 1) {
              f = minor.det().prod(-1);
            } else {
              f = minor.det();
            }
            cof[i][j] = new frac(f.top * d.bot, f.bot * d.top);
          }
        }
        return cof.T();
      }
    };
    prototype.tr = function(){
      var res, i$, to$, i;
      res = toFrac(0, 1);
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        res = res.add(this[i][i].top, this[i][i].bot);
      }
      return res;
    };
    prototype.write = function(){
      var d, i$, to$, i, j$, to1$, j, res, f;
      d = 1;
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
          j = j$;
          this[i][j].reduce();
          d = lcm(d, this[i][j].bot);
        }
      }
      if (d === 1) {
        res = "\\begin{pmatrix}";
      } else {
        f = new frac(1, d);
        res = "\\displaystyle " + f.write() + "\\textstyle \\begin{pmatrix} ";
      }
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        for (j$ = 0, to1$ = this.dim - 1; j$ <= to1$; ++j$) {
          j = j$;
          res += this[i][j].top / this[i][j].bot * d;
          if (j === this.dim - 1) {
            if (i === this.dim - 1) {
              res += "\\end{pmatrix}";
            } else {
              res += "\\\\";
            }
          } else {
            res += "&";
          }
        }
      }
      return res;
    };
    return fmatrix;
  }());
  return fractions;
};
},{"./helpers":9,"./stats":14}],7:[function(require,module,exports){
module.exports = function(ceq){
  var helpers, gcd, signedNumber, circleEq1, circleEq2, lineEq1, lineEq2;
  helpers = require('./helpers')(ceq);
  gcd = helpers.gcd;
  signedNumber = helpers.signedNumber;
  ceq.circleEq1 = circleEq1 = function(a, b, r){
    var eqString;
    if (a == 0) {
      eqString = "x^2";
    } else {
      eqString = "(x" + signedNumber(-a) + ")^2";
    }
    if (b == 0) {
      eqString += "+y^2=";
    } else {
      eqString += "+(y" + signedNumber(-b) + ")^2=";
    }
    return eqString += Math.pow(r, 2);
  };
  ceq.circleEq2 = circleEq2 = function(a, b, r){
    var C, eqString;
    C = Math.pow(r, 2) - Math.pow(a, 2) - Math.pow(b, 2);
    if (a == 0) {
      eqString = "x^2";
    } else {
      eqString = "x^2" + signedNumber(-2 * a) + "x";
    }
    if (b == 0) {
      eqString += "+y^2";
    } else {
      eqString += "+y^2" + signedNumber(-2 * b) + "y";
    }
    if (C < 0) {
      return eqString += signedNumber(-C) + "=0";
    } else {
      return eqString += "=" + C;
    }
  };
  ceq.lineEq1 = lineEq1 = function(a, b, c, d){
    var xcoeff, ycoeff, concoeff, h, eqString;
    xcoeff = b - d;
    ycoeff = c - a;
    concoeff = -b * (c - a) + (d - b) * a;
    h = gcd(xcoeff, ycoeff, concoeff);
    xcoeff /= h;
    ycoeff /= h;
    concoeff /= h;
    if (xcoeff < 0) {
      xcoeff *= -1;
      ycoeff *= -1;
      concoeff *= -1;
    }
    if (xcoeff == 0 && ycoeff < 0) {
      ycoeff *= -1;
      concoeff *= -1;
    }
    if (xcoeff == 1) {
      eqString = "x";
    } else if (xcoeff !== 0) {
      eqString = xcoeff + "x";
    }
    if (xcoeff == 0) {
      if (ycoeff == 1) {
        eqString = "y";
      } else if (ycoeff == -1) {
        eqString = "-y";
      } else {
        eqString = ycoeff + "y";
      }
    } else {
      if (ycoeff == 1) {
        eqString += "+y";
      } else if (ycoeff == -1) {
        eqString += "-y";
      } else if (ycoeff !== 0) {
        eqString += signedNumber(ycoeff) + "y";
      }
    }
    if (concoeff !== 0) {
      eqString += signedNumber(concoeff) + "=0";
    } else {
      eqString += "=0";
    }
    return eqString;
  };
  ceq.lineEq2 = lineEq2 = function(m, c){
    var eqString;
    eqString = "y=";
    if (m == -1) {
      eqString += "-x";
    } else if (m == 1) {
      eqString += "x";
    } else if (m !== 0) {
      eqString += m + "x";
    }
    if (c !== 0) {
      if (m == 0) {
        eqString += c;
      } else {
        eqString += signedNumber(c);
      }
    }
    return eqString;
  };
  return ceq;
};
},{"./helpers":9}],8:[function(require,module,exports){
module.exports = function(gx){
  var helpers, gcd, sqroot, guessExact, proxInt;
  helpers = require('./helpers')(gx);
  gcd = helpers.gcd;
  sqroot = helpers.sqroot;
  /*
  guessExact = (x) ->
    n = proxInt(x)
    if n[0] then return n[1]
    fac = 1
  
    for s from 1 to 6
      fac *= s
      d = fac * 12
      n = proxInt(x * d)
  
      if n[0]
        f = new frac(n[1], d)
        f.reduce()
        return f.write()
  
      t = 2^s
  
      for i from -t to t by 1
        for j from -t to t by 1
          for k from 1 to s
            p = (x - (i / j)) * k
            n = proxInt(p^2)
  
            f = new frac(i,j)
            f.reduce()
  
            if n[0] and n[1] > 1
              v = new sqroot(n[1]) # v.a*root(v.n)
              g = new frac(v.a, k)
              g.reduce()
  
              # LS doesn't have a proper ternary operator :(
              if g.top > 0 then sign = " + " else sign = " - "
              return f.write + sign + fbcoeff(g, "\\sqrt{" + v.n + "}")
  
            p = (x + (i / j)) * k
            n = proxInt(p^2)
  
            if n[0] and n[1] > 1
              v = new sqroot(n[1]) # v.a*root v.n
              g = new frac(v.a, k)
              g.reduce()
  
              if g.top > 0 then sign = " + " else sign " - "
              return "-" + f.write() + sign + fbcoeff(g, "\\sqrt{" + v.n + "}")
  
    return x
  */
  gx.guessExact = guessExact = function(x){
    var n, sgn1, sgn2, i$, s, j$, to$, i, top, bot, c, v, j, a, k, k$, to1$, l$, to2$;
    n = proxInt(x);
    if (n[0]) {
      return n[1];
    }
    sgn1 = function(x){
      if (x < 0) {
        return "-";
      } else {
        return "";
      }
    };
    sgn2 = function(x){
      if (x < 0) {
        return "-";
      } else {
        return "+";
      }
    };
    for (i$ = 1; i$ <= 17; ++i$) {
      s = i$;
      for (j$ = 2, to$ = 3 + 2 * s; j$ <= to$; ++j$) {
        i = j$;
        n = proxInt(x * i);
        if (n[0]) {
          top = n[1];
          bot = i;
          c = gcd(top, bot);
          top /= c;
          bot /= c;
          return sgn1(x) + "\\frac{" + Math.abs(top) + "}{" + bot + "}";
        }
      }
      n = proxInt(Math.pow(x, 2));
      if (n[0] && n[1] < s * 10) {
        v = new sqroot(n[1]);
        return sgn1(x) + v.write();
      }
      for (j$ = 2, to$ = 1 + s; j$ <= to$; ++j$) {
        i = j$;
        n = proxInt(Math.pow(x * i, 2));
        if (n[0] && n[1] < s * 10) {
          v = new sqroot(n[1]);
          return sgn1(x) + "\\frac{" + v.write() + "}{" + i + "}";
        }
      }
      for (j$ = 1, to$ = 3 * s; j$ <= to$; ++j$) {
        j = j$;
        a = x - j;
        n = proxInt(Math.pow(a, 2));
        if (n[0] && n[1] < s * 10) {
          v = new sqroot(n[1]);
          return "\\left(" + j + sgn2(a) + v.write() + "\\right)";
        }
        a = x + j;
        n = proxInt(Math.pow(a, 2));
        if (n[0] && n[1] < s * 10) {
          v = new sqroot(n[1]);
          return "\\left(-" + j + sgn2(a) + v.write() + "\\right)";
        }
      }
      for (j$ = 2, to$ = 2 + 2 * s; j$ <= to$; ++j$) {
        k = j$;
        for (k$ = 1, to1$ = 1 + 2 * s; k$ <= to1$; ++k$) {
          j = k$;
          a = x - j / k;
          n = proxInt(Math.pow(a, 2));
          if (n[0] && n[1] < s * 10) {
            v = new sqroot(n[1]);
            return "\\left(\\frac{" + j + "}{" + k + "}" + sgn2(a) + v.write() + "\\right)";
          }
          a = x + j / k;
          n = proxInt(Math.pow(a, 2));
          if (n[0] && n[1] < s * 10) {
            v = new sqroot(n[1]);
            return "\\left(-\\frac{" + j + "}{" + k + sgn2(a) + v.write() + "\\right)";
          }
        }
      }
      for (j$ = 2, to$ = s - 1; j$ <= to$; ++j$) {
        i = j$;
        for (k$ = 1, to1$ = 2 + 2 * s; k$ <= to1$; ++k$) {
          j = k$;
          a = (x - j) * i;
          n = proxInt(Math.pow(a, 2));
          if (n[0] && n[1] < s * 10) {
            v = new sqroot(n[1]);
            return "\\left(" + j + sgn2(x - j) + "\\frac{" + v.write() + "}{" + i + "}\\right)";
          }
          a = (x + j) * i;
          n = proxInt(Math.pow(a, 2));
          if (n[0] && n[1] < s * 10) {
            v = new sqroot(n[1]);
            return "\\left(-" + j + sgn2(x + j) + "\\frac{" + v.write() + "}{" + i + "}\\right)";
          }
        }
      }
      for (j$ = 2, to$ = s - 1; j$ <= to$; ++j$) {
        i = j$;
        for (k$ = 2, to1$ = 1 + 2 * s; k$ <= to1$; ++k$) {
          k = k$;
          for (l$ = 1, to2$ = 2 * s; l$ <= to2$; ++l$) {
            j = l$;
            a = x - j / k;
            n = proxInt(Math.pow(a * i, 2));
            if ((n[0] && n[1] < s * 10) && Math.sqrt(n[1]) !== Math.floor(Math.sqrt(n[1]))) {
              v = new sqroot(n[1]);
              return "\\left(\\frac{" + j + "}{" + k + "}" + sgn2(a) + "\\frac{" + v.write() + "}{" + i + "}\\right)";
            }
            a = x + j / k;
            n = proxInt(Math.pow(a * i, 2));
            if ((n[0] && n[1] < s * 10) && Math.sqrt(n[1]) !== Math.floor(Math.sqrt(n[1]))) {
              v = new sqroot(n[1]);
              return "\\left(-\\frac{" + j + "}{" + k + "}" + sgn2(a) + "\\frac{" + v.write() + "}{" + i + "}\\right)";
            }
          }
        }
      }
    }
    return x;
  };
  gx.proxInt = proxInt = function(x){
    var n;
    n = Math.round(x);
    if (Math.abs(n - x) < (Math.abs(x) + 0.5) * 1e-8) {
      return [true, n];
    } else {
      return [false];
    }
  };
  return gx;
};
},{"./helpers":9}],9:[function(require,module,exports){
module.exports = function(helpers){
  var fractions, frac, gcd, lcm, lincombination, sinpi, cospi, rand, randnz, rank, maxel, ranking, distrand, distrandnz, sqroot, vector, ord, ordt, pickrand, epsi, rPad, repeat, signedNumber, simplifySurd;
  helpers.helpersLoaded = true;
  if (!helpers.fractionsLoaded) {
    fractions = require('./fractions')(helpers);
  } else {
    fractions = helpers;
  }
  frac = fractions.frac;
  helpers.gcd = gcd = function(){
    var a, b, i;
    a = Math.abs(gcd.arguments[0]);
    b = Math.abs(gcd.arguments[gcd.arguments.length - 1]);
    i = gcd.arguments.length;
    while (i > 2) {
      b = gcd(b, gcd.arguments[i - 2]);
      i--;
    }
    if (a * b === 0) {
      return a + b;
    }
    while ((a = a % b) && (b = b % a)) {}
    return a + b;
  };
  helpers.lcm = lcm = function(){
    var a, b, i, d;
    a = Math.abs(lcm.arguments[0]);
    b = Math.abs(lcm.arguments[lcm.arguments.length - 1]);
    i = lcm.arguments.length;
    while (i > 2) {
      b = lcm(b, lcm.arguments[i - 2]);
      i--;
    }
    if (a * b === 0) {
      return 0;
    }
    d = gcd(a, b);
    return a * b / d;
  };
  helpers.lincombination = lincombination = function(a, b){
    var x, lastx, y, lasty, quoti, c1, c2, d1, d2, e1, e2;
    x = 0;
    lastx = 1;
    y = 1;
    lasty = 0;
    while (b !== 0) {
      quoti = Math.floor(a / b);
      c1 = a;
      c2 = b;
      a = c2;
      b = c1 % c2;
      d1 = x;
      d2 = lastx;
      x = d2 - quoti * d1;
      lastx = d1;
      e1 = y;
      e2 = lasty;
      y = e2 - quoti * e1;
      lasty = e1;
    }
    return [lastx, lasty];
  };
  helpers.sinpi = sinpi = function(a, b){
    var c, A, i$, i;
    c = gcd(a, b);
    a /= c;
    b /= c;
    if (a === 0) {
      return [0, 1, 0, 1, 0, 1];
    }
    if (a === 1 && b === 6) {
      return [1, 2, 0, 1, 0, 1];
    }
    if (a === 1 && b === 4) {
      return [0, 1, 1, 2, 0, 1];
    }
    if (a === 1 && b === 3) {
      return [0, 1, 0, 1, 1, 2];
    }
    if (a === 1 && b === 2) {
      return [1, 1, 0, 1, 0, 1];
    }
    if (a === 1 && b === 1) {
      return [0, 1, 0, 1, 0, 1];
    }
    if (a / b > 0.5 && a <= b) {
      return sinpi(b - a, b);
    }
    if (a / b > 1 && a / b <= 1.5) {
      A = new Array(6);
      A = sinpi(a - b, b);
      for (i$ = 0; i$ <= 5; i$ += 2) {
        i = i$;
        A[i] *= -1;
      }
      return A;
    }
    if (a / b > 1.5 && a / b < 2) {
      A = new Array(6);
      A = sinpi(2 * b - a, b);
      for (i$ = 0; i$ <= 5; i$ += 2) {
        i = i$;
        A[i] *= -1;
      }
      return A;
    }
    return sinpi(a - 2 * b, b);
  };
  helpers.cospi = cospi = function(a, b){
    return sinpi(2 * a + b, 2 * b);
  };
  helpers.rand = rand = function(min, max){
    if (typeof min === "undefined") {
      return Math.round(Math.random());
    }
    if (typeof max === "undefined") {
      min = -Math.abs(min);
      max = Math.abs(min);
    }
    return min + Math.floor((max - min + 1) * Math.random());
  };
  helpers.randnz = randnz = function(min, max){
    var a;
    if (typeof max === "undefined") {
      min = -Math.abs(min);
      max = Math.abs(min);
    }
    if (min === 0) {
      min++;
    }
    if (max === 0) {
      max--;
    }
    if (min > max) {
      return min;
    }
    if (min < 0 && max > 0) {
      a = rand(min, max - 1);
      if (a >= 0) {
        a++;
      }
    } else {
      a = rand(min, max);
    }
    return a;
  };
  helpers.rank = rank = function(r){
    var n, list, i$, to$, i, c;
    n = rank.arguments.length - 1;
    if (r === 0) {
      r = n;
    }
    list = new Array(n);
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      list[i] = rank.arguments[i + 1];
    }
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      if (list[i] > list[i + 1]) {
        c = list[i];
        list[i] = list[i + 1];
        list[i + 1] = c;
        i = -1;
      }
    }
    return list[r - 1];
  };
  helpers.maxel = maxel = function(a){
    var n, m, ma, i$, to$, i;
    n = a.length;
    m = a[0];
    ma = 0;
    for (i$ = 1, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      if (a[i] > m) {
        m = a[i];
        ma = i;
      }
    }
    return ma;
  };
  helpers.ranking = ranking = function(a){
    var n, left, right, i$, to$, i, ls, rs, result, lp, rp;
    n = a.length;
    if (n > 2) {
      left = new Array(Math.floor(n / 2));
      right = new Array(n - left.length);
      for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
        i = i$;
        if (i < left.length) {
          left[i] = a[i];
        } else {
          right[i - left.length] = a[i];
        }
      }
      ls = ranking(left);
      rs = ranking(right);
      result = new Array(n);
      lp = 0;
      rp = 0;
      for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
        i = i$;
        if (rp === right.length || (lp < left.length && left[ls[lp]] < right[rs[rp]])) {
          result[i] = ls[lp];
          lp++;
        } else {
          result[i] = rs[rp] + left.length;
          rp++;
        }
      }
      return result;
    } else if (n === 2) {
      if (a[1] < a[0]) {
        return [1, 0];
      } else {
        return [0, 1];
      }
    } else {
      return [0];
    }
  };
  helpers.distrand = distrand = function(n, min, max){
    var list, res, i$, to$, i, s;
    if (typeof max === "undefined") {
      if (typeof min === "undefined") {
        min = 1;
        max = n;
      } else {
        min = -Math.abs(min);
        max = Math.abs(min);
      }
    }
    list = new Array(max + 1 - min);
    res = new Array(n);
    for (i$ = 0, to$ = max - min; i$ <= to$; ++i$) {
      i = i$;
      list[i] = i + min;
    }
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      s = rand(i, max - min);
      res[i] = list[s];
      list[s] = list[i];
    }
    return res;
  };
  helpers.distrandnz = distrandnz = function(n, min, max){
    var a, list, res, i$, to$, i, s;
    if (typeof max === "undefined") {
      if (typeof min === "undefined") {
        min = 1;
        max = n;
      } else {
        min = -Math.abs(min);
        max = Math.abs(min);
      }
    }
    if (min === 0) {
      min++;
    }
    if (max === 0) {
      max--;
    }
    if (min > max) {
      return [min];
    } else {
      if (min < 0 && max > 0) {
        a = 0;
      } else {
        a = 1;
      }
      list = new Array(max + a - min);
      res = new Array(n);
      for (i$ = 0, to$ = max + a - min - 1; i$ <= to$; ++i$) {
        i = i$;
        list[i] = i + min;
        if (a === 0 && list[i] >= 0) {
          list[i]++;
        }
      }
      for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
        i = i$;
        s = rand(i, max + a - min - 1);
        res[i] = list[s];
        list[s] = list[i];
      }
      return res;
    }
  };
  helpers.sqroot = sqroot = (function(){
    sqroot.displayName = 'sqroot';
    var prototype = sqroot.prototype, constructor = sqroot;
    function sqroot(n){
      var N, A, i;
      if (n !== Math.floor(n)) {
        throw new Error("non-integer sent to square root");
      } else {
        N = n;
        A = 1;
        i = 2;
        while (Math.pow(i, 2) <= N) {
          if (N % Math.pow(i, 2) === 0) {
            N /= Math.pow(i, 2);
            A *= i;
          }
          i++;
        }
        this.n = N;
        this.a = A;
      }
      if (this.a % 1 !== 0) {
        throw new Error("a is not an integer");
      }
    }
    prototype.write = function(){
      if (this.a === 1 && this.n === 1) {
        return "1";
      } else if (this.a === 1) {
        return "\\sqrt{" + this.n + "}";
      } else if (this.n === 1) {
        return this.a;
      } else {
        return this.a + "\\sqrt{" + this.n + "}";
      }
    };
    return sqroot;
  }());
  helpers.vector = vector = (function(){
    vector.displayName = 'vector';
    var prototype = vector.prototype, constructor = vector;
    function vector(dim){
      this.dim = dim;
    }
    prototype.set = function(){
      var i$, to$, i, results$ = [];
      this.dim = this.set.arguments.length;
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i] = this.set.arguments[i]);
      }
      return results$;
    };
    prototype.setrand = function(maxentry){
      var i$, to$, i, results$ = [];
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        results$.push(this[i] = Math.round(-maxentry + 2 * maxentry * Math.random()));
      }
      return results$;
    };
    prototype.dot = function(U){
      var sum, i$, to$, i;
      sum = 0;
      for (i$ = 0, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        sum += this[i] * U[i];
      }
      if (sum % 1 !== 0) {
        throw new Error("dot product is not an integer");
      }
      return sum;
    };
    prototype.cross = function(U){
      var res, i$, i, j$, j, k$, k;
      if (this.dim === 3 && U.dim === 3) {
        res = new vector(3);
        res.set(0, 0, 0);
        for (i$ = 0; i$ <= 2; ++i$) {
          i = i$;
          for (j$ = 0; j$ <= 2; ++j$) {
            j = j$;
            for (k$ = 0; k$ <= 2; ++k$) {
              k = k$;
              res[i] += epsi(i, j, k) * this[j] * U[k];
            }
          }
        }
        return res;
      } else {
        throw new Error("cross product called on vectors other than 3D");
      }
    };
    prototype.mag = function(){
      if (this.dot(this) % 1 !== 0) {
        throw new Error("magnitude is not an integer");
      }
      return this.dot(this);
    };
    prototype.write = function(){
      var q, i$, to$, i;
      q = "\\begin{pmatrix}" + this[0];
      for (i$ = 1, to$ = this.dim - 1; i$ <= to$; ++i$) {
        i = i$;
        q += "\\\\" + this[i];
      }
      return q + "\\end{pmatrix}";
    };
    return vector;
  }());
  helpers.ord = ord = function(n){
    if (n < 0) {
      throw new Error("negative ordinal requested from ord()");
    }
    if (Math.floor(n / 10) === 1) {
      n + "th";
    }
    if (n % 10 === 1) {
      return n + "st";
    } else if (n % 10 === 2) {
      return n + "nd";
    } else if (n % 10 === 3) {
      return n + "rd";
    } else {
      return n + "th";
    }
  };
  helpers.ordt = ordt = function(n){
    if (n < 0) {
      throw new Error("negative ordinal requested from ord()");
    }
    if (n <= 12) {
      return ["zeroth", "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"][n];
    } else {
      return ord(n);
    }
  };
  helpers.pickrand = pickrand = function(){
    return pickrand.arguments[rand(0, pickrand.arguments.length - 1)];
  };
  helpers.epsi = epsi = function(i, j, k){
    return (i - j) * (j - k) * (k - i) / 2;
  };
  helpers.rPad = rPad = function(n, len, char){
    var s, i$, i;
    s = n.toString();
    for (i$ = s.length + 1; i$ <= len; ++i$) {
      i = i$;
      s += char;
    }
    return s;
  };
  helpers.repeat = repeat = curry$(function(num, s){
    return (function(){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = num; i$ < to$; ++i$) {
        results$.push(s);
      }
      return results$;
    }()).join("");
  });
  helpers.signedNumber = signedNumber = function(x){
    if (x > 0) {
      return "+" + x;
    } else {
      return x.toString();
    }
  };
  helpers.simplifySurd = simplifySurd = function(a, b, c, d){
    var sq, B, C, f, top, h, innerSurd;
    sq = new sqroot(c);
    B = sq.a * b;
    C = sq.n;
    if (d === 0) {
      return "Error; zero in the denominator";
    } else if (a === 0) {
      f = new frac(B, d);
      if (C === 1) {
        return f.write();
      } else {
        if (f.top === 1) {
          top = "";
        } else if (f.top === -1) {
          top = "-";
        } else {
          top = f.top;
        }
        if (f.bot === 1) {
          return top + "\\sqrt{" + C + "}";
        } else {}
        return "\\frac{" + top + "\\sqrt{" + C + "}}{" + f.bot + "}";
      }
    } else if (B === 0 || C === 0) {
      f = new frac(a, d);
      return f.write();
    } else if (C === 1) {
      f = new frac(a + B, d);
      return f.write();
    } else {
      h = gcd(a, B, d);
      a /= h;
      B /= h;
      d /= h;
      if (d < 0) {
        a *= -1;
        B *= -1;
        d *= -1;
      }
      innerSurd = function(x, y, z){
        if (y === 1) {
          return x + "+\\sqrt{" + z + "}";
        } else if (y === -1) {
          return x + "-\\sqrt{" + z + "}";
        } else {
          return x + signedNumber(y) + "\\sqrt{" + z + "}";
        }
      };
      if (d === 1) {
        return innerSurd(a, B, C);
      } else {
        return "\\frac{" + innerSurd(a, B, C) + "}{" + d + "}";
      }
    }
  };
  return helpers;
};
function curry$(f, bound){
  var context,
  _curry = function(args) {
    return f.length > 1 ? function(){
      var params = args ? args.concat() : [];
      context = bound ? context || this : this;
      return params.push.apply(params, arguments) <
          f.length && arguments.length ?
        _curry.call(context, params) : f.apply(context, params);
    } : f;
  };
  return _curry();
}
},{"./fractions":6}],10:[function(require,module,exports){
module.exports = function(polys){
  var stats, ranking, helpers, gcd, ascoeff, abscoeff, express, polyexpand, p_quadratic, p_linear, p_const, poly;
  stats = require('./stats')(polys);
  ranking = stats.ranking;
  helpers = require('./helpers')(polys);
  gcd = helpers.gcd;
  polys.ascoeff = ascoeff = function(a){
    if (a === 1) {
      return "";
    } else if (a === -1) {
      return "-";
    } else {
      return a;
    }
  };
  polys.abscoeff = abscoeff = function(a){
    a = Math.abs(a);
    if (a === 1) {
      return "";
    } else {
      return a;
    }
  };
  polys.express = express = function(a){
    var r, n, p, t, s, i$, to$, i, q;
    r = "";
    n = a.length;
    p = ranking(a);
    t = 0;
    s = new poly(1);
    s[1] = 1;
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      if (i && a[p[i]] === q) {
        t++;
      } else {
        if (t) {
          r += "^" + (t + 1);
        }
        t = 0;
        s[0] = a[p[i]];
        r += "(" + s.write() + ")";
        q = a[p[i]];
      }
    }
    if (t) {
      r += "^" + (t + 1);
    }
    return r;
  };
  polys.polyexpand = polyexpand = function(a, b){
    var p, i$, to$, i, j$, to1$, j;
    p = new poly(a.rank + b.rank);
    p.setrand(0);
    for (i$ = 0, to$ = a.rank; i$ <= to$; ++i$) {
      i = i$;
      for (j$ = 0, to1$ = b.rank; j$ <= to1$; ++j$) {
        j = j$;
        p[i + j] += a[i] * b[j];
      }
    }
    return p;
  };
  polys.p_quadratic = p_quadratic = function(a, b, c){
    var p;
    p = new poly(2);
    p.set(c, b, a);
    return p;
  };
  polys.p_linear = p_linear = function(a, b){
    var p;
    p = new poly(1);
    p.set(b, a);
    return p;
  };
  polys.p_const = p_const = function(a){
    var p;
    p = new poly(0);
    p.set(a);
    return p;
  };
  polys.poly = poly = (function(){
    poly.displayName = 'poly';
    var prototype = poly.prototype, constructor = poly;
    function poly(rank){
      this.rank = rank;
    }
    prototype.terms = function(){
      var n, i$, to$, i;
      n = 0;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        if (this[i]) {
          n++;
        }
      }
      return n;
    };
    prototype.set = function(){
      var i$, to$, i;
      this.rank = this.set.arguments.length - 1;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        this[i] = this.set.arguments[i];
      }
      return this;
    };
    prototype.setrand = function(maxentry){
      var i$, to$, i;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        this[i] = Math.round(-maxentry + 2 * maxentry * Math.random());
        if (this[this.rank] === 0) {
          this[this.rank] = maxentry;
        }
      }
      return this;
    };
    prototype.compute = function(x){
      var y, i$, to$, i;
      y = 0;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        y += this[i] * Math.pow(x, i);
      }
      return y;
    };
    prototype.gcd = function(){
      var a, i$, to$, i;
      a = this[this.rank];
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        a = gcd(a, this[i]);
      }
      return a;
    };
    prototype.xthru = function(x){
      var i$, to$, i;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        this[i] = this[i] * x;
      }
      return this;
    };
    prototype.addp = function(x){
      var i$, to$, i;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        this[i] = this[i] + x[i];
      }
      return this;
    };
    prototype.diff = function(d){
      var i$, to$, i, results$ = [];
      d.rank = this.rank - 1;
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        results$.push(d[i] = this[i + 1] * (i + 1));
      }
      return results$;
    };
    prototype.integ = function(d){
      var i$, to$, i, results$ = [];
      d.rank = rank + 1;
      for (i$ = 0, to$ = this.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        results$.push(d[i + 1] = this[i] / (i + 1));
      }
      return results$;
    };
    prototype.write = function(l){
      var q, j, i$, i;
      l == null && (l = "x");
      q = "";
      j = false;
      for (i$ = this.rank; i$ >= 0; --i$) {
        i = i$;
        if (this[i] < 0) {
          if (j) {
            q += " ";
          }
          q += "- ";
          j = false;
        } else if (j && this[i]) {
          q += " + ";
          j = false;
        }
        if (this[i]) {
          switch (i) {
          case 0:
            q += Math.abs(this[i]);
            j = true;
            break;
          case 1:
            if (Math.abs(this[i]) === 1) {
              q += l;
            } else {
              q += Math.abs(this[i]) + l;
            }
            j = true;
            break;
          default:
            if (Math.abs(this[i]) === 1) {
              q += l + "^" + i;
            } else {
              q += Math.abs(this[i]) + l + "^" + i;
            }
            j = true;
          }
        }
      }
      return q;
    };
    prototype.rwrite = function(l){
      var q, j, i$, to$, i;
      l == null && (l = "x");
      q = "";
      j = false;
      for (i$ = 0, to$ = this.rank; i$ <= to$; ++i$) {
        i = i$;
        if (this[i] < 0) {
          if (j) {
            q += " ";
          }
          q += "- ";
          j = false;
        } else if (j && this[i]) {
          q += " + ";
          j = false;
        }
        if (this[i]) {
          switch (i) {
          case 0:
            q += Math.abs(this[i]);
            j = true;
            break;
          case 1:
            if (Math.abs(this[i]) === 1) {
              q += l;
            } else {
              q += Math.abs(this[i]) + l;
            }
            j = true;
            break;
          default:
            if (Math.abs(this[i]) === 1) {
              q += l + "^" + i;
            } else {
              q += Math.abs(this[i]) + l + "^" + i;
            }
            j = true;
          }
        }
      }
      return q;
    };
    return poly;
  }());
  return polys;
};
},{"./helpers":9,"./stats":14}],11:[function(require,module,exports){
module.exports = function(problems){
  var polys, poly, polyexpand, abscoeff, ascoeff, p_linear, p_quadratic, fpolys, fpoly, fcoeff, fbcoeff, geometry, lineEq1, lineEq2, circleEq1, circleEq2, stats, rand, randnz, distrandnz, ranking, pickrand, distrand, massBin, massPo, massGeo, massN, tableN, tableT, tableChi, genN, genBin, genGeo, genPo, helpers, express, gcd, lcm, sinpi, vector, sqroot, ordt, simplifySurd, lincombination, signedNumber, fractions, frac, fmatrix, randfrac, cplex, Complex, gx, guessExact, makePartial, makeBinomial2, makePolyInt, makeTrigInt, makeVector, makeLines, makeLinesEq, makeLineParPerp, makeCircleEq, makeCircLineInter, makeIneq, makeAP, makeFactor, makeQuadratic, makeComplete, makeBinExp, makeLog, makeStationary, makeTriangle, makeCircle, makeSolvingTrig, makeVectorEq, makeModulus, makeTransformation, makeComposition, makeParametric, makeImplicit, makeChainRule, makeProductRule, makeQuotientRule, makeGP, makeImplicitFunction, makeIntegration, makeDE, makePowers, makeHCF, makeLCM, makeDiophantine, makeDistance, makeCircumCircle, makeCArithmetic, makeCPolar, makeDETwoHard, makeMatrixQ, makeMatrix2, makeMatrix3, makeTaylor, makePolarSketch, makeFurtherVector, makeNewtonRaphson, makeFurtherIneq, makeSubstInt, makeRevolution, makeMatXforms, makeDiscreteDistn, makeContinDistn, makeHypTest, makeConfidInt, makeChiSquare, makeProductMoment;
  polys = require('./polys')(problems);
  poly = polys.poly;
  polyexpand = polys.polyexpand;
  abscoeff = polys.abscoeff;
  ascoeff = polys.ascoeff;
  p_linear = polys.p_linear;
  p_quadratic = polys.p_quadratic;
  fpolys = require('./fpolys')(problems);
  fpoly = fpolys.fpoly;
  fcoeff = fpolys.fcoeff;
  fbcoeff = fpolys.fbcoeff;
  geometry = require('./geometry')(problems);
  lineEq1 = geometry.lineEq1;
  lineEq2 = geometry.lineEq2;
  circleEq1 = geometry.circleEq1;
  circleEq2 = geometry.circleEq2;
  stats = require('./stats')(problems);
  rand = stats.rand;
  randnz = stats.randnz;
  distrandnz = stats.distrandnz;
  ranking = stats.ranking;
  pickrand = stats.pickrand;
  distrand = stats.distrand;
  massBin = stats.massBin;
  massPo = stats.massPo;
  massPo = stats.massPo;
  massGeo = stats.massGeo;
  massN = stats.massN;
  tableN = stats.tableN;
  tableT = stats.tableT;
  tableChi = stats.tableChi;
  genN = stats.genN;
  genBin = stats.genBin;
  genGeo = stats.genGeo;
  genPo = stats.genPo;
  helpers = require('./helpers')(problems);
  express = helpers.express;
  gcd = helpers.gcd;
  lcm = helpers.lcm;
  sinpi = helpers.sinpi;
  vector = helpers.vector;
  sqroot = helpers.sqroot;
  ordt = helpers.ordt;
  simplifySurd = helpers.simplifySurd;
  lincombination = helpers.lincombination;
  signedNumber = helpers.signedNumber;
  fractions = require('./fractions')(problems);
  frac = fractions.frac;
  fmatrix = fractions.fmatrix;
  randfrac = fractions.randfrac;
  cplex = require('./complex')(problems);
  Complex = cplex.Complex;
  gx = require('./guessExact')(problems);
  guessExact = gx.guessExact;
  problems.makePartial = makePartial = function(){
    var makePartial1, makePartial2, qa;
    makePartial1 = function(){
      var a, b, e, c, d, f, aString, bot, qString, qa;
      a = randnz(8);
      b = new poly(1);
      b.setrand(8);
      if (b[1] < 0) {
        b.xthru(-1);
        a = -a;
      }
      e = gcd(a, b.gcd());
      if (e > 1) {
        b.xthru(1 / e);
        a /= e;
      }
      c = randnz(8);
      d = new poly(1);
      d.setrand(8);
      if (d[1] < 0) {
        d.xthru(-1);
        c = -c;
      }
      f = gcd(c, d.gcd());
      if (f > 1) {
        d.xthru(1 / f);
        c /= f;
      }
      if (b[1] === d[1] && b[0] === d[0]) {
        d[0] = -d[0];
      }
      if (a > 0) {
        aString = "$$";
      } else {
        aString = "$$-";
      }
      aString += "\\frac{" + Math.abs(a) + "}{" + b.write() + "}";
      if (c > 0) {
        aString += "+";
      } else {
        aString += "-";
      }
      aString += "\\frac{" + Math.abs(c) + "}{" + d.write() + "}$$";
      bot = polyexpand(b, d);
      b.xthru(c);
      d.xthru(a);
      b.addp(d);
      qString = "Express$$\\frac{" + b.write() + "}{" + bot.write() + "}$$in partial fractions.";
      qa = [qString, aString];
      return qa;
    };
    makePartial2 = function(){
      var m, l, d, e, f, n, a, b, c, u, v, w, p, q, r, qString, aString, qa;
      m = distrandnz(3, 3);
      l = ranking(m);
      d = randnz(4);
      e = randnz(3);
      f = randnz(3);
      n = [d, e, f];
      a = m[l[0]];
      b = m[l[1]];
      c = m[l[2]];
      d = n[l[0]];
      e = n[l[1]];
      f = n[l[2]];
      u = new poly(1);
      v = new poly(1);
      w = new poly(1);
      u[1] = v[1] = w[1] = 1;
      u[0] = a;
      v[0] = b;
      w[0] = c;
      p = polyexpand(u, v);
      q = polyexpand(u, w);
      r = polyexpand(v, w);
      p.xthru(f);
      q.xthru(e);
      r.xthru(d);
      p.addp(q);
      p.addp(r);
      qString = "Express$$\\frac{" + p.write() + "}{" + express([a, b, c]) + "}$$in partial fractions.";
      if (d > 0) {
        aString = "$$";
      } else {
        aString = "$$-";
      }
      aString += "\\frac{" + Math.abs(d) + "}{" + u.write() + "}";
      if (e > 0) {
        aString += "+";
      } else {
        aString += "-";
      }
      aString += "\\frac{" + Math.abs(e) + "}{" + v.write() + "}";
      if (f > 0) {
        aString += "+";
      } else {
        aString += "-";
      }
      aString += "\\frac{" + Math.abs(f) + "}{" + w.write() + "}$$";
      qa = [qString, aString];
      return qa;
    };
    if (rand()) {
      qa = makePartial1();
    } else {
      qa = makePartial2();
    }
    return qa;
  };
  problems.makeBinomial2 = makeBinomial2 = function(){
    var p, n, q, qString, aString, qa;
    p = new poly(1);
    p[0] = rand(1, 5);
    p[1] = randnz(6 - p[0]);
    n = Math.round(3 + Math.random() * (3 - Math.max(0, Math.max(p[0] - 3, p[1] - 3))));
    q = new poly(3);
    q[0] = Math.pow(p[0], n);
    q[1] = n * Math.pow(p[0], n - 1) * p[1];
    q[2] = n * (n - 1) * Math.pow(p[0], n - 2) / 2 * Math.pow(p[1], 2);
    q[3] = n * (n - 1) * (n - 2) * Math.pow(p[0], n - 3) / 6 * Math.pow(p[1], 3);
    qString = "Evaluate$$(" + p.rwrite() + ")^" + n + "$$to the fourth term.";
    aString = "$$" + q.rwrite() + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makePolyInt = makePolyInt = function(){
    var A, B, a, b, c, qString, hi, lo, ans, aString, qa;
    A = rand(-3, 2);
    B = rand(A + 1, 3);
    a = new poly(3);
    a.setrand(6);
    b = new fpoly(3);
    b.setpoly(a);
    c = new fpoly(4);
    b.integ(c);
    qString = "Evaluate$$\\int_{" + A + "}^{" + B + "}" + a.write() + "\\,\\mathrm{d}x$$";
    hi = c.compute(B);
    lo = c.compute(A);
    lo.prod(-1);
    ans = new frac(hi.top, hi.bot);
    ans.add(lo.top, lo.bot);
    aString = "$$" + ans.write() + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeTrigInt = makeTrigInt = function(){
    var a, b, A, term1, B, term2, U, qString, soln1, soln2, soln, i$, i, c, aString, qa;
    a = rand(0, 7);
    b = rand(1 - Math.min(a, 1), 8);
    if (a) {
      A = randnz(4);
      term1 = abscoeff(A) + "\\sin{" + ascoeff(a) + "x}";
    } else {
      A = 0;
      term1 = "";
    }
    if (b) {
      B = randnz(4);
      term2 = abscoeff(B) + "\\cos{" + ascoeff(b) + "x}";
    } else {
      B = 0;
      term2 = "";
    }
    U = pickrand(2, 3, 4, 6);
    qString = "Evaluate$$\\int_{0}^{\\pi / " + U + "}";
    if (a) {
      if (b) {
        qString += term1;
        if (B > 0) {
          qString += " + ";
        } else {
          qString += " - ";
        }
        qString += term2;
      } else {
        qString += term1;
      }
    } else {
      if (B < 0) {
        qString += " - ";
      }
      qString += term2;
    }
    qString += "\\,\\mathrm{d}x$$";
    soln1 = new Array(6);
    soln2 = new Array(6);
    soln = new Array(6);
    if (a) {
      soln1 = cospi(a, U);
      for (i$ = 0; i$ <= 4; i$ += 2) {
        i = i$;
        soln1[i] *= -A;
      }
      for (i$ = 1; i$ <= 5; i$ += 2) {
        i = i$;
        soln1[i] *= a;
      }
      if (soln1[0]) {
        soln1[0] = soln1[1] * A + a * soln1[0];
        soln1[1] *= a;
      } else {
        soln1[0] = A;
        soln1[1] = a;
      }
    } else {
      soln1 = [0, 1, 0, 1, 0, 1];
    }
    if (b) {
      soln2 = sinpi(b, U);
      for (i$ = 0; i$ <= 4; i$ += 2) {
        i = i$;
        soln2[i] *= B;
      }
      for (i$ = 1; i$ <= 5; i$ += 2) {
        i = i$;
        soln2[i] *= b;
      }
    } else {
      soln2 = [0, 1, 0, 1, 0, 1];
    }
    for (i$ = 0; i$ <= 4; i$ += 2) {
      i = i$;
      soln[i] = soln1[i] * soln2[i + 1] + soln1[i + 1] * soln2[i];
      soln[i + 1] = soln1[i + 1] * soln2[i + 1];
      if (soln[i + 1] < 0) {
        soln[i] *= -1;
        soln[i + 1] *= -1;
      }
      if (soln[i]) {
        c = gcd(Math.abs(soln[i]), soln[i + 1]);
        soln[i] /= c;
        soln[i + 1] /= c;
      }
    }
    aString = "$$";
    if (soln[0] && soln[1] === 1) {
      aString += soln[0];
    } else if (soln[0] > 0) {
      aString += "\\frac{" + soln[0] + "}{" + soln[1] + "}";
    } else if (soln[0] < 0) {
      aString += " - \\frac{" + (-soln[0]) + "}{" + soln[1] + "}";
    }
    if (soln[2] && soln[3] === 1) {
      if (aString.length > 2) {
        if (soln[2] > 0) {
          aString += " + ";
        }
      }
      aString += soln[2] + "\\sqrt{2}";
    } else if (soln[2] > 0) {
      if (aString.length > 2) {
        aString += " + ";
      }
      aString += "\\frac{" + soln[2] + "}{" + soln[3] + "}\\sqrt{2}";
    } else if (soln[2] < 0) {
      aString += "-\\frac{" + (-soln[2]) + "}{" + soln[3] + "}\\sqrt{2}";
    }
    if (soln[4] && soln[5] === 1) {
      if (aString.length > 2) {
        if (soln[4] > 0) {
          aString += "+";
        }
      }
      if (Math.abs(soln[4]) === 1) {
        if (soln[4] === -1) {
          aString += "-";
        }
      } else {
        aString += soln[4];
      }
      aString += "\\sqrt{3}";
    } else if (soln[4] > 0) {
      if (aString.length > 2) {
        aString += " + ";
      }
      aString += "\\frac{" + soln[4] + "}{" + soln[5] + "}\\sqrt{3}";
    } else if (soln[4] < 0) {
      aString += "-\\frac{" + (-soln[4]) + "}{" + soln[5] + "}\\sqrt{3}";
    }
    if (aString === "$$") {
      aString += "0$$";
    } else {
      aString += "$$";
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeVector = makeVector = function(){
    var ntol, A, i$, i, B, c, v, qString, aString, top1, bot1, top2, bot2, qa;
    ntol = function(n){
      return String.fromCharCode(n + "A".charCodeAt(0));
    };
    A = new Array(4);
    for (i$ = 0; i$ <= 3; ++i$) {
      i = i$;
      A[i] = new vector(3);
      A[i].setrand(10);
    }
    B = new Array(0, 1, 2, 3);
    i = 0;
    while (i < 3) {
      if (A[B[i]].mag() < A[B[i + 1]].mag()) {
        c = B[i];
        B[i] = B[i + 1];
        B[i + 1] = c;
        i = -1;
      }
      i++;
    }
    v = distrand(3, 0, 3);
    qString = "Consider the four vectors";
    qString += "$$\\mathbf{A} = " + A[0].write() + "\\,,\\ \\mathbf{B} = " + A[1].write() + "$$";
    qString += "$$\\mathbf{C} = " + A[2].write() + "\\,,\\ \\mathbf{D} = " + A[3].write() + "$$";
    qString += "<ol class=\"exercise\"><li>Order the vectors by magnitude.</li>";
    qString += "<li>Use the scalar product to find the angles between";
    qString += "<ol class=\"subexercise\"><li>\\(\\mathbf{" + ntol(v[0]) + "}\\) and \\(\\mathbf{" + ntol(v[1]) + "}\\),</li>";
    qString += "<li>\\(\\mathbf{" + ntol(v[1]) + "}\\) and \\(\\mathbf{" + ntol(v[2]) + "}\\)</li></ol></ol>";
    aString = "<ol class=\"exercise\"><li>";
    aString += "\\(|\\mathbf{" + ntol(B[0]) + "}| = \\sqrt{" + A[B[0]].mag();
    aString += "},\\) \\(|\\mathbf{" + ntol(B[1]) + "}| = \\sqrt{" + A[B[1]].mag();
    aString += "},\\) \\( |\\mathbf{" + ntol(B[2]) + "}| = \\sqrt{" + A[B[2]].mag();
    aString += "}\\) and \\(|\\mathbf{" + ntol(B[3]) + "}| = \\sqrt{" + A[B[3]].mag();
    aString += "}\\).</li>";
    top1 = A[v[0]].dot(A[v[1]]);
    bot1 = new sqroot(A[v[0]].mag() * A[v[1]].mag());
    c = gcd(Math.abs(top1), bot1.a);
    top1 /= c;
    bot1.a /= c;
    top2 = A[v[1]].dot(A[v[2]]);
    bot2 = new sqroot(A[v[1]].mag() * A[v[2]].mag());
    c = gcd(Math.abs(top2), bot2.a);
    top2 /= c;
    bot2.a /= c;
    aString += "<li><ol class=\"subexercise\"><li>\\(";
    if (top1 === 0) {
      aString += "\\pi / 2";
    } else if (top1 === 1 && bot1.n === 1 && bot1.a === 1) {
      aString += "0";
    } else if (top1 === -1 && bot1.n === 1 && bot1.a === 1) {
      aString += "\\pi";
    } else {
      aString += "\\arccos\\left(";
      if (bot1.a === 1 && bot1.n === 1) {
        aString += top1;
      } else {
        aString += "\\frac{" + top1 + "}{" + bot1.write() + "}";
      }
      aString += "\\right)";
    }
    aString += "\\)</li><li>\\(";
    if (top2 === 0) {
      aString += "\\pi / 2";
    } else if (top2 === 1 && bot2.n === 1 && bot2.a === 1) {
      aString += "0";
    } else if (top2 === -1 && bot2.n === 1 && bot2.a === 1) {
      aString += "\\pi";
    } else {
      aString += "\\arccos\\left(";
      if (bot2.a === 1 && bot2.n === 1) {
        aString += top2;
      } else {
        aString += "\\frac{" + top2 + "}{" + bot2.write() + "}";
      }
      aString += "\\right)";
    }
    aString += "\\)</li></ol></li></ol>";
    qa = [qString, aString];
    return qa;
  };
  problems.makeLines = makeLines = function(){
    var a1, b1, c1, d1, e1, f1, ch, a2, b2, c2, d2, e2, f2, m1, m2, sn, p1, q1, r1, p2, q2, r2, eqn1, eqn2, qString, aString, cosbot, costh, mu, lam1, lam2, xm, ym, zm, qa;
    a1 = randnz(3);
    b1 = randnz(3);
    c1 = randnz(3);
    d1 = rand(3);
    e1 = rand(3);
    f1 = rand(3);
    ch = rand(1, 10);
    if (ch < 6) {
      a2 = randnz(3);
      b2 = randnz(3);
      c2 = randnz(3);
      d2 = rand(3);
      e2 = rand(3);
      f2 = rand(3);
    } else if (ch < 10) {
      a2 = randnz(2);
      b2 = randnz(2);
      c2 = randnz(2);
      if ((a1 * b1 * c1) % 6 === 0) {
        if (rand()) {
          if (a1 % 3 === 0) {
            a1 /= 3;
          }
          if (b1 % 3 === 0) {
            b1 /= 3;
          }
          if (c1 % 3 === 0) {
            c1 /= 3;
          }
        } else {
          if (a1 % 2 === 0) {
            a1 /= 2;
          }
          if (b1 % 2 === 0) {
            b1 /= 2;
          }
          if (c1 % 2 === 0) {
            c1 /= 2;
          }
        }
      }
      if ((a2 * d1) % a1 !== 0) {
        a2 *= a1;
        b2 *= a1;
        c2 *= a1;
      }
      if ((b2 * e1) % b1 !== 0) {
        a2 *= b1;
        b2 *= b1;
        c2 *= b1;
      }
      if ((c2 * f1) % c1 !== 0) {
        a2 *= c1;
        b2 *= c1;
        c2 *= c1;
      }
      d2 = a2 * d1 / a1;
      e2 = b2 * e1 / b1;
      f2 = c2 * f1 / c1;
      m1 = Math.abs(Math.min(d2, Math.min(e2, f2)));
      m2 = Math.max(d2, Math.max(e2, f2));
      if (m1 > 4) {
        d2 += 4;
        e2 += 4;
        f2 += 4;
      }
      if (m2 > 4) {
        d2 -= 2;
        e2 -= 2;
        f2 -= 2;
      }
      m1 = gcd(a2, b2, c2, d2, e2, f2);
      if (m1 > 1) {
        a2 /= m1;
        b2 /= m1;
        c2 /= m1;
        d2 /= m1;
        e2 /= m1;
        f2 /= m1;
      }
    } else {
      sn = randnz(2);
      a2 = a1 * sn;
      b2 = b1 * sn;
      c2 = c1 * sn;
      d2 = rand(3);
      e2 = rand(3);
      f2 = rand(3);
    }
    p1 = new poly(1);
    p1[0] = d1;
    p1[1] = a1;
    q1 = new poly(1);
    q1[0] = e1;
    q1[1] = b1;
    r1 = new poly(1);
    r1[0] = f1;
    r1[1] = c1;
    p2 = new poly(1);
    p2[0] = d2;
    p2[1] = a2;
    q2 = new poly(1);
    q2[0] = e2;
    q2[1] = b2;
    r2 = new poly(1);
    r2[0] = f2;
    r2[1] = c2;
    eqn1 = p1.write("x") + " = " + q1.write("y") + " = " + r1.write("z");
    eqn2 = p2.write("x") + " = " + q2.write("y") + " = " + r2.write("z");
    qString = "Consider the lines$$" + eqn1 + "$$and$$" + eqn2 + "$$Find the angle between them<br>and determine whether they<br>intersect.";
    aString = "";
    if (a1 * b2 === b1 * a2 && b1 * c2 === c1 * b2) {
      if (a2 * b2 * d1 - b2 * a1 * d2 === a2 * b2 * e1 - a2 * b1 * e2 && b2 * c2 * e1 - c2 * b1 * e2 === b2 * c2 * f1 - b2 * c1 * f2) {
        aString += "\\mbox{The lines are identical.}";
      } else {
        aString += "The lines are parallel and do not meet.";
      }
    } else {
      cosbot = new sqroot((Math.pow(b1, 2) * Math.pow(c1, 2) + Math.pow(c1, 2) * Math.pow(a1, 2) + Math.pow(a1, 2) * Math.pow(b1, 2)) * (Math.pow(b2, 2) * Math.pow(c2, 2) + Math.pow(c2, 2) * Math.pow(a2, 2) + Math.pow(a2, 2) * Math.pow(b2, 2)));
      costh = new frac(b1 * b2 * c1 * c2 + c1 * c2 * a1 * a2 + a1 * a2 * b1 * b2, cosbot.a);
      cosbot.a = costh.bot;
      aString += "The angle between the lines is$$";
      if (costh.top === 0) {
        aString += "\\pi / 2.$$";
      } else {
        aString += "\\arccos\\left(";
        if (cosbot.n === 1) {
          aString += costh.write();
        } else {
          aString += "\\frac{" + costh.top + "}{" + cosbot.write() + "}";
        }
        aString += "\\right).$$";
      }
      mu = new frac();
      lam1 = new frac();
      lam2 = new frac();
      if (a1 * b2 - a2 * b1) {
        mu.set(a2 * b2 * (e1 - d1) - a2 * b1 * e2 + a1 * b2 * d2, a1 * b2 - a2 * b1);
        lam1.set(b1 * mu.top - b1 * e2 * mu.bot + e1 * b2 * mu.bot, mu.bot * b2);
        lam2.set(c1 * mu.top - c1 * f2 * mu.bot + f1 * c2 * mu.bot, mu.bot * c2);
      } else {
        mu.set(b2 * c2 * (f1 - e1) - b2 * c1 * f2 + b1 * c2 * e2, b1 * c2 - b2 * c1);
        lam1.set(c1 * mu.top - c1 * f2 * mu.bot + f1 * c2 * mu.bot, mu.bot * c2);
        lam2.set(a1 * mu.top - a1 * d2 * mu.bot + d1 * a2 * mu.bot, mu.bot * a2);
      }
      if (lam1.equals(lam2)) {
        xm = new frac(lam1.top - d1 * lam1.bot, a1 * lam1.bot);
        ym = new frac(lam1.top - e1 * lam1.bot, b1 * lam1.bot);
        zm = new frac(lam1.top - f1 * lam1.bot, c1 * lam1.bot);
        aString += "The lines meet at the point$$\\left(" + xm.write() + "," + ym.write() + "," + zm.write() + "\\right).$$";
      } else {
        aString += "The lines do not meet.";
      }
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeLinesEq = makeLinesEq = function(){
    var makeLines1, qa;
    makeLines1 = function(){
      var a, b, c, d, qString, aString, grad, intercept, qa;
      a = rand(6);
      b = rand(6);
      c = rand(6);
      d = rand(6);
      while (a === c && b === d) {
        c = rand(6);
        d = rand(6);
      }
      qString = "Find the equation of the line passing through \\((" + a + "," + b + ")\\) and \\((" + c + "," + d + ")\\).";
      if (b === d) {
        aString = "$$y = " + b + ".$$";
      }
      if (a === c) {
        aString = "$$x = " + a + ".$$";
      } else {
        if (d - b === c - a) {
          grad = "";
        } else if (d - b === a - c) {
          grad = " - ";
        } else {
          grad = new frac(d - b, c - a);
          grad = grad.write();
        }
      }
      intercept = new frac(Math.abs(b * (c - a) - (d - b) * a), Math.abs(c - a));
      intercept = intercept.write();
      if (b - (d - b) / (c - a) * a < 0) {
        intercept = " - " + intercept;
      } else if (b * (c - a) === (d - b) * a) {
        intercept = "";
      } else {
        intercept = " + " + intercept;
      }
      aString = "$$y = " + grad + "x" + intercept + "\\qquad \\text{or} \\qquad " + lineEq1(a, b, c, d) + ".$$";
      qa = [qString, aString];
      return qa;
    };
    qa = makeLines1();
    return qa;
  };
  problems.makeLineParPerp = makeLineParPerp = function(){
    var a, b, c, m, makeLinePar, makeLinePerp, qa;
    a = rand(6);
    b = rand(6);
    c = rand(6);
    m = rand(6);
    makeLinePar = function(a, b, m, c){
      var qString, aString, intercept, qa;
      qString = "Find the equation of the line passing through \\((" + a + "," + b + ")\\) and parallel to the line ";
      if (Math.abs(m) === 6) {
        while (a === c) {
          c = rand(5);
        }
        qString += "\\(x = " + c + "\\).";
        aString = "$$x = " + a + ".$$";
      } else {
        if (rand()) {
          qString += "\\(" + lineEq1(0, c, 1, m + c) + ".\\)";
        } else {
          qString += "\\(" + lineEq2(m, c) + ".\\)";
        }
      }
      intercept = b - m * a;
      if (m === 0) {
        aString = "$$y = " + b + ".$$";
      } else {
        aString = "$$" + lineEq2(m, intercept) + "\\qquad\\text{or}\\qquad " + lineEq1(0, intercept, 1, m + intercept) + "$$";
      }
      qa = [qString, aString];
      return qa;
    };
    makeLinePerp = function(a, b, m, c){
      var qString, aString, grad, intercept, C, qa;
      qString = "Find the equation of the line passing through \\((" + a + "," + b + ")\\) and perpendicular to the line ";
      if (Math.abs(m) === 6) {
        while (a === c) {
          c = rand(5);
        }
        qString += "\\(x = " + c + "\\).";
        aString = "$$y = " + b + ".$$";
      } else if (m === 0) {
        while (a === 0) {
          c = rand(5);
        }
        qString += "\\(y = " + c + "\\).";
        aString = "$$x = " + a + ".$$";
      } else {
        if (rand()) {
          qString += "\\(" + lineEq1(0, c, 1, m + c) + ".\\)";
        } else {
          qString += "\\(" + lineEq2(m, c) + ".\\)";
        }
        aString = "$$y = ";
        grad = new frac(-1, m);
        intercept = new frac(b * m + a, m);
        C = (b * m + a) / m;
        if (m === -1) {
          aString += "x";
        } else if (m === 1) {
          aString += " - x";
        } else {
          aString += grad.write() + "x";
        }
        if (C % 1 === 0 && C !== 0) {
          aString += signedNumber(C);
        } else {
          if (C > 0) {
            aString += " + " + intercept.write();
          } else if (C < 0) {
            aString += intercept.write();
          }
        }
        aString += "\\qquad\\text{or}\\qquad ";
        if (m === 1) {
          aString += "x + y";
        } else if (m === -1) {
          aString += "x - y";
        } else {
          aString += "x" + signedNumber(m) + "y";
        }
        if (-b * m - a !== 0) {
          aString += signedNumber(-b * m - a);
        }
        aString += " = 0.$$";
      }
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeLinePar, makeLinePerp)(a, b, m, c);
    return qa;
  };
  problems.makeCircleEq = makeCircleEq = function(){
    var r, a, b, makeCircleEq1, makeCircleEq2, qa;
    r = rand(2, 7);
    a = rand(6);
    b = rand(6);
    makeCircleEq1 = function(a, b, r){
      var qString, aString, qa;
      qString = "Find the equation of the circle with centre \\((" + a + "," + b + ")\\) and radius \\(" + r + "\\).";
      if (a === 0 && b === 0) {
        aString = "$$" + circleEq1(a, b, r) + ".$$";
      } else {
        aString = "$$" + circleEq1(a, b, r) + "\\qquad\\text{or}\\qquad " + circleEq2(a, b, r) + ".$$";
      }
      qa = [qString, aString];
      return qa;
    };
    makeCircleEq2 = function(a, b, r){
      var qString, aString, qa;
      qString = "Find the centre and radius of the circle with equation";
      if (rand()) {
        qString += "$$" + circleEq1(a, b, r) + ".$$";
      } else {
        qString += "$$" + circleEq2(a, b, r) + ".$$";
      }
      aString = "The circle has centre \\((" + a + "," + b + ")\\) and radius \\(" + r + " \\).";
      qa = [qString, aString];
      return qa;
    };
    if (rand()) {
      qa = makeCircleEq1(a, b, r);
    } else {
      qa = makeCircleEq2(a, b, r);
    }
    return qa;
  };
  problems.makeCircLineInter = makeCircLineInter = function(){
    var makeLLInter, makeCLInter, makeCCInter, qa;
    makeLLInter = function(){
      var m1, m2, c1, c2, qString, aString, xint, yint, qa;
      m1 = rand(6);
      m2 = rand(6);
      c1 = rand(6);
      c2 = rand(6);
      if (rand()) {
        m1 = m2;
      }
      while (m1 === m2 && c1 === c2) {
        m2 = rand(6);
        c2 = rand(6);
      }
      qString = "Find all the points where the line \\(";
      if (rand()) {
        qString += lineEq1(0, c1, 1, m1 + c1);
      } else {
        qString += lineEq2(m1, c1);
      }
      qString += "\\) and the line \\(";
      if (rand()) {
        qString += lineEq1(0, c2, 1, m2 + c2);
      } else {
        qString += lineEq2(m2, c2);
      }
      qString += "\\) intersect.";
      if (m1 === m2) {
        aString = "The lines do not intersect.";
      } else {
        xint = new frac(c2 - c1, m1 - m2);
        yint = new frac(m1 * (c2 - c1) + c1 * (m1 - m2), m1 - m2);
        aString = "The lines intersect in a single point, which occurs at \\(\\left(" + xint.write() + "," + yint.write() + "\\right)\\).";
      }
      qa = [qString, aString];
      return qa;
    };
    makeCLInter = function(){
      var a, b, r, m, c, qString, A, B, C, disc, sq, aString, xint, yint, qa;
      a = rand(6);
      b = rand(6);
      r = rand(2, 7);
      m = rand(6);
      c = rand(6);
      qString = "Find all the points where the line \\(";
      if (rand()) {
        qString += lineEq1(0, c, 1, m + c);
      } else {
        qString += lineEq2(m, c);
      }
      qString += "\\) and the circle \\( ";
      if (rand()) {
        qString += circleEq1(a, b, r);
      } else {
        qString += circleEq2(a, b, r);
      }
      qString += "\\) intersect.";
      A = Math.pow(m, 2) + 1;
      B = -2 * a + 2 * m * (c - b);
      C = Math.pow(c - b, 2) - Math.pow(r, 2) + Math.pow(a, 2);
      disc = Math.pow(B, 2) - 4 * A * C;
      sq = new sqroot(disc);
      if (disc > 0) {
        aString = "The line and the circle intersect in two points, specifically ";
        aString += "$$\\left(";
        aString += simplifySurd(-B, sq.a, sq.n, 2 * A);
        aString += "," + simplifySurd(-m * B + 2 * c * A, m * sq.a, sq.n, 2 * A);
        aString += "\\right)";
        aString += "\\qquad\\text{and}\\qquad ";
        aString += "\\left(";
        aString += simplifySurd(-B, -sq.a, sq.n, 2 * A);
        aString += "," + simplifySurd(-m * B + 2 * c * A, -m * sq.a, sq.n, 2 * A);
        aString += "\\right)$$";
      } else if (disc < 0) {
        aString = "The line and the circle do not intersect in any points.";
      } else if (disc === 0) {
        xint = new frac(-B, 2 * A);
        yint = new frac(-B * m + c * 2 * A, 2 * A);
        aString = "The line and the circle intersect in exactly one point, which occurs at \\(\\left(" + xint.write() + "," + yint.write() + "\\right)\\).";
      }
      qa = [qString, aString];
      return qa;
    };
    makeCCInter = function(){
      var a1, b1, r1, a2, b2, r2, qString, D, DD, R, RR, S, aString, d, x1, y1, qa;
      a1 = rand(6);
      b1 = rand(6);
      r1 = rand(2, 7);
      a2 = rand(6);
      b2 = rand(6);
      r2 = rand(2, 7);
      while (a1 === a2 && b1 === b2 && r1 === r2) {
        a2 = rand(6);
        b2 = rand(6);
        r2 = rand(2, 7);
      }
      qString = "Find all the points where the circle \\(";
      if (rand()) {
        qString += circleEq1(a1, b1, r1);
      } else {
        qString += circleEq2(a1, b1, r1);
      }
      qString += "\\) and the circle \\(";
      if (rand()) {
        qString += circleEq1(a2, b2, r2);
      } else {
        qString += circleEq2(a2, b2, r2);
      }
      qString += "\\) intersect.";
      D = Math.sqrt(Math.pow(b2 - b1, 2) + Math.pow(a2 - a1, 2));
      DD = Math.pow(b2 - b1, 2) + Math.pow(a2 - a1, 2);
      R = r1 + r2;
      RR = Math.pow(r1, 2) - Math.pow(r2, 2);
      S = Math.abs(r1 - r2);
      if (R > D && D > S) {
        aString = "The circles intersect in two points, which are";
        d = new sqroot(-Math.pow(DD, 2) + 2 * DD * Math.pow(r1, 2) - Math.pow(r1, 4) + 2 * DD * Math.pow(r2, 2) + 2 * Math.pow(r1, 2) * Math.pow(r2, 2) - Math.pow(r2, 4));
        aString += "$$\\left(";
        aString += simplifySurd((a1 + a2) * DD + (a2 - a1) * RR, (b1 - b2) * d.a, d.n, 2 * DD) + ",";
        aString += simplifySurd((b1 + b2) * DD + (b2 - b1) * RR, (a2 - a1) * d.a, d.n, 2 * DD);
        aString += "\\right)";
        aString += "\\qquad\\text{and}\\qquad ";
        aString += "\\left(";
        aString += simplifySurd((a1 + a2) * DD + (a2 - a1) * RR, (b2 - b1) * d.a, d.n, 2 * DD) + ",";
        aString += simplifySurd((b1 + b2) * DD + (b2 - b1) * RR, (a1 - a2) * d.a, d.n, 2 * DD);
        aString += "\\right)";
        aString += "$$";
      } else if (DD === Math.pow(R, 2)) {
        x1 = new frac(a1 * R + r1 * (a2 - a1), R);
        y1 = new frac(b1 * R + r1 * (b2 - b1), R);
        aString = "The circles intersect in a single point, which is \\((" + x1.write() + "," + y1.write() + ")\\).";
      } else if (D > R || D <= S) {
        aString = "The two circles do not intersect in any points.";
      } else {
        aString = "Uh oh, something went wrong. Please try another question.";
      }
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeCLInter, makeLLInter, makeCCInter)();
    return qa;
  };
  problems.makeIneq = makeIneq = function(){
    var makeIneq2, makeIneq3, qa;
    makeIneq2 = function(){
      var roots, B, C, qString, p, aString, qa;
      roots = distrandnz(2, 6);
      B = -roots[0] - roots[1];
      C = roots[0] * roots[1];
      qString = "By factorising a suitable polynomial, or otherwise, find the values of \\(x\\) which satisfy$$";
      p = new poly(2);
      switch (rand(1, 3)) {
      case 1:
        p[0] = 0;
        p[1] = B;
        p[2] = 1;
        qString += p.write() + " < " + (-C);
        break;
      case 2:
        p[0] = C;
        p[1] = 0;
        p[2] = 1;
        qString += p.write() + " < ";
        if (B) {
          qString += ascoeff(-B) + "x";
        } else {
          qString += "0";
        }
        break;
      case 3:
        p[0] = -C;
        p[1] = -B;
        p[2] = 0;
        qString += "x^2" + " < " + p.write();
      }
      qString += "$$";
      aString = "$$" + Math.min(roots[0], roots[1]) + " < x < " + Math.max(roots[0], roots[1]) + "$$";
      qa = [qString, aString];
      return qa;
    };
    makeIneq3 = function(){
      var a, b, c, qString, B, C, D, p, q, m, r, aString, qa;
      a = randnz(5);
      b = randnz(5);
      c = rand(2);
      qString = "By factorising a suitable polynomial, or otherwise, find the values of \\(y\\) which satisfy$$";
      B = -(a + b + c);
      C = a * b + b * c + c * a;
      D = -a * b * c;
      p = new poly(3);
      p.set(0, 0, 0, 1);
      q = new poly(2);
      q.set(0, 0, 0);
      switch (rand(1, 3)) {
      case 1:
        p[2] = B;
        q[1] = -C;
        q[0] = -D;
        break;
      case 2:
        p[1] = C;
        q[2] = -B;
        q[0] = -D;
        break;
      case 3:
        p[0] = D;
        q[2] = -B;
        q[1] = -C;
      }
      qString += p.write('y') + " < " + q.write('y') + "$$";
      m = [a, b, c];
      r = ranking(m);
      aString = "$$y < " + m[r[0]];
      if (m[r[1]] !== m[r[2]]) {
        aString += "$$and$$" + m[r[1]] + " < y < " + m[r[2]] + "$$";
      } else {
        aString += "$$";
      }
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeIneq2, makeIneq3)();
    return qa;
  };
  problems.makeAP = makeAP = function(){
    var m, n, k, a1, a2, qString, aString, qa;
    m = rand(2, 6);
    n = rand(m + 2, 11);
    k = rand(Math.max(n + 3, 10), 40);
    a1 = new frac();
    a2 = new frac();
    qString = "An arithmetic progression has " + ordt(m) + " term \\(\\alpha\\) and " + ordt(n) + " term \\(\\beta\\). Find the ";
    if (rand() === 0) {
      qString += "sum to \\(" + k + "\\) terms.";
      a1.set(k * (2 * n - 1 - k), 2 * (n - m));
      a2.set(k * (1 + k - 2 * m), 2 * (n - m));
    } else {
      qString += "value of the \\(" + ordt(k) + "\\) term.";
      a1.set(n - k, n - m);
      a2.set(k - m, n - m);
    }
    aString = "$$" + fcoeff(a1, "\\alpha") + (a2.top > 0 ? " + " : " - ") + fbcoeff(a2, "\\beta") + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeFactor = makeFactor = function(){
    var makeFactor1, makeFactor2, makeFactor3;
    makeFactor1 = function(){
      var a, b, c, u, v, w, x, qString, aString, qa;
      a = randnz(4);
      b = randnz(7);
      c = randnz(7);
      u = new poly(1);
      v = new poly(1);
      w = new poly(1);
      u[1] = v[1] = w[1] = 1;
      u[0] = a;
      v[0] = b;
      w[0] = c;
      x = polyexpand(polyexpand(u, v), w);
      qString = "Divide $$" + x.write() + "$$ by $$(" + u.write() + ")$$ and hence factorise it completely.";
      aString = "$$" + express([a, b, c]) + "$$";
      qa = [qString, aString];
      return qa;
    };
    makeFactor2 = function(){
      var a, b, c, u, v, w, x, qString, aString, qa;
      a = randnz(2);
      b = randnz(5);
      c = randnz(5);
      u = new poly(1);
      v = new poly(1);
      w = new poly(1);
      u[1] = v[1] = w[1] = 1;
      u[0] = a;
      v[0] = b;
      w[0] = c;
      x = polyexpand(polyexpand(u, v), w);
      qString = "Use the factor theorem to factorise $$" + x.write() + ".$$";
      aString = "$$" + express([a, b, c]) + "$$";
      qa = [qString, aString];
      return qa;
    };
    makeFactor3 = function(){
      var a, b, c, d, u, v, w, y, x, z, qString, aString, qa;
      a = randnz(2);
      b = randnz(4);
      c = randnz(4);
      d = randnz(4);
      if (d === c) {
        d = -d;
      }
      u = new poly(1);
      v = new poly(1);
      w = new poly(1);
      y = new poly(1);
      u[1] = v[1] = w[1] = y[1] = 1;
      u[0] = a;
      v[0] = b;
      w[0] = c;
      y[0] = d;
      x = polyexpand(polyexpand(u, v), w);
      z = polyexpand(polyexpand(u, v), y);
      qString = "Simplify$$\\frac{" + x.write() + "}{" + z.write() + "}.$$";
      aString = "$$\\frac{" + w.write() + "}{" + y.write() + "}$$";
      qa = [qString, aString];
      return qa;
    };
    return pickrand(makeFactor1, makeFactor2, makeFactor3)();
  };
  problems.makeQuadratic = makeQuadratic = function(){
    var qString, p, dcr, aString, r1, disc, r2, roots, qa;
    qString = "Find the real roots, if any, of$$";
    if (rand()) {
      p = new poly(2);
      p.setrand(5);
      p[2] = 1;
      qString += p.write();
      dcr = Math.pow(p[1], 2) - 4 * p[0];
      if (dcr < 0) {
        aString = "There are no real roots.";
      } else if (dcr === 0) {
        r1 = new frac(-p[1], 2);
        aString = "$$x = " + r1.write() + "$$is a repeated root.";
      } else {
        disc = new sqroot(dcr);
        r1 = new frac(-p[1], 2);
        if (disc.n === 1) {
          r1.add(disc.a, 2);
          aString = "$$x = " + r1.write() + "\\mbox{ and }x = ";
          r1.add(-disc.a);
          aString += r1.write() + "$$";
        } else {
          r2 = new frac(disc.a, 2);
          aString = "$$x = ";
          if (r1.top) {
            aString += r1.write();
          }
          aString += +"\\pm";
          if (r2.top !== 1 || r2.bot !== 1) {
            aString += r2.write();
          }
          aString += "\\sqrt{" + disc.n + "}$$";
        }
      }
    } else {
      roots = distrandnz(2, 5);
      p = new poly(2);
      p[2] = 1;
      p[1] = -roots[0] - roots[1];
      p[0] = roots[0] * roots[1];
      qString += p.write();
      aString = "$$x = " + roots[0] + "\\mbox{ and }x = " + roots[1] + "$$";
    }
    qString += " = 0$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeComplete = makeComplete = function(){
    var a, b, p, qString, aString, c, d, qa;
    a = randnz(4);
    b = randnz(5);
    p = new poly(2);
    p[2] = 1;
    p[1] = -2 * a;
    p[0] = Math.pow(a, 2) + b;
    if (rand()) {
      qString = "By completing the square, find (for real \\(x\\)) the minimum value of$$" + p.write() + ".$$";
      aString = "The minimum value is \\(" + b + ",\\) which occurs at \\(x = " + a + "\\).";
    } else {
      c = randnz(3);
      d = randnz(c + 2, c + 4);
      qString = "Find the minimum value of$$" + p.write() + "$$in the range$$" + c + "\\leq x\\leq" + d + ".$$";
      if (c <= a && a <= d) {
        aString = "The minimum value is \\(" + b + "\\) which occurs at \\(x = " + a + "\\)";
      } else if (a < c) {
        aString = "The minimum value is \\(" + (Math.pow(c, 2) - 2 * a * c + Math.pow(a, 2) + b) + "\\) which occurs at \\(x = " + c + "\\)";
      } else {
        aString = "The minimum value is \\(" + (Math.pow(d, 2) - 2 * a * d + Math.pow(a, 2) + b) + "\\) which occurs at \\(x = " + d + "\\)";
      }
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeBinExp = makeBinExp = function(){
    var a, b, n, m, pow, p, qString, q, aString, qa;
    a = rand(1, 3);
    b = randnz(2);
    n = rand(2, 5);
    m = rand(1, n - 1);
    pow = new frac(m, n);
    p = new fpoly(1);
    p[0] = new frac(1, 1);
    p[1] = new frac(b, a);
    qString = "Find the first four terms in the expansion of $$\\left(" + p.rwrite() + "\\right)^{" + pow.write() + "}$$";
    q = new fpoly(3);
    q[0] = new frac(1);
    q[1] = new frac(m * b, n * a);
    q[2] = new frac(m * (m - n) * Math.pow(b, 2), 2 * Math.pow(n, 2) * Math.pow(a, 2));
    q[3] = new frac(m * (m - n) * (m - 2 * n) * Math.pow(b, 3), 6 * Math.pow(n, 3) * Math.pow(a, 3));
    aString = "$$" + q.rwrite() + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeLog = makeLog = function(){
    var makeLog1, makeLog2, makeLog3, qa;
    makeLog1 = function(){
      var a, m, n, qString, r, aString, qa;
      a = pickrand(2, 3, 5);
      m = rand(1, 4);
      n = rand(1, 4);
      if (n >= m) {
        n++;
      }
      qString = "If \\(" + Math.pow(a, m) + " = " + Math.pow(a, n) + "^{x},\\) then find \\(x\\).";
      r = new frac(m, n);
      aString = "$$x = " + r.write() + "$$";
      qa = [qString, aString];
      return qa;
    };
    makeLog2 = function(){
      var a, b, c, qString, aString, qa;
      a = rand(2, 9);
      b = rand(2, 5);
      c = Math.pow(b, 2);
      qString = "Find \\(x\\) if \\(" + c + "\\log_{x}" + a + " = \\log_{" + a + "}x\\).";
      aString = "$$x = " + Math.pow(a, b) + "\\mbox{ or }x = \\frac{1}{" + Math.pow(a, b) + "}$$";
      qa = [qString, aString];
      return qa;
    };
    makeLog3 = function(){
      var a, b, qString, c, aString, qa;
      a = rand(2, 7);
      b = Math.floor(Math.pow(a, 7 * Math.random()));
      qString = "If \\(" + a + "^{x} = " + b + "\\), then find \\(x\\) to three decimal places.";
      c = new Number(Math.log(b) / Math.log(a));
      aString = "$$x = " + c.toFixed(3) + "$$";
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeLog1, makeLog2, makeLog3)();
    return qa;
  };
  problems.makeStationary = makeStationary = function(){
    var makeStationary2, makeStationary3, qa;
    makeStationary2 = function(){
      var p, d, qString, aString, qa;
      p = new poly(2);
      p.set(randnz(4), randnz(8), randnz(4));
      d = new frac(-p[1], 2 * p[2]);
      qString = "Find the stationary point of $$y = " + p.write() + ",$$ and state whether it is a maximum or a minimum.";
      aString = "The stationary point occurs at \\(x = " + d.write() + "\\), and it is a ";
      if (p[2] > 0) {
        aString += "minimum.";
      } else {
        aString += "maximum.";
      }
      qa = [qString, aString];
      return qa;
    };
    makeStationary3 = function(){
      var p, d, c, b, a, qString, aString, qa;
      p = new poly(3);
      d = randnz(4);
      c = randnz(3);
      b = randnz(3);
      a = randnz(5);
      if (Math.abs(c * (b + a)) % 2 === 1) {
        b++;
      }
      p.set(d, 3 * c * a * b, -3 * c * (a + b) / 2, c);
      qString = "Find the stationary points of $$y = " + p.write() + ",$$ and state their nature.";
      if (a === b) {
        aString = "The stationary point occurs at \\(x = " + a + ",\\) and is a point of inflexion.";
      } else if (c > 0) {
        aString = "The stationary points occur at \\(x = " + Math.min(a, b) + "\\), a maximum, and \\(x = " + Math.max(a, b) + "\\), a minimum";
      } else {
        aString = "The stationary points occur at \\(x = " + Math.min(a, b) + "\\), a minimum, and \\(x = " + Math.max(a, b) + "\\), a maximum";
      }
      qa = [qString, aString];
      return qa;
    };
    if (rand()) {
      qa = makeStationary2();
    } else {
      qa = makeStationary3();
    }
    return qa;
  };
  problems.makeTriangle = makeTriangle = function(){
    var makeTriangle1, makeTriangle2, makeTriangle3, qa;
    makeTriangle1 = function(){
      var a, b, m, s, hyp, shortv, other, angle, qString, length, aString, qa;
      a = rand(3, 8);
      b = rand(a + 1, 16);
      m = distrand(3, 0, 2);
      s = ["AB", "BC", "CA"];
      hyp = s[m[0]];
      shortv = s[m[1]];
      other = s[m[2]];
      switch (hyp) {
      case "AB":
        angle = "C";
        break;
      case "BC":
        angle = "A";
        break;
      case "CA":
        angle = "B";
      }
      qString = "In triangle \\(ABC\\), \\(" + shortv + " = " + a + "\\), \\(" + hyp + " = " + b + ",\\) and angle \\(" + angle + "\\) is a right angle. Find the length of \\(" + other + "\\).";
      length = new sqroot(Math.pow(b, 2) - Math.pow(a, 2));
      aString = "$$" + other + " = " + length.write() + "$$";
      qa = [qString, aString];
      return qa;
    };
    makeTriangle2 = function(){
      var a, b, c, qString, aa, bb, cc, aString, qa;
      a = rand(2, 8);
      b = rand(1, 6);
      c = rand(Math.max(a, b) - Math.min(a, b) + 1, a + b - 1);
      qString = "In triangle \\(ABC\\), \\(AB = " + c + "\\), \\(BC = " + a + ",\\) and \\(CA = " + b + ".\\) Find the angles of the triangle.";
      aa = new frac(Math.pow(b, 2) + Math.pow(c, 2) - Math.pow(a, 2), 2 * b * c);
      bb = new frac(Math.pow(c, 2) + Math.pow(a, 2) - Math.pow(b, 2), 2 * c * a);
      cc = new frac(Math.pow(a, 2) + Math.pow(b, 2) - Math.pow(c, 2), 2 * a * b);
      aString = "$$\\cos A = " + aa.write() + ",\\cos B = " + bb.write() + ",\\cos C = " + cc.write() + ".$$";
      qa = [qString, aString];
      return qa;
    };
    makeTriangle3 = function(){
      var a, cc, lb, c, qString, d, aString, qa;
      a = rand(1, 6);
      cc = pickrand(3, 4, 6);
      lb = a * Math.ceil(Math.sin(Math.PI / cc));
      c = rand(lb, Math.max(5, lb + 1));
      qString = "In triangle \\(ABC\\), \\(AB = " + c + "\\), \\(BC = " + a + "\\) and angle \\(C = \\frac{\\pi}{" + cc + "}\\). Find angle \\(A\\).";
      d = new frac(a, 2 * c);
      aString = "$$A = \\arcsin\\left(" + d.write();
      if (cc === 3) {
        aString += "\\sqrt{3}";
      } else if (cc === 4) {
        aString += "\\sqrt{2}";
      }
      aString += "\\right)$$";
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeTriangle1, makeTriangle2, makeTriangle3)();
    return qa;
  };
  problems.makeCircle = makeCircle = function(){
    var r, bot, top, prop, qString, length, area, aString, qa;
    r = rand(2, 8);
    bot = rand(2, 9);
    top = rand(1, 2 * bot - 1);
    prop = new frac(top, bot);
    qString = "Find, for a sector of angle \\(";
    if (prop.bot === 1) {
      qString += ascoeff(prop.top) + "\\pi";
    } else {
      qString += "\\frac{" + ascoeff(prop.top) + "\\pi}{" + prop.bot + "}";
    }
    qString += "\\) of a disc of radius \\(" + r + ":\\)<ul class=\"exercise\"><li> the length of the perimeter and</li><li>the area.</li></ul>";
    length = new frac(prop.top * r, prop.bot);
    area = new frac(prop.top * Math.pow(r, 2), 2 * prop.bot);
    aString = "<ul class=\"exercise\"><li>\\(" + r * 2 + " + " + length.write() + "\\pi\\)</li><li>\\(" + area.write() + "\\pi\\)</li></ul>";
    qa = [qString, aString];
    return qa;
  };
  problems.makeSolvingTrig = makeSolvingTrig = function(){
    var A, alpha, c, qString, aString, qa;
    A = pickrand(1, 3, 4, 5);
    alpha = pickrand(3, 4, 6);
    c = new frac(A, 2);
    qString = "Write $$" + c.write();
    if (alpha === 6) {
      qString += "\\sqrt{3}";
    } else if (alpha === 4) {
      qString += "\\sqrt{2}";
    }
    qString += "\\sin{\\theta} + " + c.write();
    if (alpha === 4) {
      qString += "\\sqrt{2}";
    } else if (alpha === 3) {
      qString += "\\sqrt{3}";
    }
    qString += "\\cos{\\theta}$$ in the form \\(A\\sin(\\theta + \\alpha),\\) where \\(A\\) and \\(\\alpha\\) are to be determined.";
    if (A === 1) {
      aString = "$$";
    } else {
      aString = "$$" + A;
    }
    aString += "\\sin\\left(\\theta + \\frac{\\pi}{" + alpha + "}\\right)$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeVectorEq = makeVectorEq = function(){
    var a, b, l, v, i$, i, qString, aString, qa;
    a = new vector(3);
    a.setrand(6);
    b = new vector(3);
    b.setrand(6);
    l = distrand(3, 5);
    v = new Array(3);
    for (i$ = 0; i$ <= 2; ++i$) {
      i = i$;
      v[i] = new vector(3);
      v[i].set(a[0] + l[i] * b[0], a[1] + l[i] * b[1], a[2] + l[i] * b[2]);
    }
    qString = "Show that the points with position vectors$$" + v[0].write() + "\\,," + v[1].write() + "\\,," + v[2].write() + "$$";
    qString += "lie on a straight line, and give the equation of the line in the form \\(\\mathbf{r} = \\mathbf{a} + \\lambda\\mathbf{b}\\).";
    aString = '$$' + a.write() + " + \\lambda\\," + b.write() + '$$';
    qa = [qString, aString];
    return qa;
  };
  problems.makeModulus = makeModulus = function(){
    var parms, fn, data, graph, a, aa, l, r, qString, drawIt, aString, params, s, xa, qa;
    parms = 0;
    fn = 0;
    data = [];
    graph = null;
    drawIt;
    if (rand()) {
      a = randnz(4);
      aa = Math.abs(a);
      l = rand(-aa - 6, -aa - 2);
      r = rand(aa + 2, aa + 6);
      qString = "Sketch the graph of \\(|" + a + " - |x||\\) for \\(" + l + "\\leq{x}\\leq" + r + "\\).";
      drawIt = function(parms){
        var d1, n, i$, to$, i;
        d1 = [];
        n = 0;
        for (i$ = parms[1], to$ = parms[2]; i$ <= to$; i$ += 0.5) {
          i = i$;
          n++;
          d1.push([i, Math.abs(parms[0] - Math.abs(i))]);
          if (n > 50) {
            i = parms[2];
          }
        }
        return [d1];
      };
      aString = '%GRAPH%';
      params = [a, l, r];
    } else {
      a = distrandnz(2, 4);
      s = [rand(), rand()];
      xa = Math.max(Math.abs(a[0]), Math.abs(a[1]));
      l = rand(-xa - 6, -xa - 2);
      r = rand(xa + 2, xa + 6);
      qString = "Sketch the graph of \\((" + a[0];
      if (s[0]) {
        qString += " + ";
      } else {
        qString += " - ";
      }
      qString += "|x|)(" + a[1];
      if (s[1]) {
        qString += " + ";
      } else {
        qString += " - ";
      }
      qString += "|x|)\\) for \\(" + l + "\\leq{x}\\leq" + r + "\\).";
      drawIt = function(parms){
        var a, s, l, r, d1, n, i$, i, s0, s1;
        a = parms[0];
        s = parms[1];
        l = parms[2];
        r = parms[3];
        d1 = [];
        n = 0;
        for (i$ = l; i$ <= r; i$ += 0.25) {
          i = i$;
          n++;
          if (s[0]) {
            s0 = 1;
          } else {
            s0 = -1;
          }
          if (s[1]) {
            s1 = 1;
          } else {
            s1 = -1;
          }
          d1.push([i, (a[0] + s0 * Math.abs(i)) * (a[1] + s1 * Math.abs(i))]);
          if (n > 100) {
            i = r;
          }
        }
        return [d1];
      };
      aString = '%GRAPH%';
      params = [a, s, l, r];
    }
    qa = [qString, aString, drawIt, params];
    return qa;
  };
  problems.makeTransformation = makeTransformation = function(){
    var fnn, which, fnf, parms, fn, data, p, q, l, r, qString, drawIt, aString, qa;
    fnn = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", "{z}^{2}");
    which = rand(0, 6);
    fnf = [
      Math.log, function(x){
        return 1 / Math.sin(x);
      }, function(x){
        return 1 / Math.cos(x);
      }, Math.sin, function(x){
        return Math.tan(x);
      }, Math.cos, function(x){
        return Math.pow(x, 2);
      }
    ][which];
    parms = 0;
    fn = 0;
    data = "";
    p = new poly(1);
    p.setrand(2);
    q = new poly(1);
    q.setrand(3);
    q[1] = Math.abs(q[1]);
    if (rand()) {
      p[1] = 1;
    } else if (rand()) {
      q[1] = 1;
    } else if (rand()) {
      p[0] = 0;
    } else {
      q[0] = 0;
    }
    if (which) {
      l = rand(-5, 2);
    } else {
      l = Math.max(Math.ceil((1 - q[0]) / q[1]), 0);
    }
    r = l + rand(4, 8);
    qString = "Let \\(f(x) = " + fnn[which].replace(/z/g, 'x') + "\\). Sketch the graphs of \\(y = f(x)\\) and \\(y = " + p.write("f(" + q.write() + ")") + "\\) for \\(" + l;
    if (which === 0 && l === 0) {
      qString += " < ";
    } else {
      qString += "\\leq ";
    }
    qString += "x \\leq " + r + "\\).";
    drawIt = function(parms){
      var p, q, f, l, r, d1, d2, n, i$, i, y1, y2;
      p = parms[0];
      q = parms[1];
      f = parms[2];
      l = parms[3];
      r = parms[4];
      d1 = [];
      d2 = [];
      n = 0;
      for (i$ = l; i$ <= r; i$ += 0.01) {
        i = i$;
        n++;
        y1 = f(i);
        if (Math.abs(y1) > 20) {
          y1 = null;
        }
        d1.push([i, y1]);
        y2 = p.compute(f(q.compute(i)));
        if (Math.abs(y2) > 20) {
          y2 = null;
        }
        d2.push([i, y2]);
        if (n > 2500) {
          i = r;
        }
      }
      return [d1, d2];
    };
    aString = '%GRAPH%';
    qa = [qString, aString, drawIt, [p, q, fnf, l, r]];
    return qa;
  };
  problems.makeComposition = makeComposition = function(){
    var p, fnf, fnn, which, parms, fn, data, l, r, qString, drawIt, aString, qa;
    p = new poly(rand(1, 2));
    p.setrand(2);
    if (p.rank === 1 && p[0] === 0 && p[1] === 1) {
      p[0] = randnz(2);
    }
    fnf = new Array(Math.sin, Math.tan, Math.cos, 0);
    fnn = new Array("\\sin(z)", "\\tan(z)", "\\cos(z)", p.write("z"));
    which = distrand(2, 0, 3);
    parms = 0;
    fn = 0;
    data = "";
    l = rand(-4, 0);
    r = rand(Math.max(l + 5, 2), 8);
    qString = "Let \\(f(x) = " + fnn[which[0]].replace(/z/g, 'x') + ", g(x) = " + fnn[which[1]].replace(/z/g, 'x') + ".\\) Sketch the graph of \\(y = f(g(x))\\) (where it exists) for \\(" + l + "\\leq{x}\\leq" + r + "\\) and \\(-12\\leq{y}\\leq12.\\)";
    drawIt = function(parms){
      var f, g, p, l, r, incinit, incmin, ylimit, calcpoints, calcpoint, calcgradient, calcangle, d1;
      f = parms[0];
      g = parms[1];
      p = parms[2];
      l = parms[3];
      r = parms[4];
      incinit = 0.01;
      incmin = incinit / 1024;
      ylimit = 12;
      calcpoints = function(l, r, inc){
        var points, angles, n, yprev, i$, i, y, ylimitsigned, yi, gradient, iylimit, ii, angle, subpoints;
        points = [];
        angles = [null];
        n = 0;
        yprev = calcpoint(l - inc);
        for (i$ = l; inc < 0 ? i$ >= r : i$ <= r; i$ += inc) {
          i = i$;
          y = calcpoint(i);
          if (Math.abs(y) > ylimit) {
            y = null;
          }
          if ((deepEq$(yprev, null, '===') && !deepEq$(y, null, '===')) || (!deepEq$(yprev, null, '===') && deepEq$(y, null, '==='))) {
            ylimitsigned = ylimit;
            if (deepEq$(yprev, null, '===')) {
              if (y < 0) {
                ylimitsigned = -ylimit;
              }
              yi = calcpoint(i + inc);
              gradient = calcgradient(y, yi, inc);
              iylimit = (y - ylimitsigned) / gradient;
            } else {
              if (yprev < 0) {
                ylimitsigned = -ylimit;
              }
              yi = calcpoint(i - 2 * inc);
              gradient = calcgradient(yi, yprev, inc);
              iylimit = (ylimitsigned - yprev) / gradient;
            }
            ii = i + iylimit;
            if (l <= ii && ii <= r) {
              n++;
              points.push([ii, ylimitsigned]);
            }
          }
          yprev = y;
          n++;
          points.push([i, y]);
          if (n > 2) {
            angle = calcangle(points[n - 3], points[n - 2], points[n - 1]);
            if (!deepEq$(angle, null, '===') && Math.abs(angle) < 1 && inc >= incmin) {
              subpoints = calcpoints(points[n - 3][0], points[n - 1][0], inc / 2);
              points.splice(-3, 3);
              points = points.concat(subpoints);
              n = n - 3 + subpoints.length;
            }
          }
          if (n > 10000) {
            i = r;
          }
        }
        return points;
      };
      calcpoint = function(x){
        var y2, y3;
        if (g) {
          y2 = g(x);
        } else {
          y2 = p.compute(x);
        }
        if (typeof y2 === 'number') {
          if (f) {
            y3 = f(y2);
          } else {
            y3 = p.compute(y2);
          }
        } else {
          y3 = null;
        }
        return y3;
      };
      calcgradient = function(y1, y2, dx){
        return (y2 - y1) / dx;
      };
      calcangle = function(p1, p2, p3){
        if (deepEq$(p1[1], null, '===') || deepEq$(p2[1], null, '===') || deepEq$(p3[1], null, '===')) {
          return null;
        }
        return Math.atan2(p1[1] - p2[1], p1[0] - p2[0]) - Math.atan2(p3[1] - p2[1], p3[0] - p2[0]);
      };
      d1 = calcpoints(l, r, incinit);
      return [d1];
    };
    aString = '%GRAPH%';
    qa = [qString, aString, drawIt, [fnf[which[0]], fnf[which[1]], p, l, r]];
    return qa;
  };
  problems.makeParametric = makeParametric = function(){
    var p, fnf, fnn, which, parms, fn, data, qString, drawIt, aString, qa;
    p = new poly(rand(1, 2));
    p.setrand(2);
    if (p.rank === 1 && p[0] === 0 && p[1] === 1) {
      p[0] = randnz(2);
    }
    fnf = new Array(Math.log, function(x){
      return 1 / Math.sin(x);
    }, function(x){
      return 1 / Math.cos(x);
    }, Math.sin, Math.tan, Math.cos, 0);
    fnn = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", p.write('z'));
    which = distrand(2, 0, 6);
    parms = 0;
    fn = 0;
    data = "";
    qString = "Sketch the curve in the \\(xy\\) plane given by \\(x = " + fnn[which[0]].replace(/z/g, 't') + ", y = " + fnn[which[1]].replace(/z/g, 't') + ". t\\) is a real parameter which ranges from \\(";
    if (which[0] && which[1]) {
      qString += " - 10";
    } else {
      qString += "0";
    }
    qString += " \\mbox{ to } 10.\\)";
    drawIt = function(parms){
      var f, g, p, l, d1, i$, i, x, y;
      f = parms[0];
      g = parms[1];
      p = parms[2];
      l = parms[3];
      d1 = [];
      for (i$ = l; i$ <= 10; i$ += 0.01) {
        i = i$;
        if (f) {
          x = f(i);
        } else {
          x = p.compute(i);
        }
        if (Math.abs(x) > 12) {
          x = null;
        }
        if (g) {
          y = g(i);
        } else {
          y = p.compute(i);
        }
        if (Math.abs(y) > 12) {
          y = null;
        }
        if (x && y) {
          d1.push([x, y]);
        } else {
          d1.push([null, null]);
        }
      }
      return [d1];
    };
    aString = '%GRAPH%';
    if (which[0] && which[1]) {
      qa = [qString, aString, drawIt, [fnf[which[0]], fnf[which[1]], p, -10]];
    } else {
      qa = [qString, aString, drawIt, [fnf[which[0]], fnf[which[1]], p, 0]];
    }
    return qa;
  };
  problems.makeImplicit = makeImplicit = function(){
    var makeImplicit1, makeImplicit2, qa;
    makeImplicit1 = function(){
      var a1, b1, c1, d1, a2, b2, c2, d2, t, qString, a, aString, qa;
      a1 = rand(1, 3);
      b1 = randnz(4);
      c1 = rand(1, 3);
      d1 = randnz(4);
      if (d1 * a1 - b1 * c1 === 0) {
        if (d1 > 0) {
          d1++;
        } else {
          d1--;
        }
      }
      a2 = randnz(3);
      b2 = randnz(4);
      c2 = rand(1, 3);
      d2 = randnz(4);
      if (d2 * a2 - b2 * c2 === 0) {
        if (d2 > 0) {
          d2++;
        } else {
          d2--;
        }
      }
      t = randnz(3);
      while (c1 * t + d1 === 0 || c2 * t + d2 === 0) {
        if (t > 0) {
          t++;
        } else {
          t--;
        }
      }
      qString = "If $$y = \\frac{" + p_linear(a1, b1).write('t') + "}{" + p_linear(c1, d1).write('t') + "}$$ and $$x = \\frac{" + p_linear(a2, b2).write('t') + "}{" + p_linear(c2, d2).write('t') + "},$$find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) when \\(t = " + t + "\\).";
      a = new frac((a1 * d1 - b1 * c1) * Math.pow(c2 * t + d2, 2), (a2 * d2 - b2 * c2) * Math.pow(c1 * t + d1, 2));
      aString = "$$" + a.write() + "$$";
      qa = [qString, aString];
      return qa;
    };
    makeImplicit2 = function(){
      var fns, difs, which, p, q, qString, aString, qa;
      fns = new Array("\\ln(z)", "e^{z}", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
      difs = new Array("\\frac{1}{z}", "e^{z}", " - \\csc(z)\\cot(z)", "\\sec(z)\\tan(z)", "\\cos(z)", "\\sec^2(z)", "-\\sin(z)");
      which = distrand(2, 0, 6);
      p = new poly(rand(1, 3));
      p.setrand(3);
      q = new poly(1);
      p.diff(q);
      qString = "If $$y + " + fns[which[0]].replace(/z/g, 'y') + " = " + fns[which[1]].replace(/z/g, 'x');
      if (p[p.rank] > 0) {
        qString += " + ";
      }
      qString += p.write('x') + ",$$ find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(y\\) and \\(x\\).";
      aString = "$$\\frac{\\mathrm{d}y}{\\mathrm{d}x} = \\frac{" + difs[which[1]].replace(/z/g, 'x');
      if (q[q.rank] > 0) {
        aString += " + ";
      }
      aString += q.write('x') + "}{" + difs[which[0]].replace(/z/g, 'y') + " + 1}$$";
      qa = [qString, aString];
      return qa;
    };
    if (rand()) {
      qa = makeImplicit1();
    } else {
      qa = makeImplicit2();
    }
    return qa;
  };
  problems.makeChainRule = makeChainRule = function(){
    var fns, difs, even, which, a, b, qString, c, aString, qa;
    fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
    difs = new Array("\\frac{y}{z}", "-y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)");
    even = new Array(-1, 1, -1, 1, 1, -1);
    which = rand(0, 5);
    a = new poly(rand(1, 3));
    a.setrand(8);
    b = new poly(0);
    a.diff(b);
    qString = "Differentiate \\(" + fns[which].replace(/z/g, a.write()) + "\\)";
    if (difs[which].charAt(0) === "-") {
      difs[which] = difs[which].slice(1);
      b.xthru(-1);
    }
    if (a[a.rank] < 0) {
      a.xthru(-1);
      b.xthru(even[which]);
    }
    if (which === 0) {
      c = gcd(a.gcd());
      a.xthru(1.0 / c);
      b.xthru(1.0 / c);
    }
    if (b.terms() > 1 && which) {
      aString = "(" + b.write() + ')';
    } else if (b.rank === 0 && which) {
      aString = ascoeff(b[0]);
    } else {
      aString = b.write();
    }
    aString = "$$" + difs[which].replace(/z/g, a.write()).replace(/y/g, aString) + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeProductRule = makeProductRule = function(){
    var fns, difs, even, which, a, b, qString, aString, i$, to$, i, qa;
    fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
    difs = new Array("\\frac{y}{z}", " - y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", " - y\\sin(z)");
    even = new Array(-1, 1, -1, 1, 1, -1);
    which = rand(0, 5);
    a = new poly(rand(1, 3));
    a.setrand(8);
    b = new poly(0);
    a.diff(b);
    qString = "Differentiate $$";
    if (a.terms() > 1) {
      qString += '(' + a.write() + ')' + fns[which].replace(/z/g, 'x');
    } else {
      qString += a.write() + fns[which].replace(/z/g, 'x');
    }
    qString += "$$";
    if (b.terms() > 1) {
      aString = '$$(' + b.write() + ')';
    } else if (b[0] === 1) {
      aString = '$$';
    } else if (b[0] === -1) {
      aString = '$$ - ';
    } else {
      aString = '$$' + b.write();
    }
    if (difs[which].charAt(0) === ' - ') {
      difs[which] = difs[which].slice(1);
      a.xthru(-1);
    }
    if (a[a.rank] > 0) {
      aString += fns[which].replace(/z/g, 'x') + ' + ';
    } else {
      aString += fns[which].replace(/z/g, 'x') + ' - ';
      a.xthru(-1);
    }
    if (which === 0 && a[0] === 0) {
      for (i$ = 0, to$ = a.rank - 1; i$ <= to$; ++i$) {
        i = i$;
        a[i] = a[i + 1];
      }
      a.rank--;
      aString += a.write();
    } else if (a.terms() > 1 && which) {
      aString += difs[which].replace(/y/g, '(' + a.write() + ')').replace(/z/g, 'x');
    } else if (a[0] === 1 && which) {
      aString += difs[which].replace(/y/g, '');
    } else {
      aString += difs[which].replace(/y/g, a.write()).replace(/z/g, 'x');
    }
    aString += '$$';
    qa = [qString, aString];
    return qa;
  };
  problems.makeQuotientRule = makeQuotientRule = function(){
    var fns, difs, even, which, a, b, qString, c, lead, bot, aString, qa;
    fns = new Array("\\sin(z)", "\\tan(z)", "\\cos(z)");
    difs = new Array("\\csc(z)\\cot(z)", "\\csc^2(z)", "\\sec(z)\\tan(z)");
    even = new Array(1, 1, -1);
    which = rand(0, 2);
    a = randnz(8);
    b = new poly(2);
    b.setrand(8);
    qString = "Differentiate $$\\frac{" + a + "}{" + fns[which].replace(/z/g, b.write()) + "}$$";
    c = new poly(1);
    b.diff(c);
    c.xthru(a);
    if (b[b.rank] < 0) {
      b.xthru(-1);
      c.xthru(even[which]);
    }
    lead = c.write();
    if (c.terms() > 1) {
      lead = '(' + lead + ')';
    } else if (c.rank === 0) {
      if (c[0] === 1) {
        lead = "";
      } else if (c[0] === -1) {
        lead = " - ";
      }
    }
    bot = difs[which].replace(/z/g, b.write());
    aString = '$$' + lead + bot + '$$';
    qa = [qString, aString];
    return qa;
  };
  problems.makeGP = makeGP = function(){
    var makeGP1, makeGP2, qa;
    makeGP1 = function(){
      var a, b, c, d, n, qString, top, bot, ans, aString, qa;
      a = randnz(8);
      b = rand(2, 9);
      c = 1;
      if (rand()) {
        b = -b;
      }
      if (rand()) {
        c = rand(2, 5);
        if (c === b) {
          c++;
        }
        d = gcd(b, c);
        b /= d;
        c /= d;
      }
      n = rand(5, 10);
      qString = "Evaluate $$\\sum_{r = 0}^{" + n + "} ";
      if (a !== 1) {
        if (a === -1) {
          if (c === 1 && b > 0) {
            qString += " - \\left(";
          } else {
            qString += " - ";
          }
        } else {
          qString += a + "\\times";
        }
      }
      if (c === 1) {
        if (b < 0) {
          qString += "\\left(" + b + "\\right)";
        } else {
          qString += b;
        }
      } else {
        qString += "\\left(\\frac{" + b + "}{" + c + "}\\right)";
      }
      qString += "^{r}";
      if (a === -1 && c === 1 && b > 0) {
        qString += "\\right)";
      }
      qString += "$$";
      top = new frac(-Math.pow(b, n + 1), Math.pow(c, n + 1));
      top.add(1);
      top.prod(a);
      bot = new frac(-b, c);
      bot.add(1);
      ans = new frac(top.top * bot.bot, top.bot * bot.top);
      ans.reduce();
      aString = '$$' + ans.write() + '$$';
      qa = [qString, aString];
      return qa;
    };
    makeGP2 = function(){
      var a, b, c, r, qString, ans, aString, qa;
      a = randnz(8);
      b = rand(1, 6);
      c = rand(b + 1, 12);
      if (rand()) {
        b = -b;
      }
      r = new frac(b, c);
      r.reduce();
      qString = "Evaluate$$\\sum_{r = 0}^{\\infty} ";
      if (a !== 1) {
        if (a === -1) {
          qString += " - ";
        } else {
          qString += a + "\\times";
        }
      }
      qString += "\\left(" + r.write() + "\\right)^{r}$$";
      r.prod(-1);
      r.add(1);
      ans = new frac(a * r.bot, r.top);
      aString = '$$' + ans.write() + '$$';
      qa = [qString, aString];
      return qa;
    };
    if (rand()) {
      qa = makeGP1();
    } else {
      qa = makeGP2();
    }
    return qa;
  };
  problems.makeImplicitFunction = makeImplicitFunction = function(){
    var mIF1, mIF2, mIF3;
    mIF1 = function(){
      var a, n, f, data, qString, drawIt, aString, qa;
      a = distrand(2, 2, 5);
      n = randnz(3);
      f = new frac(a[0], a[1]);
      data = "";
      qString = "Sketch the curve in the \\(xy\\) plane given by \\(y = " + ascoeff(n) + "x^{" + f.write() + "}\\)";
      drawIt = function(parms){
        var f, n, d1, i$, i, x, y;
        f = parms[0];
        n = parms[1];
        d1 = [];
        for (i$ = -10; i$ <= 10; i$ += 0.01) {
          i = i$;
          x = Math.pow(i, f.bot);
          if (Math.abs(x) > 12) {
            x = null;
          }
          y = n * Math.pow(i, f.top);
          if (Math.abs(y) > 12) {
            y = null;
          }
          if (x && y) {
            d1.push([x, y]);
          } else {
            d1.push([null, null]);
          }
        }
        return [d1];
      };
      aString = '%GRAPH%';
      qa = [qString, aString, drawIt, [f, n]];
      return qa;
    };
    mIF2 = function(){
      var a, n, f, data, qString, drawIt, parms, aString, qa;
      a = distrandnz(2, 5);
      n = randnz(6);
      f = new frac(a[0], a[1]);
      data = "";
      qString = "Sketch the curve in the \\(xy\\) plane given by \\(" + ascoeff(a[0]) + "y";
      if (a[1] > 0) {
        qString += " + ";
      }
      qString += ascoeff(a[1]) + "x";
      if (n > 0) {
        qString += " + ";
      }
      qString += n + " = 0\\)";
      drawIt = function(parms){
        var f, n, d1, i$, i, y;
        f = parms[0];
        n = parms[1];
        d1 = [];
        for (i$ = -10; i$ <= 10; i$ += 0.01) {
          i = i$;
          y = -i * a[1] / a[0] - n / a[0];
          d1.push([i, y]);
        }
        return [d1];
      };
      parms = [f, n];
      aString = '%GRAPH%';
      qa = [qString, aString, drawIt, [f, n]];
      return qa;
    };
    mIF3 = function(){
      var a, qString, drawIt, aString, qa;
      a = distrandnz(2, 2, 5);
      qString = "Sketch the curve in the \\(xy\\) plane given by \\(\\frac{x^2}{" + a[0] * a[0] + "} + \\frac{y^2}{" + a[1] * a[1] + "} = 1\\)";
      drawIt = function(parms){
        var d1, i$, i, x, y;
        d1 = [];
        for (i$ = -1; i$ <= 1; i$ += 0.005) {
          i = i$;
          x = parms[0] * Math.cos(i * Math.PI);
          y = parms[1] * Math.sin(i * Math.PI);
          d1.push([x, y]);
        }
        return [d1];
      };
      aString = '%GRAPH%';
      qa = [qString, aString, drawIt, a];
      return qa;
    };
    return pickrand(mIF1, mIF2, mIF3)();
  };
  problems.makeIntegration = makeIntegration = function(){
    var makeIntegration1, makeIntegration2, qa;
    makeIntegration1 = function(){
      var fns, difs, even, which, a, u, b, aString, qString, qa;
      fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
      difs = new Array("\\frac{y}{z}", "-y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)");
      even = new Array(-1, 1, -1, 1, 1, -1);
      which = rand(0, 5);
      a = new poly(rand(1, 3));
      a.setrand(8);
      a[a.rank] = Math.abs(a[a.rank]);
      if (which === 0) {
        a.xthru(1.0 / a.gcd());
      }
      u = randnz(4);
      b = new poly(0);
      a.diff(b);
      aString = '$$' + p_linear(u, 0).write(fns[which].replace(/z/g, a.write())) + " + c$$";
      if (difs[which].charAt(0) === "-") {
        difs[which] = difs[which].slice(1);
        b.xthru(-1);
      }
      b.xthru(u);
      if (b.terms() > 1 && which) {
        qString = '(' + b.write() + ')';
      } else if (b.rank === 0 && which) {
        qString = ascoeff(b[0]);
      } else {
        qString = b.write();
      }
      qString = "Find $$\\int" + difs[which].replace(/z/g, a.write()).replace(/y/g, qString) + "\\,\\mathrm{d}x$$";
      qa = [qString, aString];
      return qa;
    };
    makeIntegration2 = function(){
      var fns, difs, even, which, a, b, aString, qString, i$, to$, i, qa;
      fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
      difs = new Array("\\frac{y}{z}", "-y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)");
      even = new Array(-1, 1, -1, 1, 1, -1);
      which = rand(0, 5);
      a = new poly(rand(1, 3));
      a.setrand(8);
      b = new poly(0);
      a.diff(b);
      aString = "$$";
      if (a.terms() > 1) {
        aString += '(' + a.write() + ')' + fns[which].replace(/z/g, 'x');
      } else {
        aString += a.write() + fns[which].replace(/z/g, 'x');
      }
      aString += " + c$$";
      qString = "Find $$\\int";
      if (b.terms() > 1) {
        qString += "(" + b.write() + ")";
      } else if (b[0] === 1) {
        qString += "";
      } else if (b[0] === -1) {
        qString += "-";
      } else {
        qString += b.write();
      }
      if (difs[which].charAt(0) === "-") {
        difs[which] = difs[which].slice(1);
        a.xthru(-1);
      }
      if (a[a.rank] > 0) {
        qString += fns[which].replace(/z/g, 'x') + "+";
      } else {
        qString += fns[which].replace(/z/g, 'x') + "-";
        a.xthru(-1);
      }
      if (which === 0 && a[0] === 0) {
        for (i$ = 0, to$ = a.rank - 1; i$ <= to$; ++i$) {
          i = i$;
          a[i] = a[i + 1];
        }
        a.rank--;
        qString += a.write();
      } else if (a.terms() > 1 && which) {
        qString += difs[which].replace(/y/g, '(' + a.write() + ')').replace(/z/g, 'x');
      } else if (a[0] === 1 && which) {
        qString += difs[which].replace(/y/g, '');
      } else {
        qString += difs[which].replace(/y/g, a.write()).replace(/z/g, 'x');
      }
      qString += "\\,\\mathrm{d}x$$";
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeIntegration1, makeIntegration2)();
    return qa;
  };
  problems.makeDE = makeDE = function(){
    /* The first order code was buggy. No time to fix, so removed */
    /*makeDE1 = ->
      n = rand(1,3)
      fns = new Array("\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", n == 1?"{z}":"{z}^" + n)
      recint = new Array(" - \\cos(z)", "\\sin(z)", " - \\ln{\|\\csc(z) + \\cot(z)\|}", "\\ln\|\\sin(z)\|", "\\ln\|\\sec(z) + \\tan(z)\|", "{z}^{" + (-1 - n) + "}")
      riinv = new Array("\\arccos\\left(-z\\right)", "\\arcsin\\left(z\\right)", 0, 0, 0, "{\\left(z\\right)}^{ - \\frac{1}{" + (1 + n) + "}}")
      eriinv = new Array(0, 0, 0, "\\arcsin\\left(z\\right)", 0, 0)
      which = distrand(2, 0, 5)
      qString = "\\begin{array}{l}\\mbox{Find the general solution of the following first - order ODE:}\\\\ " + fns[which[0]].replace(/z/g, 'x') + "\\frac{\\,dy}{\\,dx} + " + fns[which[1]].replace(/z/g, 'y') + " = 0\\end{array}"
      # f(x)y' + g(y) = 0 = > - 1 / g(y) dy = 1 / f(x) dx
    
      if recint[which[1]].charAt(0) is ' - '
        recint[which[1]] = recint[which[1]].slice(1)
      else
        recint[which[1]] = ' - ' + recint[which[1]]
    
      if (recint[which[0]].search(/ln/) is - 1) or (recint[which[1]].search(/ln/) is - 1)
        if riinv[which[1]] is 0
          aString = recint[which[1]].replace(/z/g, 'y') + " = - " + recint[which[0]].replace(/z/g, 'x') + " + c"
        else
          aString = "y = " + riinv[which[1]].replace(/z/g, ' - ' + recint[which[0]].replace(/z/g, 'x') + " + c")
    
      else
        if eriinv[which[1]] is 0
          aString = recint[which[1]].replace(/z/g, 'y').replace(/-\\ln{/, "\\frac{1}{").replace(/\\ln/, "") + " = - " + recint[which[0]].replace(/z/g, 'x').replace(/-\\ln{/, "\\frac{A}{").replace(/\\ln/, "A")
        else
          aString = "y = " + eriinv[which[1]].replace(/z/g, ' - ' + recint[which[0]].replace(/z/g, 'x').replace(/-\\ln{/, "\\frac{A}{").replace(/\\ln/, "A"))
    
      aString = aString.replace(/--/g, "") # - (-x + c) = (x - c) = (x + k) and call k c
    
      qa = [qString, aString]
      return qa */
    var makeDE2, makeDE3, qa;
    makeDE2 = function(){
      var roots, p, qString, aString, qa;
      roots = distrand(2, 4);
      p = p_quadratic(1, -roots[0] - roots[1], roots[0] * roots[1]);
      qString = "Find the general solution of the following second-order ODE:$$" + p.write('D').replace("D^2", "\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}").replace("D", "\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}");
      if (p[0] === 0) {
        qString += " = 0$$";
      } else {
        qString += "y = 0$$";
      }
      aString = "$$y = ";
      if (roots[0] === 0) {
        aString += "A + ";
      } else {
        aString += "Ae^{" + ascoeff(roots[0]) + "x}" + " + ";
      }
      if (roots[1] === 0) {
        aString += "B$$";
      } else {
        aString += "Be^{" + ascoeff(roots[1]) + "x}" + '$$';
      }
      qa = [qString, aString];
      return qa;
    };
    makeDE3 = function(){
      var b, qString, aString, qa;
      b = randnz(6);
      qString = "Find the general solution of the following first-order ODE:$$x\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x} - y";
      if (b > 0) {
        qString += signedNumber(-b) + " = 0.$$";
      } else {
        qString += " = " + (-b) + "$$";
      }
      aString = "$$y = Ax";
      if (b > 0) {
        aString += " + ";
      }
      aString += b + '$$';
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeDE2, makeDE3)();
    return qa;
  };
  problems.makePowers = makePowers = function(){
    var res, q, i$, i, a, b, p, u, c, qString, aString, qa;
    res = new frac();
    q = "";
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      if (i === 1 || i > 2) {
        q += "\\times ";
      }
      switch (rand(1, 4)) {
      case 1:
        a = randnz(4);
        b = randnz(5);
        p = new frac(a, b);
        if (p.top === p.bot) {
          q += "x";
        } else {
          q += "x^{" + p.write() + "}";
        }
        if (i > 1) {
          a = -a;
        }
        res.add(a, b);
        break;
      case 2:
        a = randnz(4);
        b = randnz(2, 5);
        if (gcd(a, b) !== 1) {
          if (a > 0) {
            a++;
          } else {
            a--;
          }
        }
        q += "\\root " + b + " \\of";
        if (a === 1) {
          q += "{x}";
        } else {
          q += "{x^{" + a + "}}";
        }
        if (i > 1) {
          a = -a;
        }
        res.add(a, b);
        break;
      case 3:
        u = distrand(2, 1, 3);
        a = u[0];
        b = u[1];
        c = randnz(2, 6);
        p = new frac(a, b);
        q += "\\left(x^{" + p.write() + "}\\right)^" + c;
        if (i > 1) {
          a = -a;
        }
        res.add(a * c, b);
        break;
      case 4:
        q += "x";
        if (i > 1) {
          res.add(-1, 1);
        } else {
          res.add(1, 1);
        }
      }
      if (i === 1) {
        q += "}{";
      }
    }
    qString = "Simplify $$\\frac{" + q + "}$$";
    if (res.top === res.bot) {
      aString = "$$x$$";
    } else {
      aString = "$$x^{" + res.write() + "}$$";
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeHCF = makeHCF = function(){
    var a, b, qString, aString, qa;
    a = rand(1, 99999);
    b = rand(1, 99999);
    if (rand()) {
      while (gcd(a, b) === 1) {
        b = rand(1, 99999);
      }
    }
    while (a === b) {
      b = rand(1, 99999);
    }
    qString = "Find the highest common factor of \\(" + a + "\\) and \\(" + b + "\\).";
    aString = "$$" + gcd(a, b) + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeLCM = makeLCM = function(){
    var a, b, qString, aString, qa;
    a = rand(1, 200);
    b = rand(1, 200);
    if (rand()) {
      while (gcd(a, b) === 1) {
        b = rand(1, 200);
      }
    }
    while (a === b) {
      b = rand(1, 200);
    }
    qString = "Find the least common multiple of \\(" + a + "\\) and \\(" + b + "\\).";
    aString = "$$" + lcm(a, b) + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeDiophantine = makeDiophantine = function(){
    var a, b, c, qString, d, aString, coeffs, printSol, qa;
    a = rand(1, 999);
    b = rand(1, 999);
    if (rand()) {
      while (gcd(a, b) === 1) {
        b = rand(1, 999);
      }
    }
    while (a === b) {
      b = rand(1, 200);
    }
    c = rand(999);
    while (a === c || b === c) {
      c = rand(999);
    }
    qString = "Find all integer solutions \\(m\\) and \\(n\\) to the equation \\(" + a + "m + " + b + "n = " + c + "\\).";
    d = gcd(a, b);
    if (c % d !== 0) {
      aString = "There are no integer solutions to the equation.";
    } else {
      coeffs = lincombination(a, b);
      printSol = function(c1, varname, c2){
        var eqString;
        eqString = varname + " = ";
        if (c1 !== 0) {
          eqString += c1;
        }
        if (c2 < 0) {
          if (c2 === -1) {
            eqString += "-";
          } else {
            eqString += c2;
          }
          eqString += "r";
        } else if (c2 > 0) {
          if (c1 !== 0) {
            if (c2 === 1) {
              eqString += "+";
            } else {
              eqString += signedNumber(c2);
            }
          } else {
            if (c2 !== 1) {
              eqString += c2;
            }
          }
          eqString += "r";
        }
        return eqString;
      };
      aString = "The solutions are $$";
      aString += printSol(c / d * coeffs[0], "m", b / d) + ", \\qquad\\text{and}\\qquad ";
      aString += printSol(c / d * coeffs[1], "n", -b / d);
      aString += "$$ where \\(r\\) is an integer.";
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeDistance = makeDistance = function(){
    var maxdist, makeDistII, makeDistFF, qa;
    maxdist = 10;
    makeDistII = function(){
      var a1, a2, b1, b2, a3, b3, a3str, b3str, qString, sq, aString, qa;
      a1 = rand(maxdist);
      a2 = rand(maxdist);
      b1 = rand(maxdist);
      b2 = rand(maxdist);
      while (b1 === a1 && b2 === a2) {
        b1 = rand(maxdist);
        b2 = rand(maxdist);
      }
      if (rand()) {
        a3 = rand(maxdist);
        b3 = rand(maxdist);
        a3str = "," + a3;
        b3str = "," + b3;
      } else {
        a3 = 0;
        b3 = 0;
        a3str = "";
        b3str = "";
      }
      qString = "Find the distance between the points \\((" + a1 + "," + a2 + a3str + ")\\) and \\((" + b1 + "," + b2 + b3str + ")\\).";
      sq = new sqroot(Math.pow(b1 - a1, 2) + Math.pow(b2 - a2, 2) + Math.pow(b3 - a3, 2));
      aString = "$$" + sq.write() + "$$";
      qa = [qString, aString];
      return qa;
    };
    makeDistFF = function(){
      var a1, a2, b1, b2, a3, b3, a3str, b3str, qString, denom, s1, s2, s3, t1, t2, t3, sq, aString, qa;
      a1 = new frac(rand(maxdist), randnz(maxdist));
      a2 = new frac(rand(maxdist), randnz(maxdist));
      b1 = new frac(rand(maxdist), randnz(maxdist));
      b2 = new frac(rand(maxdist), randnz(maxdist));
      if (rand()) {
        a3 = new frac(rand(maxdist), randnz(maxdist));
        b3 = new frac(rand(maxdist), randnz(maxdist));
        a3str = "," + a3.write();
        b3str = "," + b3.write();
      } else {
        a3 = new frac(0, 1);
        b3 = new frac(0, 1);
        a3str = "";
        b3str = "";
      }
      qString = "Find the distance between the points \\((" + a1.write() + "," + a2.write() + a3str + ")\\) and \\((" + b1.write() + "," + b2.write() + b3str + ")\\).";
      denom = a1.bot * a2.bot * a3.bot * b1.bot * b2.bot * b3.bot;
      s1 = denom / a1.bot * a1.top;
      s2 = denom / a2.bot * a2.top;
      s3 = denom / a3.bot * a3.top;
      t1 = denom / b1.bot * b1.top;
      t2 = denom / b2.bot * b2.top;
      t3 = denom / b3.bot * b3.top;
      sq = new sqroot(Math.pow(t1 - s1, 2) + Math.pow(t2 - s2, 2) + Math.pow(t3 - s3, 2));
      aString = "$$" + simplifySurd(0, sq.a, sq.n, denom) + "$$";
      qa = [qString, aString];
      return qa;
    };
    qa = pickrand(makeDistII, makeDistFF)();
    return qa;
  };
  problems.makeCircumCircle = makeCircumCircle = function(){
    var maxdist, a1, a2, b1, b2, c1, c2, d, X, Y, x, y, sq, qString, aString, qa;
    maxdist = 10;
    a1 = rand(maxdist);
    a2 = rand(maxdist);
    b1 = rand(maxdist);
    b2 = rand(maxdist);
    c1 = rand(maxdist);
    c2 = rand(maxdist);
    d = 2 * (a1 * (b2 - c2) + b1 * (c2 - a2) + c1 * (a2 - b2));
    X = (Math.pow(a1, 2) + Math.pow(a2, 2)) * (b2 - c2) + (Math.pow(b1, 2) + Math.pow(b2, 2)) * (c2 - a2) + (Math.pow(c1, 2) + Math.pow(c2, 2)) * (a2 - b2);
    Y = (Math.pow(a1, 2) + Math.pow(a2, 2)) * (c1 - b1) + (Math.pow(b1, 2) + Math.pow(b2, 2)) * (a1 - c1) + (Math.pow(c1, 2) + Math.pow(c2, 2)) * (b1 - a1);
    x = new frac(X, d);
    y = new frac(Y, d);
    sq = new sqroot(Math.pow(X - b1 * d, 2) + Math.pow(Y - b2 * d, 2));
    qString = "Find the centre and radius of the circle passing through the points ";
    qString += "\\((" + a1 + "," + a2 + ")\\), ";
    qString += "\\((" + b1 + "," + b2 + ")\\) and ";
    qString += "\\((" + c1 + "," + c2 + ")\\).";
    aString = "The centre is ";
    aString += "\\((" + x.write() + "," + y.write() + ")\\) and ";
    aString += "the radius is \\(" + simplifySurd(0, sq.a, sq.n, d) + "\\).";
    qa = [qString, aString];
    return qa;
  };
  /**************************\
  |*  START OF FP MATERIAL  *|
  \**************************/
  problems.makeCArithmetic = makeCArithmetic = function(){
    var z, w, qString, aString, qa;
    z = Complex.randnz(6, 6);
    w = Complex.randnz(4, 6);
    qString = "Given \\(z = " + z.write() + "\\) and \\(w = " + w.write() + "\\), compute:";
    qString += "<ul class=\"exercise\">";
    qString += "<li>\\(z + w\\)</li>";
    qString += "<li>\\(z\\times w\\)</li>";
    qString += "<li>\\(\\frac{z}{w}\\)</li>";
    qString += "<li>\\(\\frac{w}{z}\\)</li>";
    qString += "</ul>";
    aString = "<ul class=\"exercise\">";
    aString += "<li>\\(" + z.add(w.Re, w.Im).write() + "\\)</li>";
    aString += "<li>\\(" + z.times(w.Re, w.Im).write() + "\\)</li>";
    aString += "<li>\\(" + z.divide(w.Re, w.Im).write() + "\\)</li>";
    aString += "<li>\\(" + w.divide(z.Re, z.Im).write() + "\\)</li>";
    aString += "</ul>";
    qa = [qString, aString];
    return qa;
  };
  problems.makeCPolar = makeCPolar = function(){
    var z, qString, ma, r, t, aString, qa;
    if (rand()) {
      z = Complex.randnz(6, 6);
    } else {
      z = Complex.randnz(6, 4);
    }
    qString = "Convert \\(" + z.write() + "\\) to modulus-argument form.";
    ma = Complex.ctop(z);
    r = Math.round(ma[0]);
    t = guessExact(ma[1] / Math.PI);
    if (r === 1) {
      aString = "$$";
    } else {
      aString = "$$" + r;
    }
    aString += "e^{";
    if (t === 0) {
      aString += "0";
    } else if (t === 1) {
      aString += "\\pi i";
    } else {
      aString += t + "\\pi i";
    }
    aString += "}$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeDETwoHard = makeDETwoHard = function(){
    var p, disc, roots, qString, aString, qa;
    p = new poly(2);
    p.setrand(6);
    p[2] = 1;
    disc = Math.pow(p[1], 2) - 4 * p[0] * p[2];
    roots = [0, 0];
    if (disc > 0) {
      roots[0] = (-p[1] + Math.sqrt(disc)) / 2;
      roots[1] = (-p[1] - Math.sqrt(disc)) / 2;
    } else if (disc === 0) {
      roots[0] = roots[1] = (-p[1]) / 2;
    } else {
      roots[0] = new complex(-p[1] / 2, Math.sqrt(-disc) / 2);
      roots[1] = new complex(-p[1] / 2, -Math.sqrt(-disc) / 2);
    }
    qString = "Find the general solution of the following second-order ODE:$$" + p.write('D').replace("D^2", "\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}").replace("D", "\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}");
    if (p[0] !== 0) {
      qString += "y";
    }
    qString += " = 0$$";
    qString = qString.replace(/1y/g, "y");
    aString = "$$y = ";
    if (disc > 0) {
      if (guessExact(roots[0]) === 0) {
        aString += "A";
      } else {
        aString += "Ae^{" + ascoeff(guessExact(roots[0])) + "x}";
      }
      if (guessExact(roots[1]) === 0) {
        aString += " + B$$";
      } else {
        aString += " + Be^{" + ascoeff(guessExact(roots[0])) + "x}$$";
      }
    } else if (disc === 0) {
      if (roots[0] === 0) {
        aString += "Ax + B";
      } else {
        aString += "(Ax + B)";
      }
      if (guessExact(roots[0])) {
        aString += "e^{" + ascoeff(guessExact(roots[0])) + "x}";
      }
      aString += "$$";
    } else {
      aString += "A\\cos\\left(" + ascoeff(guessExact(roots[0].Im)) + "x + \\varepsilon\\right)";
      if (guessExact(roots[0].Re)) {
        aString += "e^{" + ascoeff(guessExact(roots[0].Re)) + "x}";
      }
      aString += "$$";
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeMatrixQ = makeMatrixQ = function(dim, max){
    var A, B, I, i$, to$, i, qString, S, P, Y, aString, qa;
    A = new fmatrix(dim);
    A.setrand(max);
    B = new fmatrix(dim);
    B.setrand(max);
    I = new fmatrix(dim);
    I.zero();
    for (i$ = 0, to$ = I.dim - 1; i$ <= to$; ++i$) {
      i = i$;
      I[i][i].set(1, 1);
    }
    i = 0;
    while (B.det().top === 0) {
      if (i >= B.dim) {
        throw new Error("makeMatrixQ: failed to make a non-singular matrix");
      }
      B = B.add(I);
      i++;
    }
    qString = "Let $$A = " + A.write() + " \\qquad \\text{and} \\qquad B = " + B.write() + "$$.";
    qString += "Compute: <ul class=\"exercise\">";
    qString += "<li>\\(A + B\\)</li>";
    qString += "<li>\\(A \\times B\\)</li>";
    qString += "<li>\\(B^{ - 1}\\)</li>";
    qString += "</ul>";
    S = A.add(B);
    P = A.times(B);
    Y = B.inv();
    aString = "<ul class=\"exercise\">";
    aString += "<li>\\(" + S.write() + "\\)</li>";
    aString += "<li>\\(" + P.write() + "\\)</li>";
    aString += "<li>\\(" + Y.write() + "\\)</li>";
    aString += "</ul>";
    qa = [qString, aString];
    return qa;
  };
  problems.makeMatrix2 = makeMatrix2 = function(){
    return makeMatrixQ(2, 6);
  };
  problems.makeMatrix3 = makeMatrix3 = function(){
    return makeMatrixQ(3, 4);
  };
  problems.makeTaylor = makeTaylor = function(){
    var f, t, which, n, qString, p, i$, i, aString, qa;
    f = ["\\sin(z)", "\\cos(z)", "\\arctan(z)", "e^{z}", "\\log_{e}(1 + z)"];
    t = [[new frac(0), new frac(1), new frac(0), new frac(-1, 6)], [new frac(1), new frac(0), new frac(-1, 2), new frac(0)], [new frac(0), new frac(1), new frac(0), new frac(-1, 3)], [new frac(1), new frac(1), new frac(1, 2), new frac(1, 6)], [new frac(0), new frac(1), new frac(-1, 2), new frac(1, 3)]];
    which = rand(0, 4);
    n = randfrac(6);
    if (n.top === 0) {
      n = new frac(1);
    }
    qString = "Find the Taylor series of \\(" + f[which].replace(/z/g, fcoeff(n, 'x')) + "\\) about \\(x = 0\\) up to and including the term in \\(x^3\\)";
    p = new fpoly(3);
    for (i$ = 0; i$ <= 3; ++i$) {
      i = i$;
      p[i] = new frac(t[which][i].top * Math.pow(n.top, i), t[which][i].bot * Math.pow(n.bot, i));
    }
    aString = "$$" + p.rwrite() + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makePolarSketch = makePolarSketch = function(){
    var fnf, fnn, which, parms, fn, a, b, qString, aString, qa;
    fnf = [
      Math.sin, Math.tan, Math.cos, function(x){
        return x;
      }
    ];
    fnn = ["\\sin(z)", "\\tan(z)", "\\cos(z)", "z"];
    which = rand(0, 3);
    parms = 0;
    fn = 0;
    a = rand(0, 3);
    if (which === 3) {
      b = rand(1, 1);
    } else {
      b = rand(1, 5);
    }
    qString = "Sketch the curve given in polar co-ordinates by \\(r = ";
    if (a) {
      qString += a + " + ";
    }
    qString += fnn[which].replace(/z/g, ascoeff(b) + '\\theta') + "\\) (where \\(\\theta\\) runs from \\(-\\pi\\) to \\(\\pi\\)).";
    makePolarSketch.fn = function(parms){
      var f, d1, i$, i, r, x, y;
      f = parms[0];
      d1 = [];
      for (i$ = -1; i$ <= 1; i$ += 0.005) {
        i = i$;
        r = parms[1] + f(i * Math.PI * parms[2]);
        x = r * Math.cos(i * Math.PI);
        if (Math.abs(x) > 6) {
          x = null;
        }
        y = r * Math.sin(i * Math.PI);
        if (Math.abs(y) > 6) {
          y = null;
        }
        if (x && y) {
          d1.push([x, y]);
        } else {
          d1.push([null, null]);
        }
      }
      return [d1];
    };
    aString = '%GRAPH%' + JSON.stringify([fnf[which], a, b]);
    qa = [qString, aString];
    return qa;
  };
  problems.makeFurtherVector = makeFurtherVector = function(){
    var a, b, c, qString, axb, abc, aString, qa;
    a = new vector(3);
    a.setrand(5);
    b = new vector(3);
    b.setrand(5);
    c = new vector(3);
    c.setrand(5);
    qString = "Let \\(\\mathbf{a} = " + a.write() + "\\,\\), \\(\\mathbf{b} = " + b.write() + "\\,\\) and \\(\\mathbf{c} = " + c.write() + "\\). ";
    qString += "Calculate: <ul class=\"exercise\">";
    qString += "<li>the vector product, \\(\\mathbf{a}\\wedge \\mathbf{b}\\),</li>";
    qString += "<li>the scalar triple product, \\([\\mathbf{a}, \\mathbf{b}, \\mathbf{c}]\\).</li>";
    qString += "</ul>";
    axb = a.cross(b);
    abc = axb.dot(c);
    aString = "<ul class=\"exercise\">";
    aString += "<li>\\(" + axb.write() + "\\)</li>";
    aString += "<li>\\(" + abc + "\\)</li>";
    aString += "</ul>";
    qa = [qString, aString];
    return qa;
  };
  problems.makeNewtonRaphson = makeNewtonRaphson = function(){
    var fns, difs, fnf, diff, which, p, np, i$, i, q, nq, n, x, qString, aString, to$, eff, effdash, qa;
    fns = ["\\ln(z)", "e^{z}", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)"];
    difs = ["\\frac{1}{z}", "e^{z}", " - \\csc(z)\\cot(z)", "\\sec(z)\\tan(z)", "\\cos(z)", "\\sec^2(z)", " - \\sin(z)"];
    fnf = [
      Math.log, Math.exp, function(x){
        return 1 / Math.sin(x);
      }, function(x){
        return 1 / Math.cos(x);
      }, Math.sin, Math.tan, Math.cos
    ];
    diff = [
      function(x){
        return 1 / x;
      }, Math.exp, function(x){
        return Math.cos(x) / Math.pow(Math.sin(x), 2);
      }, function(x){
        return Math.sin(x) / Math.pow(Math.cos(x), 2);
      }, Math.cos, function(x){
        return 1 / Math.pow(Math.cos(x), 2);
      }, function(x){
        return -Math.sin(x);
      }
    ];
    which = rand(0, 6);
    p = new poly(2);
    p.setrand(6);
    p[2] = 1;
    np = new poly(2);
    for (i$ = 0; i$ <= 2; ++i$) {
      i = i$;
      np[i] = -p[i];
    }
    q = new poly(1);
    p.diff(q);
    nq = new poly(1);
    np.diff(nq);
    n = rand(4, 6);
    x = new Array(n + 1);
    if (which) {
      x[0] = rand(0, 4);
    } else {
      x[0] = rand(2, 4);
    }
    qString = "Use the Newton-Raphson method to find the first \\(" + n + "\\) iterates in solving \\(" + p.write() + " = " + fns[which].replace(/z/g, 'x') + "\\) with \\(x_0 = " + x[0] + "\\).";
    aString = "Iteration: \\begin{align*} x_{n + 1} &= x_{n} - \\frac{" + fns[which].replace(/z/g, 'x_n') + np.write() + "}{" + difs[which].replace(/z/g, 'x_n') + nq.write() + "} \\\\[10pt]";
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      eff = fnf[which](x[i]) - p.compute(x[i]);
      effdash = diff[which](x[i]) - q.compute(x[i]);
      x[i + 1] = x[i] - eff / effdash;
      if (Math.abs(x[i + 1]) < 1 - 7) {
        x[i + 1] = 0;
      }
      aString += "x_{" + (i + 1) + "} &= " + x[i + 1].toPrecision(6) + "\\\\";
    }
    aString += "\\end{align*}";
    if (isNaN(x[n])) {
      return makeNewtonRaphson();
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeFurtherIneq = makeFurtherIneq = function(){
    var A, B, C, qString, aedb, root, poles, aString, m, i$, i, l, j, n, qa;
    A = distrandnz(2, 6);
    B = distrandnz(2, 6);
    C = distrand(2, 6);
    qString = "Find the range of values of \\(x\\) for which$$";
    qString += "\\frac{" + A[0] + "}{" + p_linear(B[0], C[0]).write() + "} < \\frac{" + A[1] + "}{" + p_linear(B[1], C[1]).write() + "}$$";
    aedb = A[0] * B[1] - A[1] * B[0];
    root = new frac(A[1] * C[0] - A[0] * C[1], aedb);
    poles = [new frac(-C[0], B[0]), new frac(-C[1], B[1])];
    if (aedb === 0) {
      if (poles[0].equals(poles[1])) {
        aString = "The two fractions are equivalent, so the inequality never holds.";
      } else {
        m = new Array(2);
        for (i$ = 0; i$ <= 1; ++i$) {
          i = i$;
          m[i] = poles[i].top / poles[i].bot;
        }
        l = ranking(m);
        if (m[0] > m[1]) {
          aString = "$$x < " + poles[l[0]].write() + " \\mbox{ or }" + poles[l[1]].write() + " < x$$";
        } else {
          aString = "$$" + poles[l[0]].write() + " < x < " + poles[l[1]].write() + "$$";
        }
      }
    } else {
      if (poles[0].equals(poles[1])) {
        i = A[0] / B[0];
        j = A[1] / B[1];
        if (i > j) {
          aString = "$$x < " + poles[0].write() + "$$";
        } else {
          aString = "$$" + poles[0].write() + " < x$$";
        }
      } else {
        n = [root, poles[0], poles[1]];
        m = new Array(3);
        for (i$ = 0; i$ <= 2; ++i$) {
          i = i$;
          m[i] = n[i].top / n[i].bot;
        }
        l = ranking(m);
        i = A[0] / B[0];
        j = A[1] / B[1];
        if (i > j) {
          aString = "$$x < " + n[l[0]].write() + "\\mbox{ or }" + n[l[1]].write() + " < x < " + n[l[2]].write() + "$$";
        } else {
          aString = "$$" + n[l[0]].write() + " < x < " + n[l[1]].write() + "\\mbox{ or }" + n[l[2]].write() + " < x$$";
        }
      }
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeSubstInt = makeSubstInt = function(){
    var p, fns, fsq, q, difs, t, dt, pm, ldt, pdt, which, what, a, qString, r, aString, qa;
    p = new poly(rand(1, 2));
    p.setrand(2);
    fns = ["\\ln(Az)", "e^{Az}", p.rwrite('z')];
    fsq = ["(\\ln(Az))^2", "e^{2Az}", polyexpand(p, p).write('z')];
    q = new poly(p.rank - 1);
    p.diff(q);
    difs = ["\\frac{A}{z}", "Ae^{Az}", q.write('z')];
    t = ["\\arcsin(f)", "\\arctan(f)", "{\\rm arsinh}(f)", "{\\rm artanh}(f)"];
    dt = ["\\frac{y}{\\sqrt{1 - F}}", "\\frac{y}{1 + F}", "\\frac{y}{\\sqrt{1 + F}}", "\\frac{y}{1 - F}"];
    pm = [-1, 1, 1, -1];
    ldt = ["\\frac{A}{y\\sqrt{1 - F}}", "\\frac{A}{y(1 + F)}", "\\frac{A}{y\\sqrt{1 + F}}", "\\frac{A}{y(1 - F)}"];
    pdt = ["\\frac{y}{\\sqrt{F}}", "\\frac{y}{F}", "\\frac{y}{\\sqrt{F}}", "\\frac{y}{F}"];
    which = rand(0, 2);
    what = rand(0, 3);
    if (what === 0 && which === 0) {
      which = rand(0, 1);
    }
    a = randnz(4);
    qString = "Find $$\\int";
    if (which === 0) {
      qString += ldt[what].replace(/y/g, 'x').replace(/F/g, fsq[which].replace(/A/g, ascoeff(a))).replace(/z/g, 'x').replace(/A/g, a);
    } else if (which === 2) {
      r = polyexpand(p, p);
      r.xthru(pm[what]);
      r[0]++;
      qString += pdt[what].replace(/y/g, difs[which]).replace(/F/g, r.rwrite('z')).replace(/z/g, 'x');
    } else {
      qString += dt[what].replace(/y/g, difs[which]).replace(/F/g, fsq[which]).replace(/z/g, 'x').replace("2A", ascoeff(2 * a)).replace(/A/g, ascoeff(a));
    }
    qString += "\\,\\mathrm{d}x$$";
    aString = "$$" + t[what].replace(/f/g, fns[which]).replace(/z/g, 'x').replace(/A/g, ascoeff(a)) + " + c$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeRevolution = makeRevolution = function(){
    var makeSolidRevolution, makeSurfaceRevolution, qa;
    makeSolidRevolution = function(){
      var fns, iss, isf, which, x0, x, qString, ans, aString, qa;
      fns = ["\\sec(z)", "\\csc(z)", "\\sqrt{z}"];
      iss = ["\\tan(z)", "-\\cot(z)", 0];
      isf = [
        Math.tan, function(x){
          return -1 / Math.tan(x);
        }, function(x){
          return Math.pow(x, 2) / 2;
        }
      ];
      which = rand(0, 2);
      x0 = 0;
      if (which === 1) {
        x0++;
      }
      if (which === 2) {
        x = rand(x0 + 1, x0 + 4);
      } else {
        x = rand(x0 + 1, x0 + 1);
      }
      qString = "Find the volume of the solid formed when the area under";
      qString += "$$y = " + fns[which].replace(/z/g, 'x') + "$$";
      qString += "from \\(x = " + x0 + "\\) to \\(x = " + x + "\\) is rotated through \\(2\\pi\\) around the \\(x\\)-axis.";
      if (which === 2) {
        ans = guessExact(isf[which](x) - isf[which](x0));
      } else {
        ans = "\\left(" + iss[which].replace(/z/g, x);
        if (isf[which](x0) !== 0) {
          ans += " - ";
        }
        ans += iss[which].replace(/z/g, x0) + "\\right)\\,";
        ans = ans.replace(/--/, " + ");
      }
      aString = "$$" + ans + "\\pi$$";
      qa = [qString, aString];
      return qa;
    };
    makeSurfaceRevolution = function(){
      var a, i$, to$, i, b, c, x, qString, hi, ans, aString, qa;
      a = new poly(rand(1, 3));
      a.setrand(6);
      for (i$ = 0, to$ = a.rank; i$ <= to$; ++i$) {
        i = i$;
        a[i] = Math.abs(a[i]);
      }
      b = new fpoly(3);
      b.setpoly(a);
      c = new fpoly(4);
      b.integ(c);
      x = rand(1, 4);
      qString = "Find the area of the surface formed when the curve";
      qString += "$$y = " + a.write('x') + "$$";
      qString += "from \\(x = 0\\mbox{ to }x = " + x + "\\) is rotated through \\(2\\pi\\) around the \\(x\\)-axis.";
      hi = c.compute(x);
      ans = new frac(hi.top, hi.bot);
      ans.prod(2);
      aString = "$$" + fcoeff(ans, "\\pi") + "$$";
      qa = [qString, aString];
      return qa;
    };
    if (rand()) {
      qa = makeSolidRevolution();
    } else {
      qa = makeSurfaceRevolution();
    }
    return qa;
  };
  problems.makeMatXforms = makeMatXforms = function(){
    var a, xfms, i$, i, cosines, sines, acosines, asines, f, xft, which, qString, ans, aString, qa;
    a = rand(0, 2);
    xfms = new Array(5);
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      xfms[i] = new fmatrix(2);
    }
    cosines = [new frac(0), new frac(-1), new frac(0)];
    sines = [new frac(1), new frac(0), new frac(-1)];
    acosines = [new frac(0), new frac(1), new frac(0)];
    asines = [new frac(-1), new frac(0), new frac(1)];
    xfms[0].set(cosines[a], asines[a], sines[a], cosines[a]);
    xfms[1].set(cosines[a], sines[a], sines[a], acosines[a]);
    xfms[2].set(1, a + 1, 0, 1);
    xfms[3].set(1, 0, a + 1, 1);
    xfms[4].set(a + 2, 0, 0, a + 2);
    f = new frac(a + 1, 2);
    xft = ["a rotation through \\(" + fcoeff(f, "\\pi") + "\\) anticlockwise about O", "a reflection in the line \\(" + ["y = x", "x = 0", "y = - x"][a] + "\\)", "a shear of element \\(" + (a + 1) + ", x\\) axis invariant", "a shear of element \\(" + (a + 1) + ", y\\) axis invariant", "an enlargement of scale factor \\(" + (a + 1) + "\\)"];
    which = distrand(2, 0, 4);
    qString = "Compute the matrix representing, in 2D, " + xft[which[0]] + " followed by " + xft[which[1]] + ".";
    ans = xfms[which[1]].times(xfms[which[0]]);
    aString = "$$" + ans.write() + "$$";
    qa = [qString, aString];
    return qa;
  };
  /****************************\
  |*  START OF STATS MATERIAL *|
  \****************************/
  problems.makeDiscreteDistn = makeDiscreteDistn = function(){
    var massfn, pd, pn, f, p, parms, dists, x, which, leq, qString, ans, i$, i, aString, qa;
    massfn = [massBin, massPo, massGeo];
    pd = rand(2, 6);
    pn = rand(1, pd - 1);
    f = new frac(pn, pd);
    p = pn / pd;
    parms = [[rand(5, 12), p], [rand(1, 5)], [p]];
    dists = ["{\\rm B}\\left(" + parms[0][0] + ', ' + f.write() + "\\right)", "{\\rm Po}(" + parms[1][0] + ")", "{\\rm Geo}\\left(" + f.write() + "\\right)"];
    x = rand(1, 4);
    which = rand(0, 2);
    leq = rand();
    qString = "The random variable \\(X\\) is distributed as$$" + dists[which] + ".$$ Find \\(\\mathbb{P}(X";
    if (leq) {
      qString += "\\le";
    } else {
      qString += " = ";
    }
    qString += x + ")\\)";
    if (leq) {
      ans = 0;
      for (i$ = 0; i$ <= x; ++i$) {
        i = i$;
        ans += massfn[which](i, parms[which][0], parms[which][1]);
      }
    } else {
      ans = massfn[which](x, parms[which][0], parms[which][1]);
    }
    aString = "$$" + ans.toFixed(6) + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeContinDistn = makeContinDistn = function(){
    var mu, sigma, x, qString, z, index, p, aString, qa;
    tableN.populate();
    mu = rand(0, 4);
    sigma = rand(1, 4);
    x = Math.floor(Math.random() * 3 * sigma * 10) / 10;
    if (rand()) {
      x *= -1;
    }
    x += mu;
    qString = "The random variable \\(X\\) is normally distributed with mean \\(" + mu + "\\) and variance \\(" + Math.pow(sigma, 2) + "\\).";
    qString += "<br />Find \\(\\mathbb{P}(X\\le" + x + ")\\)";
    z = (x - mu) / sigma;
    index = Math.floor(1e3 * Math.abs(z));
    if (index < 0 || index >= tableN.values.length) {
      throw new Error('makeContinDistn: index ' + index + ' out of range\n' + 'x: ' + x);
    }
    p = tableN.values[index];
    if (z < 0) {
      p = 1 - p;
    }
    aString = "$$" + p.toFixed(3) + "$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeHypTest = makeHypTest = function(){
    var makeHypTest1, makeHypTest2, qa;
    makeHypTest1 = function(){
      var mu, sigma, which, n, sl, Sx, qString, xbar, aString, p, critdev, acc, qa;
      mu = new Array(2);
      sigma = new Array(2);
      which = 0;
      n = rand(8, 12);
      sl = pickrand(1, 5, 10);
      if (rand()) {
        mu[1] = mu[0] = rand(-1, 5);
        sigma[1] = sigma[0] = rand(1, 4);
        which = rand(0, 2);
      } else {
        mu = distrand(2, -1, 5);
        sigma[0] = rand(1, 4);
        sigma[1] = rand(1, 4);
        if (rand()) {
          if (mu[0] < mu[1]) {
            which = 2;
          } else {
            which = 1;
          }
        } else {
          which = 0;
        }
      }
      Sx = genN(mu[1] * n, sigma[1] * Math.sqrt(n));
      qString = "In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = " + mu[0] + "\\mbox{, }\\sigma^2 = " + sigma[0] * sigma[0] + "\\). ";
      qString += "The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu" + ['\\ne', '<', '>'][which] + mu[0] + "\\). ";
      qString += "The significance level is \\(" + sl + "\\%\\). ";
      qString += "A sample of size \\(" + n + "\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = " + Sx.toFixed(3) + "\\).<br />";
      qString += "<br />Compute: <ul class=\"exercise\">";
      qString += "<li>\\(\\overline{x}\\)</li>";
      qString += "<li> Is \\({\\rm H}_0\\) accepted?}</li>";
      qString += "</ul>";
      xbar = Sx / n;
      aString = "<ul class=\"exercise\">";
      aString += "<li>\\(\\overline{x} = " + xbar.toFixed(3) + "\\)</li>";
      p = 0;
      if (which) {
        switch (sl) {
        case 1:
          p = 4;
          break;
        case 5:
          p = 2;
          break;
        case 10:
          p = 1;
        }
      } else {
        switch (sl) {
        case 1:
          p = 5;
          break;
        case 5:
          p = 3;
          break;
        case 10:
          p = 2;
        }
      }
      critdev = sigma[0] * tableT.values[tableT.values.length - 1][p] / Math.sqrt(n);
      if (which) {
        aString += "<li>The critical region is $$\\overline{x}";
        if (which === 1) {
          aString += "<" + (mu[0] - critdev).toFixed(3) + "$$<br />";
        } else {
          aString += ">" + (mu[0] + critdev).toFixed(3) + "$$<br />";
        }
      } else {
        aString += "<li>The critical values are $$" + (mu[0] - critdev).toFixed(3) + "\\) and \\(" + (mu[0] + critdev).toFixed(3) + "$$<br />";
      }
      acc = false;
      switch (which) {
      case 0:
        acc = xbar >= mu[0] - critdev && xbar <= mu[0] + critdev;
        break;
      case 1:
        acc = xbar >= mu[0] - critdev;
        break;
      case 2:
        acc = xbar <= mu[0] + critdev;
      }
      if (acc) {
        aString += "\\(\\rm H}_0\\) is accepted.</li>";
      } else {
        aString += "\\(\\rm H}_0\\) is rejected.</li>";
      }
      aString += "</ul>";
      qa = [qString, aString];
      return qa;
    };
    makeHypTest2 = function(){
      var mu, which, n, sl, sigma, Sx, Sxx, i$, to$, i, xi, qString, xbar, aString, SS, p, critdev, acc, qa;
      mu = new Array(2);
      which = 0;
      n = rand(10, 25);
      sl = pickrand(1, 5, 10);
      if (rand()) {
        mu[1] = mu[0] = rand(-1, 5);
        sigma = rand(1, 4);
        which = rand(0, 2);
      } else {
        mu = distrand(2, -1, 5);
        sigma = rand(1, 4);
        if (rand()) {
          if (mu[0] < mu[1]) {
            which = 2;
          } else {
            which = 1;
          }
        } else {
          which = 0;
        }
      }
      Sx = 0;
      Sxx = 0;
      for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
        i = i$;
        xi = genN(mu[1], sigma);
        Sx += xi;
        Sxx += Math.pow(xi, 2);
      }
      qString = "In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = " + mu[0] + "\\). ";
      qString += "The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu" + ['\\ne', '<', '>'][which] + mu[0] + "\\). ";
      qString += "The significance level is \\(" + sl + "\\%\\). ";
      qString += "A sample of size \\(" + n + "\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = " + Sx.toFixed(3) + "\\). ";
      qString += "The sum of squares, \\(\\sum{x^2} = " + Sxx.toFixed(3) + "\\). ";
      qString += "Compute: <ul class=\"exercise\">";
      qString += "<li>\\(\\overline{x}\\)</li>";
      qString += "<li>Compute an estimate, \\(S^2\\), of the variance of \\(X\\)</li>";
      qString += "<li>Is \\({\\rm H}_0\\) accepted?</li>";
      qString += "</ul>";
      xbar = Sx / n;
      aString = "<ul class=\"exercise\">";
      aString = "<li>\\(\\overline{x} = " + xbar.toFixed(3) + "\\)</li>";
      SS = (Sxx - Math.pow(Sx, 2) / n) / (n - 1);
      aString += "<li>\\(S^2 = " + SS.toFixed(3) + "\\). ";
      aString += "Under \\({\\rm H}_0\\), \\({\\frac{\\overline{X}";
      if (mu[0]) {
        if (mu[0] > 0) {
          aString += " - ";
        } else {
          aString += " + ";
        }
        aString += Math.abs(mu[0]);
      }
      aString += "}{" + Math.sqrt(SS / n).toFixed(3) + "}}\\sim t_{" + (n - 1) + "}\\)</li>";
      p = 0;
      if (which) {
        switch (sl) {
        case 1:
          p = 4;
          break;
        case 5:
          p = 2;
          break;
        case 10:
          p = 1;
        }
      } else {
        switch (sl) {
        case 1:
          p = 5;
          break;
        case 5:
          p = 3;
          break;
        case 10:
          p = 2;
        }
      }
      critdev = Math.sqrt(SS) * tableT.values[n - 2][p] / Math.sqrt(n);
      if (which) {
        aString += "<li>The critical region is \\(\\overline{x}";
        if (which === 1) {
          aString += "<" + (mu[0] - critdev).toFixed(3);
        } else {
          aString += ">" + (mu[0] + critdev).toFixed(3);
        }
        aString += "\\) </br/>";
      } else {
        aString += "<li>The critical values are \\(" + (mu[0] - critdev).toFixed(3) + "\\) and \\(" + (mu[0] + critdev).toFixed(3) + "\\) <br />";
      }
      acc = false;
      switch (which) {
      case 0:
        acc = xbar >= mu[0] - critdev && xbar <= mu[0] + critdev;
        break;
      case 1:
        acc = xbar >= mu[0] - critdev;
        break;
      case 2:
        acc = xbar <= mu[0] + critdev;
      }
      if (acc) {
        aString += "\\({\\rm H}_0\\) is accepted.</li>";
      } else {
        aString += "\\({\\rm H}_0\\) is rejected.</li>";
      }
      aString += "</ul>";
      qa = [qString, aString];
      return qa;
    };
    if (rand()) {
      qa = makeHypTest1();
    } else {
      qa = makeHypTest2();
    }
    return qa;
  };
  problems.makeConfidInt = makeConfidInt = function(){
    var mu, sigma, n, sl, Sx, Sxx, i$, to$, i, xi, qString, xbar, SS, p, critdev, aString, qa;
    mu = rand(4);
    sigma = rand(1, 4);
    n = 2 * rand(6, 10);
    sl = pickrand(99, 95, 90);
    Sx = 0;
    Sxx = 0;
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      xi = genN(mu, sigma);
      Sx += xi;
      Sxx += xi * xi;
    }
    qString = "The random variable \\(X\\) has a normal distribution with unknown parameters. ";
    qString += "A sample of size \\(" + n + "\\) is taken for which $$\\sum{x} = " + Sx.toFixed(3) + "$$$$\\mbox{and}\\sum{x^2} = " + Sxx.toFixed(3) + ".$$";
    qString += "Compute, to 3 DP., a \\(" + sl + "\\)% confidence interval for the mean of \\(X\\).<br />";
    xbar = Sx / n;
    SS = (Sxx - Sx * Sx / n) / (n - 1);
    switch (sl) {
    case 99:
      p = 5;
      break;
    case 95:
      p = 3;
      break;
    case 90:
      p = 2;
    }
    critdev = Math.sqrt(SS / n) * tableT.values[n - 2][p];
    aString = "$$[" + (xbar - critdev).toFixed(3) + ", " + (xbar + critdev).toFixed(3) + "]$$";
    qa = [qString, aString];
    return qa;
  };
  problems.makeChiSquare = makeChiSquare = function(){
    var parms, distns, parmnames, nparms, massfn, genfn, which, n, sl, qString, sample, min, max, i$, to$, i, freq, y, Sx, Sxx, x, p, xbar, SS, hypparms, aString, qa, nrows, row, zh, zl, ph, pl, j1, j2, j$, j, row2, chisq, currow, crow, nu, critval;
    tableN.populate();
    parms = [[rand(10, 18) * 2, rand(20, 80) / 100], [rand(4, 12)], [rand(10, 30) / 100], [rand(4, 10), rand(2, 4)]];
    distns = ["binomial", "Poisson", "geometric", "normal"];
    parmnames = [["n", "p"], ["\\lambda"], ["p"], ["\\mu", "\\sigma"]];
    nparms = [2, 1, 1, 2];
    massfn = [massBin, massPo, massGeo, massN];
    genfn = [genBin, genPo, genGeo, genN];
    which = rand(0, 3);
    n = 5 * rand(10, 15);
    sl = pickrand(90, 95, 99);
    qString = "The random variable \\(X\\) is modelled by a <i>" + distns[which] + "</i> distribution. ";
    qString += "A sample of size \\(" + n + "\\) is drawn from \\(X\\) with the following grouped frequency data. ";
    sample = [];
    min = 1e3;
    max = 0;
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      sample[i] = genfn[which](parms[which][0], parms[which][1]);
      min = Math.min(min, sample[i]);
      max = Math.max(max, sample[i]);
    }
    min = Math.floor(min);
    max = Math.ceil(max);
    freq = [];
    for (i$ = 0, to$ = Math.ceil((max + 1 - min) / 2) - 1; i$ <= to$; ++i$) {
      i = i$;
      freq[i] = 0;
    }
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      y = Math.floor((sample[i] - min) / 2);
      freq[y]++;
    }
    qString += "<div style=\"font-size: 80%;\">$$\\begin{array}{c|r}x&\\mbox{Frequency}\\\\";
    Sx = 0;
    Sxx = 0;
    for (i$ = 0, to$ = Math.ceil((max + 1 - min) / 2) - 1; i$ <= to$; ++i$) {
      i = i$;
      x = min + i * 2;
      Sx += (x + 1) * freq[i];
      Sxx += (x + 1) * (x + 1) * freq[i];
      if (i === 0) {
        qString += "x < " + (x + 2);
      } else if (i === Math.ceil((max - 1 - min) / 2)) {
        qString += x + "\\le x";
      } else {
        qString += x + "\\le x <" + (x + 2);
      }
      qString += "&" + freq[i] + "\\\\";
    }
    qString += "\\end{array}$$</div>";
    qString += "<ul class=\"exercise\">";
    qString += "<li>Estimate the parameters of the distribution.</li>";
    qString += "<li>Use a \\(\\chi^2\\) test, with a significance level of \\(" + sl + "\\)%, to test this hypothesis.</li>";
    qString += "</ul>";
    switch (sl) {
    case 90:
      p = 3;
      break;
    case 95:
      p = 4;
      break;
    case 99:
      p = 6;
    }
    xbar = Sx / n;
    SS = (Sxx - Math.pow(Sx, 2) / n) / (n - 1);
    hypparms = [0, 0];
    aString = "<ol class=\"exercise\">";
    switch (which) {
    case 0:
      hypparms[1] = 1 - SS / xbar;
      hypparms[0] = Math.round(xbar / hypparms[1]);
      break;
    case 1:
      hypparms[0] = xbar;
      break;
    case 2:
      hypparms[0] = 1 / xbar;
      break;
    case 3:
      hypparms[0] = xbar;
      hypparms[1] = Math.sqrt(SS);
    }
    if (which === 0) {
      aString += "<li>$$" + parmnames[which][0] + " = " + hypparms[0].toString() + ", " + parmnames[which][1] + " = " + hypparms[1].toFixed(3) + ".$$</li>";
      if (hypparms[0] < 1) {
        aString += "</ol>";
        aString += "<p>The binomial model cannot fit these data</p>";
        qa = [qString, aString];
        return qa;
      }
    } else {
      aString += "<li>$$" + parmnames[which][0] + " = " + hypparms[0].toFixed(3);
      if (nparms[which] === 2) {
        aString += ", " + parmnames[which][1] + " = " + hypparms[1].toFixed(3);
      }
      aString += ".$$</li>";
    }
    aString += "<li></li></ol>";
    nrows = Math.ceil((max + 1 - min) / 2);
    row = [];
    for (i$ = 0, to$ = nrows - 1; i$ <= to$; ++i$) {
      i = i$;
      x = min + i * 2;
      row[i] = [x, x + 2, freq[i], 0, 0];
      if (which === 3) {
        zh = (x + 2 - hypparms[0]) / hypparms[1];
        zl = (x - hypparms[0]) / hypparms[1];
        if (Math.abs(zh) < 3) {
          if (zh >= 0) {
            ph = tableN.values[Math.floor(zh * 1000)];
          } else {
            ph = 1 - tableN.values[Math.floor(-zh * 1000)];
          }
        } else {
          if (zh > 0) {
            ph = 1;
          } else {
            ph = 0;
          }
        }
        if (Math.abs(zl) < 3) {
          if (zl >= 0) {
            ph = tableN.values[Math.floor(zl * 1000)];
          } else {
            pl = 1 - tableN.values[Math.floor(-zl * 1000)];
          }
        } else {
          if (zl > 0) {
            pl = 1;
          } else {
            pl = 0;
          }
        }
        if (i === 0) {
          pl = 0;
        }
        if (i === nrows - 1) {
          ph = 1;
        }
        row[i][3] = (ph - pl) * n;
      } else {
        if (i === 0) {
          j1 = 0;
        } else {
          j1 = x;
        }
        if (i === nrows - 1) {
          j2 = x + 99;
        } else {
          j2 = x + 1;
        }
        for (j$ = j1; j$ <= j2; ++j$) {
          j = j$;
          row[i][3] += massfn[which](j, hypparms[0], hypparms[1]) * n;
        }
      }
    }
    row2 = [];
    chisq = 0;
    currow = [0, 0, 0, 0, 0];
    for (i$ = 0, to$ = nrows - 1; i$ <= to$; ++i$) {
      i = i$;
      currow[1] = row[i][1];
      currow[2] += row[i][2];
      currow[3] += row[i][3];
      if (currow[3] >= 5) {
        currow[4] = Math.pow(currow[2] - currow[3], 2) / currow[3];
        row2.push(currow);
        chisq += currow[4];
        currow = [currow[1], currow[1], 0, 0, 0];
      }
    }
    if (row2.length) {
      crow = row2.pop();
    } else {
      crow = [0, 0, 0, 0, 0];
    }
    crow[1] = currow[1];
    crow[2] += currow[2];
    crow[3] += currow[3];
    chisq -= crow[4];
    crow[4] = Math.pow(crow[2] - crow[3], 2) / crow[3];
    row2.push(crow);
    chisq += crow[4];
    aString += "<div style=\"font-size: 80%;\">$$\\begin{array}{c||r|r|r}";
    aString += "x&O_i&E_i&\\frac{(O_i - E_i)^2}{E_i}\\\\";
    for (i$ = 0, to$ = row2.length - 1; i$ <= to$; ++i$) {
      i = i$;
      if (i === 0) {
        aString += "x < " + row2[i][1];
      } else if (i === row2.length - 1) {
        aString += row2[i][0] + "\\le x";
      } else {
        aString += row2[i][0] + "\\le x <" + row2[i][1];
      }
      aString += "&" + row2[i][2] + "&" + row2[i][3].toFixed(3) + "&" + row2[i][4].toFixed(3) + "\\\\";
    }
    aString += "\\end{array}$$</div>";
    aString += "$$\\chi^2 = " + chisq.toFixed(3) + "$$";
    nu = row2.length - 1 - nparms[which];
    aString += "$$\\nu = " + nu + "$$";
    if (nu < 1) {
      throw new Error("makeChiSquare: nu < 1!" + "\n\twhich:" + which + "\n\trow2.length:" + row2.length);
    }
    critval = tableChi.values[nu - 1][p];
    aString += "Critical region: \\(\\chi^2 >" + critval + "\\)<br />";
    if (chisq > critval) {
      aString += "The hypothesis is rejected.";
    } else {
      aString += "The hypothesis is accepted.";
    }
    qa = [qString, aString];
    return qa;
  };
  problems.makeProductMoment = makeProductMoment = function(){
    var n, mu, sigma, x, i$, to$, i, Ex, Exx, Exy, Eyy, Ey, qString, xbar, ybar, Sxx, Syy, Sxy, r, b, a, aString, qa;
    n = rand(6, 12);
    mu = [rand(4), rand(4)];
    sigma = [rand(1, 6), rand(1, 6)];
    x = [];
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      x[i] = [];
      x[i][0] = genN(mu[0], sigma[0]);
      x[i][1] = genN(mu[1], sigma[1]);
    }
    Ex = 0;
    Exx = 0;
    Exy = 0;
    Eyy = 0;
    Ey = 0;
    qString = "For the following data,";
    qString += "<ul class=\"exercise\">";
    qString += "<li>compute the product moment correlation coefficient, \\({\\bf r}\\)</li>";
    qString += "<li>find the regression line of \\(y\\) on \\(x\\)$$\\begin{array}{c|c}x&y\\\\";
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      qString += x[i][0].toFixed(3) + "&" + x[i][1].toFixed(3) + "\\\\";
      Ex += x[i][0];
      Exx += x[i][0] * x[i][0];
      Exy += x[i][0] * x[i][1];
      Eyy += x[i][1] * x[i][1];
      Ey += x[i][1];
    }
    qString += "\\end{array}$$</li></ul>";
    xbar = Ex / n;
    ybar = Ey / n;
    Sxx = Exx - Ex * xbar;
    Syy = Eyy - Ey * ybar;
    Sxy = Exy - Ex * Ey / n;
    r = Sxy / Math.sqrt(Sxx * Syy);
    b = Sxy / Sxx;
    a = ybar - b * xbar;
    aString = "<ul class=\"exercise\">";
    aString += "<li>\\({\\bf r} = " + r.toFixed(3) + "\\)</li><li>\\(y = " + b.toFixed(3) + "x";
    if (a > 0) {
      aString += " + ";
    }
    aString += a.toFixed(3) + "\\).";
    qa = [qString, aString];
    return qa;
  };
  return problems;
};
function deepEq$(x, y, type){
  var toString = {}.toString, hasOwnProperty = {}.hasOwnProperty,
      has = function (obj, key) { return hasOwnProperty.call(obj, key); };
  var first = true;
  return eq(x, y, []);
  function eq(a, b, stack) {
    var className, length, size, result, alength, blength, r, key, ref, sizeB;
    if (a == null || b == null) { return a === b; }
    if (a.__placeholder__ || b.__placeholder__) { return true; }
    if (a === b) { return a !== 0 || 1 / a == 1 / b; }
    className = toString.call(a);
    if (toString.call(b) != className) { return false; }
    switch (className) {
      case '[object String]': return a == String(b);
      case '[object Number]':
        return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
      case '[object Date]':
      case '[object Boolean]':
        return +a == +b;
      case '[object RegExp]':
        return a.source == b.source &&
               a.global == b.global &&
               a.multiline == b.multiline &&
               a.ignoreCase == b.ignoreCase;
    }
    if (typeof a != 'object' || typeof b != 'object') { return false; }
    length = stack.length;
    while (length--) { if (stack[length] == a) { return true; } }
    stack.push(a);
    size = 0;
    result = true;
    if (className == '[object Array]') {
      alength = a.length;
      blength = b.length;
      if (first) { 
        switch (type) {
        case '===': result = alength === blength; break;
        case '<==': result = alength <= blength; break;
        case '<<=': result = alength < blength; break;
        }
        size = alength;
        first = false;
      } else {
        result = alength === blength;
        size = alength;
      }
      if (result) {
        while (size--) {
          if (!(result = size in a == size in b && eq(a[size], b[size], stack))){ break; }
        }
      }
    } else {
      if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) {
        return false;
      }
      for (key in a) {
        if (has(a, key)) {
          size++;
          if (!(result = has(b, key) && eq(a[key], b[key], stack))) { break; }
        }
      }
      if (result) {
        sizeB = 0;
        for (key in b) {
          if (has(b, key)) { ++sizeB; }
        }
        if (first) {
          if (type === '<<=') {
            result = size < sizeB;
          } else if (type === '<==') {
            result = size <= sizeB
          } else {
            result = size === sizeB;
          }
        } else {
          first = false;
          result = size === sizeB;
        }
      }
    }
    stack.pop();
    return result;
  }
}
},{"./complex":3,"./fpolys":5,"./fractions":6,"./geometry":7,"./guessExact":8,"./helpers":9,"./polys":10,"./stats":14}],"qalib":[function(require,module,exports){
module.exports=require('gH93sY');
},{}],"gH93sY":[function(require,module,exports){
module.exports = function(qalib){
  require('seedrandom');
  require('./helpers')(qalib);
  require('./config')(qalib);
  return qalib;
};
},{"./config":4,"./helpers":9,"seedrandom":"HU2YCy"}],14:[function(require,module,exports){
module.exports = function(stats){
  var facCache, factorial, combi, massBin, massPo, massGeo, massN, massNZ, massExp, genBern, genBin, genPo, genGeo, genExp, genN, genNZ, Phi_Taylor, istr, mktableT, tableT, mktableChi, tableChi, mktableN, tableN;
  facCache = [];
  stats.factorial = factorial = function(n){
    var f, i;
    if (n < 0 || n !== Math.round(n)) {
      throw new Error("bad factorial(" + n + ")");
    }
    return facCache[n] || (n < 2
      ? 1
      : (f = 1, (function(){
        var i$, to$, results$ = [];
        for (i$ = 2, to$ = n; i$ <= to$; ++i$) {
          i = i$;
          results$.push(f = f * i);
        }
        return results$;
      }()), facCache[n] = f));
  };
  stats.combi = combi = function(n, r){
    return factorial(n) / (factorial(r) * factorial(n - r));
  };
  stats.massBin = massBin = function(x, n, p){
    if (x !== Math.round(x) || x < 0 || x > n) {
      return 0;
    } else {
      return combi(n, x) * Math.pow(p, x) * Math.pow(1 - p, n - x);
    }
  };
  stats.massPo = massPo = function(x, l){
    if (x !== Math.round(x) || x < 0) {
      return 0;
    } else {
      return Math.exp(-l) * Math.pow(l, x) / factorial(x);
    }
  };
  stats.massGeo = massGeo = function(x, p){
    if (x !== Math.round(x) || x < 1) {
      return 0;
    } else {
      return p * Math.pow(1 - p, x - 1);
    }
  };
  stats.massN = massN = function(x, m, s){
    return Math.exp(-Math.pow((x - m) / s, 2) / 2) / (s * Math.sqrt(2 * Math.PI));
  };
  stats.massNZ = massNZ = function(x){
    return Math.exp(-Math.pow(x, 2) / 2) / Math.sqrt(2 * Math.PI);
  };
  stats.massExp = massExp = function(x, l){
    return l * Math.exp(-l * x);
  };
  stats.genBern = genBern = function(p){
    if (Math.random() > p) {
      return 1;
    } else {
      return 0;
    }
  };
  stats.genBin = genBin = function(n, p){
    var x, i$, to$, i;
    x = 0;
    for (i$ = 0, to$ = n - 1; i$ <= to$; ++i$) {
      i = i$;
      x += genBern(p);
    }
    return x;
  };
  stats.genPo = genPo = function(l){
    var t, k, p;
    t = Math.exp(-l);
    k = -1;
    p = 1;
    do {
      k++;
      p *= Math.random();
    } while (p > t);
    return k;
  };
  stats.genGeo = genGeo = function(p){
    var l, x;
    l = -Math.log(1 - p);
    x = genExp(l);
    return 1 + Math.floor(x);
  };
  stats.genExp = genExp = function(l){
    return -Math.log(Math.random()) / l;
  };
  stats.genN = genN = function(m, s){
    return m + s * genNZ()[0];
  };
  stats.genNZ = genNZ = function(){
    var u, v, r, th, x, y;
    u = 1 - Math.random();
    v = 1 - Math.random();
    r = Math.sqrt(-2 * Math.log(u));
    th = 2 * Math.PI * v;
    x = r * Math.cos(th);
    y = r * Math.sin(th);
    return [x, y];
  };
  stats.Phi_Taylor = Phi_Taylor = function(x){
    return 0.5 + x * 0.398942 + Math.pow(x, 3) / 6 * -0.398942 + Math.pow(x, 5) / 120 * 1.19683 + Math.pow(x, 7) / 5040 * -5.98413 + Math.pow(x, 9) / 362880 * 41.8889;
  };
  istr = function(x){
    if (x % 3 === 1) {
      return "<strong>";
    } else {
      return "";
    }
  };
  mktableT = (function(){
    mktableT.displayName = 'mktableT';
    var prototype = mktableT.prototype, constructor = mktableT;
    function mktableT(){
      this.p = [0.75, 0.9, 0.95, 0.975, 0.99, 0.995, 0.9975, 0.999, 0.9995];
      this.v = ["&nu;=1", 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 40, 60, 120, "&infin;"];
      this.values = [['1.000', 3.078, 6.314, 12.71, 31.82, 63.66, 127.3, 318.3, 636.6], [0.816, 1.886, 2.920, 4.303, 6.965, 9.925, 14.09, 22.33, 31.60], [0.765, 1.638, 2.353, 3.182, 4.541, 5.841, 7.453, 10.21, 12.92], [0.741, 1.533, 2.132, 2.776, 3.747, 4.604, 5.598, 7.173, 8.610], [0.727, 1.476, 2.015, 2.571, 3.365, 4.032, 4.773, 5.894, 6.869], [0.718, 1.440, 1.943, 2.447, 3.143, 3.707, 4.317, 5.208, 5.959], [0.711, 1.415, 1.895, 2.365, 2.998, 3.499, 4.029, 4.785, 5.408], [0.706, 1.397, 1.860, 2.306, 2.896, 3.355, 3.833, 4.501, 5.041], [0.703, 1.383, 1.833, 2.262, 2.821, 3.250, 3.690, 4.297, 4.781], [0.700, 1.372, 1.812, 2.228, 2.764, 3.169, 3.581, 4.144, 4.587], [0.697, 1.363, 1.796, 2.201, 2.718, 3.106, 3.497, 4.025, 4.437], [0.695, 1.356, 1.782, 2.179, 2.681, 3.055, 3.428, 3.930, 4.318], [0.694, 1.350, 1.771, 2.160, 2.650, 3.012, 3.372, 3.852, 4.221], [0.692, 1.345, 1.761, 2.145, 2.624, 2.977, 3.326, 3.787, 4.140], [0.691, 1.341, 1.753, 2.131, 2.602, 2.947, 3.286, 3.733, 4.073], [0.690, 1.337, 1.746, 2.120, 2.583, 2.921, 3.252, 3.686, 4.015], [0.689, 1.333, 1.740, 2.110, 2.567, 2.898, 3.222, 3.646, 3.965], [0.688, 1.330, 1.734, 2.101, 2.552, 2.878, 3.197, 3.610, 3.922], [0.688, 1.328, 1.729, 2.093, 2.539, 2.861, 3.174, 3.579, 3.883], [0.687, 1.325, 1.725, 2.086, 2.528, 2.845, 3.153, 3.552, 3.850], [0.686, 1.323, 1.721, 2.080, 2.518, 2.831, 3.135, 3.527, 3.819], [0.686, 1.321, 1.717, 2.074, 2.508, 2.819, 3.119, 3.505, 3.792], [0.685, 1.319, 1.714, 2.069, 2.500, 2.807, 3.104, 3.485, 3.768], [0.685, 1.318, 1.711, 2.064, 2.492, 2.797, 3.091, 3.467, 3.745], [0.684, 1.316, 1.708, 2.060, 2.485, 2.787, 3.078, 3.450, 3.725], [0.684, 1.315, 1.706, 2.056, 2.479, 2.779, 3.067, 3.435, 3.707], [0.684, 1.314, 1.703, 2.052, 2.473, 2.771, 3.057, 3.421, 3.689], [0.683, 1.313, 1.701, 2.048, 2.467, 2.763, 3.047, 3.408, 3.674], [0.683, 1.311, 1.699, 2.045, 2.462, 2.756, 3.038, 3.396, 3.660], [0.683, 1.310, 1.697, 2.042, 2.457, 2.750, 3.030, 3.385, 3.646], [0.681, 1.303, 1.684, 2.021, 2.423, 2.704, 2.971, 3.307, 3.551], [0.679, 1.296, 1.671, '2.000', 2.390, 2.660, 2.915, 3.232, 3.460], [0.677, 1.289, 1.658, 1.980, 2.358, 2.617, 2.860, 3.160, 3.373], [0.674, 1.282, 1.645, 1.960, 2.326, 2.576, 2.807, 3.090, 3.291]];
    }
    prototype.writehtml = function(open, close){
      var a, i$, i, j$, j;
      a = "<table border=1 cellpadding=0>";
      a += "<tr><td>" + open + "p" + close + "</td>";
      for (i$ = 0; i$ <= 8; ++i$) {
        i = i$;
        a += "<td>" + open + istr(i) + this.p[i] + istr(i) + close + "</td>";
      }
      a += "</tr><tr><td>" + open + "<font color=\"white\">0.0-</font>" + close + "</td>";
      for (i$ = 0; i$ <= 8; ++i$) {
        i = i$;
        a += "<td>" + open + "<font color=\"white\">0.0000-</font>" + close + "</td>";
      }
      a += "</tr>";
      for (i$ = 1; i$ <= 34; ++i$) {
        i = i$;
        if (i && i % 5 === 0) {
          a += "<tr><td></td></tr>";
        }
        for (j$ = 0; j$ <= 8; ++j$) {
          j = j$;
          a += "<td>" + open + istr(j) + this.values[i - 1][j].toString().rPad(5, "0") + istr(j) + close + "</td>";
        }
        a += "</tr>";
      }
      a += "</table>";
      return a.replace(/&gt;/g, ">").replace(/&lt;/g, "<");
    };
    return mktableT;
  }());
  stats.tableT = tableT = new mktableT();
  mktableChi = (function(){
    mktableChi.displayName = 'mktableChi';
    var prototype = mktableChi.prototype, constructor = mktableChi;
    function mktableChi(){
      this.p = [0.01, 0.025, 0.05, 0.9, 0.95, 0.975, 0.99, 0.995, 0.999];
      this.v = ["&nu;=1", 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 30, 40, 50, 60, 70, 80, 90, 100];
      this.values = [['0.0&sup3;1571', '0.0&sup3;9821', '0.0&sup2;3932', 2.706, 3.841, 5.024, 6.635, 7.8794, 10.83], [0.02010, 0.05064, 0.1026, 4.605, 5.991, 7.378, 9.210, 10.60, 13.82], [0.1148, 0.2158, 0.3518, 6.251, 7.815, 9.348, 11.34, 12.84, 16.27], [0.2971, 0.4844, 0.7107, 7.779, 9.488, 11.14, 13.28, 14.86, 18.47], [0.5543, 0.8312, 1.145, 9.236, 11.07, 12.83, 15.09, 16.75, 20.51], [0.8721, 1.237, 1.635, 10.64, 12.59, 14.45, 16.81, 18.55, 22.46], [1.239, 1.690, 2.167, 12.02, 14.07, 16.01, 18.48, 20.28, 24.32], [1.647, 2.180, 2.733, 13.36, 15.51, 17.53, 20.09, 21.95, 26.12], [2.088, 2.700, 3.325, 14.68, 16.92, 19.02, 21.67, 23.59, 27.88], [2.558, 3.247, 3.940, 15.99, 18.31, 20.48, 23.21, 25.19, 29.59], [3.053, 3.816, 4.575, 17.28, 19.68, 21.92, 24.73, 26.76, 31.26], [3.571, 4.404, 5.226, 18.55, 21.03, 23.34, 26.22, 28.30, 32.91], [4.107, 5.009, 5.892, 19.81, 22.36, 24.74, 27.69, 29.82, 34.53], [4.660, 5.629, 6.571, 21.06, 23.68, 26.12, 29.14, 31.32, 36.12], [5.229, 6.262, 7.261, 22.31, '25.00', 27.49, 30.58, 32.80, 37.70], [5.812, 6.908, 7.962, 23.54, 26.30, 28.85, '32.00', 34.27, 39.25], [6.408, 7.564, 8.672, 24.77, 27.59, 30.19, 33.41, 35.72, 40.79], [7.015, 8.231, 9.390, 25.99, 28.87, 31.53, 34.81, 37.16, 42.31], [7.633, 8.907, 10.12, 27.20, 30.14, 32.85, 36.19, 38.58, 43.82], [8.260, 9.591, 10.85, 28.41, 31.41, 34.17, 37.57, '40.00', 45.31], [8.897, 10.28, 11.59, 29.62, 32.67, 35.48, 38.93, 41.40, 46.80], [9.542, 10.98, 12.34, 30.81, 33.92, 36.78, 40.29, 42.80, 48.27], [10.20, 11.69, 13.09, 32.01, 35.17, 38.08, 41.64, 44.18, 49.73], [10.86, 12.40, 13.85, 33.20, 36.42, 39.36, 42.98, 45.56, 51.18], [11.52, 13.12, 14.61, 34.38, 37.65, 40.65, 44.31, 46.93, 52.62], [14.95, 16.79, 18.49, 40.26, 43.77, 46.98, 50.89, 53.67, 59.70], [22.16, 24.43, 26.51, 51.81, 55.76, 59.34, 63.69, 66.77, 73.40], [29.71, 32.36, 34.76, 63.17, 67.50, 71.42, 76.15, 79.49, 86.66], [37.48, 40.48, 43.19, 74.40, 79.08, 83.30, 88.38, 91.95, 99.61], [45.44, 48.76, 51.74, 85.53, 90.53, 95.02, 100.4, 104.2, 112.3], [53.54, 57.15, 60.39, 96.58, 101.9, 106.6, 112.3, 116.3, 124.8], [61.75, 65.65, 69.13, 107.6, 113.1, 118.1, 124.1, 128.3, 137.2], [70.06, 74.22, 77.93, 118.5, 124.3, 129.6, 135.8, 140.2, 149.4]];
    }
    prototype.writehtml = function(open, close){
      var a, i$, i, j$, j;
      a = "<table border=1 cellpadding=0>";
      a += "<tr><td>" + open + "p" + close + "</td><td></td>";
      for (i$ = 0; i$ <= 8; ++i$) {
        i = i$;
        a += "<td>" + open + istr(i) + this.p[i] + istr(i) + close + "</td>";
        if (i === 2) {
          a += "<td></td>";
        }
      }
      a += "</tr><tr><td>" + open + "<font color=\"white\">0.0-</font>" + close + "</td><td width=3></td>";
      for (i$ = 0; i$ <= 8; ++i$) {
        i = i$;
        a += "<td>" + open + "<font color=\"white\">0.0000-</font>" + close + "</td>";
        if (i === 2) {
          a += "<td width=3></td>";
        }
      }
      a += "</tr>";
      for (i$ = 1; i$ <= 33; ++i$) {
        i = i$;
        if (i && i % 5 === 0) {
          a += "<tr><td></td></tr>";
        }
        for (j$ = 0; j$ <= 8; ++j$) {
          j = j$;
          a += "<td>" + open + istr(j) + this.values[i - 1][j].toString().rPad(5, "0") + istr(j) + close + "</td>";
          if (j === 2) {
            a += "<td></td>";
          }
        }
        a += "</tr>";
      }
      a += "</table>";
      return a.replace(/&gt;/g, ">").replace(/&lt;/g, "<");
    };
    return mktableChi;
  }());
  stats.tableChi = tableChi = new mktableChi();
  mktableN = (function(){
    mktableN.displayName = 'mktableN';
    var jstr, prototype = mktableN.prototype, constructor = mktableN;
    function mktableN(){
      this.values = new Array(3000);
      this.table = new Array(300);
      this.charac = new Array(300);
      this.ready = false;
    }
    prototype.populate = function(){
      var p, i$, i;
      if (!this.ready) {
        p = 0.5;
        for (i$ = 0; i$ <= 299; ++i$) {
          i = i$;
          this.charac[i] = 0;
        }
        for (i$ = 0; i$ <= 2999; ++i$) {
          i = i$;
          this.values[i] = p;
          if (i % 10 === 0) {
            this.table[i / 10] = this.values[i];
          } else {
            this.charac[10 * Math.floor(i / 100) + i % 10] += this.values[i] - this.table[Math.floor(i / 10)];
          }
          p += 0.001 * massNZ((i + 0.5) * 0.001);
        }
        return this.ready = true;
      }
    };
    prototype.write = function(){
      var a, i$, i, j$, j;
      if (!this.ready) {
        throw new Error("Table not populated!");
      }
      a = "\\begin{array}{c}|&-&|&-&-&-&-&-&-&-&-&-&-&-&-&-&|&-&-&-&&-&-&-&&-&-&-&|\\\\";
      a += "|&z&|&0&&1&2&3&&4&5&6&&7&8&9&|&1&2&3&&4&5&6&&7&8&9&|\\\\";
      a += "|&&|&&&&&&&&&&&&&&|&&&&&A&D&D&&&&&|\\\\";
      a += "|&-&|&-&-&-&-&-&-&-&-&-&-&-&-&-&|&-&-&-&&-&-&-&&-&-&-&|\\\\";
      for (i$ = 0; i$ <= 29; ++i$) {
        i = i$;
        if (i && i % 5 === 0) {
          a += "|&&|&&&&&&&&&&&&&&|&&&&&&&&&&&&|\\\\";
        }
        a += "|&" + i / 10 + "&|&";
        for (j$ = 0; j$ <= 9; ++j$) {
          j = j$;
          a += (Math.round(this.table[i * 10 + j] * 1e4) / 1e4).toString().rPad(6, "0") + "&";
          if (j % 3 === 0) {
            a += "|&";
          }
        }
        for (j$ = 1; j$ <= 9; ++j$) {
          j = j$;
          a += Math.round(this.charac[i * 10 + j] * 1e3) + "&";
          if (j % 3 === 0) {
            a += "|&";
          }
        }
        a += "\\\\";
      }
      a += "|&-&|&-&-&-&-&-&-&-&-&-&-&-&-&-&|&-&-&-&&-&-&-&&-&-&-&|\\\\";
      a += "\\end{array}";
      return a;
    };
    jstr = function(x, n){
      if (x % n !== 0) {
        return "<strong>";
      } else {
        return "";
      }
    };
    prototype.writehtml = function(open, close){
      var a, i$, i, j$, j;
      if (!this.ready) {
        throw new Error("Table not populated!");
      }
      a = "<table border=1 cellpadding=0 cellspacing=0>";
      a += "<tr><td>" + open + "z" + close + "</td><td width=3></td>";
      for (i$ = 0; i$ <= 9; ++i$) {
        i = i$;
        a += "<td>" + jstr(i, 3) + open + i + jstr(i, 3) + close + "</td>";
      }
      a += "<td width=5></td>";
      for (i$ = 1; i$ <= 9; ++i$) {
        i = i$;
        a += "<td>" + jstr(i, 2) + open + i + jstr(i, 2) + close + "</td>";
      }
      a += "</tr><tr><td>" + open + "<font color=\"white\"0.0-</font>" + close + "</td><td></td>";
      for (i$ = 0; i$ <= 9; ++i$) {
        i = i$;
        a += "<td>" + open + "<font color=\"white\">0.0000-</font>" + close + "</td>";
      }
      a += "<td></td>";
      for (i$ = 1; i$ <= 9; ++i$) {
        i = i$;
        a += "<td>" + open + "<font color=\"";
        if (i === 5) {
          a += "black";
        } else {
          a += "white";
        }
        a += "\">ADD</font>" + close + "</td>";
      }
      a += "</tr>";
      for (i$ = 0; i$ <= 29; ++i$) {
        i = i$;
        if (i && i % 5 === 0) {
          a += "<tr height=5><td></td></tr>";
        }
        a += "<tr><td>" + open + Math.floor(i / 10) + "." + i % 10 + close + "</td><td></td>";
        for (j$ = 0; j$ <= 9; ++j$) {
          j = j$;
          if (j % 3 === 0) {
            a += "<td>" + open + jstr(j, 3) + (Math.round(this.table[i * 10 + j] * 1e4) / 1e4).toString().rPad(6, "0") + jstr(j, 3) + close + "</td>";
          }
        }
        a += "<td></td>";
        for (j$ = 1; j$ <= 9; ++j$) {
          j = j$;
          a += "<td>" + open + jstr(j, 2) + Math.round(this.charac[i * 10 + j] * 1e3) + jstr(j, 2) + close + "</td>";
        }
        a += "</tr>";
      }
      a += "</table>";
      return a.replace(/&gt;/, ">").replace(/&lt;/g, "<");
    };
    return mktableN;
  }());
  stats.tableN = tableN = new mktableN();
  return stats;
};
String.prototype.lPad = function(n, c){
  var a, i$, to$, i;
  a = this.split("");
  for (i$ = 0, to$ = n - this.length - 1; i$ <= to$; ++i$) {
    i = i$;
    a.unshift(c);
  }
  return a.join("");
};
String.prototype.rPad = function(n, c){
  var a, i$, to$, i;
  a = this.split("");
  for (i$ = 0, to$ = n - this.length - 1; i$ <= to$; ++i$) {
    i = i$;
    a.push(c);
  }
  return a.join("");
};
},{}]},{},["gH93sY"])
;
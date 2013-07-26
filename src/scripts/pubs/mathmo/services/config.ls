/*
 * mathmo question/answer configuration
 */
angular.module('app').factory 'config', ->

  topicById: (id) -> @topics[id]
  topicTitleById: (id) -> @topics[id][0]
  topicMakerById: (id) -> @topics[id][1]

  groups:
    * title: "Algebraic"
      topicIds:
        * "C11"
          "C7"
          "C9"
          "C1"
          "C30"
          "C13"
          "C17"

    * title: "Curve sketching"
      topicIds:
        * "C24"
          "C25"
          "C26"
          "C270"
          "C27"

    * title: "Geometry"
      topicIds:
        * "C15"
          "C16"
          "C6"
          "C31"
          "C32"
          "C33"
          "C34"

    * title: "Sequences & series"
      topicIds:
        * "C8"
          "C12"
          "C23"
          "C2"

    * title: "Vectors"
      topicIds:
        * "C5"
          "C18"

    * title: "Differentiation"
      topicIds:
        * "C14"
          "C20"
          "C21"
          "C22"
          "C19"

    * title: "Integration"
      topicIds:
        * "C28"
          "C3"
          "C4"

    * title: "Differential equations"
      topicIds:
        * "C29"
        * "F3a"
        ...

    * title: "Further Topics"
      topicIds:
        * "F1"
          "F2"
          #"F3"
          "F4"
          "F5"
          # "F6"
          "F7"
          "F8"
          "F9"
          "F10"
          "F11"
          "F12"
          "F13"

    * title: "Statistics Topics"
      topicIds:
        * "S1"
          "S2"
          "S3"
          "S4"
          "S5"
          "S6"

  topics:
      "C1":
        * "Partial fractions"
          makePartial
      "C2":
        * "Binomial theorem"
          makeBinomial2
      "C3":
        * "Polynomial integration"
          makePolyInt
      "C4":
        * "Trig integration"
          makeTrigInt
      "C5":
        * "Scalar products"
          makeVector
      "C6":
        * "3D Lines"
          makeLines
      "C7":
        * "Inequalities"
          makeIneq
      "C8":
        * "Arithmetic progressions"
          makeAP
      "C9":
        * "Factor theorem"
          makeFactor
      "C10":
        * "Quadratics"
          makeQuadratic
      "C11":
        * "Completing the square"
          makeComplete
      "C12":
        * "Binomial expansion"
          makeBinExp
      "C13":
        * "Logarithms"
          makeLog
      "C14":
        * "Stationary points"
          makeStationary
      "C15":
        * "Triangles"
          makeTriangle
      "C16":
        * "Circles"
          makeCircle
      "C17":
        * "Trig equations"
          makeSolvingTrig
      "C18":
        * "Vector equations"
          makeVectorEq
      "C19":
        * "Implicit differentiation"
          makeImplicit
      "C20":
        * "The chain rule"
          makeChainRule
      "C21":
        * "The product rule"
          makeProductRule
      "C22":
        * "The quotient rule"
          makeQuotientRule
      "C23":
        * "Geometric progressions"
          makeGP
      "C24":
        * "Modulus function"
          makeModulus
      "C25":
        * "Transforms of functions"
          makeTransformation
      "C26":
        * "Composition of functions"
          makeComposition
      "C27":
        * "Parametric functions"
          makeParametric
      "C270":
        * "Implicit functions"
          makeImplicitFunction
      "C28":
        * "Integration"
          makeIntegration
      "C29":
        * "Differential equations"
          makeDE
      "C30":
        * "Powers"
          makePowers
      "C31":
        * "Equations of 2D lines"
          makeLinesEq
      "C32":
        * "Equations of circles"
          makeCircleEq
      "C33":
        * "Parallel and perpendicular lines"
          makeLineParPerp
      "C34":
        * "Intersections of circles and lines"
          makeCircLineInter

      "F1":
        * "Complex Arithmetic"
          makeCArithmetic
      "F2":
        * "Modulus Argument"
          makeCPolar
      #"F3":
      #  "1st order DEs"
      # makeDESepHard
      "F3a":
        * "2nd order DEs"
          makeDETwoHard
      "F4":
        * "Rank 2 matrices"
          makeMatrix2
      "F5":
        * "Taylor Series"
          makeTaylor
      "F6":
        * "Polar Coordinates"
          makePolarSketch
      "F7":
        * "Rank 3 matrices"
          makeMatrix3
      "F8":
        * "Further vectors"
          makeFurtherVector
      "F9":
        * "Newton-Raphson"
          makeNewtonRaphson
      "F10":
        * "Further inequalities"
          makeFurtherIneq
      "F11":
        * "Integration by substitution"
          makeSubstInt
      "F12":
        * "Figures of revolution"
          makeRevolution
      "F13":
        * "Matrix transformations"
          makeMatXforms
      'S1':
        * "Discrete Distributions"
          makeDiscreteDistn
      'S2':
        * "Continuous Distributions"
          makeContinDistn
      'S3':
        * "Hypothesis Testing"
          makeHypTest
      'S4':
        * "Confidence Intervals"
          makeConfidInt
      'S5':
        * "Chi Squared"
          makeChiSquare
      'S6':
        * "Product Moments"
          makeProductMoment

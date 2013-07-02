'use strict'

# jasmine specs for controllers go here

describe "mathmoController", ->
  beforeEach(module "app")

  scope = {} # We need this declared outside the scope of beforeEach

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    $controller("mathmoController", {
      $scope: scope
    })

    pane = scope.addQSet("unit-test")

  qatest = (questionfn, topicId, questiontext, answertext, qNo=1) ->
    console.log "Testing "+questionfn
    describe questionfn, ->
      it "should produce the correct question and answer", ->
        expect(scope.testQ(topicId, qNo)[0]).toBe questiontext
        expect(scope.testQ(topicId, qNo)[1]).toBe answertext

  testlist = [
    [
      "makePartial1"
      "C1"
      "Express$$\\frac{- 12x - 15}{2x^2 + 5x - 3}$$in partial fractions."
      "$$-\\frac{3}{x + 3}-\\frac{6}{2x - 1}$$"
    ]
    [
      "makePartial2"
      "C1"
      "Express$$\\frac{- 2x^2 - 17x + 57}{(x - 3)(x - 2)(x + 3)}$$in partial fractions."
      "$$-\\frac{2}{x - 3}-\\frac{3}{x - 2}+\\frac{3}{x + 3}$$"
      2
    ]
    [
      "makeBinomial2"
      "C2"
      "Evaluate$$(3 - x)^4$$to the fourth term."
      "$$81 - 108x + 54x^2 - 12x^3$$"
    ]
    [
      "makePolyInt"
      "C3"
      "Evaluate$$\\int_{-1}^{3}- 2x^3 - 6x^2 + 4x\\,\\mathrm{d}x$$"
      "$$-80$$"
    ]
    [
      "makeTrigInt"
      "C4"
      "Evaluate$$\\int_{0}^{\\pi/4}2\\cos{3x}\\,\\mathrm{d}x$$"
      "$$+\\frac{1}{3}\\sqrt{2}$$"
    ]
    [
      "makeVector"
      "C5"
      "Consider the four vectors$$\\mathbf{A}=\\left(\\begin{array}{c}-9\\\\0\\\\2\\end{array}\\right), \\mathbf{B}=\\left(\\begin{array}{c}-8\\\\-8\\\\4\\end{array}\\right)$$$$\\mathbf{C}=\\left(\\begin{array}{c}9\\\\0\\\\-2\\end{array}\\right), \\mathbf{D}=\\left(\\begin{array}{c}1\\\\-2\\\\5\\end{array}\\right)$$<ol class=\"exercise\"><li>Order the vectors by magnitude.</li><li>Use the scalar product<br>to find the angles between<ol class=\"exercise\"><li>\\(\\mathbf{D}\\) and \\(\\mathbf{C}\\),</li><li>\\(\\mathbf{C}\\) and \\(\\mathbf{B}\\)</li></ol></ol>"
      "<ol class=\"exercise\"><li>\\(|\\mathbf{B}|=\\sqrt{144}, |\\mathbf{A}|=\\sqrt{85},\\)<br>\\( |\\mathbf{C}|=\\sqrt{85}, |\\mathbf{D}|=\\sqrt{30}\\).</li><li><ol style=\"list-style-type:lower-alpha\"><li>\\(\\arccos\\left(\\frac{-1}{5\\sqrt{102}}\\right)\\)</li><li>\\(\\arccos\\left(\\frac{-20}{3\\sqrt{85}}\\right)\\)</li></ol></li></ol>"
    ]
    [
      "makeLines"
      "C6"
      "Consider the lines$$- x - 2=- y - 3=- 2z$$and$$- x - 3=y + 2=- z - 1$$Find the angle between them<br>and determine whether they<br>intersect."
      "The angle between the lines is$$\\arccos\\left(\\frac{-1}{3\\sqrt{3}}\\right).$$The lines meet at the point$$\\left(-2,-3,0\\right).$$"
    ]
    [
      "makeIneq2"
      "C7"
      "By factorizing a suitable polynomial, or otherwise, find the values of \\(x\\) which satisfy$$x^2 - 3x < 4$$"
      "$$-1 < x < 4$$"
    ]
    [
      "makeIneq3"
      "C7"
      "By factorizing a suitable polynomial, or otherwise, find the values of \\(y\\) which satisfy$$y^3 < 9y^2 - 20y$$"
      "$$y < 0$$and$$4 < y < 5$$"
      2
    ]
    [
      "makeAP"
      "C8"
      "An arithmetic progression has third term \\(\\alpha\\) and eleventh term \\(\\beta\\). Find the sum to \\(26\\) terms."
      "$$-\\frac{65}{8}\\alpha + \\frac{273}{8}\\beta$$"
    ]
    [
      "makeFactor1"
      "C9"
      "Divide $$x^3 + x^2 - 8x - 12$$ by $$(x + 2)$$ and hence factorise it completely."
      "$$(x - 3)(x + 2)^2$$"
    ]
    [
      "makeFactor2"
      "C9"
      "Use the factor theorem to factorise $$x^3 + x^2 - 17x + 15.$$"
      "(x - 3)(x - 1)(x + 5)"
      10
    ]
    [
      "makeFactor3"
      "C9"
      "Simplify$$\\frac{x^3 + x^2 - 9x - 9}{x^3 + 5x^2 + 7x + 3}.$$"
      "$$\\frac{x - 3}{x + 1}$$"
      4
    ]
    [
      "makeQuadratic"
      "C10"
      "Find the real roots, if any, of$$x^2 - 2x - 3=0$$"
      "$$x=-1\\mbox{ and }x=3$$"
    ]
    [
      "makeComplete"
      "C11"
      "Find the minimum value of$$x^2 - 8x + 13$$in the range$$-1\\leq x\\leq3.$$"
      "The minimum value is \\(-2\\) which occurs at \\(x=3\\)"
    ]
    [
      "makeBinExp"
      "C12"
      "Find the first four terms in the expansion of $$\\left(1 - x\\right)^{\\frac{2}{3}}$$"
      "$$1 - \\frac{2}{3}x - \\frac{1}{9}x^2 - \\frac{4}{81}x^3$$"
    ]
    [
      "makeLog"
      "C13"
      "If \\(125=3125^{x}\\) find \\(x\\)."
      "$$x=\\frac{3}{5}$$"
    ]
    [
      "makeStationary2"
      "C14"
      "Find the stationary point of $$y=- x^2 - 8x + 3,$$ and state whether it is a maximum or a minimum."
      "\\(x=-4\\), maximum."
      6
    ]
    [
      "makeStationary3"
      "C14"
      "Find the stationary points of $$y=3x^3 - 81x + 2,$$ and state their nature."
      "\\(x=-3\\), maximum,<br />and \\(x=3\\), minimum"
    ]
    [
      "makeTriangle1"
      "C15"
      "In triangle \\(ABC, AB=4,BC=5,\\) and angle \\(A\\) is a right angle. Find \\(CA\\)."
      "$$CA=3$$"
      2
    ]
    [
      "makeTriangle2"
      "C15"
      "In triangle \\(ABC, AB=4,BC=3,\\) and \\(CA=5.\\) Find the angles of the triangle."
      "$$\\cos A=\\frac{4}{5},\\cos B=0,\\cos C=\\frac{3}{5}.$$"
      5
    ]
    [
      "makeTriangle3"
      "C15"
      "In triangle \\(ABC, AB=7, BC=6\\) and angle \\(C=\\frac{\\pi}{6}. \\) Find angle \\(A\\)."
      "$$A=\\arcsin\\left(\\frac{3}{7}\\right)$$"
      3
    ]
    [
      "makeCircle"
      "C16"
      "Find, for a sector of angle \\(\\frac{11\\pi}{8}\\) of a disc of radius \\(2:\\)<br>i. the length of the perimeter; and<br>ii. the area."
      "i. \\(4+\\frac{11}{4}\\pi\\)<br>ii. \\(\\frac{11}{4}\\pi\\)"
    ]
    [
      "makeSolvingTrig"
      "C17"
      "Write $$\\frac{5}{2}\\sqrt{3}\\sin{\\theta}+\\frac{5}{2}\\cos{\\theta}$$ in the form \\(A\\sin(\\theta+\\alpha),\\) where \\(A\\) and \\(\\alpha\\) are to be determined."
      "$$5\\sin\\left(\\theta+\\frac{\\pi}{6}\\right)$$"
    ]
    [
      "makeVectorEq"
      "C18"
      "Show that the points with position vectors$$\\left(\\begin{array}{c}3\\\\-5\\\\-3\\end{array}\\right),\\left(\\begin{array}{c}8\\\\-35\\\\-8\\end{array}\\right),\\left(\\begin{array}{c}2\\\\1\\\\-2\\end{array}\\right)$$lie on a straight line, and give the equation of the line in the form \\(\\mathbf{r}=\\mathbf{a}+\\lambda\\mathbf{b}\\)."
      "$$\\left(\\begin{array}{c}3\\\\-5\\\\-3\\end{array}\\right)+\\lambda\\left(\\begin{array}{c}1\\\\-6\\\\-1\\end{array}\\right)$$"
    ]
    [
      "makeImplicit"
      "C19"
      "If $$y=\\frac{3t + 3}{t - 3}$$ and $$x=\\frac{t + 2}{t + 3},$$find \\(\\frac{dy}{dx}\\) when \\(t=-4\\)"
      "$$-\\frac{12}{49}$$"
    ]
    [
      "makeChainRule"
      "C20"
      "Differentiate \\(\\sec(5x + 1)\\)"
      "$$5\\sec(5x + 1)\\tan(5x + 1)$$"
    ]
    [
      "makeProductRule"
      "C21"
      "Differentiate $$(8x^3 - x^2 + 2x + 6)\\ln(x)$$"
      "$$(24x^2 - 2x + 2)\\ln(x) + \\frac{8x^3 - x^2 + 2x + 6}{x}$$"
    ]
    [
      "makeQuotientRule"
      "C22"
      "Differentiate $$\\frac{1}{\\tan(3x^2 + 5x + 7)}$$"
      "$$(6x + 5)\\csc^2(3x^2 + 5x + 7)$$"
    ]
    [
      "makeGP"
      "C23"
      "Evaluate $$\\sum_{r=0}^{7} -6\\times\\left(\\frac{4}{5}\\right)^{r}$$"
      "$$-\\frac{1950534}{78125}$$"
    ]
    # [ # Omitted because this has a graphical solution
    #   "makeModulus"
    #   "C24"
    #   "q-C24"
    #   "a-C24"
    # ]
    # [ # Omitted because this has a graphical solution
    #   "makeTransformation"
    #   "C25"
    #   "q-C25"
    #   "a-C25"
    # ]
    # [ # Omitted because this has a graphical solution
    #   "makeComposition"
    #   "C26"
    #   "q-C26"
    #   "a-C26"
    # ]
    # [ # Omitted because this has a graphical solution
    #   "makeParametric"
    #   "C27"
    #   "q-C27"
    #   "a-C27"
    # ]
    # [ # Omitted because this has a graphical solution
    #   "makeImplicitFunction"
    #   "C270"
    #   "q-C270multiple"
    #   "a-C270multiple"
    # ]
    [
      "makeIntegration"
      "C28"
      "Find $$\\int\\frac{14x + 7}{7x^2 + 7x + 6}\\,\\mathrm{d}x$$"
      "$$\\ln(7x^2 + 7x + 6)+c$$"
    ]
    [
      "makeDE"
      "C29"
      "Find the general solution of the following second-order ODE:$$\\frac{{\\,d^2}y}{{\\,dx}^2} + 6\\frac{\\,dy}{\\,dx} + 8y=0$$"
      "$$y=Ae^{-4x}+Be^{-2x}$$"
    ]
    [
      "makePowers"
      "C30"
      "Simplify $$\\frac{x^{\\frac{1}{3}}\\times \\root 5 \\of{x^{-4}}}{x^{-\\frac{4}{5}}\\times x^{\\frac{1}{5}}\\times \\root 2 \\of{x^{3}}}$$"
      "$$x^{-\\frac{41}{30}}$$"
    ]
    [
      "makeCArithmetic"
      "F1"
      "Given \\(z=i\\) and \\(w=2\\sqrt{3} -2i\\), compute:<ul class=\"exercise\"><li>\\(z+w\\)</li><li>\\(z\\times w\\)</li><li>\\(\\frac{z}{w}\\)</li><li>\\(\\frac{w}{z}\\)</li></ul>"
      "<ul class=\"exercise\"><li>\\(2\\sqrt{3} -i\\)</li><li>\\(2 + 2\\sqrt{3}i\\)</li><li>\\(-\\frac{1}{8} + \\frac{\\sqrt{3}}{8}i\\)</li><li>\\(-2 -2\\sqrt{3}i\\)</li></ul>"
    ]
    [
      "makeCPolar"
      "F2"
      "Convert \\(5i\\) to modulus-argument form."
      "$$5e^{\\frac{1}{2}\\pi i}$$"
    ]
    [
      "makeDETwoHard"
      "F3a"
      "Find the general solution of the following second-order ODE:$$\\frac{{\\,d^2}y}{{\\,dx}^2} - 4\\frac{\\,dy}{\\,dx} + y=0$$"
      "$$y=Ae^{\\left(2+\\sqrt{3}\\right)x}+Be^{\\left(2-\\sqrt{3}\\right)x}$$"
    ]
    [
      "makeMatrix2"
      "F4"
      "Let $$A=\\left(\\begin{array}{cc}5&-4\\\\-5&1\\end{array}\\right)$$ $$B=\\left(\\begin{array}{cc}-4&2\\\\5&3\\end{array}\\right)$$.Compute: <ul class=\"exercise\"><li>\\(A+B\\)</li><li>\\(A \\times B\\)</li><li>\\(B^{-1}\\)</li></ul>"
      "<ul class=\"exercise\"><li>\\(\\left(\\begin{array}{cc}1&-2\\\\0&4\\end{array}\\right)\\)</li><li>\\(\\left(\\begin{array}{cc}-40&-2\\\\25&-7\\end{array}\\right)\\)</li><li>\\(\\left(\\begin{array}{cc}-\\frac{3}{22}&\\frac{1}{11}\\\\\\frac{5}{22}&\\frac{2}{11}\\end{array}\\right)\\)</li></ul>"
    ]
    [
      "makeTaylor"
      "F5"
      "Find the Taylor series of \\(\\arctan(-x)\\) about \\(x=0\\) up to and including the term in \\(x^3\\)"
      "$$- x + \\frac{1}{3}x^3$$"
    ]
    # [ # Omitted because this has a graphical solution
    #   "makePolarSketch"
    #   "F6"
    #   "q-F6"
    #   "a-F6"
    # ]
    [
      "makeMatrix3"
      "F7"
      "Let $$A=\\left(\\begin{array}{ccc}3&1&2\\\\3&-3&1\\\\3&-4&-2\\end{array}\\right)$$ $$B=\\left(\\begin{array}{ccc}-4&-2&2\\\\-2&-2&3\\\\-3&3&2\\end{array}\\right)$$.Compute: <ul class=\"exercise\"><li>\\(A+B\\)</li><li>\\(A \\times B\\)</li><li>\\(B^{-1}\\)</li></ul>"
      "<ul class=\"exercise\"><li>\\(\\left(\\begin{array}{ccc}-1&-1&4\\\\1&-5&4\\\\0&-1&0\\end{array}\\right)\\)</li><li>\\(\\left(\\begin{array}{ccc}-20&-2&13\\\\-9&3&-1\\\\2&-4&-10\\end{array}\\right)\\)</li><li>\\(\\left(\\begin{array}{ccc}-\\frac{13}{38}&\\frac{5}{19}&-\\frac{1}{19}\\\\-\\frac{5}{38}&-\\frac{1}{19}&\\frac{4}{19}\\\\-\\frac{6}{19}&\\frac{9}{19}&\\frac{2}{19}\\end{array}\\right)\\)</li></ul>"
    ]
    [
      "makeFurtherVector"
      "F8"
      "Let \\(a=\\left(\\begin{array}{c}2\\\\2\\\\-5\\end{array}\\right)\\), \\(b=\\left(\\begin{array}{c}-2\\\\-3\\\\1\\end{array}\\right)\\), \\(c=\\left(\\begin{array}{c}3\\\\3\\\\-3\\end{array}\\right)\\). Calculate: <ul class=\"exercise\"><li>the vector product, \\(a\\wedge b\\),</li><li>the scalar triple product, \\([a, b, c]\\).</li></ul>"
      "<ul class=\"exercise\"><li>\\(\\left(\\begin{array}{c}-13\\\\8\\\\-2\\end{array}\\right)\\)</li><li>\\(-9\\)</li></ul>"
    ]
    [
      "makeNewtonRaphson"
      "F9"
      "Use the Newton-Raphson method to find the first \\(4m\\) iterates in solving \\(x^2 - 2x - 1 = \\cos(x)\\) with \\(x_0 = 3\\)."
      "Iteration: \\begin{align*} x_{n+1}&=x_{n}-\\frac{\\cos(x_n)- x^2 + 2x + 1}{-\\sin(x_n)- 2x + 2} \\\\[10pt]x_{1} &= 2.277974922054657\\\\x_{2} &= 2.1926616449298555\\\\x_{3} &= 2.1911000725687817\\\\x_{4} &= 2.1910995316432778\\\\\\end{align*}"
    ]
    [
      "makeFurtherIneq"
      "F10"
      "Find the range of values of \\(x\\) for which$$\\frac{-2}{6x - 4} < \\frac{-5}{- 5x - 6}$$"
      "$$-\\frac{6}{5} < x < \\frac{1}{5}\\mbox{ or }\\frac{2}{3} < x$$"
    ]
    [
      "makeSubstInt"
      "F11"
      "Find $$\\int\\frac{2x - 2}{- 4x - 2x^2 + 4x^3 - x^4}\\,dx$$"
      "$${\\rm artanh}(- 1 - 2x + x^2)+c$$"
    ]
    [
      "makeRevolution"
      "F12"
      "Find the volume of the solid formed when the area under$$y = \\sec(x)$$from \\(x = 0\\mbox{ to }x = 1\\) is rotated through \\(2\\pi\\) around the x-axis."
      "$$\\left(\\tan(1)\\right)\\pi$$"
    ]
    [
      "makeRevolution"
      "F12"
      "Find the area of the surface formed when the curve$$y = 3x^2 + 6x + 2$$from \\(x = 0\\mbox{ to }x = 4\\) is rotated through \\(2\\pi\\) around the x-axis."
      "$$240\\pi$$"
      2
    ]
    # [ # Removed because currently giving NaN answers :(
    #   "makeMatXforms"
    #   "F13"
    #   "q-F13"
    #   "a-F13"
    # ]
    [
      "makeDiscreteDistn"
      "S1"
      "The random variable \\(X\\) is distributed as$${\\rm B}\\left(7, \\frac{2}{3}\\right).$$  Find \\(\\mathbb{P}(X=1)\\)"
      "$$0.006401$$"
    ]
    [
      "makeContinDistn"
      "S2"
      "The random variable \\(X\\) is normally distributed with mean \\(0\\) and variance \\(4\\).<br />Find \\(\\mathbb{P}(X\\le-1.7)\\)"
      "$$0.198$$"
    ]
    [
      "makeHypTest"
      "S3"
      "In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = 5\\). The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu<5\\). The significance level is \\(1\\%\\). A sample of size \\(13\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = 40.351\\). The sum of squares, \\(\\sum{x^2} = 267.698\\). Compute: <ul class=\"exercise\"><li>\\(\\overline{x}\\)</li><li>Compute an estimate, \\(S^2\\), of the variance of \\(X\\)</li><li>Is \\({\\rm H}_0\\) accepted?</li></ul>"
      "<li>\\(\\overline{x} = 3.104\\)</li><li>\\(S^2 = 11.871\\). Under \\({\\rm H}_0\\), \\({\\frac{\\overline{X}-5}{0.956}}\\sim t_{12}\\)</li><li>The critical region is \\(\\overline{x}<2.438\\); </br />\\({\\rm H}_0\\) is accepted.</li></ul>"
    ]
    [
      "makeConfidInt"
      "S4"
      "The random variable \\(X\\) has a normal distribution with unknown parameters. A sample of size \\(14\\) is taken for which $$\\sum{x}=-36.270$$$$\\mbox{and}\\sum{x^2}=161.831.$$Compute, to 3 DP., a \\(90\\)% confidence interval for the mean of \\(X\\).<br />"
      "$$[-3.672, -1.509]$$"
    ]
    [
      "makeChiSquare"
      "S5"
      "The random variable \\(X\\) is modelled by a <i>normal</i> distribution. A sample of size \\(55\\) is drawn from \\(X\\) with the following grouped frequency data. <div style=\"font-size: 80%;\">$$\\begin{array}{c|r}x&\\mbox{Frequency}\\\\x < -1&4\\\\-1\\le x <1&5\\\\1\\le x <3&3\\\\3\\le x <5&10\\\\5\\le x <7&12\\\\7\\le x <9&8\\\\9\\le x <11&6\\\\11\\le x <13&6\\\\13\\le x <15&0\\\\15\\le x <17&0\\\\17\\le x <19&0\\\\19\\le x&1\\\\\\end{array}$$</div><ul class=\"exercise\"><li>Estimate the parameters of the distribution.</li><li>Use a \\(\\chi^2\\) test, with a significance level of \\(99\\)%, to test this hypothesis.</li></ul>"
      "<ol class=\"exercise\"><li>$$\\mu=5.927, \\sigma=4.438.$$</li><li></li></ol><div style=\"font-size: 80%;\">$$\\begin{array}{c||r|r|r}x&O_i&E_i&\\frac{(O_i-E_i)^2}{E_i}\\\\x < 1&9&7.342&0.374\\\\1\\le x <3&3&6.680&2.027\\\\3\\le x <5&10&8.947&0.124\\\\5\\le x <7&12&9.768&0.510\\\\7\\le x <9&8&8.817&0.076\\\\9\\le x <11&6&6.476&0.035\\\\11\\le x&7&6.970&0.000\\\\\\end{array}$$</div>$$\\chi^2 = 3.146$$$$\\nu = 4$$Critical region: \\(\\chi^2 >13.28\\)<br />The hypothesis is accepted."
    ]
    [
      "makeProductMomen"
      "S6"
      "For the following data,<ul class=\"exercise\"><li>compute the product moment correlation coefficient, \\({\\bf r}\\)</li><li>find the regression line of \\(y\\) on \\(x\\)$$\\begin{array}{c|c}x&y\\\\-0.005&-4.976\\\\-2.079&-4.368\\\\-1.276&-2.957\\\\2.534&-2.072\\\\-1.725&-4.288\\\\-2.534&-3.341\\\\0.347&-5.927\\\\-0.439&-2.561\\\\-2.235&-2.679\\\\1.095&-5.589\\\\-3.161&-3.771\\\\-4.049&-2.893\\\\\\end{array}$$</li></ul>"
      "<ul class=\"exercise\"><li>\\({\\bf r}=-0.198\\)</li><li>\\(y=-0.131x-3.932\\)."
    ]
  ]

  console.log ""
  console.log "Starting mathmo unit tests"
  console.log "-----------------------------------------"
  console.log ""

  for i in testlist
    if i.length == 4
      qatest(i[0], i[1], i[2], i[3])
    else
      qatest(i[0], i[1], i[2], i[3], i[4])

  console.log ""
  console.log "Mathmo unit tests finished"
  console.log testlist.length + " unit tests completed"
  console.log "-----------------------------------------"
  console.log ""


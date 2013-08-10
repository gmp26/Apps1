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

  qatest = (questionfn, topicId, questiontext, answertext, qNo=0) ->
    console.log "Testing "+questionfn
    describe questionfn, ->
      it "should produce the correct question and answer", ->
        expect(scope.testQ(topicId, qNo+1000)[0]).toBe questiontext
        expect(scope.testQ(topicId, qNo+1000)[1]).toBe answertext

  testlist = [
    [
      "makePartial1"
      "C1"
      "Express$$\\frac{11x + 22}{4x^2 - 10x - 24}$$in partial fractions."
      "$$-\\frac{1}{4x + 6}+\\frac{3}{x - 4}$$"
    ]
    [
      "makePartial2"
      "C1"
      "Express$$\\frac{20x - 5}{21x^2 - 43x + 20}$$in partial fractions."
      "$$-\\frac{5}{7x - 5}+\\frac{5}{3x - 4}$$"
      2
    ]
    [
      "makeBinomial2"
      "C2"
      "Evaluate$$(4 + 2x)^4$$to the fourth term."
      "$$256 + 512x + 384x^2 + 128x^3$$"
    ]
    [
      "makePolyInt"
      "C3"
      "Evaluate$$\\int_{-1}^{1}4x^3 - 6x^2 - 2x + 3\\,\\mathrm{d}x$$"
      "$$2$$"
    ]
    [
      "makeTrigInt"
      "C4"
      "Evaluate$$\\int_{0}^{\\pi / 4} - 3\\cos{6x}\\,\\mathrm{d}x$$"
      "$$\\frac{1}{2}$$"
    ]
    [
      "makeVector"
      "C5"
      "Consider the four vectors$$\\mathbf{A} = \\begin{pmatrix}-4\\\\-3\\\\0\\end{pmatrix}\\,,\\ \\mathbf{B} = \\begin{pmatrix}2\\\\-6\\\\0\\end{pmatrix}$$$$\\mathbf{C} = \\begin{pmatrix}-4\\\\2\\\\5\\end{pmatrix}\\,,\\ \\mathbf{D} = \\begin{pmatrix}-1\\\\-3\\\\-7\\end{pmatrix}$$<ol class=\"exercise\"><li>Order the vectors by magnitude.</li><li>Use the scalar product to find the angles between<ol class=\"subexercise\"><li>\\(\\mathbf{D}\\) and \\(\\mathbf{A}\\),</li><li>\\(\\mathbf{A}\\) and \\(\\mathbf{C}\\)</li></ol></ol>"
      "<ol class=\"exercise\"><li>\\(|\\mathbf{D}| = \\sqrt{59},\\) \\(|\\mathbf{C}| = \\sqrt{45},\\) \\( |\\mathbf{B}| = \\sqrt{40}\\) and \\(|\\mathbf{A}| = \\sqrt{25}\\).</li><li><ol class=\"subexercise\"><li>\\(\\arccos\\left(\\frac{13}{5\\sqrt{59}}\\right)\\)</li><li>\\(\\arccos\\left(\\frac{2}{3\\sqrt{5}}\\right)\\)</li></ol></li></ol>"
    ]
    [
      "makeLines"
      "C6"
      "Consider the lines$$3x + 3 = - 2y + 2 = - 3z + 1$$and$$- 2x + 1 = y + 2 = - 3z - 3$$Find the angle between them<br>and determine whether they<br>intersect."
      "The angle between the lines is$$\\arccos\\left(\\frac{-20}{7\\sqrt{17}}\\right).$$The lines do not meet."
      1 # I got a horrible decimal when I used 0 here. Displays fine in the browser, but still need to debig
    ]
    [
      "makeIneq2"
      "C7"
      "By factorising a suitable polynomial, or otherwise, find the values of \\(x\\) which satisfy$$x^2 - 4 < 3x$$"
      "$$-1 < x < 4$$"
      4
    ]
    [
      "makeIneq3"
      "C7"
      "By factorising a suitable polynomial, or otherwise, find the values of \\(y\\) which satisfy$$y^3 + 12 < - 8y^2 - 19y$$"
      "$$y < -4$$and$$-3 < y < -1$$"
    ]
    [
      "makeAP"
      "C8"
      "An arithmetic progression has fourth term \\(\\alpha\\) and tenth term \\(\\beta\\). Find the sum to \\(24\\) terms."
      "$$-10\\alpha + 34\\beta$$"
    ]
    [
      "makeFactor1"
      "C9"
      "Use the factor theorem to factorise $$x^3 - 2x^2 - 19x + 20.$$"
      "$$(x - 5)(x - 1)(x + 4)$$"
      2
    ]
    [
      "makeFactor2"
      "C9"
      "Divide $$x^3 - 9x^2 + 6x + 56$$ by $$(x + 2)$$ and hence factorise it completely."
      "$$(x - 7)(x - 4)(x + 2)$$"
      1
    ]
    [
      "makeFactor3"
      "C9"
      "Simplify$$\\frac{x^3 - 8x^2 + 20x - 16}{x^3 - 2x^2 - 16x + 32}.$$"
      "$$\\frac{x - 2}{x + 4}$$"
    ]
    # [ This isn't getting used so I've dropped the test
    #   "makeQuadratic"
    #   "C10"
    #   "Find the real roots, if any, of$$x^2 - 4x - 1 = 0$$"
    #   "$$x=2\\pm\\sqrt{5}$$"
    # ]
    [
      "makeComplete"
      "C11"
      "By completing the square, find (for real \\(x\\)) the minimum value of$$x^2 + 4x + 9.$$"
      "The minimum value is \\(5,\\) which occurs at \\(x = -2\\)."
    ]
    [
      "makeBinExp"
      "C12"
      "Find the first four terms in the expansion of $$\\left(1 + \\frac{2}{3}x\\right)^{\\frac{1}{2}}$$"
      "$$1 + \\frac{1}{3}x - \\frac{1}{18}x^2 + \\frac{1}{54}x^3$$"
    ]
    [
      "makeLog"
      "C13"
      "If \\(5^{x} = 2\\), then find \\(x\\) to three decimal places."
      "$$x = 0.431$$"
    ]
    [
      "makeStationary2"
      "C14"
      "Find the stationary points of $$y = - 2x^3 + 12x^2 - 18x - 3,$$ and state their nature."
      "The stationary points occur at \\(x = 1\\), a minimum, and \\(x = 3\\), a maximum"
    ]
    [
      "makeStationary3"
      "C14"
      "Find the stationary point of $$y = - 2x^2 + x - 2,$$ and state whether it is a maximum or a minimum."
      "The stationary point occurs at \\(x = \\frac{1}{4}\\), and it is a maximum."
      1
    ]
    [
      "makeTriangle1"
      "C15"
      "In triangle \\(ABC\\), \\(BC = 8\\), \\(CA = 13,\\) and angle \\(B\\) is a right angle. Find the length of \\(AB\\)."
      "$$AB = \\sqrt{105}$$"
      9
    ]
    [
      "makeTriangle2"
      "C15"
      "In triangle \\(ABC\\), \\(AB = 4\\), \\(BC = 4,\\) and \\(CA = 2.\\) Find the angles of the triangle."
      "$$\\cos A = \\frac{1}{4},\\cos B = \\frac{7}{8},\\cos C = \\frac{1}{4}.$$"
      1
    ]
    [
      "makeTriangle3"
      "C15"
      "In triangle \\(ABC\\), \\(AB = 4\\), \\(BC = 2\\) and angle \\(C = \\frac{\\pi}{6}\\). Find angle \\(A\\)."
      "$$A = \\arcsin\\left(\\frac{1}{4}\\right)$$"
    ]
    [
      "makeCircle"
      "C16"
      "Find, for a sector of angle \\(\\frac{7\\pi}{4}\\) of a disc of radius \\(6:\\)<ul class=\"exercise\"><li> the length of the perimeter and</li><li>the area.</li></ul>"
      "<ul class=\"exercise\"><li>\\(12 + \\frac{21}{2}\\pi\\)</li><li>\\(\\frac{63}{2}\\pi\\)</li></ul>"
    ]
    [
      "makeSolvingTrig"
      "C17"
      "Write $$\\frac{5}{2}\\sqrt{3}\\sin{\\theta} + \\frac{5}{2}\\cos{\\theta}$$ in the form \\(A\\sin(\\theta + \\alpha),\\) where \\(A\\) and \\(\\alpha\\) are to be determined."
      "$$5\\sin\\left(\\theta + \\frac{\\pi}{6}\\right)$$"
    ]
    [
      "makeVectorEq"
      "C18"
      "Show that the points with position vectors$$\\begin{pmatrix}2\\\\-9\\\\-14\\end{pmatrix}\\,,\\begin{pmatrix}-2\\\\-3\\\\-6\\end{pmatrix}\\,,\\begin{pmatrix}0\\\\-6\\\\-10\\end{pmatrix}$$lie on a straight line, and give the equation of the line in the form \\(\\mathbf{r} = \\mathbf{a} + \\lambda\\mathbf{b}\\)."
      "$$\\begin{pmatrix}-4\\\\0\\\\-2\\end{pmatrix} + \\lambda\\,\\begin{pmatrix}-2\\\\3\\\\4\\end{pmatrix}$$"
    ]
    [
      "makeImplicit"
      "C19"
      "If $$y + \\cos(y) = e^{x} + 2x^2 - 3x - 2,$$ find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(y\\) and \\(x\\)."
      "$$\\frac{\\mathrm{d}y}{\\mathrm{d}x} = \\frac{e^{x} + 4x - 3}{-\\sin(y) + 1}$$"
    ]
    [
      "makeChainRule"
      "C20"
      "Differentiate \\(\\cos(- 2x^3 - 2x^2 - 3x + 2)\\)"
      "$$(- 6x^2 - 4x - 3)\\sin(2x^3 + 2x^2 + 3x - 2)$$"
    ]
    [
      "makeProductRule"
      "C21"
      "Differentiate $$(4x^2 + 4x - 3)\\sin(x)$$"
      "$$(8x + 4)\\sin(x) + (4x^2 + 4x - 3)\\cos(x)$$"
    ]
    [
      "makeQuotientRule"
      "C22"
      "Differentiate $$\\frac{-6}{\\cos(4x^2 + x + 8)}$$"
      "$$(- 48x - 6)\\sec(4x^2 + x + 8)\\tan(4x^2 + x + 8)$$"
    ]
    [
      "makeGP"
      "C23"
      "Evaluate $$\\sum_{r = 0}^{5} \\left(-9\\right)^{r}$$"
      "$$-53144$$"
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
      "makeIntegration1"
      "C28"
      "Find $$\\int(- 9x^2 + 36x - 9)\\csc(x^3 - 6x^2 + 3x + 1)\\cot(x^3 - 6x^2 + 3x + 1)\\,\\mathrm{d}x$$"
      "$$3\\csc(x^3 - 6x^2 + 3x + 1) + c$$"
      2
    ]
    [
      "makeIntegration2"
      "C28"
      "Find $$\\int- 5\\ln(x)-\\frac{5x - 2}{x}\\,\\mathrm{d}x$$"
      "$$(- 5x + 2)\\ln(x) + c$$"
    ]
    [
      "makeDE2"
      "C29"
      "Find the general solution of the following second-order ODE:$$\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2} - \\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x} - 2y = 0$$"
      "$$y = Ae^{-x} + Be^{2x}$$"
      1
    ]
    [
      "makeDE3"
      "C29"
      "Find the general solution of the following first-order ODE:$$x\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x} - y = 1$$"
      "$$y = Ax-1$$"
    ]
    [
      "makePowers"
      "C30"
      "Simplify $$\\frac{\\left(x^{\\frac{1}{3}}\\right)^4\\times \\left(x^{\\frac{3}{2}}\\right)^3}{x^{-\\frac{4}{5}}\\times x^{-\\frac{4}{3}}\\times x}$$"
      "$$x^{\\frac{209}{30}}$$"
    ]
    [
      "makeLines2D"
      "C31"
      "Find the equation of the line passing through \\((-2,5)\\) and \\((6,2)\\)."
      "$$y = -\\frac{3}{8}x + \\frac{17}{4}\\qquad \\text{or} \\qquad 3x+8y-34=0.$$"
    ]
    [
      "makeCircleEq"
      "C32"
      "Find the centre and radius of the circle with equation$$x^2-2x+y^2+10y+22=0.$$"
      "The circle has centre \\((1,-5)\\) and radius \\(2 \\)."
    ]
    [
      "makeLinePar"
      "C33"
      "Find the equation of the line passing through \\((2,0)\\) and parallel to the line \\(4x+y=0.\\)"
      "$$y=-4x+8\\qquad\\text{or}\\qquad 4x+y-8=0$$"
    ]
    [
      "makeLinePerp"
      "C33"
      "Find the equation of the line passing through \\((-6,6)\\) and perpendicular to the line \\(y=x-1.\\)"
      "$$y =  - x\\qquad\\text{or}\\qquad x + y = 0.$$"
      1
    ]
    [
      "makeLLInter"
      "C34"
      "Find all the points where the line \\(y=-5x+4\\) and the line \\(5x-y+2=0\\) intersect."
      "The lines intersect in a single point, which occurs at \\(\\left(\\frac{1}{5},3\\right)\\)."
    ]
    [
      "makeCLInter"
      "C34"
      "Find all the points where the line \\(3x+y-5=0\\) and the circle \\( (x-6)^2+(y+3)^2=16\\) intersect."
      "The line and the circle intersect in two points, specifically $$\\left(\\frac{15+\\sqrt{15}}{5},\\frac{-20-3\\sqrt{15}}{5}\\right)\\qquad\\text{and}\\qquad \\left(\\frac{15-\\sqrt{15}}{5},\\frac{-20+3\\sqrt{15}}{5}\\right)$$"
      1
    ]
    [
      "makeCCInter"
      "C34"
      "Find all the points where the circle \\(x^2+12x+y^2+6y=4\\) and the circle \\(x^2-2x+y^2+8y+8=0\\) intersect."
      "The circles intersect in two points, which are$$\\left(\\frac{3+\\sqrt{17}}{10},\\frac{-39+7\\sqrt{17}}{10}\\right)\\qquad\\text{and}\\qquad \\left(\\frac{3-\\sqrt{17}}{10},\\frac{-39-7\\sqrt{17}}{10}\\right)$$"
      4
    ]
    [
      "makeHCF"
      "C35"
      "Find the highest common factor of \\(31616\\) and \\(94894\\)."
      "$$2$$"
    ]
    [
      "makeLCM"
      "C36"
      "Find the least common multiple of \\(15\\) and \\(144\\)."
      "$$720$$"
    ]
    [
      "makeDiophantine"
      "C37"
      "Find all integer solutions \\(m\\) and \\(n\\) to the equation \\(627m + 484n = -836\\)."
      "The solutions are $$m = -1292+44r, \\qquad\\text{and}\\qquad n = 1672-44r$$ where \\(r\\) is an integer."
    ]
    [
      "makeDistance" # integer-integer
      "C38"
      "Find the distance between the points \\((2,3)\\) and \\((-3,6)\\)."
      "$$\\sqrt{34}$$"
      1
    ]
    [
      "makeDistance" # frac-frac
      "C38"
      "Find the distance between the points \\((-\\frac{8}{7},\\frac{5}{8})\\) and \\((\\frac{4}{9},-\\frac{3}{5})\\)."
      "$$\\frac{\\sqrt{25529569}}{2520}$$"
    ]
    [
      "makeCircumCircle" # frac-frac
      "C39"
      "Find the centre and radius of the circle passing through the points \\((-5,3)\\), \\((7,-7)\\) and \\((8,10)\\)."
      "The centre is \\((\\frac{437}{107},\\frac{182}{107})\\) and the radius is \\(\\frac{\\sqrt{964105}}{107}\\)."
    ]
    [
      "makeCArithmetic"
      "F1"
      "Given \\(z = -\\frac{1}{2} + \\frac{\\sqrt{3}}{2}i\\) and \\(w = \\frac{3}{2} -\\frac{3\\sqrt{3}}{2}i\\), compute:<ul class=\"exercise\"><li>\\(z + w\\)</li><li>\\(z\\times w\\)</li><li>\\(\\frac{z}{w}\\)</li><li>\\(\\frac{w}{z}\\)</li></ul>"
      "<ul class=\"exercise\"><li>\\(1 -\\sqrt{3}i\\)</li><li>\\(\\frac{3}{2} + \\frac{3\\sqrt{3}}{2}i\\)</li><li>\\(-\\frac{1}{3}\\)</li><li>\\(-3\\)</li></ul>"
    ]
    [
      "makeCPolar"
      "F2"
      "Convert \\(\\frac{3}{2} + \\frac{3\\sqrt{3}}{2}i\\) to modulus-argument form."
      "$$3e^{\\frac{1}{3}\\pi i}$$"
    ]
    [
      "makeDETwoHard"
      "F3a"
      "Find the general solution of the following second-order ODE:$$\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2} = 0$$"
      "$$y = Ax + B$$"
    ]
    [
      "makeMatrix2"
      "F4"
      "Let $$A = \\begin{pmatrix}2&6\\\\2&-5\\end{pmatrix} \\qquad \\text{and} \\qquad B = \\begin{pmatrix}-5&-2\\\\-6&3\\end{pmatrix}$$.Compute: <ul class=\"exercise\"><li>\\(A + B\\)</li><li>\\(A \\times B\\)</li><li>\\(B^{ - 1}\\)</li></ul>"
      "<ul class=\"exercise\"><li>\\(\\begin{pmatrix}-3&4\\\\-4&-2\\end{pmatrix}\\)</li><li>\\(\\begin{pmatrix}-46&14\\\\20&-19\\end{pmatrix}\\)</li><li>\\(\\displaystyle \\frac{1}{27}\\textstyle \\begin{pmatrix} -3&-2\\\\-6&5\\end{pmatrix}\\)</li></ul>"
    ]
    [
      "makeTaylor"
      "F5"
      "Find the Taylor series of \\(\\arctan(\\frac{3}{5}x)\\) about \\(x = 0\\) up to and including the term in \\(x^3\\)"
      "$$\\frac{3}{5}x - \\frac{9}{125}x^3$$"
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
      "Let $$A = \\begin{pmatrix}2&3&-2\\\\-1&-1&2\\\\1&0&2\\end{pmatrix} \\qquad \\text{and} \\qquad B = \\begin{pmatrix}1&4&-1\\\\1&-2&1\\\\0&-4&0\\end{pmatrix}$$.Compute: <ul class=\"exercise\"><li>\\(A + B\\)</li><li>\\(A \\times B\\)</li><li>\\(B^{ - 1}\\)</li></ul>"
      "<ul class=\"exercise\"><li>\\(\\begin{pmatrix}3&7&-3\\\\0&-3&3\\\\1&-4&2\\end{pmatrix}\\)</li><li>\\(\\begin{pmatrix}5&10&1\\\\-2&-10&0\\\\1&-4&-1\\end{pmatrix}\\)</li><li>\\(\\displaystyle \\frac{1}{4}\\textstyle \\begin{pmatrix} 2&2&1\\\\0&0&-1\\\\-2&2&-3\\end{pmatrix}\\)</li></ul>"
    ]
    [
      "makeFurtherVector"
      "F8"
      "Let \\(\\mathbf{a} = \\begin{pmatrix}-2\\\\0\\\\3\\end{pmatrix}\\,\\), \\(\\mathbf{b} = \\begin{pmatrix}-4\\\\3\\\\0\\end{pmatrix}\\,\\) and \\(\\mathbf{c} = \\begin{pmatrix}-3\\\\4\\\\5\\end{pmatrix}\\). Calculate: <ul class=\"exercise\"><li>the vector product, \\(\\mathbf{a}\\wedge \\mathbf{b}\\),</li><li>the scalar triple product, \\([\\mathbf{a}, \\mathbf{b}, \\mathbf{c}]\\).</li></ul>"
      "<ul class=\"exercise\"><li>\\(\\begin{pmatrix}-9\\\\-12\\\\-6\\end{pmatrix}\\)</li><li>\\(-51\\)</li></ul>"
    ]
    [
      "makeNewtonRaphson"
      "F9"
      "Use the Newton-Raphson method to find the first \\(5\\) iterates in solving \\(x^2 - 6x + 2 = \\cos(x)\\) with \\(x_0 = 1\\)."
      "Iteration: \\begin{align*} x_{n + 1} &= x_{n} - \\frac{\\cos(x_n)- x^2 + 6x - 2}{ - \\sin(x_n)- 2x + 6} \\\\[10pt]x_{1} &= -0.120871\\\\x_{2} &= 0.153735\\\\x_{3} &= 0.174138\\\\x_{4} &= 0.174251\\\\x_{5} &= 0.174251\\\\\\end{align*}"
    ]
    [
      "makeFurtherIneq"
      "F10"
      "Find the range of values of \\(x\\) for which$$\\frac{-4}{4x + 5} < \\frac{-2}{- 4x + 3}$$"
      "$$-\\frac{5}{4} < x < \\frac{1}{12}\\mbox{ or }\\frac{3}{4} < x$$"
    ]
    [
      "makeSubstInt"
      "F11"
      "Find $$\\int\\frac{4x + 1}{\\sqrt{5 - 4x - 7x^2 + 4x^3 + 4x^4}}\\,\\mathrm{d}x$$"
      "$${\\rm arsinh}(- 2 + x + 2x^2) + c$$"
    ]
    [
      "makeRevolution"
      "F12"
      "Find the volume of the solid formed when the area under$$y = \\sqrt{x}$$from \\(x = 0\\) to \\(x = 2\\) is rotated through \\(2\\pi\\) around the \\(x\\)-axis."
      "$$2\\pi$$"
    ]
    [
      "makeRevolution"
      "F12"
      "Find the area of the surface formed when the curve$$y = 5x^2 + 4x + 4$$from \\(x = 0\\mbox{ to }x = 1\\) is rotated through \\(2\\pi\\) around the \\(x\\)-axis."
      "$$\\frac{46}{3}\\pi$$"
      2
    ]
    [
      "makeMatXforms"
      "F13"
      "Compute the matrix representing, in 2D, an enlargement of scale factor \\(3\\) followed by a reflection in the line \\(y = - x\\)."
      "$$\\begin{pmatrix}0&-4\\\\-4&0\\end{pmatrix}$$"
    ]
    [
      "makeDiscreteDistn"
      "S1"
      "The random variable \\(X\\) is distributed as$${\\rm Po}(2).$$ Find \\(\\mathbb{P}(X = 1)\\)"
      "$$0.270671$$"
    ]
    [
      "makeContinDistn"
      "S2"
      "The random variable \\(X\\) is normally distributed with mean \\(1\\) and variance \\(4\\).<br />Find \\(\\mathbb{P}(X\\le4)\\)"
      "$$0.933$$"
    ]
    [
      "makeHypTest"
      "S3"
      "In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = 4\\mbox{, }\\sigma^2 = 4\\). The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu<4\\). The significance level is \\(5\\%\\). A sample of size \\(9\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = 1.793\\).<br /><br />Compute: <ul class=\"exercise\"><li>\\(\\overline{x}\\)</li><li> Is \\({\\rm H}_0\\) accepted?}</li></ul>"
      "<ul class=\"exercise\"><li>\\(\\overline{x} = 0.199\\)</li><li>The critical region is $$\\overline{x}<2.903$$<br />\\(\\rm H}_0\\) is rejected.</li></ul>"
    ]
    [
      "makeConfidInt"
      "S4"
      "The random variable \\(X\\) has a normal distribution with unknown parameters. A sample of size \\(20\\) is taken for which $$\\sum{x} = 70.096$$$$\\mbox{and}\\sum{x^2} = 389.091.$$Compute, to 3 DP., a \\(90\\)% confidence interval for the mean of \\(X\\).<br />"
      "$$[2.443, 4.567]$$"
    ]
    [
      "makeChiSquare"
      "S5"
      "The random variable \\(X\\) is modelled by a <i>binomial</i> distribution. A sample of size \\(60\\) is drawn from \\(X\\) with the following grouped frequency data. <div style=\"font-size: 80%;\">$$\\begin{array}{c|r}x&\\mbox{Frequency}\\\\x < 7&15\\\\7\\le x <9&22\\\\9\\le x <11&13\\\\11\\le x <13&8\\\\13\\le x&2\\\\\\end{array}$$</div><ul class=\"exercise\"><li>Estimate the parameters of the distribution.</li><li>Use a \\(\\chi^2\\) test, with a significance level of \\(95\\)%, to test this hypothesis.</li></ul>"
      "<ol class=\"exercise\"><li>$$n = 20, p = 0.442.$$</li><li></li></ol><div style=\"font-size: 80%;\">$$\\begin{array}{c||r|r|r}x&O_i&E_i&\\frac{(O_i - E_i)^2}{E_i}\\\\x < 7&15&8.748&4.469\\\\7\\le x <9&22&17.828&0.976\\\\9\\le x <11&13&19.827&2.351\\\\11\\le x&10&13.597&0.952\\\\\\end{array}$$</div>$$\\chi^2 = 8.747$$$$\\nu = 1$$Critical region: \\(\\chi^2 >3.841\\)<br />The hypothesis is rejected."
    ]
    [
      "makeProductMomen"
      "S6"
      "For the following data,<ul class=\"exercise\"><li>compute the product moment correlation coefficient, \\({\\bf r}\\)</li><li>find the regression line of \\(y\\) on \\(x\\)$$\\begin{array}{c|c}x&y\\\\-3.747&4.948\\\\-5.152&-4.150\\\\-4.576&9.131\\\\-4.771&5.621\\\\-4.975&6.307\\\\-5.926&-9.308\\\\\\end{array}$$</li></ul>"
      "<ul class=\"exercise\"><li>\\({\\bf r} = 0.740\\)</li><li>\\(y = 7.410x + 38.089\\)."
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


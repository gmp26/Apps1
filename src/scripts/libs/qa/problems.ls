#
# nRich RPG (Randomised Problems Generator)
#

# partial fractions
makePartial = ->

  makePartial1 = -> # two terms in the denominator
    a = randnz(8)
    b = new poly(1)
    b.setrand(8)

    if b[1] < 0
      b.xthru(-1)
      a = -a

    e = gcd(a, b.gcd())
    if e > 1
      b.xthru(1 / e)
      a /= e

    c = randnz(8)
    d = new poly(1)
    d.setrand(8)

    if d[1] < 0
      d.xthru(-1)
      c = -c

    f = gcd(c, d.gcd())
    if f > 1
      d.xthru(1 / f)
      c /= f

    if b[1] is d[1] and b[0] is d[0] then d[0] = -d[0]

    if a > 0 then aString = "$$" else aString = "$$-"
    aString += "\\frac{" + Math.abs(a) + "}{" + b.write() + "}"

    if c > 0 then aString += "+" else aString += "-"
    aString += "\\frac{" + Math.abs(c) + "}{" + d.write() + "}$$"

    bot = polyexpand(b, d)
    b.xthru(c)
    d.xthru(a)
    b.addp(d)

    qString = "Express$$\\frac{" + b.write() + "}{" + bot.write() + "}$$in partial fractions."

    qa = [qString, aString]
    return qa

  makePartial2 = -> # three terms in the denominator
    m = distrandnz(3, 3)
    l = ranking(m)

    d = randnz(4)
    e = randnz(3)
    f = randnz(3)
    n = [d, e, f]
    a = m[l[0]]; b = m[l[1]]; c = m[l[2]]
    d = n[l[0]]; e = n[l[1]]; f = n[l[2]]

    u = new poly(1); v = new poly(1); w = new poly(1)
    u[1] = v[1] = w[1] = 1;
    u[0] = a;v[0] = b; w[0] = c

    p = polyexpand(u, v); q = polyexpand(u, w); r = polyexpand(v, w)
    p.xthru(f); q.xthru(e); r.xthru(d)
    p.addp(q); p.addp(r)

    qString = "Express$$\\frac{" + p.write() + "}{" + express([a, b, c]) + "}$$in partial fractions.";

    if d > 0 then aString = "$$" else aString = "$$-"
    aString += "\\frac{" + Math.abs(d) + "}{" + u.write() + "}"

    if e > 0 then aString += "+" else aString += "-"
    aString += "\\frac{" + Math.abs(e) + "}{" + v.write() + "}"

    if f > 0 then aString += "+" else aString += "-"
    aString += "\\frac{" + Math.abs(f) + "}{" + w.write() + "}$$"

    qa = [qString, aString]
    return qa

  if rand() then qa = makePartial1() else qa = makePartial2()
  return qa



# binomial theorem
makeBinomial2 = ->
  p = new poly(1)
  p[0] = rand(1,5)
  p[1] = randnz(6 - p[0])
  n = Math.round(3 + Math.random() * (3 - Math.max(0,Math.max(p[0] - 3, p[1] - 3))))

  q = new poly(3)
  q[0] = p[0] ^ n
  q[1] = n * (p[0] ^ (n - 1)) * p[1]
  q[2] = n * (n - 1) * (p[0] ^ (n - 2)) / 2 * (p[1] ^ 2)
  q[3] = n * (n - 1) * (n - 2) * (p[0] ^ (n - 3)) / 6 * (p[1] ^ 3)

  qString = "Evaluate$$(" + p.rwrite() + ")^" + n + "$$to the fourth term."
  aString = "$$" + q.rwrite() + "$$"

  qa = [qString, aString]
  return qa



# polynomial integration
makePolyInt = ->
  A = rand(-3, 2)
  B = rand(A + 1, 3)

  a = new poly(3)
  a.setrand(6)
  b = new fpoly(3)
  b.setpoly(a)
  c = new fpoly(4)
  b.integ(c)

  qString = "Evaluate$$\\int_\{" + A + "\}^\{" + B + "\}" + a.write() + "\\,\\mathrm{d}x$$"

  hi = c.compute(B)
  lo = c.compute(A)
  lo.prod(-1)

  ans = new frac(hi.top, hi.bot)
  ans.add(lo.top, lo.bot)

  aString = "$$" + ans.write() + "$$"

  qa = [qString, aString]
  return qa



# Simple Trig Integration
makeTrigInt = ->
  a = rand(0, 7)
  b = rand(1 - Math.min(a,1), 8)

  if a
    A = randnz(4)
    term1 = abscoeff(A) + "\\sin\{" + ascoeff(a) + "x\}"
  else
    A = 0
    term1 = ""

  if b
    B = randnz(4)
    term2 = abscoeff(B) + "\\cos\{" + ascoeff(b) + "x\}"
  else
    B = 0
    term2 = ""

  U = pickrand(2, 3, 4, 6)

  qString = "Evaluate$$\\int_\{0\}^\{\\pi / " + U + "\}"
  if a
    if b
      qString += term1
      if B > 0 then qString += " + " else qString += " - "
      qString += term2
    else
      qString += term1
  else
    if B < 0 then qString += " - "
    qString += term2

  qString += "\\,\\mathrm{d}x$$"

  soln1 = new Array(6)
  soln2 = new Array(6)
  soln = new Array(6)

  if a
    soln1 = cospi(a,U)

    for i from 0 to 4 by 2
      soln1[i] *= -A

    for i from 1 to 5 by 2
      soln1[i] *= a

    if soln1[0]
      soln1[0] = soln1[1] * A + a * soln1[0]
      soln1[1] *= a
    else
      soln1[0] = A
      soln1[1] = a
  else soln1 = [0, 1, 0, 1, 0, 1]

  if b
    soln2 = sinpi(b,U)

    for i from 0 to 4 by 2
      soln2[i] *= B

    for i from 1 to 5 by 2
      soln2[i] *= b
  else soln2 = [0, 1, 0, 1, 0, 1]

  for i from 0 to 4 by 2
    soln[i] = soln1[i] * soln2[i + 1] + soln1[i + 1] * soln2[i]
    soln[i + 1] = soln1[i + 1] * soln2[i + 1]

    if soln[i + 1] < 0
      soln[i] *= -1
      soln[i + 1] *= -1

    if soln[i]
      c = gcd(Math.abs(soln[i]), soln[i + 1])
      soln[i] /= c
      soln[i + 1] /= c

  aString = "$$"

  if soln[0] and soln[1] is 1
    aString += soln[0]
  else if soln[0] > 0
    aString += "\\frac\{" + soln[0] + "\}\{" + soln[1] + "\}"
  else if soln[0] < 0
    aString += " - \\frac\{" + (-soln[0]) + "\}\{" + soln[1] + "\}"

  if soln[2] and soln[3] is 1
    if aString.length > 2
      if soln[2] > 0 then aString += " + "
    aString += soln[2] + "\\sqrt\{2\}"
  else if soln[2] > 0
    if aString.length > 2 then aString += " + "
    aString += "\\frac\{" + soln[2] + "\}\{" + soln[3] + "\}\\sqrt\{2\}"
  else if soln[2] < 0
    aString += "-\\frac\{" + (-soln[2]) + "\}\{" + soln[3] + "\}\\sqrt\{2\}"

  if soln[4] and soln[5] is 1
    if aString.length > 2
      if soln[4] > 0 then aString += "+"
    if Math.abs(soln[4]) is 1
      if soln[4] is -1 then aString += "-"
    else
      aString += soln[4]
    aString += "\\sqrt\{3\}"

  else if soln[4] > 0
    if aString.length > 2 then aString += " + "
    aString += "\\frac\{" + soln[4] + "\}\{" + soln[5] + "\}\\sqrt\{3\}"
  else if soln[4] < 0
    aString += "-\\frac\{" + (-soln[4]) + "\}\{" + soln[5] + "\}\\sqrt\{3\}"

  if aString is "$$"
    aString += "0$$"
  else
    aString += "$$"

  qa = [qString, aString]
  return qa



# Vectors
makeVector = ->
  ntol = (n) -> String.fromCharCode(n + "A".charCodeAt(0))

  A = new Array(4)
  for i from 0 to 3
    A[i] = new vector(3)
    A[i].setrand(10)

  B = new Array(0, 1, 2, 3)

  # I had to discard the FOR loop in JS because LS doesn't process the variables correctly
  i = 0
  while i < 3
    if A[B[i]].mag() < A[B[i + 1]].mag()
      c = B[i]
      B[i] = B[i + 1]
      B[i + 1] = c
      i = -1
    i++

  v = distrand(3, 0, 3)

  #qString = "Consider the four vectors$$\\begin\{array\}\{l\} \\mathbf\{A\} = " + A[0].write() + ", \\mathbf\{B\} = " + A[1].write() + ", \\mathbf\{C\} = " + A[2].write() + ", \\mathbf\{D\} = " + A[3].write() + ".\\\\ \\\\ \\mbox\{  (i) Order the vectors by magnitude.\}\\\\ \\\\ \\mbox\{ (ii) Use the scalar product to find the angles between (a) \}\\mathbf\{" + ntol(v[0]) + "\} \\mbox\{ and \}\\mathbf\{" + ntol(v[1]) + "\}, \\mbox\{(b) \}\\mathbf\{" + ntol(v[1]) + "\} \\mbox\{ and \} \\mathbf\{" + ntol(v[2]) + "\}.\\end\{array\}"
  qString = "Consider the four vectors"
  qString += "$$\\mathbf{A} = " + A[0].write() + "\\,,\\ \\mathbf{B} = " + A[1].write() + "$$"
  qString += "$$\\mathbf{C} = " + A[2].write() + "\\,,\\ \\mathbf{D} = " + A[3].write() + "$$"
  qString += "<ol class=\"exercise\"><li>Order the vectors by magnitude.</li>"
  qString += "<li>Use the scalar product to find the angles between"
  qString += "<ol class=\"subexercise\"><li>\\(\\mathbf{" + ntol(v[0]) + "}\\) and \\(\\mathbf{" + ntol(v[1]) + "}\\),</li>"
  qString += "<li>\\(\\mathbf{" + ntol(v[1]) + "}\\) and \\(\\mathbf{" + ntol(v[2]) + "}\\)</li></ol></ol>"

  aString = "<ol class=\"exercise\"><li>"
  aString += "\\(|\\mathbf{" + ntol(B[0]) + "}| = \\sqrt{" + A[B[0]].mag()
  aString += "},\\) \\(|\\mathbf{" + ntol(B[1]) + "}| = \\sqrt{" + A[B[1]].mag()
  aString += "},\\) \\( |\\mathbf{" + ntol(B[2]) + "}| = \\sqrt{" + A[B[2]].mag()
  aString += "}\\) and \\(|\\mathbf{" + ntol(B[3]) + "}| = \\sqrt{" + A[B[3]].mag()
  aString += "}\\).</li>"

  top1 = A[v[0]].dot(A[v[1]])
  bot1 = new sqroot(A[v[0]].mag() * A[v[1]].mag())
  c = gcd(Math.abs(top1), bot1.a)
  top1 /= c
  bot1.a /= c

  top2 = A[v[1]].dot(A[v[2]])
  bot2 = new sqroot(A[v[1]].mag() * A[v[2]].mag())
  c = gcd(Math.abs(top2), bot2.a)
  top2 /= c
  bot2.a /= c

  aString += "<li><ol class=\"subexercise\"><li>\\("

  if top1 is 0
    aString += "\\pi / 2"
  else if top1 is 1 and bot1.n is 1 and bot1.a is 1
    aString += "0"
  else if top1 is -1 and bot1.n is 1 and bot1.a is 1
    aString += "\\pi"
  else
    aString += "\\arccos\\left("
    if bot1.a is 1 and bot1.n is 1
      aString += top1
    else
      aString += "\\frac{" + top1 + "}{" + bot1.write() + "}"
    aString += "\\right)"

  aString += "\\)</li><li>\\("

  if top2 is 0
    aString += "\\pi / 2"
  else if top2 is 1 and bot2.n is 1 and bot2.a is 1
    aString += "0"
  else if top2 is -1 and bot2.n is 1 and bot2.a is 1
    aString += "\\pi"
  else
    aString += "\\arccos\\left("
    if bot2.a is 1 and bot2.n is 1
      aString += top2
    else
      aString += "\\frac\{" + top2 + "\}\{" + bot2.write() + "\}"
    aString += "\\right)"

  aString += "\\)</li></ol></li></ol>"

  qa = [qString, aString]
  return qa



# Lines in 3D
makeLines = ->
  a1 = randnz(3); b1 = randnz(3); c1 = randnz(3)
  d1 = rand(3); e1 = rand(3); f1 = rand(3)
  ch = rand(1,10)

  if ch < 6
    a2 = randnz(3); b2 = randnz(3); c2 = randnz(3)
    d2 = rand(3); e2 = rand(3); f2 = rand(3)
  else if ch < 10
    a2 = randnz(2); b2 = randnz(2); c2 = randnz(2)

    if (a1 * b1 * c1) % 3 is 0 and (a1 * b1 * c1) % 2 is 0
      if rand()
        if a1 % 3 is 0 then a1 /= 3
        if b1 % 3 is 0 then b1 /= 3
        if c1 % 3 is 0 then c1 /= 3
      else
        if a1 % 2 is 0 then a1 /= 2
        if b1 % 2 is 0 then b1 /= 2
        if c1 % 2 is 0 then c1 /= 2

    if (a2 * d1) % a1 is not 0
      a2 *= a1; b2 *= a1; c2 *= a1

    if (b2 * e1) % b1 is not 0
      a2 *= b1; b2 *= b1; c2 *= b1

    if (c2 * f1) % c1 is not 0
      a2 *= c1; b2 *= c1; c2 *= c1

    d2 = a2 * d1 / a1
    e2 = b2 * e1 / b1
    f2 = c2 * f1 / c1

    m1 = Math.abs(Math.min(d2, Math.min(e2, f2)))
    m2 = Math.max(d2, Math.max(e2, f2))

    if m1 > 4 then d2 += 4; e2 += 4; f2 += 4
    if m2 > 4 then d2 -= 2; e2 -= 2; f2 -= 2

    m1 = gcd(a2, b2, c2, d2, e2, f2)
    if m1 > 1
      a2/=m1; b2 /= m1; c2 /= m1; d2 /= m1; e2 /= m1; f2 /= m1;

  else
    sn = randnz(2)
    a2 = a1 * sn; b2 = b1 * sn; c2 = c1 * sn
    d2 = rand(3); e2 = rand(3); f2 = rand(3)

  p1 = new poly(1); p1[0] = d1; p1[1] = a1
  q1 = new poly(1); q1[0] = e1; q1[1] = b1
  r1 = new poly(1); r1[0] = f1; r1[1] = c1
  p2 = new poly(1); p2[0] = d2; p2[1] = a2
  q2 = new poly(1); q2[0] = e2; q2[1] = b2
  r2 = new poly(1); r2[0] = f2; r2[1] = c2

  eqn1 = p1.write("x") + " = " + q1.write("y") + " = " + r1.write("z")
  eqn2 = p2.write("x") + " = " + q2.write("y") + " = " + r2.write("z")

  qString = "Consider the lines$$" + eqn1 + "$$and$$" + eqn2 + "$$Find the angle between them<br>and determine whether they<br>intersect."
  aString = ""

  if (a1 * b2) is (b1 * a2) and (b1 * c2) is (c1 * b2)
    if (a2 * b2 * d1 - b2 * a1 * d2) is (a2 * b2 * e1 - a2 * b1 * e2) and (b2 * c2 * e1 - c2 * b1 * e2) is (b2 * c2 * f1 - b2 * c1 * f2)
      aString = "\\mbox{The lines are identical.}"
    else
      aString = "The lines are parallel and do not meet."

  else
    cosbot = new sqroot((b1^2 * c1^2 + c1^2 * a1^2 + a1^2 * b1^2) * (b2^2 * c2^2 + c2^2 * a2^2 + a2^2 * b2^2))
    costh = new frac(b1 * b2 * c1 * c2 + c1 * c2 * a1 * a2 + a1 * a2 * b1 * b2, cosbot.a)
    cosbot.a = costh.bot

    aString = "The angle between the lines is$$"

    if costh.top is 0
      aString += "\\pi / 2.$$"
    else
      aString += "\\arccos\\left("
      if cosbot.n is 1
        aString += costh.write()
      else
        aString += "\\frac{" + costh.top + "}{" + cosbot.write() + "}"
      aString += "\\right).$$"

    mu = new frac()
    lam1 = new frac()
    lam2 = new frac()

    if(a1 * b2 - a2 * b1)
      mu.set(a2 * b2 * (e1 - d1) - a2 * b1 * e2 + a1 * b2 * d2, a1 * b2 - a2 * b1)
      lam1.set(b1 * mu.top - b1 * e2 * mu.bot + e1 * b2 * mu.bot, mu.bot * b2)
      lam2.set(c1 * mu.top - c1 * f2 * mu.bot + f1 * c2 * mu.bot, mu.bot * c2)
    else
      mu.set(b2 * c2 * (f1 - e1) - b2 * c1 * f2 + b1 * c2 * e2, b1 * c2 - b2 * c1)
      lam1.set(c1 * mu.top - c1 * f2 * mu.bot + f1 * c2 * mu.bot, mu.bot * c2)
      lam2.set(a1 * mu.top - a1 * d2 * mu.bot + d1 * a2 * mu.bot, mu.bot * a2)

    if lam1.equals(lam2)
      xm = new frac(lam1.top - d1 * lam1.bot, a1 * lam1.bot)
      ym = new frac(lam1.top - e1 * lam1.bot, b1 * lam1.bot)
      zm = new frac(lam1.top - f1 * lam1.bot, c1 * lam1.bot)
      aString += "The lines meet at the point$$\\left(" + xm.write() + "," + ym.write() + "," + zm.write() + "\\right).$$"
    else
      aString += "The lines do not meet."

  qa = [qString, aString]
  return qa



# Equation of lines in 2D
# This isn’t perfect, but it does the job. Some prettying of the output wouldn’t be amiss.
makeLinesEq = ->

  makeLines1 = ->
    a = rand(6); b = rand(6); c = rand(6); d = rand(6)

    while a is c and b is d # check for degeneracy
      c = rand(6); d = rand(6)

    qString = "Find the equation of the line passing through \\((" + a + "," + b + ")\\) and \\((" + c + "," + d + ")\\)."

    # horizontal lines
    if b is d then aString = "$$y = " + b + ".$$"

    # vertical lines
    if a is c then aString = "$$x = " + a + ".$$"

    # final case
    else
      if (d - b) is (c - a) then grad = ""
      else if (d - b) is (a - c) then grad = " - "
      else
        grad = new frac(d - b, c - a)
        grad = grad.write()

    intercept = new frac(Math.abs(b * (c - a) - (d - b) * a), Math.abs(c - a))
    intercept = intercept.write()

    if (b - (d - b) / (c - a) * a) < 0
      intercept = " - " + intercept
    else if (b * (c - a)) is ((d - b) * a)
      intercept = ""
    else
      intercept = " + " + intercept

    aString = "$$y = " + grad + "x" + intercept + "\\qquad \\text{or} \\qquad " + lineEq1(a, b, c, d) + ".$$"

    qa = [qString, aString]
    return qa

  qa = makeLines1()
  return qa



# Lines parallel or perpendicular to a point
makeLineParPerp = ->
  a = rand(6); b = rand(6); c = rand(6)
  m = rand(6) # If m = 6 then we treat it as vertical

  makeLinePar = (a, b, m, c) ->

    qString = "Find the equation of the line passing through \\((" + a + "," + b + ")\\) and parallel to the line "

    if Math.abs(m) is 6
      while a is c
        c = rand(5)
      qString += "\\(x = " + c + "\\)."
      aString = "$$x = " + a + ".$$"

    else
      if rand()
        qString += "\\(" + lineEq1(0, c, 1, m + c) + ".\\)"
      else
        qString += "\\(" + lineEq2(m, c) + ".\\)"

    intercept = b - m * a

    if m is 0
      aString = "$$y = " + b + ".$$"
    else
      aString = "$$" + lineEq2(m, intercept) + "\\qquad\\text{or}\\qquad " + lineEq1(0, intercept, 1, m + intercept) + "$$"

    qa = [qString, aString]
    return qa

  makeLinePerp = (a, b, m, c) ->
    qString = "Find the equation of the line passing through \\((" + a + "," + b + ")\\) and perpendicular to the line "

    # Vertical lines
    if Math.abs(m) is 6
      while a is c
        c = rand(5)
      qString += "\\(x = " + c + "\\)."
      aString = "$$y = " + b + ".$$"

    # Horizontal lines
    else if m is 0
      while a is 0
        c = rand(5)
      qString += "\\(y = " + c + "\\)."
      aString = "$$x = " + a + ".$$"

    else

      # Equation of line in the question
      if rand()
        qString += "\\(" + lineEq1(0, c, 1, m + c) + ".\\)"
      else
        qString += "\\(" + lineEq2(m, c) + ".\\)"

      aString = "$$y = "

      grad = new frac(-1, m)
      intercept = new frac(b * m + a, m)
      C = (b * m + a) / m

      # Gradient in y = mx + c
      if m is -1 then aString += "x"
      else if m is 1 then aString += " - x"
      else aString += grad.write() + "x"

      # Intercept in y = mx + c
      if C % 1 is 0 and C is not 0
        aString += signedNumber(C)
      else
        if C > 0
          aString += " + " + intercept.write()
        else if C < 0
          aString += intercept.write()

      aString += "\\qquad\\text{or}\\qquad "

      if m is 1
        aString += "x + y"
      else if m is -1
        aString += "x - y"
      else
        aString += "x" + signedNumber(m) + "y"

      if (-b * m - a!) is 0
        aString += signedNumber(-b * m - a)

      aString += " = 0.$$"

    qa = [qString, aString]
    return qa

  qa = pickrand(makeLinePar, makeLineParPerp)(a, b, m, c)
  return qa



# Equations of circles
makeCircleEq = ->
  r = rand(2,7)
  a = rand(6)
  b = rand(6)

  makeCircleEq1 = (a,b,r) ->
    qString = "Find the equation of the circle with centre \\((" + a + "," + b + ")\\) and radius \\(" + r + "\\)."

    if a is 0 and b is 0
      aString = "$$" + circleEq1(a, b, r) + ".$$"
    else
      aString = "$$" + circleEq1(a, b, r) + "\\qquad\\text{or}\\qquad " + circleEq2(a, b, r) + ".$$"

    qa = [qString, aString]
    return qa

  makeCircleEq2 = (a,b,r) ->
    qString = "Find the centre and radius of the circle with equation"
    if rand()
      qString += "$$" + circleEq1(a, b, r) + ".$$"
    else
      qString += "$$" + circleEq2(a, b, r) + ".$$"

    aString = "The circle has centre \\((" + a + "," + b + ")\\) and radius \\(" + r + " \\)."

    qa = [qString, aString]
    return qa

  if rand() then qa = makeCircleEq1(a, b, r) else qa = makeCircleEq2(a, b, r)
  return qa



makeCircLineInter = ->

  makeLLInter = ->
    m1 = rand(6); m2 = rand(6); c1 = rand(6); c2 = rand(6)

    # Artificially increase the number of parallel lines
    if rand() then m1 = m2

    while m1 is m2 and c1 is c2
      m2 = rand(6); c2 = rand(6)

    qString = "Find all the points where the line \\("

    if rand()
      qString += lineEq1(0, c1, 1, m1 + c1)
    else
      qString += lineEq2(m1, c1)

    qString += "\\) and the line \\("

    if rand()
      qString += lineEq1(0,c2,1,m2 + c2)
    else
      qString += lineEq2(m2,c2)

    qString += "\\) intersect."

    if m1 is m2
      aString = "The lines do not intersect."
    else
      xint = new frac(c2 - c1, m1 - m2)
      yint = new frac(m1 * (c2 - c1) + c1 * (m1 - m2),m1 - m2)
      aString = "The lines intersect in a single point, which occurs at \\(\\left(" + xint.write() + "," + yint.write() + "\\right)\\)."

    qa = [qString, aString]
    return qa

  makeCLInter = ->
    a = rand(6); b = rand(6); r = rand(2,7)
    m = rand(6); c = rand(6)

    qString = "Find all the points where the line \\("

    if rand()
      qString += lineEq1(0, c, 1, m + c)
    else
      qString += lineEq2(m, c)

    qString += "\\) and the circle \\( "

    if rand()
      qString += circleEq1(a, b, r)
    else
      qString += circleEq2(a, b, r)

    qString += "\\) intersect."

    # By substitution, we can get an equation of the form Ax^ + Bx + C = 0
    # The roots are the points of intersection
    # We compute these variables:
    A = m^2 + 1
    B = - 2 * a + 2 * m * (c - b)
    C = (c - b) ^ 2 - r ^ 2 + a ^ 2

    # Discriminant for the roots
    disc = B ^ 2 - 4 * A * C
    sq = new sqroot(disc)

    if disc > 0
      aString = "The line and the circle intersect in two points, specifically "

      # First solution x1 = (-B + sqrt(disc)) / 2A, y = m * x1 + c
      aString += "$$\\left("
      aString += simplifySurd(-B, sq.a, sq.n, 2 * A)
      aString += "," + simplifySurd(-m * B + 2 * c * A, m * sq.a, sq.n, 2 * A)
      aString += "\\right)"

      aString += "\\qquad\\text{and}\\qquad "

      # Second solution x2 = (-B - sqrt(disc)) / 2A, y = m * x2 + c
      aString += "\\left("
      aString += simplifySurd(-B, -sq.a, sq.n, 2 * A)
      aString += "," + simplifySurd(-m * B + 2 * c * A, -m * sq.a, sq.n, 2 * A)
      aString += "\\right)$$"

    else if disc < 0
      aString = "The line and the circle do not intersect in any points."

    else if disc is 0
      # This never happens in practice; do we want to artificially increase it?
      xint = new frac(-B, 2 * A)
      yint = new frac(-B * m + c * 2 * A, 2 * A)
      aString = "The line and the circle intersect in exactly one point, which occurs at \\(\\left(" + xint.write() + "," + yint.write() + "\\right)\\)."

    qa = [qString, aString]
    return qa

  makeCCInter = ->
    a1 = rand(6); b1 = rand(6); r1 = rand(2,7)
    a2 = rand(6); b2 = rand(6); r2 = rand(2,7)

    while (a1 is a2) and (b1 is b2) and (r1 is r2)
      a2 = rand(6); b2 = rand(6); r2 = rand(2,7)

    qString = "Find all the points where the circle \\("

    if rand()
      qString += circleEq1(a1, b1, r1)
    else
      qString += circleEq2(a1, b1, r1)

    qString += "\\) and the circle \\("

    if rand()
      qString += circleEq1(a2, b2, r2)
    else
      qString += circleEq2(a2, b2, r2)

    qString += "\\) intersect."

    D = Math.sqrt((b2 - b1) ^ 2 + (a2 - a1) ^ 2)
    DD = (b2 - b1) ^ 2 + (a2 - a1) ^ 2
    R = r1 + r2
    RR = r1 ^ 2 - r2 ^ 2
    S = Math.abs(r1 - r2)

    # The formulae for the case of two intersections is cribbed from
    # http:#www.ambrsoft.com / TrigoCalc / Circles2 / Circle2.htm

    if R > D and D > S
      aString = "The circles intersect in two points, which are"

      d = new sqroot(-DD ^ 2 + 2 * DD * r1 ^ 2 - r1 ^ 4 + 2 * DD * r2 ^ 2 + 2 * r1 ^ 2 * r2 ^ 2 - r2 ^ 4)

      # First solution
      aString += "$$\\left("
      aString += simplifySurd((a1 + a2) * DD + (a2 - a1) * RR, (b1 - b2) * d.a, d.n, 2 * DD) + ","
      aString += simplifySurd((b1 + b2) * DD + (b2 - b1) * RR, (a2 - a1) * d.a, d.n, 2 * DD)
      aString += "\\right)"

      aString += "\\qquad\\text{and}\\qquad "

      # Second solution
      aString += "\\left("
      aString += simplifySurd((a1 + a2) * DD + (a2 - a1) * RR, (b2 - b1) * d.a, d.n, 2 * DD) + ","
      aString += simplifySurd((b1 + b2) * DD + (b2 - b1) * RR, (a1 - a2) * d.a, d.n, 2 * DD)
      aString += "\\right)"

      aString += "$$"

    else if DD is R ^ 2
      x1 = new frac(a1 * R + r1 * (a2 - a1), R)
      y1 = new frac(b1 * R + r1 * (b2 - b1), R)
      aString = "The circles intersect in a single point, which is \\((" + x1.write() + "," + y1.write() + ")\\)."

    else if D > R or D <= S
      aString = "The two circles do not intersect in any points."

    else
      # This shouldn't occur in practice, but I'd rather get a unique error than debug a bunch of JavaScript
      aString = "Uh oh, something went wrong. Please try another question."

    qa = [qString, aString]
    return qa

  qa = pickrand(makeCLInter, makeLLInter, makeCCInter)()
  return qa



makeIneq = ->

  makeIneq2 = ->
    roots = distrandnz(2, 6)
    B = - roots[0] - roots[1]
    C = roots[0] * roots[1]

    qString = "By factorising a suitable polynomial, or otherwise, find the values of \\(x\\) which satisfy$$"
    p = new poly(2)

    switch rand(1, 3)
      case 1
        p[0] = 0; p[1] = B; p[2] = 1
        qString += p.write() + " < " + (-C)

      case 2
        p[0] = C; p[1] = 0; p[2] = 1
        qString += p.write() + " < "
        if B then qString += ascoeff(-B) + "x" else qString += "0"

      case 3
        p[0] = -C; p[1] = -B; p[2] = 0
        qString += "x^2" + " < " + p.write()

    qString += "$$"
    aString = "$$" + Math.min(roots[0],roots[1]) + " < x < " + Math.max(roots[0], roots[1]) + "$$"

    qa = [qString, aString]
    return qa

  makeIneq3 = ->
    a = randnz(5); b = randnz(5); c = rand(2)

    qString = "By factorising a suitable polynomial, or otherwise, find the values of \\(y\\) which satisfy$$"

    B = - (a + b + c)
    C = a * b + b * c + c * a
    D = - a * b * c

    p = new poly(3); p.set(0,0,0,1)
    q = new poly(2); q.set(0,0,0)

    switch rand(1, 3)
      | 1 => p[2] = B; q[1] = - C; q[0] = - D
      | 2 => p[1] = C; q[2] = - B; q[0] = - D
      | 3 => p[0] = D; q[2] = - B; q[1] = - C

    qString += p.write('y') + " < " + q.write('y') + "$$"

    m = [a,b,c]
    r = ranking(m)
    aString = "$$y < " + m[r[0]]

    if m[r[1]] is not m[r[2]]
      aString += "$$and$$" + m[r[1]] + " < y < " + m[r[2]] + "$$"
    else
      aString += "$$"

    qa = [qString, aString]
    return qa

  qa = pickrand(makeIneq2, makeIneq3)()
  return qa



makeAP = ->
  m = rand(2, 6)
  n = rand(m + 2, 11)
  k = rand(Math.max(n + 3, 10), 40)
  a1 = new frac()
  a2 = new frac()

  qString = "An arithmetic progression has " + ordt(m) + " term \\(\\alpha\\) and " + ordt(n) + " term \\(\\beta\\). Find the "
  if rand() is 0
    qString += "sum to \\(" + k + "\\) terms."
    a1.set(k * (2 * n - 1 - k), 2 * (n - m))
    a2.set(k * (1 + k - 2 * m), 2 * (n - m))
  else
    qString += "value of the \\(" + ordt(k) + "\\) term."
    a1.set(n - k, n - m)
    a2.set(k - m, n - m)

  aString = "$$" + fcoeff(a1, "\\alpha") + (if a2.top > 0 then " + " else " - ") + fbcoeff(a2, "\\beta") + "$$"

  qa = [qString, aString]
  return qa



makeFactor = ->

  makeFactor1 = ->
    a = randnz(4); b = randnz(7); c = randnz(7)
    u = new poly(1); v = new poly(1); w = new poly(1)
    u[1] = v[1] = w[1] = 1
    u[0] = a; v[0] = b; w[0] = c
    x = polyexpand(polyexpand(u, v), w)

    qString = "Divide $$" + x.write() + "$$ by $$(" + u.write() + ")$$ and hence factorise it completely."
    aString = "$$" + express([a, b, c]) + "$$"

    qa = [qString, aString]
    return qa

  makeFactor2 = ->

    a = randnz(2); b = randnz(5); c = randnz(5)
    u = new poly(1); v = new poly(1); w = new poly(1)
    u[1] = v[1] = w[1] = 1
    u[0] = a; v[0] = b; w[0] = c
    x = polyexpand(polyexpand(u, v), w)

    qString = "Use the factor theorem to factorise $$" + x.write() + ".$$"
    aString = "$$" + express([a, b, c]) + "$$"

    qa = [qString, aString]
    return qa

  makeFactor3 = ->
    a = randnz(2); b = randnz(4); c = randnz(4); d = randnz(4)
    if d is c then d = -d
    u = new poly(1); v = new poly(1); w = new poly(1); y = new poly(1)
    u[1] = v[1] = w[1] = y[1] = 1
    u[0] = a; v[0] = b; w[0] = c; y[0] = d
    x = polyexpand(polyexpand(u, v), w)
    z = polyexpand(polyexpand(u, v), y)

    qString = "Simplify$$\\frac{" + x.write() + "}{" + z.write() + "}.$$"
    aString = "$$\\frac{" + w.write() + "}{" + y.write() + "}$$"

    qa = [qString, aString]
    return qa

  return pickrand(makeFactor1, makeFactor2, makeFactor3)()



makeQuadratic = ->
  qString = "Find the real roots, if any, of$$"

  if rand()
    p = new poly(2)
    p.setrand(5)
    p[2] = 1
    qString += p.write()

    dcr = p[1] ^ 2 - 4 * p[0]

    if dcr < 0
      aString = "There are no real roots."

    else if dcr is 0
      r1 = new frac(-p[1], 2)
      aString = "$$x = " + r1.write() + "$$is a repeated root."

    else
      disc = new sqroot(dcr)
      r1 = new frac(-p[1], 2)

      if disc.n is 1
        r1.add(disc.a, 2)
        aString = "$$x = " + r1.write() + "\\mbox{ and }x = "
        r1.add(-disc.a)
        aString += r1.write() + "$$"

      else
        r2 = new frac(disc.a, 2)

        aString = "$$x = "
        if r1.top
          aString += r1.write()
        aString += + "\\pm"

        if r2.top is not 1 or r2.bot is not 1
          aString += r2.write()
        aString += "\\sqrt{" + disc.n + "}$$"

  else
    roots = distrandnz(2, 5)
    p = new poly(2)
    p[2] = 1; p[1] = -roots[0] - roots[1]; p[0] = roots[0] * roots[1]
    qString += p.write()
    aString = "$$x = " + roots[0] + "\\mbox{ and }x = " + roots[1] + "$$"

  qString += " = 0$$"

  qa = [qString, aString]
  return qa



makeComplete = ->
  a = randnz(4); b = randnz(5)
  p = new poly(2)
  p[2] = 1; p[1] = - 2 * a; p[0] = a^2 + b

  if rand()
    qString = "By completing the square, find (for real \\(x\\)) the minimum value of$$" + p.write() + ".$$"
    aString = "The minimum value is \\(" + b + ",\\) which occurs at \\(x = " + a + "\\)."

  else
    c = randnz(3)
    d = randnz(c + 2,c + 4)

    qString = "Find the minimum value of$$" + p.write() + "$$in the range$$" + c + "\\leq x\\leq" + d + ".$$"

    if c <= a and a <= d
      aString = "The minimum value is \\(" + b + "\\) which occurs at \\(x = " + a + "\\)"
    else if a < c
      aString = "The minimum value is \\(" + (c^2 - 2 * a * c + a^2 + b) + "\\) which occurs at \\(x = " + c + "\\)"
    else
      aString = "The minimum value is \\(" + (d^2 - 2 * a * d + a^2 + b) + "\\) which occurs at \\(x = " + d + "\\)"

  qa = [qString, aString]
  return qa



makeBinExp = ->
  a = rand(1,3)
  b = randnz(2)
  n = rand(2, 5)
  m = rand(1, n - 1)
  pow = new frac(m, n)

  p = new fpoly(1)
  p[0] = new frac(1, 1)
  p[1] = new frac(b, a)

  qString = "Find the first four terms in the expansion of $$\\left(" + p.rwrite() + "\\right)^{" + pow.write() + "}$$"

  q = new fpoly(3)
  q[0] = new frac(1)
  q[1] = new frac(m * b, n * a)
  q[2] = new frac(m * (m - n) * b^2 ,2 * n^2 * a^2)
  q[3] = new frac(m * (m - n) * (m - 2 * n) * b^3, 6 * n^3 * a^3)

  aString = "$$" + q.rwrite() + "$$"

  qa = [qString, aString]
  return qa



makeLog = ->

  makeLog1 = ->
    a = pickrand(2, 3, 5)
    m = rand(1, 4)
    n = rand(1, 4); if n >= m then n++
    qString = "If \\(" + a ^ m + " = " + a ^ n + "^{x},\\) then find \\(x\\)."

    r = new frac(m,n)
    aString = "$$x = " + r.write() + "$$"

    qa = [qString, aString]
    return qa

  makeLog2 = ->
    a = rand(2,9)
    b = rand(2,5)
    c = b ^ 2
    qString = "Find \\(x\\) if \\(" + c + "\\log_{x}" + a + " = \\log_{" + a + "}x\\)."
    aString = "$$x = " + a ^ b + "\\mbox{ or }x = \\frac{1}{" + a ^ b + "}$$"

    qa = [qString, aString]
    return qa

  makeLog3 = ->
    a = rand(2,7)
    b = Math.floor(Math.pow(a,7 * Math.random()))
    qString = "If \\(" + a + "^{x} = " + b + "\\), then find \\(x\\) to three decimal places."
    c = new Number(Math.log(b) / Math.log(a))
    aString = "$$x = " + c.toFixed(3) + "$$"

    qa = [qString, aString]
    return qa

  qa = pickrand(makeLog1, makeLog2, makeLog3)()
  return qa



makeStationary = ->

  makeStationary2 = -> # Quadratics
    p = new poly(2)
    p.set(randnz(4), randnz(8), randnz(4))
    d = new frac(-p[1],2 * p[2])

    qString = "Find the stationary point of $$y = " + p.write() + ",$$ and state whether it is a maximum or a minimum."
    aString = "The stationary point occurs at \\(x = " + d.write() + "\\), and it is a "
    if p[2] > 0 then aString += "minimum." else aString += "maximum."

    qa = [qString, aString]
    return qa

  makeStationary3 = -> # Cubics
    p = new poly(3)
    d = randnz(4); c = randnz(3); b = randnz(3); a = randnz(5)

    if (Math.abs(c * (b + a)) % 2) is 1 then b++ # I hope it doesn't matter that this can make b == 0.
    p.set(d, 3 * c * a * b, - 3 * c * (a + b) / 2, c)

    qString = "Find the stationary points of $$y = " + p.write() + ",$$ and state their nature."

    if a is b
      aString = "The stationary point occurs at \\(x = " + a + ",\\) and is a point of inflexion."
    else if c > 0
      aString = "The stationary points occur at \\(x = " + Math.min(a,b) + "\\), a maximum, and \\(x = " + Math.max(a,b) + "\\), a minimum"
    else
      aString = "The stationary points occur at \\(x = " + Math.min(a,b) + "\\), a minimum, and \\(x = " + Math.max(a,b) + "\\), a maximum"

    qa = [qString, aString]
    return qa

  if rand() then qa = makeStationary2() else qa = makeStationary3()
  return qa



makeTriangle = ->

  makeTriangle1 = ->

    a = rand(3,8)
    b = rand(a + 1,16)
    m = distrand(3, 0, 2)

    s = ["AB", "BC", "CA"]
    hyp = s[m[0]]
    shortv = s[m[1]]
    other = s[m[2]]

    switch hyp
      | "AB" => angle = "C"
      | "BC" => angle = "A"
      | "CA" => angle = "B"

    qString = "In triangle \\(ABC\\), \\(" + shortv + " = " + a + "\\), \\(" + hyp + " = " + b + ",\\) and angle \\(" + angle + "\\) is a right angle. Find the length of \\(" + other + "\\)."
    length = new sqroot(b ^ 2 - a ^ 2)
    aString = "$$" + other + " = " + length.write() + "$$"

    qa = [qString, aString]
    return qa

  makeTriangle2 = ->
    a = rand(2,8)
    b = rand(1,6)
    c = rand(Math.max(a,b) - Math.min(a,b) + 1, a + b - 1)
    qString = "In triangle \\(ABC\\), \\(AB = " + c + "\\), \\(BC = " + a + ",\\) and \\(CA = " + b + ".\\) Find the angles of the triangle."

    aa = new frac(b^2 + c^2 - a^2, 2 * b * c)
    bb = new frac(c^2 + a^2 - b^2, 2 * c * a)
    cc = new frac(a^2 + b^2 - c^2, 2 * a * b)
    aString = "$$\\cos A = " + aa.write() + ",\\cos B = " + bb.write() + ",\\cos C = " + cc.write() + ".$$"

    qa = [qString, aString]
    return qa

  makeTriangle3 = ->
    a = rand(1,6)
    cc = pickrand(3,4,6)
    lb = a * Math.ceil(Math.sin(Math.PI / cc))
    c = rand(lb, Math.max(5, lb + 1))
    qString = "In triangle \\(ABC\\), \\(AB = " + c + "\\), \\(BC = " + a + "\\) and angle \\(C = \\frac{\\pi}{" + cc + "}\\). Find angle \\(A\\)."

    d = new frac(a, 2 * c)
    aString = "$$A = \\arcsin\\left(" + d.write()
    if cc is 3
      aString += "\\sqrt{3}"
    else if cc is 4
      aString += "\\sqrt{2}"
    aString += "\\right)$$"

    qa = [qString, aString]
    return qa

  qa = pickrand(makeTriangle1, makeTriangle2, makeTriangle3)()
  return qa



makeCircle = ->
  r = rand(2, 8)
  bot = rand(2, 9)
  top = rand(1, 2 * bot - 1)
  prop = new frac(top,bot)

  qString = "Find, for a sector of angle \\("
  if prop.bot is 1
    qString += ascoeff(prop.top) + "\\pi"
  else
    qString += "\\frac{" + ascoeff(prop.top) + "\\pi}{" + prop.bot + "}"
  qString += "\\) of a disc of radius \\(" + r + ":\\)<ul class=\"exercise\"><li> the length of the perimeter and</li><li>the area.</li></ul>"

  length = new frac(prop.top * r, prop.bot)
  area = new frac(prop.top * r^2, 2 * prop.bot)
  aString = "<ul class=\"exercise\"><li>\\(" + (r * 2) + " + " + length.write() + "\\pi\\)</li><li>\\(" + area.write() + "\\pi\\)</li></ul>"

  qa = [qString, aString]
  return qa



makeSolvingTrig = ->
  A = pickrand(1,3,4,5)
  alpha = pickrand(3,4,6)
  c = new frac(A,2)

  qString = "Write $$" + c.write()

  if alpha is 6
    qString += "\\sqrt{3}"
  else if alpha is 4
    qString += "\\sqrt{2}"

  qString += "\\sin{\\theta} + " + c.write()

  if alpha is 4
    qString += "\\sqrt{2}"
  else if alpha is 3
    qString += "\\sqrt{3}"

  qString += "\\cos{\\theta}$$ in the form \\(A\\sin(\\theta + \\alpha),\\) where \\(A\\) and \\(\\alpha\\) are to be determined."

  if A is 1 then aString = "$$" else aString = "$$" + A
  aString += "\\sin\\left(\\theta + \\frac{\\pi}{" + alpha + "}\\right)$$"

  qa = [qString, aString]
  return qa



makeVectorEq = ->
  a = new vector(3)
  a.setrand(6)
  b = new vector(3)
  b.setrand(6)
  l = distrand(3, 5)
  v = new Array(3)

  for i from 0 to 2
    v[i] = new vector(3)
    v[i].set(a[0] + l[i] * b[0], a[1] + l[i] * b[1], a[2] + l[i] * b[2])

  qString = "Show that the points with position vectors$$" + v[0].write() + "\\,," + v[1].write() + "\\,," + v[2].write() + "$$"
  qString += "lie on a straight line, and give the equation of the line in the form \\(\\mathbf{r} = \\mathbf{a} + \\lambda\\mathbf{b}\\)."
  aString = '$$' + a.write() + " + \\lambda\\," + b.write() + '$$'

  qa = [qString, aString]
  return qa



makeModulus = ->
  parms = 0
  fn = 0
  data = []
  graph = null
  drawIt

  if rand()
    a = randnz(4)
    aa = Math.abs(a)
    l = rand(-aa - 6, - aa - 2)
    r = rand(aa + 2, aa + 6)
    qString = "Sketch the graph of \\(|" + a + " - |x||\\) for \\(" + l + "\\leq{x}\\leq" + r + "\\)."

    drawIt = (parms) ->
      d1 = []
      n = 0
      for i from parms[1] to parms[2] by 0.5
        n++
        d1.push([i, Math.abs(parms[0] - Math.abs(i))])
        if n > 50 then i = parms[2] # prevent infiniloops

      #$.plot($("#graph"), [d1])
      return [d1]

    aString = '%GRAPH%'
    params = [a, l, r]

  else
    a = distrandnz(2, 4)
    s = [rand(), rand()]
    xa = Math.max(Math.abs(a[0]), Math.abs(a[1]))
    l = rand(-xa - 6, - xa - 2)
    r = rand(xa + 2, xa + 6)

    qString = "Sketch the graph of \\((" + a[0]
    if s[0] then qString += " + " else qString += " - "
    qString += "|x|)(" + a[1]
    if s[1] then qString += " + " else qString += " - "
    qString += "|x|)\\) for \\(" + l + "\\leq{x}\\leq" + r + "\\)."

    drawIt = (parms) ->
      a = parms[0]; s = parms[1]; l = parms[2]; r = parms[3]
      d1 = []
      n = 0

      for i from l to r by 0.25
        n++
        if s[0] then s0 = 1 else s0 = -1
        if s[1] then s1 = 1 else s1 = -1

        d1.push([i, (a[0] + s0 * Math.abs(i)) * (a[1] + s1 * Math.abs(i))])

        if n > 100 then i = r # prevent infiniloops

      #$.plot($("#graph"), [d1])
      return [d1]

    aString = '%GRAPH%'
    params = [a, s, l, r]

  qa = [qString, aString, drawIt, params]
  return qa



makeTransformation = ->
  fnn = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", "{z}^{2}")
  which = rand(0, 6)
  fnf = [
    Math.log, (x) -> 1 / Math.sin(x),
    (x) -> 1 / Math.cos(x),
    Math.sin, (x) -> Math.tan(x),
    Math.cos, (x) -> x ^ 2
  ][which]

  parms = 0
  fn = 0
  data = ""

  p = new poly(1); p.setrand(2)
  q = new poly(1); q.setrand(3)
  q[1] = Math.abs(q[1])

  if rand() then p[1] = 1
  else if rand() then q[1] = 1
  else if rand() then p[0] = 0
  else q[0] = 0

  if which
    l = rand(-5, 2)
  else
    l = Math.max(Math.ceil((1 - q[0]) / q[1]), 0)
  r = l + rand(4, 8)

  qString = "Let \\(f(x) = " + fnn[which].replace(/z/g, 'x') + "\\). Sketch the graphs of \\(y = f(x)\\) and \\(y = " + p.write("f(" + q.write() + ")") + "\\) for \\(" + l
  if which is 0 and l is 0 then qString += " < " else qString += "\\leq "
  qString += "x \\leq " + r + "\\)."
  #console.log(qString)

  drawIt = (parms) ->
    p = parms[0]; q = parms[1]; f = parms[2]; l = parms[3]; r = parms[4]
    d1 = []; d2 = []
    n = 0

    for i from l to r by 0.01
      n++
      y1 = f(i)

      if Math.abs(y1) > 20 then y1 = null
      d1.push([i, y1])

      y2 = p.compute(f(q.compute(i)))
      if Math.abs(y2) > 20 then y2 = null

      d2.push([i, y2])
      if n > 2500 then i = r # prevent infiniloops

    #$.plot($("#graph"), [d1, d2])
    return [d1, d2]

  aString = '%GRAPH%'

  qa = [qString, aString, drawIt, [p, q, fnf, l, r]]
  return qa



makeComposition = ->
  p = new poly(rand(1, 2)); p.setrand(2)

  if p.rank is 1 and p[0] is 0 and p[1] is 1
    p[0] = randnz(2)

  fnf = new Array(Math.sin, Math.tan, Math.cos, 0)
  fnn = new Array("\\sin(z)", "\\tan(z)", "\\cos(z)", p.write("z"))
  which = distrand(2, 0, 3)
  parms = 0
  fn = 0
  data = ""
  l = rand(-4, 0)
  r = rand(Math.max(l + 5, 2), 8)

  qString = "Let \\(f(x) = " + fnn[which[0]].replace(/z/g, 'x') + ", g(x) = " + fnn[which[1]].replace(/z/g, 'x') + ".\\) Sketch the graph of \\(y = f(g(x))\\) (where it exists) for \\(" + l + "\\leq{x}\\leq" + r + "\\) and \\(-12\\leq{y}\\leq12.\\)"

  drawIt = (parms) ->
    f = parms[0]; g = parms[1]; p = parms[2]; l = parms[3]; r = parms[4]
    d1 = []
    n = 0

    for i from l to r by 0.01
      n++

      if g then y2 = g(i) else y2 = p.compute(i)

      if y2
        if f then y3 = f(y2) else y3 = p.compute(y2)
      else
        y3 = null

      if Math.abs(y3) > 12
        y3 = null

      d1.push([i, y3])
      if n > 2500 then i = r # prevent infiniloops

    #$.plot($("#graph"), [d1])
    return [d1]

  aString = '%GRAPH%'
  qa = [qString, aString, drawIt, [fnf[which[0]], fnf[which[1]], p, l, r]]
  return qa



makeParametric = ->
  p = new poly(rand(1, 2))
  p.setrand(2)

  if p.rank is 1 and p[0] is 0 and p[1] is 1
    p[0] = randnz(2)

  fnf = new Array(Math.log, (x) -> (1 / Math.sin(x)), (x) -> (1 / Math.cos(x)), Math.sin, Math.tan, Math.cos, 0)
  fnn = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", p.write('z'))
  which = distrand(2, 0, 6)
  parms = 0
  fn = 0
  data = ""

  qString = "Sketch the curve in the \\(xy\\) plane given by \\(x = " + fnn[which[0]].replace(/z/g, 't') + ", y = " + fnn[which[1]].replace(/z/g, 't') + ". t\\) is a real parameter which ranges from \\("

  if which[0] and which[1]
    qString += " - 10"
  else
    qString += "0"

  qString += " \\mbox{ to } 10.\\)"

  drawIt = (parms) ->
    f = parms[0]; g = parms[1]; p = parms[2]; l = parms[3]
    d1 = []

    for i from l to 10 by 0.01
      if f then x = f(i) else x = p.compute(i)
      if Math.abs(x) > 12 then x = null

      if g then y = g(i) else y = p.compute(i)
      if Math.abs(y) > 12 then y = null

      if x and y then d1.push([x, y]) else d1.push([null, null])

    #$.plot($("#graph"), [d1])
    return [d1]

  aString = '%GRAPH%'

  if which[0] and which[1]
    qa = [qString, aString, drawIt ,[fnf[which[0]], fnf[which[1]], p, -10]]
  else
    qa = [qString, aString, drawIt ,[fnf[which[0]], fnf[which[1]], p, 0]]
  return qa



makeImplicit = ->

  makeImplicit1 = ->
    a1 = rand(1,3)
    b1 = randnz(4)
    c1 = rand(1,3)
    d1 = randnz(4)

    if (d1 * a1 - b1 * c1) is 0
      if d1 > 0 then d1++ else d1--

    a2 = randnz(3)
    b2 = randnz(4)
    c2 = rand(1,3)
    d2 = randnz(4)

    if (d2 * a2 - b2 * c2) is 0
      if d2 > 0 then d2++ else d2--

    t = randnz(3)

    while (c1 * t + d1) is 0 or (c2 * t + d2) is 0
      if t > 0 then t++ else t--

    qString = "If $$y = \\frac{" + p_linear(a1, b1).write('t') + "}{" + p_linear(c1, d1).write('t') + "}$$ and $$x = \\frac{" + p_linear(a2, b2).write('t') + "}{" + p_linear(c2, d2).write('t') + "},$$find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) when \\(t = " + t + "\\)."

    a = new frac((a1 * d1 - b1 * c1) * (c2 * t + d2) ^ 2 (a2 * d2 - b2 * c2) * (c1 * t + d1) ^ 2)
    aString = "$$" + a.write() + "$$"

    qa = [qString, aString]
    return qa

  makeImplicit2 = ->
    fns = new Array("\\ln(z)", "e^{z}", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)")
    difs = new Array("\\frac{1}{z}", "e^{z}", " - \\csc(z)\\cot(z)", "\\sec(z)\\tan(z)", "\\cos(z)", "\\sec^2(z)", "-\\sin(z)")
    which = distrand(2, 0, 6)

    p = new poly(rand(1, 3))
    p.setrand(3)

    q = new poly(1); p.diff(q)

    qString = "If $$y + " + fns[which[0]].replace(/z/g, 'y') + " = " + fns[which[1]].replace(/z/g, 'x')
    if p[p.rank] > 0 then qString += " + "
    qString += p.write('x') + ",$$ find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(y\\) and \\(x\\)."

    aString = "$$\\frac{\\mathrm{d}y}{\\mathrm{d}x} = \\frac{" + difs[which[1]].replace(/z/g, 'x')
    if q[q.rank] > 0 then aString += " + "
    aString += q.write('x') + "}{" + difs[which[0]].replace(/z/g, 'y') + " + 1}$$"

    qa = [qString, aString]
    return qa

  if rand() then qa = makeImplicit1() else qa = makeImplicit2()
  return qa



makeChainRule = ->
  fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)")
  difs = new Array("\\frac{y}{z}", " - y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", " - y\\sin(z)")
  even = new Array(-1, 1, - 1, 1, 1, - 1)
  which = rand(0, 5)

  a = new poly(rand(1, 3))
  a.setrand(8)
  b = new poly(0)
  a.diff(b)

  qString = "Differentiate \\(" + fns[which].replace(/z/g, a.write()) + "\\)"

  if difs[which].charAt(0) is " - "
    difs[which] = difs[which].slice(1)
    b.xthru(-1)

  if a[a.rank] < 0
    a.xthru(-1)
    b.xthru(even[which])

  if which is 0
    c = gcd(a.gcd())
    a.xthru(1.0 / c)
    b.xthru(1.0 / c)

  if b.terms() > 1 and which
    aString = "(" + b.write() + ')'

  if b.rank is 0 and which
    aString = ascoeff(b[0])

  else aString = b.write()

  aString = "$$" + difs[which].replace(/z/g, a.write()).replace(/y/g, aString) + "$$"

  qa = [qString, aString]
  return qa



makeProductRule = ->
  fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)")
  difs = new Array("\\frac{y}{z}", " - y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", " - y\\sin(z)")
  even = new Array(-1, 1, - 1, 1, 1, - 1)
  which = rand(0, 5)

  a = new poly(rand(1, 3))
  a.setrand(8)
  b = new poly(0)
  a.diff(b)

  qString = "Differentiate $$"
  if a.terms()>1
    qString += '(' + a.write() + ')' + fns[which].replace(/z/g, 'x')
  else
    qString += a.write() + fns[which].replace(/z/g, 'x')
  qString += "$$"

  if b.terms() > 1
    aString = '$$(' + b.write() + ')'
  else if b[0] is 1
    aString = '$$'
  else if b[0] is -1
    aString = '$$ - '
  else
    aString = '$$' + b.write()

  if difs[which].charAt(0) is ' - '
    difs[which] = difs[which].slice(1)
    a.xthru(-1)

  if a[a.rank] > 0
    aString += fns[which].replace(/z/g, 'x') + ' + '
  else
    aString += fns[which].replace(/z/g, 'x') + ' - '
    a.xthru(-1)

  if which is 0 and a[0] is 0 # deal with eg. D(axlnx) = alnx + ax / x = alnx + a
    for i from 0 to a.rank - 1
      a[i] = a[i + 1]
    a.rank--
    aString += a.write()

  else if a.terms() > 1 and which
    aString += difs[which].replace(/y/g, '(' + a.write() + ')').replace(/z/g, 'x')
  else if a[0] is 1 and which
    aString += difs[which].replace(/y/g, '')
  else
    aString += difs[which].replace(/y/g, a.write()).replace(/z/g, 'x')
  aString += '$$'

  qa = [qString,aString]
  return qa



makeQuotientRule = ->
  fns = new Array("\\sin(z)", "\\tan(z)", "\\cos(z)")
  difs = new Array("\\csc(z)\\cot(z)", "\\csc^2(z)", "\\sec(z)\\tan(z)")
  even = new Array(1, 1, - 1)
  which = rand(0, 2)

  a = randnz(8)
  b = new poly(2)
  b.setrand(8)
  # D(a / f.b = (f.b * Da) + (a * D{f.b}) / (f * f).b = a * b' * f'.b / (f * f).b

  qString = "Differentiate $$\\frac{" + a + "}{" + fns[which].replace(/z/g, b.write()) + "}$$"

  c = new poly(1)
  b.diff(c)
  c.xthru(a)

  if b[b.rank] < 0
    b.xthru(-1)
    c.xthru(even[which])

  lead = c.write()

  if c.terms() > 1
    lead = '(' + lead + ')'
  else if c.rank is 0
    if c[0] is 1
      lead = ""
    else if c[0] is -1
      lead = " - "

  bot = difs[which].replace(/z/g, b.write())
  aString = '$$' + lead + bot + '$$'

  qa = [qString, aString]
  return qa



makeGP = ->

  makeGP1 = ->
    a = randnz(8)
    b = rand(2, 9)
    c = 1

    if rand() then b = -b

    if rand()
      c = rand(2, 5)
      if c is b then c++
      d = gcd(b, c)
      b /= d
      c /= d

    n = rand(5, 10)

    qString = "Evaluate $$\\sum_{r = 0}^{" + n + "} "

    if a is not 1
      if a is -1
        if c is 1 and b > 0
          qString += " - \\left("
        else qString += " - "
      else qString += a + "\\times"

    if c is 1
      if b < 0
        qString += "\\left(" + b + "\\right)"
      else qString += b
    else
      qString += "\\left(\\frac{" + b + "}{" + c + "}\\right)"

    qString += "^{r}"
    if a is -1 and c is 1 and b > 0
      qString += "\\right)"
    qString += "$$"

    # Sum is a(1 - r^n + 1) / (1 - r)
    top = new frac(-b ^ (n + 1), c ^ (n + 1))
    top.add(1)
    top.prod(a)
    bot = new frac(-b, c)
    bot.add(1)

    ans = new frac(top.top * bot.bot, top.bot * bot.top)
    ans.reduce()
    aString = '$$' + ans.write() + '$$'

    qa = [qString, aString]
    return qa

  makeGP2 = ->
    a = randnz(8)
    b = rand(1, 6)
    c = rand(b + 1, 12)

    if rand() then b = -b

    r = new frac(b, c)
    r.reduce()

    qString = "Evaluate$$\\sum_{r = 0}^{\\infty} "
    if a is not 1
      if a is -1
        qString += " - "
      else
        qString += a + "\\times"

    qString += "\\left(" + r.write() + "\\right)^{r}$$"

    # Sum is a / (1 - r)
    r.prod(-1)
    r.add(1)
    ans = new frac(a * r.bot, r.top)
    aString = '$$' + ans.write() + '$$'

    qa = [qString, aString]
    return qa

  if rand() then qa = makeGP1() else qa = makeGP2()
  return qa







makeImplicitFunction = ->

  mIF1 = ->
    a = distrand(2, 2, 5)
    n = randnz(3)
    f = new frac(a[0], a[1])
    data = ""

    qString = "Sketch the curve in the \\(xy\\) plane given by \\(y = " + ascoeff(n) + "x^{" + f.write() + "}\\)"

    drawIt = (parms) ->
      f = parms[0]
      n = parms[1]
      d1 = []

      for i from -10 to 10 by 0.01
        x = Math.pow(i, f.bot)
        if Math.abs(x) > 12 then x = null

        y = n * Math.pow(i, f.top)
        if Math.abs(y) > 12 then y = null

        if x and y then d1.push([x, y])
        else d1.push([null, null])

      #$.plot($("#graph"), [d1])
      return [d1]

    aString = '%GRAPH%'

    qa = [qString,aString, drawIt, [f,n]]
    return qa

  mIF2 = ->
    a = distrandnz(2, 5)
    n = randnz(6)
    f = new frac(a[0], a[1])
    data = ""

    qString = "Sketch the curve in the \\(xy\\) plane given by \\(" + ascoeff(a[0]) + "y"
    if a[1] > 0 then qString += " + "
    qString += ascoeff(a[1]) + "x"
    if n > 0 then qString += " + "
    qString += n + " = 0\\)"

    drawIt = (parms) ->
      f = parms[0]
      n = parms[1]
      d1 = []

      for i from -10 to 10 by 0.01
        y = -i * a[1] / a[0] - n / a[0]
        d1.push([i, y])

      #$.plot($("#graph"), [d1])
      return [d1]

    parms = [f, n]
    aString = '%GRAPH%'

    qa = [qString,aString, drawIt, [f, n]]
    return qa

  mIF3 = ->
    a = distrandnz(2, 2, 5)
    qString = "Sketch the curve in the \\(xy\\) plane given by \\(\\frac{x^2}{" + (a[0] * a[0]) + "} + \\frac{y^2}{" + (a[1] * a[1]) + "} = 1\\)"

    drawIt = (parms) ->
      d1 = []

      for i from -1 to 1 by 0.005
        x = parms[0] * Math.cos(i * Math.PI)
        y = parms[1] * Math.sin(i * Math.PI)
        d1.push([x, y])

      #$.plot($("#graph"), [d1])
      return [d1]

    # where are the parms?
    aString = '%GRAPH%'
    qa = [qString, aString, drawIt, a]
    return qa

  return pickrand(mIF1, mIF2, mIF3)()



makeIntegration = ->

  makeIntegration1 = ->
    fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)")
    difs = new Array("\\frac{y}{z}", " - y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)")
    even = new Array(-1, 1, -1, 1, 1, -1)
    which = rand(0, 5)

    a = new poly(rand(1, 3))
    a.setrand(8)
    a[a.rank] = Math.abs(a[a.rank])

    if which is 0 then a.xthru(1.0 / a.gcd())
    u = randnz(4)
    b = new poly(0)
    a.diff(b)

    aString = '$$' + p_linear(u, 0).write(fns[which].replace(/z/g, a.write())) + " + c$$"

    if difs[which].charAt(0) is " - "
      difs[which] = difs[which].slice(1)
      b.xthru(-1)

    b.xthru(u)

    if b.terms() > 1 and which
      qString = '(' + b.write() + ')'
    else if b.rank is 0 and which
      qString = ascoeff(b[0])
    else qString = b.write()

    qString = "Find $$\\int" + difs[which].replace(/z/g, a.write()).replace(/y/g, qString) + "\\,\\mathrm{d}x$$"

    qa = [qString, aString]
    return qa

  makeIntegration2 = ->
    fns = new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)")
    difs = new Array("\\frac{y}{z}", " - y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", " - y\\sin(z)")
    even = new Array(-1, 1, - 1, 1, 1, - 1)
    which = rand(0, 5)

    a = new poly(rand(1, 3))
    a.setrand(8)
    b = new poly(0)
    a.diff(b)

    aString = "$$"
    if a.terms() > 1
      aString += '(' + a.write() + ')' + fns[which].replace(/z/g, 'x')
    else
      aString += a.write() + fns[which].replace(/z/g, 'x')
    aString += " + c$$"

    qString = "Find $$\\int"
    if b.terms() > 1
      qString += '(' + b.write() + ')'
    else if b[0] is 1
      qString += ''
    else if b[0] is -1
      qString += ' - '
    else
      qString += b.write()

    if difs[which].charAt(0) is " - "
      difs[which] = difs[which].slice(1)
      a.xthru(-1)

    if a[a.rank] > 0
      qString += fns[which].replace(/z/g, 'x') + ' + '
    else
      qString += fns[which].replace(/z/g, 'x') + ' - '
      a.xthru(-1)

    if which is 0 and a[0] is 0 # deal with eg. D(axlnx) = alnx + ax / x = alnx + a
      for i from 0 to a.rank - 1
        a[i] = a[i + 1]
      a.rank--
      qString += a.write()
    else if a.terms() > 1 and which
      qString += difs[which].replace(/y/g, '(' + a.write() + ')').replace(/z/g, 'x')
    else if a[0] is 1 and which
      qString += difs[which].replace(/y/g, '')
    else
      qString += difs[which].replace(/y/g, a.write()).replace(/z/g, 'x')

    qString += "\\,\\mathrm{d}x$$"

    qa = [qString, aString]
    return qa

  if rand() then qa = makeIntegration1() else qa = makeIntegration2
  return qa



makeDE = ->

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

  makeDE2 = ->
    roots = distrand(2, 4)
    p = p_quadratic(1, - roots[0] - roots[1], roots[0] * roots[1])

    qString = "Find the general solution of the following second-order ODE:$$" + p.write('D').replace("D^2", "\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}").replace("D", "\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}")
    if p[0] is 0
      qString += " = 0$$"
    else
      qString += "y = 0$$"

    aString = "$$y = "

    if roots[0] is 0
      aString += "A + "
    else aString += "Ae^{" + ascoeff(roots[0]) + "x}" + " + "

    if roots[1] is 0
      aString += "B$$"
    else aString += "Be^{" + ascoeff(roots[1]) + "x}" + '$$'

    qa = [qString, aString]
    return qa

  makeDE3 = ->
    b = randnz(6)
    qString = "Find the general solution of the following first-order ODE:$$x\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x} - y"

    if b > 0
      qString += signedNumber(-b) + " = 0.$$"
    else
      qString += " = " + (-b) + "$$"

    aString = "$$y = Ax"
    if b > 0 then aString += " + "
    aString += b + '$$'

    qa = [qString, aString]
    return qa

  qa = pickrand(makeDE2, makeDE3)()
  return qa



makePowers = ->
  res = new frac()
  q = ""

  for i from 0 to 4
    if i is 1 or i > 2 then q += "\\times "

    switch rand(1, 4)

      case 1
        a = randnz(4)
        b = randnz(5)
        p = new frac(a, b)

        if p.top is p.bot
          q += "x"
        else
          q += "x^{" + p.write() + "}"

        if i > 1 then a = -a
        res.add(a, b)

      case 2
        a = randnz(4)
        b = randnz(2, 5)

        if gcd(a,b) is not 1
          if a > 0 then a++ else a--

        q += "\\root " + b + " \\of"
        if a is 1
          q += "{x}"
        else
          q += "{x^{" + a + "}}"

        if i > 1 then a = -a
        res.add(a, b)

      case 3
        u = distrand(2, 1, 3)
        a = u[0]
        b = u[1]
        c = randnz(2, 6)
        p = new frac(a, b)

        q += "\\left(x^{" + p.write() + "}\\right)^" + c

        if i > 1 then a = -a
        res.add(a * c, b)

      case 4
        q += "x"
        if i > 1 then res.add(-1, 1) else res.add(1, 1)

    if i is 1 then q += "}{"

  qString = "Simplify $$\\frac{" + q + "}$$"

  if res.top is res.bot
    aString = "$$x$$"
  else
    aString = "$$x^{" + res.write() + "}$$"

  qa = [qString, aString]
  return qa



/**************************\
|*  START OF FP MATERIAL  *|
\**************************/



makeCArithmetic = ->
  z = Complex.randnz(6, 6)
  w = Complex.randnz(4, 6)

  qString = "Given \\(z = " + z.write() + "\\) and \\(w = " + w.write() + "\\), compute:"

  qString += "<ul class=\"exercise\">"
  qString += "<li>\\(z + w\\)</li>"
  qString += "<li>\\(z\\times w\\)</li>"
  qString += "<li>\\(\\frac{z}{w}\\)</li>"
  qString += "<li>\\(\\frac{w}{z}\\)</li>"
  qString += "</ul>"

  aString = "<ul class=\"exercise\">"
  aString += "<li>\\(" + z.add(w.Re, w.Im).write() + "\\)</li>"
  aString += "<li>\\(" + z.times(w.Re, w.Im).write() + "\\)</li>"
  aString += "<li>\\(" + z.divide(w.Re, w.Im).write() + "\\)</li>"
  aString += "<li>\\(" + w.divide(z.Re, z.Im).write() + "\\)</li>"
  aString += "</ul>"

  qa = [qString, aString]
  return qa



makeCPolar = ->
  if rand()
    z = Complex.randnz(6, 6)
  else
    z = Complex.randnz(6, 4)

  qString = "Convert \\(" + z.write() + "\\) to modulus-argument form."
  ma = Complex.ctop(z)
  r = Math.round(ma[0])
  t = guessExact(ma[1] / Math.PI)

  if r is 1
    aString = "$$"
  else
    aString = "$$" + r # + "\\times "

  aString += "e^{"

  if t is 0
    aString += "0"
  else if t is 1
    aString += "\\pi i"
  else
    aString += t + "\\pi i"

  aString += "}$$"

  qa = [qString, aString]
  return qa



makeDETwoHard = ->
  p = new poly(2)
  p.setrand(6)
  p[2] = 1

  disc = (p[1])^2 - 4 * p[0] * p[2]
  roots = [0,0]

  if disc > 0
    roots[0] = (-p[1] + Math.sqrt(disc)) / 2
    roots[1] = (-p[1] - Math.sqrt(disc)) / 2

  else if disc is 0
    roots[0] = roots[1] = (-p[1]) / 2

  else
    roots[0] = new complex(-p[1] / 2, Math.sqrt(-disc) / 2)
    roots[1] = new complex(-p[1] / 2, - Math.sqrt(-disc) / 2)

  qString = "Find the general solution of the following second-order ODE:$$" + p.write('D').replace("D^2", "\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}").replace("D", "\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}")
  if p[0] is not 0 then qString += "y"
  qString += " = 0$$"
  qString = qString.replace(/1y/g, "y")

  aString = "$$y = "

  if disc > 0
    if guessExact(roots[0]) is 0
      aString += "A"
    else
      aString += "Ae^{" + ascoeff(guessExact(roots[0])) + "x}"

    if guessExact(roots[1]) is 0
      aString += " + B$$"
    else
      aString += " + Be^{" + ascoeff(guessExact(roots[0])) + "x}$$"

  else if disc is 0
    if roots[0] is 0
      aString += "Ax + B"
    else
      aString += "(Ax + B)"

    if guessExact(roots[0])
      aString += "e^{" + ascoeff(guessExact(roots[0])) + "x}"

    aString += "$$"

  else
    aString += "A\\cos\\left(" + ascoeff(guessExact(roots[0].Im)) + "x + \\varepsilon\\right)"

    if guessExact(roots[0].Re)
      aString += "e^{" + ascoeff(guessExact(roots[0].Re)) + "x}"

    aString += "$$"

  qa = [qString, aString]
  return qa



makeMatrixQ = (dim, max) ->
  A = new fmatrix(dim); A.setrand(max)
  B = new fmatrix(dim); B.setrand(max)
  I = new fmatrix(dim)

  I.zero()
  for i from 0 to I.dim - 1
    I[i][i].set(1, 1)

  # A + tI can be singular for at most n values of t
  # (i.e. eigenvalues of A)
  # Hence the throw statement should never be encountered, but if the
  # matrix API changes or something I'd rather be debugging an
  # exception than an infinite loop.
  i = 0
  while B.det().top is 0
    if i >= B.dim
      throw new Error "makeMatrixQ: failed to make a non-singular matrix"
    B = B.add(I)
    i++

  qString = "Let $$A = " + A.write() + " \\qquad \\text{and} \\qquad B = " + B.write() + "$$."
  qString += "Compute: <ul class=\"exercise\">"
  qString += "<li>\\(A + B\\)</li>"
  qString += "<li>\\(A \\times B\\)</li>"
  qString += "<li>\\(B^{ - 1}\\)</li>"
  qString += "</ul>"

  S = A.add(B)
  P = A.times(B)
  Y = B.inv()

  aString = "<ul class=\"exercise\">"
  aString += "<li>\\(" + S.write() + "\\)</li>"
  aString += "<li>\\(" + P.write() + "\\)</li>"
  aString += "<li>\\(" + Y.write() + "\\)</li>"
  aString += "</ul>"

  qa = [qString, aString]
  return qa

makeMatrix2 = -> makeMatrixQ(2, 6)
makeMatrix3 = -> makeMatrixQ(3, 4)



makeTaylor = ->
  f = ["\\sin(z)" "\\cos(z)" "\\arctan(z)" "e^{z}" "\\log_{e}(1 + z)"]
  t = [[new frac(0), new frac(1), new frac(0), new frac(-1, 6)], [new frac(1), new frac(0), new frac(-1, 2), new frac(0)], [new frac(0), new frac(1), new frac(0), new frac(-1, 3)], [new frac(1), new frac(1), new frac(1, 2), new frac(1, 6)], [new frac(0), new frac(1), new frac(-1, 2), new frac(1, 3)]]
  which = rand(0, 4)
  n = randfrac(6)

  if n.top is 0 then n = new frac(1)
  qString = "Find the Taylor series of \\(" + f[which].replace(/z/g, fcoeff(n, 'x')) + "\\) about \\(x = 0\\) up to and including the term in \\(x^3\\)"

  p = new fpoly(3)
  for i from 0 to 3
    p[i] = new frac(t[which][i].top * (n.top)^i, t[which][i].bot * (n.bot)^i)
  aString = "$$" + p.rwrite() + "$$"

  qa = [qString, aString]
  return qa



makePolarSketch = ->
  fnf = [Math.sin, Math.tan, Math.cos, (x) -> x]
  fnn = ["\\sin(z)", "\\tan(z)", "\\cos(z)", "z"]
  which = rand(0, 3)
  parms = 0
  fn = 0
  a = rand(0, 3)

  if which is 3 then b = rand(1, 1)
  else b = rand(1, 5)

  qString = "Sketch the curve given in polar co-ordinates by \\(r = "
  if a then qString += a + " + "
  qString += fnn[which].replace(/z/g, ascoeff(b) + '\\theta') + "\\) (where \\(\\theta\\) runs from \\(-\\pi\\) to \\(\\pi\\))."

  makePolarSketch.fn = (parms) ->
    f = parms[0]
    d1 = []

    for i from -1 to 1 by 0.005
      r = parms[1] + f(i * Math.PI * parms[2])

      x = r * Math.cos(i * Math.PI)
      if Math.abs(x) > 6 then x = null

      y = r * Math.sin(i * Math.PI)
      if Math.abs(y) > 6 then y = null

      if x and y
        d1.push([x, y])
      else
        d1.push([null, null])

    return [d1]
    #$.plot($("#graph"), [d1])

  aString = '%GRAPH%' + JSON.stringify([fnf[which], a, b])

  qa = [qString, aString]
  return qa



makeFurtherVector = ->
  a = new vector(3); a.setrand(5)
  b = new vector(3); b.setrand(5)
  c = new vector(3); c.setrand(5)

  qString = "Let \\(\\mathbf{a} = " + a.write() + "\\,\\), \\(\\mathbf{b} = " + b.write() + "\\,\\) and \\(\\mathbf{c} = " + c.write() + "\\). "
  qString += "Calculate: <ul class=\"exercise\">"
  qString += "<li>the vector product, \\(\\mathbf{a}\\wedge \\mathbf{b}\\),</li>"
  qString += "<li>the scalar triple product, \\([\\mathbf{a}, \\mathbf{b}, \\mathbf{c}]\\).</li>"
  qString += "</ul>"

  axb = a.cross(b)
  abc = axb.dot(c)

  aString = "<ul class=\"exercise\">"
  aString += "<li>\\(" + axb.write() + "\\)</li>"
  aString += "<li>\\(" + abc + "\\)</li>"
  aString += "</ul>"

  qa = [qString, aString]
  return qa



makeNewtonRaphson = ->
  fns = ["\\ln(z)", "e^{z}", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)"]
  difs = ["\\frac{1}{z}", "e^{z}", " - \\csc(z)\\cot(z)", "\\sec(z)\\tan(z)", "\\cos(z)", "\\sec^2(z)", " - \\sin(z)"]
  fnf = [Math.log, Math.exp, (x) -> (1 / Math.sin(x)), (x) -> (1 / Math.cos(x)), Math.sin, Math.tan, Math.cos]
  diff = [(x) -> (1 / x), Math.exp, (x) -> (Math.cos(x) / (Math.sin(x)) ^ 2), (x) -> (Math.sin(x) / (Math.cos(x)) ^ 2), Math.cos, (x) -> (1 / (Math.cos(x)) ^ 2), (x) -> (-Math.sin(x))]
  which = rand(0, 6)

  p = new poly(2)
  p.setrand(6); p[2] = 1
  np = new poly(2)

  for i from 0 to 2
    np[i] = -p[i]

  q = new poly(1); p.diff(q)
  nq = new poly(1); np.diff(nq)
  n = rand(4, 6)
  x = new Array(n + 1)

  if which then x[0] = rand(0, 4) else x[0] = rand(2, 4)

  qString = "Use the Newton-Raphson method to find the first \\(" + n + "\\) iterates in solving \\(" + p.write() + " = " + fns[which].replace(/z/g, 'x') + "\\) with \\(x_0 = " + x[0] + "\\)."
  aString = "Iteration: \\begin{align*} x_{n + 1} &= x_{n} - \\frac{" + fns[which].replace(/z/g, 'x_n') + np.write() + "}{" + difs[which].replace(/z/g, 'x_n') + nq.write() + "} \\\\[10pt]"

  for i from 0 to (n - 1)
    eff = fnf[which](x[i]) - p.compute(x[i])
    effdash = diff[which](x[i]) - q.compute(x[i])
    x[i + 1] = x[i] - (eff / effdash)

    if Math.abs(x[i + 1]) < 1e - 7
      x[i + 1] = 0

    aString += "x_{" + (i + 1) + "} &= " + x[i + 1] + "\\\\"  /* + "&" + p.write('x_{' + (i + 1) + '}') + ' = ' + p.compute(x[i + 1]) + "&" + fns[which].replace(/z/g, 'x_{' + (i + 1) + '}') + " = " + fnf[which](x[i + 1]) */

  aString += "\\end{align*}"
  if isNaN(x[n])
    return(makeNewtonRaphson()) #TODO: find a better way this is worst - case infinite

  qa = [qString, aString]
  return qa



makeFurtherIneq = ->
  A = distrandnz(2, 6); B = distrandnz(2, 6); C = distrand(2, 6)

  qString = "Find the range of values of \\(x\\) for which$$"
  qString += "\\frac{" + A[0] + "}{" + p_linear(B[0], C[0]).write() + "} < \\frac{" + A[1] + "}{" + p_linear(B[1], C[1]).write() + "}$$"

  aedb = A[0] * B[1] - A[1] * B[0]
  root = new frac(A[1] * C[0] - A[0] * C[1], aedb)
  poles = [new frac(-C[0], B[0]), new frac(-C[1], B[1])] # both always exist, but they mightn't be distinct

  if aedb is 0 # AE = DB

    # singular
    if poles[0].equals(poles[1]) # always equal
      aString = "The two fractions are equivalent, so the inequality never holds."

    else # never equal
      # changes at poles
      m = new Array(2)

      for i from 0 to 1
        m[i] = poles[i].top / poles[i].bot

      l = ranking(m)
      # state for lge - ve x? < if poles[0] > poles[1]

      if m[0] > m[1]
        aString = "$$x < " + poles[l[0]].write() + " \\mbox{ or }" + poles[l[1]].write() + " < x$$"
      else
        aString = "$$" + poles[l[0]].write() + " < x < " + poles[l[1]].write() + "$$"

  else
    if poles[0].equals(poles[1])
      #for x< - C / B iff A / B > D / E
      i = A[0] / B[0]
      j = A[1] / B[1]

      if i > j
        aString = "$$x < " + poles[0].write() + "$$"
      else
        aString = "$$" + poles[0].write() + " < x$$"

    else
      # changes at root and poles, all distinct
      n = [root, poles[0], poles[1]]
      m = new Array(3)

      for i from 0 to 2
        m[i] = n[i].top / n[i].bot

      l = ranking(m)
      # state for lge - ve x? < if i>j
      i = A[0] / B[0]
      j = A[1] / B[1]

      if i > j
        aString = "$$x < " + n[l[0]].write() + "\\mbox{ or }" + n[l[1]].write() + " < x < " + n[l[2]].write() + "$$"
      else
        aString = "$$" + n[l[0]].write() + " < x < " + n[l[1]].write() + "\\mbox{ or }" + n[l[2]].write() + " < x$$"

  qa = [qString, aString]
  return qa



makeSubstInt = -> /* Has issues with polys which are never in the domain of, say, arcsin worked around for now */
  p = new poly(rand(1, 2)); p.setrand(2)
  fns = ["\\ln(Az)", "e^{Az}", p.rwrite('z')]
  fsq = ["(\\ln(Az))^2", "e^{2Az}", polyexpand(p, p).write('z')]

  q = new poly(p.rank - 1); p.diff(q)
  difs = ["\\frac{A}{z}", "Ae^{Az}", q.write('z')]
  t = ["\\arcsin(f)", "\\arctan(f)", "{\\rm arsinh}(f)", "{\\rm artanh}(f)"]
  dt = ["\\frac{y}{\\sqrt{1 - F}}", "\\frac{y}{1 + F}", "\\frac{y}{\\sqrt{1 + F}}", "\\frac{y}{1 - F}"]
  pm = [-1, 1, 1, -1]
  ldt = ["\\frac{A}{y\\sqrt{1 - F}}", "\\frac{A}{y(1 + F)}", "\\frac{A}{y\\sqrt{1 + F}}", "\\frac{A}{y(1 - F)}"]
  pdt = ["\\frac{y}{\\sqrt{F}}", "\\frac{y}{F}", "\\frac{y}{\\sqrt{F}}", "\\frac{y}{F}"]

  which = rand(0, 2)
  what = rand(0, 3)

  if what is 0 and which is 0
    which = rand(0, 1) # It's easier this way, no worrying about "when do solns exist"

  a = randnz(4)
  qString = "Find $$\\int"

  # special cases: polys and ln
  if which is 0
    qString += ldt[what].replace(/y/g, 'x').replace(/F/g, fsq[which].replace(/A/g, ascoeff(a))).replace(/z/g, 'x').replace(/A/g, a)
  else if which is 2
    r = polyexpand(p, p)
    r.xthru(pm[what])
    r[0]++
    qString += pdt[what].replace(/y/g, difs[which]).replace(/F/g, r.rwrite('z')).replace(/z/g, 'x')
  else
    qString += dt[what].replace(/y/g, difs[which]).replace(/F/g, fsq[which]).replace(/z/g, 'x').replace("2A", ascoeff(2 * a)).replace(/A/g, ascoeff(a))

  qString += "\\,\\mathrm{d}x$$"
  aString = "$$" + t[what].replace(/f/g, fns[which]).replace(/z/g, 'x').replace(/A/g, ascoeff(a)) + " + c$$"

  qa = [qString, aString]
  return qa



# Note: Important not to let things become negative. Can't just apply an abs() here and there, because areas of integrals might cancel out
makeRevolution = ->

  makeSolidRevolution = ->
    fns = ["\\sec(z)", "\\csc(z)", "\\sqrt{z}"]
    iss = ["\\tan(z)", "-\\cot(z)", 0]
    isf = [Math.tan, (x) -> (-1 / Math.tan(x)), (x) -> ((x ^ 2) / 2)]

    which = rand(0, 2)
    x0 = 0
    if which is 1 then x0++

    if which is 2
      x = rand(x0 + 1, x0 + 4)
    else
      x = rand(x0 + 1, x0 + 1)

    qString = "Find the volume of the solid formed when the area under"
    qString += "$$y = " + fns[which].replace(/z/g, 'x') + "$$"
    qString += "from \\(x = " + x0 + "\\) to \\(x = " + x + "\\) is rotated through \\(2\\pi\\) around the \\(x\\)-axis."

    if which is 2
      ans = guessExact(isf[which](x) - isf[which](x0))
    else
      ans = "\\left(" + iss[which].replace(/z/g, x)
      if isf[which](x0) is not 0 then ans += " - "
      ans += iss[which].replace(/z/g, x0) + "\\right)\\,"
      ans = ans.replace(/--/, " + ")
    aString = "$$" + ans + "\\pi$$"

    qa = [qString, aString]
    return qa

  makeSurfaceRevolution = ->
    a = new poly(rand(1, 3))
    a.setrand(6)

    for i from 0 to a.rank
      a[i] = Math.abs(a[i])

    b = new fpoly(3)
    b.setpoly(a)
    c = new fpoly(4)
    b.integ(c)

    x = rand(1, 4)

    qString = "Find the area of the surface formed when the curve"
    qString += "$$y = " + a.write('x') + "$$"
    qString += "from \\(x = 0\\mbox{ to }x = " + x + "\\) is rotated through \\(2\\pi\\) around the \\(x\\)-axis."
    hi = c.compute(x) # lo is going to be 0 since our lower limit on the integral is 0, and the antiderivs are polys with no (or arb) constant term
    ans = new frac(hi.top, hi.bot)
    ans.prod(2)
    aString = "$$" + fcoeff(ans, "\\pi") + "$$"

    qa = [qString, aString]
    return qa

  if rand() then qa = makeSolidRevolution() else qa = makeSurfaceRevolution()
  return qa



makeMatXforms = ->
  a = rand(0, 2)
  xfms = new Array(5)

  for i from 0 to 4
    xfms[i] = new fmatrix(2)

  cosines  = [new frac(0), new frac(-1), new frac(0)]
  sines    = [new frac(1), new frac(0), new frac(-1)]
  acosines = [new frac(0), new frac(1), new frac(0)]
  asines   = [new frac(-1), new frac(0), new frac(1)]

  xfms[0].set(cosines[a], asines[a], sines[a], cosines[a]) # first sin is - 1
  xfms[1].set(cosines[a], sines[a], sines[a], acosines[a]) # second cos is - 1
  xfms[2].set(1, a + 1, 0, 1)
  xfms[3].set(1, 0, a + 1, 1)
  xfms[4].set(a + 2, 0, 0, a + 2)

  f = new frac(a + 1, 2)
  xft = [
    "a rotation through \\(" + fcoeff(f, "\\pi") + "\\) anticlockwise about O"
    "a reflection in the line \\(" + ["y = x","x = 0","y = - x"][a] + "\\)"
    "a shear of element \\(" + (a + 1) + ", x\\) axis invariant"
    "a shear of element \\(" + (a + 1) + ", y\\) axis invariant"
    "an enlargement of scale factor \\(" + (a + 1) + "\\)"]

  which = distrand(2, 0, 4)
  qString = "Compute the matrix representing, in 2D, " + xft[which[0]] + " followed by " + xft[which[1]] + "."

  ans = xfms[which[1]].times(xfms[which[0]])
  aString = "$$" + ans.write() + "$$"

  qa = [qString, aString]
  return qa



/****************************\
|*  START OF STATS MATERIAL *|
\****************************/



makeDiscreteDistn = ->
  # nparms = [2, 1, 1]
  massfn = [massBin, massPo, massGeo]
  pd = rand(2, 6)
  pn = rand(1, pd - 1)
  f = new frac(pn, pd)
  p = pn / pd
  parms = [[rand(5, 12), p], [rand(1, 5)], [p]]
  dists = ["{\\rm B}\\left(" + parms[0][0] + ', ' + f.write() + "\\right)", "{\\rm Po}(" + parms[1][0] + ")", "{\\rm Geo}\\left(" + f.write() + "\\right)"]
  x = rand(1, 4)
  which = rand(0, 2)
  leq = rand()

  qString = "The random variable \\(X\\) is distributed as$$" + dists[which] + ".$$ Find \\(\\mathbb{P}(X"
  if leq
    qString += "\\le"
  else
    qString += " = "
  qString += x + ")\\)"

  if leq
    ans = 0
    for i from 0 to x
      ans += massfn[which](i, parms[which][0], parms[which][1])
  else
    ans = massfn[which](x, parms[which][0], parms[which][1])
  aString = "$$" + ans.toFixed(6) + "$$"

  qa = [qString, aString]
  return qa



makeContinDistn = ->

  tableN.populate()

  mu = rand(0, 4)
  sigma = rand(1, 4)

  # like toFixed(1) but always rounding downwards
  x = Math.floor(Math.random() * 3 * sigma * 10)  /  10

  # x is  / slightly /  nonuniform because -0 = 0,
  # but it's not a perceptible effect in general
  if rand() then x *= -1
  x += mu

  qString = "The random variable \\(X\\) is normally distributed with mean \\(" + mu + "\\) and variance \\(" + sigma^2 + "\\)."
  qString += "<br />Find \\(\\mathbb{P}(X\\le" + x + ")\\)"
  z = (x - mu) / sigma

  index = Math.floor(1e3 * Math.abs(z))
  if index < 0 or index >= tableN.values.length
    throw new Error('makeContinDistn: index ' + index + ' out of range\n' + 'x: ' + x)

  p = tableN.values[index]
  if z < 0 then p = 1 - p
  aString = "$$" + p.toFixed(3) + "$$"

  qa = [qString, aString]
  return qa



makeHypTest = ->

  makeHypTest1 = ->
    mu = new Array(2) # 0 = H - null, 1 = actual
    sigma = new Array(2)
    which = 0 # 0: = . 1: <. 2: >.
    n = rand(8, 12)
    sl = pickrand(1, 5, 10)

    if rand()
      mu[1] = mu[0] = rand(-1, 5)
      sigma[1] = sigma[0] = rand(1, 4)
      which = rand(0, 2)

    else
      mu = distrand(2, -1, 5)
      sigma[0] = rand(1, 4)
      sigma[1] = rand(1, 4)

      if rand()
        if mu[0] < mu[1] then which = 2 else which = 1
      else which = 0

    Sx = genN(mu[1] * n, sigma[1] * Math.sqrt(n))
    qString = "In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = " + mu[0] + "\\mbox{, }\\sigma^2 = " + sigma[0] * sigma[0] + "\\). "
    qString += "The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu" + ['\\ne','<','>'][which] + mu[0] + "\\). "
    qString += "The significance level is \\(" + sl + "\\%\\). "
    qString += "A sample of size \\(" + n + "\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = " + Sx.toFixed(3) + "\\).<br />"

    qString += "<br />Compute: <ul class=\"exercise\">"
    qString += "<li>\\(\\overline{x}\\)</li>"
    qString += "<li> Is \\({\\rm H}_0\\) accepted?}</li>"
    qString += "</ul>"

    xbar = Sx / n
    aString = "<ul class=\"exercise\">"
    aString += "<li>\\(\\overline{x} = " + xbar.toFixed(3) + "\\)</li>"
    p = 0

    if which # one tail
      switch sl
        | 1  => p = 4
        | 5  => p = 2
        | 10 => p = 1

    else # two tails
      switch sl
        | 1  => p = 5
        | 5  => p = 3
        | 10 => p = 2

    critdev = sigma[0] * tableT.values[tableT.values.length - 1][p] / Math.sqrt(n)

    if which
      aString += "<li>The critical region is $$\\overline{x}"
      if which is 1
        aString += "<" + (mu[0] - critdev).toFixed(3) + "$$<br />"
      else aString += ">" + (mu[0] + critdev).toFixed(3) + "$$<br />"
    else aString += "<li>The critical values are $$" + (mu[0] - critdev).toFixed(3) + "\\) and \\(" + (mu[0] + critdev).toFixed(3) + "$$<br />"

    acc = false

    switch which
      | 0 => acc = (xbar >= mu[0] - critdev) and (xbar <= mu[0] + critdev)
      | 1 => acc = (xbar >= mu[0] - critdev)
      | 2 => acc = (xbar <= mu[0] + critdev)

    if acc then aString += "\\(\\rm H}_0\\) is accepted.</li>" else aString += "\\(\\rm H}_0\\) is rejected.</li>"
    aString += "</ul>"

    qa = [qString, aString]
    return qa

  makeHypTest2 = ->
    mu = new Array(2) # 0 = H - null, 1 = actual
    which = 0 # 0: = . 1: <. 2: >.
    n = rand(10, 25)
    sl = pickrand(1, 5, 10)

    if rand()
      mu[1] = mu[0] = rand(-1, 5)
      sigma = rand(1, 4)
      which = rand(0, 2)

    else
      mu = distrand(2, -1, 5)
      sigma = rand(1, 4)
      if rand()
        if mu[0] < mu[1] then which = 2 else which = 1
      else which = 0

    Sx = 0
    Sxx = 0

    for i from 0 to n - 1
      xi = genN(mu[1], sigma)
      Sx += xi
      Sxx += xi ^ 2

    qString = "In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = " + mu[0] + "\\). "
    qString += "The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu" + ['\\ne','<','>'][which] + mu[0] + "\\). "
    qString += "The significance level is \\(" + sl + "\\%\\). "
    qString += "A sample of size \\(" + n + "\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = " + Sx.toFixed(3) + "\\). "
    qString += "The sum of squares, \\(\\sum{x^2} = " + Sxx.toFixed(3) + "\\). "

    qString += "Compute: <ul class=\"exercise\">"
    qString += "<li>\\(\\overline{x}\\)</li>"
    qString += "<li>Compute an estimate, \\(S^2\\), of the variance of \\(X\\)</li>"
    qString += "<li>Is \\({\\rm H}_0\\) accepted?</li>"
    qString += "</ul>"

    xbar = Sx / n
    aString = "<ul class=\"exercise\">"
    aString = "<li>\\(\\overline{x} = " + xbar.toFixed(3) + "\\)</li>"

    SS = (Sxx - Sx ^ 2 / n) / (n - 1)
    aString += "<li>\\(S^2 = " + SS.toFixed(3) + "\\). "
    aString += "Under \\({\\rm H}_0\\), \\({\\frac{\\overline{X}"
    if mu[0]
      if mu[0] > 0 then aString += " - " else aString += " + "
      aString += Math.abs(mu[0])
    aString += "}{" + Math.sqrt(SS / n).toFixed(3) + "}}\\sim t_{" + (n - 1) + "}\\)</li>"

    p = 0

    if which # one tail
      switch sl
        | 1  => p = 4
        | 5  => p = 2
        | 10 => p = 1

    else # two tails
      switch sl
        | 1  => p = 5
        | 5  => p = 3
        | 10 => p = 2

    critdev = Math.sqrt(SS) * tableT.values[n - 2][p] / Math.sqrt(n)

    if which
      aString += "<li>The critical region is \\(\\overline{x}"
      if which is 1
        aString += "<" + (mu[0] - critdev).toFixed(3)
      else
        aString += ">" + (mu[0] + critdev).toFixed(3)
      aString += "\\) </br/>"
    else aString += "<li>The critical values are \\(" + (mu[0] - critdev).toFixed(3) + "\\) and \\(" + (mu[0] + critdev).toFixed(3) + "\\) <br />"

    acc = false

    switch which
      | 0 => acc = (xbar >= mu[0] - critdev) and (xbar <= mu[0] + critdev)
      | 1 => acc = (xbar >= mu[0] - critdev)
      | 2 => acc = (xbar <= mu[0] + critdev)

    if acc
      aString += "\\({\\rm H}_0\\) is accepted.</li>"
    else aString += "\\({\\rm H}_0\\) is rejected.</li>"
    aString += "</ul>"

    qa = [qString, aString]
    return qa

  if rand() then qa = makeHypTest1() else qa = makeHypTest2()
  return qa



makeConfidInt = ->
  mu = rand(4)
  sigma = rand(1, 4)
  n = 2 * rand(6, 10)
  sl = pickrand(99, 95, 90)
  Sx = 0
  Sxx = 0

  for i from 0 to (n - 1)
    xi = genN(mu, sigma)
    Sx += xi
    Sxx += (xi * xi)

  qString = "The random variable \\(X\\) has a normal distribution with unknown parameters. "
  qString += "A sample of size \\(" + n + "\\) is taken for which $$\\sum{x} = " + Sx.toFixed(3) + "$$$$\\mbox{and}\\sum{x^2} = " + Sxx.toFixed(3) + ".$$"
  qString += "Compute, to 3 DP., a \\(" + sl + "\\)% confidence interval for the mean of \\(X\\).<br />"
  xbar = Sx / n
  SS = (Sxx - Sx * Sx / n) / (n - 1)

  switch sl
    | 99 => p = 5
    | 95 => p = 3
    | 90 => p = 2

  critdev = Math.sqrt(SS / n) * tableT.values[n - 2][p]
  aString = "$$[" + (xbar - critdev).toFixed(3) + ", " + (xbar + critdev).toFixed(3) + "]$$"

  qa = [qString, aString]
  return qa













# TODO: Fix the occasional bug with nu<1 (but how?) and find out why that crow is sometimes undefined
makeChiSquare = ->
  tableN.populate()

  parms = [[rand(10, 18) * 2, rand(20, 80) / 100], [rand(4, 12)], [rand(10, 30) / 100], [rand(4, 10), rand(2, 4)]]
  distns = ["binomial", "Poisson", "geometric", "normal"]
  parmnames = [["n", "p"], ["\\lambda"], ["p"], ["\\mu", "\\sigma"]]
  nparms = [2, 1, 1, 2]
  massfn = [massBin, massPo, massGeo, massN]
  genfn = [genBin, genPo, genGeo, genN]
  which = rand(0, 3)
  n = 5 * rand(10, 15)
  sl = pickrand(90, 95, 99)

  qString = "The random variable \\(X\\) is modelled by a <i>" + distns[which] + "</i> distribution. "
  qString += "A sample of size \\(" + n + "\\) is drawn from \\(X\\) with the following grouped frequency data. "
  sample = []; min = 1e3; max = 0

  for i from 0 to (n - 1)
    sample[i] = genfn[which](parms[which][0], parms[which][1]) # excess parms get discarded, so it doesn't matter that they're undefined
    min = Math.min(min, sample[i])
    max = Math.max(max, sample[i])

  min = Math.floor(min)
  max = Math.ceil(max)
  freq = []

  for i from 0 to (Math.ceil((max + 1 - min) / 2) - 1)
    freq[i] = 0

  for i from 0 to (n - 1)
    y = Math.floor((sample[i] - min) / 2)
    freq[y]++

  qString += "<div style=\"font-size: 80%\">$$\\begin{array}{c|r}x&\\mbox{Frequency}\\\\"

  Sx = 0; Sxx = 0

  for i from 0 to (Math.ceil((max + 1 - min) / 2) - 1)
    x = min + (i * 2)
    Sx += (x + 1) * freq[i]
    Sxx += (x + 1) * (x + 1) * freq[i]

    if i is 0
      qString += "x < " + (x + 2)
    else if i is Math.ceil((max - 1 - min) / 2)
      qString += x + "\\le x"
    else
      qString += x + "\\le x <" + (x + 2)
    qString += "&" + freq[i] + "\\\\"

  qString += "\\end{array}$$</div>"
  qString += "<ul class=\"exercise\">"
  qString += "<li>Estimate the parameters of the distribution.</li>"
  qString += "<li>Use a \\(\\chi^2\\) test, with a significance level of \\(" + sl + "\\)%, to test this hypothesis.</li>"
  qString += "</ul>"

  switch(sl)
    | 90 => p = 3
    | 95 => p = 4
    | 99 => p = 6

  xbar = Sx / n
  SS = (Sxx - Sx * Sx / n) / (n - 1)
  hypparms = [0,0]
  aString = "<ol class=\"exercise\">"

  # calculate parameters
  switch which

    case 0 # B(n, p) = > E = np, = npq = > p = 1 - (Var / E), n = E / p
      hypparms[1] = 1 - (SS / xbar)
      hypparms[0] = Math.round(xbar / hypparms[1])

    case 1 # Po(l) = > E == l
      hypparms[0] = xbar

    case 2 # Geo(p) = > E = 1 / p
      hypparms[0] = 1 / xbar

    case 3 # N(m, s^2)
      hypparms[0] = xbar
      hypparms[1] = Math.sqrt(SS)

  # binomial
  if which is 0
    aString += "<li>$$" +
      parmnames[which][0] + " = " + hypparms[0].toString() + ", " +
      parmnames[which][1] + " = " + hypparms[1].toFixed(3) + ".$$</li>"

    # n < 1 is nonsensical
    # this happened quite often when part of the question was
    # checking if we were choosing the right model,
    # but is now *very* unlikely.
    if hypparms[0] < 1
      aString += "</ol>"
      aString += "<p>The binomial model cannot fit these data</p>"
      return [qString, aString]

  else
    aString += "<li>$$" + parmnames[which][0] + " = " + hypparms[0].toFixed(3)

    if nparms[which] is 2
      aString += ", " + parmnames[which][1] + " = " + hypparms[1].toFixed(3)
    aString += ".$$</li>"

  # We include the ii. list item here but don't actually put the
  # answer text in it, because it's too wide.
  aString += "<li></li></ol>"

  # The whole "combining rows" thing is going to be hard :S
  nrows = Math.ceil((max + 1 - min) / 2)
  row = [] # [Xl, Xh, O, E, ((O - E)^2) / E]

  for i from 0 to nrows - 1
    x = min + (i * 2)
    row[i] = [x, x + 2, freq[i], 0, 0]

    if which is 3 # N is continuous (and can't be integrated either), needs special handling (use tableN)
      zh = (x + 2 - hypparms[0]) / hypparms[1]
      zl = (x - hypparms[0]) / hypparms[1]

      if Math.abs(zh) < 3
        if zh >= 0
          ph = tableN.values[Math.floor(zh * 1000)]
        else
          ph = 1 - tableN.values[Math.floor(-zh * 1000)]
      else
        if zh > 0 then ph = 1 else ph = 0

      if Math.abs(zl) < 3
        if zl >= 0
          ph = tableN.values[Math.floor(zl * 1000)]
        else
          pl = 1 - tableN.values[Math.floor(-zl * 1000)]
      else
        if zl > 0 then pl = 1 else pl = 0

      if i is 0 then pl = 0
      if i is (nrows - 1) then ph = 1

      row[i][3] = (ph - pl) * n

    else
      if i is 0 then j1 = 0 else j1 = x
      if i is (nrows - 1) then j2 = (x + 100) else j2 = (x + 2)

      for j from j1 to j2 # not perfect, we're assuming the tail after 100 is essentially flat zero
        row[i][3] += massfn[which](j, hypparms[0], hypparms[1]) * n

  row2 = []
  chisq = 0
  currow = [0, 0, 0, 0, 0]

  for i from 0 to nrows - 1
    currow[1] = row[i][1]
    currow[2] += row[i][2]
    currow[3] += row[i][3]

    if currow[3] >= 5
      currow[4] = (currow[2] - currow[3]) ^ 2 / currow[3]
      row2.push(currow)
      chisq += currow[4]
      currow = [currow[1], currow[1], 0, 0, 0]

  if row2.length
    crow = row2.pop()
  else
    crow = [0, 0, 0, 0, 0]

  crow[1] = currow[1]
  crow[2] += currow[2]
  crow[3] += currow[3]
  chisq -= crow[4]
  crow[4] = (crow[2] - crow[3]) ^ 2 / crow[3]
  row2.push(crow)
  chisq += crow[4]

  aString += "<div style=\"font-size: 80%\">$$\\begin{array}{c||r|r|r}"
  aString += "x&O_i&E_i&\\frac{(O_i - E_i)^2}{E_i}\\\\"

  for i from 0 to (row2.length - 1)
    if i is 0
      aString += "x < " + row2[i][1]
    else if i is (row2.length - 1)
      aString += row2[i][0] + "\\le x"
    else
      aString += row2[i][0] + "\\le x <" + row2[i][1]
    aString += "&" + row2[i][2] + "&" + row2[i][3].toFixed(3) + "&" + row2[i][4].toFixed(3) + "\\\\"

  aString += "\\end{array}$$</div>"
  aString += "$$\\chi^2 = " + chisq.toFixed(3) + "$$"
  nu = row2.length - 1 - nparms[which]
  aString += "$$\\nu = " + nu + "$$"

  if nu < 1
    throw new Error "makeChiSquare: nu < 1!" +
      "\n\twhich:" + which +
      "\n\trow2.length:" + row2.length

  critval = tableChi.values[nu - 1][p]
  aString += "Critical region: \\(\\chi^2 >" + critval + "\\)<br />"

  if chisq > critval
    aString += "The hypothesis is rejected."
  else
    aString += "The hypothesis is accepted."

  qa = [qString, aString]
  return qa



makeProductMoment = ->
  n = rand(6, 12)
  mu = [rand(4), rand(4)]
  sigma = [rand(1, 6), rand(1, 6)]
  x = []

  for i from 0 to n - 1
    x[i] = []
    x[i][0] = genN(mu[0], sigma[0])
    x[i][1] = genN(mu[1], sigma[1])

  Ex = 0; Exx = 0; Exy = 0; Eyy = 0; Ey = 0 # Here E represents sigma

  qString = "For the following data,"
  qString += "<ul class=\"exercise\">"
  qString += "<li>compute the product moment correlation coefficient, \\({\\bf r}\\)</li>"
  qString += "<li>find the regression line of \\(y\\) on \\(x\\)$$\\begin{array}{c|c}x&y\\\\"

  for i from 0 to n-1
    qString += x[i][0].toFixed(3) + "&" + x[i][1].toFixed(3) + "\\\\"
    Ex += x[i][0]
    Exx += x[i][0] * x[i][0]
    Exy += x[i][0] * x[i][1]
    Eyy += x[i][1] * x[i][1]
    Ey += x[i][1]

  qString += "\\end{array}$$</li></ul>"

  xbar = Ex / n; ybar = Ey / n

  Sxx = Exx - Ex * xbar
  Syy = Eyy - Ey * ybar
  Sxy = Exy - (Ex * Ey / n)

  r = Sxy/Math.sqrt(Sxx * Syy)
  b = Sxy/Sxx
  a = ybar - (b * xbar)

  aString = "<ul class=\"exercise\">"
  aString += "<li>\\({\\bf r} = " + r.toFixed(3) + "\\)</li><li>\\(y = " + b.toFixed(3) + "x"
  if a > 0 then aString += " + "
  aString += a.toFixed(3) + "\\)."

  qa = [qString, aString]
  return qa

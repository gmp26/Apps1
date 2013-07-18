#
# nRich RPG (Randomised Problems Generator)
#

makePartial = ->
  makePartial1 = ->
    a = randnz 8
    b = new poly 1
    b.setrand 8
    if b.1 < 0
      b.xthru -1
      a = -a
    e = gcd a, b.gcd!
    if e > 1
      b.xthru 1 / e
      a /= e
    c = randnz 8
    d = new poly 1
    d.setrand 8
    if d.1 < 0
      d.xthru -1
      c = -c
    f = gcd c, d.gcd!
    if f > 1
      d.xthru 1 / f
      c /= f
    if b.1 is d.1 and b.0 is d.0 then d.0 = -d.0
    aString = (if a > 0 then '$$' else '$$-') + '\\frac{' + Math.abs a + '}{' + b.write! + '}' + if c > 0 then '+' else '-' + '\\frac{' + Math.abs c + '}{' + d.write! + '}$$'
    bot = polyexpand b, d
    b.xthru c
    d.xthru a
    b.addp d
    qString = 'Express$$\\frac{' + b.write! + '}{' + bot.write! + '}$$in partial fractions.'
    qa = [qString, aString]
    qa
  makePartial2 = ->
    m = distrandnz 3, 3
    d = randnz 4
    e = randnz 3
    f = randnz 3
    l = ranking m
    n = [
      d
      e
      f
    ]
    a = m[l.0]
    b = m[l.1]
    c = m[l.2]
    d = n[l.0]
    e = n[l.1]
    f = n[l.2]
    u = new poly 1
    v = new poly 1
    w = new poly 1
    u.1 = v.1 = w.1 = 1
    u.0 = a
    v.0 = b
    w.0 = c
    p = polyexpand u, v
    q = polyexpand u, w
    r = polyexpand v, w
    p.xthru f
    q.xthru e
    r.xthru d
    p.addp q
    p.addp r
    qString = 'Express$$\\frac{' + p.write! + '}{' + express [
      a
      b
      c
    ] + '}$$in partial fractions.'
    aString = (if d > 0 then '$$' else '$$-') + '\\frac{' + Math.abs d + '}{' + u.write! + '}' + if e > 0 then '+' else '-' + '\\frac{' + Math.abs e + '}{' + v.write! + '}' + if f > 0 then '+' else '-' + '\\frac{' + Math.abs f + '}{' + w.write! + '}$$'
    qa = [qString, aString]
    qa
  qa = void
  if rand! then qa = makePartial1! else qa = makePartial2!
  qa

makeBinomial2 = ->
  p = new poly 1
  p.0 = rand 1, 5
  p.1 = randnz 6 - p.0
  n = Math.round 3 + Math.random! * (3 - Math.max 0, Math.max p.0 - 3, p.1 - 3)
  q = new poly 3
  q.0 = Math.pow p.0, n
  q.1 = n * Math.pow p.0, n - 1 * p.1
  q.2 = n * (n - 1) * Math.pow p.0, n - 2 / 2 * Math.pow p.1, 2
  q.3 = n * (n - 1) * (n - 2) * Math.pow p.0, n - 3 / 6 * Math.pow p.1, 3
  qString = 'Evaluate$$(' + p.rwrite! + ')^' + n + '$$to the fourth term.'
  aString = '$$' + q.rwrite! + '$$'
  qa = [qString, aString]
  qa

makePolyInt = ->
  A = rand -3, 2
  B = rand A + 1, 3
  a = new poly 3
  a.setrand 6
  b = new fpoly 3
  b.setpoly a
  c = new fpoly 4
  b.integ c
  qString = 'Evaluate$$\\int_{' + A + '}^{' + B + '}' + a.write! + '\\,\\mathrm{d}x$$'
  hi = c.compute B
  lo = c.compute A
  lo.prod -1
  ans = new frac hi.top, hi.bot
  ans.add lo.top, lo.bot
  aString = '$$' + ans.write! + '$$'
  qa = [qString, aString]
  qa

makeTrigInt = ->
  a = rand 0, 7
  b = rand 1 - Math.min a, 1, 8
  A = if a then randnz 4 else 0
  B = if b then randnz 4 else 0
  U = pickrand 2, 3, 4, 6
  term1 = if a then (ascoeff A) + '\\sin{' + ascoeff a + 'x}' else ''
  term2 = if b then (abscoeff B) + '\\cos{' + ascoeff b + 'x}' else ''
  qString = 'Evaluate$$\\int_{0}^{\\pi/' + U + '}' + if a then if b then term1 + if B > 0 then ' + ' else ' - ' + term2 else term1 else (if B < 0 then '-' else '') + term2 + '\\,\\mathrm{d}x$$'
  soln1 = new Array 6
  soln2 = new Array 6
  soln = new Array 6
  if a
    soln1 = cospi a, U
    i = 0
    while i < 6
      soln1[i] *= -A
      i += 2
    i = 1
    while i < 6
      soln1[i] *= a
      i += 2
    if soln1.0
      soln1.0 = soln1.1 * A + a * soln1.0
      soln1.1 *= a
    else
      soln1.0 = A
      soln1.1 = a
  else
    soln1 = [
      0
      1
      0
      1
      0
      1
    ]
  if b
    soln2 = sinpi b, U
    i = 0
    while i < 6
      soln2[i] *= B
      i += 2
    i = 1
    while i < 6
      soln2[i] *= b
      i += 2
  else
    soln2 = [
      0
      1
      0
      1
      0
      1
    ]
  i = 0
  while i < 6
    soln[i] = soln1[i] * soln2[i + 1] + soln1[i + 1] * soln2[i]
    soln[i + 1] = soln1[i + 1] * soln2[i + 1]
    if soln[i + 1] < 0
      soln[i] *= -1
      soln[i + 1] *= -1
    if soln[i]
      c = gcd (Math.abs soln[i]), soln[i + 1]
      soln[i] /= c
      soln[i + 1] /= c
    i += 2
  aString = '$$'
  if soln.0 and soln.1 is 1
    aString += soln.0
  else
    if soln.0 > 0 then aString += '\\frac{' + soln.0 + '}{' + soln.1 + '}' else if soln.0 < 0 then aString += '-\\frac{' + -soln.0 + '}{' + soln.1 + '}'
  if soln.2 and soln.3 is 1
    aString += (if aString.length then if soln.2 > 0 then '+' else '' else '') + soln.2 + '\\sqrt{2}'
  else
    if soln.2 > 0
      aString += (if aString.length then '+' else '') + '\\frac{' + soln.2 + '}{' + soln.3 + '}\\sqrt{2}'
    else
      if soln.2 < 0 then aString += '-\\frac{' + -soln.2 + '}{' + soln.3 + '}\\sqrt{2}'
  if soln.4 and soln.5 is 1
    aString += (if aString.length then if soln.4 > 0 then '+' else '' else '') + soln.4 + '\\sqrt{3}'
  else
    if soln.4 > 0
      aString += (if aString.length then '+' else '') + '\\frac{' + soln.4 + '}{' + soln.5 + '}\\sqrt{3}'
    else
      if soln.4 < 0 then aString += '-\\frac{' + -soln.4 + '}{' + soln.5 + '}\\sqrt{3}'
  if aString is '$$' then aString += '0$$' else aString += '$$'
  qa = [qString, aString]
  qa

makeVector = ->
  ntol = (n) -> String.fromCharCode n + 'A'.charCodeAt 0
  A = new Array 4
  i = 0
  while i < 4
    A[i] = new vector 3
    A[i].setrand 10
    i++
  B = new Array 0, 1, 2, 3
  i = 0
  while i < 3
    if A[B[i]].mag! < A[B[i + 1]].mag!
      c = B[i]
      B[i] = B[i + 1]
      B[i + 1] = c
      i = -1
    i++
  v = distrand 3, 0, 3
  qString = 'Consider the four vectors'
  qString += '$$\\mathbf{A}=' + A.0.write! + '\\,,\\; \\mathbf{B}=' + A.1.write! + '$$'
  qString += '$$\\mathbf{C}=' + A.2.write! + '\\,,\\; \\mathbf{D}=' + A.3.write! + '$$'
  qString += '<ol class="exercise"><li>Order the vectors by magnitude.</li>'
  qString += '<li>Use the scalar product to find the angles between'
  qString += '<ol class="subexercise"><li>\\(\\mathbf{' + ntol v.0 + '}\\) and \\(\\mathbf{' + ntol v.1 + '}\\),</li>'
  qString += '<li>\\(\\mathbf{' + ntol v.1 + '}\\) and \\(\\mathbf{' + ntol v.2 + '}\\)</li></ol></ol>'
  aString = '<ol class="exercise"><li>'
  aString += '\\(|\\mathbf{' + ntol B.0 + '}|=\\sqrt{' + A[B.0].mag!
  aString += '},\\) \\(|\\mathbf{' + ntol B.1 + '}|=\\sqrt{' + A[B.1].mag!
  aString += '},\\) \\( |\\mathbf{' + ntol B.2 + '}|=\\sqrt{' + A[B.2].mag!
  aString += '}\\) and \\(|\\mathbf{' + ntol B.3 + '}|=\\sqrt{' + A[B.3].mag!
  aString += '}\\).</li>'
  top1 = A[v.0].dot A[v.1]
  bot1 = new sqroot A[v.0].mag! * A[v.1].mag!
  c = gcd (Math.abs top1), bot1.a
  top1 /= c
  bot1.a /= c
  top2 = A[v.1].dot A[v.2]
  bot2 = new sqroot A[v.1].mag! * A[v.2].mag!
  c = gcd (Math.abs top2), bot2.a
  top2 /= c
  bot2.a /= c
  aString += '<li><ol class="subexercise"><li>\\('
  if top1 is 0
    aString += '\\pi/2'
  else
    if top1 is 1 and bot1.n is 1 and bot1.a is 1
      aString += '0'
    else
      if not (top1 is -1 and bot1.n is 1 and bot1.a is 1)
        aString += '\\arccos\\left('
        if bot1.a is 1 and bot1.n is 1 then aString += top1 else aString += '\\frac{' + top1 + '}{' + bot1.write! + '}'
        aString += '\\right)'
  aString += '\\)</li><li>\\('
  if top2 is 0
    aString += '\\pi/2'
  else
    if top2 is 1 and bot2.n is 1 and bot2.a is 1
      aString += '0'
    else
      if not (top2 is -1 and bot2.n is 1 and bot2.a is 1)
        aString += '\\arccos\\left('
        if bot2.a is 1 and bot2.n is 1 then aString += top2 else aString += '\\frac{' + top2 + '}{' + bot2.write! + '}'
        aString += '\\right)'
  aString += '\\)</li></ol></li></ol>'
  qa = [qString, aString]
  qa

makeLines = ->
  a1 = randnz 3
  b1 = randnz 3
  c1 = randnz 3
  d1 = rand 3
  e1 = rand 3
  f1 = rand 3
  a2 = void
  b2 = void
  c2 = void
  d2 = void
  e2 = void
  f2 = void
  ch = rand 1, 10
  if ch < 6
    a2 = randnz 3
    b2 = randnz 3
    c2 = randnz 3
    d2 = rand 3
    e2 = rand 3
    f2 = rand 3
  else
    if ch < 10
      a2 = randnz 2
      b2 = randnz 2
      c2 = randnz 2
      if a1 * b1 * c1 % 3 is 0 and a1 * b1 * c1 % 2 is 0
        if rand!
          a1 /= 3 if a1 % 3 is 0
          if b1 % 3 is 0 then b1 /= 3
          if c1 % 3 is 0 then c1 /= 3
        else
          a1 /= 2 if a1 % 2 is 0
          if b1 % 2 is 0 then b1 /= 2
          if c1 % 2 is 0 then c1 /= 2
      if not (a2 * d1 % a1 is 0)
        a2 *= a1
        b2 *= a1
        c2 *= a1
      if not (b2 * e1 % b1 is 0)
        a2 *= b1
        b2 *= b1
        c2 *= b1
      if not (c2 * f1 % c1 is 0)
        a2 *= c1
        b2 *= c1
        c2 *= c1
      d2 = a2 * d1 / a1
      e2 = b2 * e1 / b1
      f2 = c2 * f1 / c1
      m1 = Math.abs Math.min d2, Math.min e2, f2
      m2 = Math.max d2, Math.max e2, f2
      if m1 > 4
        d2 += 4
        e2 += 4
        f2 += 4
      if m2 > 4
        d2 -= 2
        e2 -= 2
        f2 -= 2
      if (m1 = gcd a2, b2, c2, d2, e2, f2) > 1
        a2 /= m1
        b2 /= m1
        c2 /= m1
        d2 /= m1
        e2 /= m1
        f2 /= m1
    else
      sn = randnz 2
      a2 = a1 * sn
      b2 = b1 * sn
      c2 = c1 * sn
      d2 = rand 3
      e2 = rand 3
      f2 = rand 3
  p1 = new poly 1
  p1.0 = d1
  p1.1 = a1
  q1 = new poly 1
  q1.0 = e1
  q1.1 = b1
  r1 = new poly 1
  r1.0 = f1
  r1.1 = c1
  p2 = new poly 1
  p2.0 = d2
  p2.1 = a2
  q2 = new poly 1
  q2.0 = e2
  q2.1 = b2
  r2 = new poly 1
  r2.0 = f2
  r2.1 = c2
  eqn1 = (p1.write 'x') + '=' + q1.write 'y' + '=' + r1.write 'z'
  eqn2 = (p2.write 'x') + '=' + q2.write 'y' + '=' + r2.write 'z'
  qString = 'Consider the lines$$' + eqn1 + '$$and$$' + eqn2 + '$$Find the angle between them<br>and determine whether they<br>intersect.'
  aString = ''
  if a1 * b2 is b1 * a2 and b1 * c2 is c1 * b2
    if a2 * b2 * d1 - b2 * a1 * d2 is a2 * b2 * e1 - a2 * b1 * e2 and b2 * c2 * e1 - c2 * b1 * e2 is b2 * c2 * f1 - b2 * c1 * f2 then aString = '\\mbox{The lines are identical.}' else aString = 'The lines are parallel and do not meet.'
  else
    cosbot = new sqroot (b1 * b1 * c1 * c1 + c1 * c1 * a1 * a1 + a1 * a1 * b1 * b1) * (b2 * b2 * c2 * c2 + c2 * c2 * a2 * a2 + a2 * a2 * b2 * b2)
    costh = new frac b1 * b2 * c1 * c2 + c1 * c2 * a1 * a2 + a1 * a2 * b1 * b2, cosbot.a
    cosbot.a = costh.bot
    aString = 'The angle between the lines is$$'
    if not (costh.top is 0)
      aString += '\\arccos\\left('
      if cosbot.n is 1 then aString += costh.write! else aString += '\\frac{' + costh.top + '}{' + cosbot.write! + '}'
      aString += '\\right).$$'
    mu = new frac
    lam1 = new frac
    lam2 = new frac
    if a1 * b2 - a2 * b1
      mu.set a2 * b2 * (e1 - d1) - a2 * b1 * e2 + a1 * b2 * d2, a1 * b2 - a2 * b1
      lam1.set b1 * mu.top - b1 * e2 * mu.bot + e1 * b2 * mu.bot, mu.bot * b2
      lam2.set c1 * mu.top - c1 * f2 * mu.bot + f1 * c2 * mu.bot, mu.bot * c2
    else
      mu.set b2 * c2 * (f1 - e1) - b2 * c1 * f2 + b1 * c2 * e2, b1 * c2 - b2 * c1
      lam1.set c1 * mu.top - c1 * f2 * mu.bot + f1 * c2 * mu.bot, mu.bot * c2
      lam2.set a1 * mu.top - a1 * d2 * mu.bot + d1 * a2 * mu.bot, mu.bot * a2
    if lam1.equals lam2
      xm = new frac lam1.top - d1 * lam1.bot, a1 * lam1.bot
      ym = new frac lam1.top - e1 * lam1.bot, b1 * lam1.bot
      zm = new frac lam1.top - f1 * lam1.bot, c1 * lam1.bot
      aString += 'The lines meet at the point$$\\left(' + xm.write! + ',' + ym.write! + ',' + zm.write! + '\\right).$$'
    else
      aString += 'The lines do not meet.'
  qa = [qString, aString]
  qa

makeLinesEq = ->
  makeLines1 = ->
    a = rand 6
    b = rand 6
    c = rand 6
    d = rand 6
    while a is c and b is d
      c = rand 6
      d = rand 6
    qString = 'Find the equation of the line passing through \\((' + a + ',' + b + ')\\) and \\((' + c + ',' + d + ')\\).'
    if b is d
      aString = '$$y=' + b + '.$$'
    else
      if a is c
        aString = '$$x=' + a + '.$$'
      else
        if d - b is c - a
          grad = ''
        else
          if d - b is a - c
            grad = '-'
          else
            grad = new frac d - b, c - a
            grad = grad.write!
        intercept = new frac (Math.abs b * (c - a) - (d - b) * a), Math.abs c - a
        intercept = intercept.write!
        if b - (d - b) / (c - a) * a < 0 then intercept = '-' + intercept else if b * (c - a) is (d - b) * a then intercept = '' else intercept = '+' + intercept
        aString = '$$y=' + grad + 'x' + intercept + '\\qquad \\text{or} \\qquad ' + lineEq1 a, b, c, d + '.$$'
    qa = [qString, aString]
    qa
  qa = makeLines1!
  qa

makeLineParPerp = ->
  makeLinePar = (a, b, m, c) ->
    qString = 'Find the equation of the line passing through \\((' + a + ',' + b + ')\\) and parallel to the line '
    if (Math.abs m) is 6
      while a is c
        c = rand 5
      qString += '\\(x=' + c + '\\).'
      aString = '$$x=' + a + '.$$'
    else
      if rand! then qString += '\\(' + lineEq1 0, c, 1, m + c + '.\\)' else qString += '\\(' + lineEq2 m, c + '.\\)'
      intercept = b - m * a
      if m is 0
        aString = '$$y=' + b + '.$$'
      else
        aString = '$$' + lineEq2 m, intercept + '\\qquad\\text{or}\\qquad ' + lineEq1 0, intercept, 1, m + intercept + '$$'
    qa = [qString, aString]
    qa
  makeLinePerp = (a, b, m, c) ->
    qString = 'Find the equation of the line passing through \\((' + a + ',' + b + ')\\) and perpendicular to the line '
    if (Math.abs m) is 6
      while a is c
        c = rand 5
      qString += '\\(x=' + c + '\\).'
      aString = '$$y=' + b + '.$$'
    else
      if m is 0
        while a is c
          c = rand 5
        qString += '\\(y=' + c + '\\).'
        aString = '$$x=' + a + '.$$'
      else
        if rand! then qString += '\\(' + lineEq1 0, c, 1, m + c + '.\\)' else qString += '\\(' + lineEq2 m, c + '.\\)'
        aString = '$$y='
        grad = new frac -1, m
        intercept = new frac b * m + a, m
        C = (b * m + a) / m
        if m is -1 then aString += 'x' else if m is 1 then aString += '-x' else aString += grad.write! + 'x'
        if C % 1 is 0 and C isnt 0
          aString += signedNumber C
        else
          if C > 0 then aString += '+' + intercept.write! else if C < 0 then aString += intercept.write!
        aString += '\\qquad\\text{or}\\qquad '
        if m is 1 then aString += 'x+y' else if m is -1 then aString += 'x-y' else aString += 'x' + signedNumber m + 'y'
        if -b * m - a isnt 0 then aString += signedNumber -b * m - a
        aString += '=0.$$'
    qa = [qString, aString]
    qa
  a = rand 6
  b = rand 6
  m = rand 6
  c = rand 6
  qa = if rand! then makeLinePar a, b, m, c else makeLinePerp a, b, m, c
  qa

makeCircleEq = ->
  makeCircleEq1 = (a, b, r) ->
    qString = 'Find the equation of the circle with centre \\((' + a + ',' + b + ')\\) and radius \\(' + r + '\\).'
    if a is 0 and b is 0
      aString = '$$' + circleEq1 a, b, r + '.$$'
    else
      aString = '$$' + circleEq1 a, b, r + '\\qquad\\text{or}\\qquad ' + circleEq2 a, b, r + '.$$'
    qa = [qString, aString]
    qa
  makeCircleEq2 = (a, b, r) ->
    qString = 'Find the centre and radius of the circle with equation'
    if rand! then qString += '$$' + circleEq1 a, b, r + '.$$' else qString += '$$' + circleEq2 a, b, r + '.$$'
    aString = 'The circle has centre \\((' + a + ',' + b + ')\\) and radius \\(' + r + '  \\).'
    qa = [qString, aString]
    qa
  r = rand 2, 7
  a = rand 6
  b = rand 6
  qa = if rand! then makeCircleEq1 a, b, r else makeCircleEq2 a, b, r
  qa

makeCircLineInter = ->
  makeLLInter = ->
    m1 = rand 6
    m2 = rand 6
    c1 = rand 6
    c2 = rand 6
    m1 = m2 if rand!
    while m1 is m2 and c1 is c2
      m2 = rand 6
      c2 = rand 6
    qString = 'Find all the points where the line \\('
    if rand! then qString += lineEq1 0, c1, 1, m1 + c1 else qString += lineEq2 m1, c1
    qString += '\\) and the line \\('
    if rand! then qString += lineEq1 0, c2, 1, m2 + c2 else qString += lineEq2 m2, c2
    qString += '\\) intersect.'
    if m1 is m2
      aString = 'The lines do not intersect.'
    else
      xint = new frac c2 - c1, m1 - m2
      yint = new frac m1 * (c2 - c1) + c1 * (m1 - m2), m1 - m2
      aString = 'The lines intersect in a single point, which occurs at \\(\\left(' + xint.write! + ',' + yint.write! + '\\right)\\).'
    qa = [qString, aString]
    qa
  makeCLInter = ->
    a = rand 6
    b = rand 6
    r = rand 2, 7
    m = rand 6
    c = rand 6
    qString = 'Find all the points where the line \\('
    if rand! then qString += lineEq1 0, c, 1, m + c else qString += lineEq2 m, c
    qString += '\\) and the circle \\( '
    if rand! then qString += circleEq1 a, b, r else qString += circleEq2 a, b, r
    qString += '\\) intersect.'
    A = m * m + 1
    B = -2 * a + 2 * m * (c - b)
    C = (c - b) * (c - b) - r * r + a * a
    disc = B * B - 4 * A * C
    sq = new sqroot disc
    if disc > 0
      aString = 'The line and the circle intersect in two points, specifically '
      aString += '$$\\left('
      aString += simplifySurd -B, sq.a, sq.n, 2 * A
      aString += ',' + simplifySurd -m * B + 2 * c * A, m * sq.a, sq.n, 2 * A
      aString += '\\right)'
      aString += '\\qquad\\text{and}\\qquad '
      aString += '\\left('
      aString += simplifySurd -B, -sq.a, sq.n, 2 * A
      aString += ',' + simplifySurd -m * B + 2 * c * A, -m * sq.a, sq.n, 2 * A
      aString += '\\right)'
      aString += '$$'
    else
      if disc < 0
        aString = 'The line and the circle do not intersect in any points.'
      else
        if disc is 0
          xint = new frac -B, 2 * A
          yint = new frac -B * m + c * 2 * A, 2 * A
          aString = 'The line and the circle intersect in exactly one point, which occurs at \\(\\left(' + xint.write! + ',' + yint.write! + '\\right)\\).'
    qa = [qString, aString]
    qa
  makeCCInter = ->
    a1 = rand 6
    b1 = rand 6
    r1 = rand 2, 7
    a2 = rand 6
    b2 = rand 6
    r2 = rand 2, 7
    while a1 is a2 and b1 is b2 and r1 is r2
      a2 = rand 6
      b2 = rand 6
      r2 = rand 2, 7
    qString = 'Find all the points where the circle \\('
    if rand! then qString += circleEq1 a1, b1, r1 else qString += circleEq2 a1, b1, r1
    qString += '\\) and the circle \\('
    if rand! then qString += circleEq1 a2, b2, r2 else qString += circleEq2 a2, b2, r2
    qString += '\\) intersect.'
    D = Math.sqrt (b2 - b1) * (b2 - b1) + (a2 - a1) * (a2 - a1)
    DD = (b2 - b1) * (b2 - b1) + (a2 - a1) * (a2 - a1)
    R = r1 + r2
    RR = r1 * r1 - r2 * r2
    S = Math.abs r1 - r2
    if R > D and D > S
      aString = 'The circles intersect in two points, which are'
      d = new sqroot -DD * DD + 2 * DD * r1 * r1 - r1 * r1 * r1 * r1 + 2 * DD * r2 * r2 + 2 * r1 * r1 * r2 * r2 - r2 * r2 * r2 * r2
      aString += '$$\\left('
      aString += simplifySurd (a1 + a2) * DD + (a2 - a1) * RR, (b1 - b2) * d.a, d.n, 2 * DD
      aString += ',' + simplifySurd (b1 + b2) * DD + (b2 - b1) * RR, (a2 - a1) * d.a, d.n, 2 * DD
      aString += '\\right)'
      aString += '\\qquad\\text{and}\\qquad '
      aString += '\\left('
      aString += simplifySurd (a1 + a2) * DD + (a2 - a1) * RR, (b2 - b1) * d.a, d.n, 2 * DD
      aString += ',' + simplifySurd (b1 + b2) * DD + (b2 - b1) * RR, (a1 - a2) * d.a, d.n, 2 * DD
      aString += '\\right)'
      aString += '$$'
    else
      if d is R
        x1 = new frac a1 * R + r1 * (a2 - a1), R
        y1 = new frac b1 * R + r1 * (b2 - b1), R
        aString = 'The circles intersect in a single point, which is \\((' + x1.write! + ',' + y1.write! + ')\\).'
      else
        if D > R or D <= S then aString = 'The two circles do not intersect in any points.' else aString = 'Uh oh'
    qa = [qString, aString]
    qa
  if rand! then qa = makeCLInter! else if rand! then qa = makeLLInter! else qa = makeCCInter!
  qa

makeIneq = ->
  makeIneq2 = ->
    roots = distrandnz 2, 6
    B = -roots.0 - roots.1
    C = roots.0 * roots.1
    qString = 'By factorizing a suitable polynomial, or otherwise, find the values of \\(x\\) which satisfy$$'
    p = new poly 2
    switch rand 1, 3
    case 1
      p.0 = 0
      p.1 = B
      p.2 = 1
      qString += p.write! + ' < ' + -C
    case 2
      p.0 = C
      p.1 = 0
      p.2 = 1
      qString += p.write! + ' < ' + if B then (ascoeff -B) + 'x' else '0'
    case 3
      p.0 = -C
      p.1 = -B
      p.2 = 0
      qString += 'x^2' + ' < ' + p.write!
    qString += '$$'
    aString = '$$' + Math.min roots.0, roots.1 + ' < x < ' + Math.max roots.0, roots.1 + '$$'
    qa = [qString, aString]
    qa
  makeIneq3 = ->
    a = randnz 5
    b = randnz 5
    c = rand 2
    qString = 'By factorizing a suitable polynomial, or otherwise, find the values of \\(y\\) which satisfy$$'
    B = -(a + b + c)
    C = a * b + b * c + c * a
    D = -a * b * c
    p = new poly 3
    p.set 0, 0, 0, 1
    q = new poly 2
    q.set 0, 0, 0
    switch rand 1, 3
    case 1
      p.2 = B
      q.1 = -C
      q.0 = -D
    case 2
      p.1 = C
      q.2 = -B
      q.0 = -D
    case 3
      p.0 = D
      q.2 = -B
      q.1 = -C
    qString += (p.write 'y') + ' < ' + q.write 'y' + '$$'
    m = [
      a
      b
      c
    ]
    r = ranking m
    aString = '$$y < ' + m[r.0]
    if not (m[r.1] is m[r.2]) then aString += '$$and$$' + m[r.1] + ' < y < ' + m[r.2] + '$$' else aString += '$$'
    qa = [qString, aString]
    qa
  qa = if rand! then makeIneq2! else makeIneq3!
  qa

makeAP = ->
  m = rand 2, 6
  n = rand m + 2, 11
  k = rand (Math.max n + 3, 10), 40
  a1 = new frac
  a2 = new frac
  qString = 'An arithmetic progression has ' + ordt m + ' term \\(\\alpha\\) and ' + ordt n + ' term \\(\\beta\\). Find the '
  if rand! is 0
    qString += 'sum to \\(' + k + '\\) terms.'
    a1.set k * (2 * n - 1 - k), 2 * (n - m)
    a2.set k * (1 + k - 2 * m), 2 * (n - m)
  else
    qString += 'value of the \\(' + ordt k + '\\) term.'
    a1.set n - k, n - m
    a2.set k - m, n - m
  aString = '$$' + fcoeff a1, '\\alpha' + if a2.top > 0 then ' + ' else ' - ' + fbcoeff a2, '\\beta' + '$$'
  qa = [qString, aString]
  qa

makeFactor = ->
  makeFactor1 = ->
    a = randnz 4
    b = randnz 7
    c = randnz 7
    u = new poly 1
    v = new poly 1
    w = new poly 1
    u.1 = v.1 = w.1 = 1
    u.0 = a
    v.0 = b
    w.0 = c
    x = polyexpand (polyexpand u, v), w
    qString = 'Divide $$' + x.write! + '$$ by $$(' + u.write! + ')$$ and hence factorise it completely.'
    aString = '$$' + express [
      a
      b
      c
    ] + '$$'
    qa = [qString, aString]
    qa
  makeFactor2 = ->
    a = randnz 2
    b = randnz 5
    c = randnz 5
    u = new poly 1
    v = new poly 1
    w = new poly 1
    u.1 = v.1 = w.1 = 1
    u.0 = a
    v.0 = b
    w.0 = c
    x = polyexpand (polyexpand u, v), w
    qString = 'Use the factor theorem to factorise $$' + x.write! + '.$$'
    aString = '$$' + express [
      a
      b
      c
    ] + '$$'
    qa = [qString, aString]
    qa
  makeFactor3 = ->
    a = randnz 2
    b = randnz 4
    c = randnz 4
    d = randnz 4
    d = -d if d is c
    u = new poly 1
    v = new poly 1
    w = new poly 1
    y = new poly 1
    u.1 = v.1 = w.1 = y.1 = 1
    u.0 = a
    v.0 = b
    w.0 = c
    y.0 = d
    x = polyexpand (polyexpand u, v), w
    z = polyexpand (polyexpand u, v), y
    qString = 'Simplify$$\\frac{' + x.write! + '}{' + z.write! + '}.$$'
    aString = '$$\\frac{' + w.write! + '}{' + y.write! + '}$$'
    qa = [qString, aString]
    qa
  qa = void
  if rand! then qa = makeFactor1! else if rand! then qa = makeFactor2! else qa = makeFactor3!
  qa

makeQuadratic = ->
  qString = 'Find the real roots, if any, of$$'
  aString = void
  if rand!
    p = new poly 2
    p.setrand 5
    p.2 = 1
    qString += p.write!
    dcr = p.1 * p.1 - 4 * p.0
    if dcr < 0
      aString = 'There are no real roots.'
    else
      if dcr is 0
        r1 = new frac -p.1, 2
        aString = '$$x=' + r1.write! + '$$is a repeated root.'
      else
        disc = new sqroot dcr
        r1 = new frac -p.1, 2
        if disc.n is 1
          r1.add disc.a, 2
          aString = '$$x=' + r1.write! + '\\mbox{ and }x='
          r1.add -disc.a
          aString += r1.write! + '$$'
        else
          r2 = new frac disc.a, 2
          aString = '$$x=' + if r1.top then r1.write! else '' + '\\pm'
          aString += r2.write! if r2.top isnt 1 or r2.bot isnt 1
          aString += '\\sqrt{' + disc.n + '}$$'
  else
    roots = distrandnz 2, 5
    p = new poly 2
    p.2 = 1
    p.1 = -roots.0 - roots.1
    p.0 = roots.0 * roots.1
    qString += p.write!
    aString = '$$x=' + roots.0 + '\\mbox{ and }x=' + roots.1 + '$$'
  qString += '=0$$'
  qa = [qString, aString]
  qa

makeComplete = ->
  a = randnz 4
  b = randnz 5
  p = new poly 2
  p.2 = 1
  p.1 = -2 * a
  p.0 = a * a + b
  qString = void
  aString = void
  if rand!
    qString = 'By completing the square, find (for real \\(x\\)) the minimum value of$$' + p.write! + '.$$'
    aString = 'The minimum value is \\(' + b + ',\\) which occurs at \\(x=' + a + '\\).'
  else
    c = randnz 3
    d = randnz c + 2, c + 4
    qString = 'Find the minimum value of$$' + p.write! + '$$in the range$$' + c + '\\leq x\\leq' + d + '.$$'
    if c <= a and a <= d
      aString = 'The minimum value is \\(' + b + '\\) which occurs at \\(x=' + a + '\\)'
    else
      if a < c
        aString = 'The minimum value is \\(' + c * c - 2 * a * c + a * a + b + '\\) which occurs at \\(x=' + c + '\\)'
      else
        aString = 'The minimum value is \\(' + d * d - 2 * a * d + a * a + b + '\\) which occurs at \\(x=' + d + '\\)'
  qa = [qString, aString]
  qa

makeBinExp = ->
  a = rand 1, 3
  b = randnz 2
  n = rand 2, 5
  m = rand 1, n - 1
  pow = new frac m, n
  p = new fpoly 1
  p.0 = new frac 1, 1
  p.1 = new frac b, a
  qString = 'Find the first four terms in the expansion of $$\\left(' + p.rwrite! + '\\right)^{' + pow.write! + '}$$'
  q = new fpoly 3
  q.0 = new frac 1
  q.1 = new frac m * b, n * a
  q.2 = new frac m * (m - n) * b * b, 2 * n * n * a * a
  q.3 = new frac m * (m - n) * (m - 2 * n) * b * b * b, 6 * n * n * n * a * a * a
  aString = '$$' + q.rwrite! + '$$'
  qa = [qString, aString]
  qa

makeLog = ->
  makeLog1 = ->
    a = pickrand 2, 3, 5
    m = rand 1, 4
    n = rand 1, 4
    n++ if n >= m
    qString = 'If \\(' + Math.pow a, m + '=' + Math.pow a, n + '^{x},\\) then find \\(x\\).'
    r = new frac m, n
    aString = '$$x=' + r.write! + '$$'
    qa = [qString, aString]
    qa
  makeLog2 = ->
    a = rand 2, 9
    b = rand 2, 5
    c = b * b
    qString = 'Find \\(x\\) if \\(' + c + '\\log_{x}' + a + '=\\log_{' + a + '}x\\).'
    aString = '$$x=' + Math.pow a, b + '\\mbox{ or }x=\\frac{1}{' + Math.pow a, b + '}$$'
    qa = [qString, aString]
    qa
  makeLog3 = ->
    a = rand 2, 7
    b = Math.floor Math.pow a, 7 * Math.random!
    qString = 'If \\(' + a + '^{x}=' + b + '\\), then find \\(x\\) to three decimal places.'
    c = new Number (Math.log b) / Math.log a
    aString = '$$x=' + c.toFixed 3 + '$$'
    qa = [qString, aString]
    qa
  qa = void
  switch rand 1, 3
  case 1
    qa = makeLog1!
  case 2
    qa = makeLog2!
  case 3
    qa = makeLog3!
  qa

makeStationary = ->
  makeStationary2 = ->
    p = new poly 2
    p.set (randnz 4), (randnz 8), randnz 4
    d = new frac -p.1, 2 * p.2
    qString = 'Find the stationary point of $$y=' + p.write! + ',$$ and state whether it is a maximum or a minimum.'
    aString = 'The stationary point occurs at \\(x=' + d.write! + '\\), and it is a '
    if p.2 > 0 then aString += 'minimum.' else aString += 'maximum.'
    qa = [qString, aString]
    qa
  makeStationary3 = ->
    p = new poly 3
    d = randnz 4
    c = randnz 3
    b = randnz 3
    a = randnz 5
    b++ if (Math.abs c * (b + a)) % 2 is 1
    p.set d, 3 * c * a * b, -3 * c * (a + b) / 2, c
    qString = 'Find the stationary points of $$y=' + p.write! + ',$$ and state their nature.'
    aString = void
    if a is b
      aString = 'The stationary point occurs at \\(x=' + a + ',\\) and is a point of inflexion.'
    else
      if c > 0
        aString = 'The stationary points occur at \\(x=' + Math.min a, b + '\\), a maximum, and \\(x=' + Math.max a, b + '\\), a minimum'
      else
        aString = 'The stationary points occur at \\(x=' + Math.min a, b + '\\), a minimum, and \\(x=' + Math.max a, b + '\\), a maximum'
    qa = [qString, aString]
    qa
  qa = void
  switch rand 2, 3
  case 2
    qa = makeStationary2!
  case 3
    qa = makeStationary3!
  qa

makeTriangle = ->
  makeTriangle1 = ->
    a = rand 3, 8
    b = rand a + 1, 16
    m = distrand 3, 0, 2
    s = [
      'AB'
      'BC'
      'CA'
    ]
    hyp = s[m.0]
    shortv = s[m.1]
    other = s[m.2]
    angle = void
    switch hyp
    case 'AB'
      angle = 'C'
    case 'BC'
      angle = 'A'
    case 'CA'
      angle = 'B'
    qString = 'In triangle \\(ABC\\), \\(' + shortv + '=' + a + '\\), \\(' + hyp + '=' + b + ',\\) and angle \\(' + angle + '\\) is a right angle. Find the length of \\(' + other + '\\).'
    length = new sqroot b * b - a * a
    aString = '$$' + other + '=' + length.write! + '$$'
    qa = [qString, aString]
    qa
  makeTriangle2 = ->
    a = rand 2, 8
    b = rand 1, 6
    c = rand (Math.max a, b) - Math.min a, b + 1, a + b - 1
    qString = 'In triangle \\(ABC\\), \\(AB=' + c + '\\), \\(BC=' + a + ',\\) and \\(CA=' + b + '.\\) Find the angles of the triangle.'
    aa = new frac b * b + c * c - a * a, 2 * b * c
    bb = new frac c * c + a * a - b * b, 2 * c * a
    cc = new frac a * a + b * b - c * c, 2 * a * b
    aString = '$$\\cos A=' + aa.write! + ',\\cos B=' + bb.write! + ',\\cos C=' + cc.write! + '.$$'
    qa = [qString, aString]
    qa
  makeTriangle3 = ->
    a = rand 1, 6
    cc = pickrand 3, 4, 6
    lb = a * Math.ceil Math.sin Math.PI / cc
    c = rand lb, Math.max 5, lb + 1
    qString = 'In triangle \\(ABC\\), \\(AB=' + c + '\\), \\(BC=' + a + '\\) and angle \\(C=\\frac{\\pi}{' + cc + '}\\). Find angle \\(A\\).'
    d = new frac a, 2 * c
    aString = '$$A=\\arcsin\\left(' + d.write!
    if cc is 3 then aString += '\\sqrt{3}' else if cc is 4 then aString += '\\sqrt{2}'
    aString += '\\right)$$'
    qa = [qString, aString]
    qa
  qa = void
  switch rand 1, 3
  case 1
    qa = makeTriangle1!
  case 2
    qa = makeTriangle2!
  case 3
    qa = makeTriangle3!
  qa

makeCircle = ->
  r = rand 2, 8
  bot = rand 2, 9
  top = rand 1, 2 * bot - 1
  prop = new frac top, bot
  qString = 'Find, for a sector of angle \\('
  qString += if prop.bot is 1 then (ascoeff prop.top) + '\\pi' else '\\frac{' + ascoeff prop.top + '\\pi}{' + prop.bot + '}'
  qString += '\\) of a disc of radius \\(' + r + ':\\)<br>i. the length of the perimeter; and<br>ii. the area.'
  length = new frac prop.top * r, prop.bot
  area = new frac prop.top * r * r, 2 * prop.bot
  aString = 'i. \\(' + r * 2 + '+' + length.write! + '\\pi\\)<br>ii. \\(' + area.write! + '\\pi\\)'
  qa = [qString, aString]
  qa

makeSolvingTrig = ->
  A = pickrand 1, 3, 4, 5
  alpha = pickrand 3, 4, 6
  c = new frac A, 2
  qString = 'Write $$' + c.write!
  if alpha is 6 then qString += '\\sqrt{3}' else if alpha is 4 then qString += '\\sqrt{2}'
  qString += '\\sin{\\theta}+' + c.write!
  if alpha is 4 then qString += '\\sqrt{2}' else if alpha is 3 then qString += '\\sqrt{3}'
  qString += '\\cos{\\theta}$$ in the form \\(A\\sin(\\theta+\\alpha),\\) where \\(A\\) and \\(\\alpha\\) are to be determined.'
  aString = '$$' + if A is 1 then '' else A + '\\sin\\left(\\theta+\\frac{\\pi}{' + alpha + '}\\right)$$'
  qa = [qString, aString]
  qa

makeVectorEq = ->
  a = new vector 3
  a.setrand 6
  b = new vector 3
  b.setrand 6
  l = distrand 3, 5
  v = new Array 3
  i = 0
  while i < 3
    v[i] = new vector 3
    v[i].set a.0 + l[i] * b.0, a.1 + l[i] * b.1, a.2 + l[i] * b.2
    i++
  qString = 'Show that the points with position vectors$$' + v.0.write! + '\\,,\\;' + v.1.write! + '\\,,\\;' + v.2.write! + '$$'
  qString += 'lie on a straight line, and give the equation of the line in the form \\(\\mathbf{r}=\\mathbf{a}+\\lambda\\mathbf{b}\\).'
  aString = '$$' + a.write! + '+\\lambda\\,' + b.write! + '$$'
  qa = [qString, aString]
  qa

makeImplicit = ->
  if rand!
    a1 = rand 1, 3
    b1 = randnz 4
    c1 = rand 1, 3
    d1 = randnz 4
    if d1 > 0 then d1++ else d1-- if d1 * a1 - b1 * c1 is 0
    a2 = randnz 3
    b2 = randnz 4
    c2 = rand 1, 3
    d2 = randnz 4
    if d2 * a2 - b2 * c2 is 0 then if d2 > 0 then d2++ else d2--
    t = randnz 3
    while c1 * t + d1 is 0 or c2 * t + d2 is 0
      if t > 0 then t++ else t--
    qString = 'If $$y=\\frac{' + (p_linear a1, b1).write 't' + '}{' + (p_linear c1, d1).write 't' + '}$$ and $$x=\\frac{' + (p_linear a2, b2).write 't' + '}{' + (p_linear c2, d2).write 't' + '},$$find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) when \\(t=' + t + '\\).'
    a = new frac (a1 * d1 - b1 * c1) * (c2 * t + d2) * (c2 * t + d2), (a2 * d2 - b2 * c2) * (c1 * t + d1) * (c1 * t + d1)
    aString = '$$' + a.write! + '$$'
    qa = [qString, aString]
    qa
  else
    fns = new Array '\\ln(z)', 'e^{z}', '\\csc(z)', '\\sec(z)', '\\sin(z)', '\\tan(z)', '\\cos(z)'
    difs = new Array '\\frac{1}{z}', 'e^{z}', '-\\csc(z)\\cot(z)', '\\sec(z)\\tan(z)', '\\cos(z)', '\\sec^2(z)', '-\\sin(z)'
    which = distrand 2, 0, 6
    p = new poly rand 1, 3
    p.setrand 3
    q = new poly 1
    p.diff q
    qString = 'If $$y+' + fns[which.0].replace //z//g, 'y' + '=' + fns[which.1].replace //z//g, 'x' + if p[p.rank] > 0 then '+' else '' + p.write 'x' + ',$$ find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(y\\) and \\(x\\).'
    aString = '$$\\frac{\\mathrm{d}y}{\\mathrm{d}x} = \\frac{' + difs[which.1].replace //z//g, 'x' + if q[q.rank] > 0 then '+' else '' + q.write 'x' + '}{' + difs[which.0].replace //z//g, 'y' + '+1}$$'
    qa = [qString, aString]
    qa

makeChainRule = ->
  fns = new Array '\\ln(z)', '\\csc(z)', '\\sec(z)', '\\sin(z)', '\\tan(z)', '\\cos(z)'
  difs = new Array '\\frac{y}{z}', '-y\\csc(z)\\cot(z)', 'y\\sec(z)\\tan(z)', 'y\\cos(z)', 'y\\sec^2(z)', '-y\\sin(z)'
  even = new Array -1, 1, -1, 1, 1, -1
  which = rand 0, 5
  a = new poly rand 1, 3
  a.setrand 8
  b = new poly 0
  a.diff b
  qString = 'Differentiate \\(' + fns[which].replace //z//g, a.write! + '\\)'
  if (difs[which].charAt 0) is '-'
    difs[which] = difs[which].slice 1
    b.xthru -1
  if a[a.rank] < 0
    a.xthru -1
    b.xthru even[which]
  aString = void
  if which is 0
    c = gcd a.gcd!, b.gcd!
    a.xthru 1 / c
    b.xthru 1 / c
  if b.terms! > 1 and which then aString = '(' + b.write! + ')' else if b.rank is 0 and which then aString = ascoeff b.0 else aString = b.write!
  aString = '$$' + (difs[which].replace //z//g, a.write!).replace //y//g, aString + '$$'
  qa = [qString, aString]
  qa

makeProductRule = ->
  fns = new Array '\\ln(z)', '\\csc(z)', '\\sec(z)', '\\sin(z)', '\\tan(z)', '\\cos(z)'
  difs = new Array '\\frac{y}{z}', '-y\\csc(z)\\cot(z)', 'y\\sec(z)\\tan(z)', 'y\\cos(z)', 'y\\sec^2(z)', '-y\\sin(z)'
  even = new Array -1, 1, -1, 1, 1, -1
  which = rand 0, 5
  a = new poly rand 1, 3
  a.setrand 8
  b = new poly 0
  a.diff b
  qString = 'Differentiate $$'
  if a.terms! > 1 then qString += '(' + a.write! + ')' + fns[which].replace //z//g, 'x' else qString += a.write! + fns[which].replace //z//g, 'x'
  qString += '$$'
  aString = void
  if b.terms! > 1
    aString = '$$(' + b.write! + ')'
  else
    if b.0 is 1 then aString = '$$' else if b.0 is -1 then aString = '$$-' else aString = '$$' + b.write!
  if (difs[which].charAt 0) is '-'
    difs[which] = difs[which].slice 1
    a.xthru -1
  if not (a[a.rank] > 0)
    aString += (fns[which].replace //z//g, 'x') + ' - '
    a.xthru -1
  if which is 0 and a.0 is 0
    i = 0
    while i < a.rank
      a[i] = a[i + 1]
      i++
    a.rank--
    aString += a.write!
  else
    if a.terms! > 1 and which
      aString += (difs[which].replace //y//g, '(' + a.write! + ')').replace //z//g, 'x'
    else
      if a.0 is 1 and which then aString += difs[which].replace //y//g, '' else aString += (difs[which].replace //y//g, a.write!).replace //z//g, 'x'
  aString += '$$'
  qa = [qString, aString]
  qa

makeQuotientRule = ->
  fns = new Array '\\sin(z)', '\\tan(z)', '\\cos(z)'
  difs = new Array '\\csc(z)\\cot(z)', '\\csc^2(z)', '\\sec(z)\\tan(z)'
  even = new Array 1, 1, -1
  which = rand 0, 2
  a = randnz 8
  b = new poly 2
  b.setrand 8
  qString = 'Differentiate $$\\frac{' + a + '}{' + fns[which].replace //z//g, b.write! + '}$$'
  c = new poly 1
  b.diff c
  c.xthru a
  if b[b.rank] < 0
    b.xthru -1
    c.xthru even[which]
  lead = c.write!
  if c.terms! > 1 then lead = '(' + lead + ')' else if c.rank is 0 then if c.0 is 1 then lead = '' else if c.0 is -1 then lead = '-'
  bot = difs[which].replace //z//g, b.write!
  aString = '$$' + lead + bot + '$$'
  qa = [qString, aString]
  qa

makeGP = ->
  if rand!
    a = randnz 8
    b = rand 2, 9
    b = -b if rand!
    c = 1
    if rand!
      c = rand 2, 5
      c++ if c is b
      d = gcd b, c
      b /= d
      c /= d
    n = rand 5, 10
    qString = 'Evaluate $$\\sum_{r=0}^{' + n + '} ' + if a is 1 then '' else if a is -1 then if c is 1 and b > 0 then '-\\left(' else '-' else a + '\\times' + if c is 1 then if b < 0 then '\\left(' + b + '\\right)' else b else '\\left(\\frac{' + b + '}{' + c + '}\\right)' + '^{r}' + if a is -1 and c is 1 and b > 0 then '\\right)' else '' + '$$'
    top = new frac (-Math.pow b, n + 1), Math.pow c, n + 1
    top.add 1
    top.prod a
    bot = new frac -b, c
    bot.add 1
    ans = new frac top.top * bot.bot, top.bot * bot.top
    ans.reduce!
    aString = '$$' + ans.write! + '$$'
  else
    a = randnz 8
    b = rand 1, 6
    c = rand b + 1, 12
    b = -b if rand!
    r = new frac b, c
    r.reduce!
    qString = 'Evaluate$$\\sum_{r=0}^{\\infty} ' + if a is 1 then '' else if a is -1 then '-' else a + '\\times' + '\\left(' + r.write! + '\\right)^{r}$$'
    r.prod -1
    r.add 1
    ans = new frac a * r.bot, r.top
    aString = '$$' + ans.write! + '$$'
  qa = [qString, aString]
  qa

makeModulus = ->
  parms = 0
  fn = 0
  data = []
  graph = null
  drawIt = void
  if rand!
    a = randnz 4
    aa = Math.abs a
    l = rand -aa - 6, -aa - 2
    r = rand aa + 2, aa + 6
    qString = 'Sketch the graph of \\(|' + a + '-|x||\\) for \\(' + l + '\\leq{x}\\leq' + r + '\\).'
    drawIt = (parms) ->
      d1 = []
      n = 0
      i = parms.1
      while i <= parms.2
        n++
        d1.push [i, Math.abs parms.0 - Math.abs i]
        i = parms.2 if n > 50
        i += 0.5
      [d1]
    aString = '%GRAPH%'
    params = [
      a
      l
      r
    ]
  else
    a = distrandnz 2, 4
    s = [rand!, rand!]
    xa = Math.max (Math.abs a.0), Math.abs a.1
    l = rand -xa - 6, -xa - 2
    r = rand xa + 2, xa + 6
    qString = 'Sketch the graph of \\((' + a.0 + if s.0 then '+' else '-' + '|x|)(' + a.1 + if s.1 then '+' else '-' + '|x|)\\) for \\(' + l + '\\leq{x}\\leq' + r + '\\).'
    drawIt = (parms) ->
      a := parms.0
      s := parms.1
      l := parms.2
      r := parms.3
      d1 = []
      n = 0
      i = l
      while i <= r
        n++
        d1.push [i, (a.0 + if s.0 then Math.abs i else -Math.abs i) * (a.1 + if s.1 then Math.abs i else -Math.abs i)]
        i = r if n > 100
        i += 0.25
      [d1]
    aString = '%GRAPH%'
    params = [
      a
      s
      l
      r
    ]
  qa = [
    qString
    aString
    drawIt
    params
  ]
  qa

makeTransformation = ->
  fnn = new Array '\\ln(z)', '\\csc(z)', '\\sec(z)', '\\sin(z)', '\\tan(z)', '\\cos(z)', '{z}^{2}'
  which = rand 0, 6
  fnf = [
    Math.log
    (x) -> 1 / Math.sin x
    (x) -> 1 / Math.cos x
    Math.sin
    (x) -> Math.tan x
    Math.cos
    (x) -> Math.pow x, 2
  ][which]
  parms = 0
  fn = 0
  data = ''
  p = new poly 1
  p.setrand 2
  q = new poly 1
  q.setrand 3
  q.1 = Math.abs q.1
  if rand! then p.1 = 1 else if rand! then q.1 = 1 else if rand! then p.0 = 0 else q.0 = 0
  l = if which then rand -5, 2 else Math.max (Math.ceil (1 - q.0) / q.1), 0
  r = l + rand 4, 8
  qString = 'Let \\(f(x)=' + fnn[which].replace //z//g, 'x' + '\\). Sketch the graphs of \\(y=f(x)\\) and \\(y=' + p.write 'f(' + q.write! + ')' + '\\) for \\(' + l + if which is 0 and l is 0 then ' < ' else '\\leq ' + 'x \\leq ' + r + '\\).'
  drawIt = (parms) ->
    p := parms.0
    q := parms.1
    f = parms.2
    l := parms.3
    r := parms.4
    d1 = []
    d2 = []
    n = 0
    i = l
    while i <= r
      n++
      y1 = f i
      y1 = null if (Math.abs y1) > 20
      d1.push [i, y1]
      y2 = p.compute f q.compute i
      if (Math.abs y2) > 20 then y2 = null
      d2.push [i, y2]
      if n > 2500 then i = r
      i += 0.01
    [d1, d2]
  aString = '%GRAPH%'
  qa = [
    qString
    aString
    drawIt
    [
      p
      q
      fnf
      l
      r
    ]
  ]
  qa

makeComposition = ->
  p = new poly rand 1, 2
  p.setrand 2
  p.0 = randnz 2 if p.rank is 1 and p.0 is 0 and p.1 is 1
  fnf = new Array Math.sin, Math.tan, Math.cos, 0
  fnn = new Array '\\sin(z)', '\\tan(z)', '\\cos(z)', p.write 'z'
  which = distrand 2, 0, 3
  parms = 0
  fn = 0
  data = ''
  l = rand -4, 0
  r = rand (Math.max l + 5, 2), 8
  qString = 'Let \\(f(x)=' + fnn[which.0].replace //z//g, 'x' + ', g(x)=' + fnn[which.1].replace //z//g, 'x' + '.\\) Sketch the graph of \\(y=f(g(x))\\) (where it exists) for \\(' + l + '\\leq{x}\\leq' + r + '\\) and \\(-12\\leq{y}\\leq12.\\)'
  drawIt = (parms) ->
    f = parms.0
    g = parms.1
    p := parms.2
    l := parms.3
    r := parms.4
    d1 = []
    n = 0
    i = l
    while i <= r
      n++
      y2 = if g then g i else p.compute i
      y3 = if y2 then if f then f y2 else p.compute y2 else null
      y3 = null if (Math.abs y3) > 12
      d1.push [i, y3]
      if n > 2500 then i = r
      i += 0.01
    [d1]
  aString = '%GRAPH%'
  qa = [
    qString
    aString
    drawIt
    [
      fnf[which.0]
      fnf[which.1]
      p
      l
      r
    ]
  ]
  qa

makeParametric = ->
  p = new poly rand 1, 2
  p.setrand 2
  p.0 = randnz 2 if p.rank is 1 and p.0 is 0 and p.1 is 1
  fnf = new Array Math.log, ((x) -> 1 / Math.sin x), ((x) -> 1 / Math.cos x), Math.sin, Math.tan, Math.cos, 0
  fnn = new Array '\\ln(z)', '\\csc(z)', '\\sec(z)', '\\sin(z)', '\\tan(z)', '\\cos(z)', p.write 'z'
  which = distrand 2, 0, 6
  parms = 0
  fn = 0
  data = ''
  qString = 'Sketch the curve in the \\(xy\\) plane given by \\(x=' + fnn[which.0].replace //z//g, 't' + ', y=' + fnn[which.1].replace //z//g, 't' + '. t\\) is a real parameter which ranges from \\(' + if which.0 and which.1 then '-10' else '0' + ' \\mbox{ to } 10.\\)'
  drawIt = (parms) ->
    f = parms.0
    g = parms.1
    p := parms.2
    l = parms.3
    d1 = []
    i = l
    while i <= 10
      x = if f then f i else p.compute i
      x = null if (Math.abs x) > 12
      y = if g then g i else p.compute i
      if (Math.abs y) > 12 then y = null
      if x and y then d1.push [x, y] else d1.push [null, null]
      i += 0.01
    [d1]
  aString = '%GRAPH%'
  qa = [
    qString
    aString
    drawIt
    [
      fnf[which.0]
      fnf[which.1]
      p
      if which.0 and which.1 then -10 else 0
    ]
  ]
  qa

makeImplicitFunction = ->
  mIF1 = ->
    a = distrand 2, 2, 5
    n = randnz 3
    f = new frac a.0, a.1
    data = ''
    qString = 'Sketch the curve in the \\(xy\\) plane given by \\(y=' + ascoeff n + 'x^{' + f.write! + '}\\)'
    drawIt = (parms) ->
      f := parms.0
      n := parms.1
      d1 = []
      i = -10
      while i <= 10
        x = Math.pow i, f.bot
        x = null if (Math.abs x) > 12
        y = n * Math.pow i, f.top
        if (Math.abs y) > 12 then y = null
        if x and y then d1.push [x, y] else d1.push [null, null]
        i += 0.01
      [d1]
    aString = '%GRAPH%'
    qa = [
      qString
      aString
      drawIt
      [f, n]
    ]
    qa
  mIF2 = ->
    a = distrandnz 2, 5
    n = randnz 6
    f = new frac a.0, a.1
    data = ''
    qString = 'Sketch the curve in the \\(xy\\) plane given by \\(' + ascoeff a.0 + 'y' + if a.1 > 0 then '+' else '' + ascoeff a.1 + 'x' + if n > 0 then '+' else '' + n + '=0\\)'
    drawIt = (parms) ->
      f := parms.0
      n := parms.1
      d1 = []
      i = -10
      while i <= 10
        y = -i * a.1 / a.0 - n / a.0
        d1.push [i, y]
        i += 0.01
      [d1]
    parms = [f, n]
    aString = '%GRAPH%'
    qa = [
      qString
      aString
      drawIt
      [f, n]
    ]
    qa
  mIF3 = ->
    a = distrandnz 2, 2, 5
    qString = 'Sketch the curve in the \\(xy\\) plane given by \\(\\frac{x^2}{' + a.0 * a.0 + '} + \\frac{y^2}{' + a.1 * a.1 + '}=1\\)'
    drawIt = (parms) ->
      d1 = []
      i = -1
      while i <= 1
        x = parms.0 * Math.cos i * Math.PI
        y = parms.1 * Math.sin i * Math.PI
        d1.push [x, y]
        i += 0.005
      [d1]
    aString = '%GRAPH%'
    qa = [
      qString
      aString
      drawIt
      a
    ]
    qa
  (pickrand mIF1, mIF2, mIF3)!

makeIntegration = ->
  switch rand 0, 1
  case 0
    fns = new Array '\\ln(z)', '\\csc(z)', '\\sec(z)', '\\sin(z)', '\\tan(z)', '\\cos(z)'
    difs = new Array '\\frac{y}{z}', '-y\\csc(z)\\cot(z)', 'y\\sec(z)\\tan(z)', 'y\\cos(z)', 'y\\sec^2(z)', '-y\\sin(z)'
    even = new Array -1, 1, -1, 1, 1, -1
    which = rand 0, 5
    a = new poly rand 1, 3
    a.setrand 8
    a[a.rank] = Math.abs a[a.rank]
    a.xthru 1 / a.gcd! if which is 0
    u = randnz 4
    b = new poly 0
    a.diff b
    aString = '$$' + (p_linear u, 0).write fns[which].replace //z//g, a.write! + '+c$$'
    if (difs[which].charAt 0) is '-'
      difs[which] = difs[which].slice 1
      b.xthru -1
    qString = void
    b.xthru u
    if b.terms! > 1 and which then qString = '(' + b.write! + ')' else if b.rank is 0 and which then qString = ascoeff b.0 else qString = b.write!
    qString = 'Find $$\\int' + (difs[which].replace //z//g, a.write!).replace //y//g, qString + '\\,\\mathrm{d}x$$'
    qa = [qString, aString]
    return qa
  case 1
    fns = new Array '\\ln(z)', '\\csc(z)', '\\sec(z)', '\\sin(z)', '\\tan(z)', '\\cos(z)'
    difs = new Array '\\frac{y}{z}', '-y\\csc(z)\\cot(z)', 'y\\sec(z)\\tan(z)', 'y\\cos(z)', 'y\\sec^2(z)', '-y\\sin(z)'
    even = new Array -1, 1, -1, 1, 1, -1
    which = rand 0, 5
    a = new poly rand 1, 3
    a.setrand 8
    b = new poly 0
    a.diff b
    aString = '$$'
    if a.terms! > 1 then aString += '(' + a.write! + ')' + fns[which].replace //z//g, 'x' else aString += a.write! + fns[which].replace //z//g, 'x'
    aString += '+c$$'
    qString = 'Find $$\\int'
    if b.terms! > 1
      qString += '(' + b.write! + ')'
    else
      if b.0 is 1 then qString += '' else if b.0 is -1 then qString += '-' else qString += b.write!
    if (difs[which].charAt 0) is '-'
      difs[which] = difs[which].slice 1
      a.xthru -1
    if not (a[a.rank] > 0)
      qString += (fns[which].replace //z//g, 'x') + ' - '
      a.xthru -1
    if which is 0 and a.0 is 0
      i = 0
      while i < a.rank
        a[i] = a[i + 1]
        i++
      a.rank--
      qString += a.write!
    else
      if a.terms! > 1 and which
        qString += (difs[which].replace //y//g, '(' + a.write! + ')').replace //z//g, 'x'
      else
        if a.0 is 1 and which then qString += difs[which].replace //y//g, '' else qString += (difs[which].replace //y//g, a.write!).replace //z//g, 'x'
    qString += '\\,\\mathrm{d}x$$'
    qa = [qString, aString]
    return qa
  qa

makeDE = ->
  if rand!
    roots = distrand 2, 4
    p = p_quadratic 1, -roots.0 - roots.1, roots.0 * roots.1
    qString = 'Find the general solution of the following second-order ODE:$$' + ((p.write 'D').replace 'D^2', '\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}').replace 'D', '\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}' + if p.0 is 0 then '' else 'y' + '=0' + '$$'
    aString = '$$y=' + if roots.0 is 0 then 'A' else 'Ae^{' + ascoeff roots.0 + 'x}' + '+' + if roots.1 is 0 then 'B' else 'Be^{' + ascoeff roots.1 + 'x}' + '$$'
    qa = [qString, aString]
    qa
  else
    b = randnz 6
    qString = 'Find the general solution of the following first-order ODE:$$x\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}-y'
    if b > 0 then qString += (signedNumber -b) + '=0.$$' else qString += '=' + -b + '$$'
    aString = '$$y=Ax' + if b > 0 then '+' else '' + b + '$$'
    qa = [qString, aString]
    qa

makePowers = ->
  res = new frac
  q = ''
  i = 0
  while i < 5
    q += '\\times ' if i is 1 or i > 2
    switch rand 1, 4
    case 1
      a = randnz 4
      b = randnz 5
      p = new frac a, b
      q += if p.top is p.bot then 'x' else 'x^{' + p.write! + '}'
      a = -a if i > 1
      res.add a, b
    case 2
      a = randnz 4
      b = randnz 2, 5
      if a > 0 then a++ else a-- if not ((gcd a, b) is 1)
      q += '\\root ' + b + ' \\of' + if a is 1 then '{x}' else '{x^{' + a + '}}'
      if i > 1 then a = -a
      res.add a, b
    case 3
      u = distrand 2, 1, 3
      a = u.0
      b = u.1
      c = randnz 2, 6
      p = new frac a, b
      q += '\\left(x^{' + p.write! + '}\\right)^' + c
      a = -a if i > 1
      res.add a * c, b
    case 4
      q += 'x'
      res.add (if i > 1 then -1 else 1), 1
    if i is 1 then q += '}{'
    i++
  qString = 'Simplify $$\\frac{' + q + '}$$'
  aString = '$$' + if res.top is res.bot then 'x' else 'x^{' + res.write! + '}' + '$$'
  qa = [qString, aString]
  qa

makeCArithmetic = ->
  z = Complex.randnz 6, 6
  w = Complex.randnz 4, 6
  qString = 'Given \\(z=' + z.write! + '\\) and \\(w=' + w.write! + '\\), compute:'
  qString += '<ul class="exercise">'
  qString += '<li>\\(z+w\\)</li>'
  qString += '<li>\\(z\\times w\\)</li>'
  qString += '<li>\\(\\frac{z}{w}\\)</li>'
  qString += '<li>\\(\\frac{w}{z}\\)</li>'
  qString += '</ul>'
  aString = '<ul class="exercise">'
  aString += '<li>\\(' + (z.add w.Re, w.Im).write! + '\\)</li>'
  aString += '<li>\\(' + (z.times w.Re, w.Im).write! + '\\)</li>'
  aString += '<li>\\(' + (z.divide w.Re, w.Im).write! + '\\)</li>'
  aString += '<li>\\(' + (w.divide z.Re, z.Im).write! + '\\)</li>'
  aString += '</ul>'
  qa = [qString, aString]
  qa

makeCPolar = ->
  z = if rand! then Complex.randnz 6, 6 else Complex.randnz 6, 4
  qString = 'Convert \\(' + z.write! + '\\) to modulus-argument form.'
  ma = Complex.ctop z
  r = Math.round ma.0
  t = guessExact ma.1 / Math.PI
  aString = '$$' + if r is 1 then '' else r + 'e^{' + if t is 0 then '0' else if t is 1 then '\\pi i' else t + '\\pi i' + '}$$'
  qa = [qString, aString]
  qa

makeDETwoHard = ->
  p = new poly 2
  p.setrand 6
  p.2 = 1
  disc = (Math.pow p.1, 2) - 4 * p.0 * p.2
  roots = [0, 0]
  if disc > 0
    roots.0 = (-p.1 + Math.sqrt disc) / 2
    roots.1 = (-p.1 - Math.sqrt disc) / 2
  else
    if disc is 0
      roots.0 = roots.1 = -p.1 / 2
    else
      roots.0 = new complex -p.1 / 2, (Math.sqrt -disc) / 2
      roots.1 = new complex -p.1 / 2, (-Math.sqrt -disc) / 2
  qString = 'Find the general solution of the following second-order ODE:$$' + ((p.write 'D').replace 'D^2', '\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}').replace 'D', '\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}' + if p.0 is 0 then '' else 'y' + '=0' + '$$'
  qString = qString.replace //1y//g, 'y'
  aString = ''
  if disc > 0
    aString = '$$y=' + if (guessExact roots.0) is 0 then 'A' else 'Ae^{' + ascoeff guessExact roots.0 + 'x}' + '+' + if (guessExact roots.1) is 0 then 'B' else 'Be^{' + ascoeff guessExact roots.1 + 'x}' + '$$'
  else
    if disc is 0
      if roots.0 is 0
        aString = 'y=Ax+B'
      else
        aString = '$$y=(Ax+B)' + if guessExact roots.0 then 'e^{' + ascoeff guessExact roots.0 + 'x}' else '' + '$$'
    else
      aString = '$$y=A\\cos\\left(' + ascoeff guessExact roots.0.Im + 'x+\\varepsilon\\right)' + if guessExact roots.0.Re then 'e^{' + ascoeff guessExact roots.0.Re + 'x}' else '' + '$$'
  qa = [qString, aString]
  qa

makeMatrixQ = (dim, max) ->
  A = new fmatrix dim
  A.setrand max
  B = new fmatrix dim
  B.setrand max
  I = new fmatrix dim
  I.zero!
  i = 0
  while i < I.dim
    I[i][i].set 1, 1
    i++
  i = 0
  while B.det!.top is 0
    throw new Error 'makeMatrixQ: failed to make a non-singular matrix' if i >= B.dim
    B = B.add I
    i++
  qString = 'Let $$A=' + A.write! + ' \\qquad \\text{and} \\qquad B=' + B.write! + '$$.'
  qString += 'Compute: <ul class="exercise">'
  qString += '<li>\\(A+B\\)</li>'
  qString += '<li>\\(A \\times B\\)</li>'
  qString += '<li>\\(B^{-1}\\)</li>'
  qString += '</ul>'
  S = A.add B
  P = A.times B
  Y = B.inv!
  aString = '<ul class="exercise">'
  aString += '<li>\\(' + S.write! + '\\)</li>'
  aString += '<li>\\(' + P.write! + '\\)</li>'
  aString += '<li>\\(' + Y.write! + '\\)</li>'
  aString += '</ul>'
  qa = [qString, aString]
  qa

makeMatrix2 = -> makeMatrixQ 2, 6

makeMatrix3 = -> makeMatrixQ 3, 4

makeTaylor = ->
  f = [
    '\\sin(z)'
    '\\cos(z)'
    '\\arctan(z)'
    'e^{z}'
    '\\log_{e}(1+z)'
  ]
  t = [
    [
      new frac 0
      new frac 1
      new frac 0
      new frac -1, 6
    ]
    [
      new frac 1
      new frac 0
      new frac -1, 2
      new frac 0
    ]
    [
      new frac 0
      new frac 1
      new frac 0
      new frac -1, 3
    ]
    [
      new frac 1
      new frac 1
      new frac 1, 2
      new frac 1, 6
    ]
    [
      new frac 0
      new frac 1
      new frac -1, 2
      new frac 1, 3
    ]
  ]
  which = rand 0, 4
  n = randfrac 6
  n = new frac 1 if n.top is 0
  qString = 'Find the Taylor series of \\(' + f[which].replace //z//g, fcoeff n, 'x' + '\\) about \\(x=0\\) up to and including the term in \\(x^3\\)'
  p = new fpoly 3
  i = 0
  while i <= 3
    p[i] = new frac t[which][i].top * Math.pow n.top, i, t[which][i].bot * Math.pow n.bot, i
    i++
  aString = '$$' + p.rwrite! + '$$'
  qa = [qString, aString]
  qa

makePolarSketch = ->
  fnf = [
    Math.sin
    Math.tan
    Math.cos
    (x) -> x
  ]
  fnn = [
    '\\sin(z)'
    '\\tan(z)'
    '\\cos(z)'
    'z'
  ]
  which = rand 0, 3
  parms = 0
  data = void
  fn = 0
  a = rand 0, 3
  b = rand 1, if which is 3 then 1 else 5
  qString = 'Sketch the curve given in polar co-ordinates by \\(r=' + if a then a + '+' else '' + fnn[which].replace //z//g, (ascoeff b) + '\\theta' + '\\) (where \\(\\theta\\) runs from \\(-\\pi\\) to \\(\\pi\\)).'
  makePolarSketch.fn = drawIt = (parms) ->
    f = parms.0
    d1 = []
    i = -1
    while i <= 1
      r = parms.1 + f i * Math.PI * parms.2
      x = r * Math.cos i * Math.PI
      x = null if (Math.abs x) > 6
      y = r * Math.sin i * Math.PI
      if (Math.abs y) > 6 then y = null
      if x and y then d1.push [x, y] else d1.push [null, null]
      i += 0.005
    [d1]
  aString = '%GRAPH%' + JSON.stringify [
    fnf[which]
    a
    b
  ]
  qa = [qString, aString]
  qa

makeFurtherVector = ->
  a = new vector 3
  a.setrand 5
  b = new vector 3
  b.setrand 5
  c = new vector 3
  c.setrand 5
  qString = 'Let \\(\\mathbf{a}=' + a.write! + '\\,\\), \\(\\;\\mathbf{b}=' + b.write! + '\\,\\) and \\(\\mathbf{c}=' + c.write! + '\\). '
  qString += 'Calculate: <ul class="exercise">'
  qString += '<li>the vector product, \\(\\mathbf{a}\\wedge \\mathbf{b}\\),</li>'
  qString += '<li>the scalar triple product, \\([\\mathbf{a}, \\mathbf{b}, \\mathbf{c}]\\).</li>'
  qString += '</ul>'
  axb = a.cross b
  abc = axb.dot c
  aString = '<ul class="exercise">'
  aString += '<li>\\(' + axb.write! + '\\)</li>'
  aString += '<li>\\(' + abc + '\\)</li>'
  aString += '</ul>'
  qa = [qString, aString]
  qa

makeNewtonRaphson = ->
  fns = [
    '\\ln(z)'
    'e^{z}'
    '\\csc(z)'
    '\\sec(z)'
    '\\sin(z)'
    '\\tan(z)'
    '\\cos(z)'
  ]
  difs = [
    '\\frac{1}{z}'
    'e^{z}'
    '-\\csc(z)\\cot(z)'
    '\\sec(z)\\tan(z)'
    '\\cos(z)'
    '\\sec^2(z)'
    '-\\sin(z)'
  ]
  fnf = [
    Math.log
    Math.exp
    (x) -> 1 / Math.sin x
    (x) -> 1 / Math.cos x
    Math.sin
    Math.tan
    Math.cos
  ]
  diff = [
    (x) -> 1 / x
    Math.exp
    (x) -> (Math.cos x) / Math.pow (Math.sin x), 2
    (x) -> (Math.sin x) / Math.pow (Math.cos x), 2
    Math.cos
    (x) -> 1 / Math.pow (Math.cos x), 2
    (x) -> -Math.sin x
  ]
  which = rand 0, 6
  p = new poly 2
  p.setrand 6
  p.2 = 1
  np = new poly 2
  i = void
  i = 0
  while i <= 2
    np[i] = -p[i]
    i++
  q = new poly 1
  p.diff q
  nq = new poly 1
  np.diff nq
  n = rand 4, 6
  x = new Array n + 1
  x.0 = rand (if which then 0 else 2), 4
  qString = 'Use the Newton-Raphson method to find the first \\(' + n + '\\) iterates in solving \\(' + p.write! + ' = ' + fns[which].replace //z//g, 'x' + '\\) with \\(x_0 = ' + x.0 + '\\).'
  aString = 'Iteration: \\begin{align*} x_{n+1}&=x_{n}-\\frac{' + fns[which].replace //z//g, 'x_n' + np.write! + '}{' + difs[which].replace //z//g, 'x_n' + nq.write! + '} \\\\[10pt]'
  i = 0
  while i < n
    eff = (fnf[which] x[i]) - p.compute x[i]
    effdash = (diff[which] x[i]) - q.compute x[i]
    x[i + 1] = x[i] - eff / effdash
    x[i + 1] = 0 if (Math.abs x[i + 1]) < 1e-7
    aString += 'x_{' + i + 1 + '} &= ' + x[i + 1] + '\\\\'
    i++
  aString += '\\end{align*}'
  if isNaN x[n] then return makeNewtonRaphson!
  qa = [qString, aString]
  qa

makeFurtherIneq = ->
  A = distrandnz 2, 6
  B = distrandnz 2, 6
  C = distrand 2, 6
  qString = 'Find the range of values of \\(x\\) for which$$'
  qString += '\\frac{' + A.0 + '}{' + (p_linear B.0, C.0).write! + '} < \\frac{' + A.1 + '}{' + (p_linear B.1, C.1).write! + '}$$'
  aString = void
  aedb = A.0 * B.1 - A.1 * B.0
  root = new frac A.1 * C.0 - A.0 * C.1, aedb
  poles = [(new frac -C.0, B.0), new frac -C.1, B.1]
  i = void
  j = void
  l = void
  m = void
  if aedb is 0
    if poles.0.equals poles.1
      aString = 'The two fractions are equivalent, so the inequality never holds.'
    else
      m = new Array 2
      i = 0
      while i < 2
        m[i] = poles[i].top / poles[i].bot
        i++
      l = ranking m
      if m.0 > m.1 then aString = '$$x < ' + poles[l.0].write! + ' \\mbox{ or }' + poles[l.1].write! + ' < x$$' else aString = '$$' + poles[l.0].write! + ' < x < ' + poles[l.1].write! + '$$'
  else
    if poles.0.equals poles.1
      i = A.0 / B.0
      j = A.1 / B.1
      if i > j then aString = '$$x < ' + poles.0.write! + '$$' else aString = '$$' + poles.0.write! + ' < x$$'
    else
      n = [
        root
        poles.0
        poles.1
      ]
      m = new Array 3
      i = 0
      while i < 3
        m[i] = n[i].top / n[i].bot
        i++
      l = ranking m
      i = A.0 / B.0
      j = A.1 / B.1
      if i > j
        aString = '$$x < ' + n[l.0].write! + '\\mbox{ or }' + n[l.1].write! + ' < x < ' + n[l.2].write! + '$$'
      else
        aString = '$$' + n[l.0].write! + ' < x < ' + n[l.1].write! + '\\mbox{ or }' + n[l.2].write! + ' < x$$'
  qa = [qString, aString]
  qa

makeSubstInt = ->
  p = new poly rand 1, 2
  p.setrand 2
  fns = [
    '\\ln(Az)'
    'e^{Az}'
    p.rwrite 'z'
  ]
  fsq = [
    '(\\ln(Az))^2'
    'e^{2Az}'
    (polyexpand p, p).write 'z'
  ]
  q = new poly p.rank - 1
  p.diff q
  difs = [
    '\\frac{A}{z}'
    'Ae^{Az}'
    q.write 'z'
  ]
  t = [
    '\\arcsin(f)'
    '\\arctan(f)'
    '{\\rm arsinh}(f)'
    '{\\rm artanh}(f)'
  ]
  dt = [
    '\\frac{y}{\\sqrt{1-F}}'
    '\\frac{y}{1+F}'
    '\\frac{y}{\\sqrt{1+F}}'
    '\\frac{y}{1-F}'
  ]
  pm = [
    -1
    1
    1
    -1
  ]
  ldt = [
    '\\frac{A}{y\\sqrt{1-F}}'
    '\\frac{A}{y(1+F)}'
    '\\frac{A}{y\\sqrt{1+F}}'
    '\\frac{A}{y(1-F)}'
  ]
  pdt = [
    '\\frac{y}{\\sqrt{F}}'
    '\\frac{y}{F}'
    '\\frac{y}{\\sqrt{F}}'
    '\\frac{y}{F}'
  ]
  which = rand 0, 2
  what = rand 0, 3
  which = rand 0, 1 if what is 0 and which is 2
  a = randnz 4
  qString = 'Find $$\\int'
  if which is 0
    qString += (((ldt[what].replace //y//g, 'x').replace //F//g, fsq[which].replace //A//g, ascoeff a).replace //z//g, 'x').replace //A//g, a
  else
    if which is 2
      r = polyexpand p, p
      r.xthru pm[what]
      r.0++
      qString += ((pdt[what].replace //y//g, difs[which]).replace //F//g, r.rwrite 'z').replace //z//g, 'x'
    else
      qString += ((((dt[what].replace //y//g, difs[which]).replace //F//g, fsq[which]).replace //z//g, 'x').replace '2A', ascoeff 2 * a).replace //A//g, ascoeff a
  qString += '\\,\\mathrm{d}x$$'
  aString = '$$' + ((t[what].replace //f//g, fns[which]).replace //z//g, 'x').replace //A//g, ascoeff a + '+c$$'
  qa = [qString, aString]
  qa

makeRevolution = ->
  makeSolidRevolution = ->
    fns = [
      '\\sec(z)'
      '\\csc(z)'
      '\\sqrt{z}'
    ]
    iss = [
      '\\tan(z)'
      '-\\cot(z)'
      0
    ]
    isf = [
      Math.tan
      (x) -> -1 / Math.tan x
      (x) -> (Math.pow x, 2) / 2
    ]
    which = rand 0, 2
    x0 = 0
    x0++ if which is 1
    x = rand x0 + 1, x0 + if which is 2 then 4 else 1
    qString = 'Find the volume of the solid formed when the area under'
    qString += '$$y = ' + fns[which].replace //z//g, 'x' + '$$'
    qString += 'from \\(x = ' + x0 + '\\) to \\(x = ' + x + '\\) is rotated through \\(2\\pi\\) around the x-axis.'
    ans = void
    if which is 2
      ans = guessExact (isf[which] x) - isf[which] x0
    else
      ans = '\\left(' + iss[which].replace //z//g, x + if (isf[which] x0) is 0 then '' else '-' + iss[which].replace //z//g, x0 + '\\right)\\,'
      ans = ans.replace //--//g, '+'
    aString = '$$' + ans + '\\pi$$'
    qa = [qString, aString]
    qa
  makeSurfaceRevolution = ->
    a = new poly rand 1, 3
    a.setrand 6
    i = 0
    while i <= a.rank
      a[i] = Math.abs a[i]
      i++
    b = new fpoly 3
    b.setpoly a
    c = new fpoly 4
    b.integ c
    x = rand 1, 4
    qString = 'Find the area of the surface formed when the curve'
    qString += '$$y = ' + a.write 'x' + '$$'
    qString += 'from \\(x = 0\\mbox{ to }x = ' + x + '\\) is rotated through \\(2\\pi\\) around the x-axis.'
    hi = c.compute x
    ans = new frac hi.top, hi.bot
    ans.prod 2
    aString = '$$' + fcoeff ans, '\\pi' + '$$'
    qa = [qString, aString]
    qa
  qa = void
  if rand! then qa = makeSolidRevolution! else qa = makeSurfaceRevolution!
  qa

makeMatXforms = ->
  a = rand 0, 2
  xfms = new Array 5
  i = 0
  while i < 5
    xfms[i] = new fmatrix 2
    i++
  cosines = [
    new frac 0
    new frac -1
    new frac 0
  ]
  sines = [
    new frac 1
    new frac 0
    new frac -1
  ]
  acosines = [
    new frac 0
    new frac 1
    new frac 0
  ]
  asines = [
    new frac -1
    new frac 0
    new frac 1
  ]
  xfms.0.set cosines[a], asines[a], sines[a], cosines[a]
  xfms.1.set cosines[a], sines[a], sines[a], acosines[a]
  xfms.2.set 1, a + 1, 0, 1
  xfms.3.set 1, 0, a + 1, 1
  xfms.4.set a + 2, 0, 0, a + 2
  f = new frac a + 1, 2
  xft = [
    'a rotation through \\(' + fcoeff f, '\\pi' + '\\) anticlockwise about O'
    'a reflection in the line \\(' + [
      'y=x'
      'x=0'
      'y=-x'
    ][a] + '\\)'
    'a shear of element \\(' + a + 1 + ', x\\) axis invariant'
    'a shear of element \\(' + a + 1 + ', y\\) axis invariant'
    'an enlargement of scale factor \\(' + a + 1 + '\\)'
  ]
  which = distrand 2, 0, 4
  qString = 'Compute the matrix representing, in 2D, ' + xft[which.0] + ' followed by ' + xft[which.1] + '.'
  ans = xfms[which.1].times xfms[which.0]
  aString = '$$' + ans.write! + '$$'
  qa = [qString, aString]
  qa

makeDiscreteDistn = ->
  massfn = [
    massBin
    massPo
    massGeo
  ]
  pd = rand 2, 6
  pn = rand 1, pd - 1
  f = new frac pn, pd
  p = pn / pd
  parms = [
    [(rand 5, 12), p]
    [rand 1, 5]
    [p]
  ]
  dists = [
    '{\\rm B}\\left(' + parms.0.0 + ', ' + f.write! + '\\right)'
    '{\\rm Po}(' + parms.1.0 + ')'
    '{\\rm Geo}\\left(' + f.write! + '\\right)'
  ]
  x = rand 1, 4
  which = rand 0, 2
  leq = rand!
  qString = 'The random variable \\(X\\) is distributed as$$' + dists[which] + '.$$  Find \\(\\mathbb{P}(X' + if leq then '\\le' else '=' + x + ')\\)'
  ans = void
  if leq
    ans = 0
    i = 0
    while i <= x
      ans += massfn[which] i, parms[which].0, parms[which].1
      i++
  else
    ans = massfn[which] x, parms[which].0, parms[which].1
  aString = '$$' + ans.toFixed 6 + '$$'
  qa = [qString, aString]
  qa

makeContinDistn = ->
  tableN.populate!
  mu = rand 0, 4
  sigma = rand 1, 4
  x = (Math.floor Math.random! * 3 * sigma * 10) / 10
  x *= -1 if rand!
  x += mu
  qString = 'The random variable \\(X\\) is normally distributed with mean \\(' + mu + '\\) and variance \\(' + sigma * sigma + '\\).'
  qString += '<br />Find \\(\\mathbb{P}(X\\le' + x + ')\\)'
  z = (x - mu) / sigma
  index = Math.floor 1000 * Math.abs z
  if index < 0 or index >= tableN.values.length then throw new Error 'makeContinDistn: index ' + index + ' out of range\n' + 'x: ' + x
  p = tableN.values[index]
  if z < 0 then p = 1 - p
  aString = '$$' + p.toFixed 3 + '$$'
  qa = [qString, aString]
  qa

makeHypTest = ->
  mu = void
  sigma = void
  n = void
  which = void
  sl = void
  Sx = void
  xbar = void
  p = void
  critdev = void
  acc = void
  qString = void
  aString = void
  qa = void
  if rand!
    mu = new Array 2
    sigma = new Array 2
    which = 0
    n = rand 8, 12
    sl = pickrand 1, 5, 10
    if rand!
      mu.1 = mu.0 = rand -1, 5
      sigma.1 = sigma.0 = rand 1, 4
      which = rand 0, 2
    else
      mu = distrand 2, -1, 5
      sigma.0 = rand 1, 4
      sigma.1 = rand 1, 4
      which = if rand! then if mu.0 < mu.1 then 2 else 1 else 0
    Sx = genN mu.1 * n, sigma.1 * Math.sqrt n
    qString = 'In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = ' + mu.0 + '\\mbox{, }\\sigma^2 = ' + sigma.0 * sigma.0 + '\\). '
    qString += 'The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu' + [
      '\\ne'
      '<'
      '>'
    ][which] + mu.0 + '\\). '
    qString += 'The significance level is \\(' + sl + '\\%\\). '
    qString += 'A sample of size \\(' + n + '\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = ' + Sx.toFixed 3 + '\\).<br />'
    qString += '<br />Compute: <ul class="exercise">'
    qString += '<li>\\(\\overline{x}\\)</li>'
    qString += '<li> Is \\({\\rm H}_0\\) accepted?}</li>'
    qString += '</ul>'
    xbar = Sx / n
    aString = '<ul class="exercise">'
    aString += '<li>\\(\\overline{x} = ' + xbar.toFixed 3 + '\\)</li>'
    p = 0
    if which
      switch sl
      case 1
        p = 4
      case 5
        p = 2
      case 10
        p = 1
    else
      switch sl
      case 1
        p = 5
      case 5
        p = 3
      case 10
        p = 2
    critdev = sigma.0 * tableT.values[tableT.values.length - 1][p] / Math.sqrt n
    if which
      aString += '<li>The critical region is $$\\overline{x}' + if which is 1 then '<' + (mu.0 - critdev).toFixed 3 else '>' + (mu.0 + critdev).toFixed 3 + '$$<br />'
    else
      aString += '<li>The critical values are $$' + (mu.0 - critdev).toFixed 3 + '\\) and \\(' + (mu.0 + critdev).toFixed 3 + '$$<br />'
    acc = false
    switch which
    case 0
      acc = xbar >= mu.0 - critdev and xbar <= mu.0 + critdev
    case 1
      acc = xbar >= mu.0 - critdev
    case 2
      acc = xbar <= mu.0 + critdev
    aString += if acc then '\\(\\rm H}_0\\) is accepted.</li>' else '\\(\\rm H}_0\\) is rejected.</li>'
    aString += '</ul>'
    qa = [qString, aString]
    qa
  else
    mu = new Array 2
    which = 0
    n = rand 10, 25
    sl = pickrand 1, 5, 10
    if rand!
      mu.1 = mu.0 = rand -1, 5
      sigma = rand 1, 4
      which = rand 0, 2
    else
      mu = distrand 2, -1, 5
      sigma = rand 1, 4
      which = if rand! then if mu.0 < mu.1 then 2 else 1 else 0
    Sx = 0
    Sxx = 0
    i = 0
    while i < n
      xi = genN mu.1, sigma
      Sx += xi
      Sxx += xi * xi
      i++
    qString = 'In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = ' + mu.0 + '\\). '
    qString += 'The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu' + [
      '\\ne'
      '<'
      '>'
    ][which] + mu.0 + '\\). '
    qString += 'The significance level is \\(' + sl + '\\%\\). '
    qString += 'A sample of size \\(' + n + '\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = ' + Sx.toFixed 3 + '\\). '
    qString += 'The sum of squares, \\(\\sum{x^2} = ' + Sxx.toFixed 3 + '\\). '
    qString += 'Compute: <ul class="exercise">'
    qString += '<li>\\(\\overline{x}\\)</li>'
    qString += '<li>Compute an estimate, \\(S^2\\), of the variance of \\(X\\)</li>'
    qString += '<li>Is \\({\\rm H}_0\\) accepted?</li>'
    qString += '</ul>'
    xbar = Sx / n
    aString = '<ul class="exercise">'
    aString = '<li>\\(\\overline{x} = ' + xbar.toFixed 3 + '\\)</li>'
    SS = (Sxx - Sx * Sx / n) / (n - 1)
    aString += '<li>\\(S^2 = ' + SS.toFixed 3 + '\\). '
    aString += 'Under \\({\\rm H}_0\\), \\({\\frac{\\overline{X}' + if mu.0 then (if mu.0 > 0 then '-' else '+') + Math.abs mu.0 else '' + '}{' + (Math.sqrt SS / n).toFixed 3 + '}}\\sim t_{' + n - 1 + '}\\)</li>'
    p = 0
    if which
      switch sl
      case 1
        p = 4
      case 5
        p = 2
      case 10
        p = 1
    else
      switch sl
      case 1
        p = 5
      case 5
        p = 3
      case 10
        p = 2
    critdev = (Math.sqrt SS) * tableT.values[n - 2][p] / Math.sqrt n
    if which
      aString += '<li>The critical region is \\(\\overline{x}' + if which is 1 then '<' + (mu.0 - critdev).toFixed 3 else '>' + (mu.0 + critdev).toFixed 3 + '\\); </br />'
    else
      aString += '<li>The critical values are \\(' + (mu.0 - critdev).toFixed 3 + '\\) and \\(' + (mu.0 + critdev).toFixed 3 + '\\); <br />'
    acc = false
    switch which
    case 0
      acc = xbar >= mu.0 - critdev and xbar <= mu.0 + critdev
    case 1
      acc = xbar >= mu.0 - critdev
    case 2
      acc = xbar <= mu.0 + critdev
    aString += if acc then '\\({\\rm H}_0\\) is accepted.</li>' else '\\({\\rm H}_0\\) is rejected.</li>'
    aString += '</ul>'
    qa = [qString, aString]
    qa

makeConfidInt = ->
  mu = rand 4
  sigma = rand 1, 4
  n = 2 * rand 6, 10
  sl = pickrand 99, 95, 90
  Sx = 0
  Sxx = 0
  i = 0
  while i < n
    xi = genN mu, sigma
    Sx += xi
    Sxx += xi * xi
    i++
  qString = 'The random variable \\(X\\) has a normal distribution with unknown parameters. '
  qString += 'A sample of size \\(' + n + '\\) is taken for which $$\\sum{x}=' + Sx.toFixed 3 + '$$$$\\mbox{and}\\sum{x^2}=' + Sxx.toFixed 3 + '.$$'
  qString += 'Compute, to 3 DP., a \\(' + sl + '\\)% confidence interval for the mean of \\(X\\).<br />'
  xbar = Sx / n
  SS = (Sxx - Sx * Sx / n) / (n - 1)
  p = void
  switch sl
  case 99
    p = 5
  case 95
    p = 3
  case 90
    p = 2
  critdev = (Math.sqrt SS / n) * tableT.values[n - 2][p]
  aString = '$$[' + (xbar - critdev).toFixed 3 + ', ' + (xbar + critdev).toFixed 3 + ']$$'
  qa = [qString, aString]
  qa

makeChiSquare = ->
  tableN.populate!
  parms = [
    [(rand 10, 18) * 2, (rand 20, 80) / 100]
    [rand 4, 12]
    [(rand 10, 30) / 100]
    [(rand 4, 10), rand 2, 4]
  ]
  distns = [
    'binomial'
    'Poisson'
    'geometric'
    'normal'
  ]
  parmnames = [
    ['n', 'p']
    ['\\lambda']
    ['p']
    ['\\mu', '\\sigma']
  ]
  nparms = [
    2
    1
    1
    2
  ]
  massfn = [
    massBin
    massPo
    massGeo
    massN
  ]
  genfn = [
    genBin
    genPo
    genGeo
    genN
  ]
  which = rand 0, 3
  n = 5 * rand 10, 15
  sl = pickrand 90, 95, 99
  qString = 'The random variable \\(X\\) is modelled by a <i>' + distns[which] + '</i> distribution. '
  qString += 'A sample of size \\(' + n + '\\) is drawn from \\(X\\) with the following grouped frequency data. '
  sample = []
  min = 1000
  max = 0
  i = void
  i = 0
  while i < n
    sample[i] = genfn[which] parms[which].0, parms[which].1
    min = Math.min min, sample[i]
    max = Math.max max, sample[i]
    i++
  min = Math.floor min
  max = Math.ceil max
  freq = []
  i = 0
  while i < Math.ceil (max + 1 - min) / 2
    freq[i] = 0
    i++
  i = 0
  while i < n
    y = Math.floor (sample[i] - min) / 2
    freq[y]++
    i++
  qString += '<div style="font-size: 80%;">$$\\begin{array}{c|r}x&\\mbox{Frequency}\\\\'
  x = void
  Sx = 0
  Sxx = 0
  i = 0
  while i < Math.ceil (max + 1 - min) / 2
    x = min + i * 2
    Sx += (x + 1) * freq[i]
    Sxx += (x + 1) * (x + 1) * freq[i]
    if i is 0
      qString += 'x < ' + x + 2
    else
      if i is Math.ceil (max - 1 - min) / 2 then qString += x + '\\le x' else qString += x + '\\le x <' + x + 2
    qString += '&' + freq[i] + '\\\\'
    i++
  qString += '\\end{array}$$</div>'
  qString += '<ul class="exercise">'
  qString += '<li>Estimate the parameters of the distribution.</li>'
  qString += '<li>Use a \\(\\chi^2\\) test, with a significance level of \\(' + sl + '\\)%, to test this hypothesis.</li>'
  qString += '</ul>'
  p = void
  switch sl
  case 90
    p = 3
  case 95
    p = 4
  case 99
    p = 6
  xbar = Sx / n
  SS = (Sxx - Sx * Sx / n) / (n - 1)
  hypparms = [0, 0]
  aString = '<ol class="exercise">'
  switch which
  case 0
    hypparms.1 = 1 - SS / xbar
    hypparms.0 = Math.round xbar / hypparms.1
  case 1
    hypparms.0 = xbar
  case 2
    hypparms.0 = 1 / xbar
  case 3
    hypparms.0 = xbar
    hypparms.1 = Math.sqrt SS
  if which is 0
    aString += '<li>$$' + parmnames[which].0 + '=' + hypparms.0.toString! + ', ' + parmnames[which].1 + '=' + hypparms.1.toFixed 3 + '.$$</li>'
    if hypparms.0 < 1
      aString += '</ol>'
      aString += '<p>The binomial model cannot fit these data</p>'
      return [qString, aString]
  else
    aString += '<li>$$' + parmnames[which].0 + '=' + hypparms.0.toFixed 3
    aString += ', ' + parmnames[which].1 + '=' + hypparms.1.toFixed 3 if nparms[which] is 2
    aString += '.$$</li>'
  aString += '<li></li></ol>'
  nrows = Math.ceil (max + 1 - min) / 2
  row = []
  i = 0
  while i < nrows
    x = min + i * 2
    row[i] = [
      x
      x + 2
      freq[i]
      0
      0
    ]
    if which is 3
      zh = (x + 2 - hypparms.0) / hypparms.1
      zl = (x - hypparms.0) / hypparms.1
      ph = if (Math.abs zh) < 3
        if zh >= 0 then tableN.values[Math.floor zh * 1000] else 1 - tableN.values[Math.floor -zh * 1000]
      else
        if zh > 0 then 1 else 0
      pl = if (Math.abs zl) < 3
        if zl >= 0 then tableN.values[Math.floor zl * 1000] else 1 - tableN.values[Math.floor -zl * 1000]
      else
        if zl > 0 then 1 else 0
      pl = 0 if i is 0
      if i is nrows - 1 then ph = 1
      row[i].3 = (ph - pl) * n
    else
      j = if i is 0 then 0 else x
      while j < if i is nrows - 1 then x + 100 else x + 2
        row[i].3 += (massfn[which] j, hypparms.0, hypparms.1) * n
        j++
    i++
  row2 = []
  chisq = 0
  currow = [
    0
    0
    0
    0
    0
  ]
  i = 0
  while i < nrows
    currow.1 = row[i].1
    currow.2 += row[i].2
    currow.3 += row[i].3
    if currow.3 >= 5
      currow.4 = (Math.pow currow.2 - currow.3, 2) / currow.3
      row2.push currow
      chisq += currow.4
      currow = [
        currow.1
        currow.1
        0
        0
        0
      ]
    i++
  crow = if row2.length
    row2.pop!
  else
    [
      0
      0
      0
      0
      0
    ]
  crow.1 = currow.1
  crow.2 += currow.2
  crow.3 += currow.3
  chisq -= crow.4
  crow.4 = (Math.pow crow.2 - crow.3, 2) / crow.3
  row2.push crow
  chisq += crow.4
  aString += '<div style="font-size: 80%;">$$\\begin{array}{c||r|r|r}'
  aString += 'x&O_i&E_i&\\frac{(O_i-E_i)^2}{E_i}\\\\'
  i = 0
  while i < row2.length
    if i is 0
      aString += 'x < ' + row2[i].1
    else
      if i is row2.length - 1 then aString += row2[i].0 + '\\le x' else aString += row2[i].0 + '\\le x <' + row2[i].1
    aString += '&' + row2[i].2 + '&' + row2[i].3.toFixed 3 + '&' + row2[i].4.toFixed 3 + '\\\\'
    i++
  aString += '\\end{array}$$</div>'
  aString += '$$\\chi^2 = ' + chisq.toFixed 3 + '$$'
  nu = row2.length - 1 - nparms[which]
  aString += '$$\\nu = ' + nu + '$$'
  if nu < 1
    throw new Error 'makeChiSquare: nu < 1!' + '\n\twhich:' + which + '\n\trow2.length:' + row2.length
  critval = tableChi.values[nu - 1][p]
  aString += 'Critical region: \\(\\chi^2 >' + critval + '\\)<br />'
  if chisq > critval then aString += 'The hypothesis is rejected.' else aString += 'The hypothesis is accepted.'
  qa = [qString, aString]
  qa

makeProductMoment = ->
  n = rand 6, 12
  mu = [(rand 4), rand 4]
  sigma = [(rand 1, 6), rand 1, 6]
  x = []
  i = void
  i = 0
  while i < n
    x[i] = []
    x[i].0 = genN mu.0, sigma.0
    x[i].1 = genN mu.1, sigma.1
    i++
  Ex = 0
  Exx = 0
  Exy = 0
  Eyy = 0
  Ey = 0
  qString = 'For the following data,'
  qString += '<ul class="exercise">'
  qString += '<li>compute the product moment correlation coefficient, \\({\\bf r}\\)</li>'
  qString += '<li>find the regression line of \\(y\\) on \\(x\\)$$\\begin{array}{c|c}x&y\\\\'
  i = 0
  while i < n
    qString += (x[i].0.toFixed 3) + '&' + x[i].1.toFixed 3 + '\\\\'
    Ex += x[i].0
    Exx += x[i].0 * x[i].0
    Exy += x[i].0 * x[i].1
    Eyy += x[i].1 * x[i].1
    Ey += x[i].1
    i++
  qString += '\\end{array}$$</li></ul>'
  xbar = Ex / n
  ybar = Ey / n
  Sxx = Exx - Ex * xbar
  Syy = Eyy - Ey * ybar
  Sxy = Exy - Ex * Ey / n
  r = Sxy / Math.sqrt Sxx * Syy
  b = Sxy / Sxx
  a = ybar - b * xbar
  aString = '<ul class="exercise">'
  aString += '<li>\\({\\bf r}=' + r.toFixed 3 + '\\)</li><li>\\(y=' + b.toFixed 3 + 'x' + if a > 0 then '+' else '' + a.toFixed 3 + '\\).'
  qa = [qString, aString]
  qa

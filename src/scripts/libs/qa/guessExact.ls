#
# guessExact.ls - guesses the exact representation of a floating-point variable.
#

# TODO:
# make it compute a load of guesses, and weight each one's closeness by likelihood, and pick the best.
#
# ADVISE-AVOID:
# At the moment it occasionally fails to guess the right thing at all, and sometimes guesses something else first
#
# Two versions, one is commented out.

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

guessExact = (x) ->
  n = proxInt(x)
  if n[0] then return n[1]

  # compensating for the lack of ternary operator
  sgn1 = (x) -> if x < 0 then return "-" else return ""
  sgn2 = (x) -> if x < 0 then return "-" else return "+"

  for s from 1 to 17

    for i from 2 to (3 + 2 * s)
      n = proxInt(x * i)
      if n[0]
        top = n[1]
        bot = i
        c = gcd(top, bot)
        top /= c
        bot /= c

        return sgn1(x) + "\\frac{" + Math.abs(top) + "}{" + bot + "}"

    n = proxInt(x^2)

    if n[0] and n[1] < s * 10
      v = new sqroot(n[1])
      return sgn1(x) + v.write()

    for i from 2 to 1 + s
      n = proxInt((x * i)^2)
      if n[0] and n[1] < s * 10
        v = new sqroot(n[1])
        return sgn1(x) + "\\frac{" + v.write() + "}{" + i + "}"

    for j from 1 to 3 * s

      a = (x - j)
      n = proxInt(a ^ 2)
      if n[0] and n[1] < s * 10
        v = new sqroot(n[1])
        return "\\left(" + j + sgn2(a) + v.write() + "\\right)"

      a = x + j
      n = proxInt(a ^ 2)
      if n[0] and n[1] < s * 10
        v = new sqroot(n[1])
        return "\\left(-" + j + sgn2(a) + v.write() + "\\right)"

    for k from 2 to (2 + (2 * s))
      for j from 1 to (1 + 2 * s)

        a = x - (j / k)
        n = proxInt(a ^ 2)
        if n[0] and n[1] < s * 10
          v = new sqroot(n[1])
          return "\\left(\\frac{" + j + "}{" + k + "}" + sgn2(a) + v.write() + "\\right)"

        a = x + (j / k)
        n = proxInt(a ^ 2)
        if n[0] and n[1] < s * 10
          v = new sqroot(n[1])
          return "\\left(-\\frac{" + j + "}{" + k + sgn2(a) + v.write() + "\\right)"

    for i from 2 to (s - 1)
      for j from 1 to (2 + (2 * s))

        a = (x - j) * i
        n = proxInt(a ^ 2)
        if n[0] and n[1] < s * 10
          v = new sqroot(n[1])
          return "\\left(" + j + sgn2(x - j) + "\\frac{" + v.write() + "}{" + i + "}\\right)"

        a = (x + j) * i
        n = proxInt(a ^ 2)
        if n[0] and n[1] < s * 10
          v = new sqroot(n[1])
          return "\\left(-" + j + sgn2(x + j) + "\\frac{" + v.write() + "}{" + i + "}\\right)"

    for i from 2 to (s - 1)
      for k from 2 to (1 + (2 * s))
        for j from 1 to (2 * s)

          a = (x - (j / k))
          n = proxInt((a * i) ^ 2)
          if (n[0] and n[1] < s * 10) and Math.sqrt(n[1]) is not Math.floor(Math.sqrt(n[1]))
            v = new sqroot(n[1])
            return "\\left(\\frac{" + j + "}{" + k + "}" + sgn2(a) + "\\frac{" + v.write() + "}{" + i + "}\\right)"

          a = x + (j / k)
          n = proxInt((a * i) ^ 2)
          if (n[0] and n[1] < s * 10) and Math.sqrt(n[1]) is not Math.floor(Math.sqrt(n[1]))
            v = new sqroot(n[1])
            return "\\left(-\\frac{" + j + "}{" + k + "}" + sgn2(a) + "\\frac{" + v.write() + "}{" + i + "}\\right)"

  return x

proxInt = (x) ->
  n = Math.round(x)

  if Math.abs(n - x) < (Math.abs(x) + 0.5) * 1e-8
    return [true, n]
  else
    return [false]

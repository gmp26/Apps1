#
# polys.ls - polynomial objects
#

# Write a number as a coefficient (1 disappears, -1 becomes -)
ascoeff = (a) ->
  if a is 1 then ""
  else if a is -1 then "-"
  else a



# Write a number as a |coefficient| (+-1 disappears)
abscoeff = (a) ->
  a = Math.abs(a)
  if a is 1 then "" else a



# Express a list of polynomial factors (x+a[0])(x+a[1])...
express = (a) ->
  r = ""
  n = a.length
  p = ranking(a)
  t = 0
  s = new poly(1)
  s[1] = 1

  for i from 0 to n - 1
    if i and a[p[i]] is q
      t++
    else
      if t
        r += "^" + (t + 1)
      t = 0
      s[0] = a[p[i]]
      r += "(" + s.write() + ")"
      q = a[p[i]]

  if t
    r += "^" + (t + 1)
  return r



polyexpand = (a,b) ->
  p = new poly(a.rank + b.rank)
  p.setrand() # set all entries to 0

  for i from 0 to a.rank
    for j from 0 to b.rank
      p[i + j] += a[i] * b[j]

  return p



# ax^2 + bx + c
p_quadratic = (a,b,c) ->
  p = new poly(2)
  p.set(c,b,a)
  return p

# ax + b
p_linear = (a,b) ->
  p = new poly(1)
  p.set(b,a)
  return p

# a
p_const = (a) ->
  p.set(a)
  return p



# polynomial (over Z) object:
# * can be set manually or randomly
# * nonzero terms counted
# * computed at an x value
# * multiplied by a constant
# * differentiated
# * write it in LaTeX
# * used in several other functions
# REMEMBER: it's stored backwards (x^0 term first)
class poly
  (rank) ->
    @rank = rank

  terms: ->
    n = 0
    for i from 0 to @rank
      if @[i] then n++
    return n

  set: ->
    @rank = @set.arguments.length - 1
    for i from 0 to @rank
      @[i] = @set.arguments[i]

  setrand: (maxentry) ->
    for i from 0 to @rank
      @[i] = Math.round(-maxentry + 2 * maxentry * Math.random())
      if @[@rank] is 0 then @[@rank] = maxentry

  compute: (x) ->
    y = 0
    for i from 0 to @rank
      y += @[i] * x^i
    return y

  gcd: ->
    a = @[@rank]
    for i from 0 to @rank - 1
      a = gcd(a, @[i])
    return a

  xthru: (x) ->
    for i from 0 to @rank
      @[i] = @[i] * x

  addp: (x) ->
    for i from 0 to @rank
      @[i] += x[i]

  diff: (d) ->
    d.rank = rank - 1
    for i from 0 to @rank - 1
      d[i] = @[i+1] * (i + 1)

  integ: (d) ->
    d.rank = rank + 1
    for i from 0 to @rank - 1
      d[i + 1] = @[i] / (i + 1)

  # l is the letter (or string) for the independent variable
  # if not given, defaults to x
  write: (l = "x") ->
    q = ""
    j = false

    for i from @rank to 0 by -1
      if @[i] < 0
        if j then q += " "
        q += "- "
        j = false
      else if j and @[i]
        q += " + "
        j = false

      if @[i]
        switch i
          case 0
            q += Math.abs(@[i])
            j = true
          case 1
            if Math.abs(@[i]) is 1
              q += l
            else
              q += Math.abs(@[i]) + l
            j = true
          default
            if Math.abs(@[i]) is 1
              q += l + "^" + i
            else
              q += Math.abs(@[i]) + l + "^" + i
            j = true

    return q

  rwrite: (l = "x") ->
    q = ""
    j = false

    for i from 0 to @rank
      if @[i] < 0
        if j then q += " "
        q += "- "
        j = false
      else if j and @[i]
        q += " + "
        j = false

      if @[i]
        switch i
          case 0
            q += Math.abs(@[i])
            j = true
          case 1
            if Math.abs(@[i]) is 1
              q += l
            else
              q += Math.abs(@[i]) + l
            j = true
          default
            if Math.abs(@[i]) is 1
              q += l + "^" + i
            else
              q += Math.abs(@[i]) + l + "^" + i
            j = true

    return q

  # gerwrite: (l = "x") ->
  #   q = ""
  #   j = false

  #   for i from 0 to @rank
  #     c = guessExact(@[i])
  #     ac = guessExact(Math.abs(@[i]))

  #     if @[i] < 0
  #       if j then q += " "
  #       q += "- "
  #       j = false
  #     else if j and @[i]
  #       q += " + "
  #       j = false

  #     if @[i]
  #       switch i
  #         case 0
  #           q += ac
  #           j = true
  #         case 1
  #           if ac is 1
  #             q += l
  #           else
  #             q += ac + l
  #           j = true
  #         default
  #           if ac is 1
  #             q += l + "^" + i
  #           else
  #             q += ac + l + "^" + i
  #           j = true

  #   return q

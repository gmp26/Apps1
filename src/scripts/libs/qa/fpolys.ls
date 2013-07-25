#
# fpolys.ls - polynomials with fractions
#

# write a fractional coefficient
fcoeff = (f,t) ->
  if f.top is f.bot
    t
  else if f.top + f.bot is 0
    "-" + t
  else if f.top is 0
    ""
  else
    f.write() + t



# write a fractional coefficient's modulus
fbcoeff = (f,t) ->
  g = new frac(Math.abs(f.top), Math.abs(f.bot))
  if g.top is g.bot
    t
  else if g.top is 0
    ""
  else
    g.write() + t



# Polynomial over Q
class fpoly
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
      @[i] = toFrac(@set.arguments[i])

  setrand: (maxentry) ->
    for i from 0 to @rank
      @[i] = randfrac(12)
    if @[@rank].top is 0
      @[@rank].top = maxentry
    @[@rank].reduce()

  # set from a poly (over Z) object
  setpoly: (a) ->
    @rank = a.rank
    for i from 0 to @rank
      @[i] = new frac(a[i], 1)

  compute: (x) ->
    x = toFrac(x)
    y = new frac(0,1)
    for i from 0 to @rank
      y.add(@[i].top * (x.top)^i, @[i].bot * (x.bot)^i)
    y.reduce()
    return y

  gcd: ->
    g = new frac(0,1)
    for i from 0 to @rank - 1
      g.bot *= @[i].bot
    a = @[@rank].top * g.bot / @[@rank].bot
    for i from 0 to @rank - 1
      a = gcd(a, @[i].top * g.bot / @[i].bot)
    g.reduce()

  xthru: (x) ->
    for i from 0 to @rank
      @[i].prod(x)

  diff: (d) ->
    d.rank = rank - 1
    for i from 0 to @rank - 1
      d[i] = @[i+1]
      d[i].prod(frac(i + 1, 1))
    return d

  integ: (d) ->
    d.rank = @rank + 1
    d[0] = new frac()
    for i from 0 to @rank
      d[i + 1] = @[i]
      d[i + 1].bot *= i + 1
      d[i + 1].reduce()
    return d

  write: ->
    q = ""
    j = false

    for i from @rank to 0 by -1
      val = @[i].top / @[i].bot

      if val < 0
        if j then q += " "
        q += "- "
        j = false
      else if j and val
        q += " + "
        j = false

      if val
        a = new frac(Math.abs(@[i].top, @[i].bot))
        switch i
          case 0
            q += a.write()
            j = true
          case 1
            if a.top is a.bot then q += "x"
            else q += a.write() + "x"
            j = true
          default
            if a.top is a.bot then q += "x^" + i
            else q += a.write() + "x^" + i
            j = true

      return q

  rwrite: ->
    q = ""
    j = false

    for i from 0 to @rank
      val = @[i].top / @[i].bot

      if val < 0
        if j then q += " "
        q += "- "
        j = false
      else if j and val
        q += " + "
        j = false

      if val
        a = new frac(Math.abs(@[i].top), Math.abs(@[i].bot))
        switch i
          case 0
            q += a.write()
            j = true
          case 1
            if a.top is a.bot then q += "x"
            else q += a.write() + "x"
            j = true
          default
            if a.top is a.bot then q += "x^" + i
            else q += a.write() + "x^" + i
            j = true

    return q

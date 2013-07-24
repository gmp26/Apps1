#
# complex.ls - complex numbers
#

# complex number object:
# * set or get it in Re/Im or r/theta
# * write it in LaTeX
class complex
  (Re, Im) ->
    @Re = Re
    @Im = Im

  set: (Re, Im) ->
    @Re = Re
    @Im = Im
    return this

  ptoc: (Mod, Arg) ->
    z = new complex
    z.Re = Mod * Math.cos(Arg)
    z.Im = Mod * Math.sin(Arg)
    return z

  random: (maxentry, rad) ->
    z = new complex
    z = Complex.ptoc(rand(0, maxentry), Math.PI * rand(0, rad * 2) / rad)
    return z

  randnz: (maxentry, rad) ->
    z = new complex
    z = Complex.ptoc(rand(1, maxentry), Math.PI * rand(0, rad * 2) / rad)
    return z

  ctop: (z = @) ->
    Mod = Math.sqrt((z.Re)^2 + (z.Im)^2);
    Arg = Math.atan2(z.Im, z.Re)
    return [Mod, Arg]

  isnull: -> !(@Re || @Im)

  write: ->
    u = [guessExact(@Re), guessExact(@Im)]
    if u[1] is 0
      return u[0]
    else if u[0] is 0
      return ascoeff(u[1]) + "i"
    else
      return (u[0] + " + " + ascoeff(u[1]) + "i").replace(/\+ \-/g, '-')

  add: (u,v) ->
    w = new complex(@Re + u, @Im + v)
    return w

  times: (u,v) ->
    w = new complex(@Re * u - @Im * v, @Re * v + @Im * u)
    return w

  divide: (u,v) ->
    d = u^2 + v^2
    w = new complex((u * @Re + @Im) / d, (u * @Im - v * @Re) / d)
    return w

  equals: (u,v) -> @Re is u and @Im is v

Complex = new complex # prototypical complex that lets us get the methods

# polynomial (over C) object:
# * can be set manually or randomly
# * nonzero terms counted
# * computed at a z value
# * multiplied by a constant
# * differentiated
# * write it in LaTeX
class c_poly
  (rank) ->
    @rank

  terms: ->
    n = 0
    for i from 0 to @rank
      if !@[i].isnull then n++
    return n

  set: ->
    @rank = @set.arguments.length - 1
    for i from 0 to @rank
      @[i] = @set.arguments.argument[i]

  setrand: (maxentry, rad) ->
    for i from 0 to @rank
      @[i] = Complex.random(maxentry, rad)
    if @[@rank].isnull
      @[@rank].set(1,0)

  compute: (z) ->
    y = new complex(0,0)
    zp = z.ctop()
    for i from 0 to @rank
      zi = Complex.ptoc((zp[0])^i, zp[1] * i)
      y = y.add(zi[0], zi[1])
    return y

  # TODO complex gcd() using Gaussian integers
  # gcd: ->
  #   a = @[@rank]
  #   for i from 0 to @rank - 1
  #     a = gcd(a, that[i])
  #   return a

  xthru: (x) ->
    for i from 0 to @rank
      @[i] = @[i].times(z.Re, z.Im)

  addp: (x) ->
    for i from 0 to @rank
      @[i] = @[i].add(x[i].Re, x[i].Im)

  diff: (d) ->
    d.rank = rank - 1
    for i from 0 to @rank - 1
      d[i] = @[i + 1].times(i + 1, 0)
    return d

  integ: (d) ->
    d.rank = rank + 1
    for i from 0 to @rank - 1
      d[i + 1] = @[i].divide(i + 1, 0)
    return d

  # l is the letter (or string) for the independent variable.
  # If not given, defaults to z
  write: (l = "z") ->
    q = ""
    j = false

    for i from @rank to 0 by -1
      if !@[i].isnull()

        if j
          if (@[i].Im is 0 and @[i].Re < 0) or (@[i].Re is 0 and @[i].Im < 0)
            q += " - "
          else
            q += " + "
          j = false

        switch i
          case 0
            q += @[i].write()
            j = true

          case 1
            if @[i].equals(1,0) or @[i].equals(-1,0)
              q += l
            else if @[i].equals(0,1) or @[i].equals(0,-1)
              q += "i" + l
            else if @[i].Im is 0 and @[i].Re < 0
              q += Math.abs(@[i].Re) + l
            else if @[i].Re is 0 and @[i].Im < 0
              q += Math.abs(@[i].Im) + "i" + l
            else
              q += "(" + @[i].write() + ")" + l
            j = true

          default
            if @[i].equals(1,0) or @[i].equals(-1,0)
              q += l + "^" + i
            else if @[i].equals(0,1) or @[i].equals(0,-1)
              q += "i" + l + "^" + i
            else if @[i].Im is 0 and @[i].Re < 0
              q += Math.abs(@[i].Re) + l + "^" + i
            else if @[i].Re is 0 and @[i].Im < 0
              q += Math.abs(@[i].Im) + "i" + l + "^" + i
            else
              q += "(" + @[i].write() + ")" + l + "^" + i
            j = true

    return q

  rwrite: (l = "z") ->
    q = ""
    j = false

    for i from 0 to @rank
      if !@[i].isnull()

        if j
          if (@[i].Im is 0 and @[i].Re < 0) or (@[i].Re is 0 and @[i].Im < 0)
            q += " - "
          else
            q += " + "
          j = false

        switch i
          case 0
            q += @[i].write()
            j = true

          case 1
            if @[i].equals(1,0) or @[i].equals(-1,0)
              q += l
            else if @[i].equals(0,1) or @[i].equals(0,-1)
              q += "i" + l
            else if @[i].Im is 0 and @[i].Re < 0
              q += Math.abs(@[i].Re) + l
            else if @[i].Re is 0 and @[i].Im < 0
              q += Math.abs(@[i].Im) + "i" + l
            else
              q += "(" + @[i].write() + ")" + l
            j = true

          default
            if @[i].equals(1,0) or @[i].equals(-1,0)
              q += l + "^" + i
            else if @[i].equals(0,1) or @[i].equals(0,-1)
              q += "i" + l + "^" + i
            else if @[i].Im is 0 and @[i].Re < 0
              q += Math.abs(@[i].Re) + l + "^" + i
            else if @[i].Re is 0 and @[i].Im < 0
              q += Math.abs(@[i].Im) + "i" + l + "^" + i
            else
              q += "(" + @[i].write() + ")" + l + "^" + i
            j = true
    return q

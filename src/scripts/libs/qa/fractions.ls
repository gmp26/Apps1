#
# fractions.ls - fraction object
#

# fraction object top/bot:
# * keeps itself in lowest terms
# * write in LaTeX
# * assignment
# * equality check
class frac
  (top, bot) ->
    if typeof top is "undefined" then @top = 0 else @top = top
    if typeof bot is "undefined" then @bot = 1 else @bot = bot

  write: ->
    @reduce()
    if @bot is 1 then return @top
    if @top is 0 then return "0"
    else if @top >0 then return "\\frac{" + @top + "}{" + @bot + "}"
    else return "-\\frac{" + Math.abs(@top) + "}{" + @bot + "}"

  reduce: ->
    if @bot < 0
      @top *= -1
      @bot *= -1

    c = gcd(Math.abs(@top), @bot)
    @top /= c
    @bot /= c

    return this

  set: (a,b) ->
    @top = a
    @bot = b
    @reduce()

  clone: ->
    f = new frac(@top, @bot)
    return f

  equals: (b) ->
    @reduce()
    b.reduce()
    if @top is b.top and @bot is b.bot then 1 else 0

  # updates in place
  add: (c,d) ->
    if typeof d is void then d = 1
    @set(@top * d + @bot * c, @bot * d)
    @reduce()
    return this

  # updates in place
  prod: (c) ->
    c = toFrac(c)
    @set(@top * c.top, @bot * c.bot)
    @reduce()
    return this



# makes a number into a fraction, leaves a fraction unchanged
toFrac = (n) ->
  if typeof n is "number"
    return new frac(n, 1)
  else if n instanceof frac
    return n.clone()
  else
    throw new Error "toFrac received " + typeof(n) + " expecting number or frac"



# returns a random fraction
randfrac = (max) ->
  f = new frac(rand(max), randnz(max))
  f.reduce()
  return f



# square matrix object over Q
class fmatrix
  (dim) ->
    @dim = dim

  zero: ->
    for i from 0 to @dim - 1
      @[i] = new Array(@dim)
      for j from 0 to @dim - 1
        @[i][j] = new frac(0)

  clone: ->
    r = new fmatrix(@dim)
    r.zero()

    for i from 0 to @dim - 1
      for j from 0 to @dim - 1
        r[i][j] = @[i][j].clone()

    return r

  set: ->
    args = @set.arguments
    n = @dim

    if args.length is n^2
      @zero()
      for i from 0 to n - 1
        for j from 0 to n - 1
          @[i][j] = toFrac(args[(i * n) + j])
    else
      throw new Error "Wrong number of elements sent to fmatrix.set()"

  # Fill with random integers (not fractions)
  setrand: (maxentry) ->
    for i from 0 to @dim - 1
      @[i] = new Array(@dim)
      for j from 0 to @dim - 1
        @[i][j] = toFrac(rand(maxentry))

  # Doesn't update in place, returns a new matrix
  add: (a) ->
    if @dim is not a.dim
      throw new Error "Size mismatch matrices sent to matrix.add()"
    else
      s = new fmatrix(@dim)

      for i from 0 to @dim - 1
        s[i] = new Array(@dim)
        for j from 0 to @dim - 1
          s[i][j] = @[i][j].clone().add(a[i][j].top, a[i][j].bot)

      return s

  # Doesn't update in place, returns a new matrix
  # this*a, not a*this
  times: (a) ->
    if @dim is not a.dim
      throw new Error "Size mismatch matrices sent to matrix.times()"
    else
      s = new fmatrix(@dim)

      for i from 0 to @dim - 1
        s[i] = new Array(@dim)
        for j from 0 to @dim - 1
          s[i][j] = toFrac(0)

      for i from 0 to @dim - 1
        for j from 0 to @dim - 1
          for k from 0 to @dim - 1
            f = @[i][j].clone().prod(a[j][k])
            s[i][k].add(f.top, f.bot) # (AB)_ik = A_ij B_jk

      return s

  det: ->
    if @dim is 1
      return @[0][0]

    else if @dim is 2
      f = @[0][1].clone().prod(@[1][0]).prod(-1)
      g = @[0][0].clone().prod(@[1][1]).add(f.top, f.bot)

    # Laplace expansion by first row.
    # It's slow, but it still works (and it's more maintainable than the other, quicker algos).
    # Besides, we're only going up to 3x3.  It's still bugged though :S
    else
      res = new frac(0,1)

      for i from 0 to @dim - 1
        minor = new fmatrix(@dim - 1)

        for j from 0 to @dim - 2
          minor[j] = new Array(@dim - 1)
          for k from 0 to @dim - 2
            if k >= i
              minor[j][k] = @[j+1][k+1].clone()
            else
              minor[j][k] = @[j+1][k].clone()

        if i % 2 is 1
          f = minor.det().prod(-1).prod(@[0][i])
        else
          f = minor.det().prod(@[0][i])
        res = res.add(f.top, f.bot)

      return res

  T: ->
    res = new fmatrix(@dim)

    for i from 0 to @dim - 1
      res[i] = new Array(@dim)
      for j from 0 to @dim - 1
        res[i][j] = @[j][i].clone()

    return res

  inv: ->
    d = @det

    if d.top is 0
      throw new Error "Singular matrix sent to matrix.inv()"

    else if @dim is 2
      res = new fmatrix(2)
      res.set(new frac( @[1][1].top * d.bot, @[1][1].bot * d.top),
              new frac(-@[0][1].top * d.bot, @[0][1].bot * d.top),
              new frac(-@[1][0].top * d.bot, @[1][0].bot * d.top),
              new frac( @[0][0].top * d.bot, @[0][0].bot * d.top))
      return res

    else
      cof = new fmatrix(@dim)

      for i from 0 to @dim - 1
        cof[i] = new Array(@dim)

        for j from 0 to @dim - 1
          minor = new fmatrix(@dim - 1)
          for k from 0 to @dim - 2
            minor[k] = new Array(@dim)
            for l from 0 to @dim - 2

              # this was a pair of ternary operators in the JS
              # but they don't compile properly in LS :(
              if k >= i then kk = k + 1 else kk = k
              if l >= j then ll = l + 1 else ll = l

              minor[k][l] = @[kk][ll].clone()

          if (i + j) % 2 is 1
            f = minor.det().prod(-1,1)
          else
            f = minor.det()

          cof[i][j] = new frac(f.top * d.bot, f.bot * d.top)

      return cof.T()

  tr: ->
    res = toFrac(0,1)
    for i from 0 to @dim - 1
      res = res.add(@[i][i].top, @[i][i].bot)
    return res

  write: ->
    fbot = []

    for i from 0 to @dim - 1
      for j from 0 to @dim - 1
        fbot.push(@[i][j].bot)

    d = lcm(fbot[0], fbot[1])
    for i from 2 to fbot.length - 1
      d = lcm(d, fbot[i])

    if d is 1
      res = "\\begin{pmatrix}"
    else
      f = new frac(1,d)
      res = "\\displaystyle " + f.write() + "\\textstyle \\begin{pmatrix}"

    for i from 0 to @dim - 1
      for j from 0 to @dim - 1
        res += @[i][j].top / @[i][j].bot * d

        if j is @dim - 1
          if i is @dim - 1
            res += "\\end{pmatrix}"
          else
            res += "\\\\"
        else
          res += "&"

    return res

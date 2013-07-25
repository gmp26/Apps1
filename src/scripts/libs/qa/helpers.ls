#
# helpers.ls - utility functions
#

# gcd of any list of integers
gcd = ->
  a = Math.abs gcd.arguments.0
  b = Math.abs gcd.arguments[gcd.arguments.length - 1]
  i = gcd.arguments.length
  while i > 2
    b = gcd b, gcd.arguments[i - 2]
    i--

  # If either is zero then their gcd is the other
  if a * b is 0 then return a + b

  while (a = a % b) and (b = b % a)
    continue
  a + b



# lcm of any list of integers
lcm = ->
  a = Math.abs lcm.arguments.0
  b = Math.abs lcm.arguments[lcm.arguments.length - 1]
  i = lcm.arguments.length
  while i > 2
    b = lcm b, lcm.arguments[i - 2]
    i--

  # If either is zero then their gcd is the other
  if a * b is 0 then return 0

  d = gcd(a,b)
  return a * b / d



# sin of pi/6, pi/4 and multiples in the form a/b + c sqrt(2)/d + e sqrt(3)/f
sinpi = (a,b) ->

  # get the fraction in lowest terms
  c = gcd(a,b)
  a /= c; b /= c;

  if a is 0 then return [0,1,0,1,0,1]
  if a is 1 and b is 6 then return [1,2,0,1,0,1]
  if a is 1 and b is 4 then return [0,1,1,2,0,1]
  if a is 1 and b is 3 then return [0,1,0,1,1,2]
  if a is 1 and b is 2 then return [1,1,0,1,0,1]
  if a is 1 and b is 1 then return [0,1,0,1,0,1]

  if a / b > 0.5 and a <= b then return sinpi(b - a, b)

  if a / b > 1 and a / b <= 1.5
    A = new Array(6)
    A = sinpi(a - b, b)
    for i from 0 to 5 by 2
      A[i] *= -1
    return A

  if a / b > 1.5 and a / b < 2
    A = new Array 6
    A = sinpi(2 * b - a, b)
    for i from 0 to 5 by 2
      A[i] *= -1
    return A

  return sinpi(a - 2 * b, b)



# cos as per above
cospi = (a,b) -> sinpi(2 * a + b, 2 * b)



# returns a random number between min and max, one argument becomes -min to min, zero arguments picks 0 or 1
rand = (min, max) ->
  if typeof min is "undefined" then return Math.round(Math.random())
  if typeof max is "undefined"
    min = -Math.abs(min)
    max =  Math.abs(min)
  return min + Math.floor((max - min + 1) * Math.random())



# returns a random number between min and max, but not zero, one argument becomes -min to min
randnz = (min, max) ->

  if typeof max is "undefined"
    min = -Math.abs(min)
    max =  Math.abs(min)

  if min is 0 then min++
  if max is 0 then max--

  if min > max then return min

  if (min < 0) and (max > 0)
    a = rand(min, max - 1)
    if a >= 0 then a++
  else
    a = rand(min, max)
  return a



# orders the arguments after r low to high and returns rth. r = 0 returns max.
rank = (r) ->
  n = rank.arguments.length - 1
  if r is 0 then r = n
  list = new Array(n)

  for i from 0 to n - 1
    list[i] = rank.arguments[i + 1]

  for i from 0 to n - 1
    if list[i] > list[i + 1]
      c = list[i]
      list[i] = list[i + 1]
      list[i + 1] = c
      i = -1

  list[r - 1]



# returns the location of the max value in argument, an array (faster version of rank(0, ...) and operates on an array instead of an arg list)
maxel = (a) ->
  n = a.length
  m = a[0]
  ma = 0

  for i from 1 to n-1
    if a[i] > m then m = a[i]; ma = i

  return ma



# returns a permutation (0-based) to sort the argument, an array, low to high.  Merge sort
ranking = (a) ->
  n = a.length

  if n > 2
    left = new Array(Math.floor(n / 2))
    right = new Array(n - left.length)

    for i from 0 to n-1
      if i < left.length then left[i] = a[i]
      else right[i - left.length] = a[i]

    ls = ranking(left)
    rs = ranking(right)

    result = new Array(n)

    lp = 0; rp = 0;

    for i from 0 to n-1
      if rp is right.length or (lp < left.length and left[ls[lp]] < right[rs[rp]])
        result[i] = ls[lp]
        lp++
      else
        result[i] = rs[rp] + left.length
        rp++

    return result

  else if n is 2
    if a[1] < a[0] then [1,0] else [0,1]

  else [0]



# Returns n distinct random integers in the range [min, max].
# If max omitted, then [-|min|, |min|].
# If both omitted, then [1, n]
distrand = (n, min, max) ->

  if typeof max is "undefined"
    if typeof min is "undefined"
      min = 1
      max = n
    else
      min = -Math.abs(min)
      max =  Math.abs(min)

  list = new Array(max + 1 - min)
  res = new Array(n)

  for i from 0 to max - min
    list[i] = i + min

  for i from 0 to n - 1
    s = rand(i, max - min)
    res[i] = list[s]
    list[s] = list[i]

  return res



# Returns n distinct nonzero random integers in the range [min, max].
# If max omitted, then [-|min|, |min|].
# If both omitted, then [1, n]
distrandnz = (n, min, max) ->

  if typeof max is "undefined"
    if typeof min is "undefined"
      min = 1
      max = n
    else
      min = -Math.abs(min)
      max =  Math.abs(min)

  if min is 0 then min++
  if max is 0 then max--

  if min > max then return [min]
  else
    if ((min < 0) and (max > 0)) then a = 0 else a = 1
    list = new Array(max + a - min)
    res = new Array(n)

    for i from 0 to max + a - min - 1
      list[i] = i + min
      if a is 0 and list[i] >= 0
        list[i]++

    for i from 0 to n - 1
      s = rand(i, max + a - min - 1)
      res[i] = list[s]
      list[s] = list[i]

    return res



# root object a*sqrt(n): reduces itself, write in LaTeX
class sqroot
  (n) ->
    if n is not Math.floor(n)
      throw new Error "non-integer sent to square root"
    else
      N = n
      A = 1
      i = 2

      while i^2 <= N
        if N % i^2 is 0
          N /= i^2
          A *= i
        i++

      @n = N
      @a = A

    # shouldn't happen but useful for debugging
    throw new Error "a is not an integer" if @a % 1 is not 0

  write: ->
    if @a is 1 and @n is 1 then return "1"
    else if @a is 1 then return "\\sqrt{" + @n + "}"
    else if @n is 1 then return @a
    else return @a + "\\sqrt{" + @n + "}"



# vector object
# * can be set manually or randomly
# * dot product with another vector
# * its magnitude squared
# * write it in LaTeX
class vector
  (dim) ->
    @dim = dim

  set: ->
    @dim = @set.arguments.length
    for i from 0 to @dim - 1
      @[i] = @set.arguments[i]

  setrand: (maxentry) ->
    for i from 0 to @dim - 1
      @[i] = Math.round(-maxentry + 2 * maxentry * Math.random())

  dot: (U) ->
    sum = 0
    for i from 0 to @dim - 1
      sum += @[i] * U[i]
    throw new Error "dot product is not an integer" if sum % 1 is not 0
    return sum

  cross: (U) ->
    if @dim is 3 and U.dim is 3
      res = new vector(3)
      res.set(0,0,0)

      for i from 0 to 2
        for j from 0 to 2
          for k from 0 to 2
            # (a x b)_i = e_ijk a_j b_k
            res[i] += epsi(i,j,k) * @[j] * U[k]

      return res
    else
      throw new Error "cross product called on vectors other than 3D"

  # in mathmo, we only deal with vectors in Z^2 or Z^3
  # a non-integer (magnitude) causes problems later on
  mag: ->
    throw new Error "magnitude is not an integer" if @dot(@) % 1 is not 0
    return @dot(@)

  write: ->
    q = "\\begin{pmatrix}" + @[0]
    for i from 1 to @dim - 1
      q += "\\\\" + @[i]
    return q + "\\end{pmatrix}"



# ordinals
ord = (n) ->
  throw new Error "negative ordinal requested from ord()" if n < 0

  if Math.floor(n / 10) is 1 then n + "th"

  if n % 10 is 1 then n + "st"
  else if n % 10 is 2 then n + "nd"
  else if n % 10 is 3 then n + "rd"
  else n + "th"



# ordinals, using text for anything up to twelfth
ordt = (n) ->
  throw new Error "negative ordinal requested from ord()" if n < 0
  if n <= 12
    ["zeroth", "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"][n]
  else ord n



# returns a random number from the list sent to the function
pickrand = -> pickrand.arguments[rand(0, pickrand.arguments.length - 1)]



# Levi-Civita symbol on {n, n+1, n+2} for integer n
epsi = (i,j,k) -> (i - j) * (j - k) * (k - i) / 2

String::repeat = (num) -> (new Array num + 1).join this



# Returns a number signed with + or - as a string
# Useful for printing equations
signedNumber = (x) -> if x > 0 then "+" + x else x.toString!



# Simplifies a root of the form (a + b sqrt(c)) / d
# Returns a LaTeX formatted string
simplifySurd = (a,b,c,d) ->
  sq = new sqroot(c)
  B = sq.a * b
  C = sq.n

  # This shouldn't happen, but a helpful error message is better than debugging JS blind
  if d is 0
    return "Error; zero in the denominator"

  # Surd of the form (B sqrt(C))/d
  else if a is 0
    f = new frac(B,d)

    if f.top is 1 then top = ""
    else if f.top is -1 then top = "-"
    else top = f.top

    if f.bot is 1
      return top + "\\sqrt{" + C + "}"
    else
    return "\\frac{" + top + "\\sqrt{" + C + "}}{" + f.bot + "}"

  # Case a / d
  else if B is 0 or C is 0
    f = new frac(a,d)
    return f.write()

  # Case (a + b) / d
  else if C is 1
    f = new frac(a + B, d)
    return f.write()

  # Final case
  # Non-trivial root, every term is non-zero
  else

    # simplify the terms
    h = gcd(a,B,d)
    a /= h; B /= h; d /= h;

    if d < 0
      a *= -1
      B *= -1
      d *= -1

    # returns a LaTeX string for the numerator
    # assumes all terms are non-zero, root simplified, C != 1
    # these cases are already caught
    innerSurd = (x,y,z) ->
      if y is 1 then x + "+\\sqrt{" + z + "}"
      else if y is -1 then x + "-\\sqrt{" + z + "}"
      else x + signedNumber(y) + "\\sqrt{" + z + "}"

    if d is 1 then innerSurd(a,B,C)
    else "\\frac{" + innerSurd(a,B,C) + "}{" + d + "}"

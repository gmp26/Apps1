#
# polys.ls - polynomials
#

# Write a number as a coefficient (1 disappears, -1 becomes -)

ascoeff = (a) ->
  if a ~= 1 then return ""
  else if a ~= -1 then return "-"
  else return a



# Write a number as a |coefficient| (+-1 disappears)

abscoeff = (a) ->
  a = Math.abs(a)
  if a ~= 1 then return ""
  else return a



# Express a list of polynomial factors (x+a[0])(x+a[1])...

express = (a) ->
  r = ""
  n = a.length
  p = ranking(a)
  t = 0
  s = new poly(1)
  s[1] = 1

  for i from 0 to n-1
    if i and a[p[i]] ~= q
      t++
    else
      if t
        r += "^"+(t+1)
      t = 0
      s[0] = a[p[i]]
      r += '('+s.write()+")"
      q = a[p[i]]

  if t
    r += "^"+(t+1)

  return r



polyexpand = (a,b) ->
  p = new poly(a.rank + b.rank)
  p.setrand(0) # set all entries to 0

  for i from 0 to a.rank
    for j from 0 to b.rank
      p[i+j] += a[i] * b[j]

  return p



# return a quadratic of the form ax^2 + bx + c

p_quadratic = (a,b,c) ->
  p = new poly(2)
  p.set(c,b,a)
  return p



# return a linear function of the form ax + b

p_linear = (a,b) ->
  p = new poly(1)
  p.set(b,a)
  return p



# return the constant polynomial a

p_const = (a) ->
  p = new poly(0)
  p.set(a)
  return p



# polynomial (over Z) object:
#
# * can be set manually or randomly
# * nonzero terms counted
# * computed at an x value
# * multiplied by a constant
# * differentiated
# * write it in LaTeX
# * used in several other functions
#
# REMEMBER: it's stored backwards (x^0 term first)

# this.rank = @rank

poly = (rank) ->

  that = this

  that.rank = rank

  that.terms !->
    n = 0
    for i from 0 to @rank
      if @[i]
        n++
    return n

  that.set !->
    that.rank = that.set.arguments.length-1
    for i from 0 to that.rank
      that[i] = that.set.arguments[i]

  that.setrand = (maxentry) ->
    for i from 0 to that.rank
      that[i] = Math.round(-maxentry + 2*maxentry*Math.random())

    if that[that.rank] ~= 0
      that[that.rank] = maxentry

  that.compute = (x) ->
    y = 0
    for i from 0 to that.rank
      y += that[i] * x^i
    return y

  that.gcd !->
    a = that[that.rank]
    for i from 0 to that.rank-1
      a = gcd(a, that[i])
    return a

  that.xthru = (x) ->
    for i from 0 to that.rank
      that[i] = that[i]*x

  that.addp = (x) ->
    for i from 0 to that.rank
      that[i] = that[i] + x[i]

  that.diff = (d) ->
    d.rank = rank-1
    for i from 0 to that.rank-1
      d[i] = that[i+1] * (i+1)
    return d

  that.integ = (d) ->
    d.rank = rank+1
    for i from 0 to that.rank-1
      d[i+1] = that[i]/(i+1)
    return d

  # l is the letter (or string) for the independent variable.
  # If not given, defaults to x

  that.write = (l = "x") ->
    q = ""
    j = false

    for i from that.rank to 0 by -1

      if that[i] < 0
        if j then q += ""
        q += "- "
        j = false
      else if j and that[i]
        q += " + "
        j = false

      if that[i]
        switch i
          case 0
            q += Math.abs(that[i])
            j = true
          case 1
            if Math.abs(that[i]) ~= 1
              q += l
            else
              q += Math.abs(that[i])+l
          default
            if Math.abs(that[i]) ~= 1
              q += l+"^"+i
            else
              q += Math.abs(that[i])+l+"^"+i
            j = true

    return q

  that.rwrite = (l = "x") ->
    q = ""
    j = false

    for i from 0 to that.rank

      if that[i] < 0
        if j then q += " "
        q += "- "
        j = false
      else if j and that[i]
        q += " + "
        j = false

      if that[i]
        switch i
          case 0
            q += Math.abs(that[i])
            j = true
          case 1
            if Math.abs(that[i]) ~= 1
              q += l
            else
              q += Math.abs(that[i])+l
            j = true
          default
            if Math.abs(that[i]) ~= 1
              q += l+"^"+i
            else
              q += Math.abs(that[i])+l+"^"+i
            j = true

    return q

  return ""

# This was commented out in the original JS file and hasn't been fixed yet
#
#   /*
#   that.gerwrite=function(l)
#   {
#     if(typeof(l)=='undefined')
#     {
#       l='x';
#     }
#     var q="";
#     var j=false;
#     for(var i=0;i<=that.rank;i++)
#     {
#       c=guessExact(that[i]);
#       ac=guessExact(Math.abs(that[i]));
#       if(that[i]<0)
#       {
#         if(j) q+=' ';
#         q+='- ';
#         j=false;
#       }
#       else if(j&&that[i])
#       {
#         q+=' + ';
#         j=false;
#       }
#       if(that[i])
#       {
#         switch(i)
#         {
#           case 0:
#             q+=ac; j=true;
#           break;
#           case 1:
#             if(ac==1)
#               q+=l;
#             else
#               q+=ac+l;
#             j=true;
#           break;
#           default:
#             if(ac==1)
#               q+=l+'^'+i;
#             else
#               q+=ac+l+'^'+i;
#             j=true;
#           break;
#         }
#       }
#     }
#     return q;
#   }
#   */

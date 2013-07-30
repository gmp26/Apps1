#
# geometry.ls - LaTeX formatting of equations of lines and circles
#

# Equations of the form
# (x-a)^2 + (y-b)^2 = r^2
circleEq1 = (a,b,r) ->

  if a ~= 0
    eqString = "x^2"
  else
    eqString = "(x"+signedNumber(-a)+")^2"

  if b ~= 0
    eqString += "+y^2="
  else
    eqString += "+(y"+signedNumber(-b)+")^2="

  eqString += r^2

# Equations of the form
# x^2 - 2ax + y^2 - 2bx = c
circleEq2 = (a,b,r) ->

  C = r^2 - a^2 - b^2

  if a ~= 0
    eqString = "x^2"
  else
    eqString = "x^2"+signedNumber(-2*a)+"x"

  if b ~= 0
    eqString += "+y^2"
  else
    eqString += "+y^2"+signedNumber(-2*b)+"y"

  if C < 0
    eqString += signedNumber(-C)+"=0"
  else
    eqString += "="+C

# Given points (a,b) and (c,d) on the line, return a
# LaTeX-formatted equation in the form
# ax + by + c = 0
# Given a line in the form y=mx+c, use x=0 and x=1
lineEq1 = (a,b,c,d) ->

  xcoeff = b - d
  ycoeff = c - a
  concoeff = -b * (c - a) + (d - b) * a

  # Put the terms in lowest common form
  h = gcd(xcoeff, ycoeff, concoeff)

  xcoeff /= h
  ycoeff /= h
  concoeff /= h

  # Tidying it up for prettier printing
  if xcoeff < 0
    xcoeff *= -1
    ycoeff *= -1
    concoeff *= -1

  if xcoeff ~= 0 and ycoeff < 0
    ycoeff *= -1
    concoeff *= -1

  # x-term
  if xcoeff ~= 1
    eqString = "x"
  else if xcoeff != 0
    eqString = xcoeff+"x"

  # y-term
  if xcoeff ~= 0
    if ycoeff ~= 1
      eqString = "y"
    else if ycoeff ~= -1
      eqString = "-y"
    else
      eqString = ycoeff+"y"
  else
    if ycoeff ~= 1
      eqString += "+y"
    else if ycoeff ~= -1
      eqString += "-y"
    else if ycoeff != 0
      eqString += signedNumber(ycoeff)+"y"

  if concoeff is not 0
    eqString += signedNumber(concoeff) + "=0"
  else
    eqString += "=0"

  return eqString

# Given a gradient and an intercept, return a
# LaTeX-formatted equation in the form
# y = mx + c
lineEq2 = (m,c) ->

  eqString = "y="

  if m ~= -1
    eqString += "-x"
  else if m ~= 1
    eqString += "x"
  else if m != 0
    eqString += m+"x"

  if c != 0
    if m ~= 0
      eqString += c
    else
      eqString += signedNumber(c)

  return eqString

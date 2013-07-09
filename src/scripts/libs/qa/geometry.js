/*
	geometry.js - LaTeX formatting of equations of circles and lines
*/

// Equations of the form
// (x-a)^2 + (y-b)^2 = r^2
function circleEq1(a,b,r)
{
  var eqString="";

  if (a==0) {
    eqString += "x^2";
  } else {
    eqString += "(x"+signedNumber(-a)+")^2";
  }

  if (b==0) {
    eqString += "+y^2=";
  } else {
    eqString += "+(y"+signedNumber(-b)+")^2=";
  }

  eqString += +r^2;
  return eqString;
}

// Equations of the form
// x^2 - 2ax + y^2 - 2bx = c
function circleEq2(a,b,r)
{
  var C=r^2-a^2-b^2;
  var eqString="";

  if (a==0) {
    eqString += "x^2";
  } else {
    eqString += "x^2"+signedNumber(-2*a)+"x";
  }

  if (b==0) {
    eqString += "+y^2";
  } else {
    eqString += "+y^2"+signedNumber(-2*b)+"y";
  }

  eqString += "="+C;
  return eqString;
}

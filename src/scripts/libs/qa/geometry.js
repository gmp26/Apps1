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

// Given two points (a,b) and (c,d) on a line, calculate the equation in the form
// ay + bx + c = 0
// If you have the line in the form y=mx+c, use x=0 and x=1
//
// TODO: You get a sign on the y-term if the x-term has zero coefficient. Fix this.
function lineEq1(a,b,c,d)
{
  var xcoeff=b-d;
  var ycoeff=c-a;
  var concoeff=-b*(c-a)+(d-b)*a;

  // Check the terms are in lowest common form
  var h=gcd(xcoeff,ycoeff,concoeff);

  xcoeff/=h;
  ycoeff/=h;
  concoeff/=h;

  // Tidying it up for pretty printing
  if (xcoeff<0) {
    xcoeff*=-1;
    ycoeff*=-1;
    concoeff*=-1;
  }

  var eqString="";

  if (xcoeff==1) {
    eqString+="x";
  } else if (xcoeff!==0) {
    eqString+=xcoeff+"x";
  }

  if (ycoeff==1) {
    eqString+="+y";
  } else if (ycoeff==-1) {
    eqString+="-y";
  } else if (ycoeff!==0) {
    eqString+=signedNumber(xcoeff)+"y";
  }

  if (concoeff!==0) {
    eqString+=signedNumber(concoeff);
  }

  eqString+="=0";

  return eqString;
}

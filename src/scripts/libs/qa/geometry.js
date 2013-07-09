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

  eqString += +r*r;
  return eqString;
}

// Equations of the form
// x^2 - 2ax + y^2 - 2bx = c
function circleEq2(a,b,r)
{
  var C=r*r-a*a-b*b;
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
    if (xcoeff==0) {
      eqString+="y";
    } else {
      eqString+="+y";
    }
  } else if (ycoeff==-1) {
    eqString+="-y";
  } else if (ycoeff!==0) {
    if (xcoeff==0) {
      eqString+=ycoeff+"y";
    } else {
      eqString+=signedNumber(ycoeff)+"y";
    }
  }

  if (concoeff!==0) {
    eqString+=signedNumber(concoeff);
  }

  eqString+="=0";

  return eqString;
}

// Given a gradient and an intercept, it returns a LaTeX-formatted equation of the line in the form
// y=mx+c
function lineEq2(m,c)
{
  var eqString="y=";

  if (m==-1) {
    eqString+="-x";
  } else if (m==1) {
    eqString+="x";
  } else if (m!==0) {
    eqString+=m+"x";
  }

  if (c!==0) {
    if (m==0) {
      eqString+=c;
    } else {
      eqString+=signedNumber(c);
    }
  }
  return eqString;
}

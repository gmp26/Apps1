// nRich RPG (Randomised Problems Generator)


var egfn=function(){};
var egparms=0;

// Partial Fractions
function makePartial()
{
	function makePartial1() // Two terms in the denominator
	{
		var a=randnz(8);
		var b=new poly(1);b.setrand(8);
		if(b[1]<0)
		{
			b.xthru(-1);
			a=-a;
		}
		var e=gcd(a, b.gcd());
		if(e>1)
		{
			b.xthru(1/e);
			a/=e;
		}
		var c=randnz(8);
		var d=new poly(1);d.setrand(8);
		if(d[1]<0)
		{
			d.xthru(-1);
			c=-c;
		}
		var f=gcd(c, d.gcd());
		if(f>1)
		{
			d.xthru(1/f);
			c/=f;
		}
		if(b[1]==d[1]&&b[0]==d[0]) d[0]=-d[0];

		var aString=(a>0?"$$":"$$-")+"\\frac{"+Math.abs(a)+"}{"+b.write()+"}"+(c>0?"+":"-")+"\\frac{"+Math.abs(c)+"}{"+d.write()+"}$$";

		var bot=polyexpand(b, d);
		b.xthru(c);
		d.xthru(a);
		b.addp(d);

		var qString="Express$$\\frac{"+b.write()+"}{"+bot.write()+"}$$in partial fractions.";

		var qa=[qString,aString];
		return qa;
	}
	function makePartial2() // Three terms in the denominator
	{
		var m=distrandnz(3, 3);
		var d=randnz(4),e=randnz(3),f=randnz(3);
		var l=ranking(m);
		var n=[d, e, f];
		var a=m[l[0]], b=m[l[1]], c=m[l[2]];
		d=n[l[0]];e=n[l[1]];f=n[l[2]];
		var u=new poly(1),v=new poly(1),w=new poly(1);
		u[1]=v[1]=w[1]=1;
		u[0]=a;v[0]=b;w[0]=c;
		var p=polyexpand(u, v),q=polyexpand(u, w), r=polyexpand(v, w);
		p.xthru(f);q.xthru(e);r.xthru(d);
		p.addp(q);p.addp(r);
		var qString="Express$$\\frac{"+p.write()+"}{"+express([a, b, c])+"}$$in partial fractions.";
		var aString=(d>0?"$$":"$$-")+"\\frac{"+Math.abs(d)+"}{"+u.write()+"}"+(e>0?"+":"-")+"\\frac{"+Math.abs(e)+"}{"+v.write()+"}"+(f>0?"+":"-")+"\\frac{"+Math.abs(f)+"}{"+w.write()+"}$$";
		var qa=[qString,aString];
		return qa;
	}
	var qa;
	if(rand()) qa=makePartial1();
	else qa=makePartial2();
	return qa;
}

// Binomial Theorem
function makeBinomial2()
{
	var p=new poly(1);
	p[0]=rand(1,5);
	p[1]=randnz(6-p[0]);
	var n=Math.round(3+Math.random()*(3-Math.max(0,Math.max(p[0]-3,p[1]-3))));

	var q=new poly(3);
	q[0]=Math.pow(p[0],n);
	q[1]=n*Math.pow(p[0],n-1)*p[1];
	q[2]=n*(n-1)*Math.pow(p[0],n-2)/2*Math.pow(p[1], 2);
	q[3]=n*(n-1)*(n-2)*Math.pow(p[0],n-3)/6*Math.pow(p[1], 3);

	var qString="Evaluate$$("+p.rwrite()+")^"+n+"$$to the fourth term.";
	var aString="$$"+q.rwrite()+"$$";

	var qa=[qString, aString];
	return qa;
}

// Polynomial Integration
function makePolyInt()
{
	var A=rand(-3,2);
	var B=rand(A+1,3);

	var a=new poly(3);
	a.setrand(6);
	var b=new fpoly(3);
	b.setpoly(a);
	var c=new fpoly(4);
	b.integ(c);

	var qString="Evaluate$$\\int_\{"+A+"\}^\{"+B+"\}"+a.write()+"\\,\\mathrm{d}x$$";
	var hi=c.compute(B);
	var lo=c.compute(A);
	lo.prod(-1);
	var ans=new frac(hi.top, hi.bot);
	ans.add(lo.top, lo.bot);
	var aString="$$"+ans.write()+"$$";

	var qa = [qString, aString];
	return qa;
}

// Simple Trig Integration
function makeTrigInt()
{
	var a=rand(0,7);
	var b=rand(1-Math.min(a,1),8);
	var A=a?randnz(4):0;
	var B=b?randnz(4):0;
	var U=pickrand(2,3,4,6);

	var term1=a?ascoeff(A)+"\\sin\{"+ascoeff(a)+"x\}":"";
	var term2=b?abscoeff(B)+"\\cos\{"+ascoeff(b)+"x\}":"";

	var qString="Evaluate$$\\int_\{0\}^\{\\pi/"+U+"\}"+(a?b?term1+(B>0?" + ":" - ")+term2:term1:(B<0?"-":"")+term2)+"\\,\\mathrm{d}x$$";

	var soln1=new Array(6);
	var soln2=new Array(6);
	var soln=new Array(6);

	if(a)
	{
		soln1=cospi(a,U);
		for(var i=0;i<6;i+=2) soln1[i]*=-A;
		for(i=1;i<6;i+=2) soln1[i]*=a;
		if(soln1[0])
		{
			soln1[0]=soln1[1]*A+a*soln1[0];
			soln1[1]*=a;
		}
		else
		{
			soln1[0]=A;
			soln1[1]=a;
		}
	}
	else soln1=[0,1,0,1,0,1];

	if(b)
	{
		soln2=sinpi(b,U);
		for(i=0;i<6;i+=2) soln2[i]*=B;
		for(i=1;i<6;i+=2) soln2[i]*=b;
	}
	else soln2=[0,1,0,1,0,1];

	for(i=0;i<6;i+=2)
	{
		soln[i]=soln1[i]*soln2[i+1]+soln1[i+1]*soln2[i];
		soln[i+1]=soln1[i+1]*soln2[i+1];
		if(soln[i+1]<0)
		{
			soln[i]*=-1;
			soln[i+1]*=-1;
		}
		if(soln[i])
		{
			var c=gcd(Math.abs(soln[i]),soln[i+1]);
			soln[i]/=c;
			soln[i+1]/=c;
		}
	}
	var aString="$$";
	if(soln[0]&&soln[1]==1) aString+=soln[0];
	else if(soln[0]>0) aString+="\\frac\{"+soln[0]+"\}\{"+soln[1]+"\}";
	else if(soln[0]<0) aString+="-\\frac\{"+(-soln[0])+"\}\{"+soln[1]+"\}";
	if(soln[2]&&soln[3]==1) aString+=(aString.length?soln[2]>0?"+":"":"")+soln[2]+"\\sqrt\{2\}";
	else if(soln[2]>0) aString+=(aString.length?"+":"")+"\\frac\{"+soln[2]+"\}\{"+soln[3]+"\}\\sqrt\{2\}";
	else if(soln[2]<0) aString+="-\\frac\{"+(-soln[2])+"\}\{"+soln[3]+"\}\\sqrt\{2\}";
	if(soln[4]&&soln[5]==1) aString+=(aString.length?soln[4]>0?"+":"":"")+soln[4]+"\\sqrt\{3\}";
	else if(soln[4]>0) aString+=(aString.length?"+":"")+"\\frac\{"+soln[4]+"\}\{"+soln[5]+"\}\\sqrt\{3\}";
	else if(soln[4]<0) aString+="-\\frac\{"+(-soln[4])+"\}\{"+soln[5]+"\}\\sqrt\{3\}";

	if(aString=="$$")
		aString += "0$$";
	else
		aString += "$$";
	var qa=[qString,aString];
	return qa;
}

// Vectors
function makeVector()
{
	function ntol(n)
	{
		return String.fromCharCode(n+"A".charCodeAt(0));
	}
	var A=new Array(4);
	for(var i=0;i<4;i++)
	{
		A[i]=new vector(3);
		A[i].setrand(10);
	}
	var B=new Array(0,1,2,3);
	for(i=0;i<3;i++)
	{
		if(A[B[i]].mag()<A[B[i+1]].mag())
		{
			var c=B[i];
			B[i]=B[i+1];
			B[i+1]=c;
			i=-1;
		}
	}
	var v=distrand(3, 0, 3);

	//qString="Consider the four vectors$$\\begin\{array\}\{l\} \\mathbf\{A\}="+A[0].write()+", \\mathbf\{B\}="+A[1].write()+", \\mathbf\{C\}="+A[2].write()+", \\mathbf\{D\}="+A[3].write()+".\\\\ \\\\ \\mbox\{	(i) Order the vectors by magnitude.\}\\\\ \\\\ \\mbox\{	(ii) Use the scalar product to find the angles between (a) \}\\mathbf\{"+ntol(v[0])+"\} \\mbox\{ and \}\\mathbf\{"+ntol(v[1])+"\}, \\mbox\{(b) \}\\mathbf\{"+ntol(v[1])+"\} \\mbox\{ and \} \\mathbf\{"+ntol(v[2])+"\}.\\end\{array\}";
	var qString = "Consider the four vectors";
	qString += "$$\\mathbf{A}=" + A[0].write() + "\\,,\\; \\mathbf{B}=" + A[1].write() + "$$";
	qString += "$$\\mathbf{C}=" + A[2].write() + "\\,,\\; \\mathbf{D}=" + A[3].write() + "$$";
	qString += "<ol class=\"exercise\"><li>Order the vectors by magnitude.</li>";
	qString += "<li>Use the scalar product to find the angles between";
	qString += "<ol class=\"subexercise\"><li>\\(\\mathbf{" + ntol(v[0]) + "}\\) and \\(\\mathbf{" + ntol(v[1]) + "}\\),</li>";
	qString += "<li>\\(\\mathbf{" + ntol(v[1]) + "}\\) and \\(\\mathbf{" + ntol(v[2]) + "}\\)</li></ol></ol>";

	var aString = "<ol class=\"exercise\"><li>";
	aString += "\\(|\\mathbf{" + ntol(B[0]) + "}|=\\sqrt{" + A[B[0]].mag();
	aString += "},\\) \\(|\\mathbf{" + ntol(B[1]) + "}|=\\sqrt{" + A[B[1]].mag();
	aString += "},\\) \\( |\\mathbf{" + ntol(B[2]) + "}|=\\sqrt{" + A[B[2]].mag();
	aString += "}\\) and \\(|\\mathbf{" + ntol(B[3]) + "}|=\\sqrt{" + A[B[3]].mag();
	aString += "}\\).</li>";

	var top1=A[v[0]].dot(A[v[1]]);
	var bot1=new sqroot(A[v[0]].mag()*A[v[1]].mag());
	c=gcd(Math.abs(top1),bot1.a);
	top1/=c;
	bot1.a/=c;
	var top2=A[v[1]].dot(A[v[2]]);
	var bot2=new sqroot(A[v[1]].mag()*A[v[2]].mag());
	c=gcd(Math.abs(top2),bot2.a);
	top2/=c;
	bot2.a/=c;

	aString+="<li><ol class=\"subexercise\"><li>\\(";
	if(top1==0) aString+="\\pi/2";
	else if(top1==1&&bot1.n==1&&bot1.a==1) aString+="0";
	else if(top1==-1&&bot1.n==1&&bot1.a==1) aString+="\\pi";
	else
	{
		aString+="\\arccos\\left(";
		if(bot1.a==1&&bot1.n==1) aString+=top1;
		else aString+="\\frac{"+top1+"}{"+bot1.write()+"}";
		aString+="\\right)";
	}
	aString+="\\)</li><li>\\(";
	if(top2==0) aString+="\\pi/2";
	else if(top2==1&&bot2.n==1&&bot2.a==1) aString+="0";
	else if(top2==-1&&bot2.n==1&&bot2.a==1) aString+="\\pi";
	else
	{
		aString += "\\arccos\\left(";
		if(bot2.a==1&&bot2.n==1) aString+=top2;
		else aString += "\\frac\{"+top2+"\}\{"+bot2.write()+"\}";
		aString += "\\right)";
	}
	aString += "\\)</li></ol></li></ol>";

	var qa=[qString,aString];
	return qa;
}

// Lines in 3D
function makeLines()
{
	var a1=randnz(3);
	var b1=randnz(3);
	var c1=randnz(3);
	var d1=rand(3);
	var e1=rand(3);
	var f1=rand(3);
	var a2,b2,c2,d2,e2,f2;
	var ch=rand(1,10);
	if(ch<6)
	{
		a2=randnz(3);
		b2=randnz(3);
		c2=randnz(3);
		d2=rand(3);
		e2=rand(3);
		f2=rand(3);
	}
	else if(ch<10)
	{
		a2=randnz(2);
		b2=randnz(2);
		c2=randnz(2);
		if(a1*b1*c1%3==0&&a1*b1*c1%2==0)
		{
			if(rand())
			{
				if(a1%3==0) a1/=3;
				if(b1%3==0) b1/=3;
				if(c1%3==0) c1/=3;
			}
			else
			{
				if(a1%2==0) a1/=2;
				if(b1%2==0) b1/=2;
				if(c1%2==0) c1/=2;
			}
		}
		if(a2*d1%a1!=0)
		{
			a2*=a1; b2*=a1; c2*=a1;
		}
		if(b2*e1%b1!=0)
		{
			a2*=b1; b2*=b1; c2*=b1;
		}
		if(c2*f1%c1!=0)
		{
			a2*=c1; b2*=c1; c2*=c1;
		}
		d2=a2*d1/a1;
		e2=b2*e1/b1;
		f2=c2*f1/c1;
		var m1=Math.abs(Math.min(d2,Math.min(e2,f2)));
		var m2=Math.max(d2,Math.max(e2,f2));
		if(m1>4) { d2+=4; e2+=4; f2+=4; }
		if(m2>4) { d2-=2; e2-=2; f2-=2; }
		if((m1=gcd(a2,b2,c2,d2,e2,f2))>1)
		{
			a2/=m1;b2/=m1;c2/=m1;d2/=m1;e2/=m1;f2/=m1;
		}
	}
	else
	{
		var sn=randnz(2);
		a2=a1*sn;
		b2=b1*sn;
		c2=c1*sn;
		d2=rand(3);
		e2=rand(3);
		f2=rand(3);
	}
	var p1=new poly(1);p1[0]=d1;p1[1]=a1;
	var q1=new poly(1);q1[0]=e1;q1[1]=b1;
	var r1=new poly(1);r1[0]=f1;r1[1]=c1;
	var p2=new poly(1);p2[0]=d2;p2[1]=a2;
	var q2=new poly(1);q2[0]=e2;q2[1]=b2;
	var r2=new poly(1);r2[0]=f2;r2[1]=c2;
	var eqn1=p1.write('x')+"="+q1.write('y')+"="+r1.write('z');
	var eqn2=p2.write('x')+"="+q2.write('y')+"="+r2.write('z');

	var qString="Consider the lines$$"+eqn1+"$$and$$"+eqn2+"$$Find the angle between them<br>and determine whether they<br>intersect.";
	var aString = "";

	if(a1*b2==b1*a2&&b1*c2==c1*b2)
	{
		if(a2*b2*d1-b2*a1*d2==a2*b2*e1-a2*b1*e2&&b2*c2*e1-c2*b1*e2==b2*c2*f1-b2*c1*f2) {
			aString="\\mbox{The lines are identical.}";
		}
		else {
			aString="The lines are parallel and do not meet.";
		}
	}

	else
	{
		cosbot=new sqroot((b1*b1*c1*c1+c1*c1*a1*a1+a1*a1*b1*b1)*(b2*b2*c2*c2+c2*c2*a2*a2+a2*a2*b2*b2));
		costh=new frac(b1*b2*c1*c2+c1*c2*a1*a2+a1*a2*b1*b2,cosbot.a);
		cosbot.a=costh.bot;
		aString="The angle between the lines is$$";
		if(costh.top==0)
			aString+="\\pi/2.$$";
		else {
			aString+="\\arccos\\left(";
			if(cosbot.n==1) aString+=costh.write();
			else aString+="\\frac{"+costh.top+"}{"+cosbot.write()+"}";
			aString+="\\right).$$";
		}
		var mu=new frac();
		var lam1=new frac();
		var lam2=new frac();
		if(a1*b2-a2*b1)
		{
			mu.set(a2*b2*(e1-d1)-a2*b1*e2+a1*b2*d2,a1*b2-a2*b1);
			lam1.set(b1*mu.top-b1*e2*mu.bot+e1*b2*mu.bot,mu.bot*b2);
			lam2.set(c1*mu.top-c1*f2*mu.bot+f1*c2*mu.bot,mu.bot*c2);
		}
		else
		{
			mu.set(b2*c2*(f1-e1)-b2*c1*f2+b1*c2*e2,b1*c2-b2*c1);
			lam1.set(c1*mu.top-c1*f2*mu.bot+f1*c2*mu.bot,mu.bot*c2);
			lam2.set(a1*mu.top-a1*d2*mu.bot+d1*a2*mu.bot,mu.bot*a2);
		}
		if(lam1.equals(lam2))
		{
			var xm=new frac(lam1.top-d1*lam1.bot,a1*lam1.bot);
			var ym=new frac(lam1.top-e1*lam1.bot,b1*lam1.bot);
			var zm=new frac(lam1.top-f1*lam1.bot,c1*lam1.bot);
			aString+="The lines meet at the point$$\\left("+xm.write()+","+ym.write()+","+zm.write()+"\\right).$$";
		}
		else aString+="The lines do not meet.";
	}
	var qa=[qString,aString];
	return qa;
}

// Equation of lines in 2D
// This isn’t perfect, but it does the job. Some prettying of the output wouldn’t be amiss.
function makeLinesEq()
{
  function makeLines1()
  {
    var a=rand(6);
    var b=rand(6);
    var c=rand(6);
    var d=rand(6);

    while (a==c && b==d) // Check for degeneracy
    {
      c=rand(6);
      d=rand(6);
    }

    var qString="Find the equation of the line passing through \\(("+a+","+b+")\\) and \\(("+c+","+d+")\\).";

    if (b==d) // Vertical lines
    {
      var aString="$$y="+b+".$$";
    }
    else if (a==c) // Horizontal lines
    {
      var aString="$$x="+a+".$$";
    }
    else // Other case
    {
      if (d-b==c-a) {
        var grad = "";
      } else if (d-b==a-c) {
        var grad = "-";
      } else {
        var grad=new frac(d-b,c-a);
        grad=grad.write();
      }

      var intercept=new frac(Math.abs(b*(c-a)-(d-b)*a),Math.abs(c-a));
      intercept=intercept.write();
      if (b-(d-b)/(c-a)*a < 0) {
        intercept = "-" + intercept;
      } else if (b*(c-a)==(d-b)*a) {
        intercept = "";
      } else {
        intercept = "+" + intercept;
      }

      var aString="$$y="+grad+"x"+intercept+"\\qquad \\text{or} \\qquad "+lineEq1(a,b,c,d)+".$$";
    }

    var qa=[qString,aString];
    return qa;
  }
  var qa=makeLines1();
  return qa;
}

// Lines parallel or perpendicular to a point
function makeLineParPerp()
{
  var a=rand(6);
  var b=rand(6);
  var m=rand(6); // If m=6 then we treat it as vertical
  var c=rand(6);

  function makeLinePar(a,b,m,c) {

    var qString="Find the equation of the line passing through \\(("+a+","+b+")\\) and parallel to the line ";

    if (Math.abs(m)==6) {
      while (a==c) {
        c=rand(5);
      }
      qString += "\\(x="+c+"\\).";
      var aString="$$x="+a+".$$";
    } else {
      if (rand()) {
        qString += "\\("+lineEq1(0,c,1,m+c)+".\\)";
      } else {
        qString += "\\("+lineEq2(m,c)+".\\)";
      }

      var intercept=b-m*a;
      var aString="$$"+lineEq2(m,intercept)+"\\qquad\\text{or}\\qquad "+lineEq1(0,intercept,1,m+intercept)+"$$";
    }

    var qa=[qString,aString];
    return qa;
  }

  function makeLinePerp(a,b,m,c) {
    var qString="Find the equation of the line passing through \\(("+a+","+b+")\\) and perpendicular to the line ";

    // Vertical lines
    if (Math.abs(m)==6) {
      while (a==c) {
        c=rand(5);
      }
      qString += "\\(x="+c+"\\).";
      var aString="$$y="+b+".$$";
    } else if (m==0) { // Horizontal lines
      while (a==c) {
        c=rand(5);
      }
      qString += "\\(y="+c+"\\).";
      var aString="$$x="+a+".$$";
    } else {

      // Equation of line in the question
      if(rand()) {
        qString += "\\("+lineEq1(0,c,1,m+c)+".\\)";
      } else {
        qString += "\\("+lineEq2(m,c)+".\\)";
      }

      var aString="$$y=";

      var grad=new frac(-1,m);
      var intercept=new frac(b*m+a,m);
      var C=(b*m+a)/m;

      // Gradient in y=mx+c
      if (m==-1) {
        aString+="x";
      } else if (m==1) {
        aString+="-x";
      } else {
        aString+=grad.write()+"x";
      }

      // Intercept in y=mx+c
      if (C%1==0&&C!==0) {
        aString+=signedNumber(C);
      } else {
        if (C>0) {
          aString+="+"+intercept.write();
        } else if (C<0) {
          aString+=intercept.write();
        }
      }

      aString+="\\qquad\\text{or}\\qquad ";

      aString+="x"+signedNumber(m)+"y";

      if (-b*m-a!==0) {
        aString+=signedNumber(-b*m-a);
      }

      aString+="=0.$$";
    }

    var qa=[qString,aString];
    return qa;
  }

  var qa=rand() ? makeLinePar(a,b,m,c) : makeLinePerp(a,b,m,c);
  return qa;
}

// Equations of circles
function makeCircleEq()
{
  var r=rand(2,7);
  var a=rand(6);
  var b=rand(6);

  function makeCircleEq1(a,b,r) {
    var qString="Find the equation of the circle with centre \\(("+a+","+b+")\\) and radius \\("+r+"\\).";
    if(a==0&&b==0) {
      var aString="$$"+circleEq1(a,b,r)+".$$";
    } else {
      var aString="$$"+circleEq1(a,b,r)+"\\qquad\\text{or}\\qquad "+circleEq2(a,b,r)+".$$";
    }
    var qa=[qString,aString];
    return qa;
  }

  function makeCircleEq2(a,b,r) {
    var qString="Find the centre and radius of the circle with equation";
    if (rand()) {
      qString+="$$"+circleEq1(a,b,r)+".$$";
    } else {
      qString+="$$"+circleEq2(a,b,r)+".$$";
    }
    var aString="The circle has centre \\(("+a+","+b+")\\) and radius \\("+r+"  \\).";
    var qa=[qString,aString];
    return qa;
  }

  var qa=rand() ? makeCircleEq1(a,b,r) : makeCircleEq2(a,b,r);
  return qa;
}

function makeCircLineInter()
{
  function makeLLInter()
  {
    m1=rand(6);
    m2=rand(6);
    c1=rand(6);
    c2=rand(6);

    if (rand()) { // Artificially increase the number of parallel lines
      m1=m2;
    }

    while(m1==m2&&c1==c2) {
      m2=rand(6);
      c2=rand(6);
    }

    var qString="Consider the lines \\(";

    if (rand()) {
      qString+=lineEq1(0,c1,1,m1+c1);
    } else {
      qString+=lineEq2(m1,c1);
    }

    qString+="\\) and \\(";

    if (rand()) {
      qString+=lineEq1(0,c2,1,m2+c2);
    } else {
      qString+=lineEq2(m2,c2);
    }

    qString+="\\). <br><br> Find out how many points of intersection they have, and the location of any intersections."

    if (m1==m2) {
      var aString="The lines do not intersect.";
    } else {
      var xint=new frac(c2-c1,m1-m2);
      var yint=new frac(m1*(c2-c1)+c1*(m1-m2),m1-m2);
      var aString="The lines intersect in a single point, which occurs at \\(\\left("+xint.write()+","+yint.write()+"\\right)\\).";
    }

    var qa=[qString,aString];
    return qa;
  }

  function makeCLInter() {
    var a=rand(6);
    var b=rand(6);
    var r=rand(2,7);

    var m=rand(6);
    var c=rand(6);

    var qString="Consider the line \\(";

    if (rand()) {
      qString+=lineEq1(0,c,1,m+c);
    } else {
      qString+=lineEq2(m,c);
    }

    qString+="\\) and the circle \\( "

    if (rand()) {
      qString+=circleEq1(a,b,r);
    } else {
      qString+=circleEq2(a,b,r);
    }

    qString+="\\). <br><br> Find out how many points of intersection they have, and the location of any intersections."

    // By substitution, we can get an equation of the form Ax^ + Bx + C = 0
    // The roots are the points of intersection
    // We compute these variables:
    var A=m*m+1;
    var B=-2*a+2*m*(c-b);
    var C=(c-b)*(c-b)-r*r+a*a;

    // Discriminant for the roots
    var disc=B*B-4*A*C;
    var sq=new sqroot(disc);

    if (disc>0) {
      var aString="The line and the circle intersect in two points, specifically ";

      // First solution x1 = (-B+sqrt(disc))/2A, y=m*x1+c
      aString+="$$\\left("
      aString+=simplifySurd(-B,sq.a,sq.n,2*A);
      aString+=","+simplifySurd(-m*B+2*c*A,m*sq.a,sq.n,2*A);
      aString+="\\right)";

      aString+="\\qquad\\text{and}\\qquad ";

      // Second solution x2 = (-B-sqrt(disc))/2A, y=m*x2+c
      aString+="\\left("
      aString+=simplifySurd(-B,-sq.a,sq.n,2*A);
      aString+=","+simplifySurd(-m*B+2*c*A,-m*sq.a,sq.n,2*A);
      aString+="\\right)";

      aString+="$$";
    }
    else if (disc<0)
    {
      var aString="The line and the circle do not intersect in any points.";
    }
    else if (disc==0)
    { // This never happens in practice; do we want to artificially increase it?
      var xint=new frac(-B,2*A);
      var yint=new frac(-B*m+c*2*A,2*A);
      var aString="The line and the circle intersect in exactly one point, which occurs at \\(\\left("+xint.write()+","+yint.write()+"\\right)\\).";
    }

    var qa=[qString,aString];
    return qa;
  }

  function makeCCInter() {
    var a1=rand(6);
    var b1=rand(6);
    var r1=rand(2,7);

    var a2=rand(6);
    var b2=rand(6);
    var r2=rand(2,7);

    while (a1==a2&&b1==b2&&r1==r2) {
      a2=rand(6);
      b2=rand(6);
      r2=rand(2,7);
    }

    var qString="Consider the circles \\(";

    if (rand()) {
      qString+=circleEq1(a1,b1,r1);
    } else {
      qString+=circleEq2(a1,b1,r1);
    }

    qString+="\\) and \\("

    if (rand()) {
      qString+=circleEq1(a2,b2,r2);
    } else {
      qString+=circleEq2(a2,b2,r2);
    }

    qString+="\\). <br><br> Find out how many points of intersection they have, and the location of any intersections."

    var D=Math.sqrt((b2-b1)*(b2-b1)+(a2-a1)*(a2-a1));
    var DD=(b2-b1)*(b2-b1)+(a2-a1)*(a2-a1);
    var R=r1+r2;
    var RR=r1*r1-r2*r2;
    var S=Math.abs(r1-r2);

    // The formulae for the case of two intersections is cribbed from
    // http://www.ambrsoft.com/TrigoCalc/Circles2/Circle2.htm

    if (R>D&&D>S) {
      var aString="The circles intersect in two points, which are";

      var d=new sqroot(-DD*DD+2*DD*r1*r1-r1*r1*r1*r1+2*DD*r2*r2+2*r1*r1*r2*r2-r2*r2*r2*r2);

      // First solution
      aString+="$$\\left(";
      aString+=simplifySurd((a1+a2)*DD+(a2-a1)*RR,(b1-b2)*d.a,d.n,2*DD);
      aString+=","+simplifySurd((b1+b2)*DD+(b2-b1)*RR,(a2-a1)*d.a,d.n,2*DD);
      aString+="\\right)";

      aString+="\\qquad\\text{and}\\qquad ";

      // Second solution
      aString+="\\left(";
      aString+=simplifySurd((a1+a2)*DD+(a2-a1)*RR,(b2-b1)*d.a,d.n,2*DD);
      aString+=","+simplifySurd((b1+b2)*DD+(b2-b1)*RR,(a1-a2)*d.a,d.n,2*DD);
      aString+="\\right)";

      aString+="$$";
    } else if (d==R) {
      var x1=new frac(a1*R+r1*(a2-a1),R);
      var y1=new frac(b1*R+r1*(b2-b1),R);
      var aString="The circles intersect in a single point, which is \\(("+x1.write()+","+y1.write()+")\\).";
    } else if (D>R||D<=S) {
      var aString="The two circles do not intersect in any points.";
    } else {
      var aString="Uh oh";
    }

    var qa=[qString,aString];
    return qa;
  }

  if (rand()) {
    var qa=makeCLInter();
  } else if (rand()) {
    var qa=makeLLInter();
  } else {
    var qa=makeCCInter();
  }

  return qa;
}

function makeIneq()
{
	function makeIneq2()
	{
		var roots=distrandnz(2, 6);
		var B=-roots[0]-roots[1];
		var C=roots[0]*roots[1];
		var qString="By factorizing a suitable polynomial, or otherwise, find the values of \\(x\\) which satisfy$$";
		var p=new poly(2);
		switch(rand(1,3))
		{
			case 1:
				p[0]=0;p[1]=B;p[2]=1;
				qString+=p.write()+" < "+(-C);
			break;
			case 2:
				p[0]=C;p[1]=0;p[2]=1;
				qString+=p.write()+" < "+(B?ascoeff(-B)+"x":"0");
			break;
			case 3:
				p[0]=-C;p[1]=-B;p[2]=0;
				qString+="x^2"+" < "+p.write();
			break;
		}
		qString+="$$";
		var aString="$$"+Math.min(roots[0],roots[1])+" < x < "+Math.max(roots[0], roots[1])+"$$";
		var qa=[qString,aString];
		return qa;
	}

	function makeIneq3()
	{
		var a=randnz(5);
		var b=randnz(5);
		var c=rand(2);
		var qString="By factorizing a suitable polynomial, or otherwise, find the values of \\(y\\) which satisfy$$";
		var B=-(a+b+c);
		var C=a*b+b*c+c*a;
		var D=-a*b*c;
		var p=new poly(3);p.set(0,0,0,1);
		var q=new poly(2);q.set(0,0,0);
		switch(rand(1,3))
		{
			case 1:
				p[2]=B;q[1]=-C;q[0]=-D;
			break;
			case 2:
				p[1]=C;q[2]=-B;q[0]=-D;
			break;
			case 3:
				p[0]=D;q[2]=-B;q[1]=-C;
			break;
		}
		qString+=p.write('y')+" < "+q.write('y')+"$$";
		var m=[a,b,c];
		var r=ranking(m);
		var aString="$$y < "+m[r[0]];
		if(m[r[1]]!=m[r[2]])
			aString+="$$and$$"+m[r[1]]+" < y < "+m[r[2]] + "$$";
		else
			aString+= "$$";
		var qa=[qString,aString];
		return qa;
	}
	var qa=rand() ? makeIneq2() : makeIneq3();
	return qa;
}

function makeAP()
{
	var m=rand(2,6);
	var n=rand(m+2,11);
	var k=rand(Math.max(n+3,10),40);
	var a1=new frac();
	var a2=new frac();
	var qString="An arithmetic progression has "+ordt(m)+" term \\(\\alpha\\) and "+ordt(n)+" term \\(\\beta\\). Find the ";
	if(rand()==0)
	{
		qString+="sum to \\("+k+"\\) terms.";
		a1.set(k*(2*n-1-k),2*(n-m));
		a2.set(k*(1+k-2*m),2*(n-m));
	}
	else
	{
		qString+="value of the \\("+ordt(k)+"\\) term.";
		a1.set(n-k,n-m);
		a2.set(k-m,n-m);
	}
	var aString="$$"+fcoeff(a1, "\\alpha")+(a2.top>0?" + ":" - ")+fbcoeff(a2, "\\beta")+"$$";
	var qa=[qString,aString];
	return qa;
}

function makeFactor()
{
	function makeFactor1()
	{
		var a=randnz(4), b=randnz(7), c=randnz(7);
		var u=new poly(1), v=new poly(1), w=new poly(1);
		u[1]=v[1]=w[1]=1;
		u[0]=a;v[0]=b;w[0]=c;
		var x=polyexpand(polyexpand(u, v), w);
		var qString="Divide $$"+x.write()+"$$ by $$("+u.write()+")$$ and hence factorise it completely.";
		var aString="$$"+express([a, b, c])+"$$";
		var qa=[qString,aString];
		return qa;
	}
	function makeFactor2()
	{
		var a=randnz(2), b=randnz(5), c=randnz(5);
		var u=new poly(1), v=new poly(1), w=new poly(1);
		u[1]=v[1]=w[1]=1;
		u[0]=a;v[0]=b;w[0]=c;
		var x=polyexpand(polyexpand(u, v), w);
		var qString="Use the factor theorem to factorise $$"+x.write()+".$$";
		var aString="$$"+express([a, b, c])+"$$";
		var qa=[qString,aString];
		return qa;
	}
	function makeFactor3()
	{
		var a=randnz(2), b=randnz(4), c=randnz(4), d=randnz(4);
		if(d==c) d=-d;
		var u=new poly(1), v=new poly(1), w=new poly(1), y=new poly(1);
		u[1]=v[1]=w[1]=y[1]=1;
		u[0]=a;v[0]=b;w[0]=c;y[0]=d;
		var x=polyexpand(polyexpand(u, v), w);
		var z=polyexpand(polyexpand(u, v), y);
		var qString="Simplify$$\\frac{"+x.write()+"}{"+z.write()+"}.$$";
		var aString="$$\\frac{"+w.write()+"}{"+y.write()+"}$$";
		var qa=[qString,aString];
		return qa;
	}

	var qa;
	if(rand()) qa=makeFactor1();
	else if(rand()) qa=makeFactor2();
	else qa=makeFactor3();
	return qa;
}

function makeQuadratic()
{
	var qString="Find the real roots, if any, of$$";
	var aString;
	if(rand())
	{
		var p=new poly(2);
		p.setrand(5);
		p[2]=1;
		qString+=p.write();
		dcr=p[1]*p[1]-4*p[0];
		if(dcr<0)
		{
			aString="There are no real roots.";
		}
		else if(dcr==0)
		{
			var r1=new frac(-p[1],2);
			aString="$$x="+r1.write()+"$$is a repeated root.";
		}
		else
		{
			var disc=new sqroot(dcr);
			r1=new frac(-p[1],2);
			if(disc.n==1)
			{
				r1.add(disc.a,2);
				aString="$$x="+r1.write()+"\\mbox{ and }x=";
				r1.add(-disc.a);
				aString+=r1.write() + "$$";
			}
			else
			{
				var r2=new frac(disc.a,2);
				aString="$$x="+(r1.top?r1.write():"")+"\\pm";
				if((r2.top!=1)||(r2.bot!=1)) aString+=r2.write();
				aString+="\\sqrt{"+disc.n+"}$$";
			}
		}
	}
	else
	{
		var roots=distrandnz(2, 5);
		p=new poly(2);
		p[2]=1;p[1]=-roots[0]-roots[1];p[0]=roots[0]*roots[1];
		qString+=p.write();
		aString="$$x="+roots[0]+"\\mbox{ and }x="+roots[1]+"$$";
	}
	qString+="=0$$";
	var qa=[qString,aString];
	return qa;
}

function makeComplete()
{
	var a=randnz(4);
	var b=randnz(5);
	var p=new poly(2);
	p[2]=1;p[1]=-2*a;p[0]=a*a+b;
	var qString,aString;
	if(rand())
	{
		qString="By completing the square, find (for real \\(x\\)) the minimum value of$$"+p.write()+".$$";
		aString="The minimum value is \\("+b+",\\) which occurs at \\(x="+a+"\\).";
	}
	else
	{
		var c=randnz(3);
		var d=randnz(c+2,c+4);
		qString="Find the minimum value of$$"+p.write()+"$$in the range$$"+c+"\\leq x\\leq"+d+".$$";
		if(c<=a&&a<=d) aString="The minimum value is \\("+b+"\\) which occurs at \\(x="+a+"\\)";
		else if(a<c) aString="The minimum value is \\("+(c*c-2*a*c+a*a+b)+"\\) which occurs at \\(x="+c+"\\)";
		else aString="The minimum value is \\("+(d*d-2*a*d+a*a+b)+"\\) which occurs at \\(x="+d+"\\)";
	}
	var qa=[qString,aString];
	return qa;
}

function makeBinExp()
{
	var a=rand(1,3);
	var b=randnz(2);
	var n=rand(2,5);
	var m=rand(1,n-1);
	var pow=new frac(m,n);
	var p=new fpoly(1);
	p[0]=new frac(1,1);p[1]=new frac(b,a);
	var qString="Find the first four terms in the expansion of $$\\left("+p.rwrite()+"\\right)^{"+pow.write()+"}$$";
	var q=new fpoly(3);
	q[0]=new frac(1);
	q[1]=new frac(m*b,n*a);
	q[2]=new frac(m*(m-n)*b*b,2*n*n*a*a);
	q[3]=new frac(m*(m-n)*(m-2*n)*b*b*b,6*n*n*n*a*a*a);
	var aString="$$"+q.rwrite()+"$$";
	var qa=[qString,aString];
	return qa;
}

function makeLog()
{
	function makeLog1()
	{
		var a=pickrand(2,3,5);
		var m=rand(1,4);
		var n=rand(1,4);if(n>=m) n++;
		var qString="If \\("+Math.pow(a,m)+"="+Math.pow(a,n)+"^{x},\\) then find \\(x\\).";
		var r=new frac(m,n);
		var aString="$$x="+r.write()+"$$";
		var qa=[qString,aString];
		return qa;
	}
	function makeLog2()
	{
		var a=rand(2,9);
		var b=rand(2,5);
		var c=b*b;
		var qString="Find \\(x\\) if \\("+c+"\\log_{x}"+a+"=\\log_{"+a+"}x\\).";
		var aString="$$x="+Math.pow(a,b)+"\\mbox{ or }x=\\frac{1}{"+Math.pow(a, b)+"}$$";
		var qa=[qString,aString];
		return qa;
	}
	function makeLog3()
	{
		var a=rand(2,7);
		var b=Math.floor(Math.pow(a,7*Math.random()));
		var qString="If \\("+a+"^{x}="+b+"\\), then find \\(x\\) to three decimal places.";
		var c=new Number(Math.log(b)/Math.log(a));
		var aString="$$x="+c.toFixed(3)+"$$";
		var qa=[qString,aString];
		return qa;
	}
	var qa;
	switch(rand(1,3))
	{
		case 1:
			qa=makeLog1();
			break;
		case 2:
			qa=makeLog2();
			break;
		case 3:
			qa=makeLog3();
			break;
	}
	return qa;
}

function makeStationary()
{
	function makeStationary2() // Quadratics
	{
		var p=new poly(2);
		p.set(randnz(4), randnz(8), randnz(4));
		var d=new frac(-p[1],2*p[2]);
		var qString="Find the stationary point of $$y="+p.write()+",$$ and state whether it is a maximum or a minimum.";
		var aString="\\(x="+d.write()+"\\),";
		if(p[2]>0) aString+=" minimum.";
		else aString+=" maximum.";
		var qa=[qString,aString];
		return qa;
	}
	function makeStationary3() // Cubics
	{
		var p=new poly(3);
		var d=randnz(4), c=randnz(3), b=randnz(3), a=randnz(5);
		if((Math.abs(c*(b+a))%2)==1) b++; // I hope it doesn't matter that this can make b==0.
		p.set(d, 3*c*a*b, -3*c*(a+b)/2, c);
		var qString="Find the stationary points of $$y="+p.write()+",$$ and state their nature.";
		var aString;
		if(a==b) aString="\\(x="+a+",\\) point of inflexion.";
		else if(c>0) aString="\\(x="+Math.min(a,b)+"\\), maximum,<br />and \\(x="+Math.max(a,b)+"\\), minimum";
		else aString="\\(x="+Math.min(a,b)+"\\), minimum, <br />and \\(x="+Math.max(a,b)+"\\), maximum";
		var qa=[qString,aString];
		return qa;
	}
	var qa;
	switch(rand(2,3))
	{
		case 2:
			qa=makeStationary2();
			break;
		case 3:
			qa=makeStationary3();
			break;
	}
	return qa;
}

function makeTriangle()
{
	function makeTriangle1()
	{
		var a=rand(3,8);
		var b=rand(a+1,16);
		var m=distrand(3, 0, 2);
		var s=["AB", "BC", "CA"];
		var hyp=s[m[0]];
		var shortv=s[m[1]];
		var other=s[m[2]];
		var angle;
		switch(hyp) {
			case "AB":
				angle="C";
				break;
			case "BC":
				angle="A";
				break;
			case "CA":
				angle="B";
				break;
		}
		var qString="In triangle \\(ABC\\), \\("+shortv+"="+a+"\\), \\("+hyp+"="+b+",\\) and angle \\("+angle+"\\) is a right angle. Find the length of \\("+other+"\\).";
		var length=new sqroot(b*b-a*a);
		var aString="$$"+other+"="+length.write()+"$$";
		var qa=[qString,aString];
		return qa;
	}
	function makeTriangle2()
	{
		var a=rand(2,8);
		var b=rand(1,6);
		var c=rand(Math.max(a,b)-Math.min(a,b)+1,a+b-1);
		var qString="In triangle \\(ABC\\), \\(AB="+c+"\\), \\(BC="+a+",\\) and \\(CA="+b+".\\) Find the angles of the triangle.";
		var aa=new frac(b*b+c*c-a*a,2*b*c);
		var bb=new frac(c*c+a*a-b*b,2*c*a);
		var cc=new frac(a*a+b*b-c*c,2*a*b);
		var aString="$$\\cos A="+aa.write()+",\\cos B="+bb.write()+",\\cos C="+cc.write()+".$$";
		var qa=[qString,aString];
		return qa;
	}
	function makeTriangle3()
	{
		var a=rand(1,6);
		var cc=pickrand(3,4,6);
		var lb=a*Math.ceil(Math.sin(Math.PI/cc));
		var c=rand(lb, Math.max(5, lb+1));
		var qString="In triangle \\(ABC\\), \\(AB="+c+"\\), \\(BC="+a+"\\) and angle \\(C=\\frac{\\pi}{"+cc+"}\\). Find angle \\(A\\).";
		var d=new frac(a,2*c);
		var aString="$$A=\\arcsin\\left("+d.write();
		if(cc==3) aString+="\\sqrt{3}";
		else if(cc==4) aString+="\\sqrt{2}";
		aString+="\\right)$$";
		var qa=[qString,aString];
		return qa;
	}
	var qa;
	switch(rand(1,3))
	{
		case 1:
			qa=makeTriangle1();
			break;
		case 2:
			qa=makeTriangle2();
			break;
		case 3:
			qa=makeTriangle3();
			break;
	}
	return qa;
}

function makeCircle()
{
	var r=rand(2,8);
	var bot=rand(2,9);
	var top=rand(1,2*bot-1);
	var prop=new frac(top,bot);
	var qString="Find, for a sector of angle \\(";
	qString += ((prop.bot===1) ?
		(ascoeff(prop.top)+"\\pi") :
		("\\frac{" + ascoeff(prop.top) + "\\pi}{" + prop.bot + "}"));
	qString += "\\) of a disc of radius \\(" + r + ":\\)<br>i. the length of the perimeter; and<br>ii. the area.";
	var length=new frac(prop.top*r,prop.bot);
	var area=new frac(prop.top*r*r,2*prop.bot);
	var aString="i. \\("+(r*2)+"+"+length.write()+"\\pi\\)<br>ii. \\("+area.write()+"\\pi\\)";
	var qa=[qString,aString];
	return qa;
}

function makeSolvingTrig()
{
	var A=pickrand(1,3,4,5);
	var alpha=pickrand(3,4,6);
	var c=new frac(A,2);

	var qString="Write $$"+c.write();
	if(alpha==6) qString+="\\sqrt{3}";
	else if(alpha==4) qString+="\\sqrt{2}";
	qString+="\\sin{\\theta}+"+c.write();
	if(alpha==4) qString+="\\sqrt{2}";
	else if(alpha==3) qString+="\\sqrt{3}";
	qString+="\\cos{\\theta}$$ in the form \\(A\\sin(\\theta+\\alpha),\\) where \\(A\\) and \\(\\alpha\\) are to be determined.";
	var aString="$$"+(A==1?"":A)+"\\sin\\left(\\theta+\\frac{\\pi}{"+alpha+"}\\right)$$";
	var qa=[qString,aString];
	return qa;
}

function makeVectorEq()
{
	var a=new vector(3);
	a.setrand(6);
	var b=new vector(3);
	b.setrand(6);
	var l=distrand(3, 5);
	var v=new Array(3);
	for(var i=0;i<3;i++)
	{
		v[i]=new vector(3);
		v[i].set(a[0]+l[i]*b[0],a[1]+l[i]*b[1],a[2]+l[i]*b[2]);
	}
	var qString="Show that the points with position vectors$$"+v[0].write()+"\\,,\\;"+v[1].write()+"\\,,\\;"+v[2].write()+"$$";
	qString+="lie on a straight line, and give the equation of the line in the form \\(\\mathbf{r}=\\mathbf{a}+\\lambda\\mathbf{b}\\).";
	var aString='$$'+a.write()+"+\\lambda\,"+b.write()+'$$';
	var qa=[qString,aString];
	return qa;
}

function makeImplicit()
{
	if(rand())
	{
		var a1=rand(1,3);
		var b1=randnz(4);
		var c1=rand(1,3);
		var d1=randnz(4);
		if(d1*a1-b1*c1==0) (d1>0?d1++:d1--);
		var a2=randnz(3);
		var b2=randnz(4);
		var c2=rand(1,3);
		var d2=randnz(4);
		if(d2*a2-b2*c2==0) (d2>0?d2++:d2--);
		var t=randnz(3);
		while((c1*t+d1)==0||(c2*t+d2)==0) (t>0?t++:t--);
		var qString="If $$y=\\frac{"+p_linear(a1, b1).write('t')+"}{"+p_linear(c1, d1).write('t')+"}$$ and $$x=\\frac{"+p_linear(a2, b2).write('t')+"}{"+p_linear(c2, d2).write('t')+"},$$find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) when \\(t="+t+"\\).";
		var a=new frac((a1*d1-b1*c1)*(c2*t+d2)*(c2*t+d2), (a2*d2-b2*c2)*(c1*t+d1)*(c1*t+d1));
		var aString="$$"+a.write()+"$$";
		var qa=[qString,aString];
		return qa;
	}
	else
	{
		var fns=new Array("\\ln(z)", "e^{z}", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
		var difs=new Array("\\frac{1}{z}", "e^{z}", "-\\csc(z)\\cot(z)", "\\sec(z)\\tan(z)", "\\cos(z)", "\\sec^2(z)", "-\\sin(z)");
		var which=distrand(2, 0, 6);
		var p=new poly(rand(1, 3));
		p.setrand(3);
		var q=new poly(1);p.diff(q);
		qString="If $$y+"+fns[which[0]].replace(/z/g, 'y')+"="+fns[which[1]].replace(/z/g, 'x')+(p[p.rank]>0?"+":"")+p.write('x')+",$$ find \\(\\frac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(y\\) and \\(x\\).";
		aString="$$\\frac{\\mathrm{d}y}{\\mathrm{d}x} = \\frac{"+difs[which[1]].replace(/z/g, 'x')+(q[q.rank]>0?"+":"")+q.write('x')+"}{"+difs[which[0]].replace(/z/g, 'y')+"+1}$$";
		qa=[qString,aString];
		return qa;
	}
}

function makeChainRule()
{
	var fns=new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
	var difs=new Array("\\frac{y}{z}", "-y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)");
	var even=new Array(-1, 1, -1, 1, 1, -1);
	var which=rand(0, 5);
	var a=new poly(rand(1, 3));
	a.setrand(8);
	var b=new poly(0);
	a.diff(b);
	var qString="Differentiate \\("+fns[which].replace(/z/g, a.write())+"\\)";
	if(difs[which].charAt(0)=='-')
	{
		difs[which]=difs[which].slice(1);
		b.xthru(-1);
	}
	if(a[a.rank]<0)
	{
		a.xthru(-1);
		b.xthru(even[which]);
	}
	var aString;
	if(which==0)
	{
		var c=gcd(a.gcd(), b.gcd());
		a.xthru(1.0/c);
		b.xthru(1.0/c);
	}
	if((b.terms()>1)&&which)
		aString='('+b.write()+')';
	else if(b.rank==0&&which)
		aString=ascoeff(b[0]);
	else
		aString=b.write();
	aString="$$"+difs[which].replace(/z/g, a.write()).replace(/y/g, aString)+"$$";
	var qa=[qString,aString];
	return qa;
}

function makeProductRule()
{
	var fns=new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
	var difs=new Array("\\frac{y}{z}", "-y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)");
	var even=new Array(-1, 1, -1, 1, 1, -1);
	var which=rand(0, 5);
	var a=new poly(rand(1, 3));
	a.setrand(8);
	var b=new poly(0);
	a.diff(b);
	var qString="Differentiate $$";
	if(a.terms()>1)
		qString+='('+a.write()+')'+fns[which].replace(/z/g, 'x');
	else
		qString+=a.write()+fns[which].replace(/z/g, 'x');
	qString += "$$";
	var aString;
	if(b.terms()>1)
		aString='$$('+b.write()+')';
	else if(b[0]==1)
		aString='$$';
	else if(b[0]==-1)
		aString='$$-';
	else
		aString='$$'+b.write();
	if(difs[which].charAt(0)=='-')
	{
		difs[which]=difs[which].slice(1);
		a.xthru(-1);
	}
	if(a[a.rank]>0)
		aString+=fns[which].replace(/z/g, 'x')+' + ';
	else
	{
		aString+=fns[which].replace(/z/g, 'x')+' - ';
		a.xthru(-1);
	}
	if(which==0&&a[0]==0) // deal with eg. D(axlnx) = alnx + ax/x = alnx + a
	{
		for(var i=0;i<a.rank;i++)
			a[i]=a[i+1];
		a.rank--;
		aString+=a.write();
	}
	else if((a.terms()>1)&&which)
		aString+=difs[which].replace(/y/g, '('+a.write()+')').replace(/z/g, 'x');
	else if((a[0]==1)&&which)
		aString+=difs[which].replace(/y/g, '');
	else
		aString+=difs[which].replace(/y/g, a.write()).replace(/z/g, 'x');
	aString += '$$';
	var qa=[qString,aString];
	return qa;
}

function makeQuotientRule()
{
	var fns=new Array("\\sin(z)", "\\tan(z)", "\\cos(z)");
	var difs=new Array("\\csc(z)\\cot(z)", "\\csc^2(z)", "\\sec(z)\\tan(z)");
	var even=new Array(1, 1, -1);
	var which=rand(0, 2);
	var a=randnz(8);
	var b=new poly(2);
	b.setrand(8);
	// D(a/f.b = (f.b*Da)+(a*D{f.b})/(f*f).b = a*b'*f'.b/(f*f).b
	var qString="Differentiate $$\\frac{"+a+"}{"+fns[which].replace(/z/g, b.write())+"}$$";
	var c=new poly(1);
	b.diff(c);
	c.xthru(a);
	if(b[b.rank]<0)
	{
		b.xthru(-1);
		c.xthru(even[which]);
	}
	var lead=c.write();
	if(c.terms()>1)
		lead='('+lead+')';
	else if(c.rank==0)
	{
		if(c[0]==1)
			lead="";
		else if(c[0]==-1)
			lead="-";
	}
	var bot=difs[which].replace(/z/g, b.write());
	var aString='$$'+lead+bot+'$$';
	var qa=[qString,aString];
	return qa;
}

function makeGP()
{
	if(rand())
	{
		var a=randnz(8);
		var b=rand(2, 9);
		if(rand()) b=-b;
		var c=1;
		if(rand())
		{
			c=rand(2, 5);
			if(c==b) c++;
			var d=gcd(b, c);
			b/=d;
			c/=d;
		}
		var n=rand(5, 10);
		var qString = "Evaluate $$\\sum_{r=0}^{"+n+"} "+(a==1?"":a==-1?c==1&&b>0?"-\\left(":"-":a+"\\times")+(c==1?b<0?"\\left("+b+"\\right)":b:"\\left(\\frac{"+b+"}{"+c+"}\\right)")+"^{r}"+(a==-1&&c==1&&b>0?"\\right)":"")+'$$'; // don't you just love gratuitous use of the ternary operator?
		// Sum is a(1-r^n+1)/(1-r)
		var top=new frac(-Math.pow(b, n+1), Math.pow(c, n+1));
		top.add(1);
		top.prod(a);
		var bot=new frac(-b, c);
		bot.add(1);
		var ans=new frac(top.top*bot.bot, top.bot*bot.top);
		ans.reduce();
		var aString = '$$'+ans.write()+'$$';
	}
	else
	{
		a=randnz(8);
		b=rand(1, 6);
		c=rand(b+1, 12);
		if(rand()) b=-b;
		var r=new frac(b, c);
		r.reduce();
		qString = "Evaluate$$\\sum_{r=0}^{\\infty} "+(a==1?"":a==-1?"-":a+"\\times")+"\\left("+r.write()+"\\right)^{r}$$";
		// Sum is a/(1-r)
		r.prod(-1);
		r.add(1);
		ans=new frac(a*r.bot, r.top);
		aString = '$$'+ans.write()+'$$';
	}
	var qa=[qString,aString];
	return qa;
}

function makeModulus()
{
	var parms=0;
	var fn=0;
	var data=[];
	var graph = null;
	var drawIt;
	if(rand())
	{
		var a=randnz(4);
		var aa=Math.abs(a);
		var l=rand(-aa-6, -aa-2);
		var r=rand(aa+2, aa+6);
		var qString = "Sketch the graph of \\(|"+a+"-|x||\\) for \\("+l+"\\leq{x}\\leq"+r+"\\).";
		drawIt = function(parms)
		{
			var d1 = [];
			var n=0;
			for(var i=parms[1];i<=parms[2]; i+=0.5)
			{
				n++;
				d1.push([i, Math.abs(parms[0]-Math.abs(i))]);
				if(n>50)
					i=parms[2]; // prevent infiniloops
			}
			//$.plot($("#graph"), [d1]);
			return [d1];
		};
		aString = '%GRAPH%'
		params = [a, l, r];
	}
	else
	{
		a=distrandnz(2, 4);
		var s=[rand(), rand()];
		var xa=Math.max(Math.abs(a[0]), Math.abs(a[1]));
		l=rand(-xa-6, -xa-2);
		r=rand(xa+2, xa+6);
		qString="Sketch the graph of \\(("+a[0]+(s[0]?'+':'-')+"|x|)("+a[1]+(s[1]?'+':'-')+"|x|)\\) for \\("+l+"\\leq{x}\\leq"+r+"\\).";
		drawIt=function(parms)
		{
			var a=parms[0];
			var s=parms[1];
			var l=parms[2];
			var r=parms[3];
			var d1 = [];
			var n=0;
			for(var i=l;i<=r; i+=0.25)
			{
				n++;
				d1.push([i, (a[0]+(s[0]?Math.abs(i):-Math.abs(i)))*(a[1]+(s[1]?Math.abs(i):-Math.abs(i)))]);
				if(n>100)
					i=r; // prevent infiniloops
			}
			//$.plot($("#graph"), [d1]);
			return [d1];
		};
		aString = '%GRAPH%';
		params = [a, s, l, r];
	}
	var qa=[qString,aString, drawIt, params];
	return qa;
}

function makeTransformation()
{
	var fnn=new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", "{z}^{2}");
	var which=rand(0, 6);
	var fnf=[
		Math.log, function(x) { return 1/Math.sin(x);},
		function(x) {return 1/Math.cos(x);},
		Math.sin,
		function(x) {return Math.tan(x);},
		Math.cos,
		function(x) {return Math.pow(x, 2);}
	][which];
	var parms=0;
	var fn=0;
	var data = "";
	var p=new poly(1);p.setrand(2);
	var q=new poly(1);q.setrand(3);
	q[1]=Math.abs(q[1]);
	if(rand()) p[1]=1;
	else if(rand()) q[1]=1;
	else if(rand()) p[0]=0;
	else q[0]=0;
	var l=which?rand(-5, 2):Math.max(Math.ceil((1-q[0])/q[1]), 0);
	var r=l+rand(4, 8);
	var qString="Let \\(f(x)="+fnn[which].replace(/z/g, 'x')+"\\). Sketch the graphs of \\(y=f(x)\\) and \\(y="+p.write("f("+q.write()+")")+"\\) for \\("+l+((which==0&&l==0)?" < ":"\\leq ")+"x \\leq "+r+"\\).";
	//console.log(qString);
	drawIt=function(parms)
	{
		var p=parms[0];
		var q=parms[1];
		var f=parms[2];
		var l=parms[3];
		var r=parms[4];
		var d1 = [];
		var d2 = [];
		var n=0;
		for(var i=l;i<=r; i+=0.01)
		{
			n++;
			var y1=f(i);
			if(Math.abs(y1)>20)
				y1=null;
			d1.push([i, y1]);
			var y2=p.compute(f(q.compute(i)));
			if(Math.abs(y2)>20)
				y2=null;
			d2.push([i, y2]);
			if(n>2500)
				i=r; // prevent infiniloops
		}
		//$.plot($("#graph"), [d1, d2]);
		return [d1, d2];
	};
	var aString='%GRAPH%';
	var qa=[qString, aString, drawIt, [p,q,fnf,l,r]];
	return qa;
}

function makeComposition()
{
	var p=new poly(rand(1, 2));p.setrand(2);
	if(p.rank==1&&p[0]==0&&p[1]==1) p[0]=randnz(2);
	var fnf=new Array(Math.sin, Math.tan, Math.cos, 0);
	var fnn=new Array("\\sin(z)", "\\tan(z)", "\\cos(z)", p.write('z'));
	var which=distrand(2, 0, 3);
	var parms=0;
	var fn=0;
	var data="";
	var l=rand(-4, 0);
	var r=rand(Math.max(l+5, 2), 8);
	var qString="Let \\(f(x)="+fnn[which[0]].replace(/z/g, 'x')+", g(x)="+fnn[which[1]].replace(/z/g, 'x')+".\\) Sketch the graph of \\(y=f(g(x))\\) (where it exists) for \\("+l+"\\leq{x}\\leq"+r+"\\) and \\(-12\\leq{y}\\leq12.\\)";
	var drawIt=function(parms)
	{
		var f=parms[0];
		var g=parms[1];
		var p=parms[2];
		var l=parms[3];
		var r=parms[4];
		var d1 = [];
		var n=0;
		for(var i=l;i<=r; i+=0.01)
		{
			n++;
			var y2=g?g(i):p.compute(i);
			var y3=y2?f?f(y2):p.compute(y2):null;
			if(Math.abs(y3)>12)
				y3=null;
			d1.push([i, y3]);
			if(n>2500)
				i=r; // prevent infiniloops
		}
		//$.plot($("#graph"), [d1]);
		return [d1];
	};

	var aString='%GRAPH%';
	var qa=[qString, aString, drawIt, [fnf[which[0]], fnf[which[1]], p, l, r]];
	return qa;
}

function makeParametric()
{
	var p=new poly(rand(1, 2));p.setrand(2);
	if(p.rank==1&&p[0]==0&&p[1]==1) p[0]=randnz(2);
	var fnf=new Array(Math.log, function(x) { return 1/Math.sin(x);}, function(x) {return 1/Math.cos(x);}, Math.sin, Math.tan, Math.cos, 0);
	var fnn=new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", p.write('z'));
	var which=distrand(2, 0, 6);
	var parms=0;
	var fn=0;
	var data="";
	var qString="Sketch the curve in the \\(xy\\) plane given by \\(x="+fnn[which[0]].replace(/z/g, 't')+", y="+fnn[which[1]].replace(/z/g, 't')+". t\\) is a real parameter which ranges from \\("+(which[0]&&which[1]?"-10":"0")+" \\mbox{ to } 10.\\)";
	drawIt = function(parms)
	{
		var f=parms[0];
		var g=parms[1];
		var p=parms[2];
		var l=parms[3];
		var d1 = [];
		for(var i=l;i<=10; i+=0.01)
		{
			var x=f?f(i):p.compute(i);
			if(Math.abs(x)>12)
				x=null;
			var y=g?g(i):p.compute(i);
			if(Math.abs(y)>12)
				y=null;
			if(x&&y)
				d1.push([x, y]);
			else
				d1.push([null, null]);
		}
		//$.plot($("#graph"), [d1]);
		return [d1];
	};
	aString = '%GRAPH%';
	var qa=[qString,aString, drawIt ,[fnf[which[0]], fnf[which[1]], p, (which[0]&&which[1]?-10:0)]];
	return qa;
}

function makeImplicitFunction()
{
	function mIF1()
	{
		var a=distrand(2, 2, 5);
		var n=randnz(3);
		var f=new frac(a[0], a[1]);
		var data="";
		var qString="Sketch the curve in the \\(xy\\) plane given by \\(y="+ascoeff(n)+"x^{"+f.write()+"}\\)";
		var drawIt=function(parms)
		{
			var f=parms[0];
			var n=parms[1];
			var d1 = [];
			for(var i=-10;i<=10; i+=0.01)
			{
				var x=Math.pow(i, f.bot);
				if(Math.abs(x)>12)
					x=null;
				var y=n*Math.pow(i, f.top);
				if(Math.abs(y)>12)
					y=null;
				if(x&&y)
					d1.push([x, y]);
				else
					d1.push([null, null]);
			}
			//$.plot($("#graph"), [d1]);
			return [d1];
		};
		aString = '%GRAPH%';
		var qa=[qString,aString, drawIt, [f,n]];
		return qa;
	}
	function mIF2()
	{
		var a=distrandnz(2, 5);
		var n=randnz(6);
		var f=new frac(a[0], a[1]);
		var data="";
		var qString="Sketch the curve in the \\(xy\\) plane given by \\("+ascoeff(a[0])+"y"+(a[1]>0?"+":"")+ascoeff(a[1])+"x"+(n>0?"+":"")+n+"=0\\)";
		drawIt=function(parms)
		{
			var f=parms[0];
			var n=parms[1];
			var d1 = [];
			for(var i=-10;i<=10; i+=0.01)
			{
				var y=-i*a[1]/a[0]-n/a[0];
				d1.push([i, y]);
			}
			//$.plot($("#graph"), [d1]);
			return [d1];
		};
		var parms=[f, n];
		var aString = '%GRAPH%';
		var qa=[qString,aString, drawIt, [f, n]];
		return qa;
	}
	function mIF3()
	{
		var a=distrandnz(2, 2, 5);
		var qString="Sketch the curve in the \\(xy\\) plane given by \\(\\frac{x^2}{"+(a[0]*a[0])+"} + \\frac{y^2}{"+(a[1]*a[1])+"}=1\\)";

		drawIt=function(parms)
		{
			var d1 = [];
			for(var i=-1;i<=1; i+=0.005)
			{
				var x=parms[0]*Math.cos(i*Math.PI);
				var y=parms[1]*Math.sin(i*Math.PI);
				d1.push([x, y]);
			}
			//$.plot($("#graph"), [d1]);
			return [d1];
		};
		var aString = '%GRAPH%';
		var qa=[qString, aString, drawIt, a];
		return qa;
	}
	return(pickrand(mIF1, mIF2, mIF3)());
}

function makeIntegration()
{
	switch(rand(0, 1))
	{
		case 0:
			var fns=new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
			var difs=new Array("\\frac{y}{z}", "-y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)");
			var even=new Array(-1, 1, -1, 1, 1, -1);
			var which=rand(0, 5);
			var a=new poly(rand(1, 3));
			a.setrand(8);
			a[a.rank]=Math.abs(a[a.rank]);
			if(which==0) a.xthru(1.0/a.gcd());
			var u=randnz(4);
			var b=new poly(0);
			a.diff(b);
			var aString='$$'+p_linear(u, 0).write(fns[which].replace(/z/g, a.write()))+"+c$$";
			if(difs[which].charAt(0)=='-')
			{
				difs[which]=difs[which].slice(1);
				b.xthru(-1);
			}
			var qString;
			b.xthru(u);
			if((b.terms()>1)&&which)
				qString='('+b.write()+')';
			else if(b.rank==0&&which)
				qString=ascoeff(b[0]);
			else
				qString=b.write();
			qString="Find $$\\int"+difs[which].replace(/z/g, a.write()).replace(/y/g, qString)+"\\,\\mathrm{d}x$$";
			var qa=[qString,aString];
			return qa;
		break;
		case 1:
			fns=new Array("\\ln(z)", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)");
			difs=new Array("\\frac{y}{z}", "-y\\csc(z)\\cot(z)", "y\\sec(z)\\tan(z)", "y\\cos(z)", "y\\sec^2(z)", "-y\\sin(z)");
			even=new Array(-1, 1, -1, 1, 1, -1);
			which=rand(0, 5);
			a=new poly(rand(1, 3));
			a.setrand(8);
			b=new poly(0);
			a.diff(b);
			aString="$$";
			if(a.terms()>1)
				aString+='('+a.write()+')'+fns[which].replace(/z/g, 'x');
			else
				aString+=a.write()+fns[which].replace(/z/g, 'x');
			aString+="+c$$";
			qString="Find $$\\int";
			if(b.terms()>1)
				qString+='('+b.write()+')';
			else if(b[0]==1)
				qString+='';
			else if(b[0]==-1)
				qString+='-';
			else
				qString+=b.write();
			if(difs[which].charAt(0)=='-')
			{
				difs[which]=difs[which].slice(1);
				a.xthru(-1);
			}
			if(a[a.rank]>0)
				qString+=fns[which].replace(/z/g, 'x')+' + ';
			else
			{
				qString+=fns[which].replace(/z/g, 'x')+' - ';
				a.xthru(-1);
			}
			if(which==0&&a[0]==0) // deal with eg. D(axlnx) = alnx + ax/x = alnx + a
			{
				for(var i=0;i<a.rank;i++)
					a[i]=a[i+1];
				a.rank--;
				qString+=a.write();
			}
			else if((a.terms()>1)&&which)
				qString+=difs[which].replace(/y/g, '('+a.write()+')').replace(/z/g, 'x');
			else if((a[0]==1)&&which)
				qString+=difs[which].replace(/y/g, '');
			else
				qString+=difs[which].replace(/y/g, a.write()).replace(/z/g, 'x');
			qString+="\\,\\mathrm{d}x$$";
			qa=[qString,aString];
			return qa;
		break;
	}
	return qa;
}

function makeDE()
{
	if(rand()) /* The first order codes was buggy. No time to fix, so removed*/

	/*{
		var n=rand(1,3);
		fns=new Array("\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)", n==1?"{z}":"{z}^"+n);
		recint=new Array("-\\cos(z)", "\\sin(z)", "-\\ln{\|\\csc(z)+\\cot(z)\|}", "\\ln\|\\sin(z)\|", "\\ln\|\\sec(z)+\\tan(z)\|", "{z}^{"+(-1-n)+"}");
		riinv=new Array("\\arccos\\left(-z\\right)", "\\arcsin\\left(z\\right)", 0, 0, 0, "{\\left(z\\right)}^{-\\frac{1}{"+(1+n)+"}}");
		eriinv=new Array(0, 0, 0, "\\arcsin\\left(z\\right)", 0, 0);
		var which=distrand(2, 0, 5);
		qString="\\begin{array}{l}\\mbox{Find the general solution of the following first-order ODE:}\\\\ "+fns[which[0]].replace(/z/g, 'x')+"\\frac{\\,dy}{\\,dx}+"+fns[which[1]].replace(/z/g, 'y')+"=0\\end{array}";
		// f(x)y' + g(y) = 0 => -1/g(y) dy = 1/f(x) dx
		if(recint[which[1]].charAt(0)=='-')
		{
			recint[which[1]]=recint[which[1]].slice(1);
		}
		else
		{
			recint[which[1]]='-'+recint[which[1]];
		}
		if((recint[which[0]].search(/ln/)==-1) || (recint[which[1]].search(/ln/)==-1))
		{
			if(riinv[which[1]]==0)
				aString=recint[which[1]].replace(/z/g, 'y')+"=-"+recint[which[0]].replace(/z/g, 'x')+"+c";
			else
				aString="y="+riinv[which[1]].replace(/z/g, '-'+recint[which[0]].replace(/z/g, 'x')+"+c");
		}
		else
		{
			if(eriinv[which[1]]==0)
				aString=recint[which[1]].replace(/z/g, 'y').replace(/-\\ln{/, "\\frac{1}{").replace(/\\ln/, "")+"=-"+recint[which[0]].replace(/z/g, 'x').replace(/-\\ln{/, "\\frac{A}{").replace(/\\ln/, "A");
			else
				aString="y="+eriinv[which[1]].replace(/z/g, '-'+recint[which[0]].replace(/z/g, 'x').replace(/-\\ln{/, "\\frac{A}{").replace(/\\ln/, "A"));
		}
		aString=aString.replace(/--/g, ""); // -(-x+c) = (x-c) = (x+k) and call k c
		var qa=[qString,aString];
		return qa;
	}
	else if(rand(0, 4)>0)*/
	{
		var roots=distrand(2, 4);
		var p=p_quadratic(1, -roots[0]-roots[1], roots[0]*roots[1]);
		var qString="Find the general solution of the following second-order ODE:$$"+p.write('D').replace("D^2", "\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}").replace("D", "\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}")+(p[0]==0?"":"y")+"=0"+"$$";
		var aString="$$y="+(roots[0]==0?"A":"Ae^{"+ascoeff(roots[0])+"x}")+"+"+(roots[1]==0?"B":"Be^{"+ascoeff(roots[1])+"x}") + '$$';
		var qa=[qString,aString];
		return qa;
	}
	else
	{
		var b=randnz(6);
		qString="Find the general solution of the following first-order ODE:$$x\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}-y="+(-b)+"$$";
		aString="$$y=Ax"+(b>0?'+':'')+b+'$$';
		qa=[qString,aString];
		return qa;
	}
}

function makePowers()
{
	var res=new frac();
	var q="";
	for(var i=0;i<5;i++)
	{
		if(i==1||i>2) q+="\\times ";
		switch(rand(1, 4))
		{
			case 1:
				var a=randnz(4);
				var b=randnz(5);
				var p=new frac(a, b);
				q+=(p.top==p.bot?"x":"x^{"+p.write()+"}");
				if(i>1) a=-a;
				res.add(a, b);
			break;
			case 2:
				a=randnz(4);
				b=randnz(2, 5);
				if(gcd(a, b)!=1) (a>0?a++:a--);
				q+="\\root "+b+" \\of"+(a==1?"{x}":"{x^{"+a+"}}");
				if(i>1) a=-a;
				res.add(a, b);
			break;
			case 3:
				var u=distrand(2, 1, 3);
				a=u[0];
				b=u[1];
				var c=randnz(2, 6);
				p=new frac(a, b);
				q+="\\left(x^{"+p.write()+"}\\right)^"+c;
				if(i>1) a=-a;
				res.add(a*c, b);
			break;
			case 4:
				q+="x";
				res.add((i>1?-1:1), 1);
			break;
		}
		if(i==1) q+="}{";
	}
	var qString="Simplify $$\\frac{"+q+"}$$";
	var aString="$$"+(res.top==res.bot?"x":"x^{"+res.write()+"}")+'$$';
	var qa=[qString,aString];
	return qa;
}

/****************************\
|*	START OF FP MATERIAL	*|
\****************************/

function makeCArithmetic()
{
	var z=Complex.randnz(6, 6);
	var w=Complex.randnz(4, 6);
	var qString="Given \\(z="+z.write()+"\\) and \\(w="+w.write()+"\\), compute:";

	qString += "<ul class=\"exercise\">";
	qString += "<li>\\(z+w\\)</li>";
	qString += "<li>\\(z\\times w\\)</li>";
	qString += "<li>\\(\\frac{z}{w}\\)</li>";
	qString += "<li>\\(\\frac{w}{z}\\)</li>";
	qString += "</ul>";

	var aString = "<ul class=\"exercise\">";
	aString += "<li>\\(" + z.add(w.Re, w.Im).write() +"\\)</li>";
	aString += "<li>\\(" + z.times(w.Re, w.Im).write() +"\\)</li>";
	aString += "<li>\\(" + z.divide(w.Re, w.Im).write() +"\\)</li>";
	aString += "<li>\\(" + w.divide(z.Re, z.Im).write() +"\\)</li>";
	aString += "</ul>";
	var qa=[qString,aString];
	return qa;
}


function makeCPolar()
{
	var z=(rand()?Complex.randnz(6, 6):Complex.randnz(6, 4));
	var qString="Convert \\("+z.write()+"\\) to modulus-argument form.";
  var ma=Complex.ctop(z);
	var r=Math.round(ma[0]);
	var t=guessExact(ma[1]/Math.PI);
	var aString="$$"+(r===1?"":r/*+"\\times "*/)+"e^{"+(t===0?"0":t===1?"\\pi i":t+"\\pi i")+"}$$";
	var qa=[qString,aString];
	return qa;
}

function makeDETwoHard()
{
	var p=new poly(2);
	p.setrand(6);
	p[2]=1;
	var disc=Math.pow(p[1], 2)-4*p[0]*p[2];
	var roots=[0,0];
	if(disc>0)
	{
		roots[0]=(-p[1]+Math.sqrt(disc))/2;
		roots[1]=(-p[1]-Math.sqrt(disc))/2;
	}
	else if(disc===0)
	{
		roots[0]=roots[1]=(-p[1])/2;
	}
	else
	{
		roots[0]=new complex(-p[1]/2, Math.sqrt(-disc)/2);
		roots[1]=new complex(-p[1]/2, -Math.sqrt(-disc)/2);
	}
	var qString="Find the general solution of the following second-order ODE:$$"+p.write('D').replace("D^2", "\\frac{{\\,\\mathrm{d}^2}y}{{\\,\\mathrm{d}x}^2}").replace("D", "\\frac{\\,\\mathrm{d}y}{\\,\\mathrm{d}x}")+(p[0]===0?"":"y")+"=0"+"$$";
	qString=qString.replace(/1y/g, "y");
	var aString="";
	if(disc>0)
	{
		aString="$$y="+(guessExact(roots[0])===0?"A":"Ae^{"+ascoeff(guessExact(roots[0]))+"x}")+"+"+(guessExact(roots[1])===0?"B":"Be^{"+ascoeff(guessExact(roots[1]))+"x}")+"$$";
	}
	else if(disc===0)
	{
		if(roots[0]===0)
		{
			aString="y=Ax+B";
		}
		else
		{
			aString="$$y=(Ax+B)"+(guessExact(roots[0])?"e^{"+ascoeff(guessExact(roots[0]))+"x}":"") + "$$";
		}
	}
	else
	{
		aString="$$y=A\\cos\\left("+ascoeff(guessExact(roots[0].Im))+"x+\\varepsilon\\right)"+(guessExact(roots[0].Re)?"e^{"+ascoeff(guessExact(roots[0].Re))+"x}":"")+"$$";
	}
	var qa=[qString,aString];
	return qa;
}

function makeMatrixQ(dim,max)
{
	var A=new fmatrix(dim);A.setrand(max);
	var B=new fmatrix(dim);B.setrand(max);
	var I=new fmatrix(dim);

	I.zero();
	for(var i = 0; i < I.dim; i++)
		I[i][i].set(1,1);

	// A + tI can be singular for at most n values of t
	// (i.e. eigenvalues of A)
	// Hence the throw statement should never be encountered, but if the
	// matrix API changes or something I'd rather be debugging an
	// exception than an infinite loop.
	for(var i = 0; B.det().top === 0; i++)
	{
		if(i >= B.dim)
			throw new Error('makeMatrixQ: failed to make a non-singular matrix');

		B = B.add(I);
	}

	var qString="Let $$A="+A.write()+" \\qquad \\text{and} \\qquad B="+B.write()+"$$.";
	qString += "Compute: <ul class=\"exercise\">";
	qString += "<li>\\(A+B\\)</li>";
	qString += "<li>\\(A \\times B\\)</li>";
	qString += "<li>\\(B^{-1}\\)</li>";
	qString += "</ul>";
	var S=A.add(B);
	var P=A.times(B);
	var Y=B.inv();
	var aString = "<ul class=\"exercise\">";
	aString += "<li>\\(" + S.write() +"\\)</li>";
	aString += "<li>\\(" + P.write() +"\\)</li>";
	aString += "<li>\\(" + Y.write() +"\\)</li>";
	aString += "</ul>";
	var qa=[qString,aString];
	return qa;
}

function makeMatrix2()
{
	return makeMatrixQ(2,6);
}

function makeMatrix3()
{
	return makeMatrixQ(3,4);
}

function makeTaylor()
{
	var f=['\\sin(z)', '\\cos(z)', '\\arctan(z)', 'e^{z}', '\\log_{e}(1+z)'];
	var t=[[new frac(0), new frac(1), new frac(0), new frac(-1, 6)], [new frac(1), new frac(0), new frac(-1, 2), new frac(0)], [new frac(0), new frac(1), new frac(0), new frac(-1, 3)], [new frac(1), new frac(1), new frac(1, 2), new frac(1, 6)], [new frac(0), new frac(1), new frac(-1, 2), new frac(1, 3)]];
	var which=rand(0, 4);
	var n=randfrac(6);
	if(n.top===0) {n=new frac(1);}
	var qString="Find the Taylor series of \\("+f[which].replace(/z/g, fcoeff(n, 'x'))+"\\) about \\(x=0\\) up to and including the term in \\(x^3\\)";
	var p=new fpoly(3);
	for(var i=0;i<=3;i++)
	{
		p[i]=new frac(t[which][i].top*Math.pow(n.top, i),t[which][i].bot*Math.pow(n.bot, i));
	}
	var aString="$$"+p.rwrite()+"$$";
	var qa=[qString,aString];
	return qa;
}

function makePolarSketch()
{
	var fnf=[Math.sin, Math.tan, Math.cos, function(x){return x;}];
	var fnn=["\\sin(z)", "\\tan(z)", "\\cos(z)", "z"];
	var which=rand(0, 3);
	var parms=0;
	var data;
	var fn=0;
	var a=rand(0, 3);
	var b=rand(1, (which===3?1:5));
	var qString="Sketch the curve given in polar co-ordinates by \\(r="+(a?a+"+":"")+fnn[which].replace(/z/g, ascoeff(b)+'\\theta')+"\\) (where \\(\\theta\\) runs from \\(-\\pi\\) to \\(\\pi\\)).";
	makePolarSketch.fn=function drawIt(parms)
	{
		var f=parms[0];
		var d1 = [];
		for(var i=-1;i<=1; i+=0.005)
		{
			var r=parms[1]+f(i*Math.PI*parms[2]);
			var x=r*Math.cos(i*Math.PI);
			if(Math.abs(x)>6) {x=null;}
			var y=r*Math.sin(i*Math.PI);
			if(Math.abs(y)>6) {y=null;}
			if(x&&y)
			{
				d1.push([x, y]);
			}
			else
			{
				d1.push([null, null]);
			}
		}
		return [d1];
		//$.plot($("#graph"), [d1]);
	};
	var aString='%GRAPH%' + JSON.stringify([fnf[which], a, b])
	var qa=[qString,aString];
	return qa;
}

function makeFurtherVector()
{
	var a=new vector(3);a.setrand(5);
	var b=new vector(3);b.setrand(5);
	var c=new vector(3);c.setrand(5);
	var qString="Let \\(\\mathbf{a}="+a.write()+"\\,\\), \\(\\;\\mathbf{b}="+b.write()+"\\,\\) and \\(\\mathbf{c}="+c.write()+"\\). ";
	qString += "Calculate: <ul class=\"exercise\">";
	qString += "<li>the vector product, \\(\\mathbf{a}\\wedge \\mathbf{b}\\),</li>";
	qString += "<li>the scalar triple product, \\([\\mathbf{a}, \\mathbf{b}, \\mathbf{c}]\\).</li>";
	qString += "</ul>";
	var axb=a.cross(b);
	var abc=axb.dot(c);
	var aString = "<ul class=\"exercise\">";
	aString += "<li>\\(" + axb.write() +"\\)</li>";
	aString += "<li>\\(" + abc +"\\)</li>";
	aString += "</ul>";
	var qa=[qString,aString];
	return qa;
}

function makeNewtonRaphson()
{
	var fns=["\\ln(z)", "e^{z}", "\\csc(z)", "\\sec(z)", "\\sin(z)", "\\tan(z)", "\\cos(z)"];
	var difs=["\\frac{1}{z}", "e^{z}", "-\\csc(z)\\cot(z)", "\\sec(z)\\tan(z)", "\\cos(z)", "\\sec^2(z)", "-\\sin(z)"];
	var fnf=[Math.log, Math.exp, function(x) {return 1/Math.sin(x);}, function(x) {return 1/Math.cos(x);}, Math.sin, Math.tan, Math.cos];
	var diff=[function(x) {return 1/x;}, Math.exp, function(x) {return Math.cos(x)/Math.pow(Math.sin(x), 2);}, function(x) {return Math.sin(x)/Math.pow(Math.cos(x), 2);}, Math.cos, function(x) {return 1/Math.pow(Math.cos(x), 2);}, function(x) {return -Math.sin(x);}];
	var which=rand(0, 6);
	var p=new poly(2);
	p.setrand(6);p[2]=1;
	var np=new poly(2);
	var i;
	for(i=0;i<=2;i++)
	{
		np[i]=-p[i];
	}
	var q=new poly(1); p.diff(q);
	var nq=new poly(1); np.diff(nq);
	var n=rand(4, 6);
	var x=new Array(n+1);x[0]=rand((which?0:2), 4);
	var qString="Use the Newton-Raphson method to find the first \\("+n+"\\) iterates in solving \\("+p.write()+" = "+fns[which].replace(/z/g, 'x')+"\\) with \\(x_0 = "+x[0]+"\\).";
	var aString="Iteration: \\begin{align*} x_{n+1}&=x_{n}-\\frac{"+fns[which].replace(/z/g, 'x_n')+np.write()+"}{"+difs[which].replace(/z/g, 'x_n')+nq.write()+"} \\\\[10pt]";
	for(i=0;i<n;i++)
	{
		var eff=fnf[which](x[i])-p.compute(x[i]);
		var effdash=diff[which](x[i])-q.compute(x[i]);
		x[i+1]=x[i]-(eff/effdash);
		if(Math.abs(x[i+1])<1e-7) {x[i+1]=0;}
		aString+="x_{"+(i+1)+"} &= "+x[i+1]+"\\\\"; /*+"&"+p.write('x_{'+(i+1)+'}')+'='+p.compute(x[i+1])+"&"+fns[which].replace(/z/g, 'x_{'+(i+1)+'}')+"="+fnf[which](x[i+1])*/
	}
  aString+="\\end{align*}"
	if(isNaN(x[n]))
	{
		return(makeNewtonRaphson()); //TODO: find a better way; this is worst-case infinite
	}
	var qa=[qString,aString];
	return qa;
}

function makeFurtherIneq()
{
	var A=distrandnz(2, 6);
	var B=distrandnz(2, 6);
	var C=distrand(2, 6);
	var qString="Find the range of values of \\(x\\) for which$$";
	qString+="\\frac{"+A[0]+"}{"+p_linear(B[0], C[0]).write()+"} < \\frac{"+A[1]+"}{"+p_linear(B[1], C[1]).write()+"}$$";
	var aString;
	var aedb=A[0]*B[1]-A[1]*B[0];
	var root=new frac(A[1]*C[0]-A[0]*C[1], aedb);
	var poles=[new frac(-C[0], B[0]), new frac(-C[1], B[1])]; // both always exist, but they mightn't be distinct
	var i,j,l,m;
	if(aedb===0) // AE=DB
	{
		// singular
		if(poles[0].equals(poles[1])) // always equal
		{
			aString="The two fractions are equivalent, so the inequality never holds.";
		}
		else // never equal
		{
			// changes at poles
			m=new Array(2);
			for(i=0;i<2;i++)
			{
				m[i]=poles[i].top/poles[i].bot;
			}
			l=ranking(m);
			// state for lge -ve x? < if poles[0]>poles[1]
			if(m[0]>m[1])
			{
				aString="$$x < "+poles[l[0]].write()+" \\mbox{ or }"+poles[l[1]].write()+" < x$$";
			}
			else
			{
				aString="$$" + poles[l[0]].write()+" < x < "+poles[l[1]].write() + "$$";
			}
		}
	}
	else
	{
		if(poles[0].equals(poles[1]))
		{
			//for x<-C/B iff A/B > D/E
			i=A[0]/B[0];
			j=A[1]/B[1];
			if(i>j)
			{
				aString="$$x < "+poles[0].write() + "$$";
			}
			else
			{
				aString="$$"+poles[0].write()+" < x$$";
			}
		}
		else
		{
			// changes at root and poles, all distinct
			var n=[root, poles[0], poles[1]];
			m=new Array(3);
			for(i=0;i<3;i++)
			{
				m[i]=n[i].top/n[i].bot;
			}
			l=ranking(m);
			// state for lge -ve x? < if i>j
			i=A[0]/B[0];
			j=A[1]/B[1];
			if(i>j)
			{
				aString="$$x < "+n[l[0]].write()+"\\mbox{ or }"+n[l[1]].write()+" < x < "+n[l[2]].write() + "$$";
			}
			else
			{
				aString="$$"+n[l[0]].write()+" < x < "+n[l[1]].write()+"\\mbox{ or }"+n[l[2]].write()+" < x$$";
			}
		}
	}
	var qa=[qString,aString];
	return qa;
}

function makeSubstInt() /* Has issues with polys which are never in the domain of, say, arcsin; worked around for now */
{
	var p=new poly(rand(1, 2)); p.setrand(2);
	var fns=["\\ln(Az)", "e^{Az}", p.rwrite('z')];
	var fsq=["(\\ln(Az))^2", "e^{2Az}", polyexpand(p, p).write('z')];
	var q=new poly(p.rank-1);p.diff(q);
	var difs=["\\frac{A}{z}", "Ae^{Az}", q.write('z')];
	var t=["\\arcsin(f)", "\\arctan(f)", "{\\rm arsinh}(f)", "{\\rm artanh}(f)"];
	var dt=["\\frac{y}{\\sqrt{1-F}}", "\\frac{y}{1+F}", "\\frac{y}{\\sqrt{1+F}}", "\\frac{y}{1-F}"];
	var pm=[-1, 1, 1, -1];
	var ldt=["\\frac{A}{y\\sqrt{1-F}}", "\\frac{A}{y(1+F)}", "\\frac{A}{y\\sqrt{1+F}}", "\\frac{A}{y(1-F)}"];
	var pdt=["\\frac{y}{\\sqrt{F}}", "\\frac{y}{F}", "\\frac{y}{\\sqrt{F}}", "\\frac{y}{F}"];
	var which=rand(0, 2);
	var what=rand(0, 3);
	if(what===0 && which===2)
	{
		which=rand(0, 1); // It's easier this way, no worrying about "when do solns exist"
	}
	var a=randnz(4);
	var qString="Find $$\\int";
	// special cases: polys and ln
	if(which===0)
	{
		qString+=ldt[what].replace(/y/g, 'x').replace(/F/g, fsq[which].replace(/A/g, ascoeff(a))).replace(/z/g, 'x').replace(/A/g, a);
	}
	else if(which===2)
	{
		var r=polyexpand(p, p);
		r.xthru(pm[what]);
		r[0]++;
		qString+=pdt[what].replace(/y/g, difs[which]).replace(/F/g, r.rwrite('z')).replace(/z/g, 'x');
	}
	else
	{
		qString+=dt[what].replace(/y/g, difs[which]).replace(/F/g, fsq[which]).replace(/z/g, 'x').replace("2A", ascoeff(2*a)).replace(/A/g, ascoeff(a));
	}
	qString += "\\,\\mathrm{d}x$$";
	var aString="$$"+t[what].replace(/f/g, fns[which]).replace(/z/g, 'x').replace(/A/g, ascoeff(a))+"+c$$";
	var qa=[qString,aString];
	return qa;
}

/* Note: Important not to let things become negative.  Can't just apply an abs() here and there, because areas of integrals might cancel out */
function makeRevolution()
{
	function makeSolidRevolution()
	{
		var fns=["\\sec(z)", "\\csc(z)", "\\sqrt{z}"];
		var iss=["\\tan(z)", "-\\cot(z)", 0];
		var isf=[Math.tan, function(x){return -1/Math.tan(x);}, function(x){return Math.pow(x, 2)/2;}];
		var which=rand(0, 2);
		var x0=0;if(which===1){x0++;}
		var x=rand(x0+1, x0+((which===2)?4:1));
		var qString="Find the volume of the solid formed when the area under";
		qString+="$$y = "+fns[which].replace(/z/g, 'x')+"$$";
		qString+="from \\(x = "+x0+"\\mbox{ to }x = "+x+"\\) is rotated through \\(2\\pi\\) around the x-axis.";
		var ans;
		if(which===2)
		{
			ans=guessExact(isf[which](x)-isf[which](x0));
		}
		else
		{
			ans="\\left("+iss[which].replace(/z/g, x)+(isf[which](x0)===0?"":"-"+iss[which].replace(/z/g, x0))+"\\right)";
			ans=ans.replace(/--/g, "+");
		}
		var aString="$$"+ans+"\\pi$$";
		var qa=[qString,aString];
		return(qa);
	}
	function makeSurfaceRevolution()
	{
		var a=new poly(rand(1, 3));
		a.setrand(6);
		for(var i=0;i<=a.rank;i++)
		{
			a[i]=Math.abs(a[i]);
		}
		var b=new fpoly(3);
		b.setpoly(a);
		var c=new fpoly(4);
		b.integ(c);

		var x=rand(1, 4);

		var qString="Find the area of the surface formed when the curve";
		qString+="$$y = "+a.write('x')+"$$";
		qString+="from \\(x = 0\\mbox{ to }x = "+x+"\\) is rotated through \\(2\\pi\\) around the x-axis.";
		var hi=c.compute(x); // lo is going to be 0 since our lower limit on the integral is 0, and the antiderivs are polys with no (or arb) constant term
		var ans=new frac(hi.top, hi.bot);
		ans.prod(2);
		var aString="$$" + fcoeff(ans, "\\pi") + "$$";
		var qa=[qString,aString];
		return(qa);
	}
	var qa;
	if(rand())
	{
		qa=makeSolidRevolution();
	}
	else
	{
		qa=makeSurfaceRevolution();
	}
	return qa;
}

function makeMatXforms()
{
	var a=rand(0, 2);
	var xfms=new Array(5);
	for(var i=0;i<5;i++) {xfms[i]=new fmatrix(2);}
	var cosines = [new frac(0), new frac(-1), new frac(0)];
	var sines = [new frac(1), new frac(0), new frac(-1)];
  var acosines = [new frac(0), new frac(1), new frac(0)];
  var asines = [new frac(-1), new frac(0), new frac(1)];
	xfms[0].set(cosines[a], asines[a], sines[a], cosines[a]); // first sin is -1
	xfms[1].set(cosines[a], sines[a], sines[a], acosines[a]); // second cos is -1
	xfms[2].set(1, a + 1, 0, 1);
	xfms[3].set(1, 0, a + 1, 1);
	xfms[4].set(a+2, 0, 0, a+2);
	var f=new frac(a+1, 2);
	var xft=[
    "a rotation through \\("+fcoeff(f, "\\pi")+"\\) anticlockwise about O",
    "a reflection in the line \\("+["y=x","x=0","y=-x"][a]+"\\)",
    "a shear of element \\("+(a+1)+", x\\) axis invariant",
    "a shear of element \\("+(a+1)+", y\\) axis invariant",
    "an enlargement of scale factor \\("+(a+1)+"\\)"];
	var which=distrand(2, 0, 4);
	var qString="Compute the matrix representing, in 2D, "+xft[which[0]]+" followed by "+xft[which[1]]+".";
	var ans=xfms[which[1]].times(xfms[which[0]]);
	var aString="$$"+ans.write()+"$$";
	var qa=[qString,aString];
	return(qa);
}

/****************************\
|*	START OF STATS MATERIAL	*|
\****************************/

function makeDiscreteDistn()
{
	//var nparms=[2, 1, 1];
	var massfn=[massBin, massPo, massGeo];
	var pd=rand(2, 6);
	var pn=rand(1, pd-1);
	var f=new frac(pn, pd);
	var p=pn/pd;
	var parms=[[rand(5, 12), p], [rand(1, 5)], [p]];
	var dists=['{\\rm B}\\left('+parms[0][0]+', '+f.write()+'\\right)','{\\rm Po}('+parms[1][0]+')','{\\rm Geo}\\left('+f.write()+'\\right)'];
	var x=rand(1, 4);
	var which=rand(0, 2);
	var leq=rand();
	var qString="The random variable \\(X\\) is distributed as$$"+dists[which]+".$$  Find \\(\\mathbb{P}(X"+(leq?"\\le":"=")+x+")\\)";
	var ans;
	if(leq)
	{
		ans=0;
		for(var i=0;i<=x;i++)
		{
			ans+=massfn[which](i, parms[which][0], parms[which][1]);
		}
	}
	else
	{
		ans=massfn[which](x, parms[which][0], parms[which][1]);
	}
	var aString="$$"+ans.toFixed(6)+"$$";
	var qa=[qString,aString];
	return(qa);
}

function makeContinDistn()
{
	tableN.populate();
	var mu=rand(0, 4);
	var sigma=rand(1, 4);
	// like toFixed(1) but always rounding downwards
	var x = Math.floor(Math.random() * 3 * sigma * 10) / 10;
	// x is /slightly/ nonuniform because -0 = 0,
	// but it's not a perceptible effect in general
	if(rand())
		x *= -1;
	x += mu;
	var qString="The random variable \\(X\\) is normally distributed with mean \\("+mu+"\\) and variance \\("+sigma*sigma+"\\).";
	qString+="<br />Find \\(\\mathbb{P}(X\\le"+x+")\\)";
	var z=(x-mu)/sigma;
	var index = Math.floor(1e3*Math.abs(z));
	if(index < 0 || index >= tableN.values.length)
		throw new Error('makeContinDistn: index ' + index + ' out of range\n' + 'x: ' + x);
	var p=tableN.values[index];
	if(z<0) {p=1-p;}
	var aString="$$"+p.toFixed(3)+"$$";
	var qa=[qString,aString];
	return(qa);
}

function makeHypTest()
{
	var mu, sigma, n, which, sl, Sx, xbar, p, critdev, acc, qString, aString, qa;
	if(rand())
	{
		mu=new Array(2); // 0 = H-null, 1 = actual
		sigma=new Array(2);
		which=0; // 0: =.  1: <.  2: >.
		n=rand(8, 12);
		sl=pickrand(1, 5, 10);
		if(rand())
		{
			mu[1]=mu[0]=rand(-1, 5);
			sigma[1]=sigma[0]=rand(1, 4);
			which=rand(0, 2);
		}
		else
		{
			mu=distrand(2, -1, 5);
			sigma[0]=rand(1, 4);
			sigma[1]=rand(1, 4);
			which=rand()?(mu[0]<mu[1]?2:1):0;
		}
		Sx=genN(mu[1]*n, sigma[1]*Math.sqrt(n));
		qString="In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = "+mu[0]+"\\mbox{, }\\sigma^2 = "+sigma[0]*sigma[0]+"\\). ";
		qString+="The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu"+['\\ne','<','>'][which]+mu[0]+"\\). ";
		qString+="The significance level is \\("+sl+"\\%\\). ";
		qString+="A sample of size \\("+n+"\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = "+Sx.toFixed(3)+"\\).<br />";

		qString+="<br />Compute: <ul class=\"exercise\">";
		qString += "<li>\\(\\overline{x}\\)</li>";
		qString += "<li> Is \\({\\rm H}_0\\) accepted?}</li>";
		qString += "</ul>";

		xbar=Sx/n;
		aString = "<ul class=\"exercise\">";
		aString += "<li>\\(\\overline{x} = "+xbar.toFixed(3) +"\\)</li>";
		p=0;
		if(which) // one tail
		{
			switch(sl)
			{
				case 1:
					p=4;
				break;
				case 5:
					p=2;
				break;
				case 10:
					p=1;
				break;
			}
		}
		else // two tail
		{
			switch(sl)
			{
				case 1:
					p=5;
				break;
				case 5:
					p=3;
				break;
				case 10:
					p=2;
				break;
			}
		}
		critdev=sigma[0]*tableT.values[tableT.values.length-1][p]/Math.sqrt(n);
		if(which)
		{
			aString+="<li>The critical region is $$\\overline{x}"+(which===1?"<"+(mu[0]-critdev).toFixed(3):">"+(mu[0]+critdev).toFixed(3))+"$$<br />";
		}
		else
		{
			aString+="<li>The critical values are $$"+(mu[0]-critdev).toFixed(3)+"\\) and \\("+(mu[0]+critdev).toFixed(3)+"$$<br />";
		}
		acc=false;
		switch(which)
		{
			case 0:
				acc=(xbar>=mu[0]-critdev)&&(xbar<=mu[0]+critdev);
			break;
			case 1:
				acc=(xbar>=mu[0]-critdev);
			break;
			case 2:
				acc=(xbar<=mu[0]+critdev);
			break;
		}
		aString+=acc?"\\(\\rm H}_0\\) is accepted.</li>":"\\(\\rm H}_0\\) is rejected.</li>";
		aString += "</ul>";
		qa=[qString,aString];
		return(qa);
	}
	else
	{
		mu=new Array(2); // 0 = H-null, 1 = actual
		which=0; // 0: =.  1: <.  2: >.
		n=rand(10, 25);
		sl=pickrand(1, 5, 10);
		if(rand())
		{
			mu[1]=mu[0]=rand(-1, 5);
			sigma=rand(1, 4);
			which=rand(0, 2);
		}
		else
		{
			mu=distrand(2, -1, 5);
			sigma=rand(1, 4);
			which=rand()?(mu[0]<mu[1]?2:1):0;
		}
		Sx=0;
		var Sxx=0;
		for(var i=0;i<n;i++)
		{
			var xi=genN(mu[1], sigma);
			Sx+=xi;
			Sxx+=(xi*xi);
		}
		qString = "In a hypothesis test, the null hypothesis \\({\\rm H}_0\\) is that \\(X\\) is normally distributed, with \\(\\mu = "+mu[0]+"\\). ";
		qString += "The alternative hypothesis \\({\\rm H}_1\\) is that \\(\\mu"+['\\ne','<','>'][which]+mu[0]+"\\). ";
		qString += "The significance level is \\("+sl+"\\%\\). ";
		qString += "A sample of size \\("+n+"\\) is drawn from \\(X\\), and its sum \\(\\sum{x} = "+Sx.toFixed(3)+"\\). ";
		qString += "The sum of squares, \\(\\sum{x^2} = "+Sxx.toFixed(3)+"\\). ";

		qString += "Compute: <ul class=\"exercise\">";
		qString += "<li>\\(\\overline{x}\\)</li>";
		qString += "<li>Compute an estimate, \\(S^2\\), of the variance of \\(X\\)</li>";
		qString += "<li>Is \\({\\rm H}_0\\) accepted?</li>";
		qString += "</ul>";
		xbar=Sx/n;
		aString = "<ul class=\"exercise\">";
		aString="<li>\\(\\overline{x} = "+xbar.toFixed(3)+"\\)</li>";
		var SS=(Sxx-Sx*Sx/n)/(n-1);
		aString+="<li>\\(S^2 = "+SS.toFixed(3)+"\\). ";
		aString+="Under \\({\\rm H}_0\\), \\({\\frac{\\overline{X}"+(mu[0]?(mu[0]>0?"-":"+")+Math.abs(mu[0]):"")+"}{"+Math.sqrt(SS/n).toFixed(3)+"}}\\sim t_{"+(n-1)+"}\\)</li>";
		p=0;
		if(which) // one tail
		{
			switch(sl)
			{
				case 1:
					p=4;
				break;
				case 5:
					p=2;
				break;
				case 10:
					p=1;
				break;
			}
		}
		else // two tail
		{
			switch(sl)
			{
				case 1:
					p=5;
				break;
				case 5:
					p=3;
				break;
				case 10:
					p=2;
				break;
			}
		}
		critdev=Math.sqrt(SS)*tableT.values[n-2][p]/Math.sqrt(n);
		if(which)
		{
			aString+="<li>The critical region is \\(\\overline{x}"+(which===1?"<"+(mu[0]-critdev).toFixed(3):">"+(mu[0]+critdev).toFixed(3))+"\\); </br />";
		}
		else
		{
			aString+="<li>The critical values are \\("+(mu[0]-critdev).toFixed(3)+"\\) and \\("+(mu[0]+critdev).toFixed(3)+"\\); <br />";
		}
		acc=false;
		switch(which)
		{
			case 0:
				acc=(xbar>=mu[0]-critdev)&&(xbar<=mu[0]+critdev);
			break;
			case 1:
				acc=(xbar>=mu[0]-critdev);
			break;
			case 2:
				acc=(xbar<=mu[0]+critdev);
			break;
		}
		aString+=acc?"\\({\\rm H}_0\\) is accepted.</li>":"\\({\\rm H}_0\\) is rejected.</li>";
		aString+="</ul>";
		qa=[qString,aString];
		return(qa);
	}
}

function makeConfidInt()
{
	var mu=rand(4);
	var sigma=rand(1, 4);
	var n=2*rand(6, 10);
	var sl=pickrand(99, 95, 90);
	var Sx=0;
	var Sxx=0;
	for(var i=0;i<n;i++)
	{
		var xi=genN(mu, sigma);
		Sx+=xi;
		Sxx+=(xi*xi);
	}
	var qString="The random variable \\(X\\) has a normal distribution with unknown parameters. ";
	qString+="A sample of size \\("+n+"\\) is taken for which $$\\sum{x}="+Sx.toFixed(3)+"$$$$\\mbox{and}\\sum{x^2}="+Sxx.toFixed(3)+".$$";
	qString+="Compute, to 3 DP., a \\("+sl+"\\)% confidence interval for the mean of \\(X\\).<br />";
	var xbar=Sx/n;
	var SS=(Sxx-Sx*Sx/n)/(n-1);
	var p;
	switch(sl)
	{
		case 99:
			p=5;
		break;
		case 95:
			p=3;
		break;
		case 90:
			p=2;
		break;
	}
	var critdev=Math.sqrt(SS/n)*tableT.values[n-2][p];
	var aString="$$["+(xbar-critdev).toFixed(3)+", "+(xbar+critdev).toFixed(3)+"]$$";
	var qa=[qString,aString];
	return(qa);
}

// TODO: Fix the occasional bug with nu<1 (but how?) and find out why that crow is sometimes undefined
function makeChiSquare()
{
	tableN.populate();
	var parms=[[rand(10,18)*2, rand(20, 80)/100], [rand(4, 12)], [rand(10, 30)/100], [rand(4, 10), rand(2, 4)]];
	var distns=["binomial", "Poisson", "geometric", "normal"];
	var parmnames=[["n", "p"], ["\\lambda"], ["p"], ["\\mu", "\\sigma"]];
	var nparms=[2, 1, 1, 2];
	var massfn=[massBin, massPo, massGeo, massN];
	var genfn=[genBin, genPo, genGeo, genN];
	var which=rand(0, 3);
	var n=5*rand(10, 15);
	var sl=pickrand(90, 95, 99);
	var qString="The random variable \\(X\\) is modelled by a <i>"+distns[which]+"</i> distribution. ";
	qString+="A sample of size \\("+n+"\\) is drawn from \\(X\\) with the following grouped frequency data. ";
	var sample=[],min=1e3,max=0;
	var i;
	for(i=0;i<n;i++)
	{
		sample[i]=genfn[which](parms[which][0], parms[which][1]); // excess parms get discarded, so it doesn't matter that they're undefined
		min=Math.min(min, sample[i]);
		max=Math.max(max, sample[i]);
	}
	min=Math.floor(min);
	max=Math.ceil(max);
	var freq=[];
	for(i=0;i<Math.ceil((max+1-min)/2);i++)
	{
		freq[i]=0;
	}
	for(i=0;i<n;i++)
	{
		var y=Math.floor((sample[i]-min)/2);
		freq[y]++;
	}
	qString += "<div style=\"font-size: 80%;\">$$\\begin{array}{c|r}x&\\mbox{Frequency}\\\\";
	var x;
	var Sx=0, Sxx=0;
	for(i=0;i<Math.ceil((max+1-min)/2);i++)
	{
		x=min+(i*2);
		Sx+=(x+1)*freq[i];
		Sxx+=(x+1)*(x+1)*freq[i];
		if(i==0)
		{
			qString+="x < "+(x+2);
		}
		else if(i==Math.ceil((max-1-min)/2))
		{
			qString+=x+"\\le x";
		}
		else
		{
			qString+=x+"\\le x <"+(x+2);
		}
		qString+="&"+freq[i]+"\\\\";
	}
	qString += "\\end{array}$$</div>";
	qString += "<ul class=\"exercise\">";
	qString += "<li>Estimate the parameters of the distribution.</li>";
	qString += "<li>Use a \\(\\chi^2\\) test, with a significance level of \\("+sl+"\\)%, to test this hypothesis.</li>";
	qString += "</ul>";
	var p;
	switch(sl)
	{
		case 90:
			p=3;
		break;
		case 95:
			p=4;
		break;
		case 99:
			p=6;
		break;
	}
	var xbar=Sx/n;
	var SS=(Sxx-Sx*Sx/n)/(n-1);
	var hypparms=[0,0];
	var aString = "<ol class=\"exercise\">";

	// calculate parameters
	switch(which)
	{
		case 0: // B(n, p) => E=np, Var=npq => p=1-(Var/E), n=E/p
			hypparms[1]=1-(SS/xbar);
			hypparms[0]=Math.round(xbar/hypparms[1]);
		break;
		case 1: // Po(l) => E=Var=l
			hypparms[0]=xbar;
		break;
		case 2: // Geo(p) => E=1/p
			hypparms[0]=1/xbar;
		break;
		case 3: // N(m, s^2)
			hypparms[0]=xbar;
			hypparms[1]=Math.sqrt(SS);
		break;
	}

	// binomial
	if(which===0)
	{
		aString += "<li>$$" +
			parmnames[which][0] + "=" + hypparms[0].toString() + ", " +
			parmnames[which][1] + "=" + hypparms[1].toFixed(3) + ".$$</li>";

		// n < 1 is nonsensical
		// this happened quite often when part of the question was
		// checking if we were choosing the right model,
		// but is now *very* unlikely.
		if(hypparms[0] < 1)
		{
			aString += "</ol>";
			aString += "<p>The binomial model cannot fit these data</p>";
			return [qString, aString];
		}
	}
	else
	{
		aString += "<li>$$" + parmnames[which][0] + "=" + hypparms[0].toFixed(3);
		if(nparms[which]===2)
		{
			aString += ", " + parmnames[which][1] + "=" +
				hypparms[1].toFixed(3);
		}
		aString += ".$$</li>";
	}

	// We include the ii. list item here but don't actually put the
	// answer text in it, because it's too wide.
	aString += "<li></li></ol>";

	// The whole "combining rows" thing is going to be hard :S
	var nrows=Math.ceil((max+1-min)/2);
	var row=[]; // [Xl, Xh, O, E, ((O-E)^2)/E]
	for(i=0;i<nrows;i++)
	{
		x=min+(i*2);
		row[i]=[x, x+2, freq[i], 0, 0];
		if(which===3) // N is continuous (and can't be integrated either), needs special handling (use tableN)
		{
			var zh=(x+2-hypparms[0])/hypparms[1];
			var zl=(x-hypparms[0])/hypparms[1];
			var ph=Math.abs(zh)<3?(zh>=0)?tableN.values[Math.floor(zh*1000)]:1-tableN.values[Math.floor(-zh*1000)]:(zh>0?1:0);
			var pl=Math.abs(zl)<3?(zl>=0)?tableN.values[Math.floor(zl*1000)]:1-tableN.values[Math.floor(-zl*1000)]:(zl>0?1:0);
			if(i===0) {pl=0;}
			if(i===nrows-1) {ph=1;}
			row[i][3]=(ph-pl)*n;
		}
		else
		{
			for(var j=(i===0?0:x);j<(i===nrows-1?x+100:x+2);j++) // not perfect, we're assuming the tail after 100 is essentially flat zero
			{
				row[i][3]+=massfn[which](j, hypparms[0], hypparms[1])*n;
			}
		}
	}
	var row2=[];
	var chisq=0;
	var currow=[0, 0, 0, 0, 0];
	for(i=0;i<nrows;i++)
	{
		currow[1]=row[i][1];
		currow[2]+=row[i][2];
		currow[3]+=row[i][3];
		if(currow[3]>=5)
		{
			currow[4]=Math.pow(currow[2]-currow[3], 2)/currow[3];
			row2.push(currow);
			chisq+=currow[4];
			currow=[currow[1], currow[1], 0, 0, 0];
		}
	}
	var crow=row2.length?row2.pop():[0, 0, 0, 0, 0];
	crow[1]=currow[1];
	crow[2]+=currow[2];
	crow[3]+=currow[3];
	chisq-=crow[4];
	crow[4]=Math.pow(crow[2]-crow[3], 2)/crow[3];
	row2.push(crow);
	chisq+=crow[4];
	aString+="<div style=\"font-size: 80%;\">$$\\begin{array}{c||r|r|r}";
	aString+="x&O_i&E_i&\\frac{(O_i-E_i)^2}{E_i}\\\\";
	for(i=0;i<row2.length;i++)
	{
		if(i===0)
		{
			aString+="x < "+row2[i][1];
		}
		else if(i===row2.length-1)
		{
			aString+=row2[i][0]+"\\le x";
		}
		else
		{
			aString+=row2[i][0]+"\\le x <"+row2[i][1];
		}
		aString+="&"+row2[i][2]+"&"+row2[i][3].toFixed(3)+"&"+row2[i][4].toFixed(3)+"\\\\";
	}
	aString+="\\end{array}$$</div>";
	aString+="$$\\chi^2 = "+chisq.toFixed(3)+"$$";
	var nu=row2.length-1-nparms[which];
	aString+="$$\\nu = "+nu+"$$";
	if(nu<1)
		throw new Error("makeChiSquare: nu < 1!" +
			"\n\twhich:" + which +
			"\n\trow2.length:" + row2.length);
	var critval=tableChi.values[nu-1][p];
	aString+="Critical region: \\(\\chi^2 >"+critval+"\\)<br />";
	if(chisq>critval)
	{
		aString+="The hypothesis is rejected.";
	}
	else
	{
		aString+="The hypothesis is accepted.";
	}
	var qa=[qString,aString];
	return(qa);
}

function makeProductMoment()
{
	var n=rand(6, 12);
	var mu=[rand(4), rand(4)];
	var sigma=[rand(1, 6), rand(1, 6)];
	var x=[];
	var i;
	for(i=0;i<n;i++)
	{
		x[i]=[];
		x[i][0]=genN(mu[0], sigma[0]);
		x[i][1]=genN(mu[1], sigma[1]);
	}
	var Ex=0,Exx=0,Exy=0,Eyy=0,Ey=0; // Here E represents sigma
	var qString="For the following data,";
	qString += "<ul class=\"exercise\">";
	qString += "<li>compute the product moment correlation coefficient, \\({\\bf r}\\)</li>";
	qString+="<li>find the regression line of \\(y\\) on \\(x\\)$$\\begin{array}{c|c}x&y\\\\";
	for(i=0;i<n;i++)
	{
		qString+=x[i][0].toFixed(3)+"&"+x[i][1].toFixed(3)+"\\\\";
		Ex+=x[i][0];
		Exx+=x[i][0]*x[i][0];
		Exy+=x[i][0]*x[i][1];
		Eyy+=x[i][1]*x[i][1];
		Ey+=x[i][1];
	}
	qString+="\\end{array}$$</li></ul>";
	var xbar=Ex/n, ybar=Ey/n;
	var Sxx=Exx-Ex*xbar, Syy=Eyy-Ey*ybar;
	var Sxy=Exy-(Ex*Ey/n);
	var r=Sxy/Math.sqrt(Sxx*Syy);
	var b=Sxy/Sxx;
	var a=ybar-(b*xbar);
	var aString = "<ul class=\"exercise\">";
	aString += "<li>\\({\\bf r}="+r.toFixed(3)+"\\)</li><li>\\(y="+b.toFixed(3)+"x"+(a>0?"+":"")+a.toFixed(3)+"\\).";
	var qa=[qString,aString];
	return(qa);
}

// guesses the exact representation of a floating-point variable.
// TODO: make it compute a load of guesses, and weight each one's closeness by likelihood, 
// and pick the best.
// ADVISE-AVOID: At the moment it occasionally fails to guess the right thing at all, 
// and sometimes guesses something else first
// Two versions, one is commented out.
/*function guessExact(x)
{
	var n=proxInt(x)
	if(n[0])
		return(n[1]);
	var fac=1;
	for(var s=1;s<=6;s++)
	{
		fac*=s;
		var d=fac*12;
		n=proxInt(x*d);
		if(n[0])
		{
			var f=new frac(n[1], d);
			f.reduce();
			return(f.write());
		}
		var t=Math.pow(2, s);
		for(var i=-t;i<=t;i++)
		{
			for(var j=-t;j<=t;j++)
			{
				for(var k=1;k<=s;k++)
				{
					var p=(x-(i/j))*k;
					n=proxInt(p*p);
					if(n[0] && (n[1]>1))
					{
						var f=new frac(i, j);
						f.reduce();
						var v=new sqroot(n[1]); // v.a*root(v.n)
						var g=new frac(v.a, k);
						g.reduce();
						return(f.write()+(g.top>0?" + ":" - ")+fbcoeff(g, "\\sqrt{"+v.n+"}"));
					}
					var p=(x+(i/j))*k;
					n=proxInt(p*p);
					if(n[0] && (n[1]>1))
					{
						var f=new frac(i, j);
						f.reduce();
						var v=new sqroot(n[1]); // v.a*root(v.n)
						var g=new frac(v.a, k);
						g.reduce();
						return("-"+f.write()+(g.top>0?" + ":" - ")+fbcoeff(g, "\\sqrt{"+v.n+"}"));
					}
				}
			}
		}
	}
	return(x);
}
*/
function guessExact(x)
{
	var n=proxInt(x);
	if(n[0])
		return(n[1]);
	for(var s=1;s<18;s++)
	{
		for(var i=2;i<=(3+2*s);i++)
		{
			n=proxInt(x*i);
			if(n[0])
			{
				var top=n[1];
				var bot=i;
				var c=gcd(top, bot);
				top/=c;
				bot/=c;
				return((x<0?"-":"")+"\\frac{"+Math.abs(top)+"}{"+bot+"}");
			}
		}
		n=proxInt(Math.pow(x, 2));
		if(n[0] && (n[1]<s*10))
		{
			var v=new sqroot(n[1]);
			return((x<0?"-":"")+v.write());
		}
		for(i=2;i<(2+s);i++)
		{
			n=proxInt(Math.pow(x*i, 2));
			if(n[0] && (n[1]<s*10))
			{
				v=new sqroot(n[1]);
				return((x<0?"-":"")+"\\frac{"+v.write()+"}{"+i+"}");
			}
		}
		for(var j=1;j<1+(3*s);j++)
		{
			n=proxInt(Math.pow(x-j, 2));
			if(n[0] && (n[1]<s*10))
			{
				v=new sqroot(n[1]);
				return("\\left\("+j+((x-j)<0?"-":"+")+v.write()+"\\right)");
			}
			n=proxInt(Math.pow(x+j, 2));
			if(n[0] && (n[1]<s*10))
			{
				v=new sqroot(n[1]);
				return("\\left(-"+j+((x+j)<0?"-":"+")+v.write()+"\\right)");
			}
		}
		for(var k=2;k<=(2+(2*s));k++)
		{
			for(j=1;j<(2+(2*s));j++)
			{
				n=proxInt(Math.pow((x-(j/k)), 2));
				if(n[0] && (n[1]<s*10))
				{
					v=new sqroot(n[1]);
					return("\\left\(\\frac{"+j+"}{"+k+"}"+((x-(j/k))<0?"-":"+")+v.write()+"\\right)");
				}
				n=proxInt(Math.pow((x+(j/k)), 2));
				if(n[0] && (n[1]<s*10))
				{
					v=new sqroot(n[1]);
					return("\\left(-\\frac{"+j+"}{"+k+"}"+((x+(j/k))<0?"-":"+")+v.write()+"\\right)");
				}
			}
		}
		for(i=2;i<s;i++)
		{
			for(j=1;j<3+(2*s);j++)
			{
				n=proxInt(Math.pow((x-j)*i, 2));
				if(n[0] && (n[1]<s*10))
				{
					v=new sqroot(n[1]);
					return("\\left\("+j+((x-j)<0?"-":"+")+"\\frac{"+v.write()+"}{"+i+"}\\right)");
				}
				n=proxInt(Math.pow((x+j)*i, 2));
				if(n[0] && (n[1]<s*10))
				{
					v=new sqroot(n[1]);
					return("\\left(-"+j+((x+j)<0?"-":"+")+"\\frac{"+v.write()+"}{"+i+"}\\right)");
				}
			}
		}
		for(i=2;i<s;i++)
		{
			for(k=2;k<2+(2*s);k++)
			{
				for(j=1;j<1+(2*s);j++)
				{
					n=proxInt(Math.pow((x-(j/k))*i, 2));
					if((n[0] && (n[1]<s*10)) && (Math.sqrt(n[1])!=Math.floor(Math.sqrt(n[1]))))
					{
						v=new sqroot(n[1]);
						return("\\left\(\\frac{"+j+"}{"+k+"}"+((x-(j/k))<0?"-":"+")+"\\frac{"+v.write()+"}{"+i+"}\\right)");
					}
					n=proxInt(Math.pow((x+(j/k))*i, 2));
					if((n[0] && (n[1]<s*10)) && (Math.sqrt(n[1])!=Math.floor(Math.sqrt(n[1]))))
					{
						v=new sqroot(n[1]);
						return("\\left(-\\frac{"+j+"}{"+k+"}"+((x+(j/k))<0?"+":"-")+"\\frac{"+v.write()+"}{"+i+"}\\right)");
					}
				}
			}
		}
	}
	return(x);
}

function proxInt(x)
{
	var n=Math.round(x);
	if(Math.abs(n-x)<((Math.abs(x)+0.5)*1e-8))
		return([true, n]);
	return([false]);
}

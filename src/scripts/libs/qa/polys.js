/*
	polys.js - polynomials
*/

// Write a number as a coefficient (1 disappears, -1 becomes -)
function ascoeff(a)
{
	if(a==1)
		return("");
	if(a==-1)
		return("-");
	return(a);
}

// Write a number as a |coefficient| (+-1 disappears)
function abscoeff(a)
{
	a=Math.abs(a);
	if(a==1)
		return("");
	return(a);
}

// Express a list of polynomial factors (x+a[0])(x+a[1])...
function express(a)
{
	var r="";
	var n=a.length;
	var p=ranking(a);
	var q;
	var t=0;
	var s=new poly(1);
	s[1]=1;
	for(var i=0;i<n;i++)
	{
		if(i && a[p[i]]==q)
		{
			t++;
		}
		else
		{
			if(t)
				r+="^"+(t+1);
			t=0;
			s[0]=a[p[i]];
			r+='('+s.write()+')';
			q=a[p[i]];
		}
	}
	if(t)
		r+="^"+(t+1);
	return(r);
}

function polyexpand(a, b)
{
	var p=new poly(a.rank+b.rank);
	p.setrand(0); // set all entries to 0
	for(var i=0;i<=a.rank;i++)
	{
		for(var j=0;j<=b.rank;j++)
		{
			p[i+j]+=a[i]*b[j];
		}
	}
	return p;
}

function p_quadratic(a, b, c)
{
	var p=new poly(2);
	p.set(c, b, a);
	return p; // = ax^2 + bx + c
}

function p_linear(a, b)
{
	var p=new poly(1);
	p.set(b, a);
	return p; // = ax + b
}

function p_const(a)
{
	var p=new poly(0);
	p.set(a);
	return p; // = a
}

// polynomial (over Z) object: can be set manually or randomly, nonzero terms counted, computed at an x value, multiplied by a constant, differentiated, write it in latex, used in several other functions
// REMEMBER: it's stored backwards (x^0 term first)
function poly(rank)
{
	var that = this;
	
	that.rank=rank;
	that.terms=function()
	{
		var n=0;
		for(var i=0;i<=this.rank;i++) {
			if(this[i]) {
				n++;
			}
		}
		return n;
	};
	
	that.set=function()
	{
		that.rank=that.set.arguments.length-1;
		for(var i=0;i<=that.rank;i++) that[i]=that.set.arguments[i];
	};
	
	that.setrand=function(maxentry)
	{
		for(var i=0;i<=that.rank;i++) that[i]=Math.round(-maxentry+2*maxentry*Math.random());
		if(that[that.rank]==0) that[that.rank]=maxentry;
	};
	
	that.compute=function(x)
	{
		var y=0;
		for(var i=0;i<=that.rank;i++) y+=that[i]*Math.pow(x, i);
		return y;
	};
	
	that.gcd=function()
	{
		var a=that[that.rank];
		for(var i=0;i<that.rank;i++) a=gcd(a, that[i]);
		return a;
	};
	
	that.xthru=function(x)
	{
		for(var i=0;i<=that.rank;i++)
		{
			that[i]=(that[i]*x);
		}
	};
	
	that.addp=function(x)
	{
		for(var i=0;i<=that.rank;i++)
		{
			that[i]=that[i]+x[i];
		}
	};
	
	that.diff=function(d)
	{
		d.rank=rank-1;
		for(var i=0;i<that.rank;i++) d[i]=that[i+1]*(i+1);
	};
	
	that.integ=function(d)
	{
		d.rank=rank+1;
		for(var i=0;i<that.rank;i++) d[i+1]=that[i]/(i+1);
	};
	
	that.write=function(l) // l is the letter (or string) for the independent variable.  If not given, defaults to x
	{
		if(typeof(l)=='undefined')
		{
			l='x';
		}
		var q="";
		var j=false;
		for(var i=that.rank;i>=0;i--)
		{
			if(that[i]<0)
			{
				if(j) q+=' ';
				q+='- ';
				j=false;
			}
			else if(j&&that[i])
			{
				q+=' + ';
				j=false;
			}
			if(that[i])
			{
				switch(i)
				{
					case 0:
						q+=Math.abs(that[i]); j=true;
					break;
					case 1:
						if(Math.abs(that[i])==1)
							q+=l;
						else
							q+=Math.abs(that[i])+l;
						j=true;
					break;
					default:
						if(Math.abs(that[i])==1)
							q+=l+'^'+i;
						else
							q+=Math.abs(that[i])+l+'^'+i;
						j=true;
					break;
				}
			}
		}
		return q;
	};
	
	that.rwrite=function(l)
	{
		if(typeof(l)=='undefined')
		{
			l='x';
		}
		var q="";
		var j=false;
		for(var i=0;i<=that.rank;i++)
		{
			if(that[i]<0)
			{
				if(j) q+=' ';
				q+='- ';
				j=false;
			}
			else if(j&&that[i])
			{
				q+=' + ';
				j=false;
			}
			if(that[i])
			{
				switch(i)
				{
					case 0:
						q+=Math.abs(that[i]); j=true;
					break;
					case 1:
						if(Math.abs(that[i])==1)
							q+=l;
						else
							q+=Math.abs(that[i])+l;
						j=true;
					break;
					default:
						if(Math.abs(that[i])==1)
							q+=l+'^'+i;
						else
							q+=Math.abs(that[i])+l+'^'+i;
						j=true;
					break;
				}
			}
		}
		return q;
	};
	
	/*
	that.gerwrite=function(l)
	{
		if(typeof(l)=='undefined')
		{
			l='x';
		}
		var q="";
		var j=false;
		for(var i=0;i<=that.rank;i++)
		{
			c=guessExact(that[i]);
			ac=guessExact(Math.abs(that[i]));
			if(that[i]<0)
			{
				if(j) q+=' ';
				q+='- ';
				j=false;
			}
			else if(j&&that[i])
			{
				q+=' + ';
				j=false;
			}
			if(that[i])
			{
				switch(i)
				{
					case 0:
						q+=ac; j=true;
					break;
					case 1:
						if(ac==1)
							q+=l;
						else
							q+=ac+l;
						j=true;
					break;
					default:
						if(ac==1)
							q+=l+'^'+i;
						else
							q+=ac+l+'^'+i;
						j=true;
					break;
				}
			}
		}
		return q;
	}
	*/
}

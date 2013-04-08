
var Complex = new complex; // prototypical Complex object that lets us get the methods

// complex number object: set or get it in Re/Im or r/theta, write it in LaTeX
function complex(Re, Im)
{
	var that = this;
	that.Re=Re;
	that.Im=Im;
	that.set=function(Re, Im)
	{
		that.Re=Re;
		that.Im=Im;
		return(that);
	};
	that.ptoc=function(Mod, Arg)
	{
		var z=new complex;
		z.Re=Mod*Math.cos(Arg);
		z.Im=Mod*Math.sin(Arg);
		return(z);
	};
	that.random=function(maxentry, rad)
	{
		var z=new complex;
		z=Complex.ptoc(rand(0, maxentry), Math.PI*rand(0, rad*2)/rad);
		return(z);
	};
	that.randnz=function(maxentry, rad)
	{
		var z=new complex;
		z=Complex.ptoc(rand(1, maxentry), Math.PI*rand(0, rad*2)/rad);
		return(z);
	};
	that.ctop=function(z)
	{
		if(typeof(z)=='undefined')
			z=that;
		var Mod=Math.sqrt(Math.pow(z.Re, 2)+Math.pow(z.Im, 2));
		var Arg=Math.atan2(z.Im, z.Re);
		return([Mod, Arg]);
	};
	that.isnull=function() {return !(that.Re||that.Im);};
	that.write=function()
	{
		var u=[guessExact(that.Re), guessExact(that.Im)];
		if(u[1]==0)
			return(u[0]);
		else if(u[0]==0)
		{
			return(ascoeff(u[1])+"i");
		}
		else
		{
			return((u[0]+" + "+ascoeff(u[1])+"i").replace(/\+ \-/g, '-'));
		}
	};
	that.add=function(u, v)
	{
		var w=new complex(that.Re+u, that.Im+v);
		return(w);
	};
	that.times=function(u, v)
	{
		var w=new complex(that.Re*u - that.Im*v, that.Re*v + that.Im*u);
		return(w);
	};
	that.divide=function(u, v)
	{
		var d=Math.pow(u, 2)+Math.pow(v, 2);
		var w=new complex((u*that.Re+v*that.Im)/d, (u*that.Im-v*that.Re)/d);
		return(w);
	};
	that.equals=function(u, v)
	{
		return(that.Re==u&&that.Im==v);
	};
}

// polynomial (over C) object: can be set manually or randomly, nonzero terms counted, computed at a z value, multiplied by a constant, differentiated, write it in latex
// REMEMBER: it's stored backwards (x^0 term first)
function c_poly(rank)
{
	var that = this;
	that.rank=rank;
	that.terms=function()
	{
		var n=0;
		for(var i=0;i<=that.rank;i++) {
			if(!that[i].isnull) {
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
	that.setrand=function(maxentry, rad)
	{
		for(var i=0;i<=that.rank;i++)
		{
			that[i]=Complex.random(maxentry, rad);
		}
		if(that[that.rank].isnull()) that[that.rank].set(1, 0);
	};
	that.compute=function(z)
	{
		var y=new complex(0, 0);
		var zp=z.ctop();
		for(var i=0;i<=that.rank;i++) 
		{
			var zi=Complex.ptoc(Math.pow(zp[0], i), zp[1]*i);
			y=y.add(zi[0], zi[1]);
		}
		return y;
	};
	/*that.gcd=function() // TODO complex gcd() using Gaussian integers stuff
	{
		var a=that[that.rank];
		for(var i=0;i<that.rank;i++) a=gcd(a, that[i]);
		return a;
	}*/
	that.xthru=function(z)
	{
		for(var i=0;i<=that.rank;i++)
		{
			that[i]=(that[i].times(z.Re, z.Im));
		}
	};
	that.addp=function(x)
	{
		for(var i=0;i<=that.rank;i++)
		{
			that[i]=that[i].add(x[i].Re, x[i].Im);
		}
	};
	that.diff=function(d)
	{
		d.rank=rank-1;
		for(var i=0;i<that.rank;i++) d[i]=that[i+1].times(i+1, 0);
	};
	that.integ=function(d)
	{
		d.rank=rank+1;
		for(var i=0;i<that.rank;i++) d[i+1]=that[i].divide(i+1, 0);
	};
	that.write=function(l) // l is the letter (or string) for the independent variable.  If not given, defaults to z
	{
		if(typeof(l)=='undefined')
		{
			l='z';
		}
		var q="";
		var j=false;
		for(var i=that.rank;i>=0;i--)
		{
			if(!that[i].isnull())
			{
				if(j)
				{
					if((that[i].Im==0 && that[i].Re<0) || (that[i].Re==0 && that[i].Im<0))
						q+=' - ';
					else
						q+=' + ';
					j=false;
				}
				switch(i)
				{
					case 0:
						q+=that[i].write(); j=true;
					break;
					case 1:
						if(that[i].equals(1, 0) || that[i].equals(-1, 0))
							q+=l;
						else if(that[i].equals(0, 1) || that[i].equals(0, -1))
							q+="i"+l;
						else if(that[i].Im==0 && that[i].Re<0)
							q+=Math.abs(that[i].Re)+l;
						else if(that[i].Re==0 && that[i].Im<0)
							q+=Math.abs(that[i].Im)+"i"+l;
						else
							q+="("+that[i].write()+")"+l;
						j=true;
					break;
					default:
						if(that[i].equals(1, 0) || that[i].equals(-1, 0))
							q+=l+"^"+i;
						else if(that[i].equals(0, 1) || that[i].equals(0, -1))
							q+="i"+l+"^"+i;
						else if(that[i].Im==0 && that[i].Re<0)
							q+=Math.abs(that[i].Re)+l+"^"+i;
						else if(that[i].Re==0 && that[i].Im<0)
							q+=Math.abs(that[i].Im)+"i"+l+"^"+i;
						else
							q+="("+that[i].write()+")"+l+"^"+i;
						j=true;
					break;
				}
			}
		}
		return q;
	};
	that.rwrite=function(l) // l is the letter (or string) for the independent variable.  If not given, defaults to z
	{
		if(typeof(l)=='undefined')
		{
			l='z';
		}
		var q="";
		var j=false;
		for(var i=0;i<=that.rank;i++)
		{
			if(!that[i].isnull())
			{
				if(j)
				{
					if((that[i].Im==0 && that[i].Re<0) || (that[i].Re==0 && that[i].Im<0))
						q+=' - ';
					else
						q+=' + ';
					j=false;
				}
				switch(i)
				{
					case 0:
						q+=that[i].write(); j=true;
					break;
					case 1:
						if(that[i].equals(1, 0) || that[i].equals(-1, 0))
							q+=l;
						else if(that[i].equals(0, 1) || that[i].equals(0, -1))
							q+="i"+l;
						else if(that[i].Im==0 && that[i].Re<0)
							q+=Math.abs(that[i].Re)+l;
						else if(that[i].Re==0 && that[i].Im<0)
							q+=Math.abs(that[i].Im)+"i"+l;
						else
							q+="("+that[i].write()+")"+l;
						j=true;
					break;
					default:
						if(that[i].equals(1, 0) || that[i].equals(-1, 0))
							q+=l+"^"+i;
						else if(that[i].equals(0, 1) || that[i].equals(0, -1))
							q+="i"+l+"^"+i;
						else if(that[i].Im==0 && that[i].Re<0)
							q+=Math.abs(that[i].Re)+l+"^"+i;
						else if(that[i].Re==0 && that[i].Im<0)
							q+=Math.abs(that[i].Im)+"i"+l+"^"+i;
						else
							q+="("+that[i].write()+")"+l+"^"+i;
						j=true;
					break;
				}
			}
		}
		return q;
	};
}
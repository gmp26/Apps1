/*
	fpolys.js - polynomials with fractions
*/

// write a fractional coefficient
function fcoeff(f, t)
{
	if(f.top==f.bot)
		return(t);
	if(f.top==-f.bot)
		return("-"+t);
	if(f.top==0)
		return("");
	return(f.write()+t);
}

// write a fractional coefficient's modulus
function fbcoeff(f, t)
{
	var g=new frac(Math.abs(f.top), Math.abs(f.bot));
	if(g.top==g.bot)
		return(t);
	if(g.top==0)
		return("");
	return(g.write()+t);
}

// Polynomial over Q
function fpoly(rank)
{
	var that = this;
	
	that.rank=rank;
	that.terms=function()
	{
		var n=0;
		for(var i=0;i<=that.rank;i++) {
			if(that[i]) {
				n++;
			}
		}
		return n;
	};
	that.set=function()
	{
		that.rank= that.set.arguments.length - 1;
		for(var i = 0; i <= that.rank; i++)
			that[i] = toFrac(that.set.arguments[i]);
	};
	that.setrand=function(maxentry)
	{
		for(var i=0;i<=that.rank;i++) that[i]=randfrac(12);
		if(that[that.rank].top==0) that[that.rank].top=maxentry;
		that[that.rank].reduce();
	};
	that.setpoly=function(a) // set from a poly (over Z) object
	{
		that.rank=a.rank;
		for(var i=0;i<=that.rank;i++) that[i]=new frac(a[i], 1);
	};
	that.compute=function(x)
	{
		x = toFrac(x);
		var y=new frac(0, 1);
		for(var i=0;i<=that.rank;i++)
			y.add(that[i].top*Math.pow(x.top, i), that[i].bot*Math.pow(x.bot, i));
		y.reduce();
		return y;
	};
	that.gcd=function()
	{
		var g=frac(0, 1);
		for(var i=0;i<that.rank;i++) g.bot*=that[i].bot;
		var a=that[that.rank].top*g.bot/that[that.rank].bot;
		for(var i=0;i<that.rank;i++) a=gcd(a, that[i].top*g.bot/that[i].bot);
		g.reduce();
		return g;
	};
	that.xthru=function(x)
	{
		for(var i=0;i<=that.rank;i++)
		{
			that[i].prod(x);
		}
	};
	that.diff=function(d)
	{
		d.rank=rank-1;
		for(var i=0;i<that.rank;i++)
		{
			d[i]=that[i+1];
			d[i].prod(frac(i+1, 1));
		}
	};
	that.integ=function(d)
	{
		d.rank=that.rank+1;
		d[0]=new frac();
		for(var i=0;i<=that.rank;i++)
		{
			d[i+1]=that[i];
			d[i+1].bot*=(i+1);
			d[i+1].reduce();
		}
	};
	that.write=function()
	{
		var q="";
		var j=false;
		for(var i=that.rank;i>=0;i--)
		{
			var val=that[i].top/that[i].bot;
			if(val<0)
			{
				if(j) q+=' ';
				q+='- ';
				j=false;
			}
			else if(j&&val)
			{
				q+=' + ';
				j=false;
			}
			if(val)
			{
				var a=new frac(Math.abs(that[i].top), that[i].bot);
				switch(i)
				{
					case 0:
						q+=a.write(); j=true;
					break;
					case 1:
						if(a.top==a.bot)
							q+='x';
						else
							q+=a.write()+'x';
						j=true;
					break;
					default:
						if(a.top==a.bot)
							q+='x^'+i;
						else
							q+=a.write()+'x^'+i;
						j=true;
					break;
				}
			}
		}
		return q;
	};
	that.rwrite=function()
	{
		var q="";
		var j=false;
		for(var i=0;i<=that.rank;i++)
		{
			var val=that[i].top/that[i].bot;
			if(val<0)
			{
				if(j) q+=' ';
				q+='- ';
				j=false;
			}
			else if(j&&val)
			{
				q+=' + ';
				j=false;
			}
			if(val)
			{
				var a=new frac(Math.abs(that[i].top), that[i].bot);
				switch(i)
				{
					case 0:
						q+=a.write(); j=true;
					break;
					case 1:
						if(a.top==a.bot)
							q+='x';
						else
							q+=a.write()+'x';
						j=true;
					break;
					default:
						if(a.top==a.bot)
							q+='x^'+i;
						else
							q+=a.write()+'x^'+i;
						j=true;
					break;
				}
			}
		}
		return q;
	};
}

/*
	fractions.js - Fraction object
*/

// fraction object top/bot: keeps itself in lowest terms, write in latex, assignment, equality check
function frac(top,bot)
{
	this.top=typeof(top)!='undefined'?top:0;
	this.bot=typeof(bot)!='undefined'?bot:1;
	this.write=function()
	{
		this.reduce();
		if(this.bot==1) return this.top;
		if(this.top==0) return "0";
		else if(this.top>0) return "\\frac{"+this.top+"}{"+this.bot+"}";
		else return "-\\frac{"+Math.abs(this.top)+"}{"+this.bot+"}";
	}
	this.reduce=function()
	{
		if(this.bot<0)
		{
			this.top*=-1;
			this.bot*=-1;
		}
		var c=gcd(Math.abs(this.top),this.bot);
		this.top/=c;
		this.bot/=c;
	}
	this.set=function(a,b)
	{
		this.top=a;
		this.bot=b;
		this.reduce();
	}
	this.clone=function()
	{
		f=new frac(this.top, this.bot);
		return(f);
	}
	this.equals=function(b)
	{
		this.reduce();
		b.reduce();
		if(this.top==b.top&&this.bot==b.bot) return 1;
		else return 0;
	}
	// Updates in-place
	this.add=function(c,d)
	{
		if(typeof(d)=='undefined') d=1;
		this.set(this.top*d+this.bot*c,this.bot*d);
		this.reduce();
		return(this);
	}
	// Updates in-place
	this.prod=function(c)
	{
		c = toFrac(c);
		this.set(this.top*c.top, this.bot*c.bot);
		this.reduce();
		return(this);
	}
	this.reduce();
}

// makes a number into a fraction, leaves a fraction unchanged
function toFrac(n)
{
	if(typeof(n) == 'number')
		return new frac(n, 1);
	else if(n instanceof frac)
		return n.clone();
	else
		throw new Error('toFrac received ' + typeof(n) +
			' expecting number or frac');
}

// returns a random fraction
function randfrac(max)
{
	var f=new frac(rand(max), randnz(max));
	f.reduce();
	return(f);
}

// square matrix object over Q
function fmatrix(dim)
{
	this.dim=dim;
	this.zero=function()
	{
		for(var i=0;i<this.dim;i++)
		{
			this[i]=new Array(this.dim);
			for(var j=0;j<this.dim;j++)
				this[i][j]=new frac(0);
		}
	}
	this.clone=function()
	{
		var r=new fmatrix(this.dim);
		r.zero();
		for(var i=0;i<this.dim;i++)
			for(var j=0;j<this.dim;j++)
				r[i][j]=this[i][j].clone();
		return(r);
	}
	this.set=function()
	{
		var args = this.set.arguments;
		var n = this.dim;
		if(args.length === n*n)
		{
			this.zero();
			for(var i = 0; i < n; i++)
			{
				for(var j = 0; j < n; j++)
					this[i][j] = toFrac(args[(i*n)+j]);
			}
		}
		else
		{
			throw new Error('Wrong number of elements sent to fmatrix.set()!');
		}
	}
	// Fill with random integers (not fractions)
	this.setrand=function(maxentry)
	{
		for(var i=0;i<this.dim;i++)
		{
			this[i]=new Array(this.dim);
			for(var j=0;j<this.dim;j++)
			{
				this[i][j]=new frac(rand(maxentry), 1);
			}
		}
	}
	// Doesn't update in-place, returns a new matrix
	this.add=function(a)
	{
		if(this.dim!=a.dim)
		{
			throw new Error('Size mismatch matrices sent to matrix.add()!');
		}
		else
		{
			var s=new fmatrix(this.dim);
			for(var i=0;i<this.dim;i++)
			{
				s[i]=new Array(this.dim);
				for(var j=0;j<this.dim;j++)
				{
					s[i][j]=this[i][j].clone().add(a[i][j].top, a[i][j].bot);
				}
			}
			return(s);
		}
	}
	// Doesn't update in-place, returns a new matrix (this*a, not a*this!)
	this.times=function(a)
	{
		if(this.dim!=a.dim) // since we only deal in square matrices, they have to be the same size
		{
			throw new Error('Size mismatch matrices sent to matrix.times()!');
		}
		else
		{
			var s=new fmatrix(this.dim);
			for(var i=0;i<this.dim;i++)
			{
				s[i]=new Array(this.dim);
				for(var j=0;j<this.dim;j++)
				{
					s[i][j]=new frac(0, 1);
				}
			}
			for(var i=0;i<this.dim;i++)
			{
				for(var j=0;j<this.dim;j++)
				{
					for(var k=0;k<this.dim;k++)
					{
						var f=this[i][j].clone().prod(a[j][k]);
						s[i][k].add(f.top, f.bot); // (AB)ik=AijBjk
					}
				}
			}
			return(s);
		}
	}
	this.det=function()
	{
		if(this.dim==2)
		{
			var f=this[0][1].clone().prod(this[1][0]).prod(-1);
			return(this[0][0].clone().prod(this[1][1]).add(f.top, f.bot));
		}
		else if(this.dim==1)
		{
			return(this[0][0].clone());
		}
		else
		{
			// Laplace expansion by first row.  It's slow, but it still works (and it's more maintainable than the other, quicker algos.  Besides, we're only going up to 3x3.  It's still bugged though :S
			var res=new frac(0, 1);
			for(var i=0;i<this.dim;i++) // which column
			{
				var minor=new fmatrix(this.dim-1);
				for(var j=0;j<this.dim-1;j++)
				{
					minor[j]=new Array(this.dim-1);
					for(var k=0;k<this.dim-1;k++)
					{
						minor[j][k]=this[j+1][k>=i?k+1:k].clone();
					}
				}
				var f=minor.det().prod(i%2==1?-1:1).prod(this[0][i]);
				res=res.add(f.top, f.bot);
			}
			return(res);
		}
	}
	this.T=function()
	{
		var res=new fmatrix(this.dim);
		for(var i=0;i<this.dim;i++)
		{
			res[i]=new Array(this.dim);
			for(var j=0;j<this.dim;j++)
			{
				res[i][j]=this[j][i].clone();
			}
		}
		return(res);
	}
	this.inv=function()
	{
		var d=this.det();
		if(d.top==0)
		{
			throw new Error('Singular matrix sent to matrix.inv()!');
		}
		else
		{
			if(this.dim==2)
			{
				var res=new fmatrix(2);
				res.set(new frac(this[1][1].top*d.bot, this[1][1].bot*d.top), new frac(-this[0][1].top*d.bot, this[0][1].bot*d.top), new frac(-this[1][0].top*d.bot, this[1][0].bot*d.top), new frac(this[0][0].top*d.bot, this[0][0].bot*d.top));
				return(res);
			}
			var cof=new fmatrix(this.dim);
			for(var i=0;i<this.dim;i++)
			{
				cof[i]=new Array(this.dim);
				for(var j=0;j<this.dim;j++)
				{
					var minor=new fmatrix(this.dim-1);
					for(var k=0;k<this.dim-1;k++)
					{
						minor[k]=new Array(this.dim);
						for(var l=0;l<this.dim-1;l++)
						{
							minor[k][l]=this[k>=i?k+1:k][l>=j?l+1:l].clone();
						}
					}
					var f=minor.det().prod(((i+j)%2==1?-1:1), 1);
					cof[i][j]=new frac(f.top*d.bot, f.bot*d.top);
				}
			}
			return(cof.T());
		}
	}
	this.tr=function()
	{
		var res=new frac(0, 1);
		for(var i=0;i<this.dim;i++)
			res=res.add(this[i][i].top, this[i][i].bot);
		return(res);
	}
	this.write=function(l)
	{
		if(typeof(l)=='undefined')
			l=["(",")"];
		var res="\\left"+l[0]+"\\begin{array}{"+"c".repeat(this.dim)+"}";
		for(var i=0;i<this.dim;i++)
		{
			for(var j=0;j<this.dim;j++)
			{
				res+=this[i][j].write();
				if(j==this.dim-1)
				{
					if(i==this.dim-1)
					{
						res+="\\end{array}\\right"+l[1];
					}
					else
					{
						res+="\\\\";
					}
				}
				else
				{
					res+="&";
				}
			}
		}
		return(res);
	}
}

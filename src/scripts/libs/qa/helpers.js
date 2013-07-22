// root object a sqrt(n): reduces itself, write in latex
function sqroot(n)
{
	var that = this;

	if(n!=Math.floor(n))
		throw new Error("non-integer sent to square root");
	var a=1;
	for(var i=2;i*i<=n;i++)
	{
		if(n%(i*i)==0)
		{
			n/=(i*i);
			a*=i--;
		}
	}
	that.a=a;
	that.n=n;
	that.write=function()
	{
		if(that.a==1&&that.n==1) return "1";
		else if(that.a==1) return "\\sqrt{"+that.n+"}";
		else if(that.n==1) return that.a;
		else return that.a+"\\sqrt{"+that.n+"}";
	};
}

// vector object: can be set manually or randomly, dot product with another vector, its magnitude squared, write it in latex,
function vector(dim)
{
	var that = this;
	that.dim=dim;
	that.set=function()
	{
		that.dim=that.set.arguments.length;
		for(var i=0;i<that.dim;i++) that[i]=that.set.arguments[i];
	};

	that.setrand=function(maxentry)
	{
		for(var i=0;i<that.dim;i++) that[i]=Math.round(-maxentry+2*maxentry*Math.random());
	};

	that.dot=function(U)
	{
		var sum=0;
		for(var i=0;i<dim;i++) sum+=that[i]*U[i];
		return sum;
	};

	that.cross=function(U)
	{
		if((that.dim==3)&&(U.dim==3))
		{
			var res=new vector(3);
			res.set(0, 0, 0);
			for(var i=0;i<3;i++)
			{
				for(var j=0;j<3;j++)
				{
					for(var k=0;k<3;k++)
					{
						// (axb)i = eijk aj bk
						res[i]+=epsi(i, j, k)*that[j]*U[k];
					}
				}
			}
			return(res); // = that x U
		}
		else
		{
			console.log("vector.cross() called on vectors other than 3D");
			console.log(that);
			console.log(U);
			return res; // jslint again
		}
	};

	that.mag=function()
	{
		return that.dot(that);
	};

	that.write=function()
	{
		var q="\\begin{pmatrix}"+that[0];
		for(var i=1;i<that.dim;i++) q=q+"\\\\"+that[i];
		return q+"\\end{pmatrix}";
	};
}

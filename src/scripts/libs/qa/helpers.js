// gcd of any list of integers
function gcd()
{
	var a=Math.abs(gcd.arguments[0]);
	var b=Math.abs(gcd.arguments[gcd.arguments.length-1]);
	for(var i=gcd.arguments.length;i>2;i--) b=gcd(b,gcd.arguments[i-2]);
	if(a*b==0) return(a+b); // if either is zero, then their gcd is the other
	while((a=a%b)&&(b=b%a)) {};
	return a+b;
}

// sin of pi/6, pi/4 and multiples in the from a/b + csqrt2/d + esqrt3/f
function sinpi(a,b)
{
	var c=gcd(a,b);
	a/=c;
	b/=c;
	if(a==0) return [0,1,0,1,0,1];
	if(a==1&&b==6) return [1,2,0,1,0,1];
	if(a==1&&b==4) return [0,1,1,2,0,1];
	if(a==1&&b==3) return [0,1,0,1,1,2];
	if(a==1&&b==2) return [1,1,0,1,0,1];
	if(a==1&&b==1) return [0,1,0,1,0,1];
	if(a/b>0.5&&a<=b) return sinpi(b-a,b);
	if(a/b>1&&a/b<=1.5)
	{
		var A=new Array(6);
		A=sinpi(a-b,b);
		for(var i=0;i<6;i+=2) A[i]*=-1;
		return A;
	}
	if(a/b>1.5&&a/b<2)
	{
		A=new Array(6);
		A=sinpi(2*b-a,b);
		for(i=0;i<6;i+=2) A[i]*=-1;
		return A;
	}
	return sinpi(a-2*b,b);
}

// cos as per above
function cospi(a,b)
{
	return sinpi(2*a+b,2*b);
}

// returns a random number between min and max, one argument becomes -min to min, zero arguments picks 0 or 1
function rand(min,max)
{
	if(typeof(min)=='undefined') return Math.round(Math.random());
	if(typeof(max)=='undefined')
	{
		if(min>0) min*=-1;
		max=-min;
	}
	return min+Math.floor((max-min+1)*Math.random());
}

// returns a random number between min and max, but not zero, one argument becomes -min to min
function randnz(min,max)
{
	if(typeof(max)=='undefined')
	{
		if(min>0) min*=-1;
		max=-min;
	}
	if(min==0) min++;
	if(max==0) max--;
	if(min>max) return min;
	var a;
	if((min<0) && (max>0))
	{
		a=rand(min, max-1);
		if(a>=0)
			a++;
	}
	else
		a=rand(min, max);
	return a;
}

// returns a random number from the list sent to the function
function pickrand()
{
	return pickrand.arguments[rand(0,pickrand.arguments.length-1)];
}

// orders the arguments after r low to high and returns rth. r=0 returns max.
function rank(r)
{
	var n=rank.arguments.length-1;
	if(r==0) r=n;
	var list=new Array(n);
	for(var i=0;i<n;i++) list[i]=rank.arguments[i+1];
	for(i=0;i<n;i++)
	{
		if(list[i]>list[i+1])
		{
			var c=list[i];
			list[i]=list[i+1];
			list[i+1]=c;
			i=-1;
		}
	}
	return list[r-1];
}

// returns the location of the max value in argument, an array (faster version of rank(0, ...) and operates on an array instead of an arg list)
function maxel(a)
{
	var n=a.length;
	var m=a[0];
	var ma=0;
	for(var i=1;i<n;i++)
	{
		if(a[i]>m)
		{
			m=a[i];
			ma=i;
		}
	}
	return ma;
}

// returns a permutation (0-based) to sort the argument, an array, low to high.  Merge sort
function ranking(a)
{
	var n=a.length;
	if(n>2)
	{
		var left=new Array(Math.floor(n/2));
		var right=new Array(n-left.length);
		for(var i=0;i<n;i++)
		{
			if(i<left.length)
				left[i]=a[i];
			else
				right[i-left.length]=a[i];
		}
		var ls=ranking(left);
		var rs=ranking(right);
		var result=new Array(n);
		var lp=0;
		var rp=0;
		for(i=0;i<n;i++)
		{
			if((rp==right.length)||(lp<left.length&&left[ls[lp]]<right[rs[rp]]))
			{
				result[i]=ls[lp];
				lp++;
			}
			else
			{
				result[i]=rs[rp]+left.length;
				rp++;
			}
		}
		return result;
	}
	else if(n==2)
	{
		if(a[1]<a[0])
		{
			return [1, 0];
		}
		return [0, 1];
	}
	else
		return [0];
}

// Returns n distinct random integers in the range [min, max].  If max omitted, then [-|min|, |min|].  If both omitted, then [1, n]
function distrand(n, min, max)
{
	if(typeof(max)=='undefined')
	{
		if(typeof(min)=='undefined')
		{
			min=1;
			max=n;
		}
		else
		{
			max=Math.abs(min);
			min=-Math.abs(min);
		}
	}
	var list=new Array(max+1-min);
	var res=new Array(n);
	for(var i=0;i<max+1-min;i++)
		list[i]=i+min;
	for(i=0;i<n;i++)
	{
		var s=rand(i, max-min);
		res[i]=list[s];
		list[s]=list[i];
	}
	return res;
}

// Returns n distinct nonzero random integers in the range [min, max].  If max omitted, then [-|min|, |min|].  If both omitted, then [1, n]
function distrandnz(n, min, max)
{
	if(typeof(max)=='undefined')
	{
		if(typeof(min)=='undefined')
		{
			min=1;
			max=n;
		}
		else
		{
			max=Math.abs(min);
			min=-Math.abs(min);
		}
	}
	if(min==0) min++;
	if(max==0) max--;
	if(min>max) return [min];
	var a=((min<0) && (max>0));
	var list=new Array(max+(a?0:1)-min);
	var res=new Array(n);
	for(var i=0;i<max+(a?0:1)-min;i++)
	{
		list[i]=i+min;
		if(a&&list[i]>=0) list[i]++;
	}
	for(i=0;i<n;i++)
	{
		var s=rand(i, max+(a?-1:0)-min);
		res[i]=list[s];
		list[s]=list[i];
	}
	return res;
}

// ordinals
function ord(n)
{
	if(n<0)
		throw new Error("negative ordinal requested from ord()");
	if(Math.floor(n/10)==1)
		return(n+"th");
	switch(n%10)
	{
		case 1:
			return(n+"st");
		break;
		case 2:
			return(n+"nd");
		break;
		case 3:
			return(n+"rd");
		break;
		default:
			return(n+"th");
		break;
	}
	return(n+"th"); // keep jslint happy
}

// ordinals, using text for anything up to twelfth
function ordt(n)
{
	if(n<0)
		throw new Error("negative ordinal requested from ord()");
	if(n<=12)
		return(["zeroth","first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth"][n]);
	return ord(n);
}

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

// Levi-Civita symbol on {n, n+1, n+2} for n \in Z
function epsi(i, j, k)
{
	return((i-j)*(j-k)*(k-i)/2);
}

String.prototype.repeat = function(num)
{
    return(new Array(num+1).join(this));
};

// Returns a number signed with + or - as a string
// Useful for equations

function signedNumber(x) // What about x = +/-1?
{
    if (x > 0) {
        return "+" + x;
    } else {
        return x.toString();
    }
}

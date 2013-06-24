beforeEach(function() {
	this.addMatchers({
		equals: function(other) {
			return this.actual.equals(other)
		}
	});
});

describe("frac", function() {
	var a;

	beforeEach(function() {
		a = randfrac(20);
	});

	it("should be in lowest terms", function() {
		expect(gcd(a.top, a.bot)).toEqual(1);
	});

	it("should equal itself", function() {
		expect(a).equals(a);
	});

	it("should equal its clone", function() {
		expect(a).equals(a.clone());
	});

	it("should not equal its clone plus 1", function() {
		expect(a).not.equals(a.clone().add(1,1))
	});
});

describe("fmatrix", function() {
	var one, zero; // fractions
	var eye; // identity
	var a, b; // random matrices
	var s; // a singular matrix

	beforeEach(function () {
		one = new frac(1,1);
		zero = new frac(0,1);

		eye = new fmatrix(3);
		eye.set(one,zero,zero,zero,one,zero,zero,zero,one);

		a = new fmatrix(3);
		b = new fmatrix(3);
		a.setrand(4);
		b.setrand(4);

		var i, p = randfrac(5), q = randfrac(5);
		s = new fmatrix(3);
		s.setrand(4);
		// make the first column a combination of the others
		for(i = 0; i < 3; i++)
		{
			var r = s[i][1].clone().prod(p);
			s[i][0] = s[i][2].clone().prod(q).add(r.top, r.bot);
		}
	});

	describe("identity matrix", function() {
		it("should have trace = dim", function() {
			var df = new frac(eye.dim);
			expect(eye.tr()).equals(df);
		});

		it("should have det = 1", function() {
			expect(eye.det()).equals(one);
		});
	});

	describe("determinant", function() {
		it("should be a homomorphism", function() {
			var c = b.times(a);
			expect(c.det()).equals(b.det().prod(a.det()));
		});

		it("should be 0 on singular matrices", function() {
			expect(s.det()).equals(zero);
		});

		it("should be antisymmetric", function() {
			var c = a.clone();
			// swap a random pair of columns
			var cols = distrand(2, 0, c.dim-1);
			for(i = 0; i < c.dim; i++)
			{
				var t = c[i][cols[0]];
				c[i][cols[0]] = c[i][cols[1]];
				c[i][cols[1]] = t;
			}
			expect(c.det().prod(-1)).equals(a.det());
		});

		it("should be multilinear", function() {
			var c = a.clone();
			// multiply a random column by a random constant
			var p = randfrac(5);
			var col = rand(0, c.dim-1);
			for(var i = 0; i < c.dim; i++)
				c[i][col].prod(p);
			expect(c.det()).equals(a.det().prod(p));
		});
	});

	describe("transpose", function() {
		var t;

		beforeEach(function () {
			t = a.T();
		});

		it("should have the same det+trace", function() {
			expect(t.det()).equals(a.det());
			expect(t.tr()).equals(a.tr());
		});
	});
});

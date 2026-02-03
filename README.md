## `VisualizeULPError.jl`

This package just provides the Julia app `visualize_ulp_error`.

Not yet registered.

### Usage examples

#### Subcommand `plot`

Visualize the numerical error of `acos` in ULPs:

```sh
time visualize_ulp_error -t5 -- plot '(;
    parent_dir = "/home/nsajko/ulp_error_plots",
    downsampled_length = 650,  # number of data points in the final visualization
    factor = 50000,            # number of evaluations for each data point in the final visualization
    window_size = 10,
    bf_precision = 140,        # `BigFloat` precision
    no_scoped_values = true,
    width = 1500px,            # image width
    height = 500px,            # image height
    func = acos,
    itv = (-1.0, 1.0),
)'
```

#### Subcommand `plots`

Visualize the numerical error for the transcendental functions that come with Julia.

See the resulting plots on the companion Julia Discourse topic:

* https://discourse.julialang.org/t/floating-point-accuracy-visualization-example-the-ulp-error-for-each-math-function-coming-with-julia/135392?u=nsajko

```sh
time visualize_ulp_error -t5 -- plots 'let
    z = 0.0
    o = 1.0
    b = 7.0
    d = rad2deg(b)
    (;
        parent_dir = "/home/nsajko/ulp_error_plots",
        downsampled_length = 650,
        factor = 50000,
        window_size = 10,
        bf_precision = 140,
        no_scoped_values = true,
        width = 1200px,
        height = 500px,
        functions = (
            (acos, (-o, o)),
            (acosd, (-o, o)),
            (acosh, (o, b)),
            (acot, (-b, b)),
            (acotd, (-b, b)),
            (acoth, (o, b)),
            (acsc, (o, b)),
            (acscd, (o, b)),
            (acsch, (-b, b)),
            (asec, (o, b)),
            (asecd, (o, b)),
            (asech, (z, o)),
            (asin, (-o, o)),
            (asind, (-o, o)),
            (asinh, (-b, b)),
            (atan, (-o, o)),
            (atand, (-o, o)),
            (atanh, (-o, o)),
            (cos, (-b, b)),
            (cosc, (-b, b)),
            (cosd, (-d, d)),
            (cosh, (-b, b)),
            (cospi, (-b, b)),
            (cot, (-b, b)),
            (cotd, (-d, d)),
            (coth, (-b, b)),
            (csc, (-b, b)),
            (cscd, (-d, d)),
            (csch, (-b, b)),
            (deg2rad, (-b, b)),
            (exp, (-b, b)),
            (exp10, (-b, b)),
            (exp2, (-b, b)),
            (expm1, (-b, b)),
            (log, (z, b)),
            (log10, (z, b)),
            (log1p, (-o, b)),
            (log2, (z, b)),
            (rad2deg, (-b, b)),
            (sec, (-b, b)),
            (secd, (-d, d)),
            (sech, (-b, b)),
            (sin, (-b, b)),
            (sinc, (-b, b)),
            (sind, (-d, d)),
            (sinh, (-b, b)),
            (sinpi, (-b, b)),
            (tan, (-b, b)),
            (tand, (-d, d)),
            (tanh, (-b, b)),
            (tanpi, (-b, b)),
        ),
    )
end'
```

#### Measure the error of a custom function

To measure the error of an arbitrary function, define it when providing the command options:

```sh
visualize_ulp_error plot 'let sin_fast
    function sin_fast(x::BigFloat)  # accurate reference
        sin(x)
    end
    function sin_fast(x::Float64)   # fast approximation of `sin(x)` for `abs(x) ≤ 0.125`
        # Found with Sollya, using this command: `fpminimax(sin(x), [|1, 3, 5|], [|D...|], [0; 0.125]);`.
        p = (0.9999999999763268, -0.16666663941291426, 0.008328683245851542)
        x * evalpoly(x * x, p)  # odd polynomial composed from simpler polynomials
    end
    (;
        parent_dir = "/home/nsajko/ulp_error_plots",
        downsampled_length = 650,
        factor = 6000,
        window_size = 10,
        bf_precision = 140,
        no_scoped_values = true,
        width = 1100px,
        height = 500px,
        func = sin_fast,
        itv = (-0.125, 0.125),
    )
end'
```

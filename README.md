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

Visualize the numerical error for the transcendental functions that come with Julia:

```sh
time visualize_ulp_error -t5 -- plots 'let
    z = 0.0
    o = 1.0
    b = 7.0
    d = rad2deg(b)
    (;
        parent_dir = "/home/nsajko/ulp_error_plots",
        downsampled_length = 650,
        factor = 20000,
        window_size = 10,
        bf_precision = 140,
        no_scoped_values = true,
        width = 1500px,
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
            (cosd, (-d, d)),
            (cosc, (-b, b)),
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
            (sind, (-d, d)),
            (sinc, (-b, b)),
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

module RelativeError
    export relative_error, relative_error_maximum
    @noinline function throw_invalid()
        throw(ArgumentError("invalid"))
    end
    function relative_error(accurate::AbstractFloat, approximate::AbstractFloat)
        if isnan(accurate)
            @noinline throw_invalid()
        end
        if isnan(approximate)
            @noinline throw_invalid()
        end
        # the relative error is usually not required to great accuracy, so `Float32` should be precise enough
        zero_return = Float32(0)
        inf_return = Float32(Inf)
        if isinf(accurate) || iszero(accurate)  # handle floating-point edge cases
            if isinf(accurate)
                if isinf(approximate) && (signbit(accurate) == signbit(approximate))
                    return zero_return
                end
                return inf_return
            end
            # `iszero(accurate)`
            if iszero(approximate)
                return zero_return
            end
            return inf_return
        end
        # assuming `precision(BigFloat)` is great enough
        acc = if accurate isa BigFloat
            accurate
        else
            BigFloat(accurate)::BigFloat
        end
        # https://nhigham.com/2017/08/14/how-and-how-not-to-compute-a-relative-error/
        err = abs(Float32((approximate - acc) / acc)::Float32)
        if isnan(err)
            @noinline throw_invalid()  # unexpected
        end
        err
    end
    function relative_error(accurate::Acc, approximate::App, x::AbstractFloat) where {Acc, App}
        acc = accurate(x)
        app = approximate(x)
        relative_error(acc, app)
    end
    function relative_error(func::Func, x::AbstractFloat) where {Func}
        relative_error(func ∘ BigFloat, func, x)
    end
    function relative_error_maximum(func::Func, iterator) where {Func}
        function f(x::AbstractFloat)
            relative_error(func, x)
        end
        maximum(f, iterator)
    end
end

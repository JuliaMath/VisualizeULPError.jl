module ValidatedPositiveInt
    export validated_positive_int
    @noinline function throw_err_not_positive()
        throw(ArgumentError("not positive"))
    end
    function validated_positive_int(m::Int)
        if m < 1
            @noinline throw_err_not_positive()
        end
        m
    end
end

module FloatingPointExhaustiveIterators
    export FloatingPointExhaustiveIterator
    @noinline function throw_err_not_finite()
        throw(ArgumentError("not finite"))
    end
    struct FloatingPointExhaustiveIterator{T <: AbstractFloat}
        start::T
        stop::T
        function FloatingPointExhaustiveIterator(start::AbstractFloat, stop::AbstractFloat)
            if !isfinite(start)
                @noinline throw_err_not_finite()
            end
            if !isfinite(stop)
                @noinline throw_err_not_finite()
            end
            new{typeof(start)}(start, stop)
        end
    end
    function Base.IteratorSize(::Type{<:FloatingPointExhaustiveIterator})
        Base.SizeUnknown()
    end
    function Base.IteratorEltype(::Type{<:FloatingPointExhaustiveIterator})
        Base.HasEltype()
    end
    function Base.eltype(::Type{<:FloatingPointExhaustiveIterator{T}}) where {T}
        T
    end
    function _iterate(iterator::FloatingPointExhaustiveIterator, state::AbstractFloat)
        start = iterator.start
        stop = iterator.stop
        if !isfinite(start)
            @noinline throw_err_not_finite()
        end
        if !isfinite(stop)
            @noinline throw_err_not_finite()
        end
        if stop < state
            return nothing
        end
        if !isfinite(state)
            @noinline throw_err_not_finite()
        end
        (state, nextfloat(state))
    end
    function Base.iterate(iterator::FloatingPointExhaustiveIterator, state = iterator.start)
        _iterate(iterator, state)
    end
end

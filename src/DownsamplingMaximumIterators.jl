module DownsamplingMaximumIterators
    export DownsamplingMaximumIterator
    using ..ValidatedPositiveInt
    struct DownsamplingMaximumIterator{Factor, Iterator, Ord <: Base.Order.Ordering}
        iterator::Iterator
        order::Ord
        function DownsamplingMaximumIterator{Factor}(iterator, order::Base.Order.Ordering) where {Factor}
            f = validated_positive_int(Factor)
            new{f, typeof(iterator), typeof(order)}(iterator, order)
        end
    end
    function Base.IteratorSize(::Type{<:DownsamplingMaximumIterator})
        Base.SizeUnknown()
    end
    function Base.IteratorEltype(::Type{<:DownsamplingMaximumIterator})
        Base.EltypeUnknown()
    end
    function get_factor(::DownsamplingMaximumIterator{Factor}) where {Factor}
        validated_positive_int(Factor)
    end
    function _iterate(iterator::DownsamplingMaximumIterator, state::Union{Tuple{}, Tuple{Any}})
        inner_iterator = iterator.iterator
        order = iterator.order
        iter_initial = if state === ()
            iterate(inner_iterator)
        else
            let (is, id) = state[1]
                if id
                    return nothing
                end
                iterate(inner_iterator, is)
            end
        end
        if iter_initial === nothing
            return iter_initial
        end
        (elem_max, inner_iterator_state) = iter_initial
        factor = get_factor(iterator)
        is_done = false
        Base.@assume_effects :terminates_locally for _ ∈ 2:factor
            iter = iterate(inner_iterator, inner_iterator_state)
            if iter === nothing
                is_done = true
                break
            end
            (elem, inner_iterator_state) = iter
            if Base.Order.lt(order, elem_max, elem)
                elem_max = elem
            end
        end
        (elem_max, ((inner_iterator_state, is_done),))
    end
    function Base.iterate(iterator::DownsamplingMaximumIterator, state = ())
        _iterate(iterator, state)
    end
end

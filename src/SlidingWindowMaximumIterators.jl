module SlidingWindowMaximumIterators
    export SlidingWindowMaximumIterator
    using ..ValidatedPositiveInt, ..DeleteFromEnd
    struct SlidingWindowMaximumIterator{Iterator, Ord <: Base.Order.Ordering}
        window_size::Int
        iterator::Iterator
        order::Ord
        function SlidingWindowMaximumIterator(window_size::Int, iterator, order::Base.Order.Ordering)
            s = validated_positive_int(window_size)
            new{typeof(iterator), typeof(order)}(s, iterator, order)
        end
    end
    function Base.IteratorSize(::Type{<:SlidingWindowMaximumIterator})
        Base.SizeUnknown()
    end
    function Base.IteratorEltype(::Type{<:SlidingWindowMaximumIterator{Iterator}}) where {Iterator}
        Base.IteratorEltype(Iterator)
    end
    function Base.eltype(::Type{<:SlidingWindowMaximumIterator{Iterator}}) where {Iterator}
        eltype(Iterator)
    end
    function get_window_size(iterator::SlidingWindowMaximumIterator)
        iterator.window_size
    end
    function delete_all_lesser_from_end!(window_queue::Vector, order::Base.Order.Ordering, elem)
        pop_count = 0
        len = length(window_queue)
        while (pop_count < len) && Base.Order.lt(order, window_queue[end - pop_count][1], elem)
            pop_count = pop_count + 1
        end
        delete_from_end!(window_queue, pop_count)
    end
    # `window_queue` is logically a double-ended queue data structure: only mutating it
    # with `pop!`, `popfirst` and `push!`.
    function _iterate(iterator::SlidingWindowMaximumIterator, state::Tuple{Tuple{(Vector{Tuple{T, Int}} where {T}), Int, Any}})
        (window_queue, counter, inner_iterator_state_initial) = state[1]
        counter = counter::Int
        iter = iterate(iterator.iterator, inner_iterator_state_initial)
        if iter === nothing
            return iter
        end
        (elem, inner_iterator_state) = iter
        order = iterator.order
        delete_all_lesser_from_end!(window_queue, order, elem)
        if (!isempty(window_queue)) && (get_window_size(iterator) ≤ counter - window_queue[1][2]::Int)
            popfirst!(window_queue)
        end
        push!(window_queue, (elem, counter))
        next_state = (window_queue, counter + 1, inner_iterator_state)
        (window_queue[1][1], (next_state,))
    end
    function _iterate(iterator::SlidingWindowMaximumIterator, ::Tuple{})
        inner_iterator = iterator.iterator
        iter_initial = iterate(inner_iterator)
        if iter_initial === nothing
            return iter_initial
        end
        (elem_initial, inner_iterator_state) = iter_initial
        window_size = get_window_size(iterator)
        counter = 0
        window_queue = [(elem_initial, counter)]
        order = iterator.order
        for _ ∈ 2:window_size
            iter = iterate(inner_iterator, inner_iterator_state)
            if iter === nothing
                return iter
            end
            (elem, inner_iterator_state) = iter
            delete_all_lesser_from_end!(window_queue, order, elem)
            counter = counter + 1
            push!(window_queue, (elem, counter))
        end
        state = (window_queue, counter + 1, inner_iterator_state)
        (window_queue[1][1], (state,))
    end
    function Base.iterate(iterator::SlidingWindowMaximumIterator, state = ())
        _iterate(iterator, state)
    end
end

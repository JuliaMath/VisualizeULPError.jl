module ErrorPlotting
    export error_plot
    using ..ValidatedPositiveInt, ..ULPError, ..SlidingWindowMaximumIterators, ..DownsamplingMaximumIterators, ..FloatingPointExhaustiveIterators
    function error_plot_data(
        accurate::Acc,
        approximate::App,
        domain_interval::NTuple{2, AbstractFloat};
        downsampled_length::Int, factor::Int, window_size::Int,
    ) where {Acc, App}
        downsampled_length = validated_positive_int(downsampled_length)
        factor = validated_positive_int(factor)
        window_size = validated_positive_int(window_size)
        domain = let (start, stop) = domain_interval
            if stop ≤ start
                throw(ArgumentError("malformed interval"))
            end
            length = validated_positive_int(Base.checked_mul(downsampled_length, factor)) + window_size - 1
            range(; start, stop, length)
        end
        order = Base.Order.By(last)
        function err(x)
            y = ulp_error(accurate, approximate, x)
            (x, y)
        end
        raw_error = Iterators.map(err, domain)
        smoothed_error = SlidingWindowMaximumIterator(window_size, raw_error, order)
        downsampled_error = DownsamplingMaximumIterator{factor}(smoothed_error, order)
        downsampled_error
    end
    function error_plot_data_exhaustive(
        accurate::Acc,
        approximate::App,
        domain_interval::NTuple{2, AbstractFloat};
        downsampled_length::Int, factor::Int, window_size::Int,
    ) where {Acc, App}
        downsampled_length = validated_positive_int(downsampled_length)
        factor = validated_positive_int(factor)
        window_size = validated_positive_int(window_size)
        domain = let (start, stop) = domain_interval
            if stop ≤ start
                throw(ArgumentError("malformed interval"))
            end
            FloatingPointExhaustiveIterator(start, stop)
        end
        order = Base.Order.By(last)
        function err(x)
            y = ulp_error(accurate, approximate, x)
            (x, y)
        end
        raw_error = Iterators.map(err, domain)
        smoothed_error = SlidingWindowMaximumIterator(window_size, raw_error, order)
        downsampled_error = DownsamplingMaximumIterator{factor}(smoothed_error, order)
        downsampled_error
    end
    function error_plot(
        plot::Plot,
        accurate::Acc,
        approximate::App,
        domain_interval::NTuple{2, AbstractFloat};
        downsampled_length::Int, factor::Int, window_size::Int,
    ) where {Plot, Acc, App}
        downsampled_error = error_plot_data(accurate, approximate, domain_interval; downsampled_length, factor, window_size)
        xs = collect(Float64, Iterators.map(first, downsampled_error))
        ys = collect(Float64, Iterators.map(last, downsampled_error)) 
        plot(xs, ys)
    end
end

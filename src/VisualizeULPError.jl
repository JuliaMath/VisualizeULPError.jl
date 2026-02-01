module VisualizeULPError
    include("ValidatedPositiveInt.jl")
    include("SetPrecision.jl")
    include("DeleteFromEnd.jl")
    include("ULPError.jl")
    include("DownsamplingMaximumIterators.jl")
    include("SlidingWindowMaximumIterators.jl")
    include("FloatingPointExhaustiveIterators.jl")
    include("ErrorPlotting.jl")
    using Gadfly: Gadfly, px
    using Cairo: Cairo
    using Fontconfig: Fontconfig
    function draw(plot; file_name, width, height)
        Gadfly.draw(Gadfly.PNG(string(file_name, ".png"), width, height), plot)
    end
    function plot(x, y)
        Gadfly.plot(Gadfly.Geom.line; x, y)
    end
    function error_plot(f::F; itv, downsampled_length::Int, factor::Int, window_size::Int) where {F}
        ErrorPlotting.error_plot(plot, f ∘ big, f, itv; downsampled_length, factor, window_size)
    end
    function do_plot_inferred(::Val{opts}; parent_dir) where {opts}
        function f()
            (; downsampled_length, factor, window_size) = opts.experiment
            (; width, height) = opts.visualization
            (; func, itv) = opts.funct
            plot = error_plot(func; itv, downsampled_length, factor, window_size)
            file_name = string(parent_dir, '/', func)
            draw(plot; file_name, width, height)
        end
        eo = opts.experiment
        SetPrecision.set_precision(f, BigFloat, eo.bf_precision, eo.no_scoped_values)
        nothing
    end
    function do_plots_inferred(::Val{experiment}, ::Val{visualization}; parent_dir, functions) where {experiment, visualization}
        for (func, itv) ∈ functions
            funct = (; func, itv)
            opts = (; experiment, visualization, funct)
            @time func do_plot_inferred(Val(opts); parent_dir)
        end
    end
    function do_plot(args)
        (; parent_dir, func, itv, downsampled_length, factor, window_size, bf_precision, no_scoped_values, width, height) = eval(Meta.parse(args[1]))
        experiment = (; downsampled_length, factor, window_size, bf_precision, no_scoped_values)
        visualization = (; width, height)
        funct = (; func, itv)
        opts = (; experiment, visualization, funct)
        do_plot_inferred(Val(opts); parent_dir)
    end
    function do_plots(args)
        (; parent_dir, functions, downsampled_length, factor, window_size, bf_precision, no_scoped_values, width, height) = eval(Meta.parse(args[1]))
        experiment = (; downsampled_length, factor, window_size, bf_precision, no_scoped_values)
        visualization = (; width, height)
        do_plots_inferred(Val(experiment), Val(visualization); parent_dir, functions)
    end
    function (@main)(args)
        if isempty(args)
            return
        end
        let command = args[1], args = args[(begin + 1):end]
            if command == "plots"
                do_plots(args)
            elseif command == "plot"
                do_plot(args)
            end
            nothing
        end
    end
end

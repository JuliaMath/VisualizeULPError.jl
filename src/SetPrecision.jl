# See issue https://github.com/JuliaLang/julia/issues/53584

module SetPrecision
    function set_precision_old(f::F, ::Type{T}, prec::Int) where {F, T <: AbstractFloat}
        old = precision(T)
        setprecision(T, prec)
        f()
        setprecision(T, old)
    end
    function set_precision(f::F, ::Type{T}, prec::Int, old::Bool) where {F, T <: AbstractFloat}
        if old
            set_precision_old(f, T, prec)
        else
            setprecision(f, T, prec)
        end
    end
end

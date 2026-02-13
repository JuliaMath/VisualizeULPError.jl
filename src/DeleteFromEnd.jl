module DeleteFromEnd
    export delete_from_end!
    @noinline function cannot_delete_more_than_length()
        throw(ArgumentError("the collection does not have that many elements"))
    end
    function delete_from_end!(c::Vector, n::Int)
        l = length(c)
        if l < n
            @noinline cannot_delete_more_than_length()
        end
        e = lastindex(c)
        deleteat!(c, (e - (n - 1)):e)
        c
    end
end

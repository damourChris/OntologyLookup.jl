module Client

using HTTP

function errorHandler(hanlder)
    return function (req; kwargs...)
        try
            return hanlder(req; kwargs...)
        catch e
            @error e
        end
    end
end

# Create a new client with the error layer added
HTTP.@client [errorHandler]

end
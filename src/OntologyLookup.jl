module OntologyLookup

const OLS_BASE_URL = "https://www.ebi.ac.uk/ols4/api/"
export OLS_BASE_URL

include("terms.jl")
include("client.jl")
using .Client

include("search.jl")
using .Search
export search

function __init__()
end

end
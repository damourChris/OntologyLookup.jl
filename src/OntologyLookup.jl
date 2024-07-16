module OntologyLookup

const OLS_BASE_URL = "https://www.ebi.ac.uk/ols4/api/"
export OLS_BASE_URL

include("terms.jl")
export Term

include("client.jl")
using .Client

include("search.jl")
using .Search
export search

include("term_controller.jl")
using .TermController
export onto_terms, onto_term, get_parents, get_hierarchical_parent

function __init__()
end

end
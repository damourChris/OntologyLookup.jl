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

include("ontologies.jl")
using .Ontologies
export Ontology, list_ontologies, list_ontologies_ids, get_ontology

function __init__()
end

end
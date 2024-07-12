using OntologyLookup
using Test

@testset "OntologyLookup.jl" begin

    # Search Module Tests
    include("test_search.jl")

    # Ontology Term Controller Tests
    include("test_term_controller.jl")
end

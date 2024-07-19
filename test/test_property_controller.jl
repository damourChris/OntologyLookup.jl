# Test onto_properties()
# Test case 1: Test with valid ontology name
# testbroken = false
@testitem "Valid ontology name" begin
    onto = "duo"
    properties = onto_properties(onto)
    @test !isempty(properties)
    @test typeof(properties) == Dict{String,Term}
end

# testbroken = true
# @testitem "Additional parameters - iri" begin
#     onto = "duo"
#     iri = "http://purl.obolibrary.org/obo/BFO_0000050"

#     properties = onto_properties(onto; iri=iri)

#     @test !isempty(properties)
#     @test typeof(properties) == Dict{String,Term}
# end

# testbroken = false
@testitem "Additional parameters - short_from" begin
    onto = "duo"
    short_from = "BFO_0000050"

    properties = onto_properties(onto; short_from=short_from)

    @test !isempty(properties)
    @test typeof(properties) == Dict{String,Term}
end

# testbroken = true
# @testitem "Additional parameters - obo_id" begin
#     onto = "duo"
#     obo_id = "BFO:0000051"

#     properties = onto_properties(onto; obo_id=obo_id)

#     @test !isempty(properties)
#     @test typeof(properties) == Dict{String,Term}
# end

# testbroken = false
@testitem "Additional parameters - lang" begin
    onto = "duo"
    lang = "en"
    properties = onto_properties(onto; lang=lang)
    @test !isempty(properties)
    @test typeof(properties) == Dict{String,Term}
end

# Test onto_property()
# Test case 1: Test with valid ontology name and IRI
# testbroken = false
@testitem "Valid ontology name and IRI" begin
    onto = "duo"
    iri = "http://purl.obolibrary.org/obo/BFO_0000051"
    term = onto_property(onto, iri)
    @test !ismissing(term)
    @test typeof(term) == Term
end

# Test case 2: Test with empty ontology name and IRI
# testbroken = false
@testitem "Empty ontology name and IRI" begin
    onto = ""
    iri = ""
    term = onto_property(onto, iri)
    @test ismissing(term)
    @test typeof(term) == Missing
end

# Test case 3: Test with valid ontology name and encoded IRI
# testbroken = true
@testitem "Valid ontology name and encoded IRI" begin
    onto = "duo"
    iri = "ttp://purl.obolibrary.org/obo/BFO_0000051"
    term = onto_property(onto, iri; encode_iri=true)
    @test !ismissing(term)
    @test typeof(term) == Term
end
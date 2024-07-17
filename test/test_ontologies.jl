# Test list_ontologies()
@testitem "list_ontologies()" begin
    ontologies = list_ontologies()
    @test !isempty(ontologies)
    @test typeof(ontologies) == Vector{OntologyLookup.Ontology}
end

# Test list_ontologies_ids()
@testitem "list_ontologies_ids()" begin
    ontologies = list_ontologies_ids()
    @test !isempty(ontologies)
    @test typeof(ontologies) == Vector{String}
end

# Test get_ontology()
@testitem "get_ontology()" begin
    ontologies = list_ontologies()
    if !isempty(ontologies)
        ontology_id = ontologies[1].ontology_id
        @test_throws MethodError get_ontology()
        @test !ismissing(get_ontology(ontology_id))
        @test typeof(get_ontology(ontology_id)) == OntologyLookup.Ontology
    end
end
@testset "Ontology Term Controller API Wrapper" begin
    @testset "should return a dictionary of terms" begin
        ontology_name = "go"

        terms = onto_terms(ontology_name)

        @test !isempty(terms)
        @test typeof(terms) == Dict{String,Term}
    end

    @testset "should return a dictionary of terms with a specific ID" begin
        ontology_name = "go"
        test_id = "GO:0000001"

        terms = onto_terms(ontology_name; id=test_id)

        @test !isempty(terms)
        @test typeof(terms) == Dict{String,Term}
        @test test_id in keys(terms)
    end

    @testset "should return a singluar term with a specific ID for a given IRI" begin
        test_iri = "http://purl.obolibrary.org/obo/GO_0000001"
        ontology_name = "go"

        term = onto_term(ontology_name, test_iri)

        @test !ismissing(term)
        @test typeof(term) == Term
        @test term.iri == test_iri
        @test term.ontology_name == ontology_name
    end
    @testset "should return a empty term with a wrong IRI" begin
        test_iri = "some random IRI"
        ontology_name = "go"

        @test_warn "Error fetching term with IRI: $test_iri. Returning nothing." begin
            term = onto_term(ontology_name, test_iri)
            @test ismissing(term)
        end
    end

    @testset "should return a list of term that are the parents of the given IRI" begin
        test_term = onto_term("go", "http://purl.obolibrary.org/obo/GO_0000001")

        parents = get_parents(test_term)

        @test !isempty(parents)
    end
    @testset "should return missing with a wrong IRI" begin
        test_term = Term(Dict("iri" => "some random IRI", "label" => "some random label",
                              "ontology_name" => "go", "ontology_prefix" => "GO",
                              "short_form" => "GO:0000001",
                              "description" => ["some random description"],
                              "obo_id" => "GO:0000001"))

        @test_warn "Error fetching parents for term with IRI: $(test_term.iri). Returning nothing." begin
            term = get_parents(test_term)
            @test ismissing(term)
        end
    end
end
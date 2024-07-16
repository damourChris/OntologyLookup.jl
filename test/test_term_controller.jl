@testitem "should return a dictionary of terms" begin
    ontology_name = "go"

    terms = onto_terms(ontology_name)

    @test !isempty(terms)
    @test typeof(terms) == Dict{String,Term}
end

@testitem "should return a dictionary of terms with a specific ID" begin
    ontology_name = "go"
    test_id = "GO:0000001"

    terms = onto_terms(ontology_name; id=test_id)

    @test !isempty(terms)
    @test typeof(terms) == Dict{String,Term}
    @test test_id in keys(terms)
end

@testitem "should return a singluar term with a specific ID for a given IRI" begin
    test_iri = "http://purl.obolibrary.org/obo/GO_0000001"
    ontology_name = "go"

    term = onto_term(ontology_name, test_iri)

    @test !ismissing(term)
    @test typeof(term) == Term
    @test term.iri == test_iri
    @test term.ontology_name == ontology_name
end

@testitem "should return a empty term with a wrong IRI" begin
    test_iri = "some random IRI"
    ontology_name = "go"

    @test_warn "Error fetching term with IRI: $test_iri. Returning missing." begin
        term = onto_term(ontology_name, test_iri)
        @test ismissing(term)
    end
end

@testitem "should return a list of term that are the parents of the given IRI" begin
    test_term = onto_term("go", "http://purl.obolibrary.org/obo/GO_0000001")

    parents = get_parents(test_term)

    @test !isempty(parents)
end

@testitem "should return missing with a wrong IRI" begin
    test_term = Term(Dict("iri" => "some random IRI", "label" => "some random label",
                          "ontology_name" => "go", "ontology_prefix" => "GO",
                          "short_form" => "GO:0000001",
                          "description" => ["some random description"],
                          "obo_id" => "GO:0000001"))

    @test_warn "Error fetching parents for term with IRI: $(test_term.iri). Returning missing." begin
        term = get_parents(test_term)
        @test ismissing(term)
    end
end

@testitem "should return a dictionary of terms" begin
    ontology_name = "go"

    terms = onto_terms(ontology_name)

    @test !isempty(terms)
    @test typeof(terms) == Dict{String,Term}
end

@testitem "should return a dictionary of terms with a specific ID" begin
    ontology_name = "go"
    test_id = "GO:0000001"

    terms = onto_terms(ontology_name; id=test_id)

    @test !isempty(terms)
    @test typeof(terms) == Dict{String,Term}
    @test test_id in keys(terms)
end

@testitem "should return a singluar term with a specific ID for a given IRI" begin
    test_iri = "http://purl.obolibrary.org/obo/GO_0000001"
    ontology_name = "go"

    term = onto_term(ontology_name, test_iri)

    @test !ismissing(term)
    @test typeof(term) == Term
    @test term.iri == test_iri
    @test term.ontology_name == ontology_name
end

@testitem "should return a empty term with a wrong IRI" begin
    test_iri = "some random IRI"
    ontology_name = "go"

    @test_warn "Error fetching term with IRI: $test_iri. Returning missing." begin
        term = onto_term(ontology_name, test_iri)
        @test ismissing(term)
    end
end

@testitem "should return a list of term that are the parents of the given IRI" begin
    test_term = onto_term("cl", "http://purl.obolibrary.org/obo/CL_0000084")

    parents = get_parents(test_term)

    @test !isempty(parents)
end

@testitem "should return missing with a wrong IRI" begin
    test_term = Term(Dict("iri" => "some random IRI", "label" => "some random label",
                          "ontology_name" => "go", "ontology_prefix" => "GO",
                          "short_form" => "GO:0000001",
                          "description" => ["some random description"],
                          "obo_id" => "GO:0000001"))

    @test_warn "Error fetching parents for term with IRI: $(test_term.iri). Returning missing." begin
        term = get_parents(test_term)
        @test ismissing(term)
    end
end

@testitem "should return the hierarchical parent of a term" begin
    test_term = onto_term("cl", "http://purl.obolibrary.org/obo/CL_0000084")

    parent = get_hierarchical_parent(test_term)

    @test !ismissing(parent)
    @test typeof(parent) == Term
end

@testitem "should return the preferred hierarchical parent of a term" begin
    test_term = onto_term("cl", "http://purl.obolibrary.org/obo/CL_0000084")
    preferred_parent = onto_term("cl", "http://purl.obolibrary.org/obo/CL_0000542")

    parent = get_hierarchical_parent(test_term; preferred_parent)

    @test !ismissing(parent)
    @test typeof(parent) == Term
    @test parent == preferred_parent
end

@testitem "should return the first hierarchical parent when multiple parents exist" begin
    test_term = onto_term("cl", "http://purl.obolibrary.org/obo/CL_0000084")

    parent = get_hierarchical_parent(test_term)

    @test !ismissing(parent)
    @test typeof(parent) == Term
end

@testitem "should return missing with a wrong IRI" begin
    test_term = Term(Dict("iri" => "some random IRI", "label" => "some random label",
                          "ontology_name" => "go", "ontology_prefix" => "GO",
                          "short_form" => "GO:0000001",
                          "description" => ["some random description"],
                          "obo_id" => "GO:0000001"))

    @test_warn "Error fetching parents for term with IRI: $(test_term.iri). Returning missing." begin
        term = get_hierarchical_parent(test_term)
        @test ismissing(term)
    end
end

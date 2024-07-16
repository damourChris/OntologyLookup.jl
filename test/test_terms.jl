using Test

# Test the construction of a Term from a dictionary
@testset "Term construction" begin
    d = Dict(
        "iri" => "http://example.com/term",
        "ontology_name" => "Example Ontology",
        "ontology_prefix" => "ex",
        "short_form" => "term",
        "obo_id" => "EX:123",
        "description" => ["Example term"],
        "lang" => "en",
        "label" => "Example",
        "ontology_iri" => "http://example.com/ontology",
        "synonyms" => ["Synonym 1", "Synonym 2"],
        "is_preferred_root" => true
    )
    term = Term(d)
    @test term.iri == "http://example.com/term"
    @test term.ontology_name == "Example Ontology"
    @test term.ontology_prefix == "ex"
    @test term.short_form == "term"
    @test term.obo_id == "EX:123"
    @test term.description == ["Example term"]
    @test term.lang == "en"
    @test term.label == "Example"
    @test term.ontology_iri == "http://example.com/ontology"
    @test term.synonyms == ["Synonym 1", "Synonym 2"]
    @test term.is_preferred_root == true
end

# Test the show function for Term
@testset "Term show" begin
    term = Term(
        "http://example.com/term",
        "Example Ontology",
        "ex",
        "term",
        "EX:123",
        ["Example term"],
        "en",
        "Example",
        "http://example.com/ontology",
        ["Synonym 1", "Synonym 2"],
        true
    )
    io = IOBuffer()
    show(io, term)
    expected_output = """
    Term:
      IRI: http://example.com/term
      Ontology Name: Example Ontology
      Ontology Prefix: ex
      Short Form: term
      OBO ID: EX:123
      Description(s): Example term
      Language: en
      Label: Example
      Ontology IRI: http://example.com/ontology
      Synonyms: Synonym 1, Synonym 2
      Is Preferred Root: true
    """
    @test String(take!(io)) == expected_output
end

# Test the equality operator for Term
@testset "Term equality" begin
    term1 = Term(
        "http://example.com/term",
        "Example Ontology",
        "ex",
        "term",
        "EX:123",
        ["Example term"],
        "en",
        "Example",
        "http://example.com/ontology",
        ["Synonym 1", "Synonym 2"],
        true
    )
    term2 = Term(
        "http://example.com/term",
        "Example Ontology",
        "ex",
        "term",
        "EX:123",
        ["Example term"],
        "en",
        "Example",
        "http://example.com/ontology",
        ["Synonym 1", "Synonym 2"],
        true
    )
    term3 = Term(
        "http://example.com/term2",
        "Example Ontology",
        "ex",
        "term",
        "EX:123",
        ["Example term"],
        "en",
        "Example",
        "http://example.com/ontology",
        ["Synonym 1", "Synonym 2"],
        true
    )
    @test term1 == term2
    @test term1 != term3
end

# Test the hash function for Term
@testset "Term hash" begin
    term = Term(
        "http://example.com/term",
        "Example Ontology",
        "ex",
        "term",
        "EX:123",
        ["Example term"],
        "en",
        "Example",
        "http://example.com/ontology",
        ["Synonym 1", "Synonym 2"],
        true
    )
    h = hash(term)
    @test typeof(h) == UInt
end
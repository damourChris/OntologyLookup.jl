@testitem "return a valid response" begin
    res = search("cancer")

    @test !isempty(res)
end

@testitem "return the correct number of results" begin
    res = search("cancer"; rows=5)

    @test size(res, 1) == 5
end

@testitem "query a specific ontology" begin
    res = search("cancer"; ontology_id="go")

    @test all(res.ontology_prefix .== "GO")
end

@testitem "return an empty DataFrame if no results are found" begin
    res = search("asdfghjkl")

    @test isempty(res)
    @test size(res, 1) == 0
end

@testitem "return an exact result" begin
    res = search("t cell"; exact=true, ontology="CL")

    @test_broken all(lowercase.(res.label) .== "t cell")
end

@testitem "return nothing if search has a typo with exact flag" begin
    res = search("cancre"; exact=true)

    @test size(res, 1) == 0
end
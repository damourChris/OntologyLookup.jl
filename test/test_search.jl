@testset "Search" begin
    @testset "search" begin
        @testset "it should return a valid response" begin
            res = search("cancer")

            @test !isempty(res)
        end

        @testset "it should return the correct number of results" begin
            res = search("cancer"; rows=5)

            @test size(res, 1) == 5
        end

        @testset "it should query a specific ontology" begin
            res = search("cancer"; ontology="go")

            @test all(res.ontology_prefix .== "GO")
        end

        @testset "it should return an empty DataFrame if no results are found" begin
            res = search("asdfghjkl")

            @test isempty(res)
        end

        @testset "it should return an exact result" begin
            res = search("cancer"; exact=true)
            @test all(lowercase.(res.label) .== "cancer")
        end

        @testset "it should return nothing if search has a typo with exact flag" begin
            res = search("cancre"; exact=true)

            @test size(res, 1) == 0
        end
    end
end
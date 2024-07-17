using OntologyLookup
using Documenter
using Changelog

DocMeta.setdocmeta!(OntologyLookup, :DocTestSetup, :(using OntologyLookup); recursive=true)
Changelog.generate(Changelog.Documenter(),
                   joinpath(@__DIR__, "../CHANGELOG.md"),
                   joinpath(@__DIR__, "src/changelog.md");
                   repo="damourChris/OntologyLookup.jl",)

makedocs(;
         modules=[OntologyLookup],
         authors="Chris Damour",
         sitename="OntologyLookup.jl",
         format=Documenter.HTML(;
                                canonical="https://damourChris.github.io/OntologyLookup.jl",
                                edit_link="main",
                                assets=String[],),
         pages=["Home" => "index.md",
                "Search" => "search.md",
                "Term Controller" => "term_controller.md",
                "Ontologies" => "ontologies.md",
                "Changelog" => "changelog.md",
                "Reference" => "reference.md"],)

deploydocs(;
           repo="github.com/damourChris/OntologyLookup.jl.git",
           push_preview=true,)

using OntologyLookup
using Documenter

DocMeta.setdocmeta!(OntologyLookup, :DocTestSetup, :(using OntologyLookup); recursive=true)

makedocs(;
    modules=[OntologyLookup],
    authors="Chris Damour",
    sitename="OntologyLookup.jl",
    format=Documenter.HTML(;
        canonical="https://damourChris.github.io/OntologyLookup.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/damourChris/OntologyLookup.jl",
    devbranch="main",
)

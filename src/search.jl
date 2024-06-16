module Search

using DataFrames
using JSON3

using ..OLSClient
import ..OntologyLookup: OLS_BASE_URL, Term

export search

function OLSquery(q::Dict)
    url = OLS_BASE_URL * "search"
    response = OLSClient.get(url; query=q)

    body = JSON3.read(String(response.body))

    data = body["response"]["docs"]

    return data
end

function search(q::String; rows::Int=10, ontology::String="")
    q = Dict("q" => q, "rows" => rows, "ontology" => ontology)
    data = OLSquery(q)

    terms = [Term(term) for term in data]

    res = DataFrame(terms)

    return res
end

end
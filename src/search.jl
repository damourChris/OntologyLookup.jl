module Search

using DataFrames
using JSON3

using ..Client
import ..OntologyLookup: OLS_BASE_URL, Term

export search

"""
    OLSquery(q::Dict)

Query the Ontology Lookup Service (OLS) with the given parameters.

# Arguments
- `q::Dict`: A dictionary containing the query parameters.

# Returns
- `data`: The response data from the OLS search.

"""
function OLSquery(q::Dict)
    url = OLS_BASE_URL * "search"
    response = Client.get(url; query=q)

    body = JSON3.read(String(response.body))

    data = body["response"]["docs"]

    return data
end

"""
    search(q::String; [rows::Int=10, ontology::String=""])

Searches for ontology terms from the Ontology Lookup Service (OLS) using a search query.

# Arguments
- `q::String`: The search query.
- `rows::Int`: The maximum number of rows to return.
- `ontology::String`: The ontology to search in.
- `exact::Bool`: Whether to search for an exact match.

# Returns
A DataFrame containing the search results.

"""
function search(q::String; rows::Int=10, ontology::String="", exact::Bool=false)
    q = Dict("q" => q, "rows" => rows, "ontology" => ontology, "exactMatch" => exact)
    data = OLSquery(q)

    terms = [Term(term) for term in data]

    res = DataFrame(terms)

    return res
end

end
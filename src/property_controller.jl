module PropertyController

import ..OntologyLookup: Term, OLS_BASE_URL, Client

using JSON3
using HTTP

export onto_properties, onto_property

"""
    onto_properties(ontogy_id::AbstractString;
                    [iri::AbstractString="",
                    short_from::AbstractString="",
                    obo_id="",
                    lang::AbstractString="en",
                    encode_iri::Bool=true])

Fetches the properties of an ontology specified by `ontogy_id`.

# Arguments
- `ontogy_id::AbstractString`: The name of the ontology.
- `iri::AbstractString`: (optional) The IRI of the property.
- `short_from::AbstractString`: (optional) The short form of the property.
- `obo_id`: (optional) The OBO ID of the property.
- `lang::AbstractString`: (optional) The language of the property.
- `encode_iri::Bool`: (optional) Whether to encode the IRI.

# Returns
- `terms::Dict`: A dictionary of properties, where the keys are the OBO IDs and the values are `Term` objects.

# Example
```julia
ontogy_id = "duo"
iri = "http://purl.obolibrary.org/obo/BFO_0000050"
properties = onto_properties(ontogy_id; iri=iri)
```

# See also

- [`onto_property()`](@ref)

"""
function onto_properties(ontogy_id::AbstractString;
                         iri::AbstractString="",
                         short_from::AbstractString="",
                         obo_id="",
                         lang::AbstractString="en",
                         encode_iri::Bool=true)
    url = OLS_BASE_URL * "ontologies/" * ontogy_id * "/properties"
    iri_encoded = encode_iri ? HTTP.URIs.escapeuri(HTTP.URIs.escapeuri(iri)) : iri
    # Only include the parameters that are not empty
    q = Dict("iri" => iri_encoded, "short_form" => short_from, "obo_id" => obo_id,
             "lang" => lang)
    q = filter(x -> x[2] != "" && x[2] != false, q)

    data = try
        response = Client.get(url; query=q)

        body = JSON3.read(String(response.body), Dict)

        data = body["_embedded"]["properties"]

        terms = Dict([term["obo_id"] => Term(term) for term in data])
        return terms
    catch e
        @error e
        @warn "Error fetching term with IRI: $iri. Returning missing."
        return missing
    end
end

"""
    onto_property(ontogy_id::AbstractString, iri::AbstractString; encode_iri::Bool=false)

Fetches the term with the given IRI from the specified ontology.

# Arguments
- `ontogy_id::AbstractString`: The name of the ontology.
- `iri::AbstractString`: The IRI (Internationalized Resource Identifier) of the term.
- `encode_iri::Bool=false`: Whether to encode the IRI before making the request.

# Returns
- If the term is found, returns a `Term` object representing the term.
- If an error occurs during the request, logs the error and returns `missing`.

# See also
- [`onto_properties()`](@ref)

"""
function onto_property(ontogy_id::AbstractString, iri::AbstractString;
                       encode_iri::Bool=false)
    iri_encoded = encode_iri ? HTTP.URIs.escapeuri(HTTP.URIs.escapeuri(iri)) : iri

    url = OLS_BASE_URL * "ontologies/" * ontogy_id * "/properties/" * iri_encoded

    try
        response = Client.get(url)

        body = JSON3.read(String(response.body), Dict)

        term = Term(body)
        return term
    catch e
        @error e
        @warn "Error fetching term with IRI: $iri. Returning missing."
        return missing
    end
end

"""
    roots(ontogy_id::String)::Union{Vector{Term},Missing}

Fetches the root terms of the ontology specified by `ontogy_id`.

# Arguments
- `onto::String`: The name of the ontology.

# Returns
- If successful, returns a vector of Terms representing the root terms of the ontology.
- If an error occurs during the API request, returns `missing`.
"""
function roots(ontogy_id::String)::Union{Vector{Term},Missing}
    url = OLS_BASE_URL * "ontologies/" * ontogy_id * "/roots"
    data = try
        response = Client.get(url)
        body = JSON3.read(String(response.body), Dict)

        data = body["_embedded"]["properties"]

        return [Term(root) for root in data]
    catch e
        @error e
        @warn "Error fetching roots for ontology with ID: $ontogy_id. Returning"
    end

    return data
end

end # module
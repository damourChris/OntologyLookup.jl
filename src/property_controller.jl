module PropertyController

import ..OntologyLookup: Term, OLS_BASE_URL, Client

export onto_properties, onto_property

function onto_properties(onto::AbstractString;
                         iri::AbstractString="",
                         short_from::AbstractString="",
                         obo_id="",
                         lang::AbstractString="en")
    url = OLS_BASE_URL * "ontologies/" * onto * "/properties"
    # Only include the parameters that are not empty
    q = Dict("iri" => iri, "short_form" => short_from, "obo_id" => obo_id, "lang" => lang)
    q = filter(x -> x[2] != "" && x[2] != false, q)

    data = try
        response = Client.get(url; query=q)

        body = JSON3.read(String(response.body), Dict)

        data = body["_embedded"]["terms"]

        terms = Dict([term["obo_id"] => Term(term) for term in data])
        return terms
    catch e
        @error e
        @warn "Error fetching term with IRI: $iri. Returning missing."
        return missing
    end
end

function onto_property(onto::AbstractString, iri::AbstractString; encode_iri::Bool=false)
    iri_encoded = encode_iri ? HTTP.URIs.escapeuri(HTTP.URIs.escapeuri(iri)) : iri

    url = OLS_BASE_URL * "ontologies/" * onto * "/properties/" * iri_encoded

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

end # module
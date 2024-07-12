module TermController

export onto_terms, onto_term, get_parents

using ..Client
using JSON3
using HTTP
import ..OntologyLookup: OLS_BASE_URL, Term

function onto_terms(onto::AbstractString;
                    id::AbstractString="",
                    iri::AbstractString="", short_from::AbstractString="", obo_id="",
                    obsoletes::Bool=false, lang::AbstractString="en")
    url = OLS_BASE_URL * "ontologies/" * onto * "/terms"
    # Only include the parameters that are not empty
    q = Dict("id" => id, "iri" => iri, "short_form" => short_from, "obo_id" => obo_id,
             "obsoletes" => obsoletes, "lang" => lang)
    q = filter(x -> x[2] != "" && x[2] != false, q)

    response = Client.get(url; query=q)

    body = JSON3.read(String(response.body), Dict)

    data = body["_embedded"]["terms"]

    terms = Dict([term["obo_id"] => Term(term) for term in data])

    return terms
end

function onto_term(onto::AbstractString, iri::AbstractString; lang="en")
    iri_encoded = HTTP.URIs.escapeuri(iri)
    iri_double_encoded = HTTP.URIs.escapeuri(iri_encoded)
    url = OLS_BASE_URL * "ontologies/" * onto * "/terms/" * iri_double_encoded

    q = Dict("lang" => lang)

    data = try
        response = Client.get(url; query=q)
        body = JSON3.read(String(response.body), Dict)
        term = Term(body)
        return term
    catch
        @warn "Error fetching term with IRI: $iri. Returning nothing."
        return missing
    end

    return data
end

function get_parents(term::Term)
    iri = term.iri
    iri_encoded = HTTP.URIs.escapeuri(iri)
    iri_double_encoded = HTTP.URIs.escapeuri(iri_encoded)
    url = OLS_BASE_URL * "ontologies/" * term.ontology_name * "/terms/" *
          iri_double_encoded *
          "/parents"

    parents = try
        response = Client.get(url)

        body = JSON3.read(String(response.body), Dict)
        data = body["_embedded"]["terms"]
        parents = [Term(parent) for parent in data]
        return parents
    catch
        @warn "Error fetching parents for term with IRI: $iri. Returning nothing."
        return missing
    end

    return parents
end

end # module
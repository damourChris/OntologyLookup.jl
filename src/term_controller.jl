module TermController

export onto_terms, onto_term, get_parents

using ..Client
using JSON3
using HTTP
import ..OntologyLookup: OLS_BASE_URL, Term

"""
    onto_terms(onto::AbstractString;
               [id::AbstractString="",
               iri::AbstractString="",
               short_from::AbstractString="",
               obo_id="",
               obsoletes::Bool=false,
               lang::AbstractString="en"])

Fetches ontology terms from the OLS API based on the specified parameters.

## Arguments
- `onto::AbstractString`: The name of the ontology to fetch terms from.
- `id::AbstractString`: (optional) The ID of the term.
- `iri::AbstractString`: (optional) The IRI of the term.
- `short_from::AbstractString`: (optional) The short form of the term.
- `obo_id`: (optional) The OBO ID of the term.
- `obsoletes::Bool`: (optional) Whether to include obsoleted terms. Default is `false`.
- `lang::AbstractString`: (optional) The language of the term. Default is `"en"`.

## Returns
A dictionary of terms, where the keys are the OBO IDs of the terms and the values are `Term` objects.

"""
function onto_terms(onto::AbstractString;
                    id::AbstractString="",
                    iri::AbstractString="", short_from::AbstractString="", obo_id="",
                    obsoletes::Bool=false, lang::AbstractString="en")
    url = OLS_BASE_URL * "ontologies/" * onto * "/terms"
    # Only include the parameters that are not empty
    q = Dict("id" => id, "iri" => iri, "short_form" => short_from, "obo_id" => obo_id,
             "obsoletes" => obsoletes, "lang" => lang)
    q = filter(x -> x[2] != "" && x[2] != false, q)

    data = try
        response = Client.get(url; query=q)

        body = JSON3.read(String(response.body), Dict)

        data = body["_embedded"]["terms"]

        terms = Dict([term["obo_id"] => Term(term) for term in data])
        return terms
    catch
        @warn "Error fetching term with IRI: $iri. Returning missing."
        return missing
    end
end

"""
    onto_term(onto::AbstractString, iri::AbstractString; [lang="en"])

Fetches the term information from the specified ontology using the given IRI.

# Arguments
- `onto::AbstractString`: The name of the ontology.
- `iri::AbstractString`: The IRI (Internationalized Resource Identifier) of the term.
- `lang::AbstractString`: (optional) The language code for the term description. Default is "en".

# Returns
- If the term is found, returns a `Term` object containing the term information.
- If there is an error fetching the term, a warning is issued and `missing` is returned.

"""
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
        @warn "Error fetching term with IRI: $iri. Returning missing."
        return missing
    end

    return data
end

"""
    get_parents(term::Term)

Fetches the parent terms for a given term.

# Arguments
- `term::Term`: The term for which to fetch the parent terms.

# Returns
An array of `Term` objects representing the parent terms of the given term, or `missing` if an error occurs.

""" 
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
        @warn "Error fetching parents for term with IRI: $iri. Returning missing."
        return missing
    end

    return parents
end

end # module
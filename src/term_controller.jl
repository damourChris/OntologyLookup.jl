module TermController

export onto_terms, onto_term, get_parents, get_hierarchical_parent

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
<<<<<<< HEAD
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
- `iri::AbstractString`: (optional) The IRI of the term. Note, set encode_iri to false if the IRI is already encoded.
- `short_from::AbstractString`: (optional) The short form of the term.
- `obo_id`: (optional) The OBO ID of the term.
- `obsoletes::Bool`: (optional) Whether to include obsoleted terms. Default is `false`.
- `lang::AbstractString`: (optional) The language of the term. Default is `"en"`.

## Returns
A dictionary of terms, where the keys are the OBO IDs of the terms and the values are `Term` objects.

"""
=======
>>>>>>> main
function onto_terms(onto::AbstractString;
                    id::AbstractString="",
                    iri::AbstractString="", short_from::AbstractString="", obo_id="",
                    obsoletes::Bool=false, lang::AbstractString="en", encode_iri::Bool=true)
    url = OLS_BASE_URL * "ontologies/" * onto * "/terms"
    # Only include the parameters that are not empty
    q = Dict("id" => id, "iri" => encode_iri ? HTTP.URIs.escapeuri(iri) : iri,
             "short_form" => short_from, "obo_id" => obo_id,
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
<<<<<<< HEAD
    onto_term(onto::AbstractString, iri::AbstractString; [lang="en", encode_iri=true])
=======
    onto_term(onto::AbstractString, iri::AbstractString; [lang="en"])
>>>>>>> main

Fetches the term information from the specified ontology using the given IRI.

# Arguments
- `onto::AbstractString`: The name of the ontology.
- `iri::AbstractString`: The IRI (Internationalized Resource Identifier) of the term.
- `lang::AbstractString`: (optional) The language code for the term description. Default is "en".
<<<<<<< HEAD
- `encode_iri::Bool` (optional): Whether to encode the IRI before making the request. Default is `true`.
=======
>>>>>>> main

# Returns
- If the term is found, returns a `Term` object containing the term information.
- If there is an error fetching the term, a warning is issued and `missing` is returned.

"""
<<<<<<< HEAD
function onto_term(onto::AbstractString, iri::AbstractString; lang="en",
                   encode_iri::Bool=true)
    iri_encoded = encode_iri ? HTTP.URIs.escapeuri(iri) : iri

    url = OLS_BASE_URL * "ontologies/" * onto * "/terms/" * iri_encoded
=======
function onto_term(onto::AbstractString, iri::AbstractString; lang="en")
    iri_encoded = HTTP.URIs.escapeuri(iri)
    iri_double_encoded = HTTP.URIs.escapeuri(iri_encoded)
    url = OLS_BASE_URL * "ontologies/" * onto * "/terms/" * iri_double_encoded
>>>>>>> main

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
<<<<<<< HEAD
- `encode_iri::Bool` (optional): Whether to encode the IRI before making the request. Default is `true` since IRI are usually stored non-encode in Term struct.
=======
>>>>>>> main

# Returns
An array of `Term` objects representing the parent terms of the given term, or `missing` if an error occurs.

<<<<<<< HEAD
"""
function get_parents(term::Term; encode_iri::Bool=true)
=======
""" 
function get_parents(term::Term)
>>>>>>> main
    iri = term.iri

    iri_encoded = encode_iri ? HTTP.URIs.escapeuri(iri) : iri

    url = OLS_BASE_URL * "ontologies/" * term.ontology_name * "/terms/" *
          iri_encoded *
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

"""
    get_hierarchical_parent(term::Term; preferred_parent::Union{Missing,Term}=missing)

Fetches the hierarchical parent of a given term.

## Arguments
- `term::Term`: The term for which to fetch the hierarchical parent.
- `preferred_parent::Union{Missing,Term}` (optional): The preferred parent term to be returned, if multiple parents are found.
- `encode_iri::Bool` (optional): Whether to encode the IRI before making the request. Default is `true` since IRI are usually stored non-encode in Term struct.

## Returns
- If a single parent is found, returns the hierarchical parent as a `Term` object.
- If multiple parents are found and a preferred parent is specified, returns the preferred parent as a `Term` object.
- If multiple parents are found and no preferred parent is specified, returns the first parent as a `Term` object.
- If an error occurs while fetching the parents, returns `missing`.

"""
function get_hierarchical_parent(term::Term; preferred_parent::Union{Missing,Term}=missing,
                                 encode_iri::Bool=true)
    iri = term.iri

    iri_encoded = encode_iri ? HTTP.URIs.escapeuri(iri) : iri

    url = OLS_BASE_URL * "ontologies/" * term.ontology_name * "/terms/" *
          iri_encoded *
          "/hierarchicalParents"

    data = try
        response = Client.get(url)

        body = JSON3.read(String(response.body), Dict)
        data = body["_embedded"]["terms"]
        if (length(data) > 1)
            if !isnothing(preferred_parent)
                for parent in data
                    if Term(parent) == preferred_parent
                        @info "Preferred parent found for term with IRI: $iri."
                        return preferred_parent
                    end
                end
            end
            @warn "More than one parent found for term with IRI: $iri. Returning the first parent."
        end
        parent = Term(data[1])
        return parent
    catch
        @warn "Error fetching parents for term with IRI: $iri. Returning missing."
        return missing
    end

    return data
end

end # module
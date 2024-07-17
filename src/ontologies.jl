module Ontologies

using JSON3

import ..OntologyLookup: Client, OLS_BASE_URL

export Ontology, list_ontologies, list_ontologies_ids, get_ontology

@kwdef struct Ontology
    language::String
    available_languages::Vector{String}
    ontology_id::String
    version::Union{Nothing,String}
    number_of_terms::Int
    number_of_properties::Int
end

function Base.show(io::IO, ontology::Ontology)
    println(io, "Ontology:")
    println(io, "  Ontology ID: ", ontology.ontology_id)
    println(io, "  Language: ", ontology.language)
    println(io, "  Available Languages: ", join(ontology.available_languages, ", "))
    println(io, "  Version: ", ontology.version)
    println(io, "  Number of Terms: ", ontology.number_of_terms)
    return println(io, "  Number of Properties: ", ontology.number_of_properties)
end

"""
    list_ontologies()::Union{Vector{Ontology},Missing}

Fetches a list of ontologies from the OLS (Ontology Lookup Service) API.

# Returns
- If successful, returns a vector of `Ontology` objects representing the fetched ontologies.
- If an error occurs during the API request, returns `missing`.

# See also 
- [`list_ontologies_ids()`](@ref)
- [`get_ontology()`](@ref)
"""
function list_ontologies()::Union{Vector{Ontology},Missing}
    url = OLS_BASE_URL * "ontologies"
    data = try
        response = Client.get(url)
        body = JSON3.read(String(response.body), Dict)
        data = body["_embedded"]["ontologies"]
        ontologies = [Ontology(;
                               language=ontology["lang"],
                               available_languages=ontology["languages"],
                               ontology_id=ontology["ontologyId"],
                               version=ontology["version"],
                               number_of_terms=ontology["numberOfTerms"],
                               number_of_properties=ontology["numberOfProperties"])
                      for ontology in data]
        return ontologies
    catch e
        @error e
        @warn "Error fetching ontologies. Returning missing."
        return missing
    end
    return data
end

"""
    list_ontologies_ids()::Union{Vector{String},Missing}

Returns a vector of ontology IDs.

Retrieve the list of available ontologies, and returns a vector of their IDs. 
If an error occurs during the fetch, the function returns `missing`.

# See also 
- [`list_ontologies()`](@ref)
- [`get_ontology()`](@ref)

"""
function list_ontologies_ids()::Union{Vector{String},Missing}
    ontologies = list_ontologies()
    if ontologies === missing
        return missing
    end
    return [ontology.ontology_id for ontology in ontologies]
end

"""
    get_ontology(ontology_id::String)::Union{Ontology,Missing}

Fetches an ontology from the OLS (Ontology Lookup Service) based on the given `ontology_id`. 
To get a list of available ontologies, use the `list_ontologies()` function.

# Returns
- If the ontology is found, returns an `Ontology` object containing information about the ontology.
- If the ontology is not found or an error occurs during the fetch, returns `missing`.

# See also 
- [`list_ontologies()`](@ref)
- [`list_ontologies_ids()`](@ref)
"""
function get_ontology(ontology_id::String)::Union{Ontology,Missing}
    url = OLS_BASE_URL * "ontologies/" * ontology_id
    data = try
        response = Client.get(url)
        body = JSON3.read(String(response.body), Dict)
        ontology = Ontology(;
                            language=body["lang"],
                            available_languages=body["languages"],
                            ontology_id=body["ontologyId"],
                            version=body["version"],
                            number_of_terms=body["numberOfTerms"],
                            number_of_properties=body["numberOfProperties"])
        return ontology
    catch e
        @error e
        @warn "Error fetching ontology with ID: $ontology_id. Returning missing."
        return missing
    end
    return data
end

end # module
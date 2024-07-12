struct Term
    iri::String
    ontology_name::String
    ontology_prefix::String
    short_form::String
    obo_id::String
    description::Array{String}
    lang::Union{String,Missing}
    label::Union{String,Missing}
    ontology_iri::Union{String,Missing}
    synonyms::Union{Array{String},Missing}
    is_preferred_root::Union{Bool,Missing}
end

function Term(d::AbstractDict)
    @assert haskey(d, "iri") && haskey(d, "ontology_name") &&
            haskey(d, "ontology_prefix") &&
            haskey(d, "short_form") && haskey(d, "obo_id") && haskey(d, "description") "Unable to construct Term from dictionary."
    lang = get(d, "lang", missing)
    label = get(d, "label", missing)
    ontology_iri = get(d, "ontology_iri", missing)
    synonyms = get(d, "synonyms", missing)
    is_preferred_root = get(d, "is_preferred_root", missing)

    return Term(d["iri"], d["ontology_name"], d["ontology_prefix"], d["short_form"],
                d["obo_id"], d["description"], lang, label, ontology_iri, synonyms,
                is_preferred_root)
end
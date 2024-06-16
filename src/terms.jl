struct Term
    iri::String
    label::String
    ontology_name::String
    ontology_prefix::String
    short_form::String
    description::Array{String}
    obo_id::String
end

function Term(d::AbstractDict)
    @assert haskey(d, "iri") && haskey(d, "label") && haskey(d, "ontology_name") &&
            haskey(d, "ontology_prefix") && haskey(d, "short_form") &&
            haskey(d, "description") && haskey(d, "obo_id")
    return Term(d["iri"], d["label"], d["ontology_name"], d["ontology_prefix"],
                d["short_form"], d["description"], d["obo_id"])
end
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

function Base.show(io::IO, term::Term)
    println(io, "Term:")
    println(io, "  IRI: ", term.iri)
    println(io, "  Ontology Name: ", term.ontology_name)
    println(io, "  Ontology Prefix: ", term.ontology_prefix)
    println(io, "  Short Form: ", term.short_form)
    println(io, "  OBO ID: ", term.obo_id)

    # Handling array fields
    println(io, "  Description(s): ", join(term.description, ", "))

    # Handling optional fields
    print_optional(io, "Language", term.lang)
    print_optional(io, "Label", term.label)
    print_optional(io, "Ontology IRI", term.ontology_iri)

    # Special handling for synonyms array
    if !ismissing(term.synonyms)
        println(io, "  Synonyms: ", join(term.synonyms, ", "))
    end

    return print_optional(io, "Is Preferred Root", term.is_preferred_root)
end

# Helper function to handle optional fields
function print_optional(io::IO, name::String, value::Union{T,Missing}) where {T}
    if !ismissing(value)
        println(io, "  $name: ", value)
    end
end

# Ontologies
 
The Ontology Lookup Service (OLS) is designed to leverage the power of multiple ontologies, providing a structured and semantic framework for organizing, interpreting, and querying data across various domains.

The OLS provides access to a wide range of ontologies, including the following:
- [ChEBI](https://www.ebi.ac.uk/chebi/)
- [GO](http://geneontology.org/)
- [NCBITaxon](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi)
- [PR](https://proconsortium.org/)
- [UBERON](http://obophenotype.github.io/uberon/)
- [EFO](https://www.ebi.ac.uk/efo/)

The OLS also provides access to the following cross-domain ontologies:
- [OBO](http://obofoundry.org/)
- [EDAM](https://edamontology.org/)


And many more. The OLS is designed to be extensible, allowing users to add their own ontologies to the system.

# Listing ontologies

To list all available ontologies, use the following command:

```julia
list_ontologies()
```

This will return a list of all available ontologies in the OLS.

Note, this will return Ontology objects, which contain information about the ontology, such as the name, title, description, and version. If you wish to only get the ids of the ontologies, you can use the following command:

```julia
list_ontology_ids()
```

# Getting an ontology

To get information about a specific ontology, use the following command:

```julia
get_ontology("CHEBI")
```


# References

```@autodocs
Modules = [OntologyLookup.Ontologies]
```




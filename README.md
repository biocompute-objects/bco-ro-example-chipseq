# bco-ro-example-chipseq

Packaging a IEEE 2791 described BioCompute Object as RO-Crate, using a workflow run of [nf-core/chipseq](https://nf-co.re/chipseq) as example. This composition is colloqually called a _BCO RO-Crate_.

This example attempts to show the separation of concerns for workflow data packaging when combining these standards:

* [BioComputeObject](https://biocomputeobject.org/) formalized in standard [IEEE 2791](10.1109/IEEESTD.2020.9094416)
* [RO-Crate](https://w3id.org/ro/crate/)
* [BagIt (RFC8493)](https://www.rfc-editor.org/rfc/rfc8493.html)

For more information, see <https://biocompute-objects.github.io/bco-ro-crate/> where this example is explained in detail. 

## License

The license of this example is [Creative Commons Zero v1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) which permits free reuse without attribution or license requirements.

Note that some of the data in `data/results` are derived from the reference data, licensed under the [MIT license](https://spdx.org/licenses/MIT)

The workflow nf-core/chipseq is licensed under the [MIT license](https://spdx.org/licenses/MIT)

This package is therefore a good example of mixed licensing.

## Workflow

This package contains results of an exemplar run of the [Nextflow](https://www.nextflow.io/) workflow [nf-core/chipseq](https://nf-co.re/chipseq) version 1.2.1. This workflow was chosen because it is well documentedf for domain scientists, uses public reference data, and is reproducible to run using [BioConda](https://bioconda.github.io/) or [Docker containers](https://www.docker.com/).  The Nextflow workflow engine is also open source and runs on most platforms.

Attribution-wise this workflow is open-source, has multiple community authors and a Zenodo DOI for citations <https://doi.org/10.5281/zenodo.3966161>

The [workflow repository in GitHub](https://github.com/nf-core/chipseq/tree/1.2.1) is bundled with test data which at nf-core is used for automated testing. This exemplar therefore runs the workflow with those inputs by using `-profile test`.

Nextflow allows execution of the [nf-core](https://nf-co.re/) workflows by their short name, and they are downloaded automatically. Our [run.sh](run.sh) therefore refers to the workflow by reference `nf-core/chipseq`:

```sh
cd data
nextflow run nf-core/chipseq -revision 1.2.1 -profile test,conda | tee nextflow.log
```

**Note** Here we use `-revision 1.2.1` to fix the workflow version. Similar measures should be used when executing workflows that are not contained in the BCO folders.

## Reference data

This workflow retrives reference data sets from <https://github.com/nf-core/test-datasets/tree/atacseq> which again come from [ilummina's iGenomes](https://emea.support.illumina.com/sequencing/sequencing_software/igenome.html). This is a good example of reuse of reference data sets that have multiple levels of provenance and attributions.


## Results

The folder [data/results](deta/results) contain the outputs as produced by the Nextflow workflow. 

Note that some of these files are large and are stored using [Git LFS](https://git-lfs.github.com/) - if you need all the files, follow the git-lfs install instructions, then try `git lfs fetch` in a Git checkout of [this repository](https://github.com/biocompute-objects/bco-ro-example-chipseq)

## BioCompute Object (IEEE 2791)

[data/chipseq_20200910.json](data/chipseq_20200910.json) is a [JSON](https://www.json.org/json-en.html) file
conforming to [IEEE 2791](10.1109/IEEESTD.2020.9094416)'s JSON Schemas <https://w3id.org/ieee/ieee-2791-schema/> 

As is common practice, the BCO file is named `chipseq_20200910.json` to reflect the workflow name and this particular run. This name is not required to be particularly unique but should be meaningful to users.  The RO-Crate metadata file will help programmatic access in locating the correct BCO file. It is RECOMMENDED that a BCO RO-Crate has only a single BCO file.

Here the role of the BCO is to explain the workflow, particularly for a domain expert not familiar with Nextflow.

The JSON can be validated with tools like <https://www.jsonschemavalidator.net/> using the JSON Schema:
    
```json
{ "$ref": "https://w3id.org/ieee/ieee-2791-schema/2791object.json"}
```

The above schema will recursively include the full [IEEE 2791 schemas](https://w3id.org/ieee/ieee-2791-schema/).

## RO-Crate

[data/ro-crate-metadata.json](data/ro-crate-metadata.json) is a JSON-LD file conforming to [RO-Crate Metadata specification 1.1-DRAFT](https://www.researchobject.org/ro-crate/1.1-DRAFT/)

Here the role of the RO-Crate is to type, relate and describe the individual files in this package. This includes external references, licenses and attributions to authors. This may seem like overlap from the BCO, but as it is here per file it can distinguish more complicated situations such as the reference datasets.

## BagIt

[bagit.txt](bagit.txt), [bag-info.txt](bag-info.txt), [manifest-sha512.txt](manifest-sha512.txt) and [tagmanifest-sha512.txt](tagmanifest-sha512.txt) conform to [BagIt (RFC8493)](https://www.rfc-editor.org/rfc/rfc8493.html).

The role of the BagIt is mainly ensure all files are present and not modified or corrupted in transfer.

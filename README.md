# bco-ro-example-chipseq

Packaging a IEEE 2791 described BioCompute Object as RO-Crate, using a workflow run of [nf-core/chipseq](https://nf-co.re/chipseq) as example.

This example attempts to show the separation of concerns for workflow data packaging when combining these standards:

* [BioComputeObject](https://biocomputeobject.org/) formalized in standard [IEEE 2791](10.1109/IEEESTD.2020.9094416)
* [RO-Crate](https://w3id.org/ro/crate/)
* [BagIt (RFC8493)](https://www.rfc-editor.org/rfc/rfc8493.html)

## License

The license of this example is [Creative Commons Zero v1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) which permits free reuse without attribution or license requirements.

Note that some of the data in `data/results` are derived from the reference data, licensed under the [MIT license](https://spdx.org/licenses/MIT)

The workflow nf-core/chipseq is licensed under the [MIT license](https://spdx.org/licenses/MIT)

This package is therefore a good example of mixed licensing.

## Workflow

This package contains results of an exemplar run of the [Nextflow](https://www.nextflow.io/) workflow [nf-core/chipseq](https://nf-co.re/chipseq) version 1.2.1. This workflow was chosen because it is well documented, uses reference data, and is reproducible to run using [BioConda](https://bioconda.github.io/) or [Docker containers](https://www.docker.com/). 

Attribution-wise this workflow is open-source, has multiple community authors and a Zenodo DOI for citations <https://doi.org/10.5281/zenodo.3966161>

The [workflow repository in GitHub](https://github.com/nf-core/chipseq/tree/1.2.1) is bundled with test data which at nf-core is used for automated testing. This exemplar therefore runs the workflow with those inputs.


## Reference data

This workflow retrives reference data sets from <https://github.com/nf-core/test-datasets/tree/atacseq> which again come from [ilummina's iGenomes](https://emea.support.illumina.com/sequencing/sequencing_software/igenome.html). This is a good example of reuse of reference data sets that have 


## Results

## BioCompute Object (IEEE 2791)

## RO-Crate

## BagIt


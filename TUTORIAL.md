# Tutorial: Creating a BCO RO-Crate

This tutorial will show how to make the exemplar BCO RO-Crate, starting with a workflow run.

We will run the [Nextflow](https://www.nextflow.io/) workflow [nf-core/chipseq](https://nf-co.re/chipseq) version 1.2.1 using test inputs, capture the results in a BCO which we then describe further as an RO-Crate, and finally package all the files using BagIt.

## Prerequisite: BioConda

This tutorial is based on [Ubuntu 20.04 TLS](https://releases.ubuntu.com/20.04/), but should work on any modern Linux distribution. Instructions may need to be adapted for macOS and Windows, but note this workflow has only been tested on Linux. 

Below we'll use [Conda](https://conda.io/) which can be installed for all major operating systems and will assist in smoothing out their differences as it provides an independent and versioned distribution of a wide range of bioinformatics tools through [BioConda](https://bioconda.github.io/). Conda is also used by Nextflow to install its workflow dependencies.

### Install Conda

First follow instructions for [installing conda](https://bioconda.github.io/user/install.html#install-conda). 

For Linux:

```
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh
```

Follow the instructions in the installer.

### Activate Conda environment

Next we'll activate a
[Conda environment](environment.yml) that installs Nextflow,
Java and UNIX tools needed for this tutorial:

```sh
$ conda env create -f https://raw.githubusercontent.com/stain/bco-ro-example-chipseq/master/environment.yml

Downloading and Extracting Packages
curl-7.71.1          | 139 KB    | ##################################################################################################################### | 100% 
…
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate bco-ro
```

**Tip**: You can activate your own environment file with `-f environment.yml`, or change the environment name with `-n bco-ro`

Next we'll activate the environment and check Nextflow got installed correctly:

```sh
(base) stain@biggie:~/src/bco-ro-example-chipseq$ conda activate bco-ro

(bco-ro) stain@biggie:~/src/bco-ro-example-chipseq$ type nextflow
nextflow is /home/stain/miniconda3/envs/bco-ro/bin/nextflow

(bco-ro) stain@biggie:~/src/bco-ro-example-chipseq$ nextflow -version

      N E X T F L O W
      version 20.07.1 build 5412
      created 24-07-2020 15:18 UTC (16:18 BST)
      cite doi:10.1038/nbt.3820
      http://nextflow.io
```


### Installing Nextflow and Docker separately

If for whatever reason you are unable to use Conda, 
follow the [Nextflow: Getting started](https://www.nextflow.io/) instructions, 
including installing the expected version of Java. 

As this example let Nextflow download workflow dependencies with Conda,
you can instead install and use [Docker](https://www.docker.com/) 
or [Singularity](https://sylabs.io/docs/) containers.

## Starting the BCO RO-Crate

We'll create the BCO RO-Crate inside a new folder. 

```sh
mkdir chipseq_20200924
cd chipseq_20200924
mkdir data
```

Here we use a name `chipseq_20200924` as we ran the workflow `chipseq` on 2020-09-24 - you can use any reasonable name.

The `data/` folder will contain our [RO-Crate](https://stain.github.io/ro-crate/1.1-DRAFT/) according to its [recommendation for combining with BagIt](https://stain.github.io/ro-crate/1.1-DRAFT/appendix/implementation_notes.html#combining-with-other-packaging-schemes).  If you will not be using BagIt you can skip the `data/` subfolder.

Note that running the workflow can take a while, so this might be a good point to [skip ahead](#running-the-workflow) and start the Nextflow run in a separate window.
 
### Skeleton BCO 

We'll start our editor to create skeleton JSON files for the BCO and RO-Crate.

The BCO JSON can have any name - to make its relative paths easy we'll put it in the root of `data/` and we'll name it like the folder `chipseq_20200924.json` which we'll also use as our `object_id`:

**data/chipseq_20200924.json**
```
{
    "object_id": "chipseq_20200924",
    "spec_version": "https://w3id.org/ieee/ieee-2791-schema/",
    "etag": "abcd",
    "provenance_domain": {
        "name": "",
        "version": "",
        "created": "2020-09-24T15:38:00Z",
        "modified": "2020-09-24T15:38:00Z",
        "contributors": [
            {"contribution": ["createdBy"],
             "name": ""
            }   
        ],
        "license": ""
    },
    "usability_domain": [
    ],
    "description_domain": {
        "keywords": [
        ],
        "pipeline_steps": [
        ]
    },
    "execution_domain": {
		"script": [],
        "script_driver": "",
        "software_prerequisites": [
        ],
        "external_data_endpoints": [
        ],
        "environment_variables": {}
    },
    "io_domain": {
      "input_subdomain": [],
      "output_subdomain": []     
    }
}

While the above is valid according to the [IEEE 2791 schemas](https://w3id.org/ieee/ieee-2791-schema/) it has obviously not got much information yet.  

**Tip:** While editing the BCO JSON, have it open as **Input JSON** in <https://www.jsonschemavalidator.net/> with the below schema:

```json
{ "$ref": "https://w3id.org/ieee/ieee-2791-schema/2791object.json"}
```

### ETag

To set the `etag` we need some kind of checksum of the JSON. 

Below is a poor man's attempt of a JSON checksum that ignores "etag" when calculating a new etag, as well as whitespace:

```sh
$ grep -v '"etag"' chipseq_20200924.json  | sed -e ':x /$/ { N; s/\n//g ; bx ; }' | sed 's/\s*//g' | sha256sum
cfb77c3e5c9b0e937de215190106dadcc9af9f40fa19a4deacf9a5a3a42f5de6  -

```json
"etag": "cfb77c3e5c9b0e937de215190106dadcc9af9f40fa19a4deacf9a5a3a42f5de6"
```

We'll need to update the `etag` whenever we substantially change the BCO - so we'll do this again towards the end of this tutorial.

### Provenance domain

The `provenance_domain` describe this BCO overall. Because in this case we are primarily submitting the `nf-core/chipseq` workflow with supporting data we'll reflect the workflow's original creation date and contributors, even though they were not involved in making the workflow's description as a BCO. 

Luckily nf-core has provided [citation info](https://nf-co.re/chipseq#citation) where we can find the authors ([`authoredBy`](http://purl.org/pav/html#http://purl.org/pav/authoredBy)) of the workflow from <https://doi.org/10.5281/zenodo.3240506>.  

We add a `name` with the title from the `nf-core/chipseq` website, as well as their indicated [latest release](https://nf-co.re/chipseq/releases) - at time of writing `"version": "1.2.1"`.  If your workflow does not currently have a version number, consider using [Semantic Versioning](https://semver.org/spec/v2.0.0.html) as recommended by IEEE 2791.

Here `created` reflects the original release date the workflow (which did not include a BCO), we'll set `modified` to current date to reflect when we last updated the BCO JSON (and presumably also changed its `etag`). 

In many cases your workflow will be considered "released" at the same time as the BCO JSON is created by its own authors, in which case this situation is simplified.


```json
"provenance_domain": {
    "name": "nf-core/chipseq: ChIP-seq peak-calling, QC and differential analysis pipeline",
    "version": "1.2.1",
    "created": "2020-07-29T17:33:46+01:00",
    "modified": "2020-09-10T13:11:58+01:00",
    "contributors": [
        {"contribution": ["authoredBy"], "name": "Harshil Patel" },
        {"contribution": ["authoredBy"], "name": "Chuan Wang" },
        {"contribution": ["authoredBy"], "name": "Phil Ewels" },
        {"contribution": ["authoredBy"], "name": "Alexander Peltzer" },
        {"contribution": ["authoredBy"], "name": "Tiago Chedraoui Silva" },
        {"contribution": ["authoredBy"], "name": "Drew Behrens" },
        {"contribution": ["authoredBy"], "name": "Maxime Garcia" },
        {"contribution": ["authoredBy"], "name": "mashehu" },
        {"contribution": ["authoredBy"], "name": "Rotholandus" },
        {"contribution": ["authoredBy"], "name": "Sofia Haglund" },
        {"contribution": ["authoredBy"], "name": "Winni Kretzschmar" },
    ],
    "license": "https://github.com/nf-core/chipseq/blob/1.2.1/LICENSE"
},
```

To find the `license` of the workflow we have to hunt into its GitHub source code <https://github.com/nf-core/chipseq> where we find a [LICENSE](https://github.com/nf-core/chipseq/blob/1.2.1/LICENSE) file - indicated as an _MIT License_. As this particular license includes a copyright statement _Copyright (c) Philip Ewels_ we need to refer to the license in its source repository, rather than the generic SPDX identifier <https://spdx.org/licenses/MIT>. 

For open source licenses like the _Apache License version 2.0_ which are not modified depending on copyright holder, you should instead use their SPDX identifier like <https://spdx.org/licenses/Apache-2.0> (removing `.html`). If your workflow has its own license that is not on the web (e.g. non-open license), use `"license": "LICENSE.txt"` and add the file `data/LICENSE.txt` with your copyright information.

In this case Stian has _created_ the BCO and performed the workflow run, so we'll also add this as a separate contribution to the `contributors` array, ideally including a <https://orcid.org/> identifier to disambiguate from other people with the same name.

```json
{ "contribution": ["createdBy"],
  "name": "Stian Soiland-Reyes",
  "orcid": "https://orcid.org/0000-0001-9842-9718",
} 
```

[PAV contributor relations](http://purl.org/pav/html) [supported by IEEE 2791](https://w3id.org/ieee/ieee-2791-schema/2791object.json) include:

* [authoredBy](http://purl.org/pav/html#http://purl.org/pav/authoredBy) - who originated or gave existence to the work that is expressed by this BCO (who designed the workflow)
* [createdBy](http://purl.org/pav/html#http://purl.org/pav/createdBy) - person who made the representation as saved to disk (JSON of this BCO)
* [createdWith](http://purl.org/pav/html#http://purl.org/pav/createdWith) - software used to create the representation (e.g. [BCO Editor](https://github.com/biocompute-objects/bco_editor))
* [curatedBy](http://purl.org/pav/html#http://purl.org/pav/curatedBy) - who shaped the expression (workflow) into the appropriate format (BCO) or who ensured the quality of the representation (see also `review` key of `provenance_domain`)
* [importedBy](http://purl.org/pav/html#http://purl.org/pav/importedBy) - software that transcribed the work (workflow) to the current form (BCO)
* [providedBy](http://purl.org/pav/html#http://purl.org/pav/providedBy) - original provider of the encoded information (e.g. _nf-core_)
* [retrievedBy](http://purl.org/pav/html#http://purl.org/pav/retrievedBy) - software that retrieved data from external source
* [sourceAccessedBy](http://purl.org/pav/html#http://purl.org/pav/sourceAccessedBy) - someone who consulted an external source of information
* [contributedBy](http://purl.org/pav/html#http://purl.org/pav/contributedBy) - someone who provided any sort of help in conceiving the work (if none of the above match)

These additional PAV relations can also be provided, however we would need to be flexible with their `name` and `orcid` field to give their URIs:

* [derivedFrom](http://purl.org/pav/html#http://purl.org/pav/derivedFrom) - where knowledge was derived from but substantially changed, e.g. a different workflow (see also `derived_from` key of `provenance_domain` if previous was a BCO)
* [importedFrom](http://purl.org/pav/html#http://purl.org/pav/importedFrom) - where knowledge was transcribed from, e.g. <https://nf-co.re/chipseq>
* [retrievedFrom](http://purl.org/pav/html#http://purl.org/pav/retrievedFrom) - where the BCO was directly retrieved from, e.g. <https://raw.githubusercontent.com/stain/bco-ro-example-chipseq/master/data/chipseq_20200910.json>
* [createdAt](http://purl.org/pav/html#http://purl.org/pav/createdAt) - a location the BCO was created at, e.g. `"Manchester, UK"`

### Skeleton RO-Crate

Similarly let's create the high-level [RO-Crate](https://stain.github.io/ro-crate/1.1-DRAFT/). According to the [RO-Crate structure](https://stain.github.io/ro-crate/1.1-DRAFT/structure.html) the RO-Crate Metadata File always have the name `ro-crate-metadata.json` which we'll create inside `data/`:

**data/ro-crate-metadata.json**

```json
{ "@context": "https://w3id.org/ro/crate/1.1-DRAFT/context", 
  "@graph": [
    {
        "@type": "CreativeWork",
        "@id": "ro-crate-metadata.json",
        "conformsTo": {"@id": "https://w3id.org/ro/crate/1.1-DRAFT"},
        "about": {"@id": "./"}
    },
    
    {
      "@id": "./",
      "@type": "Dataset"
    }
  ]
}
```

This preamble  declares the version of the RO-Crate specification used, it's equivalent to BCO's `spec_version`. The remaining RO-Crate elements will be added to the `@graph` array as [data entities](https://stain.github.io/ro-crate/1.1-DRAFT/data-entities.html) (files and directories) or [contextual entities](https://stain.github.io/ro-crate/1.1-DRAFT/contextual-entities.html) (e.g.  people, organizations)

The [root of the RO-Crate](https://stain.github.io/ro-crate/1.1-DRAFT/root-data-entity.html) represents the whole _dataset_, in this case our `data/` folder, but also any external references like the nf-core workflow and reference data. We're going to use the RO-Crate metadata to provide further details on resources and their origin in the world, while the BCO provides finer-grained details of the workflow execution. 

In both cases we will mainly use relative paths within the `data/` directory, where also both metadata files reside. We notice thus that `./` for the root Dataset reflects the `data/` directory.

We'll start by describing the RO-Crate itself under the `./` Dataset, including as a minimum the [core properties of the Root Data Entity](https://stain.github.io/ro-crate/1.1-DRAFT/root-data-entity.html#direct-properties-of-the-root-data-entity), although any of the <http://schema.org/Dataset> properties can be utillized:

```json
{
    "@id": "./",
    "@type": "Dataset",
    "name": "Workflow run of nf-core/chipseq",
    "description": "Workflow run of a ChIP-seq peak-calling, QC and differential analysis pipeline",
    "author": {
    "@id": "https://orcid.org/0000-0001-9842-9718"
    },
    "datePublished": "2020-09-24T23:00:00.000Z",
    "distribution": {
    "@id": "https://github.com/stain/bco-ro-example-chipseq/archive/master.zip"
    },
    "hasPart": [
    {
        "@id": "chipseq_20200910.json"
    }
    ],
    "license": {
    "@id": "https://spdx.org/licenses/CC0-1.0"
    }
}
```

Already you will notice some differences from the BCO. The `name` could match the `provenance_domain/name` of the BCO - but as the BCO focus more on the workflow and the Dataset includes all the files we've changed it to include `"Workflow run of.."`. However if your RO-Crate did not include workflow results, then the two could have the same title. `description` allow us to provide a longer description - comparable to BCO's `usability_domain` which we'll populate later, but again decribing the whole dataset.

The reason these fields are mainly at dataset level is that we can further describe individual files and resources later as separate [data entities](https://stain.github.io/ro-crate/1.1-DRAFT/data-entities.html). Therefore here the `author` of the dataset is  <https://orcid.org/0000-0001-9842-9718>, the ORCID identifier for Stian, as he ran the workflow and gathered (most of) the files, and `license` of the dataset (the whole folder) can be different from the license of the workflow. If need be `license`, `author` etc. can be different on the `ro-crate-metadata.json` entity if someone else made this JSON.

The `hasPart` lists the content of the RO-Crate, currently just the BCO JSON file. We'll describe it as a [data entity](https://stain.github.io/ro-crate/1.1-DRAFT/data-entities.html) and indicate that it is following the IEEE 2791 schemas using `conformsTo` and adding to the `@graph` array:

```json
{
    "@id": "chipseq_20200910.json",
    "@type": "File",
    "name": "chipseq_20200910.json",
    "description": "IEEE 2791 description (BioCompute Object) of nf-core/chipseq",
    "conformsTo": {
        "@id": "https://w3id.org/ieee/ieee-2791-schema/"
    }
}
```

Given the above you can identify programmatically the BCO file `chipseq_20200910.json` 
independent of its filename: Parse `ro-crate-metadata.json` as JSON, then iterate 
over `@graph` array until you find a matching `conformsTo`, then look up its `@id` to
find its (URI escaped) file path within the `data/` folder.


### Assigning unique identifiers to BCOs

If the BCO has a `object_id` that is globally unique, e.g. a 
randomly generated [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) 
then these can be reflected as `identifier` URIs in the RO-Crate. 

This can be useful when looking up BCOs later; RO-Crate Metadata files are valid
[JSON-LD](https://json-ld.org/) and can be loaded into a 
knowledge graph using a _triple store_ like 
[Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/index.html) for 
detailed [querying](https://jena.apache.org/tutorials/sparql.html).


```
$ echo urn:uuid:`uuidgen`
urn:uuid:dc308d7c-7949-446a-9c39-511b8ab40caf
```

So we can change our BCO from the not-so-unique `chipseq_20200924` to:

```json
"object_id": "urn:uuid:dc308d7c-7949-446a-9c39-511b8ab40caf"
```

and add to the `chipseq_20200910.json` entry in `ro-crate-metadata.json`:

```json
"identifier": { "@id": "urn:uuid:dc308d7c-7949-446a-9c39-511b8ab40caf" }
```

## Running the workflow

We'll run the workflow from within the `data/` directory that will contain the BagIt _Payload files_ 
with the outputs of the workflows:

```sh
mkdir -p chipseq_20200924/data
cd chipseq_20200924/data
```

We're going to run the workflow [nf-core/chipseq](https://nf-co.re/chipseq). Nextflow 
allows running of [nf-core](https://nf-co.re) workflows directly by their GitHub short-name.

### Recording

We'll use the `test` profile that runs with preconfigured test data, for using your own inputs
see the [workflow usage](https://nf-co.re/chipseq/1.2.1/docs/usage) instructions.

Because our BCO should be reproducible we need to be concious about which version of the workflow
we are using. At time of writing the latest version is `1.2.1`.

If you are using Docker/Singularity containers instead of Conda, 
change the below `-profile test,conda` to 
`-profile test,docker` or `-profile test,singularity` accordingly.


```sh
$ nextflow run nf-core/chipseq -revision 1.2.1 -profile test,conda

N E X T F L O W  ~  version 20.07.1
Launching `nf-core/chipseq` [small_legentil] - revision: 0f487ed76d [1.2.1]
----------------------------------------------------
                                        ,--./,-.
        ___     __   __   __   ___     /,-._.--~'
  |\ | |__  __ /  ` /  \ |__) |__         }  {
  | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                        `._,._,'
  nf-core/chipseq v1.2.1
----------------------------------------------------
Run Name            : small_legentil
Data Type           : Paired-End
Design File         : https://raw.githubusercontent.com/nf-core/test-datasets/chipseq/design.csv
Genome              : Not supplied
Fasta File          : https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/reference/genome.fa
GTF File            : https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/reference/genes.gtf
MACS2 Genome Size   : 1.2E+7
Min Consensus Reps  : 1
…
```

The workflow will take a while to run. If you previously skipped ahead, now go back to create the [skeleton BCO](#skeleton-bco)

We notice already nf-core reporting inputs of reference datasets. We'll record these in the BCO as:

```json
{"description_domain": {

        "external_data_endpoints": [
          {"name": "Experiment design file for minimal test dataset",
           "url": "https://raw.githubusercontent.com/nf-core/test-datasets/chipseq/design.csv"
          },
          {"name": "iGenomes R64-1-1 Ensembl (Fasta sequence)",
           "url": "https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/reference/genome.fa"
          },
          {"name": "iGenomes R64-1-1 Ensembl (GTF Genes)",
           "url": "https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/reference/genes.gtf"
          }
}
```

(...)

## Listing steps


### Identifying input/output files

The  `input_list` and `output_list`

This form is valid, and use a HTTP _raw_ URI at GitHub. Note that the use of large files on GitHub might require the use of [Git LFS](https://git-lfs.github.com/) which could cause billable charges. The use of S3 bucket is **discouraged** as they are subject to change. Note that the below uses commit `ae950188ef874a9527f2c466354aa19a23ca0043` instead of `master` which again could be subject to change.
 
```json
{"step_number": 3, "name": "MAKE_GENE_BED", "description": "", "input_list": [], "output_list": [
    {"uri": "https://raw.githubusercontent.com/stain/bco-ro-example-chipseq/ae950188ef874a9527f2c466354aa19a23ca0043/data/results/genome/genes.bed",
     "filename": "data/results/genome/genes.bed"
    }
]},
```

We include the relative path under `filename`. It would not be valid to use that path as `uri`; 
the form below uses relative path, which currently is not valid according to the IEEE 2791 JSON Schema:

```json
{"uri": "data/results/genome/genes.bed"},
```

This form uses a `file:///` path which is valid and provides provenance of where the file was made locally, is not portable to other machines:

```json
{"uri": "file:///home/stain/src/bco-ro-example-chipseq/data/results/genome/genes.bed"},
```

This form uses [ARCP URIs inside the RO-Crate](https://www.researchobject.org/ro-crate/1.1-DRAFT/appendix/relative-uris.html#establishing-a-base-uri-inside-a-zip-file) based on the uuid in `bag-info.txt`, but is not valid because `,` wrongly is not permitted in the `uri` JSON Schema format for `authority` (it expects a hostname).

```json
{"uri": "arcp://uuid,9b309ebd-6dfb-4c6d-983b-56b91fca6e06home/data/results/genome/genome.fa.include_regions.bed"},
```
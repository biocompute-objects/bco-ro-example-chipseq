# bco-ro-example-chipseq

Packaging a IEEE 2791 described BioCompute Object as RO-Crate, using a workflow run of [nf-core/chipseq](https://nf-co.re/chipseq) as example. This composition is colloqually called a _BCO RO-Crate_.

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

### execution_domain

The `execution_domain` should refer to actual the workflow script being executed. 

This is a bit of a challenge in this example as we have not bundled the `*.nf` file in the BCO, but ran it by refernece `nf-core/chipseq` which Nextflow then retrieved from GitHub. The web page <https://nf-co.re/chipseq> gives great information for humans, but is in HTML and not executable by workflow engines. 

Taking into consideration the `-revision 1.2.1` we then navigate from <https://nf-co.re/chipseq> to <https://github.com/nf-core/chipseq>, select the [tag 1.2.1](https://github.com/nf-core/chipseq/tree/1.2.1) and find <https://github.com/nf-core/chipseq/blob/1.2.1/main.nf> - but again this is HTML, so we use the **Raw** button to find <https://raw.githubusercontent.com/nf-core/chipseq/1.2.1/main.nf>.

This can then be described in the BCO in the `script` array, for `script_driver` we use `nextflow` as it matches the command line (Note: there is currently no registry of known `script_driver` values).

```json
    "execution_domain": {
        "script": ["https://raw.githubusercontent.com/nf-core/chipseq/1.2.1/main.nf"],
        "script_driver": "nextflow"
    }
```

We can annotate the other URIs like <https://nf-co.re/chipseq> in the RO-Crate, as they give additional information for the user.

A challenge here is that we have not indicated how the workflow engine itself should be invoked on the command line. Should we instead have listed our [run.sh](run.sh) that invokes Nextflow? (We would need to move `run.sh` into `data/` to make it part of the RO-Crate)

```json
    "execution_domain": {
        "script": ["run.sh"],
        "script_driver": "shell"
    }
```

In one way this is more useful, as it directly executable - at least if the Conda [environment.yml](environment.yml) has been activated. On the other side `run.sh` provides absolutely no details about the data analysis performed, and as the purpose of the BCO is to submit a workflow, we instead show the `main.nf` that lists the individual steps, matching the `pipeline_steps` section of the BCO.


## RO-Crate

[data/ro-crate-metadata.json](data/ro-crate-metadata.json) is a JSON-LD file conforming to [RO-Crate Metadata specification 1.1-DRAFT](https://www.researchobject.org/ro-crate/1.1-DRAFT/)

Here the role of the RO-Crate is to type, relate and describe the individual files in this package. This includes external references, licenses and attributions to authors. This may seem like overlap from the BCO, but as it is here per file it can distinguish more complicated situations such as the reference datasets.

## BagIt

[bagit.txt](bagit.txt), [bag-info.txt](bag-info.txt), [manifest-sha512.txt](manifest-sha512.txt) and [tagmanifest-sha512.txt](tagmanifest-sha512.txt) conform to [BagIt (RFC8493)](https://www.rfc-editor.org/rfc/rfc8493.html).

The role of the BagIt is mainly ensure all files are present and not modified or corrupted in transfer. The roles of the files are as follows:

* [bagit.txt](bagit.txt) — BagIt [declaration](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.1.1)
* [bag-info.txt](bag-info.txt) — BagIt [metadata](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.2.2)
* [manifest-sha512.txt](manifest-sha512.txt) — [Payload manifest](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.1.3), checksums of all `data/` files
* [tagmanifest-sha512.txt](tagmanifest-sha512.txt) — [Tag manifest](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.2.1), checksums of other files

### BagIt declaration

[bagit.txt](bagit.txt) should have this fixed content:

```
BagIt-Version: 1.0
Tag-File-Character-Encoding: UTF-8
```

The main role of this file is to mark the folder as a bag according to [RFC8493](https://www.rfc-editor.org/rfc/rfc8493.html). The base directory containing `bagit.txt` can have any name, and can be transferred in any way, e.g. [ZIP](https://github.com/stain/bco-ro-example-chipseq/archive/master.zip), SFTP or even be exposed [on the web](https://raw.githubusercontent.com/stain/bco-ro-example-chipseq/master/bagit.txt). 

### Payload manifest

[manifest-sha512.txt](manifest-sha512.txt) contain [SHA-512 checksums](https://en.wikipedia.org/wiki/SHA-2) of **all** files under [data/](data/) directory, e.g.:

```
41846747…ee71  data/ro-crate-metadata.json
e1105ed0…5e13  data/chipseq_20200910.json
37fd3a02…bb95  data/results/pipeline_info/design_reads.csv
…
```

Creating this file without using BagIt tools/libraries can be done as:

```sh
$ find data -type f -print0 | xargs -0 sha512sum > manifest-sha512.txt
```

Similarly checking the file:

```sh
$ sha512sum --quiet -c manifest-sha512.txt 
data/chipseq_20200910.json: FAILED
data/ro-crate-metadata.json: FAILED
sha512sum: WARNING: 2 computed checksums did NOT match
```

Notice how the BagIt _payload manifest_ list checksums of all individual data outputs in [data/results], as well as the RO-Crate [data/ro-crate-metadata.json](data/ro-crate-metadata.json) and the IEEE 2791 BCO JSON [data/chipseq_20200910.json](data/chipseq_20200910.json). Although these files are strictly speaking _metadata_ we can consider them part of the `data/` _payload_ of transfering an RO-Crate-described BioCompute Object, as [recommended by RO-Crate 1.0](https://w3id.org/ro/crate/1.0#example-of-adding-ro-crate-to-bagit).

Alternative checksums algorithm are allowed [according to RFC8493](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.4), e.g. `manifest-sha256.txt` - as long as each manifest file is complete - here we use SHA-512 by default as recommended by RFC8493.

### Tag manifest

In BagIt it is optional to also checksum files outside `data/`, so-called [tag files](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.2.1), as in [tagmanifest-sha512.txt](tagmanifest-sha512.txt). Because we have included the RO-Crate under `data/` these files are in examples are mainly about creating the BagIt BCO, such as this README file, and the BagIt files like `bagit.txt` `manifest-sha512.txt`

```
b0556450…8802  bag-info.txt
1abe59bd…969a  Makefile
b5598554…256d  README.md
000b27e3…c52e  manifest-sha512.txt
…
```

Unlike the _payload manifest_ above this file does not need to be complete (e.g. it does not list itself!), however we recommend it minimally includes `bag-info.txt` and `manifest-sha512.txt` to ensure these files are complete.

Creating the tag manifest without BagIt files is best achieved by listing individual files:

```sh
$ sha512sum bagit.txt bag-info.txt manifest-sha512.txt > tagmanifest-sha512.txt
```

### BagIt metadata

[bag-info.txt](bag-info.txt) contains [Bag-It metadata](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.2.2) in a loose key-value based textual format to the describe the bag, primarily for the purpose of transfer.


Our example is quite minimal:

```
ROCrate_Specification_Identifier: https://w3id.org/ro/crate/1.0/
External-Description: Workflow run of a ChIP-seq peak-calling, QC and differential analysis pipeline
Bagging-Date: 2020-09-10T19:27:45Z
Payload-Oxum: 414893243.372
Bag-Size: 396MB
```

`ROCrate_Specification_Identifier` is an additional key used by [RO-Crate Describo](https://uts-eresearch.github.io/describo/) to indicate the version of [data/ro-crate-metadata.json](data/ro-crate-metadata.json). This string SHOULD match the [`conformsTo`](data/ro-crate-metadata.json#L7) URI.

`Payload-Oxum` is a compound field listing the total size of `data/` files in bytes, and the number of payload files (excluding directories). These numbers could be obtained with:

```sh
$ du --apparent-size -b -s data
414893243	data
$ du --apparent-size --human-readable -s data
396M	data
$ find data -type f | wc -l
372
```

(Note the use of `--apparent-size` as in this case actual disk-usage is 129M due to ZFS compression)

This example from RFC8493 lists other keys that MAY be used:

```
Source-Organization: FOO University
Organization-Address: 1 Main St., Cupertino, California, 11111
Contact-Name: Jane Doe
Contact-Phone: +1 111-111-1111
Contact-Email: example@example.com
External-Description: Uncompressed greyscale TIFF images from the
        FOO papers colle...
Bagging-Date: 2008-01-15
External-Identifier: university_foo_001
Payload-Oxum: 279164409832.1198
Bag-Group-Identifier: university_foo
Bag-Count: 1 of 15
Internal-Sender-Identifier: /storage/images/foo
Internal-Sender-Description: Uncompressed greyscale TIFFs created
        from microfilm and are...
```

However, as metadata would mainly be covered by the [bco](data/chipseq_20200910.json) and [RO-Crate](data/ro-crate-metadata.json) we recommend keeping `bag-info.txt` minimal for transfer-level metadata. 
# Update according to https://opensource.ieee.org/2791-object/ieee-2791-schema/-/releases
IEEE2791_VERSION=1.4
BCO=data/chipseq_20200910.json

all: test

test: test-bagit test-ro test-bco

pre-dependencies:
	# Pre-flight check for dependencies needed by make
	tar --version
	curl --version
	mktemp --version

dependencies: pre-dependencies .lib/ieee-2791-schema-version-${IEEE2791_VERSION}/	
	# Checking dependencies are installed
	python --version
	nextflow -v
	bagit.py --version
	jsonschema --version
	jsonschema .lib/ieee-2791-schema-version-1.4/2791object.json
	rdfpipe --version

.lib/ieee-2791-schema-version-1.4/: pre-dependencies
	mkdir -p .lib/
	curl -L https://opensource.ieee.org/2791-object/ieee-2791-schema/-/archive/version-${IEEE2791_VERSION}/ieee-2791-schema-version-${IEEE2791_VERSION}.tar.gz | tar xzv --directory=.lib/

bagit: manifest-sha512.txt tagmanifest-sha512.txt

manifest-sha512.txt: data
	find data -type f -print0 | xargs -0 sha512sum > manifest-sha512.txt

tagmanifest-sha512.txt: bag-info.txt environment.yml LICENSE Makefile README.md run.sh
	sha512sum bag-info.txt environment.yml LICENSE Makefile README.md run.sh > tagmanifest-sha512.txt

test-bagit: bagit
	# Checking bagit manifests
	bagit.py --quiet --validate .

test-bco: dependencies ${BCO}
	# Check if BCO is valid according to IEEE 2791 JSON Schemas
	jsonschema .lib/ieee-2791-schema-version-1.4/2791object.json -i ${BCO}

test-ro: data/ro-crate-metadata.json 
	# Check if RO-Crate Metadata File is valid JSON-LD
	rdfpipe -i json-ld --no-out data/ro-crate-metadata.json 
	# Check some of the triples in RO-Crate Metadata
	mkdir -p .tmp
	rdfpipe -i json-ld -o ntriples data/ro-crate-metadata.json > .tmp/ro-crate.nt
	egrep -q '<http://schema.org/Dataset>' .tmp/ro-crate.nt
	egrep -q 'ro-crate-metadata.json>.*about>.*/data/>' .tmp/ro-crate.nt
	egrep -q '/data/>.*hasPart>.*/${BCO}>' .tmp/ro-crate.nt
	egrep -q '/${BCO}>.*conformsTo>.*<https://w3id.org/ieee/ieee-2791-schema/>' .tmp/ro-crate.nt
	rm -rf .tmp


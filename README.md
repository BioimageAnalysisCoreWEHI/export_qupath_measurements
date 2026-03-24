# export_qupath_measurements

Nextflow pipeline for exporting image measurements from QuPath projects in headless mode.

## What it does

- Runs QuPath in CLI headless mode using a Groovy script.
- Exports one CSV per image in the QuPath project.
- Publishes outputs to a Nextflow output directory.

## Required inputs

- `--project`: Path to QuPath `.qpproj` file.

Optional:

- `--qupath_bin`: Path to QuPath executable (default: `/stornext/System/data/software/rhel/9/base/tools/QuPath/0.6.0/bin/QuPath`).
- `--script`: Path to Groovy export script (default: `bin/export_image_measurements_indiv.groovy`).
	Relative paths are resolved from the pipeline directory.
- `--outdir`: Output directory (default: `results`).

## Usage

Local/interactive run:

```bash
nextflow run main.nf \
	--project /path/to/project.qpproj \
	--qupath_bin /stornext/System/data/software/rhel/9/base/tools/QuPath/0.6.0/bin/QuPath \
	--outdir /path/to/output
```

HPC run with Singularity + medium resources:

```bash
nextflow run main.nf \
	-profile singularity,medium \
	--project /path/to/project.qpproj \
	--qupath_bin /stornext/System/data/software/rhel/9/base/tools/QuPath/0.6.0/bin/QuPath \
	--outdir /path/to/output
```

## Outputs

- `measurements/` folder containing one CSV per image from the project
- `qupath_export.log` containing QuPath export logs

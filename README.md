# export_qupath_measurements

Nextflow pipeline for exporting image measurements from QuPath projects in headless mode.

## What it does

- Runs QuPath in CLI headless mode using a Groovy script.
- Exports one CSV per image in the QuPath project.
- Publishes outputs to a Nextflow output directory.

## Required inputs

- `--project`: Path to QuPath `.qpproj` file.
- `--qupath_bin`: Path to QuPath executable (for example `/vast/projects/project_name/QuPath/bin/QuPath`).

Optional:

- `--script`: Path to Groovy export script (default: `bin/export_image_measurements_indiv.groovy`).
- `--outdir`: Output directory (default: `results`).

## Usage

Local/interactive run:

```bash
nextflow run main.nf \
	--project /path/to/project.qpproj \
	--qupath_bin /vast/projects/project_name/QuPath/bin/QuPath \
	--outdir /path/to/output
```

HPC run with Singularity + medium resources:

```bash
nextflow run main.nf \
	-profile singularity,medium \
	--project /path/to/project.qpproj \
	--qupath_bin /vast/projects/SOLACE2/QuPath/bin/QuPath \
	--outdir /path/to/output
```

## Outputs

- `measurements/` folder containing one CSV per image from the project
- `qupath_export.log` containing QuPath export logs

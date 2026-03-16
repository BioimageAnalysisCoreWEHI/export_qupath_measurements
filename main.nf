nextflow.enable.dsl = 2

params.project = null
params.qupath_bin = null
params.script = "${projectDir}/bin/export_image_measurements_indiv.groovy"
params.outdir = "results"
params.publish_dir_mode = "copy"
params.validate_params = true

process EXPORT_QUPATH_MEASUREMENTS {
    tag { project_path.tokenize('/').last() }
    label 'process_medium'

    publishDir "${params.outdir}", mode: params.publish_dir_mode

    input:
    tuple val(project_path), val(qupath_bin), val(script_path)

    output:
    path "measurements"
    path "qupath_export.log"

    script:
    """
    set -euo pipefail

    if [[ ! -f "${project_path}" ]]; then
      echo "ERROR: QuPath project not found: ${project_path}" >&2
      exit 1
    fi

    if [[ ! -x "${qupath_bin}" ]]; then
      echo "ERROR: QuPath binary is not executable: ${qupath_bin}" >&2
      exit 1
    fi

    if [[ ! -f "${script_path}" ]]; then
      echo "ERROR: Groovy script not found: ${script_path}" >&2
      exit 1
    fi

    mkdir -p measurements
    export QUPATH_EXPORT_DIR="\$(pwd)/measurements"

    "${qupath_bin}" script "${script_path}" --project "${project_path}" \
      2>&1 | tee qupath_export.log
    """
}

workflow {
    if (!params.project) {
        error "Missing required parameter: --project"
    }
    if (!params.qupath_bin) {
        error "Missing required parameter: --qupath_bin"
    }

    def projectFile = file(params.project)
    if (!projectFile.exists()) {
        error "Project file does not exist: ${params.project}"
    }

    def qupathExe = file(params.qupath_bin)
    if (!qupathExe.exists()) {
        error "QuPath binary does not exist: ${params.qupath_bin}"
    }

    def scriptFile = file(params.script)
    if (!scriptFile.exists()) {
        error "Groovy script does not exist: ${params.script}"
    }

    Channel
        .of(tuple(projectFile.toString(), qupathExe.toString(), scriptFile.toString()))
        | EXPORT_QUPATH_MEASUREMENTS
}

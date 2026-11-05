process MSNBASEXIC {
    label 'process_single'
    tag "$meta.id"

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    'community.wave.seqera.io/library/bioconductor-msnbase_r-ggplot2_r-optparse_r-pracma_r-readr:83cd263d3bfd0c9e' :
    'community.wave.seqera.io/library/bioconductor-msnbase_r-ggplot2_r-optparse_r-pracma_r-readr:83cd263d3bfd0c9e' }"

    input:
        tuple val(meta), path(mzml_file)
        path tsv_file

    output:
        tuple val(meta), path("*_mqc.json"), emit: xic_output
        path "versions.yml", emit: versions

    when:
        task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    msnbasexic.R \\
      --file_name ${mzml_file} \\
      --tsv_name ${tsv_file} \\
      ${args}
    """
}

process MERGEJSONS {
    label 'process_single'
    tag "merge_jsons"

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    // Singularity (ociAutoPull via Wave)
    'community.wave.seqera.io/library/bioconductor-msnbase_r-ggplot2_r-optparse_r-pracma_r-readr:83cd263d3bfd0c9e' :
    // Docker/Wave
    'community.wave.seqera.io/library/bioconductor-msnbase_r-ggplot2_r-optparse_r-pracma_r-readr:83cd263d3bfd0c9e' }"

    input:
        path(json_files, stageAs: "merge_jsons_input/*")

    output:
    path("*_merged_mqc.json"), emit: merged_jsons


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    mergejsons.R \\
      ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        r-base: \$( Rscript --version 2>&1 )
    END_VERSIONS
    """
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { paramsSummaryMap        } from 'plugin/nf-schema'
include { softwareVersionsToYAML  } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText  } from '../subworkflows/local/utils_nfcore_ribomsqc_pipeline'
include { THERMORAWFILEPARSER     } from '../modules/nf-core/thermorawfileparser/main'
include { MSNBASEXIC              } from '../modules/local/msnbasexic/main'
include { MULTIQC                 } from '../modules/nf-core/multiqc/main'
include { MERGEJSONS              } from '../modules/local/mergejsons/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow RIBOMSQC {

    take:
    input_ch

    main:
        ch_versions = Channel.empty()

<<<<<<< HEAD
    ch_versions = channel.empty()

    //
    // Collate and save software versions
    //
    def topic_versions = Channel.topic("versions")
        .distinct()
        .branch { entry ->
            versions_file: entry instanceof Path
            versions_tuple: true
        }

    def topic_versions_string = topic_versions.versions_tuple
        .map { process, tool, version ->
            [ process[process.lastIndexOf(':')+1..-1], "  ${tool}: ${version}" ]
        }
        .groupTuple(by:0)
        .map { process, tool_versions ->
            tool_versions.unique().sort()
            "${process}:\n${tool_versions.join('\n')}"
        }

    softwareVersionsToYAML(ch_versions.mix(topic_versions.versions_file))
        .mix(topic_versions_string)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info",
            name: 'nf_core_'  +  'ribomsqc_software_'  + 'versions.yml',
            sort: true,
            newLine: true
        ).set { ch_collated_versions }
=======
        /*
        --------------------------------------------------------------------------------
        MODULE: Run THERMORAWFILEPARSER
        --------------------------------------------------------------------------------
        */
        THERMORAWFILEPARSER(
            input_ch
        )

        ch_versions = ch_versions.mix(THERMORAWFILEPARSER.out.versions)
>>>>>>> origin/dev

        /*
        --------------------------------------------------------------------------------
        MODULE: Run MSNBASEXIC
        --------------------------------------------------------------------------------
        */
        MSNBASEXIC(
            THERMORAWFILEPARSER.out.spectra,
            Channel.value(file(params.analytes_tsv, checkIfExists: true))
        )

        ch_versions = ch_versions.mix(MSNBASEXIC.out.versions)

        /*
        --------------------------------------------------------------------------------
        MODULE: Extract XIC Files
        --------------------------------------------------------------------------------
        */
        xic_files_ch         = MSNBASEXIC.out.xic_output
        ch_mqc_jsons_current = xic_files_ch.map { it -> it[1] }

        /*
        --------------------------------------------------------------------------------
        MODULE: Merge MQC JSONs
        --------------------------------------------------------------------------------
        */
        ch_merge_input = ch_mqc_jsons_current
            .collect()

        MERGEJSONS(ch_merge_input)

        MERGEJSONS.out.merged_jsons
            .flatten()
            .collect()
            .set { ch_multiqc_files }

        /*
        --------------------------------------------------------------------------------
        MODULE: Run MULTIQC
        --------------------------------------------------------------------------------
        */
        MULTIQC([], [], [], [], ch_multiqc_files, [])

        /*
        --------------------------------------------------------------------------------
        Collate and Save Software Versions
        --------------------------------------------------------------------------------
        */
        softwareVersionsToYAML(ch_versions)
            .collectFile(
                storeDir : "${params.outdir}/pipeline_info",
                name     : 'nf_core_' + 'ribomsqc_software_' + 'versions.yml',
                sort     : true,
                newLine  : true
            ).set { ch_collated_versions }

    emit:
    versions       = ch_versions
    spectra        = THERMORAWFILEPARSER.out.spectra
    xic_output     = MSNBASEXIC.out.xic_output
    multiqc_report = MULTIQC.out.report
}

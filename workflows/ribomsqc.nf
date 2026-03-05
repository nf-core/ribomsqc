/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { paramsSummaryMap        } from 'plugin/nf-schema'
include { softwareVersionsToYAML  } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText  } from '../subworkflows/local/utils_nfcore_ribomsqc_pipeline'
include { THERMORAWFILEPARSER     } from '../modules/nf-core/thermorawfileparser/main'
include { MSNBASEXIC              } from '../modules/local/msnbasexic/main'
include { MULTIQC                 } from '../modules/nf-core/multiqc/main'
include { MERGEJSONS              } from '../modules/local/mergejsons/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow RIBOMSQC {

    take:
        input_ch

    main:
        ch_versions = Channel.empty()

        /*
        --------------------------------------------------------------------------------
        MODULE: Run THERMORAWFILEPARSER
        --------------------------------------------------------------------------------
        */
        THERMORAWFILEPARSER(
            input_ch
        )

        ch_versions = ch_versions.mix(THERMORAWFILEPARSER.out.versions)

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
        ch_mqc_jsons_current = MSNBASEXIC.out.xic_output.map { _meta, json -> json }

        /*
        --------------------------------------------------------------------------------
        MODULE: Merge MQC JSONs
        --------------------------------------------------------------------------------
        */
        MERGEJSONS(
            ch_mqc_jsons_current.collect()
        )

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
            )

    emit:
        versions       = ch_versions
        spectra        = THERMORAWFILEPARSER.out.spectra
        xic_output     = MSNBASEXIC.out.xic_output
        multiqc_report = MULTIQC.out.report
}

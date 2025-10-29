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
        mzml_ch             = THERMORAWFILEPARSER.out.spectra
        analytes_tsv_ch     = Channel.value(file(params.analytes_tsv, checkIfExists: true))
        analyte_ch          = Channel.value(params.analyte)
        rt_tol_ch           = Channel.value(params.rt_tolerance)
        mz_tol_ch           = Channel.value(params.mz_tolerance)
        ms_level_ch         = Channel.value(params.ms_level)
        plot_xic_ms1_ch     = Channel.value(params.plot_xic_ms1)
        plot_xic_ms2_ch     = Channel.value(params.plot_xic_ms2)
        plot_output_path_ch = Channel.value(params.plot_output_path)
        overwrite_tsv_ch    = Channel.value(params.overwrite_tsv)

        MSNBASEXIC(
            mzml_ch,
            analytes_tsv_ch
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
        def outdir_path = file("${workflow.launchDir}/${params.outdir}")

        ch_mqc_jsons_previous = (outdir_path.exists()) ?
            Channel.fromPath("${outdir_path}/**/*_mqc.json") :
            Channel.empty()

        ch_merge_input = ch_mqc_jsons_current
            .mix(ch_mqc_jsons_previous)
            .distinct()
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

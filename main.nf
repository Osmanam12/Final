#!/usr/bin/env nextflow

include { SEMINAR  } from './workflows/seminar'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_seminar_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_seminar_pipeline'
include { getGenomeAttribute      } from './subworkflows/local/utils_nfcore_seminar_pipeline'

params.fasta = getGenomeAttribute('fasta')

workflow NFCORE_SEMINAR {

    take:
    samplesheet // channel: samplesheet read in from --input

    main:

    SEMINAR (
        samplesheet
    )
    emit:
    multiqc_report = SEMINAR.out.multiqc_report // channel: /path/to/multiqc_report.html
}

workflow {

    main:

    PIPELINE_INITIALISATION (
        params.version,
        params.validate_params,
        params.monochrome_logs,
        //args,
        params.outdir,
        params.input
    )

    NFCORE_SEMINAR (
        PIPELINE_INITIALISATION.out.samplesheet )
   
    PIPELINE_COMPLETION (
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
        params.hook_url,
        NFCORE_SEMINAR.out.multiqc_report
    )
}

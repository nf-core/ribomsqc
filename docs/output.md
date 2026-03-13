# nf-core/ribomsqc: Output

## Introduction

This document describes the output produced by the pipeline.
After execution, the following directories will be created under the top-level `results/` directory, each containing key output files necessary for downstream QC and reporting.

## Pipeline overview

The pipeline is implemented with [Nextflow](https://www.nextflow.io/) and executes the following major steps:

1. **ThermoRawFileParser** – Conversion of raw instrument files
2. **MSNBASEXIC** – Extract chromatographic peaks and calculate per-analyte QC metrics
3. **Merge JSONs** – Consolidation of individual QC metric JSONs into merged summaries
4. **MultiQC** – Aggregation and visualization of QC metrics
5. **Pipeline information** – Generation of execution reports and parameter logs

---

## ThermoRawFileParser

<details markdown="1">
<summary>Output files</summary>

- `thermorawfileparser/`
  - `*.mzML`: `.raw` file convert to format suitable for downstream processing.

</details>

---

## XIC results

<details markdown="1">
<summary>Output files</summary>

- `msnbasexic/`
  - Contains one `.json` file **per sample and per analyte**, named according to the QC metrics and sample ID (e.g. `dmz_ppm_Day_5_mqc.json`).
  - Format: structured JSON capturing extracted chromatographic metrics for each analyte, such as retention time, peak area, mass accuracy and FWHM.
  - These files represent the core QC outputs generated from XIC extraction and can be used for both individual review and longitudinal performance assessment.

</details>

---

## Merge JSONs

<details markdown="1">
<summary>Output files</summary>

- `mergejsons/`
  - This folder contains JSON files summarizing QC metrics across all samples for each parameter. These are used by MultiQC for report generation.
  - Files include:
    - `dmz_ppm_merged_mqc.json`: Summary of mass accuracy deviations (Δm/z in ppm) for each analyte across samples.
    - `FWHM_merged_mqc.json`: Full Width at Half Maximum values for chromatographic peaks, used to assess peak sharpness and consistency.
    - `Log2_Total_Area_merged_mqc.json`: Log2-transformed total peak areas, serving as a proxy for relative analyte abundance and signal stability.
    - `Observed_RT_sec_merged_mqc.json`: Observed retention times (in seconds) across samples, useful for detecting RT drift over time.

Each of these **merged** JSON files consolidates multiple per-sample (or per-file) JSON outputs for the same QC metric into a single array. For example, all individual `dmz_ppm.json` fragments from different samples are combined into `dmz_ppm_merged_mqc.json`. This ensures that each parameter’s values across all samples are gathered in one file, formatted for seamless ingestion by MultiQC and unified visualization of QC trends.

</details>

---

## MultiQC report

<details markdown="1">
<summary>Output files</summary>

- `multiqc/`
  - `multiqc_report.html`: Interactive HTML report aggregating XIC-derived tables and merged JSON metrics.
  - `multiqc_data/`: Directory containing raw data inputs for MultiQC, including the merged QC JSON files.

</details>

---

## Pipeline information

<details markdown="1">
<summary>Output files</summary>

- `pipeline_info/`
  - Nextflow execution artifacts: `execution_report.html`, `execution_timeline.html`, `execution_trace.txt`, `pipeline_dag.dot`/`pipeline_dag.svg`
  - Pipeline software versions: `nf_core_ribomsqc_software_versions.yml`
  - Run parameters: `params.json` (only if `-saveParams true` is set)

</details>

For more details on Nextflow execution reports and troubleshooting, refer to the [Nextflow documentation](https://www.nextflow.io/docs/latest/tracing.html).

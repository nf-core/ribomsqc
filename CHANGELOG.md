# nf-core/ribomsqc: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.1.0 - 2026-11-05

### `Added`

- #46 - Manifest contributors metadata

### `Changed`

- #45 - Template updates for nf-core/tools 4.0.0, 4.0.2, 4.0.3, 4.1.0 and 4.2.1
- #45 - Bump minimum Nextflow version to >= 25.10.4
- #45 - Remove Slack notification feature with the template 4.x sync
- #46 - manifest.defaultBranch set to dev
- #46 - Drop duplicate nextflow.enable.moduleBinaries declaration inside params
- #46 - Remove dead MSNBASEXIC ext.args block from nextflow.config
- #46 - Deduplicate .nf-core.yml ignore entries
- #46 - docs/usage.md: remove duplicated header and params line

### `Fixed`

- #42 - Remove vulnerable PR-comment artifact pattern
- #44 - Switch fix-linting to the hardened nf-core/actions reusable workflow
- #45 - Fix nf-test versions snapshot (real versions file content, stable assertions)
- #46 - README Zenodo badge DOI updated to 10.5281/zenodo.18998042
- #46 - CHANGELOG dead links to the archived proteomicsunitcrg/ribomsqc repo replaced by plain #27 refs

### `Dependencies`

- #46 - Align MSNBASEXIC conda environment with the production image: r-base 4.4.3, bioconductor-msnbase 2.32.0, r-ggplot2 3.5.1, r-pracma 2.4.4
- #49 - Fix MSNBASEXIC conda environment for R 4.4.3: r-optparse 1.7.5, r-readr 2.1.5, r-jsonlite 1.9.1, r-glue 1.8.0 (previous pins had no R 4.4 builds and were unresolvable)

## v1.0.0 - 2026-03-11

### `Added`

- #27 - Added new quantification markers to XIC line plots for enhanced interpretability
- #27 - Accumulate TSV export with overwrite toggle
- #27 - Add MS level to section_name in MultiQC JSON output
- #27 - Enhance XIC plots with FWHM and PPP threshold visualization
- #27 - Add support for --analyte_name all to process all TSV entries
- #27 - Support for `MultiQC` as module to aggregate results.
- #27 - Custom `MSNBASEXIC` module to extract and plot XICs.
- #27 - Support for ThermoRawFileParser module to convert RAW to mzML.
- #27 - Initial implementation of the pipeline.

### `Changed`

- #27 - Remove unused ch_mqc_jsons_previous logic from workflow
- #27 - Bump MultiQC from 1.28 to 1.33
- #27 - Improved logging clarity and enhanced plot aesthetics
- #27 - Corrected MS2 peak extraction logic with accurate precursor matching
- #27 - Refined internal logic of the XIC extraction algorithm

### `Fixed`

- #27 - Resolved issue causing missing JSON output entries for certain analytes
- #27 - Harmonized XIC plot styling, layout and retention time interval handling
- #27 - Preserve MS level in mergejsons
- #27 - Fixed FWHM interpolation logic

### `Dependencies`

| Dependency                 | Version |
| -------------------------- | ------- |
| `ThermoRawFileParser`      | 1.4.5   |
| `bioconductor-msnbase (R)` | 2.32.0  |
| `MultiQC`                  | 1.33    |

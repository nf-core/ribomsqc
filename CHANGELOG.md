# nf-core/ribomsqc: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.1.0 - 2026-11-18

### `Added`

- [#46](https://github.com/nf-core/ribomsqc/pull/46) - Manifest contributors metadata

### `Changed`

- [#45](https://github.com/nf-core/ribomsqc/pull/45) - Template updates for nf-core/tools 4.0.0, 4.0.2, 4.0.3, 4.1.0 and 4.2.1
- [#45](https://github.com/nf-core/ribomsqc/pull/45) - Bump minimum Nextflow version to >= 25.10.4
- [#45](https://github.com/nf-core/ribomsqc/pull/45) - Remove Slack notification feature with the template 4.x sync
- [#46](https://github.com/nf-core/ribomsqc/pull/46) - Drop duplicate nextflow.enable.moduleBinaries declaration inside params
- [#46](https://github.com/nf-core/ribomsqc/pull/46) - Remove dead MSNBASEXIC ext.args block from nextflow.config
- [#46](https://github.com/nf-core/ribomsqc/pull/46) - Deduplicate .nf-core.yml ignore entries
- [#46](https://github.com/nf-core/ribomsqc/pull/46) - docs/usage.md: remove duplicated header and params line
- [#50](https://github.com/nf-core/ribomsqc/pull/50) - Widen dmz_ppm MultiQC plot y-axis window from +/-3 to +/-5 ppm
- [#52](https://github.com/nf-core/ribomsqc/pull/52) - Sync template to nf-core/tools 4.2.2 (setup-apptainer action v3 in CI)
- [#53](https://github.com/nf-core/ribomsqc/pull/53) - Add 'Adding a new instrument' sub-page under docs/usage/
- [#54](https://github.com/nf-core/ribomsqc/pull/54) - Drop stale files_unchanged entries (branch.yml, linting.yml) from .nf-core.yml
- [#55](https://github.com/nf-core/ribomsqc/pull/55) - docs/usage/adding_a_new_instrument.md: clarify that the operations layer described is one institution's reference example
- [#55](https://github.com/nf-core/ribomsqc/pull/55) - Remove TODO nf-core metro map comment from nextflow.config

### `Fixed`

- [#42](https://github.com/nf-core/ribomsqc/pull/42) - Remove vulnerable PR-comment artifact pattern
- [#44](https://github.com/nf-core/ribomsqc/pull/44) - Switch fix-linting to the hardened nf-core/actions reusable workflow
- [#45](https://github.com/nf-core/ribomsqc/pull/45) - Fix nf-test versions snapshot (real versions file content, stable assertions)
- [#46](https://github.com/nf-core/ribomsqc/pull/46) - README Zenodo badge DOI updated to 10.5281/zenodo.18998042
- [#46](https://github.com/nf-core/ribomsqc/pull/46), [#55](https://github.com/nf-core/ribomsqc/pull/55) - CHANGELOG PR references in the v1.0.0 section relinked to the current repo (dead archived-repo links removed)
- [#55](https://github.com/nf-core/ribomsqc/pull/55) - README nf-core template badge bumped to 4.2.2 (consistent with .nf-core.yml)
- [#55](https://github.com/nf-core/ribomsqc/pull/55) - manifest: doi set to 1.0.0 Zenodo DOI (10.5281/zenodo.18998042)

### `Dependencies`

- [#46](https://github.com/nf-core/ribomsqc/pull/46) - Align MSNBASEXIC conda environment with the production image: r-base 4.4.3, bioconductor-msnbase 2.32.0, r-ggplot2 3.5.1, r-pracma 2.4.4
- [#49](https://github.com/nf-core/ribomsqc/pull/49) - Fix MSNBASEXIC conda environment for R 4.4.3: r-optparse 1.7.5, r-readr 2.1.5, r-jsonlite 1.9.1, r-glue 1.8.0 (previous pins had no R 4.4 builds and were unresolvable)

## v1.0.0 - 2026-03-11

### `Added`

- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Added new quantification markers to XIC line plots for enhanced interpretability
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Accumulate TSV export with overwrite toggle
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Add MS level to section_name in MultiQC JSON output
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Enhance XIC plots with FWHM and PPP threshold visualization
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Add support for --analyte_name all to process all TSV entries
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Support for `MultiQC` as module to aggregate results.
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Custom `MSNBASEXIC` module to extract and plot XICs.
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Support for ThermoRawFileParser module to convert RAW to mzML.
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Initial implementation of the pipeline.

### `Changed`

- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Remove unused ch_mqc_jsons_previous logic from workflow
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Bump MultiQC from 1.28 to 1.33
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Improved logging clarity and enhanced plot aesthetics
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Corrected MS2 peak extraction logic with accurate precursor matching
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Refined internal logic of the XIC extraction algorithm

### `Fixed`

- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Resolved issue causing missing JSON output entries for certain analytes
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Harmonized XIC plot styling, layout and retention time interval handling
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Preserve MS level in mergejsons
- [#27](https://github.com/nf-core/ribomsqc/pull/27) - Fixed FWHM interpolation logic

### `Dependencies`

| Dependency                 | Version |
| -------------------------- | ------- |
| `ThermoRawFileParser`      | 1.4.5   |
| `bioconductor-msnbase (R)` | 2.32.0  |
| `MultiQC`                  | 1.33    |

# nf-core/ribomsqc: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.0.0dev - 2025-03-26

### `Added`

- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Initial implementation of comprehensive CI testing with BSA test data
- Added new quantification markers to XIC line plots for enhanced interpretability
- Accumulate TSV export with overwrite toggle
- Add MS level to section_name in MultiQC JSON output
- Enhance XIC plots with FWHM and PPP threshold visualization
- Add support for `--analyte all` to process all TSV entries
- Support for `MultiQC` module to aggregate results
- Custom `MSNBASEXIC` module to extract and plot XICs
- Support for ThermoRawFileParser module to convert RAW to mzML
- Initial implementation of the pipeline

### `Changed`

- Improved logging clarity and enhanced plot aesthetics
- Corrected MS2 peak extraction logic with accurate precursor matching
- Refined internal logic of the XIC extraction algorithm

### `Fixed`

- Resolved issue causing missing JSON output entries for certain analytes
- Harmonized XIC plot styling, layout and retention time interval handling
- Preserve MS level in mergejsons
- Fixed FWHM interpolation logic

### `Dependencies`

| Dependency                 | Version |
| -------------------------- | ------- |
| `ThermoRawFileParser`      | 1.4.5   |
| `bioconductor-msnbase (R)` | 2.32.0  |
| `MultiQC`                  | 1.31    |

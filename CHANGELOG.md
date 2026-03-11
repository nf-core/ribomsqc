# nf-core/ribomsqc: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.0.0dev - 2025-03-26

### `Added`

- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Added new quantification markers to XIC line plots for enhanced interpretability
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Accumulate TSV export with overwrite toggle
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Add MS level to section_name in MultiQC JSON output
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Enhance XIC plots with FWHM and PPP threshold visualization
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Add support for --analyte_name all to process all TSV entries
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Support for `MultiQC` as module to aggregate results.
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Custom `MSNBASEXIC` module to extract and plot XICs.
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Support for ThermoRawFileParser module to convert RAW to mzML.
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Initial implementation of the pipeline.

### `Changed`

- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Remove unused ch_mqc_jsons_previous logic from workflow
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Bump MultiQC from 1.28 to 1.33
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Improved logging clarity and enhanced plot aesthetics
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Corrected MS2 peak extraction logic with accurate precursor matching
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Refined internal logic of the XIC extraction algorithm

### `Fixed`

- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Resolved issue causing missing JSON output entries for certain analytes
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Harmonized XIC plot styling, layout and retention time interval handling
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Preserve MS level in mergejsons
- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Fixed FWHM interpolation logic

### `Dependencies`

| Dependency                 | Version |
| -------------------------- | ------- |
| `ThermoRawFileParser`      | 1.4.5   |
| `bioconductor-msnbase (R)` | 2.32.0  |
| `MultiQC`                  | 1.33    |

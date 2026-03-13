# nf-core/ribomsqc: Usage

## ⚠️ Please read this documentation on the nf-core website: [https://nf-co.re/ribomsqc/usage](https://nf-co.re/ribomsqc/usage)

> _Documentation of pipeline parameters is generated automatically from the pipeline schema and can no longer be found in markdown files._

## Introduction

`nf-core/ribomsqc` is a quality control (QC) pipeline designed for monitoring mass spectrometry performance in ribonucleoside analysis. It parses RAW files, performs XIC extraction using analyte definitions, and generates summary plots with MultiQC.

## Samplesheet input

Before running the pipeline, you must provide a samplesheet CSV file containing metadata about the RAW files to be processed. The pipeline supports one or multiple samples, each defined on a separate line in the CSV.

```bash
--input '[path to samplesheet.csv]'
```

The samplesheet must contain a header and two columns:

```csv title="samplesheet.csv"
id,raw_file
Day_5,/full/path/to/Day_5.raw
Sample_XYZ,/another/path/to/Sample_XYZ.raw
```

### Column descriptions

- **id**: Unique identifier for the sample. This can be any descriptive label and is used to name output files.
- **raw_file**: Full path to the corresponding RAW instrument file. Multiple entries can be included to analyze several samples in one pipeline run.

:::note
The `Day_5` row above is just an example. Replace it with your actual sample IDs and file paths.
:::

## Analytes TSV input

To define which compounds should be targeted for chromatographic extraction (XIC), the pipeline requires a tab-delimited TSV file passed with:

```bash
--analytes_tsv '[path to analytes.tsv]'
```

This file must follow a strict format and include the following columns in this exact order:

| short_name | long_name                               | mz_M0    | mz_M1 | mz_M2 | ms2_mz   | rt_teoretical |
| ---------- | --------------------------------------- | -------- | ----- | ----- | -------- | ------------- |
| C          | Cytidine 50 μg/mL                       | 244.0928 |       |       | 112.0505 | 555           |
| U          | Uridine 25 μg/mL                        | 245.0768 |       |       | 113.0346 | 1566          |
| m3C        | 3-Methylcytidine methosulfate 100 μg/mL | 258.1084 |       |       | 126.0662 | 508           |
| m5C        | 5-Methylcytidine 100 μg/mL              | 258.1084 |       |       | 126.0662 | 655           |
| Cm         | 2-O-Methylcytidine 20 μg/mL             | 258.1084 |       |       | 112.0505 | 883           |
| m5U        | 5-Methyluridine 50 μg/mL                | 259.0925 |       |       | 127.0502 | 1866          |
| I          | Inosine 25 μg/mL                        | 269.088  |       |       | 137.0458 | 1741          |
| m1A        | 1-Methyladenosine 25 μg/mL              | 282.1197 |       |       | 150.0774 | 523           |
| G          | Guanosine 25 μg/mL                      | 284.0989 |       |       | 152.0567 | 1726          |
| m7G        | 7-Methylguanosine 25 μg/mL              | 298.1146 |       |       | 166.0723 | 554           |

### Column Descriptions

### Column Descriptions

| Column            | Description                                                                 |
| ----------------- | --------------------------------------------------------------------------- |
| `short_name`      | Unique short identifier for the compound (used internally by the pipeline). |
| `long_name`       | Full descriptive name of the analyte, optionally including concentration.   |
| `mz_M0`           | Monoisotopic mass-to-charge ratio. **Required**.                            |
| `mz_M1` / `mz_M2` | Optional isotopic variant m/z values. Reserved for future versions.         |
| `ms2_mz`          | Fragment ion used for MS2-level extraction, if applicable.                  |
| `rt_teoretical`   | Expected retention time (in seconds). **You must customize this value.**    |

### Notes

- The retention times in `rt_teoretical` must reflect your instrument's chromatography performance.
- If multiple transitions are known, you can fill in `mz_M1`, `mz_M2`, and `ms2_mz` for more targeted detection.
- At least one compound must be selected at runtime using the `--analyte` parameter.

### Output directory (`--outdir`)

The `--outdir` parameter specifies where the pipeline output files will be stored. Its behavior depends on how the path is defined:

- If a **relative folder name** is provided (e.g., `results`), the directory will be created in the current working directory from which the pipeline is launched.
- If an **absolute path** is given (e.g., `/home/user/project/ribomsqc_output`), the output will be created exactly at the specified location.

:::tip
Use absolute paths in scripts or production workflows to ensure consistent and predictable file placement, especially when running from different directories or via automation.
:::

## Running the pipeline

Typical command:

```bash
nextflow run nf-core/ribomsqc \
  --input /home/proteomics/mydata/csv/samplesheet.csv \
  --analytes_tsv /home/proteomics/mydata/tsv/qcn1.tsv \
  --analyte m3C \
  --rt_tolerance 150 \
  --mz_tolerance 20 \
  --ms_level 2 \
  --plot_xic_ms1 false \
  --plot_xic_ms2 false \
  --plot_output_path xic_plot \
  --overwrite_tsv true \
  --outdir results \
  -profile singularity
```

Alternatively, you can define parameters in a separate file:

### Minimal `params.yaml` example

```yaml title="params.yaml"
input: /home/proteomics/mydata/csv/samplesheet.csv
analytes_tsv: /home/proteomics/mydata/tsv/qcn1.tsv
analyte: m3C
rt_tolerance: 150
mz_tolerance: 20
ms_level: 2
plot_xic_ms1: false
plot_xic_ms2: false
plot_xic_ms2: false
plot_output_path: xic_plot
overwrite_tsv: true
outdir: results
```

Run with:

```bash
nextflow run nf-core/ribomsqc -profile singularity -params-file params.yaml
```

## MultiQC Integration

The pipeline integrates [MultiQC](https://multiqc.info/). It collects the consolidated `.json` files generated by the `MERGEJSONS` module to summarise QC metrics. Output is stored in `${params.outdir}`.

## Reproducibility

Use `-r` to specify a pipeline version:

```bash
nextflow run nf-core/ribomsqc -r 1.0.1dev ...
```

Update the pipeline:

```bash
nextflow pull nf-core/ribomsqc
```

## Core Nextflow options

- `-profile docker|singularity|conda|podman|...`: Choose execution environment
- `-resume`: Resume from a previous run
- `-params-file`: Load parameters from a YAML/JSON file
- `-c`: Load additional config for cluster resources, etc.

## Tips

- Use `-profile singularity` for reproducibility
- Compatible with [Wave containers](https://seqera.io/wave/) for dynamic container resolution
- For cluster configs, see [nf-core/configs](https://github.com/nf-core/configs)

## Example output

```bash
results/
├── thermorawfileparser/
│   └── *.mzML
├── msnbasexic/
│   └── *.json
├── mergejsons/
│   └── *_merged_mqc.json
├── multiqc/
│   └── multiqc_report.html
└── pipeline_info/
    └── nf_core_ribomsqc_software_versions.yml
```

---

Generated with ❤️ by [nf-core](https://nf-co.re) and adapted for custom analyte QC workflows.

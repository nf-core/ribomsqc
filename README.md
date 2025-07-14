<h1>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/images/nf-core-ribomsqc_logo_dark.png">
    <img alt="nf-core/ribomsqc" src="docs/images/nf-core-ribomsqc_logo_light.png">
  </picture>
</h1>

[![GitHub Actions CI Status](https://github.com/nf-core/ribomsqc/actions/workflows/ci.yml/badge.svg)](https://github.com/nf-core/ribomsqc/actions/workflows/ci.yml)
[![GitHub Actions Linting Status](https://github.com/nf-core/ribomsqc/actions/workflows/linting.yml/badge.svg)](https://github.com/nf-core/ribomsqc/actions/workflows/linting.yml)[![AWS CI](https://img.shields.io/badge/CI%20tests-full%20size-FF9900?labelColor=000000&logo=Amazon%20AWS)](https://nf-co.re/ribomsqc/results)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A524.04.2-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/nf-core/ribomsqc)

[![Get help on Slack](http://img.shields.io/badge/slack-nf--core%20%23ribomsqc-4A154B?labelColor=000000&logo=slack)](https://nfcore.slack.com/channels/ribomsqc)[![Follow on Twitter](http://img.shields.io/badge/twitter-%40nf__core-1DA1F2?labelColor=000000&logo=twitter)](https://twitter.com/nf_core)[![Follow on Mastodon](http://img.shields.io/badge/mastodon-nf__core-6364ff?labelColor=FFFFFF&logo=mastodon)](https://mstdn.science/@nf_core)[![Watch on YouTube](http://img.shields.io/badge/youtube-nf--core-FF0000?labelColor=000000&logo=youtube)](https://www.youtube.com/c/nf-core)

## Introduction

Aquí tens una versió de la secció **Introduction** per a `nf-core/ribomsqc`, adaptada a l’estil del template que proposes:

---

### Introduction

Use **nf-core/ribomsqc** to:

- Perform automated quality control of ribonucleoside analysis by mass spectrometry.
- Summarize and visualize QC metrics through integrated **MultiQC** reports.

![Text alternatiu](docs/images/ribomsqc_general_workflow.png)
![Text alternatiu](docs/images/ribomsqc_workflow_horizontal.png)

## Usage

> \[!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow.

1. **Prepare a samplesheet** with your input data, for example:

   ```csv title="samplesheet.csv"
   id,raw_file
   Day_5,path/to/Day_5.raw
   ```

For more information, see the [usage docs](https://nf-co.re/ribomsqc/usage) on required `samplesheet.csv` columns.

2. **Prepare an analytes TSV file** (e.g. `qcn1.tsv`) with your compounds and theoretical retention times. The TSV must have **exactly** these columns and format:

```tsv
short_name	long_name	mz_M0	mz_M1	mz_M2	ms2_mz	rt_teoretical
C	Cytidine 50 μg/mL	244.0928			112.0505	555
U	Uridine 25 μg/mL	245.0768			113.0346	1566
m3C	3-Methylcytidine methosulfate 100 μg/mL	258.1084			126.0662	508
m5C	5-Methylcytidine 100 μg/mL	258.1084			126.0662	655
Cm	2-O-Methylcytidine 20 μg/mL	258.1084			112.0505	883
m5U	5-Methyluridine 50 μg/mL	259.0925			127.0502	1866
I	Inosine 25 μg/mL	269.088			137.0458	1741
m1A	1-Methyladenosine 25 μg/mL	282.1197			150.0774	523
G	Guanosine 25 μg/mL	284.0989			152.0567	1726
m7G	7-Methylguanosine 25 μg/mL	298.1146			166.0723	554
```

> [!NOTE]
> Replace **only** the values in the `rt_teoretical` column with **your own** retention times (in seconds) for each compound.

3. **Run the pipeline**:

   ```bash
   nextflow run nf-core/ribomsqc \
     --input samplesheet.csv \
     --analytes_tsv qcn1.tsv \
     --analyte all \
     --rt_tolerance 120 \
     --mz_tolerance 7 \
     --ms_level 1 \
     --outdir results \
     -profile singularity
   ```

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option.

For more information, see the [usage docs](https://nf-co.re/ribomsqc/usage) and [parameters](https://nf-co.re/ribomsqc/parameters).

## Pipeline output

See [results page](https://nf-co.re/ribomsqc/results) for example output and [output docs](https://nf-co.re/ribomsqc/output).

## Credits

nf-core/ribomsqc was originally written by Roger Olivella.

## Contributions and Support

For help, visit [Slack #ribomsqc](https://nfcore.slack.com/channels/ribomsqc) or see [contributing guide](.github/CONTRIBUTING.md).

## Citations

See [`CITATIONS.md`](CITATIONS.md) for tool references.

> Ewels PA _et al._ (2020) _The nf-core framework_. Nat Biotechnol. [doi:10.1038/s41587-020-0439-x](https://doi.org/10.1038/s41587-020-0439-x)

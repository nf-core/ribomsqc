# nf-core/ribomsqc: Adding a new instrument

## Overview

The pipeline is instrument-agnostic: it processes any Thermo Fisher RAW file
given a samplesheet and an analytes TSV, so onboarding a new instrument
requires **no changes to the pipeline code**.

How you monitor raw-data arrival, submit jobs, and publish results is
entirely up to your site. The rest of this page documents **one concrete
setup used by the current maintainers** at their institution, as a
reference example: a cron-based monitor watches each instrument's
acquisition directory, submits jobs to a job scheduler (SLURM), and
publishes a rolling MultiQC dashboard per instrument. Adding a new
instrument means creating a parallel instrument configuration in that
operations layer; the checklist below follows that setup and can be
adapted to your own (different scheduler, directory layout, or
publishing target).

## Checklist

1. **Choose a short code** for the instrument (lowercase, no spaces), e.g.
   `ecl1` or `exp240`. Sample ids are prefixed with this code, so
   instruments never collide in the dashboards.
2. **Create the instrument config** `data/instruments/<code>.conf` with:
   - `CODE`, `INSTRUMENT`, `INSTRUMENT_LABEL` — short id, acquisition
     directory name, display name
   - `RAW_DIR_BASE` — base directory of the acquisition data (QCN1 RAW files
     live at `<RAW_DIR_BASE>/<MMYY>/QCN1/`)
   - `RAW_NAME_PATTERN` — filename pattern of the QCN1 RAW files
   - `ANALYTES_TSV` — path to the instrument-specific analytes table
   - `STATE_FILE`, `PENDING_FILE` — bookkeeping of processed RAW files and
     pending jobs
   - `ROLLING_BASE` — local working directory of the rolling dashboard
   - `RESULTS_DIR` — where the pipeline results are written
   - `PUBLISH_BASE`, `PUBLISH_URL_BASE` — dashboard folder on the web server
     and its public URL
3. **Prepare the analytes TSV** with the calibration values measured on the
   new instrument (columns: `short_name`, `long_name`, `mz_M0`, `mz_M1`,
   `mz_M2`, `ms2_mz`, `rt_teoretical`). Theoretical retention times are
   instrument-specific and must reflect the new instrument's
   chromatography performance.
4. **Create the results directory** for the new instrument.
5. **Add the cron jobs** for the new code:
   - `ribomsqc_monitor.sh <code>` every 10 min — watches the current month's
     QCN1 folder and submits the new RAW files
   - `ribomsqc_publish_rolling.sh <code>` every 15 min — rebuilds and
     republishes the rolling dashboard
6. **Backfill past RAWs** if needed: submit them manually with
   `ribomsqc_trigger.sh <code> <raw_file> ...`, or pre-register their
   basenames in the state file if they should be skipped. The monitor only
   scans the current month's acquisition folder, so older months never come
   back on their own.
7. **Smoke test**: trigger one known-good RAW, check that all analytes are
   found in the results (observed RT, ppm, areas), and verify the new
   instrument's dashboard is published.
8. **Announce** the new dashboard URL to the lab.

## Notes

- From v1.1.0 on, the Δm/z plot window is ±5 ppm, which accommodates the
  systematic mass bias (−3…−4 ppm) observed on the Exploris 240.
- Each instrument has its own state files, results directory and rolling
  dashboard (latest 10 samples); instruments are processed independently
  and never interfere.

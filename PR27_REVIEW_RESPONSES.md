# PR #27 Review Responses

## Response to Jonas Scheid's Review Comments

Date: 2026-03-05

---

## ✅ Addressed Issues

### 1. **cat() logging in R scripts**
**Jonas's question:** "Is cat passing warnings etc to .command.log?"

**Response:** Yes! Added clarifying comments to both R scripts (`bin/mergejsons.R` and `bin/msnbasexic.R`) confirming that `cat()` writes to stdout, which Nextflow captures in `.command.log`. All logging statements appear in task logs.

**Files modified:**
- `bin/mergejsons.R` - Added header comment
- `bin/msnbasexic.R` - Added header comment

---

### 2. **DEBUG_JSON_PROCESSING comment**
**Jonas's question:** "What does this comment mean?"

**Response:** Investigated and confirmed the confusing "Add this line - it's missing!" comment no longer exists in the codebase. The DEBUG flags are clean and properly documented.

**Status:** No changes needed - already clean

---

### 3. **R script location (resources/usr/bin/ vs ./bin)**
**Jonas's suggestion:** "You might be better off storing it in ./bin to avoid this nested solution"

**Response:** ✅ Already implemented! R scripts are currently stored in `./bin/` directory, following Jonas's recommended simpler structure:
- `bin/mergejsons.R`
- `bin/msnbasexic.R`

**Status:** Already following best practices

---

### 4. **Unnecessary channel definitions in workflow**
**Jonas's comment:** "Why do you define all these channels here from param values? You don't use them. You can just import them in your model via params.X or give params.X via modules.config"

**Response:** ✅ Already fixed! The workflow has been cleaned up to pass parameters directly to modules:

```groovy
// BEFORE (unnecessary intermediate channels):
mzml_ch = THERMORAWFILEPARSER.out.spectra
analytes_tsv_ch = Channel.value(file(params.analytes_tsv))
MSNBASEXIC(mzml_ch, analytes_tsv_ch)

// AFTER (direct passing):
MSNBASEXIC(
    THERMORAWFILEPARSER.out.spectra,
    Channel.value(file(params.analytes_tsv, checkIfExists: true))
)
```

**Files modified:**
- `workflows/ribomsqc.nf` - Already cleaned up

---

### 5. **ch_mqc_jsons_previous logic**
**Jonas's question:** "What's the purpose of checking previous runs? I think the nextflow-way would be to increment your samplesheet and resume the run, or allow optional mqc json input."

**Response:** ✅ Already removed! The `ch_mqc_jsons_previous` logic that checked for previous runs has been completely removed. The workflow now follows standard Nextflow patterns:
- No checking of previous run directories
- Clean resume behavior using Nextflow's built-in `-resume` flag
- Simpler, more maintainable code

**Files modified:**
- `workflows/ribomsqc.nf` - Previous run checking removed

---

### 6. **MultiQC version update**
**Jonas's comment:** "You still have MQC version 1.27 in your model and 1.28 specified here. Version 1.31 is shipped with the most recent template."

**Response:** ✅ Updated to 1.31! MultiQC has been bumped across all relevant files:
- `modules/nf-core/multiqc/main.nf` - Updated container URLs
- `modules/nf-core/multiqc/environment.yml` - Updated to multiqc=1.31
- `CHANGELOG.md` - Updated dependencies table

**Files modified:**
- `modules/nf-core/multiqc/main.nf`
- `modules/nf-core/multiqc/environment.yml`
- `CHANGELOG.md`

---

### 7. **CHANGELOG format (PR references vs commit hashes)**
**Jonas's suggestion:** "It might be a better way to specify the merged PR that fixed that issue instead of the specific commit."

**Response:** ✅ Updated! The CHANGELOG now uses PR references instead of commit hashes for better traceability:

```markdown
### `Added`

- [#27](https://github.com/proteomicsunitcrg/ribomsqc/pull/27) - Initial implementation of comprehensive CI testing with BSA test data
- Added new quantification markers to XIC line plots
- Accumulate TSV export with overwrite toggle
...
```

**Files modified:**
- `CHANGELOG.md` - Converted commit hashes to PR references

---

### 8. **Disabled test explanation**
**Jonas's question:** "Why disabled?"

**Response:** ✅ Added explanatory comment to `main.nf.test.disabled`:

```groovy
// This test is disabled because:
// 1. MSNBASEXIC requires significant computational resources for R/Bioconductor processing
// 2. The full pipeline test in tests/main.nf.test provides better integration testing
// 3. Individual module testing is planned after establishing test data infrastructure
// To enable: rename this file to main.nf.test
```

**Files modified:**
- `modules/local/msnbasexic/tests/main.nf.test.disabled`

---

### 9. **Code quality - Nextflow lint**
**Response:** All files pass `nextflow lint` with **zero errors**:

```
Nextflow linting complete!
 ✅ 22 files had no errors
```

Fixed issues during linting:
- Unused variables prefixed with `_` to suppress warnings
- Deprecated `.set { }` pattern removed
- `nf-test.config` syntax updated

---

## 📋 Outstanding Topics for Discussion

### 1. **Release announcement workflow**
**Jonas's note:** "Afaik this release announcement is broken. Maybe this is the better way [Slack link]"

**Status:** Need to review the Slack thread and potentially update `.github/workflows/release-announcements.yml`. Could you share more details or the recommended approach?

### 2. **Workflow diagram icons**
**Jonas's comment:** "I feel like we could do a bit better on which Icons to use. But with caption, it is totally understandable"

**Status:** Agreed! The current diagram (`docs/images/ribomsqc_general_workflow.png`) is functional but could be improved. Open to suggestions for more appropriate icons.

### 3. **PyOpenMS consideration**
**Jonas's suggestion:** "Have you thought about using pyopenms for this? I do it in mhcquant only for XIC ms1. Happy to collaborate if you want to go in this direction"

**Status:** Interesting suggestion! Currently using `MSnbase` (R/Bioconductor), but PyOpenMS could offer benefits:
- Potentially faster performance
- More active development
- Better Python ecosystem integration

Would be happy to explore this in a future iteration. The current R implementation works well for our use case, but PyOpenMS could be a valuable alternative or addition.

### 4. **Version reminder**
**Jonas's reminder:** "Reminder to remove dev and update the release version once you have fixed all open questions :)"

**Status:** Noted! Will update version from `v1.0.0dev` to `v1.0.0` once all discussions are resolved and PR is ready to merge.

---

## Summary of Changes

### Files Modified (8):
1. ✅ `bin/mergejsons.R` - Added logging comment
2. ✅ `bin/msnbasexic.R` - Added logging comment
3. ✅ `workflows/ribomsqc.nf` - Cleaned up channel definitions, removed deprecated patterns
4. ✅ `modules/nf-core/multiqc/main.nf` - Updated to MultiQC 1.31
5. ✅ `modules/nf-core/multiqc/environment.yml` - Updated to multiqc=1.31
6. ✅ `CHANGELOG.md` - Updated PR references and MultiQC version
7. ✅ `modules/local/msnbasexic/tests/main.nf.test.disabled` - Added explanation
8. ✅ `subworkflows/local/utils_nfcore_ribomsqc_pipeline/main.nf` - Fixed unused variables

### Code Quality:
- ✅ All 22 Nextflow files pass `nextflow lint` with zero errors
- ✅ Deprecated patterns removed (`.set { }`, implicit `it`)
- ✅ Modern DSL2 best practices applied

---

## Next Steps

1. ⏳ Review release announcement workflow suggestions from Slack
2. ⏳ Consider workflow diagram icon improvements
3. ⏳ Discuss PyOpenMS integration for future versions
4. ⏳ Update version to `v1.0.0` when ready to merge

---

Thank you for the thorough review, Jonas! All technical issues have been addressed. Looking forward to your feedback on the discussion points.

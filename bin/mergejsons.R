#!/usr/bin/env Rscript

# Logging: cat() writes to stdout which Nextflow captures in .command.log
# All cat() statements below will appear in task logs

# Load required libraries
suppressPackageStartupMessages({
          library(jsonlite)
          library(tools)
})

# Define input folder for staged JSONs
input_dir <- "merge_jsons_input"

# Validate that the input directory exists
if (!dir.exists(input_dir)) {
          stop("Input directory 'merge_jsons_input' does not exist.")
}

# List all candidate *_mqc.json files inside the input directory
json_files <- list.files(path = input_dir, pattern = "*_mqc.json$", full.names = TRUE)

# Abort if no JSONs are found
if (length(json_files) == 0) {
          stop("No JSON files found in input directory.")
}

cat("[INFO] Found JSON input files:\n")
print(json_files)

# Try to read the metric IDs from each file (with error handling)
extract_metric_id <- function(f) {
          tryCatch(
            {
              fromJSON(f)$id
            },
            error = function(e) {
              warning(paste("Skipping invalid JSON file:", f, "->", e$message))
              return(NA)
            }
          )
}

metric_ids <- unique(na.omit(sapply(json_files, extract_metric_id)))

# Abort if no valid metric IDs were parsed
if (length(metric_ids) == 0) {
          stop("No valid JSON files with a 'id' field found.")
}

# Check if all expected merged outputs already exist
existing_outputs <- list.files(pattern = "_merged_mqc\\.json$")
expected_outputs <- paste0(metric_ids, "_merged_mqc.json")

if (all(expected_outputs %in% existing_outputs)) {
          cat("[INFO] All merged JSONs already exist. Skipping merge.\n")
          quit(status = 0)
}

if (any(expected_outputs %in% existing_outputs)) {
          stop("Some merged JSONs already exist. Please remove or clean the output directory before reprocessing.")
}

# Initialize the merged data structure and meta-header tracking
merged_metrics <- list()
meta_headers <- list()
all_samples <- c() # Track all samples across all files

# First pass: collect all sample names
for (file in json_files) {
          data <- tryCatch(
            {
              fromJSON(file)
            },
            error = function(e) {
              return(NULL)
            }
          )

          if (!is.null(data) && !is.null(data$data)) {
            for (analyte in names(data$data)) {
              if (is.list(data$data[[analyte]]) && length(data$data[[analyte]]) > 0) {
                all_samples <- c(all_samples, names(data$data[[analyte]]))
              }
            }
          }
}

all_samples <- unique(all_samples)
cat("[DEBUG] All samples found:", paste(all_samples, collapse = ", "), "\n")

# Second pass: process each JSON file and group values by metric → analyte → sample
for (file in json_files) {
          cat("[INFO] Processing file:", file, "\n")
          data <- tryCatch(
            {
              fromJSON(file)
            },
            error = function(e) {
              warning(paste("Skipping invalid JSON:", file, "->", e$message))
              return(NULL)
            }
          )

          if (is.null(data) || is.null(data$id) || is.null(data$data)) {
            warning(paste("Skipping malformed JSON (missing 'id' or 'data'):", file))
            next
          }

          metric <- data$id

          # Save meta header (first occurrence only)
          if (!metric %in% names(meta_headers)) {
            meta_headers[[metric]] <- list(
              section_name = data$section_name,
              description = data$description,
              pconfig = data$pconfig
            )
          }

          if (!metric %in% names(merged_metrics)) {
            merged_metrics[[metric]] <- list()
          }

          for (analyte in names(data$data)) {
            if (!analyte %in% names(merged_metrics[[metric]])) {
              merged_metrics[[metric]][[analyte]] <- list()
            }

            analyte_data <- data$data[[analyte]]

            if (is.list(analyte_data) && length(analyte_data) > 0) {
              for (sample in names(analyte_data)) {
                value <- analyte_data[[sample]]
                # Use NA instead of NULL to preserve the entry
                merged_metrics[[metric]][[analyte]][[sample]] <- if (is.null(value)) NA else value
              }
            }
          }
}

# Third pass: Fill in missing samples with NA for complete data matrix
for (metric in names(merged_metrics)) {
          for (analyte in names(merged_metrics[[metric]])) {
            for (sample in all_samples) {
              if (!sample %in% names(merged_metrics[[metric]][[analyte]])) {
                merged_metrics[[metric]][[analyte]][[sample]] <- NA
              }
            }
          }
}

# Write merged JSONs, one per metric
for (metric in names(merged_metrics)) {
          header <- meta_headers[[metric]]

          # Filter out analytes that have no valid data across all samples
          filtered_data <- list()
          for (analyte in names(merged_metrics[[metric]])) {
            analyte_data <- merged_metrics[[metric]][[analyte]]
            # Check if analyte has at least one non-NA value
            has_valid_data <- any(!is.na(unlist(analyte_data)))

            if (has_valid_data || length(analyte_data) > 0) {
              filtered_data[[analyte]] <- analyte_data
            }
          }

          merged_json <- list(
            id = metric,
            section_name = header$section_name,
            description = header$description,
            plot_type = "linegraph",
            pconfig = header$pconfig,
            data = filtered_data
          )

          out_file <- paste0(metric, "_merged_mqc.json")
          cat("[INFO] Writing merged JSON:", out_file, "\n")

          # Use na = "null" to ensure NA values are written as null in JSON
          write_json(
            merged_json,
            path = out_file,
            auto_unbox = TRUE,
            pretty = TRUE,
            na = "null"
          )
}

cat("[INFO] JSON merge completed successfully.\n")

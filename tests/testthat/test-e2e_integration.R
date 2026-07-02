library(testthat)
library(bookmetrics)
library(dplyr)

test_that("End-to_end pipeline works with Alice in Wonderland (from registry)", {
  # Use the registered identifier 'alice'
  book_id <- "alice"
  characters <- c("Alice", "Rabbit")
  output_dir <- "test_gallery_e2e"

  # Ensure clean directory
  if (dir.exists(output_dir)) unlink(output_dir, recursive = TRUE)
  dir.create(output_dir, showWarnings = FALSE)

  # 1. Run full analysis pipeline using the registry ID
  analysis <- try(analyse_book(book_id, characters), silent = TRUE)

  expect_false(inherits(analysis, "try-error"), info = "Analysis pipeline failed to execute.")
  expect_s3_class(analysis, "book_analysis")

  # 2. Generate the gallery
  gallery_files <- try(generate_gallery(analysis, output_dir), silent = TRUE)
  expect_false(inherits(gallery_files, "try-error"), info = "Gallery generation failed.")

  # 3. Verify outputs
  expected_files <- c(
    file.path(output_dir, "index.html"),
    file.path(output_dir, "plot_match_timeline.png"),
    file.path(output_dir, "plot_character_possession.png"),
    file.path(output_dir, "plot_character_influence_timeline.png"),
    file.path(output_dir, "plot_annotated_match_timeline.png"),
    file.path(output_dir, "plot_emotional_arc.png")
  )

  for (f in expected_files) {
    expect_true(file.exists(f), info = paste("Expected file not found:", f))
  }

  # 4. Verify content of index.html roughly
  index_content <- readLines(file.path(output_dir, "index.html"), warn = FALSE)
  expect_true(any(grepl("Alice", index_content)), info = "HTML title missing book name.")
  expect_true(any(grepl("plot_match_timeline.png", index_content)), info = "HTML missing match timeline link.")

  # Cleanup
  unlink(output_dir, recursive = TRUE)
})

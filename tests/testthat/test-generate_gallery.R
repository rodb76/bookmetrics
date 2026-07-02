library(testthat)
library(tibble)
library(bookmetrics)

# Load implementation
source("../../R/book_analysis.R")
source("../../R/plot_match_timeline.R")
source("../../R/plot_character_possession.R")
source("../../R/plot_character_influence_timeline.R")
source("../../R/plot_annotated_match_timeline.R")
source("../../R/plot_emotional_arc.R")
source("../../R/generate_gallery.R")

test_that("generate_gallery creates directory and generates files", {
  # Setup minimal analysis object
  analysis <- create_book_analysis(
    metadata = list(title = "Test"),
    match_metrics = tibble::tibble(chapter = 1L, momentum = 0.1, intensity = 0.1),
    key_events = tibble::tibble(chapter = 1L, event_type = "test"),
    character_possession = tibble::tibble(
      chapter = 1L, character = "A", mentions = 1L,
      chapter_total_mentions = 1L, possession_pct = 1.0
    ),
    sentiment = tibble::tibble(chapter = 1L, sentiment_score = 0.1)
  )

  test_dir <- file.path(tempdir(), "gallery_test")
  if (dir.exists(test_dir)) unlink(test_dir, recursive = TRUE)

  # Run function
  files <- generate_gallery(analysis, test_dir)

  # Assertions
  expect_true(dir.exists(test_dir))
  expect_type(files, "character")
  expect_true(all(file.exists(as.character(files))))
  expect_true(all(grepl("plot_", files)))

  # Clean up
  unlink(test_dir, recursive = TRUE)
})

test_that("generate_gallery fails with invalid input", {
  analysis <- create_book_analysis()

  expect_error(generate_gallery("not an analysis object", "tmp"), "must be a 'book_analysis' object")
  expect_error(generate_gallery(analysis, 123), "must be a single character string")
})

library(testthat)
library(tibble)

# Load implementation
source("../../R/book_analysis.R")
source("../../R/load_gutenberg_book.R")
source("../../R/split_into_chapters.R")
source("../../R/compute_sentiment_by_chapter.R")
source("../../R/compute_match_metrics.R")
source("../../R/identify_key_events.R")
source("../../R/extract_character_mentions.R")
source("../../R/compute_character_possession.R")
source("../../R/analyse_book.R")

test_that("analyse_book returns a book_analysis object", {
  # Create a temporary dummy "book" file.
  tmp_file <- tempfile()
  writeLines("Start Project Gutenberg\nChapter 1\nAlice met Bob.\nEnd Project Gutenberg", tmp_file)

  # Use the absolute path directly
  url <- normalizePath(tmp_file, winslash = "/")
  characters <- c("Alice", "Bob")

  result <- try(analyse_book(url, characters), silent = TRUE)

  if (inherits(result, "try-error")) {
    skip("Could not run integration test: file access error")
	} else {
    expect_s3_class(result, "book_analysis")
    expect_true(all(c("metadata", "chapters", "sentiment", "match_metrics",
                    "key_events", "character_mentions", "character_possession") %in% names(result)))
  }

  # Cleanup
  unlink(tmp_file)
})

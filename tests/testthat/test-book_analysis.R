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
source("../../R/plot_match_timeline.R")
source("../../R/plot_character_possession.R")
source("../../R/plot_character_influence_timeline.R")
source("../../R/plot_annotated_match_timeline.R")
source("../../R/plot_emotional_arc.R")

test_that("create_book_analysis creates an S3 object of class book_analysis", {
  analysis <- create_book_analysis(metadata = list(title = "Test Book"))
  expect_s3_class(analysis, "book_analysis")
})

test_that("create_book_analysis contains all required components", {
  analysis <- create_book_analysis()
  expected_components <- c("metadata", "chapters", "sentiment", "match_metrics",
                           "key_events", "character_mentions", "character_possession")
  expect_true(all(expected_components %in% names(analysis)))
})

test_that("create_book_analysis handles provided data correctly", {
  meta <- list(title = "Test Title", author = "Test Author")
  chapters <- tibble::tibble(chapter = 1L, text = "Hello")

  analysis <- create_book_analysis(metadata = meta, chapters = chapters)

  expect_equal(analysis$metadata$title, "Test Title")
  expect_equal(nrow(analysis$chapters), 1)
})

test_that("print.book_analysis produces expected output and does not error", {
  analysis <- create_book_analysis(metadata = list(title = "Print Test"))
  # We use expect_output to check the printed text
  expect_output(print(analysis), "Book Analysis Object")
  expect_output(print(analysis), "Metadata: title")
})

test_that("plot_match_timeline accepts both tibble and book_analysis", {
  # Tibble input
  m_data <- tibble::tibble(chapter = 1L, momentum = 0.1, intensity = 0.1)
  expect_silent(plot_match_timeline(m_data))

  # book_analysis input
  analysis <- create_book_analysis(match_metrics = m_data)
  expect_silent(plot_match_timeline(analysis))
})

test_that("plot_character_possession accepts both tibble and book_analysis", {
  # Tibble input
  p_data <- tibble::tibble(
    chapter = 1L, character = "Alice", mentions = 10L,
    chapter_total_mentions = 10L, possession_pct = 1.0
  )
  expect_silent(plot_character_possession(p_data))

  # book_analysis input
  analysis <- create_book_analysis(character_possession = p_data)
  expect_silent(plot_character_possession(analysis))
})

test_that("plot_character_influence_timeline accepts both tibble and book_analysis", {
  # Tibble input
  i_data <- tibble::tibble(chapter = 1L, character = "Alice", possession_pct = 1.0)
  expect_silent(plot_character_influence_timeline(i_data))

  # book_analysis input
  analysis <- create_book_analysis(character_possession = i_data)
  expect_silent(plot_character_influence_timeline(analysis))
})

test_that("plot_annotated_match_timeline accepts both tibbles and book_analysis", {
  # Tibble inputs
  m_data <- tibble::tibble(chapter = 1L, momentum = 0.1)
  e_data <- tibble::tibble(chapter = 1L, event_type = "breakthrough")
  expect_silent(plot_annotated_match_timeline(m_data, e_data))

  # book_analysis inputs
  analysis <- create_book_analysis(match_metrics = m_data, key_events = e_data)
  expect_silent(plot_annotated_match_timeline(analysis, analysis))
})

test_that("plot_emotional_arc accepts both tibble and book_analysis", {
  # Tibble input
  s_data <- tibble::tibble(chapter = 1L, sentiment_score = 0.1)
  expect_silent(plot_emotional_arc(s_data))

  # book_analysis input
  analysis <- create_book_analysis(sentiment = s_data)
  expect_silent(plot_emotional_arc(analysis))
})

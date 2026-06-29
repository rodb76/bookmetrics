library(testthat)
library(dplyr)
library(bookmetrics)

test_that("End-to-end pipeline works with Alice in Wonderland", {
  # We use a small part of Alice or the full thing if allowed.
  # To avoid network dependency failures in CI, we might want to mock this,
  # but for integration tests, we's testing the real connection.
  url <- "https://www.gutenberg.org/files/11/11-0.txt"

  # Check connectivity/loading
  expect_no_error(book_data <- load_gutenberg_book(url, strict = FALSE))
  expect_s3_class(book_data, "tbl_df")
  expect_true("text" %in% names(book_data))

  # 1. Splitting into chapters
  chapters <- split_into_chapters(book_data)
  expect_s3_class(chapters, "tbl_df")
  expect_true(all(c("chapter", "text") %in% names(chapters)))
  expect_true(is.integer(chapters$chapter))
  expect_gt(nrow(chapters), 0)

  # 2. Sentiment analysis
  sentiment <- compute_sentiment_by_chapter(chapters)
  expect_s3_class(sentiment, "tbl_df")
  expect_true(all(c("chapter", "sentiment_score", "word_count") %in% names(sentiment)))

  # 3. Match metrics
  metrics <- compute_match_metrics(sentiment)
  expect_s3_class(metrics, "tbl_df")
  expect_true(all(c("chapter", "sentiment_score", "word_count", "momentum", "intensity") %in% names(metrics)))

  # 4. Key events identification
  events <- identify_key_events(metrics)
  expect_s3_class(events, "tbl_df")
  expect_true(all(c("chapter", "event_type", "metric_value") %in% names(events)))

  # 5. Character mentions extraction
  chars <- c("Alice", "Rabbit")
  mentions <- extract_character_mentions(chapters, chars)
  expect_s3_class(mentions, "tbl_df")
  expect_true(all(c("chapter", "character", "mentions") %in% names(mentions)))

  # 6. Character possession calculation
  possession <- compute_character_possession(mentions)
  expect_s3_class(possession, "tbl_df")
  expect_true(all(c("chapter", "character", "mentions", "chapter_total_mentions", "possession_pct") %in% names(possession)))
})

test_that("Functions fail fast with invalid inputs", {
  # load_gutenberg_book validation
  expect_error(load_gutenberg_book(123), "Argument 'url' must be a single string.")

  # split_into_chapters validation
  invalid_df <- tibble::tibble(not_text = "hello")
  expect_error(split_into_chapters(invalid_df), "Input tibble must contain a 'text' column.")

  # compute_sentiment_by_chapter validation
  invalid_sent <- tibble::tibble(chapter = "1", text = "hello") # chapter is character, not integer
  expect_error(compute_sentiment_by_chapter(invalid_sent), "'chapter' column must be of type integer.")
})

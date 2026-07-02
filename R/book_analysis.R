#' Create a book analysis object
#'
#' This function initializes an S3 object of class 'book_analysis' containing
#' all the necessary components for book processing results.
#'
#' @param metadata A list or data frame containing book metadata (e.g., title, author).
#' @param chapters A tibble or data frame containing chapter information.
#' @param sentiment A tibble or data frame containing sentiment scores per chapter.
#' @param match_metrics A list or data frame containing metrics from character/event matching.
#' @param key_events A tibble or data frame containing extracted key events.
#' @param character_mentions A tibble or data frame containing character mention counts.
#' @param character_possession A tibble or data frame containing character possession data.
#' @param analysis_date The date when the analysis was performed.
#' @param source_url The URL of the original source.
#' @param character_list The list of characters searched for.
#'
#' @return An object of class 'book_analysis'.
#' @export
#'
#' @examples
#' \dontrun{
#' analysis <- create_book_analysis(metadata = list(title = "Alice in Wonderland"))
#' print(analysis)
#' }
create_book_analysis <- function(metadata = list(),
                                chapters = tibble::tibble(),
                                sentiment = tibble::tibble(),
                                match_metrics = list(),
                                key_events = tibble::tibble(),
                                character_mentions = tibble::tibble(),
                                character_possession = tibble::tibble(),
                                analysis_date = Sys.Date(),
                                source_url = NULL,
                                character_list = character(0)) {

  # Calculate word count from chapters if available
  total_word_count <- if (nrow(chapters) > 0 && "text" %in% names(chapters)) {
    sum(stringr::str_count(chapters$text, "\\w+"))
  } else {
    0L
  }

  structure(
    list(
      metadata = metadata,
      chapters = chapters,
      sentiment = sentiment,
      match_metrics = match_metrics,
      key_events = key_events,
      character_mentions = character_mentions,
      character_possession = character_possession,
      analysis_date = analysis_date,
      source_url = source_url,
      character_list = character_list,
      total_word_count = total_word_count,
      chapter_count = nrow(chapters)
    ),
    class = "book_analysis"
  )
}

#' Print method for book_analysis
#'
#' Provides a human-readable summary of the book analysis object.
#'
#' @param x An object of class 'book_analysis'.
#' @param ... Additional arguments passed to `print.default`.
#' @useMethod print
#' @export
print.book_analysis <- function(x, ...) {
  cat("Book Analysis Object\n")
  cat("--------------------\n")
  cat("Title:            ", if (!is.null(x$metadata$title)) x$metadata$title else "Unknown", "\n")
  cat("Author:           ", if (!is.null(x$metadata$author)) x$metadata$author else "Unknown", "\n")
  cat("Source URL:       ", if (!is.null(x$source_url)) x$source_url else "N/A", "\n")
  cat("Analysis Date:    ", format(x$analysis_date, "%Y-%m-%d"), "\n")
  cat("--------------------\n")
  cat("Chapters:         ", x$chapter_count, "\n")
  cat("Total Word Count: ", format(x$total_word_count, big.mark = ","), "\n")
  cat("Characters Found: ", length(x$character_list), "\n")
  cat("--------------------\n")
  cat("Components:\n")
  cat("  - Sentiment:     ", nrow(x$sentiment), "rows\n")
  cat("  - Key Events:    ", nrow(x$key_events), "rows\n")
  cat("  - Character Pos.:", nrow(x$character_possession), "rows\n")
  cat("--------------------\n")
  invisible(x)
}

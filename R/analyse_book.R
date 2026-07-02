#' Analyze a book from Project Gutenberg
#'
#' Orchestrates the complete book analysis pipeline, from loading raw text
#' to generating structured analysis components including sentiment,
#' key events, and character metrics.
#'
#' @param url A string containing the valid Project
#'   Gutenberg URL. If `chapters` is provided, this is used for metadata.
#' @param character_names A character vector of names to search for in the text.
#' @param chapters An optional tibble containing pre-processed chapters.
#'   If `NULL`, the function will download and split the book using `url`.
#'
#' @return An object of class 'book_analysis' containing all processing results.
#' @export
#'
#' @examples
#' \dontrun{
#' characters <- c("Alice", "Bob")
#' analysis <- analyse_book("https://www.gutenberg.org/files/11/11-0.txt", characters)
#' print(analysis)
#' }
#' @importFrom bookmetrics load_gutenberg_book split_into_chapters
#'   compute_sentiment_by_chapter compute_match_metrics identify_key_events
#'   extract_character_mentions compute_character_possession create_book_analysis
analyse_book <- function(book, character_names, chapters = NULL) {
  # Check if 'book' is a registered identifier
  url <- get_book_url(book)

  if (is.null(url)) {
    # If not in registry, assume it's a direct URL
    url <- book
  }

  # 1. Load and split the book if chapters are not provided
  if (is.null(chapters)) {
    book_text <- load_gutenberg_book(url)
    chapters <- split_into_chapters(book_text)
  }

  # 2. Compute sentiment
  sentiment <- compute_sentiment_by_chapter(chapters)

  # 3. Compute match metrics (derived from sentiment changes)
  match_metrics <- compute_match_metrics(sentiment)

  # 4. Identify key events (from momentum/intensity)
  key_events <- identify_key_events(match_metrics)

  # 5. Extract character mentions
  character_mentions <- extract_character_mentions(chapters, character_names)

  # 6. Compute possession (derived from mentions)
  character_possession <- compute_character_possession(character_mentions)

  # 7. Assemble and return the book_analysis object
  create_book_analysis(
    metadata = list(url = url),
    chapters = chapters,
    sentiment = sentiment,
    match_metrics = match_metrics,
    key_events = key_events,
    character_mentions = character_mentions,
    character_possession = character_possession,
    source_url = url,
    character_list = character_names,
    analysis_date = Sys.Date()
  )
}

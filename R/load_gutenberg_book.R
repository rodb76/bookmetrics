#' Load a book from Project Gutenberg
  #'
  #' Fetches the raw text from a Project Gutenberg URL, removes the standard
  #' Gutenberg header and footer using flexible pattern matching, and returns the content as a single-column tibble.                                                                                 
  #' @param url A string containing the valid Project Gutenberg URL.
  #' @param strict Logical. If `TRUE`, throws an error if header or footer markers
  #'   cannot be identified. If `FALSE`, returns the full text.
  #'
  #' @return A tibble with a single column `text` containing the cleaned book content.
  #'
  #' @examples
  #' \dontrun{
  #'   book_text <- load_gutenberg_book("https://www.gutenberg.org/files/11/11-0.txt", strict = FALSE)
  #'   print(book_text)
  #' }
  #'
  #' @importFrom readr read_lines
  #' @importFrom tibble tibble
  #' @importFrom stringr str_detect
  #' @export
  load_gutenberg_book <- function(url, strict = TRUE) {
    if (!is.character(url) || length(url) != 1) {
      stop("Argument 'url' must be a single string.")
    }

    # Read lines from the URL
    #lines <- readr::read_lines(url)
    lines <- readr::read_lines(url, locale = readr::locale(encoding = "UTF-8"))

    # Flexible regex patterns for header and footer
    header_pattern <- "(?i)start.*project gutenberg"
    footer_pattern <- "(?i)end.*project gutenberg"

    start_indices <- which(stringr::str_detect(lines, header_pattern))
    end_indices <- which(stringr::str_detect(lines, footer_pattern))

    # Determine content range
    if (length(start_indices) > 0 && length(end_indices) > 0) {
      start_idx <- min(start_indices)
      end_idx <- max(end_indices)

      if (start_idx >= end_idx) {
        stop("Detected header occurs after the footer in the document.")
      }

      # Extract content between the end of the header and the start of the footer
      content_lines <- lines[(start_idx + 1):(end_idx - 1)]
    } else {
      if (strict) {
        stop("Could not identify standard Gutenberg header or footer markers.")
      } else {
        warning("Could not find standard Gutenberg markers. Returning full
  text.")
        content_lines <- lines
      }
    }

    # Collapse lines into a single string and return as a tibble
    full_text <- paste(content_lines, collapse = "\n")

    tibble::tibble(text = full_text)
  }

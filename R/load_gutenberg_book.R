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

  lines <- readr::read_lines(url, locale = readr::locale(encoding = "UTF-8"))

  header_pattern <- "(?i)start.*project gutenberg"
  footer_pattern <- "(?i)end.*project gutenberg"

  start_indices <- which(stringr::str_detect(lines, header_pattern))
  end_indices <- which(stringr::str_detect(lines, footer_pattern))

  if (length(start_indices) > 0 && length(end_indices) > 0) {
    start_idx <- min(start_indices)
    end_idx <- max(end_indices)

    if (start_idx >= end_idx) {
      stop("Detected header occurs after the footer in the document.")
    }

    # Metadata lives in the preamble, before the START marker
    preamble <- lines[seq_len(start_idx - 1)]

    title_line <- preamble[stringr::str_detect(preamble, "(?i)^title:\\s*")]
    author_line <- preamble[stringr::str_detect(preamble, "(?i)^author:\\s*")]

    title <- if (length(title_line) > 0) {
      stringr::str_trim(stringr::str_remove(title_line[1], "(?i)^title:\\s*"))
    } else {
      NA_character_
    }

    author <- if (length(author_line) > 0) {
      stringr::str_trim(stringr::str_remove(author_line[1], "(?i)^author:\\s*"))
    } else {
      NA_character_
    }

    content_lines <- lines[(start_idx + 1):(end_idx - 1)]
  } else {
    if (strict) {
      stop("Could not identify standard Gutenberg header or footer markers.")
    } else {
      warning("Could not find standard Gutenberg markers. Returning full text.")
      content_lines <- lines
      title <- NA_character_
      author <- NA_character_
    }
  }

  full_text <- paste(content_lines, collapse = "\n")

  tibble::tibble(text = full_text, title = title, author = author)
}

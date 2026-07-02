#' Analyze and generate a gallery for a Gutenberg book
#'
#' This is the primary entry point for the `bookmetrics` package. It automates
#' the full pipeline: downloading text from Project Gutenberg, splitting it into
#' chapters, performing a comprehensive analysis (sentiment, events,
#' character metrics), and generating an image gallery of all resulting plots.
#'
#' @param url A string containing the valid Project Gutenberg URL.
#' @param character_names A character vector of names to search for in the text.
#' @param output_dir A character string specifying where to save the plot gallery.
#'   Defaults to `"output/plots"`.
#'
#' @return An object of class 'book_analysis' containing all processing results,
#'   returned invisibly.
#'
#' @examples
#' \dontrun{
#' library(bookmetrics)
#' # The single entry point for a complete analysis and gallery generation
#' analysis <- analyse_gutenberg_book(
#'   url = "https://www.gutenberg.org/files/11/11-0.txt",
#'   character_names = c("Alice", "Rabbit"),
#'   output_dir = "my_analysis_plots"
#' )
#' print(analysis)
#' }
#'
#' @importFrom bookmetrics load_gutenberg_book split_into_chapters
#'   analyse_book generate_gallery
#' @importFrom magrittr %>%
#' @export
analyse_gutenberg_book <- function(url, character_names, output_dir = "output/plots") {
  # 1. Load the book text
  book_text <- load_gutenberg_book(url)

  # 2. Split into chapters
  chapters <- split_into_chapters(book_text)

  # 3. Run the complete analysis pipeline using pre-processed chapters
  analysis <- analyse_book(url, character_names, chapters = chapters)

  # 4. Generate the visual gallery
  generate_gallery(analysis, output_dir)

  # 5. Return the result invisibly
  return(invisible(analysis))
}

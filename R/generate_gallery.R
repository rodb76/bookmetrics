#' Generate a gallery of plots for a book analysis object
#'
#' This function iterates through all available plotting functions in the
#' `bookmetrics` package, generates them using the provided `book_analysis`
#' object, and saves them as PNG files in the specified directory.
#' It also generates an HTML index page for easy browsing.
#'
#' @param analysis A `book_analysis` object containing the data to plot.
#' @param output_dir A character string specifying where plots and the index should be saved.
#'
#' @return Invisibly returns a character vector of the paths to the generated files.
#' @export
#'
#' @examples
#' \dontrun{
#' library(bookmetrics)
#' # Assuming 'analysis' is a valid book_analysis object
#' gallery_files <- generate_gallery(analysis, "output/plots")
#' print(gallery_files)
#' }
generate_gallery <- function(analysis, output_dir) {
  if (!inherits(analysis, "book_analysis")) {
    rlang::abort("Input 'analysis' must be a 'book_analysis' object.")
  }

  if (!is.character(output_dir) || length(output_dir) != 1) {
    rlang::abort("'output_dir' must be a single character string representing a directory path.")
  }

  # Create the directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  generated_files <- character()

  # Define the plots to generate and their corresponding filenames
  plots_to_run <- list(
    "match_timeline" = plot_match_timeline,
    "character_possession" = plot_character_possession,
    "character_influence_timeline" = plot_character_influence_timeline,
    "    annotated_match_timeline" = function(analysis) {
      plot_annotated_match_timeline(analysis$match_metrics, analysis$key_events)
    },
    "emotional_arc" = plot_emotional_arc
  )

  for (name in names(plots_to_run)) {
    plot_func <- plots_to_run[[name]]
    file_path <- file.path(output_dir, paste0("plot_", name, ".png"))

    # Generate the plot
    tryCatch({
      p <- plot_func(analysis)

      # Save the plot
      ggplot2::ggsave(file_path, plot = p, device = "png", width = 8, height = 6, dpi = 300)
      generated_files <- c(generated_files, file_path)
    }, error = function(e) {
      warning(paste("Failed to generate plot for", name, ":", e$message))
    })
  }

  # Create index.html in the output directory
  if (length(generated_files) > 0) {
    title <- if (!is.null(analysis$metadata$title)) analysis$metadata$title else "Book Analysis Gallery"

    html_lines <- c(
      "<!DOCTYPE html>",
      "<html>",
      "<head>",
      "  <meta charset='UTF-8'>",
      "  <title>Analysis Gallery: ", title, "</title>",
      "  <style>",
      "    body { font-family: sans-serif; margin: 40px; background: #f9f9f9; line-height: 1.6; }",
      "    h1 { color: #333; border-bottom: 2px solid #eee; padding-bottom: 10px; }",
      "    .metadata { margin-bottom: 30px; font-size: 0.9em; color: #666; background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #eee; }",
      "    .metadata div { margin-bottom: 5px; }",
      "    .gallery-item { background: white; padding: 20px; margin-bottom: 40px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }",
      "    img { max-width: 100%; height: auto; display: block; margin-bottom: 15px; border: 1px solid #ddd; }",
      "    .caption { font-weight: bold; color: #555; }",
      "    a { color: #007bff; text-decoration: none; font-size: 0.9em; }",
      "    a:hover { text-decoration: underline; }",
      "  </style>",
      "</head>",
      "<body>",
      "  <h1>Analysis Gallery: ", title, "</h1>",
      "  <div class='metadata'>",
      "    <div><strong>Source URL:</strong> ", if (!is.null(analysis$source_url)) analysis$source_url else "N/A", "</div>",
      "    <div><strong>Analysis Date:</strong> ", format(analysis$analysis_date, "%Y-%m-%d"), "</div>",
      "    <div><strong>Characters Found:</strong> ", length(analysis$character_list), "</div>",
      "  </div>",
      "  <div class='gallery'>"
    )

    for (f in generated_files) {
      fname <- basename(f)
      # Create a cleaner caption by removing 'plot_' and '.png'
      clean_name <- gsub("^plot_", "", tools::file_path_sans_ext(fname))
      clean_name <- gsub("_", " ", clean_name)
      clean_name <- paste0(toupper(substring(clean_name, 1, 1)), substring(clean_name, 2))

      html_lines <- c(
        html_lines,
        "    <div class='gallery-item'>",
        "      <img src='", fname, "' alt='", clean_name, "'>",
        "      <div class='caption'>", clean_name, "</div>",
        "      <a href='", fname, "'>Download Full Size</a>",
        "    </div>"
      )
    }

    html_lines <- c(html_lines, "  </div></body></html>")
    writeLines(html_lines, file.path(output_dir, "index.html"))
  }

  return(invisible(generated_files))
}

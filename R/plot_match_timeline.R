#' Plot match metrics timeline
#'
#' Creates a bar chart visualizing narrative momentum across chapters.
#'
#' @param data A tibble containing `chapter` (integer), `momentum` (numeric),
#'   and `intensity` (numeric), OR an object of class 'book_analysis'
#'   containing the 'match_metrics' component.
#' @return A `ggplot` object showing momentum by chapter.
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' data <- tibble(
#'   chapter = 1:5L,
#'   momentum = c(0, 0.2, -0.1, 0.4, -0.3),
#'   intensity = c(0, 0.2, 0.1, 0.4, 0.3)
#' )
#' plot_match_timeline(data)
#' }
plot_match_timeline <- function(data) {
    # Handle book_analysis object
    if (inherits(data, "book_analysis")) {
      data <- data$match_metrics
    }

    # Input validation
    if (!inherits(data, "tbl_df") && !inherits(data, "grouped_for_data_frame")) {
      rlang::abort("Input 'data' must be a tibble.")
    }

    required_columns <- c("chapter", "momentum", "intensity")
    if (!all(required_columns %in% names(data))) {
      rlang::abort(paste0("Input 'data' must contain columns: ", paste(required_columns, collapse = ", ")))
    }

    if (!is.numeric(data$chapter)) {
      rlang::abort("'chapter' must be numeric.")
    }

    if (!is.numeric(data$momentum)) {
      rlang::abort("'momentum' must be numeric.")
    }

    # Visualization
    ggplot2::ggplot(data, ggplot2::aes(x = chapter, y = momentum)) +
      ggplot2::geom_col() +
      ggplot2::geom_hline(yintercept = 0, color = "black", linewidth = 0.5) +
      theme_bookmetrics() +
      ggplot2::labs(
        x = "Chapter",
        y = "Narrative Momentum"
      )
  }

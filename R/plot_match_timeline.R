#' Plot match metrics timeline
#'
#' Creates a bar chart visualizing narrative momentum across chapters.
#'
#' @param data A tibble containing `chapter` (integer), `momentum` (numeric),
#'   and `intensity` (numeric).
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
#' match_stats <- compute_match_metrics(sentiment)
#' plot_match_timeline(data)
#' }
  plot_match_timeline <- function(data) {
    # Input validation
    if (!inherits(data, "tbl_df")) {
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
      ggplot2::geom_bin_2d(data = data, ggplot2::aes(x = chapter, y = momentum), stat = "identity") +
      ggplot2::geom_col() +
      ggplot2::geom_hline(yintercept = 0, color = "black", linewidth = 0.5) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        x = "Chapter",
        y = "Narrative Momentum"
      )
  }

#' Plot character influence timeline
#'
#' Creates a stacked area chart visualizing the relative share of character
#' presence (based on possession percentage) across chapters.
#'
#' @param data A tibble containing `chapter` (integer), `character` (character),
#'   and `possession_pct` (numeric), OR an object of class 'book_analysis'
#'   containing the 'character_possession' component.
#' @return A `ggplot` object representing the stacked area chart of character influence.
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' data <- tibble(
#'   chapter = c(1L, 1L, 2L, 2L),
#'   character = c("Alice", "Rabbit", "Alice", "Hare"),
#'   possession_pct = c(0.66, 0.34, 0.40, 0.60)
#' )
#' plot_character_influence_timeline(data)
#' }
plot_character_influence_timeline <- function(data) {
    # Handle book_analysis object
    if (inherits(data, "book_analysis")) {
      data <- data$character_possession
    }

    # Input validation
    if (!inherits(data, "tbl_df") && !inherits(data, "grouped_for_data_frame")) {
      rlang::abort("Input 'data' must be a tibble.")
    }

    required_columns <- c("chapter", "character", "possession_pct")
    if (!all(required_columns %in% names(data))) {
      rlang::abort(paste0("Input 'data' must contain columns: ",
                          paste(required_columns, collapse = ", ")))
    }

    if (!is.numeric(data$chapter) || !is.character(data$character) ||
        !is.numeric(data$possession_pct)) {
      rlang::abort("Required columns must have correct types: chapter (numeric),
      character (character), possession_pct (numeric).")
    }

    if (any(data$possession_pct < 0 | data$possession_pct > 1, na.rm = TRUE)) {
      rlang::abort("'possession_pct' must be between 0 and 1.")
    }

    # Ensure chapters are sorted for the area plot to render correctly
    plot_data <- data |>
      dplyr::arrange(chapter)

    # Visualization
    ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = chapter,
        y = possession_pct,
        fill = character
      )
    ) +
      ggplot2::geom_area(alpha = 0.8, color = "white", linewidth = 0.1) +
      theme_bookmetrics() +
      ggplot2::labs(
        title = "Character Influence Through the Story",
        x = "Chapter",
        y = "Share of Character Presence",
        fill = "Character"
      )
  }

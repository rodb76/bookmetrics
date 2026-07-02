#' Plot character possession by chapter
#'
#' Creates a horizontal bar chart showing the character with the highest
#' possession percentage for each chapter.
#'
#' @param data A tibble containing `chapter` (integer), `character` (character),
#'   `mentions` (integer), `chapter_total_mentions` (integer), and
#'   `possession_pct` (numeric), OR an object of class 'book_analysis'
#'   containing the 'character_possession' component.
#' @return A `ggplot` object representing the possession percentages.
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' data <- tibble(
#'   chapter = c(1L, 1L, 2L, 2L),
#'   character = c("Alice", "Rabbit", "Alice", "Hare"),
#'   mentions = c(10L, 5L, 8L, 12L),
#'   chapter_total_mentions = c(15L, 15L, 20L, 20L),
#'   possession_pct = c(10/15, 5/15, 8/20, 12/20)
#' )
#' plot_character_possession(data)
#' }
plot_character_possession <- function(data) {
    # Handle book_analysis object
    if (inherits(data, "book_analysis")) {
      data <- data$character_possession
    }

    # Input validation
    if (!inherits(data, "tbl_df") && !inherits(data, "grouped_for_data_frame")) {
      rlang::abort("Input 'data' must be a tibble.")
    }

    required_columns <- c(
      "chapter", "character", "mentions",
      "chapter_total_mentions", "possession_pct"
    )

    if (!all(required_columns %in% names(data))) {
      rlang::abort(paste0("Input 'data' must contain columns: ",
                          paste(required_columns, collapse = ", ")))
    }

    if (any(data$possession_pct < 0 | data$possession_pct > 1, na.rm = TRUE)) {
      rlang::abort("'possession_pct' must be between 0 and 1.")
    }

    # Processing: Identify the character with highest possession per chapter
    plot_data <- data |>
      dplyr::group_by(chapter) |>
      dplyr::slice_max(possession_pct, n = 1, with_ties = FALSE) |>
      dplyr::ungroup()

    # Visualization
    ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = possession_pct, y = factor(chapter), fill = character
      )
    ) +
      ggplot2::geom_col() +
      ggplot2::geom_text(
        ggplot2::aes(
          label = scales::percent(possession_pct, accuracy = 1)
        ),
        hjust = -0.2,
        size = 3.5,
        fontface = "bold"
      ) +
      theme_bookmetrics() +
      ggplot2::labs(
        title = "Character Possession by Chapter",
        x = "Possession",
        y = "Chapter"
      ) +
      ggplot2::theme(
        legend.position = "none"
      ) +
      # Expand x limit to ensure labels are visible
      ggplot2::expand_limits(x = max(plot_data$possession_pct, na.rm = TRUE) * 1.2)
  }

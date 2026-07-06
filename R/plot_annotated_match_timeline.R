#' Plot annotated match timeline
#'
#' Creates an enhanced bar chart of narrative momentum with aggregated,
#' highly readable event annotations (e.g., "UP: CH7 BREAKTHROUGH").
#'
#' @param match_data A tibble containing `chapter` (integer) and
#'   `momentum` (numeric), OR an object of class 'book_analysis'
#'   containing the 'match_metrics' component.
#' @param event_data A tibble containing `chapter` (integer) and
#'   `event_type` (character), OR an object of class 'book_analysis'
#'   containing the 'key_events' component.
#' @return A `ggplot` object showing momentum with optimized event annotations.
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' match_df <- tibble(
#'   chapter = 1:5L,
#'   momentum = c(0, 0.2, -0.1, 0.4, -0.3)
#' )
#' event_df <- tibble(
#'   chapter = c(2L, 4L, 4L),
#'   event_type = c("breakthrough", "turning_point", "intensity_spike")
#' )
#' plot_annotated_match_timeline(match_df, event_df)
#' }
plot_annotated_match_timeline <- function(match_data, event_data) {
    # Handle book_analysis object for match_data
    if (inherits(match_data, "book_analysis")) {
      match_data <- match_data$match_metrics
    }

    # Handle book_analysis object for event_data
    if (inherits(event_data, "book_analysis")) {
      event_data <- event_data$key_events
    }

    # Input validation for match_data
    if (!inherits(match_data, "tbl_df") && !inherits(match_data, "grouped_for_data_frame")) {
      rlang::abort("Input 'match_data' must be a tibble.")
    }

    if (!inherits(event_data, "tbl_df") && !inherits(event_data, "grouped_for_data_frame")) {
      rlang::abort("Input 'event_data' must be a tibble.")
    }

    match_cols <- c("chapter", "momentum")
    if (!all(match_cols %in% names(match_data))) {
      rlang::abort(paste0("'match_data' must contain: ", paste(match_cols, collapse = ", ")))
    }

    event_cols <- c("chapter", "event_type")
    if (!all(event_cols %in% names(event_data))) {
      rlang::abort(paste0("'event_data' must contain: ", paste(event_cols, collapse = ", ")))
    }

    # 1. Aggregate event_data to combine multiple events per chapter
    events_agg <- event_data |>
      dplyr::group_by(chapter) |>
      dplyr::summarise(
        combined_events = paste(event_type, collapse = " + "),
        .groups = "drop"
      )

    # 2. Join aggregated events onto match_data
    annotated_data <- dplyr::left_join(match_data, events_agg, by = "chapter") |>
      dplyr::mutate(
        # 3. Construct informative labels with direction icons
        event_label = dplyr::case_when(
          is.na(combined_events) ~ NA_character_,
          momentum >= 0 ~ paste0("UP: CH", chapter, " ", combined_events),
          TRUE ~ paste0("DOWN: CH", chapter, " ", combined_events)
        )
      )

    # 4. Visualization
    ggplot2::ggplot(annotated_data, ggplot2::aes(x = chapter, y = momentum)) +
      # Bar chart
      ggplot2::geom_col(color = "black", linewidth = 0.2) +
      # 5. Emphasize zero line
      ggplot2::geom_hline(yintercept = 0, color = "black", linewidth = 0.8) +
      # 6. Add text labels outside bars
      ggplot2::geom_text(
        data = dplyr::filter(annotated_data, !is.na(event_label)),
        ggplot2::aes(
          label = event_label,
          vjust = ifelse(momentum >= 0, -0.5, 1.5)
        ),
        size = 3.5,
        fontface = "bold"
      ) +
      theme_bookmetrics() +
      ggplot2::labs(
        x = "Chapter",
        y = "Narrative Momentum"
      )
  }

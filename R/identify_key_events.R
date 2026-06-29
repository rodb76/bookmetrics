#' Identify key narrative events
#'
#' Detects significant narrative milestones such as breakthroughs,
#' collapses, and turning points based on momentum and intensity.
#'
#' @param data A tibble containing `chapter` (integer), `momentum` (numeric),
#'   and `intensity` (numeric).
#' @return A tibble containing `chapter` (integer), `event_type` (character),
#'   and `metric_value` (numeric) for each identified event.
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' data <- tibble(
#'   chapter = 1:5L,
#'   momentum = c(0, 0.2, -0.1, 0.4, -0.3),
#'   intensity = c(0, 0.2, 0.1, 0.4, 0.3)
#' )
#' identify_key_events(data)
#' }
  identify_key_events <- function(data) {
    # Input validation
    if (!inherits(data, "tbl_flag") && !inherits(data, "tbl_df")) {
      rlang::abort("Input 'data' must be a tibble.")
    }

    required_columns <- c("chapter", "momentum", "intensity")
    if (!all(required_columns %in% names(data))) {
      rlang::abort(paste0("Input 'data' must contain columns: ", paste(required_columns, collapse = ", ")))
    }

    if (!is.numeric(data$chapter) || !is.numeric(data$momentum) || !is.numeric(data$intensity)) {
      rlang::abort("Columns 'chapter', 'momentum', and 'intensity' must be numeric.")
    }

    # Identify breakthrough (max momentum)
    breakthrough <- data |>
      dplyr::slice_max(momentum, n = 1, with_ties = FALSE) |>
      dplyr::mutate(event_type = "breakthrough", metric_value = momentum) |>
      dplyr::select(chapter, event_type, metric_value)

    # Identify collapse (min momentum)
    collapse <- data |>
      dplyr::slice_min(momentum, n = 1, with_ties = FALSE) |>
      dplyr::mutate(event_type = "collapse", metric_value = momentum) |>
      dplyr::select(chapter, event_type, metric_value)

    # Identify turning point (max intensity)
    turning_point <- data |>
      dplyr::slice_max(intensity, n = 1, with_ties = FALSE) |>
      dplyr::mutate(event_type = "turning_point", metric_value = intensity) |>
      dplyr::select(chapter, event_type, metric_value)

    # Combine all identified events into a single tibble
    dplyr::bind_rows(breakthrough, collapse, turning_point)
  }

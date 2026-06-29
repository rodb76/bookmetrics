#' Compute match metrics from sentiment scores
#'
#' Calculates momentum and intensity based on changes in sentiment scores
#' between chapters.
#'
#' @param data A tibble containing `chapter` (integer), `sentiment_score` (numeric),
#'   and `word_count` (integer).
#' @return A tibble with the original columns plus `momentum` (numeric) and
#'   `intensity` (numeric).
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' data <- tibble(
#'   chapter = 1:3L,
#'   sentiment_score = c(0.5, 0.2, 0.8),
#'   word_count = c(100L, 150L, 120L)
#' )
#' compute_match_metrics(data)
#' }
  compute_match_metrics <- function(data) {
    # Input validation
    if (!inherits(data, "tbl_df")) {
      rlang::abort("Input 'data' must be a tibble.")
    }

    required_columns <- c("chapter", "sentiment_score", "word_count")
    if (!all(required_columns %in% names(data))) {
      rlang::abort(paste0("Input 'data' must contain columns: ",
  paste(required_columns, collapse = ", ")))
    }

    if (!is.numeric(data$chapter)) {
      rlang::abort("'chapter' must be numeric.")
    }


    if (!is.numeric(data$sentiment_score)) {
      rlang::abort("'sentiment_score' must be numeric.")
    }

    if (!is.numeric(data$word_count)) {
      rlang::abort("'word_count' must be numeric.")
    }

    # Calculation
    data |>
      dplyr::mutate(
        momentum = sentiment_score - dplyr::lag(sentiment_score, default = sentiment_score[1]),
        intensity = abs(momentum)
      )
  }

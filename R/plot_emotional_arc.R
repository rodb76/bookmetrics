#' Plot emotional arc
#'
#' Generates a publication-quality plot showing the progression of sentiment
#' scores across chapters of a book.
#'
#' @param sentiment_tibble A tibble containing at least two columns:
#'   \itemize{
#'     \item \code{chapter}: An integer representing the chapter number.
#'     \item \code{sentiment_score}: A numeric value representing the sentiment score.
#'   }
#'   OR an object of class 'book_analysis' containing the 'sentiment' component.
#' @param add_smooth A logical value indicating whether to add a loess
#'   smoothing line to the plot. Defaults to \code{TRUE}.
#'
#' @return A \code{ggplot} object representing the emotional arc.
#'
#' @examples
#' \dontrun{
#' library(tibble)
#' library(ggplot2)
#'
#' df <- tibble::tibble(
#'   chapter = 1:5L,
#'   sentiment_score = c(0.1, 0.2, -0.1, 0.0, 0.3)
#' )
#' plot_emotional_arc(df)
#' }
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point geom_smooth theme_minimal labs
#' @importFrom dplyr select
#' @importFrom tibble tibble
#' @importFrom rlang abort
#' @export
plot_emotional_arc <- function(sentiment_tibble, add_smooth = TRUE) {
    # Handle book_analysis object
    if (inherits(sentiment_tibble, "book_analysis")) {
      sentiment_tibble <- sentiment_tibble$sentiment
    }

    # 1. Input Validation
    if (!"chapter" %in% names(sentiment_tibble) || !"sentiment_score" %in%
      names(sentiment_tibble)) {
      rlang::abort("Input tibble must contain 'chapter' and 'sentiment_score' columns.")
    }

    if (!is.numeric(sentiment_tibble$chapter)) {
      rlang::abort("'chapter' column must be numeric.")
    }

    if (!is.numeric(sentiment_tibble$sentiment_score)) {
      rlang::abort("'sentiment_score' column must be numeric.")
    }

    if (nrow(sentiment_tibble) == 0) {
      return(ggplot2::ggplot(sentiment_tibble, ggplot2::aes(x = chapter, y =
        sentiment_score)) +
        ggplot2::theme_minimal())
    }

    # 2. Plot Construction
    p <- ggplot2::ggplot(sentiment_tibble, ggplot2::aes(x = chapter, y =
      sentiment_score)) +
      ggplot2::geom_line(color = "steelblue", linewidth = 1) +
      ggplot2::geom_point(size = 3, color = "darkblue") +
      theme_bookmetrics() +
      ggplot2::labs(
        title = "Emotional Arc",
        subtitle = "Progression of sentiment score across chapters",
        x = "Chapter",
        y = "Sentiment Score"
      )

    # 3. Add smoothing if requested and sufficient data exists
    if (add_smooth && nrow(sentiment_tibble) >= 3) {
      p <- p + ggplot2::geom_smooth(
        method = "loess",
        formula = y ~ x,
        se = TRUE,
        color = "red",
        fill = "pink",
        alpha = 0.2
      )
    }

    return(p)
  }

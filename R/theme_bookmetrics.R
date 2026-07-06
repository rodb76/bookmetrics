#' Default theme for bookmetrics plots
#'
#' Provides a consistent visual style across all `bookmetrics` visualizations,
#' optimized for clarity and aesthetic appeal in narrative analytics.
#'
#' @return A `theme` object.
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library	library(bookmetrics)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bookmetrics()
#' }
theme_bookmetrics <- function() {
  ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 14, margin = ggplot2::margin(b = 10)),
      plot.subtitle = ggplot2::element_text(size = 11, color = "grey40", margin = ggplot2::margin(b = 15)),
      axis.title = ggplot2::element_text(size = 10, face = "bold"),
      axis.text = ggplot2::element_text(size = 9),
      legend.position = "bottom",
      legend.title = ggplot2::element_text(size = 10, face = "bold"),
      legend.text = ggplot2::element_text(size = 9),
      panel.grid.minor = ggplot2::element_blank(),
      panel.spacing = ggplot2::unit(1, "lines")
    )
}

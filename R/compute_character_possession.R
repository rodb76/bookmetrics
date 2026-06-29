  #' Compute character possession percentage by chapter
  #'
  #' Calculates the proportion of total character mentions that belong to each
  #' specific character within a given chapter.
  #'
  #' @param data A tibble containing `chapter` (integer), `character` (character),
  #'   and `mentions` (integer).
  #' @return A tibble with the original columns plus `chapter_total_mentions` (integer)
  #'   and `possession_pct` (numeric).
  #' @export
  #' @examples
  #' \dontrun{
  #' library(tibble)
  #' character_mentions<- tibble(
  #'   chapter = c(1L, 1L, 2L, 2L),
  #'   character = c("Alice", "Rabbit", "Alice", "Hare"),
  #'   mentions = c(10L, 5L, 8L, 12L)
  #' )
  #' character_mentions <- extract_character_mentions(
  #'   chapters,
  #'   character_names = characters
  #' )
  #' compute_character_possession(character_mentions)
  #' }
  compute_character_possession <- function(data) {
    # Input validation
    if (!inherits(data, "tbl_df") && !inherits(data, "grouped_df")) {
      rlang::abort("Input 'data' must be a tibble.")
    }

    required_columns <- c("chapter", "character", "mentions")
    if (!all(required_columns %in% names(data))) {
      rlang::abort(paste0("Input 'data' must contain columns: ",
                          paste(required_columns, collapse = ", ")))
    }

    if (!is.numeric(data$chapter)) {
      rlang::abort("'chapter' must be numeric.")
    }
    if (!is.character(data$character)) {
      rlang::abort("'character' must be character.")
    }
    if (!is.numeric(data$mentions)) {
      rlang::abort("'mentions' must be numeric.")
    }

    # Calculation
    data |>
      dplyr::group_by(chapter) |>
      dplyr::mutate(
        chapter_total_mentions = as.integer(sum(mentions)),
        possession_pct = mentions / chapter_total_mentions
      ) |>
      dplyr::ungroup()
  }

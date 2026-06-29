#' Extract character mentions from text
#'
#' Identifies and counts occurrences of specific character names within
#' chapter text using word boundaries to ensure exact matches.
#'
#' @param input_data A tibble containing `chapter` (integer) and `text` (character) columns.
#' @param character_names A character vector of names to search for.
#'
#' @return A tibble containing `chapter` (integer), `character` (character),
#' and `mentions` (integer). Only returns rows where `mentions > 0`.
#'
#' @examples
#' \dontrun{
#' library(tibble)
#' library(dplyr)
#' library(stringr)
#' library(tidyr)
#'
#' chapters <- tibble(
#'   chapter = c(1L, 1L),
#'   text = c("Alice met Bob.", "Bob went home.")
#' )
#' characters <- c("Alice", "Bob", "Charlie")
#'
#' extract_character_mentions(chapters, characters)
#' }
#' @export
extract_character_mentions <- function(input_data, character_names) {
    if (!is.data.frame(input_data) || !"chapter" %in% names(input_data) ||
  !"text" %in% names(input_data)) {
      rlang::abort("`input_data` must be a tibble containing `chapter` and
  `text` columns.")
    }

    if (!is.character(character_names)) {
      rlang::abort("`character_names` must be a character vector.")
    }

    input_data |>
      tidyr::expand_grid(character = character_names) |>
      dplyr::mutate(
        pattern = stringr::str_c("\\b", character, "\\b"),
        mentions = stringr::str_count(text, stringr::regex(pattern, ignore_case
  = TRUE))
      ) |>
      dplyr::filter(mentions > 0) |>
      dplyr::select(chapter, character, mentions)
  }

#' Compute sentiment score by chapter
#'
#' Processes chapter-level text data to calculate a sentiment score based on
#' the Bing lexicon. The score is the difference between positive and negative  
#' word counts normalized by the total number of words in the chapter.          
#'                                                                              
#' @param chapter_tibble A tibble containing at least two columns:
#'   \itemize{
#'     \item \code{chapter}: An integer representing the chapter number.        
#'     \item \code{text}: A character string containing the chapter text.       
#'   }
#'
#' @return A tibble with one row per chapter containing:
#'   \itemize{
#'     \item \code{chapter}: An integer representing the chapter number.
#'     \item \code{sentiment_score}: A numeric value representing the normalized
#'       sentiment (positive - negative) / total_words.
#'     \item \code{word_count}: An integer representing the total number of
#'       tokens processed in the chapter.
#'   }
#' 
#' @param chapter_tibble a tibble
#'
#' @examples
#' \dontrun{
#' library(tibble)
#' library(dplyr)
#' library(tidytext)
#'
#' df <- tibble(
#'   chapter = 1L,
#'   text = "This is a wonderful and happy day. It is not sad."
#' )
#' compute_sentiment_by_chapter(df)
#' }
#'
#' @importFrom dplyr group_by summarize n left_join mutate select coalesce if_else
#' @importFrom tidytext unnest_tokens get_sentiments
#' @importFrom tibble tibble
#' @importFrom rlang abort
#' @export
compute_sentiment_by_chapter <- function(chapter_tibble) {
    # 1. Input Validation
    if (!"chapter" %in% names(chapter_tibble) || !"text" %in%
  names(chapter_tibble)) {
      rlang::abort("Input tibble must contain 'chapter' and 'text' columns.")
    }

    if (!is.integer(chapter_tibble$chapter)) {
      rlang::abort("'chapter' column must be of type integer.")
    }

    if (nrow(chapter_tibble) == 0) {
      return(tibble::tibble(
        chapter = integer(0),
        sentiment_score = numeric(0),
        word_count = integer(0)
      ))
    }

    # 2. Tokenization
    # Create a tokenized version of the input (one row per word)
    words_df <- chapter_tibble |>
      tidytext::unnest_tokens(word, text)

    # 3. Word counts per chapter
    # Calculate how many words exist in each chapter that was present in the input
    word_counts <- words_df |>
      dplyr::group_by(chapter) |>
      dplyr::summarize(word_count = dplyr::n(), .groups = "drop")

    # 4. Sentiment counts per chapter
    # Use the Bing lexicon to identify positive and negative words
    #bing_lexicon <- tidy
    bing_lexicon <- tidytext::get_sentiments("bing")

    sentiment_counts <- words_df |>
      dplyr::inner_join(bing_lexicon, by = "word") |>
      dplyr::group_by(chapter) |>
      dplyr::summarize(
        pos = sum(sentiment == "positive", na.rm = TRUE),
        neg = sum(sentiment == "negative", na.rm = TRUE),
        .groups = "drop"
      )

    # 5. Combine results back to the original chapters
    # We join back to chapter_tibble to ensure chapters with 0 words are preserved
    results <- chapter_tibble |>
      dplyr::left_join(word_counts, by = "chapter") |>
      dplyr::left_join(sentiment_counts, by = "chapter") |>
      dplyr::mutate(
        word_count = dplyr::coalesce(word_count, 0L),
        pos = dplyr::coalesce(pos, 0),
        neg = dplyr::coalesce(neg, 0),
        sentiment_score = dplyr::if_else(
          word_count > 0,
          (pos - neg) / word_count,
          0
        )
      ) |>
      dplyr::select(chapter, sentiment_score, word_count)

    return(results)
  }

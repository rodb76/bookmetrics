 #' Split book text into chapters
  #'
  #' Processes a single string of book text and splits it into a tidy tibble      #' where each row represents a detected chapter. Each chapter starts with
  #' its detected heading.                                                        #'
  #' @param text_tibble A tibble containing exactly one row with a `text`
  #'   column containing the full book content.
  #'
  #' @return A tibble with two columns:
  #'   \itemize{
  #'     \item \code{chapter}: An integer representing the sequential chapter number.
  #'     \item \code{text}: A character string containing the content of that chapter,
  #'       including the heading.
  #'   }
  #'
  #' @examples
  #' \dontrun{
  #'   # Assuming df is a tibble with a single 'text' column
  #'   chapters <- split_into_chapters(df)
  #'   print(chapters)
  #' }
  #'
  #' @importFrom tibble tibble
  #' @importFrom stringr str_split str_detect
  #' @importFrom dplyr mutate
  #' @importFrom purrr map_chr
  #' @export
  split_into_chapters <- function(text_tibble) {
    # 1. Input Validation
    if (!"text" %in% names(text_tibble)) {
      stop("Input tibble must contain a 'text' column.")
    }

    if (nrow(text_tibble) != 1) {
      stop("Input tibble must contain exactly one row.")
    }

    full_text <- text_tibble$text[1]
    if (is.na(full_text) || nchar(full_text) == 0) {
      return(tibble::tibble(chapter = integer(0), text = character(0)))
    }

    # 2. Split text into lines
    lines <- stringr::str_split(full_text, "\\n")[[1]]
    lines <- lines[nzchar(trimws(lines))] # Remove purely whitespace lines

    # 3. Improved Regex for Chapter Boundaries
    # Anchored to start of line, handles "Chapter 1", "CHAPTER I", "Letter II", etc.
    #chapter_pattern <- "^(?i)(chapter|book|letter|section)\\s*([0-9A-Z\\.\\-]+)"
    chapter_pattern <- "^(?i)(chapter|book|letter|section)\\s+([0-9]+|[IVXLCDM]+)"

    # Identify indices of lines that are chapter headings
    chapter_indices <- which(stringr::str_detect(lines, chapter_pattern))

    # 4. Handle no chapters found
    if (length(chapter_indices) == 0) {
      return(tibble::tibble(
        chapter = 1L,
        text = full_text
      ))
    }

    # 5. Segmentation Logic
    # We iterate through the detected indices.
    # Each segment starts at current index and ends at the line before the next index.
    num_chapters <- length(chapter_indices)

    chapters_list <- lapply(seq_along(chapter_indices), function(i) {
      start_line_idx <- chapter_indices[i]

      # End index is the line before the next chapter start, or the end of the
  file
      if (i < num_chapters) {
        end_line_idx <- chapter_indices[i + 1] - 1
      } else {
        end_line_idx <- length(lines)
      }

      # Extract lines and collapse
      segment_content <- paste(lines[start_line_idx:end_line_idx], collapse =
  "\n")
      return(segment_content)
    })

    # 6. Create Output Tibble
    result <- tibble::tibble(
      chapter = as.integer(seq_along(chapters_list)),
      text = unlist(chapters_list, use.names = FALSE)
    )

    return(result)
  }

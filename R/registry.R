#' Internal book registry for bookmetrics

# Private registry of books: each entry has url, title, author
.book_registry <- list(
  "alice" = list(
    url = "https://www.gutenberg.org/files/11/11-0.txt",
    title = "Alice's Adventures in Wonderland",
    author = "Lewis Carroll"
  ),
  "dracula" = list(
    url = "https://www.gutenberg.org/files/345/345-0.txt",
    title = "Dracula",
    author = "Bram Stoker"
  ),
  "pride_and_prejudice" = list(
    url = "https://www.gutenberg.org/files/1342/1342-0.txt",
    title = "Pride and Prejudice",
    author = "Jane Austen"
  ),
  "frankenstein" = list(
    url = "https://www.gutenberg.org/files/84/84-0.txt",
    title = "Frankenstein",
    author = "Mary Wollstonecraft Shelley"
  ),
  "sherlock_holmes" = list(
    url = "https://www.gutenberg.org/files/1661/1661-0.txt",
    title = "The Adventures of Sherlock Holmes",
    author = "Arthur Conan Doyle"
  ),
  "moby_dick" = list(
    url = "https://www.gutenberg.org/files/2701/2701-0.txt",
    title = "Moby Dick; Or, The Whale",
    author = "Herman Melville"
  ),
  "tom_sawyer" = list(
    url = "https://www.gutenberg.org/files/747/747-0.txt",
    title = "The Adventures of Tom Sawyer",
    author = "Mark Twain"
  ),
  "treasure_island" = list(
    url = "https://www.gutenberg.org/files/120/120-0.txt",
    title = "Treasure Island",
    author = "Robert Louis Stevenson"
  ),
  "grimms_fairy_tales" = list(
    url = "https://www.gutenberg.org/files/2591/2591-0.txt",
    title = "Grimms' Fairy Tales",
    author = "Jacob Grimm and Wilhelm Grimm"
  ),
  "the_canterbury_tales" = list(
    url = "https://www.gutenberg.org/files/1041/1041-0.txt",
    title = "The Canterbury Tales",
    author = "Geoffrey Chaucer"
  ),
  "the_call_of_the_wild" = list(
    url = "https://www.gutenberg.org/files/216/216-0.txt",
    title = "The Call of the Wild",
    author = "Jack London"
  )
)

#' List all registered books in the registry
#'
#' @return A character vector of book identifiers.
#' @export
list_books <- function() {
  names(.book_registry)
}

#' Get the Project Gutenberg URL for a registered book identifier
#'
#' @param book A character string representing the book identifier or a direct URL.
#' @return A character string containing the URL, or NULL if not found in registry.
#' @export
get_book_url <- function(book) {
  if (book %in% names(.book_registry)) {
    return(.book_registry[[book]]$url)
  }
  return(NULL)
}

#' Get title/author metadata for a registered book identifier
#'
#' @param book A character string representing the book identifier.
#' @return A list with `title` and `author`, or NULL if not found in registry.
#' @export
get_book_metadata <- function(book) {
  if (book %in% names(.book_registry)) {
    return(.book_registry[[book]][c("title", "author")])
  }
  return(NULL)
}
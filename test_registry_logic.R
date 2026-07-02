# Load the registry directly (since we can't easily load the whole package without installation)
source("R/registry.R")

# Test list_books()
books <- list_books()
cat("List of books:\n")
print(books)
if (length(books) < 10) stop("Not enough books in registry!")

# Test get_book_url() with identifier
url_alice <- get_book_url("alice")
cat("\nURL for 'alice':\n")
print(url_alice)
if (!is.character(url_alice) || !grepl("gutenberg", url_alice)) stop("Incorrect URL for 'alice'!")

# Test get_book_reg_url() with non-existent identifier
url_none <- get_book_url("non_existent")
cat("\nURL for 'non_existent':\n")
print(url_none)
if (!is.null(url_none)) stop("Should return NULL for non-existent book!")

# Test with a direct URL (as it should be handled in analyse_book, but let's check get_book_url behavior)
# The requirement says: "get_book_url() ... returns the URL if the book is a registered identifier; otherwise, returns NULL"
# So this part is correct.

cat("\nAll registry tests passed!\n")

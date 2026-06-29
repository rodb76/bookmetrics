library(bookmetrics)
library(dplyr)
library(ggplot2)

# 1. Setup output directory
output_dir <- "man/figures"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

message("Starting Alice in Wonderland analysis pipeline...")

# 2. Load and Parse
url <- "https://www.gutenberg.org/files/11/11-0.txt"
book_data <- load_gutenberg_book(url, strict = FALSE)
chapters <- split_into_chapters(book_data)

# 3. Sentiment and Match Metrics
sentiment_data <- compute_sentiment_by_chapter(chapters)
match_metrics <- compute_match_metrics(sentiment_data)
events <- identify_key_events(match_metrics)

# 4. Character Analysis
chars <- c("Alice", "Rabbit", "Hare", "Caterpillar")
char_mentions <- extract_character_mentions(chapters, chars)
possession_data <- compute_character_possession(char_mentions)

message("Pipeline completed successfully.")

# 5. Generate and save visualizations
message("Generating visualizations...")

# Plot 1: Emotional Arc
p1 <- plot_emotional_arc(sentiment_data)
ggsave(file.path(output_dir, "01_emotional_arc.png"), p1, width = 8, height = 6)

# Plot 2: Match Timeline (Momentum)
p2 <- plot_match_timeline(match_metrics)
ggsave(file.path(output_dir, "02_match_timeline.png"), p2, width = 8, height = 6)

# Plot 3: Annotated Match Timeline
p3 <- plot_annotated_match_timeline(match_metrics, events)
ggsave(file.path(output_dir, "03_annotated_match_timeline.png"), p3, width = 12, height = 8)

# Plot 4: Character Possession
p4 <- plot_character_possession(possession_data)
ggsave(file.path(output_dir, "04_character_possession.png"), p4, width = 8, height = 6)

# Plot 5: Character Influence Timeline (if it exists and works)
# Note: The file was renamed to plot_character_influence_timeline.R
if ("plot_character_influence_timeline" %in% ls()) {
  p5 <- plot_character_influence_timeline(possession_data)
  ggsave(file.path(output_dir, "05_character_influence_timeline.png"), p5, width = 10, height = 6)
}

message(paste0("All visualizations saved to the '", output_dir, "' directory."))

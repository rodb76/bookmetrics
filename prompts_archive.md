Write an R function compute_sentiment_by_chapter() following CLAUDE.md.

Requirements:

Input:
- A tibble containing:
  - chapter (integer)
  - text (character)

Output:
- A tibble containing:
  - chapter (integer)
  - sentiment_score (numeric)
  - word_count (integer)

Implementation:

1. Tokenize chapter text into words using tidytext
2. Use the Bing sentiment lexicon
3. Count positive and negative words per chapter
4. Compute:

sentiment_score =
(positive_count - negative_count) / total_words

5. Preserve chapter as the key
6. Include input validation
7. Include full roxygen2 documentation

Return only the function.
---
## phase 3
Write an R function plot_emotional_arc() following CLAUDE.md.

Requirements:

Input:
- A tibble containing:
  - chapter (integer)
  - sentiment_score (numeric)

Output:
- A ggplot object

Implementation:

1. Plot:
   - x = chapter
   - y = sentiment_score

2. Include:
   - line connecting chapters
   - points for each chapter
   - optional loess smoothing line

3. Styling:
   - theme_minimal()
   - publication-quality labels
   - no plot printing inside the function

4. Input validation

5. Include full roxygen2 documentation

Return only the function.

---
Write an R function compute_match_metrics() following CLAUDE.md.

Requirements:

Input:
- A tibble containing:
  - chapter (integer)
  - sentiment_score (numeric)
  - word_count (integer)

Output:
- A tibble containing:
  - chapter
  - sentiment_score
  - word_count
  - momentum (numeric)
  - intensity (numeric)

Implementation:

1. Preserve all existing columns

2. Compute:

momentum =
current chapter sentiment_score -
previous chapter sentiment_score

3. For chapter 1:
- momentum = 0

4. Compute:

intensity = abs(momentum)

5. Preserve chapter as key

6. Include input validation

7. Include full roxygen2 documentation

8. Use tidyverse style and explicit namespaces

Return only the function.
---
Write an R function plot_match_timeline() following CLAUDE.md.

Requirements:

Input:
- A tibble containing:
  - chapter (integer)
  - momentum (numeric)
  - intensity (numeric)

Output:
- A ggplot object

Implementation:

1. Create a bar chart:
   - x = chapter
   - y = momentum

2. Add:
   - horizontal line at y = 0
   - bars extending above and below zero

3. Styling:
   - theme_minimal()
   - publication-quality labels
   - x-axis labelled "Chapter"
   - y-axis labelled "Narrative Momentum"

4. Input validation

5. Return a ggplot object only

6. Include full roxygen2 documentation

Return only the function.

---
Write an R function identify_key_events() following CLAUDE.md.

Requirements:

Input:
- A tibble containing:
  - chapter (integer)
  - momentum (numeric)
  - intensity (numeric)

Output:
- A tibble containing:
  - chapter (integer)
  - event_type (character)
  - metric_value (numeric)

Implementation:

1. Identify:
   - the chapter with the maximum momentum
     -> event_type = "breakthrough"

2. Identify:
   - the chapter with the minimum momentum
     -> event_type = "collapse"

3. Identify:
   - the chapter with the maximum intensity
     -> event_type = "turning_point"

4. Return one row per event

5. Preserve tidy tibble output

6. Include input validation

7. Include full roxygen2 documentation

8. Use explicit namespaces

Return only the function.

---
Write an R function plot_annotated_match_timeline() following CLAUDE.md.

Requirements:

Inputs:

1. match_data:
   - chapter (integer)
   - momentum (numeric)

2. event_data:
   - chapter (integer)
   - event_type (character)

Output:
- A ggplot object

Implementation:

1. Create the same bar chart as plot_match_timeline():
   - x = chapter
   - y = momentum

2. Add:
   - horizontal line at y = 0

3. Join event_data onto match_data by chapter

4. Add text labels for event_type above or below the relevant bars

5. Styling:
   - theme_minimal()
   - publication-quality labels

6. Input validation

7. Return a ggplot object only

8. Include full roxygen2 documentation

Return only the function.
---
Refactor plot_annotated_match_timeline().

The current annotations are difficult to read.

Improve storytelling and readability.

Requirements:

1. Move labels outside bars:
   - positive momentum:
     label above bar
   - negative momentum:
     label below bar

2. Labels must include:
   - chapter number
   - event_type

Examples:
- "▲ CH7 BREAKTHROUGH"
- "▼ CH8 COLLAPSE"

3. Multiple events in the same chapter must be combined into one label.

Example:
"▲ CH7 BREAKTHROUGH + TURNING_POINT"

4. Labels must not overlap bars.

5. Reduce visual clutter:
   - lighten gridlines
   - emphasize zero line

6. Keep:
   - theme_minimal()
   - input validation
   - tidy implementation

Return only the updated function.
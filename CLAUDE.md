# Project Standards & Coding Guidelines

## 1. Project Objective

This repository builds an R package for analyzing public-domain books and
producing tidy, reusable datasets for downstream visualization.

All code must support:
- Modular analysis pipelines
- Book-agnostic processing
- Reproducible outputs
- Publication-quality visualizations

---

## 2. Core Development Philosophy

### Functional Programming
- All logic must be encapsulated in functions.
- Standalone scripts are prohibited unless explicitly requested.
- Functions must do one thing only.

### Modular Design
- Avoid global variables.
- All dependencies must be explicitly passed as arguments.
- Functions must be composable using `|>`.

### Explicit Over Clever
- Prefer readability over conciseness.
- Prefer explicit transformations over hidden side effects.
- Do not use "magic" behavior.

### Reusability
- Functions must operate on any valid input meeting the required schema.
- No book-specific assumptions.

---

## 3. Naming Conventions

### Functions
- Use `snake_case`.
- Function names must begin with a verb.

Examples:
- `load_gutenberg_book()`
- `split_into_chapters()`
- `compute_sentiment_by_chapter()`
- `plot_emotional_arc()`

### Variables
- Use `snake_case`.
- Avoid unnecessary abbreviations.

---

## 4. Data In → Data Out Contract

All analysis functions must follow:

Input:
- `tibble`

Output:
- `tibble`

Rules:
- Never mutate objects in the global environment.
- Treat inputs as immutable.
- Never return lists when a tibble is expected.
- Preserve key identifiers unless explicitly aggregating.

---

## 5. Core Data Contract

### Book-Level Data

Must contain:

- `text` (character)

### Chapter-Level Data

Must contain:

- `chapter` (integer)
- `text` (character)

Rules:
- `chapter` must always be sequential integers starting at 1.
- `chapter` must be preserved across downstream analyses unless explicitly aggregated.

### Metadata

Rules:
- Metadata must be stored as structured tibbles.
- Do not use unstructured list columns unless explicitly required.

---

## 6. Function Standards

All exported functions must:

- Be focused and ideally under 50 lines.
- Validate inputs early.
- Fail fast with clear error messages.
- Avoid side effects.
- Be deterministic and reproducible.

### Error Handling
Use:

- `rlang::abort()` preferred
- `stop()` acceptable

Never silently fail.

---

## 7. Documentation Standards

All exported functions must include full roxygen2 documentation:

Required tags:

- `@param`
- `@return`
- `@examples`
- `@export`

Examples must be executable or wrapped in `\\dontrun{}`.

---

## 8. Dependency Management

Rules:

- Use explicit namespaces:
  - `dplyr::`
  - `stringr::`
  - `ggplot2::`

- Do not call `library()` inside functions.
- Do not rely on attached packages.

Remove unused imports.

---

## 9. Analysis Function Pattern

All analysis functions must follow:

Input:
- tidy tibble

Process:
- add derived variables

Output:
- tidy tibble

Examples:

- `compute_sentiment_by_chapter()`
- `compute_character_network()`
- `compute_match_metrics()`

Rules:
- Preserve key identifiers.
- Add clearly named derived columns.

---

## 10. Visualization Standards

All visualization functions must:

- Use `ggplot2`
- Return a `ggplot` object
- Never print plots internally

Styling rules:

- Use publication-quality themes:
  - `theme_minimal()`
  - `theme_classic()`

- Never use default grey backgrounds.
- All axes must be clearly labelled.
- Legends must be readable.
- Visual styling must be consistent across the package.

Examples:

- `plot_emotional_arc()`
- `plot_match_timeline()`
- `plot_character_network()`

---

## 11. Text Processing Standards

Text processing functions must:

- Handle UTF-8 encoding explicitly.
- Be robust to formatting variations.
- Use flexible pattern matching.
- Fail clearly when parsing assumptions break.

Never hardcode:

- chapter formats
- character names
- specific books
- file paths

---

## 12. Forbidden Patterns

Never:

- Mix analysis and visualization in one function.
- Mix downloading and analysis in one function.
- Hardcode file paths.
- Hardcode book-specific logic.
- Create monolithic functions.
- Use hidden side effects.
- Return inconsistent schemas.
- Introduce random behavior without explicit arguments.

---

## 13. Claude Code Behaviour

When generating code:

- Follow this document strictly.
- Prefer extending existing abstractions over creating new ones.
- Modify only what is necessary.
- Preserve existing naming conventions.
- Do not rewrite unrelated code.
- Do not include unnecessary explanation.

If assumptions are unclear:

- Ask for clarification before generating code.

When refactoring:

- Preserve public interfaces unless explicitly asked to change them.

## Documentation & README Maintenance

Requirements:

1. Any new exported function must include:
   - a runnable example
   - roxygen2 documentation
   - clear input/output schema

2. README.md must be updated whenever:
   - a new user-facing feature is added
   - a new visualization is added
   - the package pipeline changes

3. README.md must contain:
   - package overview
   - installation instructions
   - a complete end-to-end example workflow
   - example visualizations
   - minimal reproducible examples

4. The README example pipeline must always run successfully against:
   - Alice's Adventures in Wonderland
   - Project Gutenberg ID 11

5. README examples must use:
   - explicit object names
   - tidyverse-style pipelines
   - reproducible code

6. README.md should be treated as:
   - documentation
   - integration test
   - package showcase


## README Synchronisation

Whenever a new exported function is added:

1. Update README.md
2. Add function to the example pipeline
3. Add a short explanation of the feature
4. Add example code using Alice in Wonderland
5. Ensure the README example executes without modification
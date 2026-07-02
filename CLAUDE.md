# CLAUDE.md

## Development Environment
- **Language**: R
- **Primary Tools**: `testthat` (testing), `pkgdown` (documentation), `devtools` (development)

## Feature Implementation Workflow

When implementing a new feature or analysis step, follow these steps to ensure the documentation and tests remain in sync:

### 1. Implement Core Logic
- Add your new computation function in `R/`.
- If it's an analysis component, update `R/analyse_book.R` to include it in the pipeline.
- Use `theme_bookmetrics()` for any new plots.

### 2. Update Tests
- **Unit Tests**: Add new tests in `tests/testthat/` covering:
    - Happy path (standard input).
    - Edge cases (empty text, no characters found).
    - Invalid inputs (wrong types).
- **Integration Test**: If the feature changes the output structure or adds a new visual, update `tests/testthat/test-e2e_integration.R` to verify the presence of the new artifact in the gallery.

### 3. Update Documentation
- **Function Docs**: Use Roxygen2 (`#'`) for all exported functions.
- **README**: If there's a new usage pattern (like a new `analyse_*` function), add an example to `README.md`.
- **Gallery**: Ensure the new plot is included in `R/generate_gallery.R` so it appears in the HTML output.

### 4. Automated Maintenance
After any feature implementation, Claude should:
- [ ] Update all relevant `testthat` files.
- [ ] Verify that `tests/testthat/test-e2e_integration.R` still passes.
- [ ] Refresh `README.md` examples.
- [ ] (If requested) rebuild the pkgdown site documentation.

## Project Structure
- `R/`: Core package logic and exported functions.
- `tests/testthat/`: Automated test suite.
- `man/`: Generated Roxygen2 documentation.
- `README.md`: User guide and overview.
- `CONTRIBUTING.md`: Developer guidelines.
- `CLAUDE.md`: AI developer instructions.

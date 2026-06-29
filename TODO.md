

# 🧠 Where You Are Now

You have:

### ✅ System foundation

* `CLAUDE.md` → defines how Claude writes code
* R package structure started
* Clear rules for modular, tidy outputs

### ✅ Core pipeline (this is big)

* `load_gutenberg_book()` → ingestion
* `split_into_chapters()` → structure

👉 This means you can now reliably turn raw text into:

```
chapter | text
```

That’s your **core data contract**. Everything builds on this.

---

# 🎯 What You’re Building Toward

You’re creating:

> A modular analysis engine + visualization system for books

With:

* Reusable analysis “skills”
* Swappable books
* Eventually a website/dashboard

---

# ✅ Your Task Checklist (in the right order)

## 🧱 Phase 1: Lock the Foundation

* [ ] Fix final small issues:

  * [ ] Clean roxygen formatting in both functions
  * [ ] Add UTF-8 encoding to `load_gutenberg_book()`
  * [ ] Slightly relax chapter regex (`^(?i)(chapter|book|letter|section)\\b.*`)
  * [ ] Remove unused imports

* [ ] Run locally:

  * [ ] `devtools::document()` (ensure docs build)
  * [ ] Test both functions on 1–2 books

---

## 📊 Phase 2: First Analysis Skill (VERY IMPORTANT)

* [ ] Create `compute_sentiment_by_chapter()`
* [ ] Validate output:

  * [ ] Sentiment values look reasonable
  * [ ] Word counts are correct
* [ ] Sanity check against a real book (e.g. Dracula)

---

## 📈 Phase 3: First Visualization (your first “real output”)

* [ ] Create `plot_emotional_arc()`
* [ ] Requirements:

  * [ ] Smooth sentiment curve
  * [ ] Clean, publication-quality styling
* [ ] Check:

  * [ ] Does it *look good*?
  * [ ] Does it *make sense narratively*?

👉 This is your first portfolio-worthy artifact.

---

## ⚽ Phase 4: Sports Visualization Layer (your unique angle)

* [ ] Define “match metrics”:

  * [ ] Momentum (sentiment over time)
  * [ ] Possession (character presence later)
  * [ ] Key events (sentiment spikes)

* [ ] Create:

  * [ ] `compute_match_metrics()`
  * [ ] `plot_match_timeline()`

👉 Don’t overcomplicate yet—start simple.

---

## 🧑‍🤝‍🧑 Phase 5: Character Analysis

* [ ] Extract character mentions
* [ ] Build co-occurrence network
* [ ] Create:

  * [ ] `compute_character_network()`
  * [ ] `plot_character_network()`

---

## 🌐 Phase 6: Package → App

* [ ] Build a simple `shiny` app:

  * [ ] Input: book URL
  * [ ] Output:

    * Emotional arc
    * Match-style timeline

* [ ] Optional:

  * [ ] Add comparison mode (2 books)

---

## 🔁 Phase 7: Make It Reusable (important)

* [ ] Test on multiple books:

  * Frankenstein
  * Moby-Dick

* [ ] Fix:

  * [ ] Chapter parsing edge cases
  * [ ] Sentiment inconsistencies

---

# 🧠 Key Discipline Going Forward

At every step:

👉 Don’t just write code—ask:

* Does this follow my data contract?
* Is this reusable across books?
* Is this modular?

---





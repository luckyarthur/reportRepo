# Task: Read Each Book and Summarize It Chapter-by-Chapter with Core Knowledge

Write the result to `output.md` in this folder.

## Objective
For **every book provided** to this task, read its full content and produce a structured, chapter-by-chapter summary that captures both *what each chapter says* and *the core knowledge / key takeaways* of that chapter. The goal is a study companion: someone who reads `output.md` should understand the essential ideas of each book without having read it.

## Where the books come from
Look for book files in this folder, in priority order:
1. The `books/` subdirectory inside this task folder (`tasks/13-book-chapter-summaries/books/`).
2. Any book file committed directly into this task folder.

Supported formats: `.epub`, `.pdf`, `.txt`, `.md`, `.docx`, `.mobi`.

If no book file is present, do **not** invent content. Write `output.md` stating: "No book files found in `books/`. Add a book (epub/pdf/txt/…) to this folder and re-run." and stop.

## Available parsers
The `SessionStart` hook installs these Python libraries automatically (see `scripts/setup-book-tools.sh`):
- `pymupdf` (import as `fitz`) → PDF text extraction.
- `mobi` → MOBI extraction to HTML (`mobi.extract(path)` returns a tempdir + `book.html`).
- `ebooklib` → EPUB convenience layer. Plain `zipfile` + regex over the XHTML also works.
- For Chinese books, decode as UTF-8 and keep CJK punctuation intact; do not transliterate names.

## Steps of work
1. **Discover** every book file in the locations above. List them.
2. **Extract text** from each book (PyMuPDF for PDF, `mobi` for MOBI, `zipfile`/`ebooklib` for EPUB, plain read for TXT/MD). Identify the chapter/section structure from the table of contents and headings.
3. **For each chapter**, write:
   - The chapter number and title.
   - A 3–6 sentence summary of the chapter's content in plain language.
   - A short **"Core knowledge"** block: 3–6 bullet points listing the essential concepts, principles, frameworks, or facts the reader must retain.
   - Where useful, one short representative quote from the chapter (in quotation marks), with the chapter noted.
4. **Per book**, also write a top-level book header with: title, author (if known), and a 2–4 sentence overview of the whole book and its central thesis.
5. **Repeat for every book** found.

## Required structure of `output.md`
- **Document title** and a one-line note listing how many books were processed and the date.
- For **each book**, a major section (`# <Book Title>`) containing:
  - **Overview** — author, central thesis, who it's for.
  - **Chapter-by-chapter summaries** — one subsection per chapter (`## Chapter N — <Title>`), each with the summary, the "Core knowledge" bullets, and optional quote as described above.
  - **Whole-book core takeaways** — a final 5–8 bullet list distilling the single most important lessons of the entire book.
- If multiple books are processed, separate them with a horizontal rule (`---`) and keep their sections clearly distinct.

## Rules & cautions
- **Fidelity over brevity:** base every summary strictly on the actual book text. Do not pad with outside knowledge, and do not hallucinate chapters that don't exist.
- Preserve the book's real chapter order and titles as found in its table of contents.
- If a book has parts/sections grouping multiple chapters, reflect that hierarchy.
- If a book is very long, still cover every chapter, but keep each chapter summary tight (the per-chapter limits above).
- Quote sparingly and accurately; never fabricate a quotation.

## Style
- Clear, neutral, study-guide tone.
- Consistent heading structure so the file is easy to navigate.
- No fixed total length — it scales with the number and size of the books — but keep each individual chapter summary within the limits above.

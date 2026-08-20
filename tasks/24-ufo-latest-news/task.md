# Task: Fetch the Latest UFO/UAP News & Disclosures — Rolling 90-Day Window

Write the result to `output.md` in this folder.

## Objective
Search the web for **the most recent developments concerning UFOs / UAP (Unidentified Anomalous Phenomena)** and produce a concise, well-sourced briefing on what is genuinely new.

The coverage window is **the 90 days immediately preceding the date the research is performed**. Compute that window explicitly from the current date at the start of the run and state both the start and end dates in the output. Do not use a hardcoded window.

"New" should be interpreted broadly and includes anything **published, released, or first reported inside that window**:
- Government / military disclosures, hearings, testimony, legislation, FOIA releases, or declassified documents (e.g. U.S. DoD **AARO**, Congressional hearings, the UAP Disclosure Act and its successors, foreign-government releases from the UK, France/GEIPAN, Japan, Brazil, Chile, etc.).
- New official UAP sighting reports, case resolutions, datasets, or statistics published in the window.
- Peer-reviewed papers, preprints, scientific studies, or institutional reports (e.g. the **Galileo Project**, NASA, university groups, SETI-adjacent work).
- Notable media releases tied to the topic: documentaries, books, films, TV episodes, podcasts, or major investigative journalism.
- Credible witness testimony or whistleblower statements first made public in the window.
- Debunkings, retractions, and prosaic explanations of previously-publicized cases — **these count as news and must not be omitted just because they are deflationary.**

## Relationship to task 12
`tasks/12-ufo-june-2026-releases/` covers a fixed month (June 2026). This task is a **rolling recency sweep** and its window may partially overlap that month. If an item is already covered there, either omit it or mention it in one line under a "previously covered" note — do not re-report it in full. New developments *about* an older item (a follow-up hearing, a correction, a released transcript) **do** belong here.

## Steps of work
1. **Establish the window.** Record today's date and the 90-day start date. Put both in the output's scope line.
2. **Search broadly.** Run multiple, varied queries across news, government, and science sources — e.g. "UAP news", "AARO report", "UAP congressional hearing", "UFO whistleblower testimony", "UAP declassified documents", "Galileo Project findings", "UAP peer-reviewed study", "new UFO documentary", plus the month and year names that fall inside the window. Include at least one non-U.S. query.
3. **Check primary sources directly.** Visit official pages where they exist (AARO, DoD, Congressional committee pages, NASA, journal sites) rather than relying on aggregator summaries.
4. **Fetch & verify.** Open the most relevant sources and confirm the publication/release date falls inside the window. Discard anything outside it or undated.
5. **Deduplicate & rank.** Group coverage of the same event; rank by significance and source credibility (official government > peer-reviewed > major outlets > blogs/forums/social media).
6. **Summarize.** Write the briefing described below.
7. **Cite.** Every claim carries a source link and a publication date.

## Required structure of `output.md`
- **Title + scope line** stating the exact coverage window (start date – end date) and the date the research was performed.
- **TL;DR** — 3–6 bullets capturing the most important developments in the window.
- **Government & official activity** — one subsection per item: what it is, who released it, exact date, 2–4 sentence summary, why it matters, source link(s).
- **Science & research** — papers, datasets, institutional findings, with the same per-item treatment. Note the venue and whether the work is peer-reviewed or a preprint.
- **Testimony & claims** — witness/whistleblower statements first made public in the window, each explicitly labelled with its corroboration status.
- **Debunkings & corrections** — cases resolved, claims walked back, or evidence shown to be prosaic.
- **Media & entertainment releases** — table of UFO-themed films, shows, books, documentaries, or podcasts released in the window (Title | Type | Release date | Platform/Publisher | One-line description | Source).
- **Credibility ledger** — table rating each major item: Item | Source type | Evidence offered | Independently corroborated? (Yes / Partial / No) | Confidence (High / Medium / Low).
- **Cross-cutting themes** — short paragraph on patterns across the window.
- **What to watch next** — any scheduled hearings, pending report deadlines, or announced releases falling after the window, each with a date and source.
- **Sources** — consolidated list of all links used, each tagged with its publication date and source type.

## Rules & cautions
- **Accuracy over completeness.** This is a live current-events task — only include items verifiable against a real, dated source. Do **not** fabricate reports, hearings, papers, titles, names, or dates.
- If web access is unavailable, or the search returns no verifiable items in the window, say so explicitly in `output.md`, list the exact queries attempted and what each returned, and report "No verifiable items found in window" rather than inventing content. A short, honest output is a correct output.
- **Separate evidence from assertion.** Distinguish clearly between (a) documented official actions, (b) peer-reviewed findings, (c) individual claims and testimony, and (d) speculation and tabloid reporting. Label each.
- An official body *investigating* a claim is not the same as that body *confirming* it — never blur the two.
- Treat single-source, uncorroborated, and anonymously-sourced claims as such, in the text and in the credibility ledger.
- Prefer primary sources (government sites, journals, official transcripts) over aggregators. Avoid social-media posts as sole sourcing for any factual claim.
- Note explicitly when a widely-circulated story rests on a video, image, or document whose provenance has not been established.

## Style
- Neutral, journalistic tone — no sensationalism, no wink-and-nudge framing, and equally no reflexive dismissal. Report what is documented and say plainly what is unknown.
- ~700–1200 words plus the tables and sources list.
- Use clear section headings matching the structure above.

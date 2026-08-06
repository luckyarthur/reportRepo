# Task: Swift & SwiftUI Interview Set — Filtered Analysis and Solutions

Write the result to `output.md` in this folder.

## Objective
Derive a focused, Swift-and-SwiftUI-only interview reference from the broader iOS hiring research in `tasks/18-ios-interview-questions/output.md`. Take that report's assessment catalogue, **filter it down to the items that are genuinely about the Swift language and the SwiftUI framework**, and present each one with its analysis and solution as a standalone, self-contained study document.

This is a derivation task, not a fresh research task. The prior report is the primary input.

## Prerequisite
`tasks/18-ios-interview-questions/output.md` must exist. If it does not, complete task 18 first — do not attempt to reconstruct its findings from scratch here.

## Step 1 — Filter
Read `tasks/18-ios-interview-questions/output.md` and select every assessment item (question, live-coding problem, take-home brief, system-design prompt, or follow-up) whose core subject is **Swift the language** or **SwiftUI the framework**.

**In scope:**
- **Swift language & type system** — optionals and unwrapping, value vs. reference semantics, `struct` vs. `class` vs. `enum`, copy-on-write, generics, associated types, opaque and existential types (`some` / `any`), protocol-oriented design, property wrappers, result builders, `Codable`, error handling, access control, key paths, macros.
- **Memory & runtime** — ARC, strong/`weak`/`unowned`, retain cycles in closures and delegates, capture lists, `@escaping`, autorelease behaviour, value-type performance.
- **Swift concurrency** — `async`/`await`, structured concurrency and task trees, `Task` and cancellation, `TaskGroup`, actors and actor isolation, `@MainActor`, `Sendable`, data-race safety, Swift 6 strict concurrency mode, migrating from GCD/completion handlers, `AsyncSequence`/`AsyncStream`.
- **SwiftUI** — view identity and the diffing/re-render model, `@State` / `@Binding` / `@StateObject` / `@ObservedObject` / `@EnvironmentObject` / `@Environment`, Observation (`@Observable`) vs. `ObservableObject`, the layout system and sizing negotiation, `PreferenceKey` and `GeometryReader`, `List`/`LazyVStack` performance, animations and transitions, navigation (`NavigationStack`, value-based navigation, deep links), `Form`/focus/keyboard handling, SwiftUI ↔ UIKit interop (`UIViewRepresentable`, `UIHostingController`), previews, testability, accessibility in SwiftUI.
- **Swift-based architecture and testing** where the question is really about Swift/SwiftUI mechanics (e.g. MVVM with `@Observable`, dependency injection via `@Environment`, unit-testing a SwiftUI view model, snapshot testing).

**Out of scope — exclude these:**
- Pure UIKit questions (view controller lifecycle, Auto Layout constraint mechanics, cell reuse, responder chain) unless the item is specifically about SwiftUI interop or a SwiftUI equivalent.
- Objective-C / C interop questions.
- Language-agnostic algorithm and data-structure problems, unless the item is explicitly about Swift-specific implementation concerns (e.g. thread-safe collection with actors, copy-on-write semantics).
- Backend/system-design items where iOS is incidental, tooling/CI/code-signing/App Store questions, and behavioural rounds.

Borderline items: keep them, and mark them `partially in scope` with a one-line note on which portion was retained.

## Step 2 — Present with analysis and solutions
Carry each selected item across **with its analysis and solution intact**, and upgrade it rather than merely copying:

- Verify the solution is still correct and idiomatic for **Swift 6 / iOS 18+**, and correct anything stale (e.g. `ObservableObject` patterns that `@Observable` now supersedes, GCD answers that structured concurrency now supersedes, deprecated `NavigationView`).
- Expand thin entries into full worked answers with runnable-looking ```swift code.
- Note where an answer *changed* between Swift 5.x and Swift 6, or between the old SwiftUI observation model and the new one — interviewers frequently probe exactly this seam.
- Preserve each item's provenance label from task 18 (`company-confirmed`, `candidate-reported`, `commonly-circulated`) and its company attribution where one exists.

Each entry should contain: **Question / brief · Provenance & companies · What's being tested · Analysis · Solution (with code) · Follow-ups · Red flags**.

## Required structure of `output.md`
1. **Title + scope line** — states that this is filtered from `tasks/18-ios-interview-questions/output.md`, the Swift/SwiftUI versions targeted, and the date.
2. **How this was filtered** — the inclusion/exclusion rule applied, plus counts: how many items task 18 contained, how many were retained, how many excluded and why (a short table by category is fine).
3. **TL;DR** — 5–7 bullets on what Swift/SwiftUI interviews actually test and where candidates most often fail.
4. **Part A — Swift language & type system** — entries in the format above.
5. **Part B — Memory management & ARC** — entries.
6. **Part C — Swift concurrency** — entries.
7. **Part D — SwiftUI state & data flow** — entries.
8. **Part E — SwiftUI layout, rendering & performance** — entries.
9. **Part F — SwiftUI navigation, interop & testing** — entries.
10. **Part G — Swift/SwiftUI take-home briefs & project assessments** — the retained project-style items, each with a suggested solution architecture and a grading rubric.
11. **Version-shift cheat sheet** — a table of answers that differ between Swift 5.x → Swift 6 and pre-/post-`@Observable` SwiftUI, since these are high-frequency follow-ups.
12. **Quick-reference index** — a table of every retained item (Item | Category | Companies | Provenance | Difficulty) for scanning before an interview.
13. **Sources** — carried over from task 18 for the retained items only, renumbered and complete enough to verify.

## Rules & cautions
- **Do not introduce new companies or new attributed questions** that are absent from task 18. Additional *general* Swift/SwiftUI questions may be added only if clearly marked `added-for-coverage` and kept in a clearly separated subsection.
- Do not fabricate provenance. If task 18 labelled an item `commonly-circulated`, it stays that way here.
- Code must be modern, idiomatic, and internally consistent (Swift 6, iOS 18+ APIs). State plainly that the code was not compiled if it wasn't — do not claim it was tested.
- Where a "correct" answer is genuinely contested in the community (e.g. architecture choices, TCA vs. plain MVVM), present the trade-off rather than asserting one right answer.
- If a retained item's solution in task 18 is wrong or outdated, fix it and add a one-line note recording the correction.

## Style
- Study-reference format: heavy on headings, code blocks, and tables; light on prose.
- ~3000–5000 words including code.
- All code in fenced ```swift blocks.
- Section headings must match the structure above.

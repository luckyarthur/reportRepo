# Task: Swift Modern Concurrency — Interview Questions, Analysis, and Solutions

Write the result to `output.md` in this folder.

## Objective
Search the web for **real, currently-used interview questions and technical assessments on Swift modern concurrency** (async/await, structured concurrency, actors, `Sendable`, Swift 6 strict concurrency checking). Then, for each question found, analyze what it is actually testing and write a correct, well-explained solution. The output must contain all three layers: **the questions/assessments as found**, **the analysis**, and **the solutions**.

This is a research + technical-writing task. Questions should be sourced from real interview-prep material, not invented — though see the rule below on filling gaps.

## Relationship to tasks 18 and 19
`tasks/19-swift-swiftui-interview-questions/` contains a "Part C — Swift concurrency" section derived from the broader iOS hiring research in task 18. **This task is a dedicated deep dive, not a copy of that section.** It is independent — it does not require tasks 18 or 19 to be complete, and it should do its own web research rather than deriving from them.

If `tasks/19-swift-swiftui-interview-questions/output.md` already exists when this task runs, read its Part C and:
- Do not simply reproduce those entries. Go deeper: more questions, harder tiers, and the runtime/semantic detail a concurrency-focused interview round probes for.
- Note any place where this report's answer **contradicts** task 19's, and say which is correct and why.

If it doesn't exist yet, proceed independently and ignore this section.

## Scope of "modern concurrency"
Cover the Swift concurrency model introduced from Swift 5.5 onward, through Swift 6.x strict concurrency. Topics to make sure are represented across the question set:
- `async`/`await` fundamentals; how async functions differ from completion handlers and from threads.
- **Structured concurrency** — `async let`, `TaskGroup`/`withTaskGroup`, task trees, and how child-task lifetime and error propagation work.
- **Unstructured tasks** — `Task {}`, `Task.detached`, and when each is appropriate.
- **Cancellation** — cooperative cancellation, `Task.isCancelled`, `Task.checkCancellation()`, `withTaskCancellationHandler`, and why cancellation is not preemptive.
- **Actors** — actor isolation, `await` on cross-actor calls, **actor reentrancy** (a classic interview trap), and actor hopping/performance.
- **`@MainActor`** — main-actor isolation, `nonisolated`, `isolated` parameters, and global actors.
- **`Sendable`** — the `Sendable` protocol, `@Sendable` closures, sendable checking, `@unchecked Sendable` and when it's justified.
- **Swift 6 strict concurrency** — what the compiler now diagnoses, migrating from Swift 5 mode, data-race safety at compile time, and common migration errors.
- **Bridging** — `withCheckedContinuation` / `withCheckedThrowingContinuation`, converting delegate/completion-handler APIs, and the rule that a continuation must be resumed exactly once.
- **`AsyncSequence` / `AsyncStream`** — including buffering and back-pressure considerations.
- Comparison with **GCD/`DispatchQueue`** and `OperationQueue` — what Swift concurrency replaces, what it doesn't, and the thread-explosion / cooperative-thread-pool distinction.
- Common pitfalls: blocking the cooperative thread pool, actor reentrancy bugs, unstructured `Task` capturing `self`, `Task.detached` losing context/priority, priority inversion.

If sources surface newer material (e.g. Swift 6.2's approachable-concurrency changes such as `nonisolated(nonsending)` or `@concurrent`), include it and label the Swift version it applies to.

## Required structure of `output.md`
1. **Title + scope line** stating coverage, the Swift version(s) targeted, and the date the research was performed.
2. **TL;DR** — 5-7 bullets on what interviewers most consistently probe for and where candidates most often fail.
3. **Where these questions came from** — short paragraph on the sources searched and how representative they are.
4. **Question bank** — the core of the report. Organize by tier:
   - **Tier 1 — Fundamentals** (roughly 8-10 questions)
   - **Tier 2 — Intermediate** (roughly 8-10 questions)
   - **Tier 3 — Advanced / senior-level** (roughly 6-8 questions)
   - **Tier 4 — Coding assessments / take-home style** (3-5 tasks, e.g. "convert this completion-handler API to async/await", "fix the data race in this class", "implement a rate-limited concurrent image loader", "make this type `Sendable`")

   For **every** question use this consistent format:
   - **Q:** the question as asked (verbatim or lightly normalized).
   - **What it's testing:** 1-3 sentences on the underlying concept and why interviewers ask it.
   - **Answer:** a correct, complete answer with a **compilable Swift code example** where the question warrants one.
   - **Common wrong answers / traps:** what candidates typically get wrong (omit only if genuinely not applicable).
5. **Cross-cutting analysis** — after the bank, analyze the question set as a whole: which concepts dominate, which topics separate junior from senior candidates, how Swift 6 strict concurrency has changed what gets asked, and the misconceptions that recur across multiple sources.
6. **Study plan** — a short prioritized list of what to learn in what order to prepare.
7. **Sources** — every source used, with title and URL, plus a note on the type of source (official Swift docs/evolution proposal, WWDC session, blog, interview-prep site).

## Rules & cautions
- **Accuracy over completeness.** All code must be correct for the Swift version stated. Do not present Swift 5.5-era code as valid under Swift 6 strict concurrency if it would now produce an error — call the difference out explicitly.
- **Label Swift versions.** Concurrency semantics changed meaningfully across 5.5 → 5.9 → 6.0 → 6.2. Where behavior is version-dependent, say which version applies.
- Prefer **primary sources** (Swift.org documentation, Swift Evolution proposals, Apple developer documentation, WWDC sessions) for the *answers*, even when the *questions* come from interview-prep sites — interview-prep content frequently contains outdated or subtly wrong explanations. **Where a source's own answer is wrong or outdated, note it and give the correct answer.**
- If web search yields too few questions in a given tier, you may add your own to fill the gap — but **mark clearly which questions were sourced and which were authored to fill coverage gaps**. Never present an invented question as a sourced one, and never fabricate a URL.

## Style
- Longer than the other reports in this repo is fine — completeness of the question bank matters more than hitting a word count. Target roughly 2500-4000 words.
- Use fenced code blocks with `swift` syntax highlighting for all code.
- Neutral, instructional tone.
- Use clear section headings matching the structure above.

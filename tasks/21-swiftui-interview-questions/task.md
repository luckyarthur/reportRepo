# Task: SwiftUI — Interview Questions, Analysis, and Solutions

Write the result to `output.md` in this folder.

## Objective
Search the web for **real, currently-used interview questions and technical assessments on SwiftUI**. Then, for each question found, analyze what it is actually testing and write a correct, well-explained solution. The output must contain all three layers: **the questions/assessments as found**, **the analysis**, and **the solutions**.

This is a research + technical-writing task. Questions should be sourced from real interview-prep material, not invented — though see the rule below on filling gaps.

## Relationship to tasks 18, 19 and 20
`tasks/19-swift-swiftui-interview-questions/` contains SwiftUI sections (Parts D, E and F) derived from the broader iOS hiring research in task 18, and `tasks/20-swift-concurrency-interview-questions/` is the concurrency deep dive. **This task is a dedicated SwiftUI deep dive, not a copy of those sections.** It is independent — it does not require tasks 18, 19 or 20 to be complete, and it should do its own web research rather than deriving from them.

If `tasks/19-swift-swiftui-interview-questions/output.md` already exists when this task runs, read its Parts D–F and:
- Do not simply reproduce those entries. Go deeper: more questions, harder tiers, and the rendering/layout/state-propagation detail a SwiftUI-focused interview round probes for.
- Note any place where this report's answer **contradicts** task 19's, and say which is correct and why.

Keep pure Swift-language and pure concurrency questions out of scope here (those belong to tasks 19 and 20) — except where the question is specifically about how they surface *in SwiftUI* (e.g. `@MainActor` and the `.task` modifier, actor-isolated view models, `Sendable` in `@Observable` types).

## Scope of "SwiftUI"
Target current SwiftUI (iOS 17/18+, Swift 6), while noting where answers changed from earlier versions. Topics to make sure are represented across the question set:
- **View identity and the render model** — structural vs. explicit identity, `id()`, `ForEach` identity, why SwiftUI re-invokes `body`, how diffing decides what to redraw, and why `body` must be cheap and side-effect-free.
- **State and data flow** — `@State`, `@Binding`, `@StateObject` vs. `@ObservedObject` (the classic "which one and why" question), `@EnvironmentObject`, `@Environment`, custom `EnvironmentKey`s, and single-source-of-truth reasoning.
- **Observation framework** — `@Observable` vs. `ObservableObject`/`@Published`, `@Bindable`, how per-property observation changes invalidation granularity, and migration considerations.
- **Layout system** — the parent-proposes/child-chooses negotiation, `frame` vs. `fixedSize`, `GeometryReader` (and why it's often the wrong tool), `Layout` protocol, `PreferenceKey`, alignment guides, and `ViewThatFits`.
- **Lists and performance** — `List` vs. `LazyVStack`/`ScrollView`, view recycling, `ForEach` with unstable IDs, `AnyView` and type erasure costs, `EquatableView`, expensive `body` computations, and diagnosing re-renders (`Self._printChanges()`, Instruments/SwiftUI profiling).
- **Animations and transitions** — implicit vs. explicit animation, `withAnimation`, `Transaction`, `matchedGeometryEffect`, `PhaseAnimator`/`KeyframeAnimator`, and why animating the wrong value produces glitches.
- **Navigation** — `NavigationStack`, value-based navigation and `NavigationPath`, programmatic navigation, deep linking, state restoration, and what replaced the deprecated `NavigationView`/`NavigationLink(isActive:)`.
- **UIKit/AppKit interop** — `UIViewRepresentable`/`UIViewControllerRepresentable`, the `Coordinator` pattern, `makeUIView`/`updateUIView` responsibilities, `UIHostingController`, and incremental-adoption strategy in an existing UIKit app.
- **Architecture and testing** — MVVM with `@Observable`, dependency injection via `@Environment`, what is and isn't unit-testable in SwiftUI, snapshot testing, and previews as a development tool.
- **Accessibility** — accessibility modifiers, traits, Dynamic Type, VoiceOver behavior, and why accessibility questions appear in senior rounds.
- Common pitfalls: `@ObservedObject` on an owned object, heavy work in `body`, `GeometryReader` collapsing layout, unstable `ForEach` IDs, `AnyView` overuse, retain cycles in view models, and modifier-order mistakes.

## Required structure of `output.md`
1. **Title + scope line** stating coverage, the SwiftUI/iOS/Swift version(s) targeted, and the date the research was performed.
2. **TL;DR** — 5-7 bullets on what interviewers most consistently probe for and where candidates most often fail.
3. **Where these questions came from** — short paragraph on the sources searched and how representative they are.
4. **Question bank** — the core of the report. Organize by tier:
   - **Tier 1 — Fundamentals** (roughly 8-10 questions)
   - **Tier 2 — Intermediate** (roughly 8-10 questions)
   - **Tier 3 — Advanced / senior-level** (roughly 6-8 questions)
   - **Tier 4 — Coding assessments / take-home style** (3-5 tasks, e.g. "build a searchable list screen backed by an async API", "fix the view that re-renders on every keystroke", "implement a custom `Layout`", "wrap a UIKit control with `UIViewRepresentable`", "migrate this `ObservableObject` view model to `@Observable`")

   For **every** question use this consistent format:
   - **Q:** the question as asked (verbatim or lightly normalized).
   - **What it's testing:** 1-3 sentences on the underlying concept and why interviewers ask it.
   - **Answer:** a correct, complete answer with a **compilable SwiftUI code example** where the question warrants one.
   - **Common wrong answers / traps:** what candidates typically get wrong (omit only if genuinely not applicable).
5. **Cross-cutting analysis** — after the bank, analyze the question set as a whole: which concepts dominate, which topics separate junior from senior candidates, how the Observation framework and `NavigationStack` changed what gets asked, and the misconceptions that recur across multiple sources.
6. **Version-shift notes** — a short table of answers that differ across SwiftUI generations (`NavigationView` → `NavigationStack`, `ObservableObject` → `@Observable`, `onChange` signature change in iOS 17, etc.), since these are high-frequency follow-ups.
7. **Study plan** — a short prioritized list of what to learn in what order to prepare.
8. **Sources** — every source used, with title and URL, plus a note on the type of source (Apple developer documentation, WWDC session, blog, interview-prep site).

## Rules & cautions
- **Accuracy over completeness.** All code must be correct for the SwiftUI/iOS version stated. Do not present deprecated APIs as current — call the difference out explicitly.
- **Label versions.** SwiftUI changed meaningfully across iOS 14 → 16 → 17 → 18. Where behavior or the correct answer is version-dependent, say which version applies.
- Prefer **primary sources** (Apple developer documentation, WWDC sessions, Swift.org) for the *answers*, even when the *questions* come from interview-prep sites — interview-prep content for SwiftUI is frequently outdated (still teaching `NavigationView`, `@ObservedObject`-only patterns, or pre-Observation state management). **Where a source's own answer is wrong or outdated, note it and give the correct answer.**
- Some SwiftUI behavior is **undocumented implementation detail** (exact diffing and `body` re-invocation rules). Distinguish documented guarantees from community-observed behavior rather than asserting internals as fact.
- Where a "correct" answer is genuinely contested (architecture patterns, MVVM vs. TCA vs. plain SwiftUI state), present the trade-off rather than asserting one right answer.
- If web search yields too few questions in a given tier, you may add your own to fill the gap — but **mark clearly which questions were sourced and which were authored to fill coverage gaps**. Never present an invented question as a sourced one, and never fabricate a URL.
- State plainly that the code was not compiled if it wasn't — do not claim it was tested.

## Style
- Longer than the other reports in this repo is fine — completeness of the question bank matters more than hitting a word count. Target roughly 2500-4000 words.
- Use fenced code blocks with `swift` syntax highlighting for all code.
- Neutral, instructional tone.
- Use clear section headings matching the structure above.

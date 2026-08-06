# Task: Deep Research — Who Hires iOS Engineers, What They Ask, and How to Answer It

Write the result to `output.md` in this folder.

## Objective
Produce a research-backed report on the **iOS engineering hiring market over the past four years (roughly 2022 – 2026)** that does three things in sequence:

1. Identify **which technology companies have actively recruited iOS engineers** in that window.
2. Identify **what those companies actually use to assess candidates** — interview questions, take-home assessments, live coding problems, system-design prompts, and project briefs.
3. For each assessment item collected, provide a **problem analysis and a worked solution**.

The end product is a practical, sourced study of iOS interviewing — not a listicle of "top 10 interview questions" scraped from a blog. Every company claim and every attributed question must be traceable to a source, and anything unverified must be labelled as such.

## Step 1 — Companies recruiting iOS engineers (2022 – 2026)
Search the web for technology companies that have posted, advertised, or otherwise publicly recruited for iOS / Apple-platform engineering roles in the past four years. Aim for **25–40 companies** with real coverage across these segments (do not make this a list of only US FAANG employers):

- **Large platform companies** — e.g. Apple, Google, Meta, Amazon, Microsoft, Netflix.
- **Consumer apps at scale** — e.g. Uber, Lyft, Airbnb, DoorDash, Spotify, Snap, Pinterest, Reddit, Duolingo, TikTok/ByteDance.
- **Fintech & banking** — e.g. Stripe, Block/Square/Cash App, Robinhood, Revolut, Monzo, Nubank, Chime, Coinbase.
- **Enterprise / B2B / dev tools** — e.g. Salesforce, Atlassian, Shopify, Slack, Zoom, Datadog.
- **Health, travel, commerce, media** — e.g. Instacart, Booking.com, Expedia, Delivery Hero, Wise, Klarna, Zalando, Grab, Gojek, Rakuten, Line, Mercado Libre.
- **Smaller / high-signal product companies and startups** — e.g. Notion, Figma, Linear, Superhuman, Headspace, Calm, Strava, Bumble, Discord.

For each company record: company name, region/HQ, segment, evidence that they recruited for iOS in the window (job posting, careers page, engineering blog, layoff/hiring news, conference talk), the seniority levels targeted where known, and whether their stack is publicly known to be Swift/SwiftUI, UIKit, or cross-platform (React Native/Flutter/KMP) with a native iOS component.

**Be honest about market conditions.** The 2022–2026 window includes a large tech-hiring contraction (2022–2023 layoffs), a shift toward senior-only hiring, growth in cross-platform and AI-adjacent roles, and a decline in junior iOS openings. The report must characterise the market, not just enumerate employers.

## Step 2 — What those companies use to assess candidates
For the companies identified in Step 1, search for **publicly reported** interview content: loop structure, live-coding problems, take-home assessments, project briefs, system-design prompts, and behavioural rounds.

Useful source types: company engineering blogs and official "how we interview" pages, candidate write-ups (Medium, dev.to, personal blogs), Glassdoor/Blind/Levels.fyi/Reddit r/iOSProgramming reports, published interview-prep repositories, conference talks, and recruiter-published loop descriptions.

Collect **40–60 distinct assessment items**, spread across these categories:

- **Swift language & runtime** — optionals, value vs. reference semantics, `struct` vs. `class`, ARC and retain cycles, `weak`/`unowned`, protocols and protocol-oriented design, generics, associated types, `some`/`any`, error handling, `Codable`, `@escaping`, copy-on-write.
- **Concurrency** — GCD, `OperationQueue`, `async`/`await`, structured concurrency, `Task`, actors, `@MainActor`, `Sendable`, data races, cancellation, Swift 6 strict concurrency.
- **UIKit** — view lifecycle, Auto Layout and constraint priorities, cell reuse, responder chain, `UICollectionViewDiffableDataSource`, navigation and coordinators, scroll performance.
- **SwiftUI** — view identity and diffing, `@State` / `@Binding` / `@StateObject` / `@ObservedObject` / `@EnvironmentObject` / `@Observable`, layout system, `PreferenceKey`, performance and unnecessary re-renders, SwiftUI ↔ UIKit interop, navigation APIs.
- **Architecture** — MVC / MVVM / VIPER / TCA / Clean, dependency injection, modularisation, testability trade-offs.
- **Networking & persistence** — `URLSession`, retries and pagination, caching, offline-first sync, Core Data vs. SwiftData vs. SQLite/GRDB vs. Realm, migrations.
- **Live-coding / algorithmic problems** as actually posed in iOS loops (including LRU cache, image-loading cache, debounce/throttle, rate limiter, thread-safe collection).
- **iOS system design** — design a feed, a chat client, offline-first notes, image caching/downloading, analytics SDK, file uploader with resumability, push-notification pipeline.
- **Take-home assessments / project briefs** — typical briefs (e.g. "consume this public API and build a list + detail screen with tests"), stated time budgets, and published grading rubrics where available.
- **Debugging, tooling & release** — Instruments, memory graph, crash triage, code signing, CI/CD, App Store review, accessibility, localisation.
- **Behavioural / experience rounds** — the actual prompts used, not generic advice.

For every item, record: the question/brief, the company or companies associated with it, the round it appears in, the source, and a confidence label (see Rules).

## Step 3 — Analysis and solutions (the core deliverable)
For each collected assessment item, write a compact entry containing:

- **The question / brief** — verbatim where the source quotes it, otherwise a faithful paraphrase.
- **What is really being tested** — the underlying competency the interviewer is probing.
- **Analysis** — how to decompose the problem, the clarifying questions a strong candidate asks first, the trade-offs in play, and the common wrong turns.
- **Solution** — a concrete, correct answer. For coding problems include working Swift code (compile-plausible, idiomatic, modern Swift 5.9+/6). For system-design problems include a component breakdown, data flow, and the key trade-off decisions. For take-homes include a suggested structure and what a grader looks for.
- **Follow-ups** — the deeper questions an interviewer typically asks next, with brief answers.
- **Red flags** — answers that signal a weak candidate.

Depth over volume: a shallow one-liner for 60 questions is worth less than a real analysis for 40.

## Required structure of `output.md`
1. **Title + scope line** — coverage window (2022–2026), segments and regions covered, and the date the research was performed.
2. **TL;DR** — 6–8 bullets on the state of iOS hiring and what interviews actually optimise for.
3. **Market overview** — the 2022–2026 iOS hiring market: contraction and recovery, seniority skew, native vs. cross-platform, the SwiftUI transition, the effect of AI tooling on the interview format.
4. **Company table** — the Step 1 companies (Company | Region | Segment | Evidence of iOS hiring | Levels targeted | Stack signal | Source).
5. **Interview loop patterns** — how a typical iOS loop is structured at large platform companies vs. mid-size product companies vs. startups (rounds, duration, what each round scores), including where take-homes replace live coding.
6. **Assessment catalogue with analysis and solutions** — the Step 3 material, grouped by the categories listed above. This is the bulk of the document.
7. **Grading rubrics** — what strong / borderline / weak answers look like, per category.
8. **Preparation plan** — a realistic 4–6 week study plan derived from the evidence in this report, weighted by how frequently each topic actually appeared.
9. **Sources** — consolidated, numbered list with enough detail to verify (title / publisher / date / URL). Every company claim and every attributed question must map to an entry here.

## Rules & cautions
- **Accuracy over completeness.** Do not invent job postings, interview questions, or company-specific practices. If a question is widely circulated but cannot be tied to a named company, present it as a *commonly reported* question and say so.
- **Label every assessment item's provenance** with one of: `company-confirmed` (official source), `candidate-reported` (first-hand write-up or review site), or `commonly-circulated` (prep material, no company attribution).
- Interview processes change. Date each claim and note that a loop described in 2022 may no longer reflect current practice.
- Do not reproduce material that a source presents as confidential or under NDA. Public postings, public candidate write-ups, and published prep material only.
- Swift code must be modern and idiomatic (Swift 5.9+, with Swift 6 concurrency noted where relevant). If code was not compiled, say so — do not claim it was tested.
- Prefer official/primary sources over aggregator content; where only aggregator reports exist, say so explicitly.

## Style
- Long-form reference document. ~4000–6000 words including code blocks.
- Neutral, practical tone — written for an engineer preparing for interviews and for a hiring manager designing a loop.
- Use tables for the company list and rubrics; use fenced ```swift blocks for all code.
- Section headings must match the structure above.

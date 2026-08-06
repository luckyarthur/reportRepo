# Who Hires iOS Engineers, What They Ask, and How to Answer It

*Scope: the iOS / Apple-platform engineering hiring market from roughly January 2022 through August 2026. Covers large platform companies, consumer apps at scale, fintech, enterprise/B2B, health/travel/commerce/media, and smaller product companies, across the US, UK/EU, LatAm and APAC. Web research performed **6 August 2026**. Swift code targets Swift 6.x / iOS 18+ and, except where noted, **was not compiled** — treat it as compile-plausible reference, not tested output.*

---

## TL;DR

- **The market bifurcated rather than shrank.** The 2022–23 layoff wave (≈165k tech layoffs in 2022, ≈263k in 2023) hit mobile alongside everything else, and the recovery in 2024–26 came back **senior-weighted**. Junior iOS openings never returned to 2021 levels; the postings that do exist increasingly demand demonstrated App Store shipping experience. [1][2][3]
- **Native iOS did not lose to cross-platform, but it stopped being the default everywhere.** Airbnb sunset React Native in 2018 and went native; Shopify finished the opposite migration in November 2024, unifying ~86% of code across platforms. Both outcomes are real, and both companies still employ iOS specialists. [4][5]
- **The single biggest interview-content shift is Swift concurrency.** Swift 6 (September 2024) made strict concurrency checking an error rather than a warning, and `actor` / `Sendable` / `@MainActor` / actor isolation moved from "nice to know" to a standard question block at companies that adopted it. [6][7]
- **The second biggest is the observation model.** `@Observable` (Observation framework) superseded `ObservableObject`/`@Published` for new code, and the difference — per-property read tracking vs. blanket invalidation — is one of the most reliably asked SwiftUI follow-ups. [8][9]
- **The interview format itself is being rebuilt around AI.** Meta began piloting an AI-enabled coding round in October 2025 (CoderPad with an in-panel assistant, replacing one of two onsite coding rounds); Google added a "code comprehension" round with Gemini available for 2026; Canva told candidates in June 2025 to use AI tools during technical interviews and made the questions harder and more ambiguous. [10][11][12]
- **Take-homes are strongest at mid-size and European companies, weakest at big-tech.** Monzo runs a take-home on an existing mobile codebase followed by a review call; DoorDash's iOS take-home is reported at ~5 hours with the follow-up interview built entirely on defending it. Apple, Meta and Amazon still run live loops. [13][14][15]
- **The iOS-specific part of the loop is narrower than candidates expect.** Across every loop I found evidence for, at most one or two rounds are actually about Apple frameworks. The rest is general algorithms, mobile system design, and behavioural — which is why strong iOS engineers still fail these loops.
- **Most "iOS interview questions" content on the web is unattributed.** Roughly two-thirds of the items in the catalogue below could not be tied to a named company; they are labelled `commonly-circulated` and should be treated as market convention, not as any company's actual question bank.

---

## Market overview: iOS hiring, 2022–2026

**The contraction (2022–2023).** 2022 saw roughly 165,000 layoffs across ~1,186 tech companies; 2023 was about 59% worse at ~263,000. [1] Mobile teams were not singled out, but they were disproportionately exposed at consumer companies whose growth thesis had been app-install-driven. The practical consequence for hiring was not that iOS roles vanished — it was that **req approval moved up the org chart**, and the surviving reqs skewed senior.

**The uneven recovery (2024–2026).** Layoffs declined from the 2023 peak (~152k in 2024, ~100–130k in 2025) but did not stop, and the 2025–26 wave has a different driver: AI-led restructuring and cost discipline rather than post-ZIRP correction. [2] Reported 2026 year-to-date figures are large but the trackers disagree with each other; treat any single number as an estimate.

**Seniority skew.** Rate and salary data consistently show the sharpest compensation step at the mid-to-senior boundary — US contractor averages moving from roughly $48/hr to $73/hr at the point where an engineer owns end-to-end App Store releases — which is a hiring signal as much as a pay signal: companies are paying for release ownership, not for Swift syntax. [3] Duolingo's 2025–26 Senior iOS Software Engineer postings in New York and Pittsburgh ($178k–$240k for the NY Math-team role) are typical of what a senior consumer-app req looks like now. [16]

**Native vs. cross-platform.** The honest summary is that there is no industry consensus. Airbnb's 2018 "Sunsetting React Native" post — poor initialisation and first-render time, framework immaturity, patch maintenance, no type safety — remains the canonical native-side argument and Airbnb's iOS team is native today. [4] Shopify's five-year retrospective (2025) is the canonical counter: migration complete November 2024, ~86% code unification, 1.8M lines of redundant code deleted, 99.9% crash-free sessions, engineers working across web and mobile. [5] Kotlin Multiplatform occupies a third position — shared business logic, native UI — and appears in postings but I found no primary evidence letting me quantify its share. For candidates the operational effect is that **"do you have a native iOS team?" is now a legitimate screening question to ask the recruiter**, and a cross-platform shop will still interview you on Swift for the native layer.

**The SwiftUI transition.** SwiftUI is the default for new surfaces and UIKit still carries the large legacy codebases. Vendor and community surveys put SwiftUI at roughly 70% of *new* apps against ~40% two years earlier, with UIKit still dominant in enterprise/legacy, and job postings splitting roughly 75% requiring UIKit / 60% preferring SwiftUI / ~25% SwiftUI-only. [17] **These figures come from aggregator and vendor blogs, not from a methodologically documented survey — treat them as directional only.** What is not in doubt: Apple ships SwiftUI-first APIs, iOS 26 (announced 9 June 2025, released 15 September 2025) introduced the Liquid Glass design system, and Apple unified all platform version numbers on "26" that year. [18] Interviews reflect the hybrid reality: you will be asked SwiftUI *and* asked how you'd bridge it into a UIKit app.

**AI's effect on the interview.** This is the most concrete format change in the whole window.
- **Meta** started rolling out an AI-enabled coding interview in **October 2025**: 60 minutes, CoderPad with a three-pane layout (file explorer, editor, AI chat), the assistant can answer in chat but cannot edit files directly, and candidates choose among models. It replaced one of the two onsite coding rounds; the other remains a classic no-AI algorithm round. [10]
- **Google** is adding a **code comprehension** round for 2026 — read, debug and optimise an existing codebase with Gemini available. [11]
- **Canva** (June 2025) expects candidates to use Copilot/Cursor/Claude in technical interviews and redesigned questions to be "more complex, ambiguous, and realistic". **Shopify** similarly asks candidates to integrate AI-generated snippets into unfamiliar codebases. [12]

The pattern is consistent: when AI is permitted, the problem gets harder and the grading moves from *can you produce the code* to *can you judge the code*. For iOS candidates this raises the value of exactly the skills the framework questions below test — spotting a retain cycle, an actor-isolation violation, or a SwiftUI identity bug in code you did not write.

**Caveat on all of the above.** Interview processes change continuously and every loop described here is dated. A loop reported in 2022 may bear no resemblance to that company's process today; several of these companies have publicly changed format inside this window.

---

## Company table

Companies with public evidence of recruiting for iOS / Apple-platform engineering between 2022 and 2026. **Evidence markers:** no marker = a primary or first-hand source is cited; **✱** = evidence is a careers portal or job-board aggregator listing rather than a primary posting I retrieved; **✝** = included for segment coverage on general industry knowledge, with **no source retrieved in this research** — treat as unverified.

| Company | Region / HQ | Segment | Evidence of iOS hiring (2022–2026) | Levels targeted | Stack signal | Src |
|---|---|---|---|---|---|---|
| Apple | US (Cupertino) | Large platform | Extensive candidate-reported ICT3/ICT4 loops; team-based (not central-pool) hiring | ICT2–ICT5 | Swift, UIKit + SwiftUI (first-party apps ship SwiftUI) | [19][20] |
| Google | US | Large platform | 2026 SWE loop redesign incl. code-comprehension round; native iOS apps | L3–L6 | Native Swift/ObjC | [11] |
| Meta | US | Large platform | Glassdoor iOS Engineer reports; Oct 2025 AI-enabled coding round | E3–E6 | Native Swift/ObjC, heavy in-house infra | [10][21] |
| Amazon | US | Large platform / commerce | Published Amazon *iOS Engineer* question sets; Glassdoor iOS reports | SDE I–III | Native Swift/ObjC | [15][22] |
| Microsoft | US | Large platform | ✱ Ongoing iOS reqs across Office/Outlook/Teams | SDE–Principal | Native + shared C++ cores | ✱ |
| Netflix | US | Media | Interview-process guides; heavy system-design onsite (~8 interviews) | Senior+ (flat ladder) | Native Swift | [23] |
| Disney | US | Media | Live posting: *Senior iOS Engineer – SwiftUI & UIKit*, New York | Senior | SwiftUI **and** UIKit named in the title | [24] |
| Uber | US | Consumer at scale | Glassdoor iOS Engineer reports; ~7-stage process incl. LeetCode-medium screen, architecture, EM, system design, iOS-specific coding | Mid–Staff | Native Swift, in-house DI/architecture | [25] |
| Lyft | US | Consumer at scale | First-hand candidate write-up of the iOS loop | Mid–Senior | Native Swift | [26] |
| Airbnb | US | Consumer at scale | Candidate write-up of the iOS loop; 2018 React Native sunset → native | Mid–Senior | Native Swift; SwiftUI in production | [4][27] |
| DoorDash | US | Consumer at scale | Glassdoor + candidate write-up + guide; ~5h take-home extending an Xcode project | Mid–Senior | Native Swift | [13][14][28] |
| Spotify | Sweden/US | Consumer media | Interview guides describing a ~4h final loop; iOS-specific loop with system design + iOS domain + values | Mid–Senior | Native Swift (+ shared infra) | [29] |
| Snap | US | Consumer | ✱ Ongoing iOS reqs | Mid–Senior | Native Swift/ObjC | ✱ |
| Pinterest | US | Consumer | ✱ Ongoing iOS reqs | Mid–Senior | Native Swift | ✱ |
| Reddit | US | Consumer | ✱ Reqs; reported SwiftUI in production | Mid–Senior | Native Swift, SwiftUI adoption reported | [17]✱ |
| Duolingo | US (Pittsburgh/NY) | Consumer / edtech | Live postings: Senior iOS SWE (Math team, NY, $178k–$240k; Short Form, Pittsburgh) | Senior | Swift + Cocoa Touch, native | [16] |
| ByteDance / TikTok | China/SG/US | Consumer | ✝ | Mid–Senior | Native + heavy in-house cross-platform | ✝ |
| Stripe | US | Fintech | Loop documented: recruiter → 1 coding screen → 4–5 onsite → team match; practical coding, API design, system design, culture | Mid–Staff | Native Swift SDK work | [30] |
| Block / Cash App | US | Fintech | ✱ Ongoing iOS reqs | Mid–Staff | Native Swift, KMP used elsewhere in org | ✱ |
| Robinhood | US | Fintech | Live posting: **Staff iOS Engineer** — Swift, RxSwift, UIKit, Bazel, 6+ yrs; plus Summer 2025 iOS internship | Intern + Staff | Swift, **RxSwift + UIKit**, Bazel build | [31][32] |
| Revolut | UK/EU | Fintech | Live posting: Software Engineer (iOS) — Dubai, Kraków, Madrid + remote (Cyprus, Poland, Portugal, Romania, Spain, UAE) | Mid–Senior | Native Swift | [33] |
| Monzo | UK | Fintech | **Company-confirmed**: public blog on preparing for mobile interviews; iOS Engineer postings | Mid–Senior | Native Swift; production-Swift experience probed directly | [13][34] |
| Nubank | Brazil | Fintech | ✝ | Mid–Senior | Native + KMP reported | ✝ |
| Coinbase | US | Fintech | ✱ Aggregator listings for engineering incl. mobile | Mid–Senior | Native Swift | ✱ |
| Chime | US | Fintech | ✝ | Mid–Senior | Native Swift | ✝ |
| Salesforce | US | Enterprise / B2B | ✝ | Mid–Senior | Native + hybrid | ✝ |
| Atlassian | Australia | Enterprise / B2B | ✝ | Mid–Senior | Native + KMP reported | ✝ |
| Shopify | Canada | Commerce / dev tools | **Company-confirmed**: five-year React Native retrospective (2025), migration complete Nov 2024; AI-integrated interview format | Mid–Senior | **React Native-first** with native modules | [5][12] |
| Zoom | US | Enterprise | ✝ | Mid–Senior | Native + shared C++ | ✝ |
| Datadog | US | Enterprise / dev tools | ✝ | Mid–Senior | Native Swift (RUM SDK is open-source Swift) | ✝ |
| Instacart | US | Commerce | ✝ | Mid–Senior | Native Swift | ✝ |
| Booking.com | Netherlands | Travel | ✝ | Mid–Senior | Native Swift | ✝ |
| Delivery Hero | Germany | Food delivery | ✱ Careers portal with active engineering reqs across brands | Mid–Senior | Native per-brand apps | [35]✱ |
| Klarna | Sweden | Fintech | ✱ Careers portal | Mid–Senior | Native Swift | [36]✱ |
| Gojek | Indonesia | Consumer / SEA super-app | Posting: Software Engineer – iOS, 2+ yrs, "in-depth knowledge of iOS app architecture", Swift, Cocoa, Xcode, iOS SDK | Junior–Mid | Native Swift | [37] |
| Grab | Singapore | Consumer / SEA super-app | ✝ | Mid–Senior | Native Swift | ✝ |
| Rakuten | Japan | Commerce | ✝ | Mid–Senior | Native Swift | ✝ |
| LINE / LY Corp | Japan | Consumer messaging | ✝ | Mid–Senior | Native Swift | ✝ |
| Mercado Libre | Argentina | Commerce / LatAm | ✝ | Mid–Senior | Native Swift | ✝ |
| Canva | Australia | Consumer / creative | June 2025 policy: candidates expected to use AI tools in technical interviews | Mid–Senior | Native + cross-platform | [12] |
| Notion / Figma / Linear / Superhuman / Strava / Bumble / Discord / Headspace / Calm | US/global | High-signal product startups | ✝ Small native iOS teams; typically 1–2 iOS reqs at a time | Senior-heavy | Native Swift, SwiftUI-forward | ✝ |

**Read the ✝ rows as coverage-of-segment, not as findings.** They reflect widely-known industry facts about which companies maintain iOS apps, but I retrieved no dated posting for them in this research and they should not be cited.

---

## Interview loop patterns

### Large platform companies (Apple, Google, Meta, Amazon, Netflix)

| Stage | Typical shape | What it scores |
|---|---|---|
| Recruiter screen | 30 min | Level calibration, comp, team fit |
| Technical phone screen | 45–60 min | One algorithm problem, sometimes with an iOS flavour (e.g. reverse a linked list *in Swift*, two-sum with optimisation and edge cases) [21] |
| Onsite loop | 4–5 rounds (Meta), 5 rounds (Amazon), ~8 interviews (Netflix, design-heavy) | See below |
| Coding ×2 | 45 min each | DS&A; at Meta one of the two is now the AI-enabled round [10] |
| Mobile/product system design | 45–60 min | Meta explicitly distinguishes *System Design* (distributed, scale) from *Product Architecture* (API design, client-server interaction, usability, evolution) and assigns by role [38] |
| iOS domain / framework | 45–60 min | Memory management, concurrency, framework depth — at Meta this is often folded into coding rather than being its own round [21] |
| Behavioural | 45–60 min | Amazon: Leadership Principles, one dedicated round. Netflix: culture, heavily weighted |
| Team match | — | Apple hires **per team**, not into a central pool, so the loop composition varies by team; team match plus hiring-manager approval close the process [19] |

**Note on Apple specifically:** because Apple loops are team-owned, two candidates for "iOS Engineer at Apple" can have materially different experiences. Reported round-one patterns emphasise Swift fundamentals interrogated until the candidate's ceiling is found, followed by 60–90 minutes of live Xcode work (build a small feature, debug an existing codebase, or implement a data structure). [19][20]

### Mid-size product companies (Uber, Lyft, Airbnb, DoorDash, Spotify, Stripe)

Longer and more mobile-specific than big-tech.

- **Uber:** reported as ~7 stages — LeetCode-medium screen, coding tasks, algorithms, architecture discussion, EM conversation, system design, iOS-specific coding. [25]
- **DoorDash:** take-home-centred. ~5 hours extending an existing Xcode project to load and display JSON data "in a modular way", then an interview built largely around defending the submission — recruiters explicitly warn candidates to know their own code inside out. A separate debugging round and a system-design round are reported. [13][14][28]
- **Spotify:** ~1–3 months end to end; final loop ≈4 hours, one hour each for case study, coding, system design, and values. iOS-specific loops are reported as four interviews: system design, iOS domain, coding standards, values. [29]
- **Stripe:** recruiter → one coding screen → 4–5 onsite → team match, with practical coding (not puzzle-style), API design, system design, and a culture round emphasising clarity, ownership and user empathy. [30]

### Smaller / European product companies (Monzo and similar)

Take-home replaces the algorithm screen almost entirely.

Monzo's published mobile process: initial phone interview → **take-home coding test on an existing Android or iOS project** → task review call → 2–3 hours of interviews. In the onsite rounds you meet two other iOS engineers, are walked through real technical challenges the company has faced and asked to design solutions, and are questioned about your experience **using Swift in production**. Monzo states explicitly that they do not use brainteasers or knowledge quizzes. [13][34]

This is the shape to expect at most UK/EU mid-size product companies: no LeetCode, heavy weight on the take-home and on whether you can reason about a real codebase.

### Startups (Notion, Linear, Strava-scale)

Typically 3–4 stages: founder/EM screen, a paid or unpaid take-home *or* a pair-programming session on the real codebase, a system/architecture conversation, and a values round. Live algorithm rounds are rare. The dominant risk is scope creep in the take-home.

---

## Assessment catalogue with analysis and solutions

**Provenance labels:** `company-confirmed` = official company source · `candidate-reported` = first-hand write-up or review-site report · `commonly-circulated` = prep material with no company attribution.

Code below targets Swift 6.x / iOS 18+ and **was not compiled**.

---

### A. Swift language & runtime

#### A1. "`struct` vs `class` — when do you choose which?"
`commonly-circulated` · appears in essentially every screen · **Testing:** whether you reason about semantics or recite a table.

**Analysis.** The weak answer is "structs are on the stack, classes are on the heap" — which is not reliably true (a struct captured by a closure or stored in a class is heap-allocated). The real axis is **identity**: does this thing have a lifetime and an identity that multiple owners must observe, or is it a value? Ask: does mutation need to be visible to other holders? Does it need inheritance or `deinit`? Is it bridged to Objective-C?

**Solution.** Default to `struct`. Reach for `class` when you need reference identity (a shared cache, a coordinator, a long-lived service), `deinit` for resource cleanup, Objective-C interop, or when the type is genuinely large and you want to avoid copies without relying on COW. In SwiftUI, `struct` for views and models is not a preference — the framework's diffing depends on views being cheap values. Note that `actor` is now a third option and is the correct one for a mutable reference type shared across concurrency domains.

**Follow-ups.** *"Does a struct always avoid heap allocation?"* No — escaping closures, existential boxes larger than 3 words, and storage inside reference types all move it to the heap. *"Why are SwiftUI views structs?"* Because SwiftUI recreates the view tree constantly; that only works if construction is nearly free and comparison is value-based.

**Red flags.** "Structs are always faster." Not knowing that a struct containing a class reference gives you shared mutable state through the back door.

#### A2. "Implement copy-on-write for your own type."
`commonly-circulated` · live coding · **Testing:** understanding that value semantics are an *implementation contract*, not a language gift.

```swift
struct ByteBuffer {
    private final class Storage {
        var bytes: [UInt8]
        init(_ bytes: [UInt8]) { self.bytes = bytes }
    }

    private var storage: Storage

    init(_ bytes: [UInt8] = []) { storage = Storage(bytes) }

    var count: Int { storage.bytes.count }

    subscript(index: Int) -> UInt8 {
        get { storage.bytes[index] }
        set {
            ensureUnique()
            storage.bytes[index] = newValue
        }
    }

    mutating func append(_ byte: UInt8) {
        ensureUnique()
        storage.bytes.append(byte)
    }

    private mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = Storage(storage.bytes)
        }
    }
}
```

**Analysis.** The two things graders look for: `isKnownUniquelyReferenced` taking an `inout` reference to a `final class`, and the copy happening on *write* not on read. A common wrong turn is copying in `init` or in the getter, which defeats the point.

**Follow-ups.** *"Why must `Storage` be `final`?"* `isKnownUniquelyReferenced` requires a native Swift class reference and non-final classes risk Objective-C bridging. *"What breaks if you forget `ensureUnique`?"* Two "value" copies silently alias — the classic bug this question exists to test.

**Red flags.** Claiming `Array` gives you COW so you never need this. Not knowing what makes the reference count go above one.

#### A3. "Walk me through optional unwrapping — and when is `!` acceptable?"
`commonly-circulated` · phone screen · **Testing:** production judgement, not syntax.

**Solution.** `if let` / `guard let` for control flow, `??` for defaults, optional chaining for traversal, `if case let` for pattern matching. Implicitly-unwrapped optionals are legitimate in exactly one common place: `@IBOutlet` and other two-phase-initialisation properties whose value is guaranteed by the framework contract. Force-unwrap is defensible when the alternative is silently continuing in a state that violates an invariant — e.g. `Bundle.main.url(forResource:)` for a resource you ship, where a `nil` is a build error you *want* to crash on. What is never acceptable is force-unwrapping network-derived or user-derived data.

**Follow-ups.** *"`try?` vs `try!`?"* `try?` discards the error, which is usually a bug in disguise; prefer `do/catch` and log. *"What's the cost of `Optional`?"* For most types it's a tagged layout with no extra allocation; for class references Swift uses the null pointer as the `nil` case, so it's free.

**Red flags.** "Never force-unwrap" recited as dogma without being able to name the exception; using `!` on decoded JSON.

#### A4. "Find and fix the retain cycle."
`candidate-reported` (Meta reports memory management questions in the iOS loop [21]) · coding/domain round · **Testing:** ARC mental model.

```swift
final class FeedViewModel {
    private var cancellable: AnyCancellable?
    private let service: FeedService
    private(set) var items: [Item] = []

    init(service: FeedService) {
        self.service = service
        // BUG: the closure captures `self` strongly; `self` owns `cancellable`
        // which owns the closure. Retain cycle.
        cancellable = service.updates.sink { value in
            self.items = value
        }
    }
}
```

**Fix.**

```swift
cancellable = service.updates.sink { [weak self] value in
    self?.items = value
}
```

**Analysis.** The rule to state out loud: a cycle exists when a strong reference path returns to its origin. `weak` when the captured object may legitimately die first (view controllers, view models); `unowned` when its lifetime is guaranteed to outlive the closure — cheaper, but a crash rather than a `nil` if you're wrong. `[weak self] in guard let self else { return }` is the idiom for multi-statement closures.

**Follow-ups.** *"Do all escaping closures need `[weak self]`?"* No — `URLSession` completion handlers are released after firing, so a temporary strong capture is fine and often correct (you usually *want* the object alive to receive the result). The cycle only exists if `self` retains the closure. *"How do you find one?"* Xcode Memory Graph Debugger, or Instruments → Leaks; the giveaway is a `deinit` that never runs.

**Red flags.** Sprinkling `[weak self]` everywhere without being able to say which reference completes the cycle. Using `unowned` on a delegate.

#### A5. "`some Protocol` vs `any Protocol`."
`commonly-circulated` (reported as a rising senior-level question [39]) · domain round · **Testing:** whether you understand existential boxing.

**Solution.** `some P` is an **opaque type**: one concrete type, chosen by the callee, known to the compiler, statically dispatched, no boxing. `any P` is an **existential**: any conforming type, erased at runtime, dynamically dispatched, boxed (with heap allocation once the value exceeds the inline buffer). Use `some` for return types and parameters where a single concrete type flows through — the default for performance. Use `any` when you genuinely need heterogeneity, e.g. `[any Shape]`.

```swift
// One concrete type; the caller can't name it but the compiler can.
func makeHeader() -> some View { Text("Hi").font(.title) }

// Heterogeneous storage genuinely needs an existential.
let shapes: [any Shape] = [Circle(), Rectangle()]
```

**Follow-ups.** *"Why can't a PAT-having protocol be used as `any` without care?"* Before Swift 5.7 it couldn't at all; now `any P` is allowed but you can't use the associated types without opening the existential (`some`/generic parameter). *"Which does SwiftUI's `body` use and why?"* `some View`, so the entire view tree's type is statically known and the diffing can be structural.

**Red flags.** Treating them as interchangeable syntax. Not knowing existentials allocate.

#### A6. "Design a type-erased wrapper."
`commonly-circulated` · live coding, senior · **Testing:** generics fluency.

```swift
protocol ImageLoading {
    associatedtype Output
    func load(_ url: URL) async throws -> Output
}

struct AnyImageLoader<Output>: ImageLoading {
    private let _load: @Sendable (URL) async throws -> Output
    init<L: ImageLoading>(_ loader: L) where L.Output == Output, L: Sendable {
        _load = { try await loader.load($0) }
    }
    func load(_ url: URL) async throws -> Output { try await _load(url) }
}
```

**Analysis.** The technique is always the same: store closures that capture the concrete instance, forward through them. Mention that in modern Swift you frequently *don't* need this — `some`, generics, or a plain struct-of-closures dependency often reads better and avoids the wrapper.

**Red flags.** Reaching for `AnyX` before checking whether a generic parameter would do.

#### A7. "Decode this JSON where the API is inconsistent."
`commonly-circulated`; the **DoorDash** take-home is explicitly about loading and displaying JSON [13] · take-home / live coding · **Testing:** `Codable` beyond the happy path.

```swift
struct Item: Decodable, Identifiable, Sendable {
    let id: String
    let name: String
    let price: Decimal
    let tags: [String]

    private enum CodingKeys: String, CodingKey {
        case id, name, price = "price_cents", tags
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        // The API sends id as a number sometimes and a string other times.
        if let intID = try? c.decode(Int.self, forKey: .id) {
            id = String(intID)
        } else {
            id = try c.decode(String.self, forKey: .id)
        }
        name = try c.decode(String.self, forKey: .name)
        let cents = try c.decode(Int.self, forKey: .price)
        price = Decimal(cents) / 100
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
    }
}
```

**Follow-ups.** *"One bad element shouldn't kill the whole list — how?"* Wrap in a `FailableDecodable<T>` and `compactMap`, or decode into an `UnkeyedDecodingContainer` and skip failures. *"Dates?"* `JSONDecoder.dateDecodingStrategy = .iso8601`, with `.custom` for fractional seconds. *"Money as `Double`?"* No — `Decimal`, or integer minor units.

**Red flags.** Using `Double` for currency. Making every field optional to "make it not crash", which pushes the failure into the UI layer.

#### A8. "`throws` vs `Result` vs typed throws."
`commonly-circulated` · domain round.

**Solution.** In async code, `throws` + `try await` is the default and `Result` is largely legacy — it existed to give completion-handler APIs a single success/failure parameter. Keep `Result` when you need to *store* an outcome (caching a failed fetch, a `TaskResult`-style reducer payload). Swift 6 adds **typed throws** (`func f() throws(NetworkError)`), which are valuable in library boundaries and embedded contexts but over-constrain most app code — an untyped `throws` lets you add error cases without breaking callers.

**Red flags.** Converting every `throws` into `Result` "for consistency". Catching and swallowing with `try?`.

---

### B. Concurrency

#### B1. "Migrate this completion-handler API to async/await."
`commonly-circulated` · live coding · **Testing:** continuation discipline.

```swift
// Legacy
func fetchUser(id: String, completion: @escaping (Result<User, Error>) -> Void)

// Bridge
func fetchUser(id: String) async throws -> User {
    try await withCheckedThrowingContinuation { continuation in
        fetchUser(id: id) { result in
            continuation.resume(with: result)
        }
    }
}
```

**Analysis.** State the contract: a continuation must be resumed **exactly once** — zero times leaks the task forever, twice traps. Use `withChecked...` in development (it diagnoses misuse) and consider `withUnsafe...` only in measured hot paths. If the legacy callback can fire multiple times, a continuation is the wrong tool — use `AsyncStream`.

**Follow-ups.** *"How do you support cancellation?"* `withTaskCancellationHandler`, cancelling the underlying `URLSessionTask` in the handler. *"Which thread does the callback arrive on?"* Whatever the legacy API promises; `await` resumption lands you back in the caller's isolation domain, which is the point.

**Red flags.** Resuming inside a loop. Assuming `async` implies background execution — it does not; isolation determines the executor.

#### B2. "What is an actor, and why can't you just use `@MainActor` everywhere?"
`commonly-circulated`, reported as standard at Swift 6-adopting companies [6][7] · domain round.

**Solution.** An `actor` is a reference type with compiler-enforced **mutual exclusion over its own mutable state**: all cross-actor access is `async`, so only one task touches the state at a time. `@MainActor` is a *global* actor whose executor is the main thread. Putting everything on `@MainActor` is correct for UI state and wrong for anything else — it serialises all work onto the one thread that must stay free to render, reintroducing the exact hitches actors exist to avoid.

```swift
actor ImageCache {
    private var storage: [URL: Data] = [:]
    func data(for url: URL) -> Data? { storage[url] }
    func store(_ data: Data, for url: URL) { storage[url] = data }
}
```

**Follow-ups.** *"What is actor reentrancy and why does it bite?"* At every `await` inside an actor method the actor is released and another task may mutate state; assumptions made before the `await` may be false after it — see **B8**. *"`nonisolated`?"* Marks members that touch no mutable state so they can be called synchronously (`nonisolated let`, `nonisolated func` on immutable data). *"Swift 6.2's default-MainActor mode?"* Newer toolchains can default modules to `@MainActor` isolation, inverting the burden so that *leaving* the main actor is the explicit act. [40]

**Red flags.** "An actor is just a serial queue." It's a serial *isolation domain* with compile-time checking and non-blocking suspension — a queue gives you neither.

#### B3. "Explain `Sendable` and what changed in Swift 6."
`commonly-circulated` [6][7] · domain round · **Testing:** whether you've actually migrated a codebase.

**Solution.** `Sendable` is a marker protocol asserting a type is safe to cross a concurrency boundary. Value types composed of `Sendable` members conform implicitly. Reference types must either be `final` with immutable state, or be `@unchecked Sendable` with a *manually documented* synchronisation mechanism, or be an `actor`. **In Swift 5.x, violations were warnings; Swift 6 makes them compile errors.** [6] Migration is incremental: `SWIFT_STRICT_CONCURRENCY = targeted` first, module by module, then `complete`, then the Swift 6 language mode.

```swift
struct User: Sendable { let id: UUID; let name: String }   // implicit

final class Metrics: @unchecked Sendable {                 // manual proof required
    private let lock = NSLock()
    private var counts: [String: Int] = [:]
    func increment(_ key: String) {
        lock.lock(); defer { lock.unlock() }
        counts[key, default: 0] += 1
    }
}
```

**Follow-ups.** *"`@Sendable` closure?"* The closure itself must capture only `Sendable` values. *"Cheapest way to silence an error?"* `@unchecked Sendable` — and it's the most dangerous, because it moves the guarantee from the compiler to you.

**Red flags.** Blanket `@unchecked Sendable` to get a build green. Not knowing the difference between the warning-era and error-era behaviour, which is the actual question.

#### B4. "Fetch N resources concurrently, cancel cleanly, preserve order."
`commonly-circulated` · live coding.

```swift
func loadAll(_ urls: [URL]) async throws -> [Data] {
    try await withThrowingTaskGroup(of: (Int, Data).self) { group in
        for (index, url) in urls.enumerated() {
            group.addTask {
                try Task.checkCancellation()
                let (data, _) = try await URLSession.shared.data(from: url)
                return (index, data)
            }
        }
        var results = [Data?](repeating: nil, count: urls.count)
        for try await (index, data) in group {
            results[index] = data
        }
        return results.compactMap { $0 }
    }
}
```

**Analysis.** Three points the grader wants: (1) a `TaskGroup` completes in *completion* order, so you re-key by index if order matters; (2) throwing from a child cancels the group — that's structured concurrency doing its job; (3) cancellation is cooperative, so long CPU loops need explicit `Task.checkCancellation()`.

**Follow-ups.** *"Limit to 4 in flight?"* Seed the group with 4 tasks, then add one more each time you consume a result. *"`async let` vs `TaskGroup`?"* `async let` for a fixed, small, heterogeneous set known at compile time; `TaskGroup` for a dynamic homogeneous collection.

**Red flags.** `compactMap` over a results array without noticing it silently drops failures (fine here only because a throw aborts the group). Spawning an unbounded group over 10,000 URLs.

#### B5. "This cache races. Fix it three ways."
`commonly-circulated` · debugging round.

```swift
// Racy
final class Cache {
    private var storage: [String: Data] = [:]
    func value(_ k: String) -> Data? { storage[k] }
    func set(_ v: Data, _ k: String) { storage[k] = v }
}
```

1. **Actor** — the modern default: `actor Cache { ... }`; callers `await`.
2. **Serial dispatch queue with barriers** — concurrent queue, `.barrier` on writes; still correct, still what most legacy codebases do.
3. **`NSLock` / `OSAllocatedUnfairLock` + `@unchecked Sendable`** — lowest overhead, synchronous API preserved, correctness now your responsibility.

```swift
final class Cache: @unchecked Sendable {
    private let lock = OSAllocatedUnfairLock()
    private var storage: [String: Data] = [:]
    func value(_ k: String) -> Data? { lock.withLock { storage[k] } }
    func set(_ v: Data, _ k: String) { lock.withLock { storage[k] = v } }
}
```

**Follow-ups.** *"Why would you not choose the actor?"* Because it forces every caller to become `async`, which can cascade through a synchronous codebase — a real migration cost, and the honest answer.

#### B6. "`@MainActor` — where does it belong?"
`commonly-circulated` · domain round.

**Solution.** On the type that owns UI-facing state (view models, `@Observable` models feeding SwiftUI), not on the networking or persistence layer. Annotate the *type*, not every method. Inside a `@MainActor` type, `await` on a non-isolated async function hops off and back automatically — you should not need `DispatchQueue.main.async` anywhere in new code.

**Red flags.** `DispatchQueue.main.async` inside an `async` function. `@MainActor` on a repository.

#### B7. "Turn a delegate callback into an `AsyncSequence`."
`commonly-circulated` · live coding, senior.

```swift
final class LocationStream {
    func locations() -> AsyncStream<CLLocation> {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            let delegate = Delegate { continuation.yield($0) }
            let manager = CLLocationManager()
            manager.delegate = delegate
            manager.startUpdatingLocation()
            continuation.onTermination = { _ in
                manager.stopUpdatingLocation()
                _ = delegate            // keep alive until termination
            }
        }
    }
}
```

**Analysis.** The two graded details are the **buffering policy** (unbounded buffering on a high-frequency source is a memory leak in slow motion) and `onTermination` (teardown when the consumer cancels). Mention `AsyncThrowingStream` when the source can fail.

#### B8. "Actor reentrancy: what's wrong here?"
`commonly-circulated` · senior domain round.

```swift
actor TokenProvider {
    private var token: Token?
    func token() async throws -> Token {
        if let token, !token.isExpired { return token }
        let fresh = try await network.refresh()   // <- suspension point
        self.token = fresh                        // N concurrent callers => N refreshes
        return fresh
    }
}
```

**Fix — deduplicate on the in-flight task:**

```swift
actor TokenProvider {
    private enum State { case idle, refreshing(Task<Token, Error>), valid(Token) }
    private var state: State = .idle

    func token() async throws -> Token {
        switch state {
        case .valid(let t) where !t.isExpired: return t
        case .refreshing(let task): return try await task.value
        default:
            let task = Task { try await network.refresh() }
            state = .refreshing(task)
            do {
                let t = try await task.value
                state = .valid(t)
                return t
            } catch {
                state = .idle
                throw error
            }
        }
    }
}
```

**Red flags.** Believing actor isolation prevents this. It prevents *data races*, not *logical* races across suspension points — the distinction this question exists to find.

---

### C. UIKit

#### C1. "View controller lifecycle order, and where does layout belong?"
`commonly-circulated` · phone screen.

`loadView` → `viewDidLoad` (once; one-time setup) → `viewWillAppear` (every appearance; refresh state) → `viewWillLayoutSubviews` → `viewDidLayoutSubviews` (frames are valid **here**, may run many times) → `viewDidAppear` (start animations, analytics) → `viewWillDisappear` → `viewDidDisappear`. **Red flag:** reading `view.bounds` in `viewDidLoad` and hard-coding frames from it.

#### C2. "Content hugging vs compression resistance."
`commonly-circulated` · phone screen.

Hugging = resistance to growing beyond intrinsic size. Compression resistance = resistance to shrinking below it. Both are priorities, and in a two-label row the fix for "the wrong label truncates" is to raise the *other* label's hugging or the truncating label's compression resistance — not to add width constraints. **Red flag:** "I just set a fixed width."

#### C3. "Wrong images appear in reused cells."
`candidate-reported` pattern; a debugging round at DoorDash is reported [14] · debugging.

**Cause.** The async image load completes after the cell has been dequeued for a different index path. **Fix:** cancel the in-flight task in `prepareForReuse`, and re-check identity before assigning.

```swift
final class ItemCell: UICollectionViewCell {
    private var loadTask: Task<Void, Never>?
    private var itemID: Item.ID?

    func configure(with item: Item, loader: ImageLoader) {
        itemID = item.id
        imageView.image = nil
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            let image = try? await loader.image(for: item.imageURL)
            guard let self, self.itemID == item.id else { return }
            self.imageView.image = image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        loadTask?.cancel(); loadTask = nil; itemID = nil; imageView.image = nil
    }
}
```

#### C4. "Why diffable data sources?"
`commonly-circulated`. They move you from imperative `performBatchUpdates` (where a mismatch between your model and your update counts is a hard crash) to declarative snapshots, with the framework computing the diff. Requires `Hashable` **identifiers**, not the models themselves — hashing the whole model means any field change reads as a delete+insert and you lose the animation. iOS 15+ `reconfigureItems` updates a visible cell in place without recreating it.

#### C5. "Scroll performance is bad. Diagnose it."
`commonly-circulated` · debugging. Order of attack: Instruments (Time Profiler + Animation Hitches / Core Animation), then look for (a) work on the main thread in `cellForItemAt`, (b) image decoding not moved off-main (`UIGraphicsImageRenderer` or `preparingForDisplay()`), (c) off-screen rendering from `cornerRadius` + `masksToBounds` on non-trivial layers, (d) unnecessary transparency, (e) Auto Layout thrash from deep nesting. **Red flag:** guessing before measuring.

---

### D. SwiftUI

#### D1. "`@State` vs `@Binding` vs `@StateObject` vs `@ObservedObject` vs `@EnvironmentObject`."
`commonly-circulated` [8][9] · every SwiftUI screen.

| Wrapper | Owns? | Use for |
|---|---|---|
| `@State` | Yes | Value-type state private to this view |
| `@Binding` | No | A two-way handle to state owned by an ancestor |
| `@StateObject` | Yes | An `ObservableObject` this view *creates* — survives re-renders |
| `@ObservedObject` | No | An `ObservableObject` passed in from outside |
| `@EnvironmentObject` | No | An `ObservableObject` injected through the environment |
| `@Environment` | No | Environment values, and `@Observable` objects from `.environment(_:)` |

**The graded distinction** is `@StateObject` vs `@ObservedObject`: SwiftUI recreates the view struct constantly, and `@StateObject` guarantees the object is initialised once for the view's lifetime, whereas an `@ObservedObject` created inline is reconstructed on every re-render — the classic "my view model keeps resetting" bug.

#### D2. "`@Observable` vs `ObservableObject` — what actually changed?"
`commonly-circulated`, high frequency [8][9] · SwiftUI round.

**Solution.** With `ObservableObject`, any `@Published` mutation invalidates **every** view observing the object. With `@Observable` (the Observation framework, iOS 17+), SwiftUI records **which properties each view actually read during `body`** and invalidates only views that read the property that changed. Practical consequences: fewer re-renders for free; `@StateObject`/`@ObservedObject` are replaced by plain `@State` (for ownership) and a plain `let` (for pass-through); `@EnvironmentObject` becomes `@Environment`; and optional/array-of-observable modelling gets simpler.

```swift
@Observable
final class CartModel {
    var items: [Item] = []
    var promoCode: String = ""
    var total: Decimal { items.reduce(0) { $0 + $1.price } }
}

struct CartView: View {
    @State private var model = CartModel()      // ownership: @State, not @StateObject
    var body: some View {
        VStack {
            TotalLabel(model: model)            // plain let — no property wrapper needed
            TextField("Promo", text: $model.promoCode)
        }
        .environment(model)                     // not .environmentObject
    }
}

struct TotalLabel: View {
    let model: CartModel
    var body: some View { Text(model.total, format: .currency(code: "USD")) }
    // Reads only `total`/`items` — typing in the promo field does NOT re-render this.
}
```

**Follow-ups.** *"Can you mix them?"* Technically yes, in practice don't — the invalidation semantics differ and the result is hard to reason about. [9] *"Which does SwiftData require?"* `@Observable`. *"Does `@Observable` work outside SwiftUI?"* Yes — `withObservationTracking` gives you the same tracking in non-UI code.

**Red flags.** Saying `@Observable` is "just a shorter `ObservableObject`". Not being able to state the per-property tracking difference — this is the point of the question.

#### D3. "Why does my list animate wrongly / lose state on update?"
`commonly-circulated` · SwiftUI round · **Testing:** view identity.

**Analysis.** SwiftUI identifies views **structurally** (position in the view tree) plus **explicitly** (`.id()`, `ForEach` identifiers). Two failure modes: (1) `ForEach(items, id: \.self)` on a value type whose contents change — the identifier changes with the content, so an edit reads as delete+insert and state is lost; use a stable `id` (`Identifiable` with a UUID or server ID). (2) Branching in `if/else` creates *different* structural identities, so state does not carry across the branch; if you want it to, use a single view with a changing property, or use `.id()` deliberately to force a reset.

```swift
// Bad: identity changes whenever the item's contents change
ForEach(items, id: \.self) { ItemRow(item: $0) }

// Good: identity is stable across edits
ForEach(items) { ItemRow(item: $0) }   // Item: Identifiable

// Deliberate reset: new id => brand-new view, fresh @State
ContentView().id(selectedTab)
```

**Red flags.** Using `.id(UUID())` in `body` — a new identity every render, which destroys and recreates the subtree every frame.

#### D4. "Explain the SwiftUI layout system."
`commonly-circulated` · SwiftUI round.

**Solution.** Three steps, one sentence each: **the parent proposes a size, the child chooses its own size, the parent places the child.** Children are never forced. `frame(width:height:)` does not set the child's size — it inserts a wrapper that proposes that size and centres the child. `.fixedSize()` tells the child to use its ideal size and ignore the proposal. Layout priorities decide which sibling gets scarce space in a stack. Since iOS 16, `Layout` lets you write custom layouts with `sizeThatFits` and `placeSubviews`.

**Follow-ups.** *"Why is my text truncating inside an HStack?"* The stack divided space by priority, and `Text` accepted a narrower proposal; raise `.layoutPriority` or use `.fixedSize(horizontal: false, vertical: true)`. *"When is `GeometryReader` the wrong tool?"* Almost always as an outer container — it accepts the full proposed size and greedily fills, breaking parent sizing. Prefer `.containerRelativeFrame`, `ViewThatFits`, or a `PreferenceKey`.

#### D5. "Measure a child's size and act on it in the parent."
`commonly-circulated` · live coding, senior.

```swift
private struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

extension View {
    func measureWidth(into binding: Binding<CGFloat>) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
        })
        .onPreferenceChange(WidthKey.self) { binding.wrappedValue = $0 }
    }
}
```

**Analysis.** Preferences flow **child → parent** (environment flows parent → child). The `GeometryReader` goes in a `.background`, where it takes the size of the thing it's measuring rather than dictating it. On iOS 18+ `onGeometryChange(for:of:action:)` does this natively and should be preferred; the `PreferenceKey` version is what you write when supporting older OSes. **Red flag:** a feedback loop where the measured value changes the layout that produced it.

#### D6. "My SwiftUI list stutters. What do you check?"
`commonly-circulated` · SwiftUI/performance round.

In order: (1) Is `body` doing work? Sorting, filtering, date formatting and `DateFormatter` construction in `body` run on every render — hoist them. (2) Is the invalidation scope too wide? An `ObservableObject` whose every change redraws the whole screen — split the model, or migrate to `@Observable`. (3) `List` vs `LazyVStack` in a `ScrollView`: `List` recycles rows, `LazyVStack` only defers creation and never releases — for thousands of rows `List` is usually right. (4) `AnyView` erases type information and defeats structural diffing — use `@ViewBuilder` or `Group`. (5) Instruments' SwiftUI template for view-body counts. **Red flag:** blaming SwiftUI before measuring which bodies re-run.

#### D7. "Navigation: `NavigationStack`, deep links, and restoring state."
`commonly-circulated` · SwiftUI round.

```swift
enum Route: Hashable { case item(Item.ID), settings, profile(User.ID) }

@Observable final class Router { var path: [Route] = [] }

struct RootView: View {
    @State private var router = Router()
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .item(let id):    ItemDetailView(id: id)
                    case .settings:        SettingsView()
                    case .profile(let id): ProfileView(id: id)
                    }
                }
        }
        .environment(router)
        .onOpenURL { url in router.path = Route.parse(url) }
    }
}
```

**Analysis.** The upgrade over `NavigationView` + `NavigationLink(isActive:)` is that the path is **data you own**: deep links become "replace the array", "pop to root" is `path.removeAll()`, and state restoration is `Codable` on the path. `NavigationView` is deprecated; `NavigationSplitView` handles multi-column. **Red flag:** a boolean `isPresented` per screen, which cannot express arbitrary deep links.

---

### E. Architecture

#### E1. "MVVM vs VIPER vs TCA vs plain MVC."
`candidate-reported` — architecture discussions are an explicit stage at Uber [25] and Monzo probes design of real problems [13] · architecture round.

**Analysis.** There is no correct answer here and interviewers who think there is are testing conformity, not skill. What is graded is whether you argue from constraints. **MVVM + `@Observable`** is the current default for SwiftUI: cheap, testable view models, no ceremony. **TCA** buys you exhaustive state modelling, time-travel debugging and genuinely excellent testability at the cost of a steep learning curve, compile times, and a hard dependency on a third party — defensible in a large team with strong conventions, expensive in a small one. **VIPER** solves module-boundary problems in large UIKit codebases and produces a lot of files; rarely the right choice for greenfield SwiftUI. **MVC** is fine for genuinely simple screens and pretending otherwise is cargo-culting.

**Follow-ups.** *"How do you keep MVVM from becoming Massive View Model?"* Push formatting into the view, side effects into services, and split by screen region rather than by screen. *"Where does navigation live?"* Coordinator/router, so view models don't import UIKit/SwiftUI.

**Red flags.** Advocating one architecture as universally correct. Not being able to name a downside of your own preference.

#### E2. "How do you inject dependencies?"
`commonly-circulated` · architecture round.

**Solution.** Constructor injection as the default — explicit, testable, no magic. `@Environment` for cross-cutting SwiftUI dependencies (theme, router, feature flags). A protocol-per-dependency is the conventional approach; a struct-of-closures is often better in Swift because it's trivially stubbable inline:

```swift
struct UserService: Sendable {
    var fetch: @Sendable (User.ID) async throws -> User
}

extension UserService {
    static let live = UserService { id in try await api.get("/users/\(id)") }
    static func stub(_ user: User) -> UserService { UserService { _ in user } }
}
```

**Red flags.** A global singleton registry resolved by type at runtime — it moves compile-time errors to runtime crashes, and it makes parallel tests flaky.

#### E3. "How would you modularise a large app?"
`candidate-reported` (Uber, Monzo both discuss real architectural problems) · senior architecture round.

Split by **feature** with a shared `Core`/`DesignSystem`/`Networking` layer, using Swift Package Manager local packages. Benefits: enforced boundaries (you cannot import what you didn't declare), parallel builds, per-module test targets, and sample apps per feature for fast iteration. Costs: dependency-graph maintenance, versioning friction, and slower cold builds if the graph is deep. Mention that large shops (Robinhood's posting names **Bazel** [31]) move to Bazel or similar when SPM's incrementality stops scaling.

#### E4. "Make this view model testable and test it."
`commonly-circulated` · live coding.

```swift
@MainActor @Observable
final class SearchViewModel {
    private(set) var results: [Item] = []
    private(set) var isLoading = false
    private let search: @Sendable (String) async throws -> [Item]
    private var task: Task<Void, Never>?

    init(search: @escaping @Sendable (String) async throws -> [Item]) { self.search = search }

    func query(_ text: String) {
        task?.cancel()
        task = Task {
            isLoading = true
            defer { isLoading = false }
            try? await Task.sleep(for: .milliseconds(300))   // debounce
            guard !Task.isCancelled else { return }
            results = (try? await search(text)) ?? []
        }
    }
}

@MainActor
@Test func searchPopulatesResults() async throws {
    let vm = SearchViewModel(search: { _ in [Item.fixture] })
    vm.query("swift")
    try await Task.sleep(for: .milliseconds(400))
    #expect(vm.results.count == 1)
}
```

**Follow-ups.** *"That test sleeps — how do you fix it?"* Inject the clock (`any Clock<Duration>`) and use a test clock, or expose the `Task` so the test can `await` it. Time-dependent tests that sleep are the most common source of CI flakiness, and saying so is a strong signal.

---

### F. Networking & persistence

#### F1. "Retry with exponential backoff and jitter."
`commonly-circulated` · live coding.

```swift
func withRetry<T: Sendable>(
    maxAttempts: Int = 3,
    isRetryable: (Error) -> Bool = { ($0 as? URLError)?.isTransient ?? false },
    operation: () async throws -> T
) async throws -> T {
    var attempt = 0
    while true {
        do { return try await operation() }
        catch {
            attempt += 1
            guard attempt < maxAttempts, isRetryable(error), !Task.isCancelled else { throw error }
            let base = pow(2.0, Double(attempt))            // 2, 4, 8 …
            let jitter = Double.random(in: 0...1)
            try await Task.sleep(for: .seconds(base + jitter))
        }
    }
}
```

**Analysis.** Graded points: **do not retry non-idempotent requests** without an idempotency key; **do not retry 4xx** (except 408/429); honour `Retry-After`; jitter exists to stop synchronised clients stampeding a recovering server. **Red flag:** retrying a POST that charges a card.

#### F2. "Paginate a feed with caching."
`commonly-circulated` · live coding / design.

Cursor-based pagination over offset (offset double-counts when items are inserted mid-scroll). Keep a `nextCursor: String?`; `nil` means the end. Guard against concurrent page loads with an in-flight flag. Cache pages by cursor with a short TTL, and treat the cache as *presentation* state — render cached data immediately, then reconcile.

#### F3. "Design offline-first sync with conflict resolution."
`commonly-circulated`; explicitly named as an iOS system-design theme [41] · system design.

**Components.** Local store as source of truth for the UI → an outbox of pending mutations (persisted, ordered, each with a client-generated ID for idempotency) → a sync engine that drains the outbox on connectivity and pulls a delta since the last server cursor → a conflict resolver.

**Conflict strategies, with honest trade-offs:** last-write-wins (trivial, silently loses data — acceptable for preferences); server-wins (safe, frustrating); per-field merge (good for structured records, needs field-level timestamps); CRDTs (correct for concurrent text editing, expensive in metadata and complexity); or surface the conflict to the user (correct when the data is irreplaceable).

**Graded details.** Client-generated IDs so a retried create doesn't duplicate; a monotonic sync cursor rather than wall-clock time (device clocks are wrong); tombstones for deletes; and what happens when the outbox fails permanently — you need a poison-message path, not an infinite retry.

#### F4. "Core Data vs SwiftData vs GRDB/SQLite vs Realm."
`commonly-circulated` · design round.

**SwiftData** — Swift-native, `@Model` + `@Observable`, minimal ceremony, best fit for new SwiftUI apps; less control over migrations and weaker for very large/complex schemas. **Core Data** — mature, powerful (`NSFetchedResultsController`, batch operations, fine-grained migrations), verbose, concurrency model is a common source of bugs (`perform` on the right context, never pass `NSManagedObject` across contexts). **GRDB / raw SQLite** — you write SQL, you get predictable performance and explicit migrations; best when queries are the hard part. **Realm** — pleasant API and built-in sync, but a third-party runtime and thread-confined objects.

**Follow-up: "How do you handle a migration that isn't lightweight?"** Version the store, write a mapping model or a staged migration through intermediate versions, run it off the main thread with a progress UI, always keep a rollback (copy the store first), and test the migration against a real production-sized store — not a fixture with ten rows.

---

### G. Live-coding problems as actually posed

#### G1. LRU cache, O(1)
`commonly-circulated`, very high frequency [42] · live coding.

```swift
final class LRUCache<Key: Hashable, Value> {
    private final class Node {
        let key: Key; var value: Value
        var prev: Node?; var next: Node?
        init(_ key: Key, _ value: Value) { self.key = key; self.value = value }
    }

    private let capacity: Int
    private var map: [Key: Node] = [:]
    private var head: Node?   // most recently used
    private var tail: Node?   // least recently used

    init(capacity: Int) { self.capacity = max(1, capacity) }

    func value(forKey key: Key) -> Value? {
        guard let node = map[key] else { return nil }
        moveToFront(node)
        return node.value
    }

    func set(_ value: Value, forKey key: Key) {
        if let node = map[key] {
            node.value = value
            moveToFront(node)
            return
        }
        let node = Node(key, value)
        map[key] = node
        addToFront(node)
        if map.count > capacity, let lru = tail {
            remove(lru)
            map[lru.key] = nil
        }
    }

    private func addToFront(_ node: Node) {
        node.next = head; node.prev = nil
        head?.prev = node
        head = node
        if tail == nil { tail = node }
    }

    private func remove(_ node: Node) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
        if head === node { head = node.next }
        if tail === node { tail = node.prev }
        node.prev = nil; node.next = nil
    }

    private func moveToFront(_ node: Node) {
        guard head !== node else { return }
        remove(node); addToFront(node)
    }
}
```

**Analysis.** Hash map + doubly-linked list is the only structure that gives O(1) on both operations; a plain array is O(n) on recency updates. Say the invariant out loud before coding: *map gives O(1) lookup, list gives O(1) recency reordering, every map entry is a live list node.*

**Follow-ups.** *"Make it thread-safe."* Wrap in an `actor` (callers become async) or a lock. *"Add TTL."* Store an expiry per node and evict lazily on read plus a periodic sweep. *"Why not just `NSCache`?"* `NSCache` is thread-safe and purges under memory pressure but gives you no eviction-order guarantee and no TTL — the correct production answer for images, the wrong answer when the interviewer wants the data structure. Say both.

**Red flags.** Retain cycles in the linked list going unmentioned (this one is acyclic in the `prev`/`next` sense only because we clear pointers on removal — a bidirectional strong list keeps nodes alive as long as the list holds them, which is intended here). Forgetting to update `tail` when evicting.

#### G2. Image loader with in-flight deduplication
`commonly-circulated`; overlaps the image-caching system design [43] · live coding.

```swift
actor ImageLoader {
    private enum Entry { case inFlight(Task<UIImage, Error>), ready(UIImage) }
    private var cache: [URL: Entry] = [:]

    func image(for url: URL) async throws -> UIImage {
        if let entry = cache[url] {
            switch entry {
            case .ready(let image):  return image
            case .inFlight(let task): return try await task.value   // dedup
            }
        }
        let task = Task<UIImage, Error> {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode),
                  let image = UIImage(data: data)?.preparingForDisplay()
            else { throw URLError(.cannotDecodeContentData) }
            return image
        }
        cache[url] = .inFlight(task)
        do {
            let image = try await task.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil        // don't cache the failure
            throw error
        }
    }
}
```

**Graded points.** Deduplication (ten cells asking for the same avatar issue one request); `preparingForDisplay()` to decode off the main thread; not caching failures; and knowing that an unbounded dictionary is a leak — production wants `NSCache` for memory plus a disk layer.

#### G3. Debounce and throttle
`commonly-circulated` · live coding.

```swift
@MainActor
final class Debouncer {
    private var task: Task<Void, Never>?
    private let delay: Duration
    init(delay: Duration = .milliseconds(300)) { self.delay = delay }

    func callAsFunction(_ action: @escaping @MainActor () -> Void) {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }
            action()
        }
    }
}
```

**Analysis.** Debounce = fire once after the input goes quiet (search fields). Throttle = fire at most once per interval regardless (scroll telemetry). Candidates confuse them constantly; being able to name which one a search box needs is half the grade. In Combine these are `.debounce(for:scheduler:)` and `.throttle(for:scheduler:latest:)`; be ready to write it in both styles.

#### G4. Token-bucket rate limiter
`commonly-circulated` · live coding, senior.

```swift
actor RateLimiter {
    private let capacity: Double
    private let refillPerSecond: Double
    private var tokens: Double
    private var lastRefill: ContinuousClock.Instant

    init(capacity: Double, refillPerSecond: Double, clock: ContinuousClock = .init()) {
        self.capacity = capacity
        self.refillPerSecond = refillPerSecond
        self.tokens = capacity
        self.lastRefill = clock.now
    }

    func acquire(_ cost: Double = 1) async {
        while true {
            refill()
            if tokens >= cost { tokens -= cost; return }
            let deficit = cost - tokens
            try? await Task.sleep(for: .seconds(deficit / refillPerSecond))
        }
    }

    private func refill() {
        let now = ContinuousClock().now
        let elapsed = Double((now - lastRefill).components.seconds)
            + Double((now - lastRefill).components.attoseconds) / 1e18
        tokens = min(capacity, tokens + elapsed * refillPerSecond)
        lastRefill = now
    }
}
```

**Graded points.** `ContinuousClock` not `Date` (wall-clock jumps; `ContinuousClock` doesn't); capacity as burst allowance; and a note that the loop-and-sleep design is starvation-prone under contention — a production version queues waiters in FIFO order.

#### G5. "Reverse a linked list in Swift" / "two numbers summing to a target"
`candidate-reported` at Meta [21] · phone screen / coding round.

```swift
func twoSum(_ nums: [Int], _ target: Int) -> (Int, Int)? {
    var seen: [Int: Int] = [:]                 // value -> index
    for (i, n) in nums.enumerated() {
        if let j = seen[target - n] { return (j, i) }
        seen[n] = i
    }
    return nil
}
```

**Analysis.** These are ordinary DS&A questions that happen to be posed in Swift. What differentiates iOS candidates: idiomatic Swift (`enumerated()`, dictionary default subscripts, no C-style loops), correct handling of duplicates, and stating complexity unprompted (O(n) time / O(n) space, versus the sort-and-two-pointer O(n log n) time / O(1) space alternative and when you'd pick it).

**Red flags.** Writing Objective-C-shaped Swift. Not asking whether the array is sorted or whether indices or values are wanted.

#### G6. Thread-safe collection
`commonly-circulated` · live coding. See **B5** for the three-way answer (actor / barrier queue / lock). The extra credit is knowing which one you can hand to a synchronous legacy caller (the lock) and which one gives you compile-time proof (the actor).

---

### H. iOS system design

Format expectation: 45–60 minutes, and the constraints that make it *iOS* system design rather than backend system design are **memory limits, background-execution limits, battery, intermittent connectivity, and App Store review**. Interviewers report that candidates who draw a backend architecture and never mention these do poorly. [41][44]

#### H1. "Design an image downloading and caching library."
`commonly-circulated`, very high frequency [43].

**Clarify first:** expected image sizes and volume? Does it need to survive app launches? Prefetching for scroll? Is authentication needed on image URLs? Memory budget?

**Components.** Public API (`func image(for: URL) async throws -> UIImage`) → in-flight deduplication (G2) → memory cache (`NSCache`, cost-weighted by decoded byte size, auto-purges under pressure) → disk cache (URL-hash filenames, LRU eviction on a size budget, plus `URLCache` for HTTP-level revalidation) → network (`URLSession` with a per-host concurrency cap) → decode off the main thread (`preparingForDisplay`/`preparingThumbnail(of:)`, downsampling to the display size via ImageIO).

**Key trade-offs to state.** Cache *decoded* images (fast to render, memory-hungry) vs. *encoded* data (compact, costs CPU per display) — usually decoded in memory, encoded on disk. Cache keyed by URL vs. by URL+target-size (thumbnails of the same asset should not evict each other). Eviction by count vs. by byte cost — byte cost, always. Respect HTTP cache headers rather than inventing your own TTL where you can.

**Follow-ups.** *"How do you avoid decoding a 4000×3000 image into memory for a 100pt thumbnail?"* `CGImageSourceCreateThumbnailAtIndex` with `kCGImageSourceThumbnailMaxPixelSize` — decode-time downsampling, the single biggest memory win. *"Cancellation on fast scroll?"* Cancel the `Task` in `prepareForReuse` and let deduplication handle re-requests.

#### H2. "Design a chat client."
`commonly-circulated`.

Local SQLite/Core Data store as the source of truth; a WebSocket for realtime with a `URLSession` REST fallback for history; an outbox for optimistic sends with client-generated message IDs and three states (sending/sent/failed); ordering by server sequence number with local monotonic tiebreak; pagination backwards through history by cursor; push notifications for background delivery with a notification-service-extension to decrypt/enrich; and reconnection with exponential backoff plus a gap-fill query on resume (`since: lastSequence`).

**Graded trade-offs.** Optimistic UI vs. correctness; how you dedupe when a message arrives both over the socket and in the gap-fill (client ID); what happens on clock skew (never order by device time); and the background-execution reality — iOS will not keep your socket alive, so push is not optional.

#### H3. "Design an offline-first notes app."
`commonly-circulated` [45]. See **F3** for the sync engine. Notes-specific points: text conflicts are the hard case, so either CRDT/OT for real concurrent editing or per-note last-write-wins with a "conflicted copy" escape hatch (what Apple Notes and Dropbox both effectively do); attachments sync separately from text and need resumable upload (H5); full-text search wants an FTS index locally rather than a server round-trip.

#### H4. "Design an analytics SDK."
`commonly-circulated`.

Public API (`track(event:properties:)`, non-blocking, callable from any thread — so an `actor` or a lock-protected buffer) → in-memory buffer → persistent queue (survives crashes; the whole point) → batching by size *and* time, flushed on background transition via `beginBackgroundTask` → retry with backoff → sampling and a kill switch delivered by remote config. Non-obvious requirements the interviewer is waiting for: **bounded queue** with a drop policy (never let analytics OOM the host app), **privacy** (App Tracking Transparency, no PII, a privacy manifest declaring required-reason APIs), **binary size and startup cost** (an SDK that adds 200ms to launch will be removed), and **thread-safety of the public API** because you don't control your callers.

#### H5. "Design a resumable file uploader."
`commonly-circulated`.

Chunk the file (fixed size, e.g. 5MB), hash each chunk, negotiate an upload session with the server, upload chunks with per-chunk retry, persist which chunks succeeded so a relaunch resumes rather than restarts, then commit. Use a **background `URLSession`** (`URLSessionConfiguration.background`) with file-based upload tasks so the system continues transfers after the app is suspended, and implement `handleEventsForBackgroundURLSession` in the app delegate. Constraints to name: no in-memory `Data` for large files (stream from disk), cellular/Low Data Mode policy (`allowsConstrainedNetworkAccess`), and what happens if the file changes mid-upload (hash it up front).

#### H6. Also reported: "design a feed", "design a push-notification pipeline"
`commonly-circulated` [41]. Feed: cursor pagination, prefetch window, cell reuse and image prefetching, read-state sync, and how you handle an item that is deleted server-side while on screen. Push pipeline: APNs token registration and rotation, server-side fan-out, collapse IDs, notification service/content extensions, silent pushes and why iOS throttles them, and the fact that push delivery is **best-effort** — any design that treats it as a reliable transport is wrong.

---

### I. Take-home assessments and project briefs

#### I1. Monzo — modify an existing mobile codebase
`company-confirmed` [13][34]. Monzo asks candidates to **make changes in an existing Android or iOS project**, "to learn how you work in a mobile codebase", followed by a task-review call and 2–3 hours of interviews with two other iOS engineers covering real technical challenges Monzo has faced. They state they use no brainteasers or knowledge quizzes.

**What a grader looks for:** that you matched the codebase's existing conventions rather than importing your own; that you left the surrounding code better without a gratuitous rewrite; that your tests cover the change you made; and that in the review call you can explain what you *didn't* do and why.

#### I2. DoorDash — extend an Xcode project, ~5 hours
`candidate-reported` [13][14]. Extend an existing Xcode project to load and display JSON data **"in a modular way"**, with a stated budget around five hours; the follow-up interview is largely a discussion of the submission, and candidates are advised to know it inside out.

**Suggested structure.**

```
App/            – composition root, DI wiring
Networking/     – URLSession client, endpoints, decoding
Models/         – Codable domain models
Features/List/  – view + view model + tests
Features/Detail/– view + view model + tests
Core/           – image loading, error presentation
```

**What "modular" is testing:** whether the networking layer is injectable behind a protocol or closure so the view model is testable without the network; whether the JSON models are decoupled from the view models; whether adding a second screen requires touching the first.

**Grader's checklist:** it builds on a clean checkout with no manual steps; a README stating assumptions, trade-offs, and what you'd do with more time; error and empty states handled; at least the view model unit-tested; no dead code, no commented-out experiments, no 400-line view controller.

#### I3. Generic brief — "consume this public API, build list + detail, include tests"
`commonly-circulated`; take-homes typically carry a 24–96 hour deadline with a rubric [46].

**The failure mode is scope, not skill.** Candidates add a design system, a custom networking layer, and a CI pipeline, and run out of time before writing a test. Do the brief, do it cleanly, test the thing you'd be embarrassed to break, and put everything else in the README's "with more time I would…" section. Include a short accompanying message summarising your decisions — reviewers consistently report this improves the follow-up conversation. [46]

---

### J. Debugging, tooling and release

#### J1. "Memory grows and never comes back. Find it."
`commonly-circulated`; a dedicated debugging round is reported at DoorDash [14].

Method: reproduce with a repeatable loop (push/pop the screen ten times) → Xcode Memory Graph Debugger, filter to your types, look for instances that should be gone → check the retain path the graph shows you → Instruments Allocations with generation marks (mark a generation before and after the loop; anything persisting is suspect) → Leaks for true cycles, but note that **the common case is not a "leak" but unbounded caching**, which Leaks will not flag. **Red flag:** jumping to `[weak self]` edits without a reproduction.

#### J2. "Triage this crash."
`commonly-circulated`. Symbolicate (`.dSYM` matched by UUID — and know that bitcode-era and App Store-rebuilt binaries need the dSYM from the archive, not your local build), identify the thread and whether it's your frame or a framework frame, classify the signal (`EXC_BAD_ACCESS` → over-release/dangling, `SIGABRT` → assertion/exception, `EXC_RESOURCE` → memory or CPU limit, watchdog `0x8badf00d` → main-thread block at launch), then reproduce with Zombies or Address Sanitizer as appropriate. Mention Xcode Organizer and MetricKit for field crashes and hangs.

#### J3. "Accessibility and localisation — what do you actually do?"
`commonly-circulated`. Accessibility: VoiceOver labels/values/traits (not just labels), Dynamic Type support with `.dynamicTypeSize` limits rather than fixed font sizes, 44×44pt minimum hit targets, contrast, Reduce Motion honoured on animations, and testing with the Accessibility Inspector. Localisation: String Catalogs (`.xcstrings`), `AttributedString` and format-style APIs rather than manual string interpolation, pluralisation via stringsdict/catalog plural variants, RTL support via leading/trailing constraints and `.flipsForRightToLeftLayoutDirection`, and pseudo-localisation in the scheme to catch truncation. **Red flag:** treating accessibility as a post-launch task.

---

### K. Behavioural rounds — the prompts actually used

#### K1. Amazon — Leadership Principles
`candidate-reported` [15][22]. Amazon dedicates a full round to behavioural questions, mapped to named Leadership Principles: "Tell me about a time you disagreed with your manager" (Have Backbone), "a time you had to deliver with incomplete information" (Bias for Action), "a time you took on something outside your remit" (Ownership). Structure answers as STAR, keep them first-person singular, and bring metrics.

#### K2. Netflix and Spotify — culture as a graded round
`candidate-reported` [23][29]. Netflix weights culture heavily and probes judgement, candour and independent decision-making rather than "tell me about a challenge". Spotify allocates one of four final-loop hours to values. Stripe's culture round is reported as scoring clarity, ownership and user empathy. [30]

#### K3. Mid-size product companies — real trade-off prompts
`candidate-reported`, matching Monzo's stated approach of walking through real challenges [13]. Typical: "Describe a technical decision you made that turned out to be wrong. How did you find out, and what did you do?" · "Tell me about a time you had to ship something you weren't happy with." · "How did you handle a disagreement with a designer or PM about a mobile constraint?"

**Red flags across all behavioural rounds.** Answers in "we" with no personal action. Blaming a former team. No outcome or metric. A "failure" story that is secretly a success story — interviewers are explicitly listening for whether you can identify your own mistake.

---

## Grading rubrics

| Category | Strong | Borderline | Weak |
|---|---|---|---|
| **Swift language** | Reasons from semantics (identity, ownership, COW); names the exception to their own rule | Correct definitions, thin on *why* | Recites a memorised table; "structs are on the stack" |
| **Memory / ARC** | Names the exact reference path forming the cycle; picks `weak` vs `unowned` deliberately; knows the diagnostic tools | Knows `[weak self]` fixes cycles but not which reference closes them | Adds `[weak self]` everywhere or nowhere |
| **Concurrency** | Distinguishes data races from logical races; knows Swift 5→6 warning→error change; can migrate GCD→structured concurrency and say what it costs | Uses `async/await` correctly but can't explain isolation | Thinks `async` means "background"; `@unchecked Sendable` to fix build errors |
| **UIKit** | Debugs from measurement; knows lifecycle timing and layout priorities | Knows the APIs, weak on when each runs | Hard-codes frames; can't explain cell-reuse bugs |
| **SwiftUI** | Explains identity and invalidation scope; knows the `@Observable` tracking difference; treats `GeometryReader` as a last resort | Uses the wrappers correctly by habit | Can't say why `@StateObject` differs from `@ObservedObject`; `.id(UUID())` |
| **Architecture** | Argues from team size, codebase age, and testing needs; names the downside of their own preference | Advocates one pattern competently | Declares one architecture universally correct |
| **Live coding** | States invariants and complexity before coding; handles edge cases unprompted; tests the tricky path | Reaches a working solution with hints | Silent coding; no complexity analysis; no edge cases |
| **System design** | Leads with clarifying questions; names iOS-specific constraints (memory, background limits, battery, offline); states trade-offs explicitly | Produces a reasonable diagram; light on trade-offs | Draws a backend architecture with no mobile constraints |
| **Take-home** | Clean build, README of assumptions and trade-offs, tests on the risky logic, scope held | Works, but untested or over-built | Doesn't build; no tests; scope sprawl; can't defend decisions |
| **Behavioural** | First-person, specific, includes an outcome and a genuine self-critique | Structured but generic | "We" throughout; blames others; no failure story |

---

## Preparation plan (4–6 weeks)

Weighted by how often each area actually appeared across the loops evidenced above, not by how interesting it is.

**Week 1 — Concurrency (highest marginal value).** Swift 6 strict concurrency end to end: `actor`, isolation, `Sendable`, `@MainActor`, `TaskGroup`, cancellation, `AsyncStream`. Migrate one real completion-handler API in a personal project to `async/await` with cancellation. Be able to explain the 5.x-warning → 6-error change from memory. [6][7]

**Week 2 — SwiftUI state, identity and performance.** Build one screen twice: once with `ObservableObject`, once with `@Observable`, and measure the re-render difference with the SwiftUI Instruments template. Practise the identity bugs (`id: \.self`, `if/else` branch state loss) until you can spot them in someone else's code — which is exactly what an AI-assisted round will ask you to do. [8][9][10]

**Week 3 — Live coding.** LRU cache, image loader with deduplication, debounce/throttle, rate limiter, thread-safe collection — write each from scratch, out loud, in under 25 minutes. Then a daily LeetCode medium **in Swift**, because Meta/Amazon/Uber screens still contain them. [21][25]

**Week 4 — iOS system design.** One prompt per day from H1–H6, timed at 45 minutes, always opening with clarifying questions and always naming memory/background/battery/offline constraints. Record yourself; the failure mode is pacing, not knowledge. [41][44]

**Week 5 — Take-home rehearsal + framework depth.** Do a full brief (public API → list + detail → tests + README) in five hours, exactly as DoorDash frames it, then review it as a grader would. Fill remaining gaps: UIKit lifecycle and Auto Layout priorities, Core Data/SwiftData migrations, Instruments. [13][14]

**Week 6 — Behavioural and company-specific.** Six STAR stories with metrics, mapped onto Amazon's Leadership Principles and reusable elsewhere. Then read the target company's engineering blog and, in the recruiter call, ask directly: native or cross-platform, is there a take-home, and is AI permitted in the coding round. All three change how you prepare.

**Ongoing.** Keep a written list of the questions you were actually asked. Every public write-up cited here exists because someone did that.

---

## Sources

Accessed 6 August 2026 unless noted. Several publishers (Medium, Monzo, Substack, HackingWithSwift) returned HTTP 403 to automated fetching in this environment; those entries are cited from search-index summaries of the pages rather than from full-text retrieval, and are marked **[index]**.

1. "A comprehensive archive of 2023 tech layoffs," *TechCrunch*, 1 May 2024 — https://techcrunch.com/2024/05/01/a-comprehensive-archive-of-2023-tech-layoffs/ (2022 ≈164,969 across 1,186 companies; 2023 ≈262,682).
2. "Tech Layoffs: US Companies With Job Cuts In 2024, 2025 and 2026," *Crunchbase News* — https://news.crunchbase.com/startups/tech-layoffs/ ; "Tech Layoffs by Year: The Complete Chart," *Value Add VC* — https://valueaddvc.com/blog/tech-layoffs-by-year-the-complete-chart-from-2020-to-2026 **[index]**
3. "iOS Developer Salary & Hourly Rate 2026," *Lemon.io* — https://lemon.io/rate-calculator/ios-developers/ ; "iOS Developer Salary Guide 2026," *KORE1* — https://www.kore1.com/ios-developer-salary-guide/ **[index]** (vendor rate data; directional only)
4. Gabriel Peal, "Sunsetting React Native," *The Airbnb Tech Blog*, 2018 — https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a **[index]**
5. "Five years of React Native at Shopify," *Shopify Engineering*, 2025 — https://shopify.engineering/five-years-of-react-native-at-shopify **[index]** (migration complete Nov 2024; ~86% code unification; 1.8M lines removed; 99.9% crash-free)
6. "Complete concurrency enabled by default — available from Swift 6.0," *Hacking with Swift* — https://www.hackingwithswift.com/swift/6.0/concurrency **[index]**
7. Mihai Popa, "Actors, Sendable, and Strict Concurrency in Swift 6," *Medium*, 2026 — https://medium.com/@mihaipopa/interview-26-actors-sendable-and-strict-concurrency-in-swift-6-97d951daf36f **[index]**
8. Carolane Lefebvre, "Observable vs @ObservedObject in SwiftUI," *Medium* — https://carolanelefebvre.medium.com/observable-vs-observedobject-in-swiftui-whats-the-difference-5cfd2f7dfac0 **[index]**
9. shobhakartiwari, *SwiftUI-Interview-Questions*, GitHub — https://github.com/shobhakartiwari/SwiftUI-Interview-Questions
10. "How to use AI in Meta's AI-assisted coding interview," *interviewing.io* — https://interviewing.io/blog/how-to-use-ai-in-meta-s-ai-assisted-coding-interview-with-real-prompts-and-examples ; "Meta Interview Process 2026," *ClavePrep* — https://claveprep.com/blog/meta-interview-process-2026-guide **[index]** (rollout began October 2025)
11. "Google's AI-Assisted Coding Interview (2026 Guide)," *Exponent* — https://www.tryexponent.com/blog/google-ai-coding-interview ; University of Miami Career blog, 14 May 2026 — https://customcareer.miami.edu/blog/2026/05/14/googles-ai-assisted-coding-interview-2026-guide/ **[index]**
12. "Top 4 Companies That Allow AI in Tech Interviews," *LockedIn AI* — https://www.lockedinai.com/blog/companies-allowing-ai-in-interviews **[index]** (Canva June 2025; Shopify AI-snippet integration)
13. "Preparing for Mobile Interviews at Monzo," *Monzo blog* — https://monzo.com/blog/preparing-for-mobile-interviews-at-monzo **[index]** — *company-confirmed*
14. Tanishq Arora, "DoorDash iOS Interview Experience," *Medium* — https://medium.com/@ios-interview/doordash-ios-interview-experience-82fec170daa0 **[index]**
15. "Amazon iOS Engineer interview questions (2025 list)," *Prepfully* — https://prepfully.com/interview-questions/amazon/ios-engineer **[index]**
16. Duolingo, Senior iOS Software Engineer postings (NY Math team, $178K–$240K; Pittsburgh Short Form) — https://www.builtinnyc.com/company/duolingo/jobs and https://builtin.com/job/senior-ios-software-engineer/1967344 **[index]**
17. "SwiftUI vs UIKit in 2025: Which One Will Get You Hired," *Medium*; "SwiftUI vs UIKit 2026," *theswiftk.it* — https://theswiftk.it.com/blog/swiftui-vs-uikit-2026 **[index]** — **vendor/community estimates, not a documented survey**
18. "iOS 26," *Simple English Wikipedia* — https://simple.wikipedia.org/wiki/IOS_26 (announced 9 June 2025, released 15 September 2025; unified "26" versioning; Liquid Glass); "iOS 26: Everything We Know," *MacRumors* — https://www.macrumors.com/roundup/ios-26/
19. "Apple Interview Process & Timeline," *IGotAnOffer* — https://igotanoffer.com/en/advice/apple-interview-process ; "Apple Onsite Interview Loop," *SpaceComplexity* — https://spacecomplexity.ai/blog/apple-onsite-interview **[index]**
20. "Apple ICT3 Senior Software Engineer 2025 Interview Questions," *Onsites.fyi* — https://www.onsites.fyi/blog/article/apple-ict3-software-engineer-interview-questions **[index]**
21. "Meta iOS Engineer Interview Experience & Questions," *Glassdoor* — https://www.glassdoor.com/Interview/Meta-IOS-Engineer-Interview-Questions-EI_IE40772.0,4_KO5,17.htm **[index]**
22. "Amazon iOS Engineer Interview Experience & Questions," *Glassdoor* — https://www.glassdoor.com/Interview/Amazon-IOS-Engineer-Interview-Questions-EI_IE6036.0,6_KO7,19.htm **[index]**
23. "Senior Engineer's Guide to Netflix Interviews," *interviewing.io* — https://interviewing.io/guides/hiring-process/netflix ; "Netflix Interview Process & Timeline," *IGotAnOffer* — https://igotanoffer.com/en/advice/netflix-interview-process **[index]**
24. Disney Careers, "Senior iOS Engineer – SwiftUI & UIKit," New York — https://www.disneycareers.com/en/job/new-york/senior-ios-engineer-swiftui-and-uikit/391/81294826416 **[index]**
25. "Uber iOS Engineer Interview Experience & Questions," *Glassdoor* — https://www.glassdoor.com/Interview/Uber-IOS-Engineer-Interview-Questions-EI_IE575263.0,4_KO5,17.htm **[index]**
26. Tanishq Arora, "Lyft iOS Interview Questions | My Experience," *Medium* — https://medium.com/@ios-interview/lyft-ios-interview-questions-my-experience-7b96dbb52dc3 **[index]**
27. Tanishq Arora, "Airbnb iOS Interview Experience and Questions," *Medium* — https://medium.com/@ios-interview/airbnb-ios-interview-experience-and-questions-18336d8334c0 **[index]**
28. "DoorDash iOS Engineer: Exhaustive Interview Guide [2026]," *Prepfully* — https://prepfully.com/interview-guides/doordash-ios-engineer **[index]**
29. "Spotify's Interview Process & Questions," *interviewing.io* — https://interviewing.io/spotify-interview-questions ; "The Spotify Technical Interview Process in 2026," *TechScreen* — https://techscreen.app/articles/spotify-technical-interview-process-2026 **[index]**
30. "Stripe Interview Process 2026: Coding, API Design & Prep," *Ophy AI* — https://ophyai.com/blog/company-guides/stripe-interview-guide **[index]**
31. Robinhood, "Staff iOS Engineer" posting (Swift, RxSwift, UIKit, Bazel; 6+ years) — https://peerlist.io/company/robinhood/careers/staff-ios-engineer/jobh8o9a9dpglojp9fppqr6b7naq9d **[index]**
32. Robinhood, "Software Engineering Intern, iOS (2025)" — https://www.thefreshdev.com/job/software-engineering-intern-ios-2025-robinhood-2839 **[index]**
33. Revolut, "Software Engineer (iOS)" — https://standout.work/jobs/software-engineer-ios-at-revolut **[index]**
34. "Interviewing at Monzo: an overview of our interview process," *Monzo blog* — https://monzo.com/us/blog/monzo-us-blog/interviewing-at-monzo **[index]** — *company-confirmed*
35. Delivery Hero Careers — https://careers.deliveryhero.com/deliveryhero-jobs **[index]** *(careers portal; no dated iOS posting retrieved)*
36. Klarna Careers — https://www.klarna.com/careers/openings/ **[index]** *(careers portal; no dated iOS posting retrieved)*
37. Gojek Career, "Software Engineer – iOS" — https://career.gojek.com/job/software-engineer-ios-icp-37a4449852164d7a848a68f20eba69ff/ **[index]** *(posting predates the window's midpoint; treat the date as uncertain)*
38. "How to crack the Meta product architecture interview," *IGotAnOffer* — https://igotanoffer.com/en/advice/meta-product-architecture-interview **[index]**
39. Divyesh Vekariya, "The Complete Senior iOS Developer Interview Guide (2026)," *Medium* — https://dkvekariya.medium.com/the-complete-senior-ios-developer-interview-guide-2026-3ec09ab25987 **[index]**
40. "Swift 6.2 Concurrency in Practice: Default to MainActor, Escape on Purpose," *blakecrosley.com* — https://blakecrosley.com/blog/swift-6-2-concurrency-in-practice **[index]**
41. "iOS System Design Interview: A Complete Guide (2026)," *System Design Handbook* — https://www.systemdesignhandbook.com/guides/ios-system-design-interview/ ; Jacob Bartlett, "iOS System Design interviews in 2026" — https://blog.jacobstechtavern.com/p/system-design-interview **[index]**
42. Alok Upadhyay, "Build a Thread-Safe LRU Cache with Expiry," *Stackademic* — https://blog.stackademic.com/ace-your-swift-interviews-build-a-thread-safe-lru-cache-with-expiry-4ec36a9c1300 ; "DIY: LRU Cache," *Educative* — https://www.educative.io/courses/decode-the-coding-interview-swift/JPNRnv5G6lo **[index]**
43. Shobhakar Tiwari, "iOS Interview Caching Questions & Strategies," *Medium* — https://medium.com/@shobhakartiwari/ios-interview-caching-questions-strategies-78bd4b9d0544 **[index]**
44. "Apple iOS System Design Interview Expectations," *Design Gurus* — https://www.designgurus.io/answers/detail/apple-ios-system-design-interview-expectations **[index]**
45. "iOS Notes App System Design Interview Guide," *Mockingly* — https://www.mockingly.ai/blog/ios-notes-app-system-design **[index]**
46. "How to Prepare for Take-Home Assignments and Case-Based Coding Tests," *Huru* — https://huru.ai/take-home-assignment-tips-coding-case-study-interview/ ; "Take Home Assignments and the Interview Process," *DEV Community* — https://dev.to/rockarts/take-home-assignments-and-the-interview-process-4jhl **[index]**
47. dashvlas, *awesome-ios-interview*, GitHub — https://github.com/dashvlas/awesome-ios-interview (retrieved in full)
48. mukundjogi, *ios-interview*, GitHub — https://github.com/mukundjogi/ios-interview **[index]**
49. "Ultimate iOS Engineer interview guide (2026)," *Prepfully* — https://prepfully.com/interview-guides/ios-engineer **[index]**
50. "iOS Concurrency Interview Questions," *Swift Rivals* — https://swiftrivals.com/concurrency/ios-concurrency-interview-questions **[index]**

**Sourcing caveat.** Items 1–50 vary widely in reliability. Company blogs (Monzo [13][34], Shopify [5], Airbnb [4]) are primary. Job postings ([16][24][31][32][33][37]) are primary but perishable. Glassdoor, Blind and Medium write-ups ([14][21][22][25][26][27]) are single-candidate accounts, unverifiable, and frequently stale. Interview-prep vendors ([15][19][28][29][30][49]) have a commercial incentive to appear authoritative and often recycle each other's content — where they were the only available source, that is stated in the text. No content presented by any source as confidential or under NDA has been reproduced here.

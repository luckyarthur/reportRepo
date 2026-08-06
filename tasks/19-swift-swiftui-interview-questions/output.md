# Swift & SwiftUI Interview Set — Filtered Analysis and Solutions

*Derived by filtering the assessment catalogue in [`tasks/18-ios-interview-questions/output.md`](../18-ios-interview-questions/output.md) down to items whose core subject is the Swift language or the SwiftUI framework. Targets **Swift 6.x and iOS 18+**, with notes on the iOS 26 line (announced 9 June 2025, released 15 September 2025) where relevant [20]. Filtered and upgraded **6 August 2026**. All code is compile-plausible reference and **was not compiled**.*

---

## How this was filtered

**Inclusion rule.** An item is retained if the competency being tested is *Swift the language* (type system, memory model, concurrency) or *SwiftUI the framework* (state, layout, rendering, navigation, interop, testing). An item is excluded if the competency is UIKit mechanics, backend/mobile system design, tooling/release, or behaviour — even when Swift happens to be the implementation language.

**Borderline items are retained and marked `partially in scope`** with a note on which portion carried over.

| Task-18 category | Items | Retained | Excluded | Reason for exclusion |
|---|---:|---:|---:|---|
| A. Swift language & runtime | 8 | 8 | 0 | — |
| B. Concurrency | 8 | 8 | 0 | — |
| C. UIKit | 5 | 1 | 4 | Pure UIKit mechanics (lifecycle, Auto Layout, diffable data sources, scroll profiling) |
| D. SwiftUI | 7 | 7 | 0 | — |
| E. Architecture | 4 | 3 | 1 | Modularisation is a build/tooling concern |
| F. Networking & persistence | 4 | 2 | 2 | Pagination and offline sync are system design |
| G. Live coding | 6 | 5 | 1 | Two-sum / reverse-a-linked-list are language-agnostic DS&A |
| H. iOS system design | 6 | 0 | 6 | Out of scope by rule |
| I. Take-homes | 3 | 3 | 0 | Swift/SwiftUI project briefs |
| J. Debugging & release | 3 | 1 | 2 | Crash triage and localisation are tooling/release |
| K. Behavioural | 3 | 0 | 3 | Out of scope by rule |
| **Total** | **57** | **38** | **19** | |

Two retained items (B5 "fix this racy cache" and G6 "thread-safe collection") were the same question and are merged into one entry, so **38 retained items appear as 37 entries**. Seven further entries are marked **`added-for-coverage`** — general Swift/SwiftUI topics named in the filter scope but absent from task 18 — and are confined to clearly labelled subsections. **No new company attributions have been introduced.**

**Corrections applied to task-18 solutions** (three; each flagged inline where it occurs): the `AsyncStream` delegate keep-alive, the rate limiter's elapsed-time arithmetic, and the `@ObservedObject` framing in the DI entry.

---

## TL;DR

- **Concurrency is the highest-yield block.** Swift 6 turned `Sendable` and isolation violations from warnings into compile errors [1][2]; the questions that separate candidates are about *logical* races across suspension points (actor reentrancy), not about `async` syntax.
- **`@Observable` vs `ObservableObject` is the most reliably asked SwiftUI follow-up.** The graded answer is per-property read tracking versus blanket invalidation [3][4] — not "it's shorter".
- **View identity is where most SwiftUI candidates fail.** `ForEach(items, id: \.self)`, `if/else` branch state loss, and `.id(UUID())` in `body` are the three bugs interviewers plant.
- **Candidates over-index on syntax and under-index on cost.** `any P` boxes, existentials allocate, `AnyView` defeats structural diffing, `GeometryReader` fills greedily. Naming a cost unprompted is the senior signal.
- **The AI-assisted interview raises the value of reading code, not writing it.** Meta's October 2025 AI-enabled round and similar formats ask you to judge code you didn't write [5]; retain cycles, isolation violations and identity bugs are exactly what that grades.
- **The version seam is deliberately probed.** Swift 5.x → 6 and pre-/post-`@Observable` SwiftUI generate the most common follow-ups; see the cheat sheet in §11.

---

## Part A — Swift language & type system

### A1. `struct` vs `class` — when do you choose which?
**Provenance:** `commonly-circulated` · no company attribution · **Tests:** whether you reason about semantics or recite a table.

**Analysis.** "Structs are on the stack" is not reliably true — a struct captured by an escaping closure, boxed in an existential, or stored in a class lives on the heap. The real axis is **identity**: must mutation be visible to other holders? Do you need `deinit`, inheritance, or Objective-C interop?

**Solution.** Default to `struct`. Choose `class` for reference identity, resource cleanup via `deinit`, or ObjC bridging. Choose `actor` — the third option Swift 6 makes routine — for mutable reference state shared across concurrency domains. SwiftUI views must be structs because the framework rebuilds the tree constantly and that only works when construction is near-free and comparison is value-based.

**Follow-ups.** *"Does a struct always avoid heap allocation?"* No — escaping closures, existential boxes over 3 words, and storage inside reference types. *"What breaks if a struct holds a class reference?"* You get shared mutable state through the back door and lose value semantics silently.

**Red flags.** "Structs are always faster." Not noticing the class-inside-struct aliasing trap.

### A2. Implement copy-on-write for your own type
**Provenance:** `commonly-circulated` · **Tests:** value semantics as an implementation contract.

```swift
struct ByteBuffer {
    private final class Storage {
        var bytes: [UInt8]
        init(_ bytes: [UInt8]) { self.bytes = bytes }
    }
    private var storage: Storage

    init(_ bytes: [UInt8] = []) { storage = Storage(bytes) }
    var count: Int { storage.bytes.count }

    subscript(i: Int) -> UInt8 {
        get { storage.bytes[i] }
        set { ensureUnique(); storage.bytes[i] = newValue }
    }

    mutating func append(_ byte: UInt8) {
        ensureUnique()
        storage.bytes.append(byte)
    }

    private mutating func ensureUnique() {
        guard !isKnownUniquelyReferenced(&storage) else { return }
        storage = Storage(storage.bytes)
    }
}
```

**Graded details.** `isKnownUniquelyReferenced` takes `inout` and requires a **`final`** native Swift class. The copy happens on *write*, never on read or in `init`.

**Follow-ups.** *"Why `final`?"* Non-final classes risk ObjC bridging, which invalidates the uniqueness check. *"What breaks without `ensureUnique`?"* Two nominal value copies alias — the exact bug this question exists to find. *"Is `ByteBuffer` `Sendable`?"* Not automatically: it holds a mutable class. Marking it `Sendable` would be a lie; COW value types in the stdlib get there by careful `@unchecked` implementation.

**Red flags.** "`Array` already does COW so I never need this."

### A3. Optional unwrapping — and when is `!` acceptable?
**Provenance:** `commonly-circulated` · phone screen · **Tests:** production judgement.

**Solution.** `if let`/`guard let` for control flow, `??` for defaults, optional chaining for traversal, `if case let` for pattern matching. Implicitly-unwrapped optionals are legitimate for two-phase initialisation with a framework guarantee (`@IBOutlet`). Force-unwrap is defensible only when `nil` means a build-time invariant is broken and crashing is the correct response — `Bundle.main.url(forResource:)` for a shipped resource. **Never** on network- or user-derived data.

**Follow-ups.** *"`try?` vs `try!`?"* `try?` discards the error, usually a bug in disguise. *"Cost of `Optional`?"* Generally free for class references (null pointer is the `nil` case) and a tagged layout otherwise — no extra allocation.

**Red flags.** "Never force-unwrap" as dogma with no exception named. Force-unwrapping decoded JSON.

### A4 → see Part B (memory)
Retain-cycle debugging moved to §5 where it belongs.

### A5. `some Protocol` vs `any Protocol`
**Provenance:** `commonly-circulated`; reported as a rising senior question [11] · **Tests:** understanding existential boxing.

**Solution.** `some P` is an **opaque type** — one concrete type chosen by the callee, known to the compiler, statically dispatched, no box. `any P` is an **existential** — erased at runtime, dynamically dispatched, boxed (heap-allocated once past the inline buffer). Use `some` by default; use `any` only when you genuinely need heterogeneity.

```swift
func makeHeader() -> some View { Text("Hi").font(.title) }   // one concrete type
let shapes: [any Shape] = [Circle(), Rectangle()]            // genuine heterogeneity
```

**Follow-ups.** *"Protocols with associated types as `any`?"* Allowed since Swift 5.7, but the associated types are unusable until you open the existential into a generic context. *"What does SwiftUI's `body` return and why?"* `some View`, so the whole tree's type is statically known and diffing can be structural. *"`some` in parameter position?"* Since Swift 5.7 it's sugar for an unnamed generic parameter.

**Red flags.** Treating them as interchangeable spelling. Not knowing existentials allocate.

### A6. Design a type-erased wrapper
**Provenance:** `commonly-circulated` · live coding, senior.

```swift
protocol ImageLoading: Sendable {
    associatedtype Output
    func load(_ url: URL) async throws -> Output
}

struct AnyImageLoader<Output: Sendable>: ImageLoading {
    private let _load: @Sendable (URL) async throws -> Output
    init<L: ImageLoading>(_ loader: L) where L.Output == Output {
        _load = { try await loader.load($0) }
    }
    func load(_ url: URL) async throws -> Output { try await _load(url) }
}
```

**Analysis.** The technique never varies: store closures capturing the concrete instance, forward through them. The senior answer adds that you often *shouldn't* — `some`, a generic parameter, or a struct-of-closures usually reads better.

**Swift 6 note.** The erasing closure must be `@Sendable` if the wrapper crosses isolation domains, which forces the wrapped loader to be `Sendable` too — a constraint that did not exist pre-Swift 6.

**Red flags.** Reaching for `AnyX` before checking whether a generic parameter suffices.

### A7. Decode JSON where the API is inconsistent
**Provenance:** `commonly-circulated`; the **DoorDash** take-home is explicitly about loading and displaying JSON [6][7] · **Tests:** `Codable` past the happy path.

```swift
struct Item: Decodable, Identifiable, Sendable {
    let id: String
    let name: String
    let price: Decimal
    let tags: [String]

    private enum CodingKeys: String, CodingKey {
        case id, name, price = "price_cents", tags
    }

    init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let intID = try? c.decode(Int.self, forKey: .id) {
            id = String(intID)                      // API sends id as number or string
        } else {
            id = try c.decode(String.self, forKey: .id)
        }
        name  = try c.decode(String.self, forKey: .name)
        price = Decimal(try c.decode(Int.self, forKey: .price)) / 100
        tags  = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
    }
}
```

**Follow-ups.** *"One bad element shouldn't kill the list."* Wrap elements in a `FailableDecodable<T>` and `compactMap`, or iterate an `UnkeyedDecodingContainer` skipping failures. *"Dates?"* `.iso8601`, `.custom` for fractional seconds. *"Money?"* `Decimal` or integer minor units — never `Double`.

**Red flags.** `Double` for currency. Making every field optional so it "won't crash", which relocates the failure into the UI.

### A8. `throws` vs `Result` vs typed throws
**Provenance:** `commonly-circulated`.

**Solution.** In async code `throws` + `try await` is the default; `Result` existed mainly to give completion handlers a single parameter and is largely legacy. Keep `Result` when you must *store* an outcome. **Swift 6 adds typed throws** — `func f() throws(NetworkError)` — valuable at library boundaries and in embedded contexts, but over-constraining for app code, where untyped `throws` lets you add error cases without a source break.

**Follow-ups.** *"`rethrows`?"* For higher-order functions that only throw when their closure argument does. *"`any Error` vs typed?"* Untyped `throws` is sugar for `throws(any Error)`; `throws(Never)` is equivalent to non-throwing.

**Red flags.** Converting every `throws` to `Result` "for consistency". Swallowing with `try?`.

### A-extra — `added-for-coverage`
> These three are **not** from task 18. They fill scope areas the filter names (property wrappers, result builders, macros) that the source report did not cover as standalone items. No company attribution.

**A-x1. "Write a property wrapper."**

```swift
@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>

    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
    var wrappedValue: Value {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
    var projectedValue: ClosedRange<Value> { range }   // exposed as `$property`
}
```
`wrappedValue` is required; `projectedValue` is what `$` gives you — which is exactly how `@State` hands you a `Binding`. **Red flag:** not knowing that `$value` in SwiftUI *is* a projected value.

**A-x2. "How does `@ViewBuilder` work?"** It is a `@resultBuilder`: the compiler rewrites a multi-statement closure into `buildBlock(_:_:...)` calls, with `buildEither`/`buildOptional` for `if`/`else` and `buildArray` for `ForEach`-style loops. Consequences interviewers probe: the arity limit on `buildBlock` (historically 10 subviews — hence `Group`), and the fact that `if/else` produces a `_ConditionalContent` with **two distinct structural identities**, which is why state is lost across the branch (see E1).

**A-x3. "When would you write a macro?"** Swift macros (5.9+) are compile-time source generation with type checking — `@Observable` itself is one. Write one to eliminate genuinely mechanical boilerplate across many types (`@CaseDetection`, codable key generation). Do not write one to hide logic: macros are hard to debug, slow builds, and `Expand Macro` in Xcode is the only readable view of what shipped.

---

## Part B — Memory management & ARC

### B1. Find and fix the retain cycle *(task 18 item A4)*
**Provenance:** `candidate-reported` — **Meta**, memory-management questions reported in the iOS loop [8] · **Tests:** ARC mental model.

```swift
final class FeedViewModel {
    private var cancellable: AnyCancellable?
    private(set) var items: [Item] = []

    init(service: FeedService) {
        // BUG: closure captures self strongly; self owns cancellable owns closure.
        cancellable = service.updates.sink { value in self.items = value }
    }
}
```

```swift
cancellable = service.updates.sink { [weak self] value in
    guard let self else { return }
    self.items = value
}
```

**Analysis.** State the rule: a cycle exists when a strong reference path returns to its origin. `weak` when the captured object may legitimately die first; `unowned` when its lifetime is guaranteed to outlive the closure — cheaper, but a crash rather than a `nil` if you're wrong.

**Follow-ups.** *"Do all escaping closures need `[weak self]`?"* No. A `URLSession` completion handler is released after firing, so the strong capture is temporary and usually *desirable* — you want the object alive to receive the result. The cycle only exists when `self` retains the closure. *"How do you find one?"* Memory Graph Debugger, or a `deinit` that never runs. *"Does `Task { }` capture `self` strongly?"* Yes — and an unstructured `Task` stored on `self` reproduces exactly this cycle.

**Red flags.** `[weak self]` everywhere without naming the closing reference. `unowned` on a delegate.

### B2. "Memory grows and never comes back — find it" *(task 18 item J1)* — `partially in scope`
> Retained portion: the ARC/ownership diagnosis. The Instruments-workflow and crash-triage portions were excluded as tooling.

**Provenance:** `commonly-circulated`; a dedicated debugging round is reported at **DoorDash** [7].

**Method.** Reproduce with a repeatable loop (push/pop a screen ten times) → Memory Graph Debugger filtered to your types → read the retain path the graph shows → Allocations with generation marks to confirm persistence. **The key judgement:** the common cause is *not* a cycle but **unbounded caching** — a dictionary that only ever grows — and Leaks will never flag it. **Red flag:** editing in `[weak self]` before you have a reproduction.

### B-extra — `added-for-coverage`

**B-x1. "Capture lists and `@escaping`."** A capture list is evaluated **at closure creation**, not at call time — so `[value]` snapshots the value then, and `[weak self]` establishes weakness then. `@escaping` means the closure may outlive the call, which is why escaping closures capturing `self` need thought and non-escaping ones do not. In Swift 6 an `@escaping` closure crossing isolation must also be `@Sendable`, and capture-list snapshots are how you satisfy that: `[id = self.id]` captures a `Sendable` value instead of the whole object.

---

## Part C — Swift concurrency

### C1. Migrate a completion-handler API to async/await *(B1)*
**Provenance:** `commonly-circulated` · live coding.

```swift
func fetchUser(id: String) async throws -> User {
    try await withCheckedThrowingContinuation { continuation in
        fetchUser(id: id) { result in continuation.resume(with: result) }
    }
}
```

**Contract to state out loud:** resume **exactly once** — zero leaks the task forever, twice traps. `withChecked…` diagnoses misuse; `withUnsafe…` only in measured hot paths. If the callback can fire repeatedly, a continuation is the wrong tool — use `AsyncStream` (C7).

**Follow-ups.** *"Cancellation?"* `withTaskCancellationHandler`, cancelling the underlying `URLSessionTask`. *"Which thread does the resumed code run on?"* The caller's isolation domain — that's the whole point.

**Red flags.** Resuming inside a loop. Believing `async` implies a background thread; **isolation** determines the executor.

### C2. What is an actor, and why not `@MainActor` everywhere? *(B2)*
**Provenance:** `commonly-circulated`; reported as standard at Swift 6-adopting companies [1][2].

**Solution.** An `actor` is a reference type with compiler-enforced mutual exclusion over its own mutable state; cross-actor access is `async`. `@MainActor` is a *global* actor whose executor is the main thread — correct for UI state, wrong for everything else, because it serialises work onto the one thread that must stay free to render.

```swift
actor ImageCache {
    private var storage: [URL: Data] = [:]
    func data(for url: URL) -> Data? { storage[url] }
    func store(_ data: Data, for url: URL) { storage[url] = data }
}
```

**Follow-ups.** *"`nonisolated`?"* For members touching no mutable state, callable synchronously. *"Swift 6.2's default-MainActor mode?"* Newer toolchains can default a module to `@MainActor` isolation, inverting the burden so *leaving* the main actor becomes the explicit act [12]. *"Reentrancy?"* See C8.

**Red flags.** "An actor is just a serial queue." It's a serial *isolation domain* with compile-time checking and non-blocking suspension; a queue gives you neither.

### C3. `Sendable` and what changed in Swift 6 *(B3)*
**Provenance:** `commonly-circulated` [1][2] · **Tests:** whether you've actually migrated a codebase.

```swift
struct User: Sendable { let id: UUID; let name: String }        // implicit

final class Metrics: @unchecked Sendable {                      // manual proof required
    private let lock = NSLock()
    private var counts: [String: Int] = [:]
    func increment(_ key: String) {
        lock.lock(); defer { lock.unlock() }
        counts[key, default: 0] += 1
    }
}
```

**The graded fact:** in Swift 5.x these were **warnings**; Swift 6 makes them **compile errors** [1]. Migration is incremental — `SWIFT_STRICT_CONCURRENCY = targeted`, module by module, then `complete`, then the Swift 6 language mode.

**Follow-ups.** *"`@Sendable` closure?"* It may capture only `Sendable` values. *"Cheapest way to silence the error?"* `@unchecked Sendable` — and the most dangerous, because it moves the guarantee from the compiler to you.

**Red flags.** Blanket `@unchecked Sendable` to green a build. Not knowing the warning→error change, which *is* the question.

### C4. Fetch N resources concurrently, cancel cleanly, preserve order *(B4)*
**Provenance:** `commonly-circulated`.

```swift
func loadAll(_ urls: [URL]) async throws -> [Data] {
    try await withThrowingTaskGroup(of: (Int, Data).self) { group in
        for (i, url) in urls.enumerated() {
            group.addTask {
                try Task.checkCancellation()
                let (data, _) = try await URLSession.shared.data(from: url)
                return (i, data)
            }
        }
        var results = [Data?](repeating: nil, count: urls.count)
        for try await (i, data) in group { results[i] = data }
        return results.compactMap { $0 }
    }
}
```

**Graded points.** A group yields in *completion* order — re-key by index if order matters. A throwing child cancels the group. Cancellation is cooperative, so CPU loops need explicit `Task.checkCancellation()`.

**Follow-ups.** *"Cap at 4 in flight?"* Seed 4 tasks, add one more each time you consume a result. *"`async let` vs `TaskGroup`?"* `async let` for a fixed, small, heterogeneous set known at compile time; `TaskGroup` for a dynamic homogeneous collection.

**Red flags.** An unbounded group over 10,000 URLs.

### C5. Fix this racy cache — three ways *(B5, merged with G6 "thread-safe collection")*
**Provenance:** `commonly-circulated`.

```swift
final class Cache {                       // racy
    private var storage: [String: Data] = [:]
    func value(_ k: String) -> Data? { storage[k] }
    func set(_ v: Data, _ k: String) { storage[k] = v }
}
```

1. **Actor** — modern default; callers become `async`.
2. **Concurrent queue + `.barrier` on writes** — correct, and what most legacy code does.
3. **Lock** — lowest overhead, keeps the synchronous API:

```swift
final class Cache: @unchecked Sendable {
    private let lock = OSAllocatedUnfairLock()
    private var storage: [String: Data] = [:]
    func value(_ k: String) -> Data? { lock.withLock { storage[k] } }
    func set(_ v: Data, _ k: String) { lock.withLock { storage[k] = v } }
}
```

**Follow-up: "Why would you *not* use the actor?"** Because it forces every caller to become `async`, cascading through a synchronous codebase — a real migration cost, and the honest answer that distinguishes a senior candidate.

### C6. Where does `@MainActor` belong? *(B6)*
**Provenance:** `commonly-circulated`.

On the type owning UI-facing state — view models, `@Observable` models feeding SwiftUI — annotated at the **type**, not per method. Never on a repository or networking layer. Inside a `@MainActor` type, `await`ing a non-isolated async function hops off and back automatically.

**Red flags.** `DispatchQueue.main.async` inside an `async` function. `@MainActor` on a persistence layer.

### C7. Turn a delegate callback into an `AsyncSequence` *(B7)*
**Provenance:** `commonly-circulated` · live coding, senior.

> **Correction to task 18.** That version kept the delegate alive with a stray `_ = delegate` inside `onTermination`, which is fragile and easy to optimise away conceptually. The delegate must be held by an explicit strong reference for the stream's lifetime.

```swift
func locations() -> AsyncStream<CLLocation> {
    AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
        let manager = CLLocationManager()
        let delegate = LocationDelegate { continuation.yield($0) }
        manager.delegate = delegate                   // CLLocationManager holds delegate weakly…
        let retained = delegate                       // …so keep an explicit strong reference
        manager.startUpdatingLocation()
        continuation.onTermination = { _ in
            manager.stopUpdatingLocation()
            withExtendedLifetime(retained) { }        // released only after teardown
        }
    }
}
```

**Graded details.** The **buffering policy** — unbounded buffering on a high-frequency source is a slow-motion memory leak — and `onTermination` for teardown when the consumer cancels. Use `AsyncThrowingStream` when the source can fail.

### C8. Actor reentrancy — what's wrong here? *(B8)*
**Provenance:** `commonly-circulated` · senior domain round.

```swift
actor TokenProvider {
    private var token: Token?
    func token() async throws -> Token {
        if let token, !token.isExpired { return token }
        let fresh = try await network.refresh()   // suspension: N callers => N refreshes
        self.token = fresh
        return fresh
    }
}
```

```swift
actor TokenProvider {
    private enum State { case idle, refreshing(Task<Token, Error>), valid(Token) }
    private var state: State = .idle

    func token() async throws -> Token {
        switch state {
        case .valid(let t) where !t.isExpired: return t
        case .refreshing(let task):            return try await task.value
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

**The point.** Actor isolation prevents **data races**, not **logical races across suspension points**. Every assumption made before an `await` may be false after it. This is the single most discriminating concurrency question in the set.

### C9. Retry with exponential backoff and jitter *(F1)* — `partially in scope`
> Retained portion: the structured-concurrency implementation (`Task.sleep`, cancellation, `Duration`). The HTTP-semantics portion (idempotency keys, `Retry-After`) belongs to networking and is summarised only.

**Provenance:** `commonly-circulated`.

```swift
func withRetry<T: Sendable>(
    maxAttempts: Int = 3,
    isRetryable: (any Error) -> Bool,
    operation: () async throws -> T
) async throws -> T {
    var attempt = 0
    while true {
        do { return try await operation() }
        catch {
            attempt += 1
            guard attempt < maxAttempts, isRetryable(error) else { throw error }
            try Task.checkCancellation()
            let backoff = pow(2.0, Double(attempt)) + Double.random(in: 0...1)
            try await Task.sleep(for: .seconds(backoff))
        }
    }
}
```

**Swift-specific graded points.** `try Task.sleep` propagates `CancellationError` — the loop must not swallow it. `T: Sendable` is required once the operation crosses isolation. Jitter exists so recovering servers aren't stampeded. Never retry a non-idempotent request without an idempotency key.

### C10. Thread-safe LRU cache *(G1)* — `partially in scope`
> Retained portion: the Swift-specific concurrency and ARC concerns (actor wrapping, node ownership). The O(1) hash-map-plus-doubly-linked-list data structure itself is language-agnostic and is stated without derivation.

**Provenance:** `commonly-circulated`, very high frequency [13].

**Structure.** Dictionary for O(1) lookup + doubly-linked list for O(1) recency reordering; every map entry is a live list node.

**Swift-specific concerns the interviewer is actually after.**

```swift
actor LRUCache<Key: Hashable & Sendable, Value: Sendable> {
    private final class Node {
        let key: Key; var value: Value
        var prev: Node?
        var next: Node?                    // strong forward, strong back — see note
        init(_ k: Key, _ v: Value) { key = k; value = v }
    }
    private var map: [Key: Node] = [:]
    private var head: Node?, tail: Node?
    private let capacity: Int
    init(capacity: Int) { self.capacity = max(1, capacity) }
    // value(forKey:) / set(_:forKey:) as in the standard solution, plus:
    // on eviction, clear node.prev and node.next before dropping it from `map`.
}
```

**The ARC point.** A doubly-linked list with strong `prev` **and** strong `next` is a cycle between every adjacent pair. It is survivable here only because eviction explicitly nils both pointers — say this out loud. The alternative is `weak var prev`, which costs side-table overhead on every node. Either answer is acceptable; *not noticing* is not.

**Follow-ups.** *"Why not `NSCache`?"* It's thread-safe and purges under memory pressure, but gives no eviction-order guarantee and no TTL. It is the right production answer for images and the wrong answer when the interviewer wants the data structure — say both. *"TTL?"* Per-node expiry, evicted lazily on read plus a periodic sweep.

### C11. Image loader with in-flight deduplication *(G2)*
**Provenance:** `commonly-circulated`; overlaps the image-caching design theme [14].

```swift
actor ImageLoader {
    private enum Entry { case inFlight(Task<UIImage, Error>), ready(UIImage) }
    private var cache: [URL: Entry] = [:]

    func image(for url: URL) async throws -> UIImage {
        switch cache[url] {
        case .ready(let image):    return image
        case .inFlight(let task):  return try await task.value      // dedup
        case nil:                  break
        }
        let task = Task<UIImage, Error> {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
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
            cache[url] = nil            // never cache the failure
            throw error
        }
    }
}
```

**Graded points.** Deduplication (ten cells asking for one avatar issue one request); `preparingForDisplay()` decodes off the main thread; failures are not cached; an unbounded dictionary is a leak — production wants `NSCache` plus a disk layer.

**Follow-up.** *"Why is the actor essential here?"* The check-then-insert of the in-flight task is a read-modify-write on shared state. Without isolation, two callers both see `nil` and both start a request.

### C12. Debounce and throttle *(G3)*
**Provenance:** `commonly-circulated`.

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

**The distinction candidates confuse.** Debounce fires **once after input goes quiet** (search fields). Throttle fires **at most once per interval regardless** (scroll telemetry). Naming which one a search box needs is half the grade. Combine equivalents: `.debounce(for:scheduler:)` and `.throttle(for:scheduler:latest:)`.

**SwiftUI-native alternative worth mentioning:** `.task(id: query) { try? await Task.sleep(...); await search() }` — the modifier cancels and restarts the task whenever `id` changes, which *is* a debounce with no extra type.

### C13. Token-bucket rate limiter *(G4)*
**Provenance:** `commonly-circulated` · live coding, senior.

> **Correction to task 18.** That version decomposed `Duration` into `components.seconds` + `attoseconds / 1e18` by hand, which is both awkward and lossy-looking. Use a `Duration` → `TimeInterval` conversion helper, and store the clock rather than constructing a new one inside `refill`.

```swift
actor RateLimiter {
    private let capacity: Double
    private let refillPerSecond: Double
    private let clock: ContinuousClock
    private var tokens: Double
    private var lastRefill: ContinuousClock.Instant

    init(capacity: Double, refillPerSecond: Double, clock: ContinuousClock = .init()) {
        self.capacity = capacity
        self.refillPerSecond = refillPerSecond
        self.clock = clock
        self.tokens = capacity
        self.lastRefill = clock.now
    }

    func acquire(_ cost: Double = 1) async throws {
        while true {
            refill()
            if tokens >= cost { tokens -= cost; return }
            let deficit = cost - tokens
            try await Task.sleep(for: .seconds(deficit / refillPerSecond))
        }
    }

    private func refill() {
        let now = clock.now
        let elapsed = lastRefill.duration(to: now).seconds
        tokens = min(capacity, tokens + elapsed * refillPerSecond)
        lastRefill = now
    }
}

private extension Duration {
    var seconds: Double {
        let (s, atto) = components
        return Double(s) + Double(atto) * 1e-18
    }
}
```

**Graded points.** `ContinuousClock`, not `Date` — wall-clock time jumps, monotonic time doesn't. Capacity is the burst allowance. Injecting the clock makes it testable. Honest caveat: loop-and-sleep is starvation-prone under contention; a production version queues waiters FIFO.

### C14. Cancel in-flight work when the item changes *(C3, recast)* — `partially in scope`
> Retained portion: the `Task` cancellation and identity-check pattern. The UIKit `prepareForReuse`/cell-dequeue mechanics were excluded; the SwiftUI equivalent is given instead.

**Provenance:** `candidate-reported` pattern; a debugging round is reported at **DoorDash** [7].

**The bug.** An async load completes after the view has been reassigned to different data, and the stale result lands on the wrong row.

**SwiftUI solution** — `.task(id:)` cancels and restarts automatically, and the identity check is structural rather than manual:

```swift
struct ItemRow: View {
    let item: Item
    @State private var image: UIImage?

    var body: some View {
        content
            .task(id: item.id) {                 // cancelled + restarted when id changes
                image = nil
                image = try? await loader.image(for: item.imageURL)
            }
    }
}
```

**Follow-up.** *"Why is `.task(id:)` better than `.onAppear` + a manual `Task`?"* `.onAppear` doesn't cancel on disappear and doesn't re-run on identity change; you'd have to reimplement both. **Red flag:** assigning an async result without any staleness check in the manual version.

---

## Part D — SwiftUI state & data flow

### D1. `@State` / `@Binding` / `@StateObject` / `@ObservedObject` / `@EnvironmentObject` / `@Environment` *(D1)*
**Provenance:** `commonly-circulated` [3][4] · every SwiftUI screen.

| Wrapper | Owns? | Use for | Status in 2026 |
|---|---|---|---|
| `@State` | Yes | Value state private to the view — **and** ownership of an `@Observable` object | Current |
| `@Binding` | No | Two-way handle to ancestor-owned state | Current |
| `@StateObject` | Yes | An `ObservableObject` the view creates | Legacy path |
| `@ObservedObject` | No | An `ObservableObject` passed in | Legacy path |
| `@EnvironmentObject` | No | An `ObservableObject` from the environment | Legacy path |
| `@Environment` | No | Environment values **and** `@Observable` objects via `.environment(_:)` | Current |

**The graded distinction.** SwiftUI recreates the view struct constantly. `@StateObject` initialises the object once for the view's lifetime; an `@ObservedObject` constructed inline is rebuilt on every re-render — the classic "my view model keeps resetting" bug.

**Red flags.** `@ObservedObject var vm = ViewModel()`. Not knowing that with `@Observable`, ownership is plain `@State`.

### D2. `@Observable` vs `ObservableObject` — what actually changed? *(D2)*
**Provenance:** `commonly-circulated`, high frequency [3][4] · **the most reliably asked SwiftUI follow-up.**

**Solution.** With `ObservableObject`, any `@Published` mutation invalidates **every** observing view. With `@Observable` (Observation, iOS 17+), SwiftUI records **which properties each view read during `body`** and invalidates only views that read the property that changed.

```swift
@Observable
final class CartModel {
    var items: [Item] = []
    var promoCode: String = ""
    var total: Decimal { items.reduce(0) { $0 + $1.price } }
}

struct CartView: View {
    @State private var model = CartModel()          // ownership: @State, not @StateObject
    var body: some View {
        VStack {
            TotalLabel(model: model)                // plain let — no wrapper needed
            TextField("Promo", text: $model.promoCode)
        }
        .environment(model)                         // not .environmentObject
    }
}

struct TotalLabel: View {
    let model: CartModel
    var body: some View { Text(model.total, format: .currency(code: "USD")) }
    // Reads only items/total ⇒ typing in the promo field does NOT re-render this.
}
```

**Migration map.** `@StateObject` → `@State` · `@ObservedObject` → plain `let` · `@EnvironmentObject` → `@Environment` · `.environmentObject(_:)` → `.environment(_:)` · `@Published` → delete it.

**Follow-ups.** *"Can you mix them?"* Technically yes; in practice don't — the invalidation semantics differ and the result is hard to reason about [4]. *"Which does SwiftData require?"* `@Observable`. *"Outside SwiftUI?"* `withObservationTracking(_:onChange:)` gives the same tracking in non-UI code. *"Does `$model.promoCode` still work?"* Yes — `@Bindable` (or `@State`) projects bindings from an `@Observable` object.

**Red flags.** "It's just a shorter `ObservableObject`." Inability to state the per-property tracking difference — which is the entire question.

### D3. MVVM, TCA, and where SwiftUI actually pushes you *(E1)* — `partially in scope`
> Retained portion: the Swift/SwiftUI mechanics — MVVM with `@Observable`, and why the framework's data flow shapes the choice. VIPER and the UIKit-era comparison were excluded.

**Provenance:** `candidate-reported`; architecture discussion is an explicit stage at **Uber**, and **Monzo** asks candidates to design solutions to real problems [6].

**Analysis.** There is no single correct answer and interviewers who think there is are testing conformity. Argue from constraints.

- **MVVM + `@Observable`** — current default: a `@MainActor @Observable` model per screen, `@State` ownership, constructor-injected dependencies. Cheap, testable, no third party.
- **TCA** — exhaustive state modelling, time-travel debugging, genuinely excellent testability; costs a steep learning curve, compile times, and a hard third-party dependency. Defensible in a large team with strong conventions, expensive in a small one.
- **Plain SwiftUI (no view model)** — for genuinely simple screens, `@State` plus a `.task` is not a sin, and SwiftUI's own APIs are designed for it.

**Contested, and say so:** whether view models belong in SwiftUI at all is an open community argument — one camp holds that `View` *is* the view model and a separate object duplicates SwiftUI's own state machinery. Present the trade-off; don't assert a winner.

**Follow-ups.** *"How do you keep MVVM from becoming a Massive View Model?"* Formatting into the view, side effects into services, split by screen region. *"Where does navigation live?"* A router in the environment, so models don't import SwiftUI.

**Red flags.** Declaring one architecture universally correct. Unable to name a downside of your own preference.

### D4. How do you inject dependencies? *(E2)* — `partially in scope`
> Retained portion: the Swift mechanics (struct-of-closures, `Sendable`) and the SwiftUI mechanism (`@Environment`). Module-boundary and build-graph concerns were excluded.
>
> **Correction to task 18.** That entry described `@Environment` only for "cross-cutting SwiftUI dependencies"; with `@Observable` it is now also the standard replacement for `@EnvironmentObject`, which is worth stating explicitly.

**Provenance:** `commonly-circulated`.

```swift
struct UserService: Sendable {
    var fetch: @Sendable (User.ID) async throws -> User
}
extension UserService {
    static let live = UserService { id in try await api.get("/users/\(id)") }
    static func stub(_ user: User) -> UserService { UserService { _ in user } }
}

// SwiftUI injection
private struct UserServiceKey: EnvironmentKey { static let defaultValue = UserService.live }
extension EnvironmentValues {
    var userService: UserService {
        get { self[UserServiceKey.self] }
        set { self[UserServiceKey.self] = newValue }
    }
}
```

**Analysis.** Constructor injection by default — explicit, testable, no magic. A **struct of closures** beats a protocol in Swift because it is stubbable inline with no conformance ceremony and satisfies `Sendable` naturally. `@Environment` for cross-cutting values and for `@Observable` objects.

**Follow-up.** *"`@Entry` macro?"* Recent SwiftUI provides `@Entry` to declare an environment value without the `EnvironmentKey` boilerplate above — worth naming.

**Red flags.** A global singleton resolved by type at runtime: it converts compile-time errors into runtime crashes and makes parallel tests flaky.

---

## Part E — SwiftUI layout, rendering & performance

### E1. Why does my list animate wrongly / lose state on update? *(D3)*
**Provenance:** `commonly-circulated` · **Tests:** view identity. **The most common SwiftUI bug interviewers plant.**

**Analysis.** SwiftUI identifies views **structurally** (position in the tree) and **explicitly** (`.id()`, `ForEach` identifiers). Two failure modes:

1. `ForEach(items, id: \.self)` on a value type — the identifier changes with the content, so an edit reads as delete + insert and state is lost.
2. `if/else` produces `_ConditionalContent` with two **different** structural identities, so `@State` does not survive the branch (see A-x2).

```swift
ForEach(items, id: \.self) { ItemRow(item: $0) }   // ✗ identity == contents
ForEach(items) { ItemRow(item: $0) }               // ✓ Item: Identifiable, stable id
ContentView().id(selectedTab)                      // ✓ deliberate reset
```

**Follow-ups.** *"How do you deliberately reset a subtree's state?"* Change its `.id()`. *"When does `.id()` hurt?"* `.id(UUID())` inside `body` mints a new identity every render, destroying and recreating the subtree every frame.

**Red flags.** `id: \.self` on a mutable model. `.id(UUID())`.

### E2. Explain the SwiftUI layout system *(D4)*
**Provenance:** `commonly-circulated`.

**Three steps, one sentence each:** the parent **proposes** a size; the child **chooses** its own size; the parent **places** the child. Children are never forced. `.frame(width:height:)` does not resize the child — it inserts a wrapper that proposes that size and centres the child inside it. `.fixedSize()` tells the child to ignore the proposal and use its ideal size. Layout priority decides which sibling wins scarce space. Since iOS 16 the `Layout` protocol (`sizeThatFits` / `placeSubviews`) lets you write your own.

**Follow-ups.** *"Text truncating inside an `HStack`?"* The stack divided space by priority and `Text` accepted a narrower proposal — raise `.layoutPriority` or use `.fixedSize(horizontal: false, vertical: true)`. *"When is `GeometryReader` wrong?"* Almost always as an outer container: it accepts the full proposal and fills greedily, breaking parent sizing. Prefer `.containerRelativeFrame`, `ViewThatFits`, or a preference.

**Red flags.** Believing `.frame` sets the child's size.

### E3. Measure a child's size and act on it in the parent *(D5)*
**Provenance:** `commonly-circulated` · live coding, senior.

**iOS 18+ (preferred):**

```swift
struct HeaderView: View {
    @State private var width: CGFloat = 0
    var body: some View {
        Text("Title")
            .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
    }
}
```

**Back-deployment (`PreferenceKey`):**

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

**Graded points.** Preferences flow **child → parent**; the environment flows parent → child. The `GeometryReader` belongs in a `.background`, where it takes the size of the thing it measures rather than dictating it. **Red flag:** a feedback loop where the measured value changes the layout that produced it.

### E4. My SwiftUI list stutters — what do you check? *(D6)*
**Provenance:** `commonly-circulated`.

In order:
1. **Is `body` doing work?** Sorting, filtering, or constructing a `DateFormatter` in `body` runs on every render — hoist it. `body` must be cheap and pure.
2. **Is the invalidation scope too wide?** An `ObservableObject` that redraws the whole screen on any change — split the model or migrate to `@Observable` (D2).
3. **`List` vs `LazyVStack`.** `List` recycles rows; `LazyVStack` only defers creation and never releases. For thousands of rows, `List`.
4. **`AnyView`** erases type information and defeats structural diffing — use `@ViewBuilder` or `Group`.
5. **Measure** with the SwiftUI Instruments template (view body counts) before changing anything.

**Red flags.** Blaming SwiftUI before identifying which bodies re-run.

---

## Part F — SwiftUI navigation, interop & testing

### F1. Navigation: `NavigationStack`, deep links, state restoration *(D7)*
**Provenance:** `commonly-circulated`.

```swift
enum Route: Hashable, Codable { case item(Item.ID), settings, profile(User.ID) }

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
        .onOpenURL { router.path = Route.parse($0) }
    }
}
```

**Why this beats the old model.** The path is **data you own**: a deep link is "replace the array", pop-to-root is `path.removeAll()`, and state restoration is `Codable` on the path. `NavigationView` is deprecated; `NavigationSplitView` covers multi-column.

**Follow-ups.** *"`navigationDestination` inside a `List` row?"* Register it once at the stack level, not per row — per-row registration is a common source of "destination not found" bugs. *"Sheets?"* `.sheet(item:)` with an `Identifiable` payload, not a bag of booleans.

**Red flags.** A boolean `isPresented` per screen, which cannot express arbitrary deep links.

### F2. Make this view model testable — and test it *(E4)*
**Provenance:** `commonly-circulated` · live coding.

```swift
@MainActor @Observable
final class SearchViewModel {
    private(set) var results: [Item] = []
    private(set) var isLoading = false
    private let search: @Sendable (String) async throws -> [Item]
    private let clock: any Clock<Duration>
    private var task: Task<Void, Never>?

    init(search: @escaping @Sendable (String) async throws -> [Item],
         clock: any Clock<Duration> = ContinuousClock()) {
        self.search = search
        self.clock = clock
    }

    func query(_ text: String) {
        task?.cancel()
        task = Task {
            isLoading = true
            defer { isLoading = false }
            try? await clock.sleep(for: .milliseconds(300))   // debounce
            guard !Task.isCancelled else { return }
            results = (try? await search(text)) ?? []
        }
    }

    func settle() async { await task?.value }                 // deterministic test hook
}

@MainActor
@Test func searchPopulatesResults() async {
    let vm = SearchViewModel(search: { _ in [Item.fixture] }, clock: ImmediateClock())
    vm.query("swift")
    await vm.settle()
    #expect(vm.results.count == 1)
}
```

> **Correction to task 18.** That version's test slept for 400ms and asserted afterwards. Sleeping tests are the single largest source of CI flakiness; the fixed version injects the clock and exposes `settle()` so the test awaits the actual task.

**Follow-ups.** *"Swift Testing vs XCTest?"* `@Test`/`#expect` (Swift Testing) is the current direction: parallel by default, value-based expectations, parameterised tests. XCTest remains required for UI tests and performance tests. *"How do you test the SwiftUI view itself?"* Snapshot tests for layout regressions, and keep logic out of `body` so it doesn't need a view to test.

### F-extra — `added-for-coverage`
> Three interop/testing topics named in the filter scope that task 18 did not carry as standalone items. No company attribution.

**F-x1. "Bridge UIKit into SwiftUI."**

```swift
struct TextViewRepresentable: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        return view
    }
    func updateUIView(_ view: UITextView, context: Context) {
        if view.text != text { view.text = text }        // guard against update loops
    }
    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }

    final class Coordinator: NSObject, UITextViewDelegate {
        private let text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        func textViewDidChange(_ textView: UITextView) { text.wrappedValue = textView.text }
    }
}
```
**Graded points.** `makeUIView` runs once; `updateUIView` runs on every relevant state change — guard against writing a value you just received, or you get an infinite update loop. The `Coordinator` is where delegates and targets live. Going the other way, `UIHostingController` embeds SwiftUI in UIKit; on recent OSes its `sizingOptions` handles intrinsic content size, which older code had to compute manually.

**F-x2. "Accessibility in SwiftUI."** `.accessibilityLabel/Value/Hint/Traits`; `.accessibilityElement(children: .combine)` to merge a decorative stack into one element; `.accessibilityHidden(true)` for purely decorative views; Dynamic Type via semantic fonts with `.dynamicTypeSize(...upTo:)` limits rather than fixed point sizes; `@Environment(\.accessibilityReduceMotion)` honoured on animations. **Red flag:** labelling an icon-only button with nothing, so VoiceOver reads "button".

**F-x3. "Previews and testability."** `#Preview` macro with injected stub dependencies is the fastest feedback loop in SwiftUI, and a view that can't be previewed usually can't be tested either — both symptoms of a view reaching for a singleton instead of taking its dependencies. Previews are not a substitute for tests: use them for layout iteration, snapshot tests for regression.

---

## Part G — Swift/SwiftUI take-home briefs & project assessments

### G1. Monzo — modify an existing mobile codebase *(I1)* — `partially in scope`
> Retained portion: the Swift-in-production assessment. The Android track and the non-technical stages were excluded.

**Provenance:** `company-confirmed` — **Monzo** [6][10].

**The brief.** Make changes to an existing iOS project, "to learn how you work in a mobile codebase", followed by a task-review call, then 2–3 hours of interviews with two other iOS engineers covering real technical challenges Monzo has faced and your experience **using Swift in production**. Monzo states they use no brainteasers or knowledge quizzes.

**Suggested approach.** Read before writing; match the codebase's existing conventions rather than importing your own; make the smallest change that fully solves the problem; add tests for the change you made.

| Grading dimension | Strong | Weak |
|---|---|---|
| Conventions | Matches existing idioms and file layout | Imports a personal architecture |
| Scope | Smallest complete change | Opportunistic refactor of unrelated code |
| Tests | Covers the new behaviour and one edge case | None, or trivially green |
| Review call | Can explain what you *didn't* do and why | Can't justify a decision in your own diff |

### G2. DoorDash — extend an Xcode project, ~5 hours *(I2)*
**Provenance:** `candidate-reported` — **DoorDash** [6][7][9].

**The brief.** Extend an existing Xcode project to load and display JSON data **"in a modular way"**, budgeted at roughly five hours; the follow-up interview is largely a defence of the submission, and candidates are advised to know it inside out.

**Suggested architecture.**

```
App/             composition root; wires live dependencies
Networking/      URLSession client, endpoints, decoding (see A7)
Models/          Codable domain models, Sendable
Features/List/   ListView + @Observable ListModel + tests
Features/Detail/ DetailView + @Observable DetailModel + tests
Core/            image loading (C11), error presentation
```

**What "modular" is actually testing.** Is networking injectable behind a closure or protocol so the model is testable without the network (D4)? Are JSON models decoupled from view state? Does adding a second screen require touching the first?

| Grading dimension | Strong | Borderline | Weak |
|---|---|---|---|
| Builds | Clean checkout, no manual steps | Needs a README workaround | Doesn't compile |
| Modularity | Dependencies injected; layers independently testable | Layers separate but coupled by concrete types | Networking called from `body` |
| Tests | View model + decoding, including a failure path | Happy path only | None |
| States | Loading / empty / error all handled | Loading only | Spinner forever on failure |
| README | Assumptions, trade-offs, "with more time…" | Build steps only | Absent |
| Defence | Explains every decision and its alternative | Explains most | Can't account for own code |

### G3. Generic brief — "consume this public API, build list + detail, add tests" *(I3)*
**Provenance:** `commonly-circulated`; take-homes typically carry a 24–96 hour deadline with a rubric [15].

**The failure mode is scope, not skill.** Candidates build a design system, a bespoke networking layer, and a CI pipeline, then run out of time before the first test. Do the brief; do it cleanly; test what you'd be embarrassed to break; put everything else in "with more time I would…". Send a short note summarising your decisions — reviewers consistently report it improves the follow-up [15].

**Minimum viable submission in modern Swift:** `NavigationStack` with value-based routing (F1), `@Observable` models (D2), `async/await` networking with typed decoding (A7, C1), `.task(id:)` for load and cancellation (C14), loading/empty/error states, and two tests — one decoding, one view-model.

### G4. Persistence choice in a take-home *(F4)* — `partially in scope`
> Retained portion: the SwiftData / `@Observable` / macro seam. The Core Data concurrency model, Realm, GRDB, and migration strategy were excluded as framework/infrastructure topics.

**Provenance:** `commonly-circulated`.

**The Swift-relevant answer.** SwiftData's `@Model` is a macro that makes the type observable **through the same Observation mechanism as `@Observable`** — which is why SwiftData requires `@Observable` and does not work with `ObservableObject`. In SwiftUI, `@Query` fetches and re-renders reactively with no view model in between.

```swift
@Model final class Note {
    var title: String
    var body: String
    var updatedAt: Date
    init(title: String, body: String, updatedAt: Date = .now) {
        self.title = title; self.body = body; self.updatedAt = updatedAt
    }
}

struct NotesList: View {
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]
    @Environment(\.modelContext) private var context
    var body: some View {
        List(notes) { NoteRow(note: $0) }
    }
}
```

**Follow-up.** *"When would you not use SwiftData in a take-home?"* When the brief implies complex migrations or very large datasets, where Core Data's or SQLite's explicit control is worth the verbosity. Say the trade-off; don't declare a winner.

---

## Version-shift cheat sheet

The seam interviewers probe most often. Left column is the answer that *used* to be right.

| Topic | Swift 5.x / pre-Observation | Swift 6 / iOS 18+ | Why they ask |
|---|---|---|---|
| `Sendable` violation | Warning | **Compile error** [1] | Tests whether you've migrated real code, not read a blog |
| Concurrency opt-in | `-strict-concurrency=targeted`, opt-in | Complete checking is the default in Swift 6 language mode [1] | Migration strategy question |
| Global mutable state | `var shared = …` compiles | Error unless `let`, `@MainActor`, or `nonisolated(unsafe)` | Singleton refactoring |
| Main-thread hop | `DispatchQueue.main.async` | `@MainActor` on the type; `await` hops automatically | Instant tell for stale knowledge |
| Default isolation | Nonisolated by default | Swift 6.2 modules may default to `@MainActor` [12] | Newest seam; few candidates know it |
| Background work | `DispatchQueue.global().async` | `Task.detached` sparingly; prefer structured `TaskGroup` | Structured vs unstructured concurrency |
| Typed errors | `throws` only | `throws(SomeError)` available | Library-design judgement |
| Object observation | `ObservableObject` + `@Published` | `@Observable`, per-property tracking [3] | The highest-frequency SwiftUI follow-up |
| Owning a model object | `@StateObject` | `@State` | Immediate signal of which era you learned in |
| Passing a model down | `@ObservedObject` | plain `let` | Same |
| Environment objects | `@EnvironmentObject` / `.environmentObject` | `@Environment` / `.environment` | Same |
| Bindings to a model | `$viewModel.field` via `@ObservedObject` | `@Bindable` (or `@State`) on an `@Observable` | Trips up mid-migration candidates |
| Navigation | `NavigationView` + `NavigationLink(isActive:)` | `NavigationStack(path:)`, value-based | `NavigationView` is deprecated |
| Measuring a child | `GeometryReader` + `PreferenceKey` | `onGeometryChange(for:of:action:)` | Tests whether you track new APIs |
| Environment keys | `EnvironmentKey` conformance + extension | `@Entry` macro | Small, but a good recency check |
| Persistence in SwiftUI | Core Data + `@FetchRequest` | SwiftData `@Model` + `@Query` (built on Observation) | Ties the macro and observation stories together |
| Tests | XCTest, `XCTAssert` | Swift Testing `@Test` / `#expect` | XCTest still required for UI tests |
| Async in tests | Expectations + timeouts | `async` test functions; inject a `Clock` | Flaky-test discussion |

---

## Quick-reference index

| # | Item | Category | Companies | Provenance | Difficulty |
|---|---|---|---|---|---|
| A1 | `struct` vs `class` (vs `actor`) | Swift types | — | commonly-circulated | Junior |
| A2 | Implement copy-on-write | Swift types | — | commonly-circulated | Senior |
| A3 | Optionals and when `!` is acceptable | Swift types | — | commonly-circulated | Junior |
| A5 | `some` vs `any` | Swift types | — | commonly-circulated | Senior |
| A6 | Type-erased wrapper | Swift generics | — | commonly-circulated | Senior |
| A7 | `Codable` with an inconsistent API | Swift types | DoorDash (take-home) | commonly-circulated | Mid |
| A8 | `throws` / `Result` / typed throws | Swift errors | — | commonly-circulated | Mid |
| A-x1 | Write a property wrapper | Swift types | — | added-for-coverage | Mid |
| A-x2 | How `@ViewBuilder` works | Result builders | — | added-for-coverage | Senior |
| A-x3 | When to write a macro | Macros | — | added-for-coverage | Senior |
| B1 | Find and fix the retain cycle | ARC | Meta | candidate-reported | Mid |
| B2 | Diagnose unbounded memory growth | ARC | DoorDash | commonly-circulated *(partial)* | Senior |
| B-x1 | Capture lists and `@escaping` | ARC | — | added-for-coverage | Mid |
| C1 | Completion handler → async/await | Concurrency | — | commonly-circulated | Mid |
| C2 | Actors and `@MainActor` | Concurrency | — | commonly-circulated | Mid |
| C3 | `Sendable` and the Swift 6 change | Concurrency | — | commonly-circulated | Senior |
| C4 | `TaskGroup`, ordering, cancellation | Concurrency | — | commonly-circulated | Senior |
| C5 | Fix the racy cache, three ways | Concurrency | — | commonly-circulated | Mid |
| C6 | Where `@MainActor` belongs | Concurrency | — | commonly-circulated | Mid |
| C7 | Delegate → `AsyncStream` | Concurrency | — | commonly-circulated | Senior |
| C8 | Actor reentrancy | Concurrency | — | commonly-circulated | Staff |
| C9 | Retry with backoff and jitter | Concurrency | — | commonly-circulated *(partial)* | Mid |
| C10 | Thread-safe LRU cache | Concurrency + ARC | — | commonly-circulated *(partial)* | Senior |
| C11 | Image loader with dedup | Concurrency | — | commonly-circulated | Senior |
| C12 | Debounce vs throttle | Concurrency | — | commonly-circulated | Mid |
| C13 | Token-bucket rate limiter | Concurrency | — | commonly-circulated | Senior |
| C14 | Cancel stale work on identity change | Concurrency + SwiftUI | DoorDash | candidate-reported *(partial)* | Mid |
| D1 | The state property wrappers | SwiftUI state | — | commonly-circulated | Junior |
| D2 | `@Observable` vs `ObservableObject` | SwiftUI state | — | commonly-circulated | Mid |
| D3 | MVVM / TCA / no-view-model | SwiftUI architecture | Uber, Monzo | candidate-reported *(partial)* | Senior |
| D4 | Dependency injection | SwiftUI + Swift | — | commonly-circulated *(partial)* | Mid |
| E1 | View identity and lost state | SwiftUI rendering | — | commonly-circulated | Mid |
| E2 | The layout system | SwiftUI layout | — | commonly-circulated | Mid |
| E3 | Measuring a child view | SwiftUI layout | — | commonly-circulated | Senior |
| E4 | Diagnosing list stutter | SwiftUI performance | — | commonly-circulated | Senior |
| F1 | `NavigationStack` and deep links | SwiftUI navigation | — | commonly-circulated | Mid |
| F2 | Testable view model | SwiftUI testing | — | commonly-circulated | Mid |
| F-x1 | `UIViewRepresentable` interop | SwiftUI interop | — | added-for-coverage | Senior |
| F-x2 | Accessibility in SwiftUI | SwiftUI | — | added-for-coverage | Mid |
| F-x3 | Previews and testability | SwiftUI testing | — | added-for-coverage | Junior |
| G1 | Monzo — modify an existing codebase | Take-home | **Monzo** | company-confirmed *(partial)* | Mid |
| G2 | DoorDash — extend an Xcode project | Take-home | **DoorDash** | candidate-reported | Mid |
| G3 | Generic list + detail brief | Take-home | — | commonly-circulated | Mid |
| G4 | SwiftData / `@Model` / `@Query` | Swift + SwiftUI | — | commonly-circulated *(partial)* | Mid |

**Totals:** 37 entries covering 38 retained task-18 items, plus 7 `added-for-coverage` entries. Company attributions appear on 6 entries; the remaining 38 carry no company attribution, exactly as in task 18.

---

## Sources

Carried over from `tasks/18-ios-interview-questions/output.md` for the retained items only, renumbered. Several publishers returned HTTP 403 to automated fetching; those are cited from search-index summaries rather than full-text retrieval and are marked **[index]**, as in the source report.

1. "Complete concurrency enabled by default — available from Swift 6.0," *Hacking with Swift* — https://www.hackingwithswift.com/swift/6.0/concurrency **[index]** *(task 18 ref [6])*
2. Mihai Popa, "Actors, Sendable, and Strict Concurrency in Swift 6," *Medium*, 2026 — https://medium.com/@mihaipopa/interview-26-actors-sendable-and-strict-concurrency-in-swift-6-97d951daf36f **[index]** *(ref [7])*
3. Carolane Lefebvre, "Observable vs @ObservedObject in SwiftUI: what's the difference?", *Medium* — https://carolanelefebvre.medium.com/observable-vs-observedobject-in-swiftui-whats-the-difference-5cfd2f7dfac0 **[index]** *(ref [8])*
4. shobhakartiwari, *SwiftUI-Interview-Questions*, GitHub — https://github.com/shobhakartiwari/SwiftUI-Interview-Questions *(ref [9])*
5. "How to use AI in Meta's AI-assisted coding interview," *interviewing.io* — https://interviewing.io/blog/how-to-use-ai-in-meta-s-ai-assisted-coding-interview-with-real-prompts-and-examples **[index]** *(ref [10]; rollout began October 2025)*
6. "Preparing for Mobile Interviews at Monzo," *Monzo blog* — https://monzo.com/blog/preparing-for-mobile-interviews-at-monzo **[index]** — *company-confirmed* *(ref [13])*
7. Tanishq Arora, "DoorDash iOS Interview Experience," *Medium* — https://medium.com/@ios-interview/doordash-ios-interview-experience-82fec170daa0 **[index]** *(ref [14])*
8. "Meta iOS Engineer Interview Experience & Questions," *Glassdoor* — https://www.glassdoor.com/Interview/Meta-IOS-Engineer-Interview-Questions-EI_IE40772.0,4_KO5,17.htm **[index]** *(ref [21])*
9. "DoorDash iOS Engineer: Exhaustive Interview Guide [2026]," *Prepfully* — https://prepfully.com/interview-guides/doordash-ios-engineer **[index]** *(ref [28])*
10. "Interviewing at Monzo: an overview of our interview process," *Monzo blog* — https://monzo.com/us/blog/monzo-us-blog/interviewing-at-monzo **[index]** — *company-confirmed* *(ref [34])*
11. Divyesh Vekariya, "The Complete Senior iOS Developer Interview Guide (2026)," *Medium* — https://dkvekariya.medium.com/the-complete-senior-ios-developer-interview-guide-2026-3ec09ab25987 **[index]** *(ref [39])*
12. "Swift 6.2 Concurrency in Practice: Default to MainActor, Escape on Purpose," *blakecrosley.com* — https://blakecrosley.com/blog/swift-6-2-concurrency-in-practice **[index]** *(ref [40])*
13. Alok Upadhyay, "Build a Thread-Safe LRU Cache with Expiry," *Stackademic* — https://blog.stackademic.com/ace-your-swift-interviews-build-a-thread-safe-lru-cache-with-expiry-4ec36a9c1300 ; "DIY: LRU Cache," *Educative* — https://www.educative.io/courses/decode-the-coding-interview-swift/JPNRnv5G6lo **[index]** *(ref [42])*
14. Shobhakar Tiwari, "iOS Interview Caching Questions & Strategies," *Medium* — https://medium.com/@shobhakartiwari/ios-interview-caching-questions-strategies-78bd4b9d0544 **[index]** *(ref [43])*
15. "How to Prepare for Take-Home Assignments and Case-Based Coding Tests," *Huru* — https://huru.ai/take-home-assignment-tips-coding-case-study-interview/ ; "Take Home Assignments and the Interview Process," *DEV Community* — https://dev.to/rockarts/take-home-assignments-and-the-interview-process-4jhl **[index]** *(ref [46])*
16. dashvlas, *awesome-ios-interview*, GitHub — https://github.com/dashvlas/awesome-ios-interview *(ref [47]; retrieved in full)*
17. mukundjogi, *ios-interview*, GitHub — https://github.com/mukundjogi/ios-interview **[index]** *(ref [48])*
18. "Ultimate iOS Engineer interview guide (2026)," *Prepfully* — https://prepfully.com/interview-guides/ios-engineer **[index]** *(ref [49])*
19. "iOS Concurrency Interview Questions," *Swift Rivals* — https://swiftrivals.com/concurrency/ios-concurrency-interview-questions **[index]** *(ref [50])*
20. "iOS 26," *Simple English Wikipedia* — https://simple.wikipedia.org/wiki/IOS_26 (announced 9 June 2025, released 15 September 2025; unified "26" versioning) ; *MacRumors* iOS 26 roundup — https://www.macrumors.com/roundup/ios-26/ *(ref [18])*
21. "SwiftUI vs UIKit in 2025 / 2026" — https://theswiftk.it.com/blog/swiftui-vs-uikit-2026 **[index]** — **vendor/community estimates, not a documented survey** *(ref [17])*
22. Robinhood, "Staff iOS Engineer" posting (Swift, **RxSwift, UIKit**, Bazel; 6+ years) — https://peerlist.io/company/robinhood/careers/staff-ios-engineer/jobh8o9a9dpglojp9fppqr6b7naq9d **[index]** *(ref [31]; cited here as evidence that large production codebases remain UIKit + reactive, not SwiftUI-first)*

**Sourcing caveat, carried over.** Monzo [6][10] is the only company-confirmed primary source among the retained items. Glassdoor and Medium write-ups [7][8] are single-candidate accounts, unverifiable and potentially stale. Prep vendors [9][13][18][19] have a commercial incentive to appear authoritative and frequently recycle each other. Where a technical claim rests only on prep material, the entry is labelled `commonly-circulated`. Nothing presented by any source as confidential or under NDA is reproduced here.

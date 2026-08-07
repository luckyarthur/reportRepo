# Swift Modern Concurrency — Interview Questions, Analysis, and Solutions

**Scope.** Interview questions and technical assessments on Swift's modern concurrency model: `async`/`await`, structured concurrency, unstructured tasks, cancellation, actors, global actors, `Sendable`, Swift 6 strict concurrency, continuation bridging, `AsyncSequence`/`AsyncStream`, and the comparison against GCD. Covers **Swift 5.5 through Swift 6.2**; every version-dependent claim is labelled. Behaviour that changed in **Swift 6.2** (`nonisolated(nonsending)`, `@concurrent`, default `@MainActor` isolation) is called out separately. **Research performed 7 August 2026.**

**Provenance.** Each entry is tagged `sourced` (the question appears in the interview-prep material surveyed) or `added-for-coverage` (authored here to fill a gap the sources left). 24 of 33 entries are `sourced`; 9 are `added-for-coverage`, concentrated in Tiers 3 and 4 where prep material is thinnest.

---

## TL;DR

- **The single most discriminating question is actor reentrancy.** Nearly every candidate can define an actor; very few can explain that actor isolation prevents *data races* but not *logical races across a suspension point*. This is the junior/senior line.
- **"Does `async` mean background thread?" is the most common trap**, and the most commonly failed. Isolation — not the `async` keyword — determines where code runs, and the answer changed in Swift 6.2.
- **Swift 6 turned warnings into errors, and interviewers use that as a proxy for real migration experience.** Candidates who learned concurrency from Swift 5.5-era blogs give answers that no longer compile.
- **Cancellation is cooperative, not preemptive.** Interviewers probe whether you know a cancelled task keeps running until *your* code checks, and that continuations do not receive cancellation for free.
- **`@unchecked Sendable` is a deliberate bait.** Reaching for it first marks a candidate as someone who silences diagnostics; explaining what you must *prove* to use it marks the opposite.
- **GCD comparison questions have shifted from syntax to runtime.** The graded answer is thread explosion vs. the cooperative thread pool, and why `DispatchSemaphore` violates Swift concurrency's runtime contract.
- **Where candidates most often fail:** mutating actor state across an `await`; unbounded `TaskGroup`s; `AsyncStream` with the default unbounded buffer; blocking the cooperative pool; and using `Task.detached` as "the background one."

---

## Where these questions came from

Searches were run in August 2026 across interview-prep aggregators (Prepfully-style guides, Medium interview series, GitHub question banks such as `dashvlas/awesome-ios-interview`), community engineering blogs (Donny Wals, Antoine van der Lee, Matt Massicotte, Emerge Tools, Kodeco), and primary material (Swift Evolution proposals, Apple Developer documentation, WWDC sessions 10254/2021 and 268/2025).

Two caveats matter for how you read this report. **First, representativeness is limited.** No company-confirmed concurrency question set exists publicly; almost all of the question material is single-author prep content, and these authors visibly recycle one another — the same six or seven questions ("what is an actor", "`Task` vs `Task.detached`", "what is `Sendable`") appear near-verbatim across many sites. Their frequency is therefore weak evidence of interview frequency and strong evidence of copying. **Second, several publishers were unreachable** from this environment (Medium article bodies, hackingwithswift.com, massicotte.org, swiftinterview.org, swiftrivals.com all returned egress blocks); those are cited from search-index summaries and marked **[index]** in Sources, not from full-text retrieval.

**Answers here are grounded in primary sources**, not in the prep material, because the prep material is frequently wrong. Three concrete examples, corrected in place below: `awesome-ios-interview`'s entire concurrency section is GCD/`NSOperationQueue`/semaphores with no async/await at all (§T1.10, §T2.9); several sites describe SE-0406 back-pressure as a shipped `AsyncStream` feature when the proposal is **returned for revision** (§T2.8); and multiple sites still teach `DispatchSemaphore` for "waiting on async work," which WWDC21 session 10254 explicitly identifies as unsafe (§T2.9).

### Relationship to `tasks/19-swift-swiftui-interview-questions/`

Task 19's Part C exists and was read. This report does not reproduce it: it adds tiering, roughly 2.5× the question count, and the runtime/semantic detail a dedicated concurrency round probes for. **Three places where this report contradicts or materially corrects task 19 are marked inline with a ⚠️ and collected in the cross-cutting analysis.**

---

## Question bank

### Tier 1 — Fundamentals

---

**T1.1 — Q: What is `async`/`await`, and how does it differ from completion handlers?** `sourced`

**What it's testing.** Whether you can articulate the *mechanical* difference, not just "it's more readable." Interviewers use the phrasing of your answer to date when you learned the model.

**Answer.** An `async` function may *suspend*: at an `await`, it can give up its thread, and resume later — possibly on a different thread — with its local state intact. The compiler splits the function at each suspension point and stores anything live across the split in a heap-allocated async frame (WWDC21 10254). Concretely this buys four things a completion handler cannot: (1) errors flow through `throws` instead of a `Result` in a callback, (2) the compiler enforces that you handle the result exactly once — no "forgot to call the completion handler" bug, (3) control flow (loops, `defer`, `guard`) works normally, and (4) the call participates in the task tree, so cancellation and priority propagate.

```swift
// completion handler: no compiler guarantee that `completion` is called exactly once
func loadUser(id: String, completion: @escaping (Result<User, Error>) -> Void)

// async: the type system enforces one outcome
func loadUser(id: String) async throws -> User
```

**Traps.** "It runs code on a background thread" — no (see T1.2). "It's just syntactic sugar for callbacks" — it is not; the task tree, cancellation propagation, and priority inheritance have no callback equivalent.

---

**T1.2 — Q: Does marking a function `async` make it run on a background thread?** `sourced`

**What it's testing.** The most-asked trap in the set. It separates people who understand *isolation* from people who pattern-matched `async` onto `DispatchQueue.global()`.

**Answer.** No. `async` means the function *may suspend*; it says nothing about which thread it runs on. Where it runs is determined by **isolation**:

- A function isolated to an actor (including `@MainActor`) runs on that actor's executor.
- A `nonisolated` **synchronous** function runs on the caller's executor — always.
- A `nonisolated` **async** function is the version-dependent case:
  - **Swift 5.5 – 6.1:** it hops to the concurrent cooperative thread pool, even when called from an actor.
  - **Swift 6.2 with `NonisolatedNonsendingByDefault`:** it defaults to `nonisolated(nonsending)` and runs on the *caller's* executor, matching the synchronous rule (SE-0461). To get the old always-offload behaviour you now write `@concurrent`.

```swift
@MainActor
func refresh() async {
    await parse()   // Swift ≤6.1: hops off the main actor.
}                   // Swift 6.2 + flag: stays on the main actor unless `parse` is @concurrent.

nonisolated func parse() async { /* ... */ }
```

**Traps.** Believing `await` always means a thread hop. Believing `Task { }` means "background." Assuming the Swift 6.2 answer applies to a codebase that has not enabled the upcoming feature — the flag is opt-in for existing projects and on by default only for new Xcode 26 app projects.

---

**T1.3 — Q: What actually happens at an `await`?** `added-for-coverage`

**What it's testing.** Runtime model. Prep sites almost never ask this; concurrency-focused rounds almost always do.

**Answer.** `await` marks a *potential* suspension point — the call may or may not actually suspend. If it does, the current task's continuation is saved and **the thread is released back to the cooperative pool to run other work**; the thread is not blocked. When the awaited work completes, the task is rescheduled onto an executor consistent with its isolation. Three consequences interviewers look for:

1. You may resume on a **different thread** than you suspended on (except on `@MainActor`, whose executor is the main thread).
2. Any assumption you made about shared mutable state **before** the `await` may be false **after** it — this is the root of the reentrancy bug in T3.1.
3. Because the thread is yielded rather than blocked, thousands of suspended tasks cost heap frames, not threads.

**Traps.** "`await` blocks the thread." "`await` guarantees you come back to the same thread."

---

**T1.4 — Q: What's the difference between `Task { }` and `Task.detached { }`?** `sourced`

**What it's testing.** Whether you know what a task inherits — and whether you treat `Task.detached` as "the background one," which is the common wrong mental model.

**Answer.** Both create **unstructured** tasks that start immediately and are not child tasks (nothing waits for them; their cancellation is not automatic). The difference is inheritance:

| | `Task { }` | `Task.detached { }` |
|---|---|---|
| Actor isolation of enclosing context | inherits | does **not** inherit |
| Priority | inherits | does **not** inherit |
| Task-local values | inherits | does **not** inherit |
| Cancellation from enclosing task | **not** inherited (unstructured) | not inherited |

```swift
@MainActor
final class ViewModel {
    var items: [Item] = []

    func load() {
        Task {                       // inherits @MainActor: assigning `items` is fine
            items = await fetch()
        }
        Task.detached {              // NOT on the main actor
            let fresh = await fetch()
            await MainActor.run { self.items = fresh }   // must hop back explicitly
        }
    }
}
```

`Task.detached` is almost always the wrong tool. Losing priority means UI-triggered work can be scheduled below background work; losing task-locals breaks logging/tracing context. Legitimate uses are narrow: fire-and-forget work that must deliberately outlive and de-prioritise itself from its creator. **In Swift 6.2 the idiomatic replacement for "get off the main actor to do CPU work" is a `@concurrent` function, not `Task.detached`.**

**Traps.** "Use `Task.detached` for background work." Assuming `Task { }` inherits cancellation — it does not; that is exactly what makes it unstructured.

---

**T1.5 — Q: When do you use `async let` vs. a `TaskGroup` vs. an unstructured `Task`?** `sourced`

**What it's testing.** Whether you reach for structured concurrency by default.

**Answer.**

- **`async let`** — a *fixed, statically known* set of concurrent child tasks, possibly of different types. Each runs as a child of the current task; awaiting the variable retrieves the value. If the scope exits without awaiting, the child is implicitly **cancelled and awaited** (SE-0317).
- **`TaskGroup` / `withThrowingTaskGroup`** — a *dynamic* number of children, all producing the same type, with results consumed as they finish.
- **`Task { }`** — unstructured; only when the work must escape the current scope, typically at a synchronous boundary such as a SwiftUI action or a UIKit delegate callback.

```swift
// fixed set, heterogeneous types
async let profile = loadProfile(id)
async let posts   = loadPosts(id)
let page = try await Page(profile: profile, posts: posts)

// dynamic set, homogeneous type
let sizes = try await withThrowingTaskGroup(of: Int.self) { group in
    for url in urls { group.addTask { try await byteCount(of: url) } }
    return try await group.reduce(into: 0, +=)
}
```

**Traps.** Using a task group for two fixed calls. Writing `let a = await async let …`. Not knowing that an un-awaited `async let` is cancelled at scope exit.

---

**T1.6 — Q: What is an `actor`, and what problem does it solve?** `sourced`

**What it's testing.** Baseline. The follow-up ("how is it different from a serial queue?") is where it gets graded.

**Answer.** An actor is a reference type whose mutable state is protected by **compiler-enforced isolation**: its stored properties and methods can only be accessed directly from inside the actor; from outside, access is `async` and must be `await`ed (SE-0306). Immutable `let` properties of `Sendable` type can be read synchronously from outside.

```swift
actor Counter {
    private var value = 0
    func increment() { value += 1 }     // isolated, synchronous inside
    func read() -> Int { value }
}

let c = Counter()
await c.increment()                     // cross-actor: async
```

**Difference from a serial queue.** A serial queue gives you mutual exclusion at *runtime* only, and callers block (or nest callbacks). An actor gives you mutual exclusion **checked at compile time** — the compiler rejects code that would race — and callers *suspend* rather than block, so no thread is held. A queue also cannot tell you that you forgot to route one access through it; the actor model makes that a compile error.

**Traps.** "An actor is a class with a serial queue inside." Assuming actor isolation makes multi-step operations atomic (T3.2).

---

**T1.7 — Q: What is `@MainActor`, and how does it replace `DispatchQueue.main.async`?** `sourced`

**What it's testing.** Whether your main-thread model is annotation-based or hop-based.

**Answer.** `@MainActor` is a **global actor** — a singleton actor whose executor is the main thread. Annotating a type, function, or property declares that it is main-thread-isolated, and the compiler both enforces it and inserts the hop for you at `await`.

```swift
@MainActor
final class ProfileModel {
    var name = ""
    func refresh() async throws {
        let user = try await api.user()   // hops off (Swift ≤6.1), does the I/O
        name = user.name                  // hops back automatically — no DispatchQueue
    }
}
```

Apply it at the **type** level for UI-facing state, not method by method. Do not apply it to networking, parsing, or persistence layers — that serialises real work onto the one thread that must stay free to render.

**Traps.** `DispatchQueue.main.async` inside an `async` function — an immediate signal of stale knowledge. `@MainActor` sprinkled on a repository. Believing `@MainActor` makes a type `Sendable`-safe to mutate from anywhere: it makes access *isolated*, which is why it is safe.

---

**T1.8 — Q: What is `Sendable`? Which types get it automatically?** `sourced`

**What it's testing.** Whether you understand the type-system half of data-race safety.

**Answer.** `Sendable` is a marker protocol meaning "values of this type can be safely passed across isolation boundaries." It has no requirements; the compiler checks it structurally.

- **Value types** (`struct`, `enum`) are implicitly `Sendable` when all stored properties are `Sendable` — for non-public types. Public types must declare conformance explicitly.
- **Actors** are always `Sendable`.
- **Classes** are `Sendable` only if `final`, with all stored properties immutable (`let`) and `Sendable`, and no non-`Sendable` superclass. Otherwise you must synchronise internally and declare `@unchecked Sendable` (T3.4).
- **Functions/closures** carry `@Sendable`, which restricts them to capturing `Sendable` values.

```swift
struct User: Sendable { let id: UUID; let name: String }   // fine
final class Box: Sendable { let value: Int; init(_ v: Int) { value = v } }   // fine
final class Mutable: Sendable { var value = 0 }            // ERROR: mutable stored property
```

**Swift 6.0 adds `sending`**, a different tool for the same problem: a `sending` parameter accepts a *non-`Sendable`* value provided the compiler can prove the caller gives up all references to it, so the value moves between isolation domains instead of being shared (SE-0430). `CheckedContinuation.resume(returning:)` uses it, which is why you can resume a continuation with a non-`Sendable` result.

**Traps.** "All structs are `Sendable`" — not if they hold a non-`Sendable` class. Confusing `Sendable` (the type is safe to share) with `@Sendable` (the closure's captures are restricted).

---

**T1.9 — Q: How do you bridge a completion-handler API to `async`/`await`? What are the rules?** `sourced`

**What it's testing.** Everyone can write the happy path. The rules are the graded part.

**Answer.** Wrap it in a continuation:

```swift
func loadUser(id: String) async throws -> User {
    try await withCheckedThrowingContinuation { continuation in
        loadUser(id: id) { result in continuation.resume(with: result) }
    }
}
```

**The contract: resume exactly once.**
- **Zero times** → the awaiting task suspends forever. `withCheckedContinuation` detects this at runtime and logs a `SWIFT TASK CONTINUATION MISUSE … leaked its continuation` message; `withUnsafeContinuation` silently hangs.
- **More than once** → a runtime trap with `withChecked…`; undefined behaviour with `withUnsafe…`.

Use `withUnsafeContinuation` only after measuring, in a hot path, once the checked version has proven correct. If the callback can fire **more than once**, a continuation is the wrong tool — you want `AsyncStream` (T2.8). **Cancellation does not propagate into a continuation for free** — see T2.2 and T4.1.

**Traps.** Resuming inside a loop or inside both branches *and* a `defer`. Using a continuation for a repeating delegate callback.

---

**T1.10 — Q: How is Swift concurrency's threading model different from GCD's?** `sourced`

**What it's testing.** Runtime understanding. This is the question where the recycled prep banks are most visibly out of date.

**Answer.** GCD creates threads on demand: when a work item blocks — on a lock, a semaphore, or a synchronous queue hop — GCD brings up another thread so the queue keeps making progress. With 100 concurrent network callbacks each blocking on a database queue, a 6-core device can end up with 100+ threads: memory overhead per thread, heavy context switching, and deadlock risk. That is **thread explosion** (WWDC21 10254).

Swift concurrency instead uses a **cooperative thread pool** with roughly one thread per core. Tasks never block a thread; they *suspend*, and the thread picks up other work. Switching between tasks costs about a function call rather than a full context switch. The model rests on a runtime contract: **threads always make forward progress** — dependencies must be expressed through `await`, actors, and task groups, which the runtime can see.

**What Swift concurrency does *not* replace:** `DispatchQueue` remains valid for interfacing with C/Objective-C callback APIs, for `DispatchSource` timers and file-system events, and in code that cannot adopt async. `OperationQueue`'s dependency graph and `maxConcurrentOperationCount` have no exact structured-concurrency equivalent (you rebuild the latter by hand, T2.3).

⚠️ **Source correction.** `dashvlas/awesome-ios-interview` — a widely forked question bank — answers "different ways of achieving concurrency in iOS" with "threads, GCD, NSOperationQueue" and covers semaphores, mutexes, and `@synchronized` with **no mention of Swift concurrency at all**. Treat that bank as historical: it describes the model Swift concurrency was designed to replace.

---

### Tier 2 — Intermediate

---

**T2.1 — Q: How does cancellation work in Swift concurrency? Why is it not preemptive?** `sourced`

**What it's testing.** Whether you know cancellation is *advisory*.

**Answer.** Cancelling a task sets a flag and propagates it to all child tasks. **Nothing stops.** The task keeps running until code explicitly observes cancellation:

- `Task.isCancelled` — a `Bool`; use it when you want to return a partial result or clean up without throwing.
- `try Task.checkCancellation()` — throws `CancellationError` if cancelled.
- Most stdlib suspension points (`Task.sleep`, `URLSession`'s async methods) throw on cancellation for you.

```swift
func process(_ items: [Item]) async throws -> [Result] {
    var out: [Result] = []
    for item in items {
        try Task.checkCancellation()      // a pure-CPU loop needs this explicitly
        out.append(transform(item))
    }
    return out
}
```

Preemption is not offered because stopping a task mid-statement would leave invariants broken and locks held; cooperative cancellation lets each task unwind cleanly.

**Traps.** Assuming a cancelled `Task` stops on its own. Swallowing `CancellationError` in a generic `catch` inside a retry loop — the retry then fights the cancellation. Cancelling the *parent* and expecting a detached child to stop.

---

**T2.2 — Q: What does `withTaskCancellationHandler` do, and what's the subtlety?** `sourced`

**What it's testing.** Bridging non-Swift-concurrency work — the case where cooperative cancellation needs help.

**Answer.** It runs an `onCancel` closure the moment the task is cancelled, without waiting for the operation to reach a suspension point. That is the only way to cancel work the runtime cannot see — a `URLSessionTask`, a C library handle, a `DispatchWorkItem`.

Two subtleties interviewers probe:

1. **`onCancel` runs immediately on whatever thread performs the cancellation**, concurrently with the operation body. It must therefore be thread-safe — you cannot touch actor state from it synchronously.
2. **It can run *before* the operation body has stored the thing to cancel**, in which case a naive implementation loses the cancellation. The fix is a lock-protected state box that records "already cancelled" (full solution in T4.1).

**Traps.** Assuming the handler runs on the task's isolation. Assuming it runs only after the operation starts.

---

**T2.3 — Q: With a `TaskGroup`, in what order do results arrive, how do errors propagate, and how do you cap concurrency?** `sourced`

**What it's testing.** Practical task-group mechanics — the single most common live-coding topic in this area.

**Answer.**

- **Order:** children yield in **completion** order, not submission order. Return the index alongside the value if order matters.
- **Errors:** a child's error surfaces from `group.next()` / the `for try await` loop, or — if you never consume results — at the implicit `waitForAll` when the group body ends. ⚠️ **Correction to task 19 Part C4**, which states "a throwing child cancels the group." It does not, by itself. The group is cancelled when the *error propagates out of the group body*, or when you call `group.cancelAll()`. If you catch the error inside the body and keep going, the remaining children keep running. The distinction matters because it determines whether sibling work is still in flight in your `catch` block.
- **Capping concurrency:** a group does not limit parallelism. Seed *N* children, then add one more each time you consume a result:

```swift
func loadAll(_ urls: [URL], maxConcurrent: Int = 4) async throws -> [Data] {
    try await withThrowingTaskGroup(of: (Int, Data).self) { group in
        var results = [Data?](repeating: nil, count: urls.count)
        var next = 0

        while next < min(maxConcurrent, urls.count) {
            let (i, url) = (next, urls[next])
            group.addTask { (i, try await fetch(url)) }
            next += 1
        }
        while let (i, data) = try await group.next() {
            results[i] = data
            if next < urls.count {
                let (j, url) = (next, urls[next])
                group.addTask { (j, try await fetch(url)) }
                next += 1
            }
        }
        return results.map { $0! }   // every index is filled or we threw
    }
}
```

**Traps.** An unbounded group over 10,000 URLs — you get 10,000 in-flight requests and a memory spike. Assuming results come back in order. `compactMap` on the result array, which silently shortens it if a slot is unexpectedly empty.

---

**T2.4 — Q: What does `nonisolated` mean, and when do you use it?** `sourced`

**What it's testing.** Whether you can reason about isolation at member granularity.

**Answer.** `nonisolated` opts a member out of its enclosing actor's isolation, so it can be called synchronously from anywhere. It is only legal when the member touches no isolated mutable state.

```swift
actor ImageCache {
    let directory: URL            // immutable: readable cross-actor already
    private var entries: [URL: Data] = [:]

    nonisolated var description: String { "ImageCache(\(directory.path))" }
    nonisolated func key(for url: URL) -> String { url.absoluteString }  // pure

    func data(for url: URL) -> Data? { entries[url] }   // isolated
}
```

Its most common real use is protocol conformance: `Equatable`, `Hashable`, and `CustomStringConvertible` requirements are synchronous and nonisolated, so an actor can only satisfy them with `nonisolated` members.

**Swift 6.2 note.** `nonisolated` on an *async* function changed meaning (T1.2/T3.3): it now means "runs on the caller's executor" rather than "always hops off," and `@concurrent` expresses the old behaviour.

**Traps.** Adding `nonisolated` to silence an isolation error on a member that *does* touch mutable state — the compiler will reject it, and candidates then reach for `nonisolated(unsafe)`, which is the wrong fix.

---

**T2.5 — Q: What is a `@Sendable` closure, and what are its capture rules?** `sourced`

**What it's testing.** The closure half of `Sendable`, which candidates who only memorised the type half miss.

**Answer.** `@Sendable` on a function type means the closure may be executed in a different isolation domain than where it was formed. The compiler therefore requires that every captured value be `Sendable`, and that captures of `var`s be by value (mutable captures are rejected).

```swift
var counter = 0
let bad: @Sendable () -> Void = { counter += 1 }   // ERROR: mutable capture

let box = Counter()                                 // an actor
let good: @Sendable () async -> Void = { await box.increment() }   // fine
```

`Task { }`, `Task.detached { }`, and `group.addTask { }` all take `@Sendable` closures — which is why capturing `self` in a `Task` requires `self` to be `Sendable` or the enclosing context to be isolated.

**Traps.** Confusing it with `@escaping`. Not realising that `[weak self]` in a `Task` is usually unnecessary — the task holds `self` only until it finishes — but *is* necessary when the task loops indefinitely.

---

**T2.6 — Q: What exactly does Swift 6 strict concurrency checking diagnose, and how do you migrate a large codebase?** `sourced`

**What it's testing.** Real migration experience versus blog-reading. This is the highest-signal Swift 6 question.

**Answer.** Swift 6 language mode enables **complete** data-race checking and turns what were Swift 5 *warnings* into *errors*. The main diagnostics:

- Passing a non-`Sendable` value across an isolation boundary.
- Accessing actor-isolated state from outside without `await`.
- Mutable global/`static var` state that is not isolated.
- Capturing non-`Sendable` values in a `@Sendable` closure.
- Non-`Sendable` types conforming to protocols with `Sendable` requirements.

**Migration path** — the answer interviewers want is *incremental*, per module:

1. Stay in Swift 5 mode; set `SWIFT_STRICT_CONCURRENCY = minimal` → `targeted` → `complete`, fixing warnings at each step.
2. Annotate isolation at boundaries: `@MainActor` on UI types, actors for shared mutable subsystems, `Sendable` on model types.
3. Only then flip the module to Swift 6 language mode. Modules can be migrated one at a time; a Swift 6 module can depend on a Swift 5 one.

**Global mutable state** is the highest-volume error class. The fixes, in order of preference: make it `let`; make it `@MainActor`-isolated; move it into an actor; wrap it in a `Mutex` (T3.4); and only as a last resort `nonisolated(unsafe) var`, which is an explicit, greppable "I have proven this safe by other means."

**Traps.** "Just turn on Swift 6 mode and fix the errors" — on a large codebase that is thousands of errors at once, which is precisely why the staged flags exist. Claiming Swift 6 eliminates all data races: it eliminates them in checked code, but `@unchecked Sendable`, `nonisolated(unsafe)`, and C interop remain holes.

---

**T2.7 — Q: When would you use `AsyncStream` versus writing a custom `AsyncSequence`?** `added-for-coverage`

**What it's testing.** Whether you can turn a push-based source into a pull-based sequence.

**Answer.** `AsyncStream` exists to adapt a **push** source (delegate, notification, `Combine` publisher, C callback) into a **pull** `AsyncSequence`. Write a custom `AsyncSequence` only when the values are generated on demand by the consumer, or when you need a bespoke iterator with its own state.

```swift
func locations(from manager: CLLocationManager) -> AsyncStream<CLLocation> {
    AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
        let delegate = LocationDelegate { continuation.yield($0) }
        manager.delegate = delegate
        manager.startUpdatingLocation()
        continuation.onTermination = { _ in
            manager.stopUpdatingLocation()
            withExtendedLifetime(delegate) { }     // delegate is held weakly by the manager
        }
    }
}
```

The graded details are `onTermination` — which runs when the consumer's task is cancelled or the iterator is discarded, and is where you tear the source down — and the buffering policy (T2.8).

**Traps.** Forgetting `onTermination`, so the underlying source runs forever after the consumer goes away. Letting the delegate be deallocated because the manager holds it weakly.

---

**T2.8 — Q: `AsyncStream`'s default buffering policy is `.unbounded`. Why is that a problem, and what do you do about it?** `added-for-coverage`

**What it's testing.** Back-pressure — a topic that separates people who have shipped a stream from people who have read about one.

**Answer.** With `.unbounded`, `yield` always succeeds and the buffer grows without limit. If the producer is faster than the consumer — sensor data, a high-frequency socket, scroll events — the process accumulates elements until it is killed under memory pressure. The stdlib alternatives are `.bufferingNewest(n)` (drop oldest; correct for "latest value wins" sources like location or progress) and `.bufferingOldest(n)` (drop newest; correct when the first *n* events are the meaningful ones).

**Critically, none of these is real back-pressure** — they drop data rather than slow the producer. `yield` returns a `Yield.Result` telling you whether the value was enqueued or dropped, but there is no signal to the producer that consumption has *resumed*.

⚠️ **Source correction.** Several blog and aggregator summaries describe SE-0406 ("Backpressure support for AsyncStream") as shipped. It is **returned for revision** — the proposal itself identifies the gap: `yield()` provides only a "stop" signal and no way to indicate that production should resume. As of Swift 6.2 there is no stdlib back-pressured `AsyncStream`; you either apply a buffering policy and accept dropped values, or use a bounded channel type (e.g. from `swift-async-algorithms`) whose producer side suspends.

**Traps.** Claiming a buffering policy gives you back-pressure. Not knowing `yield` has a return value.

---

**T2.9 — Q: Can you use `DispatchSemaphore` to wait for an async function from synchronous code?** `sourced`

**What it's testing.** Whether you know the runtime contract. Prep material still recommends this pattern; Apple explicitly does not.

**Answer.** No. Swift concurrency's cooperative pool has roughly one thread per core and assumes **threads always make forward progress**. Blocking a pool thread on a semaphore hides the dependency from the runtime: the runtime cannot spin up a replacement thread the way GCD would, so with enough blocked tasks you deadlock the pool outright. WWDC21 10254 lists semaphores and condition variables as unsafe under this model, and permits only tight, non-suspending critical sections with `os_unfair_lock`/`NSLock`.

The corollary is the rule that catches people in code review: **never `await` while holding a lock**, and never hold a lock across a suspension point. The task can resume on a different thread, so the unlock may happen on a thread that never locked — undefined behaviour with `os_unfair_lock`.

The correct answers to "I need to call async code from sync code": make the caller `async`; or, at a genuine boundary you cannot change, spawn a `Task` and deliver the result through a callback or `@MainActor` state.

**Traps.** "It works in my app" — it works until the pool is saturated, which is a production-only failure. Using a semaphore to limit concurrency inside async code; use a bounded task group (T2.3) or an actor-based limiter instead.

---

**T2.10 — Q: What is "actor hopping," and why is it a performance concern?** `sourced`

**What it's testing.** Whether "put `@MainActor` on everything" registers to you as a cost.

**Answer.** Every cross-actor `await` is a potential executor switch. Each switch enqueues the continuation on the target executor and suspends the task — cheap individually, expensive in a loop:

```swift
@MainActor func update(_ ids: [ID]) async throws {
    for id in ids {
        let article = try await database.load(id)   // hop off
        display(article)                            // hop back
    }                                               // 2 hops per iteration
}

@MainActor func updateBatched(_ ids: [ID]) async throws {
    let articles = try await database.load(ids)     // one hop off
    display(articles)                               // one hop back
}
```

Batch at the boundary. The related design point: annotating a *networking* or *parsing* layer `@MainActor` does not just add hops, it moves the work itself onto the main thread and drops frames.

**Traps.** Optimising by adding `Task.detached`, which adds an unstructured task on top of the hop. Assuming actor isolation makes calls free because "it's just a serial queue."

---

### Tier 3 — Advanced / senior-level

---

**T3.1 — Q: Explain actor reentrancy. Here is an actor cache — what's wrong with it?** `sourced`

**What it's testing.** The highest-signal question in the set. Data-race safety versus logical-race safety.

**Answer.** Actors are **reentrant**: when an actor-isolated function suspends at an `await`, the actor does not stay locked — it accepts and runs other messages. SE-0306 chose this deliberately for three reasons: it makes deadlock structurally impossible (A awaiting B awaiting A cannot hang), it keeps the actor making progress instead of serialising every caller behind one slow I/O, and it lets the runtime honour priority instead of strict FIFO.

The consequence is that **actor isolation prevents data races, not logical races across suspension points**:

```swift
actor TokenProvider {
    private var token: Token?
    private let network: Network

    func token() async throws -> Token {
        if let token, !token.isExpired { return token }
        let fresh = try await network.refresh()   // suspension: N callers → N refreshes
        self.token = fresh                        // last writer wins; earlier callers get stale tokens
        return fresh
    }
}
```

Ten concurrent callers all see `token == nil`, all suspend at `network.refresh()`, and all issue a refresh — which on most auth servers invalidates the previous token, so nine callers walk away holding a dead credential. Nothing here is a data race; the compiler is entirely satisfied.

**The fix is to publish the *in-flight work*, not the result** — storing a `Task` is a synchronous mutation, so the window closes before any suspension:

```swift
actor TokenProvider {
    private enum State { case idle, refreshing(Task<Token, Error>), valid(Token) }
    private var state: State = .idle

    func token() async throws -> Token {
        switch state {
        case .valid(let t) where !t.isExpired:
            return t
        case .refreshing(let task):
            return try await task.value          // all late callers join the same refresh
        default:
            let task = Task { [network] in try await network.refresh() }
            state = .refreshing(task)            // synchronous: no suspension between check and set
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

**The general rules**, both from SE-0306: perform state mutation in **synchronous** sections so it is atomic with respect to other messages, and **re-check every assumption after an `await`**.

**Traps.** "Actors serialise everything, so this is safe." Trying to fix it with a `DispatchSemaphore` or a boolean `isRefreshing` flag — the flag is checked before the suspension and is stale after it, and the semaphore blocks the pool (T2.9). Suggesting `@MainActor` on the provider, which changes nothing: global actors are reentrant too.

---

**T3.2 — Q: Can an actor guarantee a multi-step transaction?** `added-for-coverage`

**What it's testing.** A sharper form of T3.1 that senior candidates often still miss.

**Answer.** Only if every step is synchronous. An actor method is atomic with respect to other messages **between suspension points**, so `read-modify-write` inside one isolated synchronous function is safe:

```swift
actor Inventory {
    private var stock: [SKU: Int] = [:]
    func reserve(_ sku: SKU, count: Int) -> Bool {   // no await: atomic
        guard stock[sku, default: 0] >= count else { return false }
        stock[sku]! -= count
        return true
    }
}
```

The moment a step must `await` — validating against a remote service mid-transaction — atomicity is gone and you need an explicit mechanism: hold the transaction as state (a per-key `Task` or reservation record, as in T3.1), or serialise through an async lock built from a continuation queue. Swift ships no async lock, and `NSLock`/`Mutex` cannot be held across an `await` (T2.9).

**Traps.** "Wrap it in `withLock`." Assuming `await` inside an actor holds the actor.

---

**T3.3 — Q: What changed in Swift 6.2's "approachable concurrency," and what does it mean for existing code?** `sourced`

**What it's testing.** Currency. Very few candidates can answer this in August 2026, so it is a strong differentiator.

**Answer.** Three related changes, all opt-in for existing projects and on by default for new Xcode 26 app projects:

1. **`nonisolated(nonsending)` and `@concurrent` (SE-0461).** Previously a `nonisolated async` function always hopped to the global executor, unlike a `nonisolated` *synchronous* function which ran on the caller's executor — an inconsistency that also forced spurious `Sendable` requirements on arguments. Under the `NonisolatedNonsendingByDefault` upcoming feature, `nonisolated async` functions default to `nonisolated(nonsending)`: they run on the **caller's** executor. `@concurrent` (which implies `nonisolated` and requires `async`) opts back into always-offload.

```swift
@concurrent
func decodeImage(_ data: Data) async -> Image { /* runs off the caller's actor */ }
```

2. **Default actor isolation control (SE-0466).** `-default-isolation MainActor`, or `SwiftSetting.defaultIsolation(MainActor.self)` in a package manifest, makes unannotated declarations in a module `@MainActor`-isolated. This inverts the burden: single-threaded app code stops producing false-positive data-race diagnostics, and *leaving* the main actor becomes the explicit act.

3. In Xcode, the **Approachable Concurrency** build setting turns on the associated group of upcoming features; default actor isolation is a separate setting.

**What it means for existing code.** Enabling default main-actor isolation on a module that already offloads work will pull that work back onto the main actor unless it is annotated — you migrate module by module, marking genuinely concurrent entry points `@concurrent` or `nonisolated`. Enabling `NonisolatedNonsendingByDefault` can *change where existing `nonisolated async` functions run*, which is a behaviour change, not just a diagnostic change.

**Traps.** Describing `@concurrent` as a replacement for `Task.detached` in general — it is a function-isolation annotation, not a task-creation API. Assuming these are on by default in an existing project.

---

**T3.4 — Q: When is `@unchecked Sendable` justified, and what must you prove?** `sourced`

**What it's testing.** Judgement. The wrong answer is fluent and fast; the right answer is specific.

**Answer.** `@unchecked Sendable` moves the guarantee from the compiler to you. It is justified when the type *is* thread-safe by a mechanism the compiler cannot see: an internal lock, an immutable-after-init invariant the compiler can't prove, or an underlying thread-safe C/Objective-C implementation. You must be able to state **which mechanism** serialises **which stored properties**.

Since Swift 6.0, the better answer for the common case is `Mutex` from the `Synchronization` module (SE-0433), which is unconditionally `Sendable`, so the wrapping type conforms to `Sendable` **checked**:

```swift
import Synchronization

final class Metrics: Sendable {                       // note: NOT @unchecked
    private let counts = Mutex<[String: Int]>([:])
    func increment(_ key: String) { counts.withLock { $0[key, default: 0] += 1 } }
    func value(_ key: String) -> Int { counts.withLock { $0[key] ?? 0 } }
}
```

⚠️ **Correction to task 19 Part C5**, which presents `@unchecked Sendable` + `OSAllocatedUnfairLock` as *the* lock-based answer. That is correct but no longer the best available: with `Mutex` the conformance is checked rather than asserted, which is a meaningful difference in a code review. The caveat is **availability** — `Mutex` requires iOS 18 / macOS 15; below that, `OSAllocatedUnfairLock` (iOS 16+) or `NSLock` with `@unchecked Sendable` remains the right answer. Both are subject to T2.9: never hold either across an `await`.

**Traps.** `@unchecked Sendable` applied to a type with plain `var`s and no synchronisation, to green a build. Claiming a `let` array of a non-`Sendable` class type is safe because the array is immutable — the *elements* are still shared.

---

**T3.5 — Q: How does priority work in Swift concurrency, and what is priority escalation?** `added-for-coverage`

**What it's testing.** Scheduling knowledge, and the distinction from GCD's FIFO model.

**Answer.** Tasks carry a `TaskPriority`. Structured children and `Task { }` inherit it from their context; `Task.detached` does not. Two mechanisms matter:

- **Priority escalation.** If a high-priority task `await`s a low-priority one — the value of an `async let`, a child in a group, or an actor whose queue holds low-priority work ahead of it — the runtime raises the priority of the work being waited on so the waiter is not held up. This is why priority inversion is far less pathological here than under GCD, where a serial queue's strict FIFO order means a low-priority item genuinely blocks a high-priority one behind it.
- **Reentrancy as an anti-inversion device.** Because an actor picks up other messages while a task is suspended, a low-priority task suspended on I/O does not hold the actor against a high-priority one.

The remaining real inversion risk is a task that blocks rather than suspends — a lock or semaphore held across long work — because the runtime cannot see the dependency and therefore cannot escalate through it.

**Traps.** Setting `.userInitiated` everywhere "to make it fast." Assuming `Task.detached(priority:)` inherits anything else. Believing priorities are honoured strictly — they influence scheduling, they do not guarantee ordering.

---

**T3.6 — Q: `MainActor.run`, `Task { @MainActor in }`, and `MainActor.assumeIsolated` — when do you use each?** `added-for-coverage`

**What it's testing.** Precision about isolation at boundaries, and a real trap: `assumeIsolated` is a *runtime assertion*.

**Answer.**

- **`await MainActor.run { }`** — from an `async` context, run a closure on the main actor and await its result. Use it at a boundary where annotating the enclosing function is not possible.
- **`Task { @MainActor in }`** — from a **synchronous** context, schedule main-actor work. This is the correct shape inside a non-isolated delegate callback.
- **`MainActor.assumeIsolated { }`** — you are *already* on the main actor but the compiler doesn't know (a C callback, a UIKit method not yet annotated). It performs **no hop**; it asserts isolation and **traps at runtime if you are wrong**. Because it does not suspend, it is the only one of the three usable from a synchronous function that must return a value.

```swift
nonisolated func callbackFromCoreAudio() {
    MainActor.assumeIsolated { model.tick() }   // CRASHES if not actually on the main thread
}
```

The preferred fix is almost always to annotate the function `@MainActor` instead; `assumeIsolated` is for boundaries you do not control.

**Traps.** Using `assumeIsolated` to silence a diagnostic without knowing the actual thread — a latent crash. Using `MainActor.run` inside an already-`@MainActor` function, which adds a pointless suspension.

---

**T3.7 — Q: What are task-local values, and how do they propagate?** `added-for-coverage`

**What it's testing.** A less-common API whose propagation rules exercise the structured/unstructured distinction cleanly.

**Answer.** A `@TaskLocal` is a static property scoped to a task and inherited by its children — the concurrency-safe replacement for thread-local storage, used for request IDs, trace spans, and test injection.

```swift
enum Trace {
    @TaskLocal static var requestID: String?
}

await Trace.$requestID.withValue(UUID().uuidString) {
    await handleRequest()          // and every child task sees it
}
```

Propagation: **structured children (`async let`, task groups) and `Task { }` inherit** the enclosing values; **`Task.detached` does not**. The value is bound for the dynamic extent of `withValue` only — reading it after that scope returns `nil`.

**Traps.** Expecting mutation to be visible to the parent — values are inherited by copy, and children cannot write back. Using them for application state rather than contextual metadata.

---

**T3.8 — Q: How do you test async code, and how do you make concurrency tests deterministic?** `added-for-coverage`

**What it's testing.** Whether you have dealt with flaky concurrency tests, which every team has.

**Answer.** Test functions can be `async`, so the awkward expectation-plus-timeout pattern is gone. The determinism problems and their fixes:

- **Real time.** Never `Task.sleep` in a test. Inject a `Clock` (`ContinuousClock` in production, a test clock in tests) so debounce/retry/backoff logic is driven by controlled time.
- **Main-actor isolation.** Mark tests that touch `@MainActor` types `@MainActor`, rather than hopping inside the test.
- **Ordering.** Do not assert on the completion order of concurrent work; assert on the invariant (the final state, the set of results).
- **Verifying isolation.** A test that a type is `Sendable` is a compile-time test — if it compiles under strict concurrency, it passed.

Under Swift Testing, `@Test func` may be `async` and `#expect`/`#require` work with `try await` directly; XCTest is still required for UI tests.

**Traps.** `XCTAssertEqual` inside a `Task` with no `await` before the assertion — the test finishes first and passes vacuously. Fixing flakiness by raising a timeout.

---

### Tier 4 — Coding assessments / take-home style

---

**T4.1 — Task: Convert this cancellable callback API to `async`/`await`, including cancellation.** `sourced`

**What it's testing.** The continuation contract *plus* the cancellation-handler race — the part that separates a working answer from a correct one.

**The naive answer, and why it's wrong:**

```swift
func data(from url: URL) async throws -> Data {
    let box = Mutex<URLSessionDataTask?>(nil)
    return try await withTaskCancellationHandler {
        try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error { continuation.resume(throwing: error) }
                else { continuation.resume(returning: data ?? Data()) }
            }
            box.withLock { $0 = task }          // ← may run AFTER onCancel
            task.resume()
        }
    } onCancel: {
        box.withLock { $0?.cancel() }           // ← sees nil, cancellation is lost
    }
}
```

If the task is cancelled before the operation body stores the handle, `onCancel` reads `nil` and the request runs to completion. **The fix is to make the box a state machine so "cancelled first" is recorded:**

```swift
private enum BridgeState { case pending, running(URLSessionDataTask), cancelled }

func data(from url: URL) async throws -> Data {
    let state = Mutex<BridgeState>(.pending)
    return try await withTaskCancellationHandler {
        try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error { continuation.resume(throwing: error) }
                else { continuation.resume(returning: data ?? Data()) }
            }
            let alreadyCancelled = state.withLock { s -> Bool in
                if case .cancelled = s { return true }
                s = .running(task)
                return false
            }
            if alreadyCancelled { task.cancel() } else { task.resume() }
        }
    } onCancel: {
        state.withLock { s in
            if case .running(let task) = s { task.cancel() }
            s = .cancelled
        }
    }
}
```

**Grading points.** Resume exactly once on every path. `onCancel` is `@Sendable` and runs concurrently with the body, so shared state needs a lock. Cancelling a `URLSessionTask` surfaces as a `URLError.cancelled`, not `CancellationError` — map it if callers expect the latter. And say out loud that in real code you would just call `URLSession.shared.data(from:)`; this exercise is about the bridging pattern.

---

**T4.2 — Task: Fix the data race in this class. Give more than one option and justify your choice.** `sourced`

```swift
final class ImageCache {                       // racy; fails to compile under Swift 6
    private var storage: [URL: UIImage] = [:]
    func image(for url: URL) -> UIImage? { storage[url] }
    func store(_ image: UIImage, for url: URL) { storage[url] = image }
}
```

**What it's testing.** Whether you can pick a synchronisation strategy on migration cost, not fashion.

**Answer — three valid options:**

```swift
// 1. Actor — compiler-checked, but every caller becomes async.
actor ImageCache {
    private var storage: [URL: UIImage] = [:]
    func image(for url: URL) -> UIImage? { storage[url] }
    func store(_ image: UIImage, for url: URL) { storage[url] = image }
}

// 2. Mutex (Swift 6.0 / iOS 18+) — checked Sendable, synchronous API preserved.
import Synchronization
final class ImageCache: Sendable {
    private let storage = Mutex<[URL: UIImage]>([:])
    func image(for url: URL) -> UIImage? { storage.withLock { $0[url] } }
    func store(_ image: UIImage, for url: URL) { storage.withLock { $0[url] = image } }
}

// 3. @MainActor — correct when the cache is only ever touched from UI code.
@MainActor final class ImageCache { /* original body, unchanged */ }
```

**The senior answer is the trade-off, not the code.** The actor is the "modern" choice and the most expensive one: it makes every call site `async`, which cascades through a synchronous codebase and can force callers to become tasks, changing ordering guarantees they relied on. The `Mutex` keeps the synchronous API and is a drop-in for existing call sites — usually the right migration move. `@MainActor` is right only if the access pattern is genuinely UI-only, and wrong the moment a background decode wants to write.

**Grading points.** `UIImage` is `Sendable`, but a mutable dictionary of them is not — name that. In option 2, note that `withLock` must not contain an `await`. Mention availability: `Mutex` is iOS 18+, `OSAllocatedUnfairLock` iOS 16+, `NSLock` everywhere with `@unchecked Sendable`.

---

**T4.3 — Task: Implement a concurrent image loader with a concurrency cap and in-flight de-duplication.** `sourced`

**What it's testing.** The most common concurrency take-home. It combines actor state, unstructured tasks, cancellation, and reentrancy.

```swift
actor ImageLoader {
    private enum Entry { case inFlight(Task<UIImage, Error>), ready(UIImage) }

    private var cache: [URL: Entry] = [:]
    private let maxConcurrent: Int
    private var active = 0
    private var waiters: [CheckedContinuation<Void, Never>] = []

    init(maxConcurrent: Int = 4) { self.maxConcurrent = maxConcurrent }

    func image(for url: URL) async throws -> UIImage {
        switch cache[url] {
        case .ready(let image):
            return image
        case .inFlight(let task):
            return try await task.value                 // de-duplication
        case nil:
            let task = Task { try await self.download(url) }
            cache[url] = .inFlight(task)                // synchronous: closes the race window
            do {
                let image = try await task.value
                cache[url] = .ready(image)
                return image
            } catch {
                cache[url] = nil                        // don't cache failures
                throw error
            }
        }
    }

    private func download(_ url: URL) async throws -> UIImage {
        await acquireSlot()
        defer { releaseSlot() }
        try Task.checkCancellation()
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { throw LoaderError.decodingFailed }
        return image
    }

    private func acquireSlot() async {
        if active < maxConcurrent { active += 1; return }
        await withCheckedContinuation { waiters.append($0) }
        active += 1
    }

    private func releaseSlot() {
        active -= 1
        if !waiters.isEmpty { waiters.removeFirst().resume() }
    }
}
```

**Grading points.** Storing the `Task` before any `await` is what makes de-duplication correct — the same fix as T3.1, and the interviewer will ask you to explain the window. Failures must not be cached as failures. `acquireSlot`/`releaseSlot` are an async semaphore built from continuations rather than a `DispatchSemaphore`, so no pool thread is blocked (T2.9). The honest caveat to volunteer: because the shared `Task` is joined by many callers, **one caller cancelling should not cancel the shared download** — this implementation gets that right (cancelling the awaiting task does not cancel `task`), but the counterpart is that nothing cancels the download when *every* caller goes away; solving that needs reference counting.

**Traps.** Checking the cache, then awaiting, then writing — the classic reentrancy bug. Using a `DispatchSemaphore` for the cap. Making the whole loader `@MainActor` and decoding on the main thread.

---

**T4.4 — Task: Make this type `Sendable`.** `sourced`

```swift
final class Configuration {
    var endpoint: URL
    var retryCount: Int
    let logger: Logger                  // a non-Sendable class
    var onChange: (() -> Void)?
}
```

**What it's testing.** Whether you can classify each stored property by *why* it is unsafe and pick a per-property fix, rather than reaching for one blanket annotation.

**Answer.** Four distinct problems, four fixes:

1. `var endpoint` / `var retryCount` — mutable stored state. If the type is genuinely immutable after construction, make them `let`; that alone makes the class `Sendable` if the rest resolves.
2. `let logger: Logger` — an immutable reference to a **non-`Sendable`** class. `let` does not help: the referenced object is still shared. Either make `Logger` `Sendable` (or an actor), or stop storing it and pass it in.
3. `var onChange: (() -> Void)?` — a non-`@Sendable` closure. Change the type to `(@Sendable () -> Void)?`, and note that callbacks stored on a shared type usually want explicit isolation: `(@Sendable @MainActor () -> Void)?`.
4. If the type must stay mutable, the choice is an `actor`, or a `Mutex`-backed class as in T4.2.

```swift
struct Configuration: Sendable {                  // often the best answer: make it a value type
    let endpoint: URL
    let retryCount: Int
    let onChange: (@Sendable @MainActor () -> Void)?
}
```

**Grading points.** Say explicitly why `@unchecked Sendable` is wrong here: nothing synchronises `endpoint` or `retryCount`, so the annotation would be a false claim. Note that a `struct` is the strongest answer when the type is a bag of configuration — the interviewer is often looking for "does this need to be a class at all?"

---

**T4.5 — Task: Review this code. Find every concurrency defect.** `added-for-coverage`

```swift
@MainActor
final class FeedViewModel: ObservableObject {
    @Published var items: [Item] = []
    private var refreshTask: Task<Void, Never>?

    func refresh() {
        Task.detached {
            let items = await self.api.fetchItems()
            self.items = items
        }
    }

    func search(_ query: String) {
        refreshTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            let results = await self.api.search(query)
            self.items = results
        }
    }

    deinit { refreshTask?.cancel() }
}
```

**Expected findings (six):**

1. **`Task.detached` loses `@MainActor`.** `self.items = items` is a main-actor mutation from a non-isolated context — a compile error under Swift 6 and a UI race under Swift 5. Use `Task { }`, which inherits isolation.
2. **`Task.detached` also drops priority and task-locals**, so a user-initiated refresh can be scheduled behind background work.
3. **`search` never cancels the previous task.** Each keystroke starts a new debounce; older ones still land, so results arrive out of order and the last *slow* response wins. Fix: `refreshTask?.cancel()` before assigning, and `try Task.checkCancellation()` after the sleep.
4. **`try? await Task.sleep` swallows `CancellationError`**, so a cancelled task proceeds to run the search anyway. That is the bug that makes finding #3 only half a fix.
5. **`refresh` does not track its task at all**, so it cannot be cancelled and can overlap with `search`, giving two writers to `items`.
6. **`deinit` cancelling `refreshTask` is nearly dead code** — the running `Task` strongly retains `self`, so `deinit` cannot run while it is in flight. Cancellation must be driven by a lifecycle event (`.task` / `onDisappear` in SwiftUI), not by deallocation.

A candidate who also notes that `@Published`/`ObservableObject` would be `@Observable` in current code, or that the debounce belongs in a testable helper with an injected `Clock` (T3.8), is answering above the bar.

---

## Cross-cutting analysis

**Which concepts dominate.** Across the material surveyed, five topics account for the large majority of questions: `async`/`await` versus completion handlers; actors and `@MainActor`; `Sendable`; `Task` versus `Task.detached`; and the GCD comparison. That distribution reflects what is easy to write about more than what is hard to get right — three of those five are definitional and can be answered from a blog post. The topics that actually predict on-the-job competence are markedly *under*-represented in prep material: reentrancy, cancellation propagation into non-Swift APIs, back-pressure, and migration strategy. If you are preparing, weight your study toward the under-represented list; if you are interviewing, that is where to build your questions.

**What separates junior from senior.** A clean line runs through the bank. Junior answers describe **syntax and API surface** — what `await` is, what an actor is, which initialiser to call. Senior answers describe **the runtime and the failure mode** — that `await` yields a thread rather than blocking one, that reentrancy means an actor's state can change under you, that `Task.detached` costs priority and task-locals, that cancellation does nothing until someone checks. The two questions with the highest separation are **T3.1 (reentrancy)** and **T2.9 (semaphores and the runtime contract)**: both are answerable only from a model of what the runtime does, and neither can be bluffed from API familiarity.

**How Swift 6 changed what gets asked.** Before Swift 6, concurrency questions were about *writing* concurrent code. Now a large share are about *migrating* it, because the warnings-to-errors change made migration a real, costly project at every company with an existing codebase. That shifts the graded content toward judgement: which module first, when `@unchecked Sendable` is a legitimate engineering decision versus a shortcut, what `nonisolated(unsafe)` actually asserts. It has also made **recency** testable in a way it wasn't before — a candidate who answers T1.2 with the pre-6.2 rule and cannot name `nonisolated(nonsending)` has demonstrably not touched a current toolchain.

**Misconceptions that recur across multiple sources.** Four appear again and again in the prep material itself, not just in candidate answers:

- **"`async` means background thread."** Extremely widespread. It was never true, and Swift 6.2 makes the correct answer differ again.
- **"Actors serialise access, so actor code is safe."** True of data races, false of the logical races that actually bite (T3.1, T3.2).
- **"Use a semaphore to wait for async work."** Repeated in question banks that predate Swift concurrency and were never revised; directly contradicted by WWDC21 10254.
- **"`AsyncStream` handles back-pressure."** Conflates buffering policies with flow control, and in several cases cites SE-0406 as shipped when it is returned for revision (T2.8).

**Where this report contradicts task 19's Part C.** Three places, all corrections rather than disagreements of taste:

1. **Task 19 C1** answers "which thread does the resumed code run on?" with "the caller's isolation domain." That is correct only for actor-isolated async functions, or under Swift 6.2's `NonisolatedNonsendingByDefault`. In Swift 5.5–6.1, a `nonisolated async` function resumes on the **cooperative pool**, not the caller's actor — which is exactly the behaviour SE-0461 was written to change. This report's T1.2 gives the version-split answer; task 19's is right for the newest toolchain only and wrong for most shipping code today.
2. **Task 19 C4** states that "a throwing child cancels the group." The group is cancelled when the error propagates out of the group body (or on an explicit `cancelAll()`), not by the child throwing per se — catch it inside the body and the siblings keep running (T2.3).
3. **Task 19 C5** presents `@unchecked Sendable` + `OSAllocatedUnfairLock` as the lock-based answer. Since Swift 6.0, `Mutex` (SE-0433) gives the same synchronous API with a **checked** `Sendable` conformance and should be the default where iOS 18 / macOS 15 availability permits (T3.4).

---

## Study plan

1. **Build the mental model first.** Watch WWDC21 "Swift concurrency: Behind the scenes" and WWDC25 "Embracing Swift concurrency." Everything else is easier once you know that tasks suspend rather than block, and that isolation — not `async` — determines where code runs.
2. **Structured concurrency by hand.** Write `async let`, a task group with bounded concurrency (T2.3), and cancellation with `checkCancellation()` until the task-tree lifetime rules are automatic.
3. **Actors and reentrancy.** Read SE-0306, then implement the token-refresh coalescer (T3.1) from scratch. If you learn one thing on this list, learn this one.
4. **`Sendable` and the Swift 6 diagnostics.** Take a small Swift 5 module, set `SWIFT_STRICT_CONCURRENCY = complete`, and fix every warning — including the global mutable state. There is no substitute for this exercise.
5. **Bridging.** Write the cancellation-aware continuation (T4.1) and a delegate-backed `AsyncStream` with an explicit buffering policy (T2.7, T2.8).
6. **Swift 6.2.** Read SE-0461 and SE-0466, then enable Approachable Concurrency and default main-actor isolation on a real module and observe what breaks.
7. **Last, the comparison questions.** GCD vs. the cooperative pool, actors vs. locks, `Task` vs. `Task.detached`. These are the most-asked and the easiest — do them last, because they are memorisation once the model is in place.

---

## Sources

**Primary — Swift Evolution** (all retrieved in full)

1. SE-0306, *Actors* — https://github.com/swiftlang/swift-evolution/blob/main/proposals/0306-actors.md — reentrancy rationale, isolation rules, the `DecisionMaker` reentrancy example.
2. SE-0314, *AsyncStream and AsyncThrowingStream* — https://github.com/swiftlang/swift-evolution/blob/main/proposals/0314-async-stream.md — buffering policies.
3. SE-0317, *`async let` bindings* — https://github.com/apple/swift-evolution/blob/main/proposals/0317-async-let.md — implicit cancel-and-await at scope exit.
4. SE-0406, *Backpressure support for AsyncStream* — https://github.com/swiftlang/swift-evolution/blob/main/proposals/0406-async-stream-backpressure.md — **status: returned for revision**; the "no resume signal" gap.
5. SE-0430, *`sending` parameter and result values* — https://github.com/swiftlang/swift-evolution/blob/main/proposals/0430-transferring-parameters-and-results.md — implemented in Swift 6.0.
6. SE-0433, *Synchronous Mutual Exclusion Lock* (`Mutex`) — https://github.com/swiftlang/swift-evolution/blob/main/proposals/0433-mutex.md — implemented in Swift 6.0; unconditionally `Sendable`, `~Copyable`, must not suspend while held.
7. SE-0461, *Run nonisolated async functions on the caller's actor by default* — https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md — `nonisolated(nonsending)`, `@concurrent`, upcoming feature `NonisolatedNonsendingByDefault`, Swift 6.2.
8. SE-0466, *Control default actor isolation inference* — https://github.com/swiftlang/swift-evolution/blob/main/proposals/0466-control-default-actor-isolation.md — `-default-isolation MainActor`, `SwiftSetting.defaultIsolation()`, Swift 6.2.

**Primary — Apple** (retrieved in full)

9. *Embracing Swift concurrency*, WWDC25 session 268 — https://developer.apple.com/videos/play/wwdc2025/268/ — default main-actor isolation, `@concurrent`, `nonisolated` for libraries, recommended migration order.
10. *Swift concurrency: Behind the scenes*, WWDC21 session 10254 — https://developer.apple.com/videos/play/wwdc2021/10254/ — cooperative thread pool, thread explosion, the forward-progress runtime contract, semaphores as unsafe, actor hopping, priority escalation.

**Primary — not retrievable from this environment** (cited as pointers only; no claim in this report rests on them)

11. *Swift 6 Migration Guide*, swift.org — https://www.swift.org/migration/documentation/migrationguide/ — fetch returned an empty document shell.
12. *The Swift Programming Language: Concurrency* — https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/ — **[blocked by network egress]**.

**Community engineering blogs** — technically strong, not official

13. Donny Wals, "What is `@concurrent` in Swift 6.2?" — https://www.donnywals.com/what-is-concurrent-in-swift-6-2/ **[index; blocked]**
14. Donny Wals, "Structured concurrency in Swift explained" — https://www.donnywals.com/the-basics-of-structured-concurrency-in-swift-explained/ **[index]**
15. Antoine van der Lee, "Approachable Concurrency in Swift 6.2: A Clear Guide" — https://www.avanderlee.com/concurrency/approachable-concurrency-in-swift-6-2-a-clear-guide/ **[index]**
16. Matt Massicotte, "Problematic Swift Concurrency Patterns" — https://www.massicotte.org/problematic-patterns/ **[index; blocked]**
17. Emerge Tools, "Async await in Swift: The Full Toolkit" — https://www.emergetools.com/blog/posts/swift-async-await-the-full-toolkit **[index]**
18. Paul Hudson, "What's the difference between `async let`, tasks, and task groups?", *Hacking with Swift* — https://www.hackingwithswift.com/quick-start/concurrency/whats-the-difference-between-async-let-tasks-and-task-groups **[index; blocked]**
19. Paul Hudson, "How to create and use AsyncStreams to return buffered data" — https://www.hackingwithswift.com/quick-start/concurrency/how-to-create-and-use-asyncstreams-to-return-buffered-data **[index; blocked]**
20. Kodeco, *Modern Concurrency in Swift*, Ch. 5 — "Intermediate async/await & CheckedContinuation" — https://www.kodeco.com/books/modern-concurrency-in-swift/v1.0/chapters/5-intermediate-async-await-checkedcontinuation **[index]**
21. Tanaschita, "Bridging completion handlers to Swift's async/await" — https://tanaschita.com/20221205-async-await-swift-continuations/ **[index]**
22. Swift Forums, "SE-0406 review" and "AsyncStream needs a blocking buffering policy" — https://forums.swift.org/t/se-0406-backpressure-support-for-asyncstream/66771 · https://forums.swift.org/t/asyncstream-needs-a-blocking-buffering-policy/63004 **[index]**
23. Blake Crosley, "Swift 6.2 Concurrency in Practice: Default to MainActor, Escape on Purpose" — https://blakecrosley.com/blog/swift-6-2-concurrency-in-practice **[index]**
24. nsvasilev, "Demystifying Thread Hopping with Swift 6.2 Approachable Concurrency" — https://www.nsvasilev.com/posts/approachable_concurrency/ **[index]**
25. InfoQ, "Swift 6.2 Approachable Concurrency" — https://www.infoq.com/news/2025/08/swift62-approachable-concurrency **[index]**

**Interview-prep sources** — where the *questions* came from; answers not relied upon

26. dashvlas, *awesome-ios-interview* — https://github.com/dashvlas/awesome-ios-interview (English question set retrieved in full) — **entirely pre-async/await**; cited in T1.10 as evidence of stale banks.
27. Grow with Anyone, "Async/Await in iOS: Advanced Questions and Answers for Interviews" — https://growwithanyone.medium.com/async-await-in-ios-advanced-questions-and-answers-for-interviews-5fb3243c311b **[index; blocked]**
28. Md Hosne Mobarok, "100 Senior iOS Developer Technical Interview Questions (Swift Focus)" — https://medium.com/@hosnemobarok/100-senior-ios-developer-technical-interview-questions-swift-focus-5a95f57ab604 **[index]**
29. Mihai Popa, "iOS Interviews 26: Actors, Sendable, and Strict Concurrency in Swift 6" — https://medium.com/@mihaipopa/interview-26-actors-sendable-and-strict-concurrency-in-swift-6-97d951daf36f **[index]**
30. Harpreet Kaur, "iOS Interview Questions You Should Know — Part 3: Concurrency" — https://medium.com/@HarpreetVKaur/ios-interview-questions-you-should-know-part-3-04f888bf3498 **[index]**
31. Aayushi, "Swift Concurrency Interview Cheatsheet" — https://medium.com/@aayushi9555/swift-concurrency-interview-cheatsheet-16d30e258988 **[index]**
32. Sudha Chandran B C, "iOS Interview Prep 9: Concurrency and Asynchronous Programming in Swift" — https://medium.com/ios-interview-prep/ios-interview-prep-9-concurrency-and-asynchronous-programming-in-swift-93240f029474 **[index]**
33. Divyesh Vekariya, "The Complete Senior iOS Developer Interview Guide (2026)" — https://dkvekariya.medium.com/the-complete-senior-ios-developer-interview-guide-2026-3ec09ab25987 **[index]**
34. Tapos Datta, "Swift Concurrency Beyond the Basics: Task {}, Continuations, and Actor Pitfalls" — https://medium.com/@tapos-datta/swift-concurrency-beyond-the-basics-task-continuations-and-actor-pitfalls-ce15f79b3355 **[index]**
35. abdul ahad, "Understanding Actor Reentrancy in Swift Concurrency" — https://abdulahd1996.medium.com/understanding-actor-reentrancy-in-swift-concurrency-8a9459bd420a **[index]**
36. Swift Crafted, "Swift Actors: Concurrency Guide 2026" — https://swiftcrafted.dev/article/swift-actors-complete-guide-thread-safe-concurrency **[index]**
37. "iOS Concurrency Interview Questions," *Swift Rivals* — https://swiftrivals.com/concurrency/ios-concurrency-interview-questions **[blocked]**
38. *Swift Interview Prep* — https://swiftinterview.org/ **[blocked]**
39. "100+ Swift Interview Questions and Answers (2026)," *We Create Problems* — https://www.wecreateproblems.com/interview-questions/swift-interview-questions **[index]**

**Sourcing caveat.** No source in this set is company-confirmed: unlike take-home briefs, no employer publishes its concurrency question list. Items 26–39 are individual-author prep content of variable quality, and several visibly recycle one another. Every entry tagged `sourced` reflects a question that appears in that body of material; its **answer** is grounded in items 1–10. Where prep material and primary sources conflict, the primary source wins and the conflict is flagged inline (T1.10, T2.3, T2.8, T2.9). Nothing presented by any source as confidential or under NDA is reproduced here.

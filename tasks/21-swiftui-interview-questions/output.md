# SwiftUI — Interview Questions, Analysis, and Solutions

**Scope.** Interview questions and technical assessments on SwiftUI: the render and identity model, state and data flow, the Observation framework, layout, lists and performance, animation, navigation, UIKit interop, architecture and testing, and accessibility. Targets **current SwiftUI (iOS 17/18+, Swift 6)**, with the older answer noted wherever it changed. Pure Swift-language and pure concurrency questions are out of scope (they belong to `tasks/19-…` and `tasks/20-…`) except where they surface *in SwiftUI* — `.task`, `@MainActor` view models, `Sendable` in `@Observable` types. **Research performed 7 August 2026.**

**Provenance.** Each entry is tagged `sourced` (the question appears in the interview-prep material surveyed) or `added-for-coverage` (authored here to fill a gap). 25 of 33 entries are `sourced`.

**Verification status.** The code in this report **was not compiled or run.** It is written against the documented APIs cited in Sources and is intended to be correct for the version stated on each entry, but treat it as reviewed prose, not tested code.

---

## TL;DR

- **Identity is the spine of the whole subject.** Almost every hard SwiftUI question — lost `@State`, broken animations, list churn, `AnyView` costs — is an identity question wearing a different hat. Candidates who have the identity/lifetime/dependency model answer six questions with one idea.
- **The `@StateObject` vs `@ObservedObject` question is still asked constantly, and is now half-obsolete.** The strongest answer gives the ownership rule *and* says what replaces both under `@Observable`.
- **"Parent proposes, child chooses" is the expected phrase**, and the follow-up — "so what does `.frame(width:)` actually do?" — is where most candidates fail.
- **`GeometryReader` is the most commonly misused API in SwiftUI**, and interviewers know it. Reaching for it as an outer container is a reliable negative signal.
- **Performance questions have moved from folklore to measurement.** The graded answer names `Self._printChanges()`, dependency scoping, and the SwiftUI Instruments template — not a list of "avoid `AnyView`" superstitions.
- **A great deal of published SwiftUI prep material is out of date** — still teaching `NavigationView`, `ObservableObject`-only state, and the deprecated single-parameter `onChange`. Interviewers use exactly these as recency probes.
- **Where candidates most often fail:** explaining *why* `@ObservedObject var vm = VM()` is wrong (not just that it is); `ForEach(items, id: \.self)` on mutable models; expensive work in `body`; and treating `body` as a lifecycle callback rather than a pure function of state.

---

## Where these questions came from

Searches in August 2026 covered interview-prep aggregators and question banks (`shobhakartiwari/SwiftUI-Interview-Questions`, InterviewPrep, ResumeKraft, Curotec, Hyring, byby.dev), Medium/DEV interview-question series, community engineering blogs (Donny Wals, Majid Jabrayilov, Alexey Naumov, The SwiftUI Lab, fatbobman, STRV), and primary Apple material (WWDC sessions and developer documentation).

**Representativeness is limited, and in a specific direction.** No employer publishes its SwiftUI question list, so essentially all question material here is individual-author prep content. That content skews **junior and stale**: the largest public SwiftUI question bank surveyed (`shobhakartiwari/SwiftUI-Interview-Questions`) is organised around `@State`/`@Binding`/`@ObservedObject`/`@EnvironmentObject` and `NavigationView` + `NavigationLink`, with **no coverage of the Observation framework at all** — a framework that is now three OS releases old and changes the correct answer to roughly a third of its questions. Tier 3 of this report is therefore proportionally more `added-for-coverage` than Tiers 1–2: the hard questions that real senior rounds ask (invalidation granularity, `Layout`, measurement methodology) are barely represented in public prep material.

**Answers are grounded in primary sources**, principally WWDC21 "Demystify SwiftUI," WWDC23 "Demystify SwiftUI performance," WWDC23 "Discover Observation in SwiftUI," WWDC22 "The SwiftUI cookbook for navigation," and WWDC22 "Compose custom layouts with SwiftUI." Several publishers were unreachable from this environment (`hackingwithswift.com`, various Medium article bodies) and are cited from search-index summaries, marked **[index]**.

**A note on internals.** SwiftUI's exact diffing algorithm and the precise conditions under which `body` is re-invoked are **not documented**. Apple documents the *model* (identity, lifetime, dependencies) and the *guidance*; it does not document the implementation. Throughout this report, statements about the model are attributed to Apple sources; statements about observed behaviour are labelled **[community-observed]** and should be presented that way in an interview too. Claiming certainty about undocumented internals is itself a negative signal.

### Relationship to `tasks/19-swift-swiftui-interview-questions/`

Task 19's Parts D–F exist and were read. This report does not reproduce them: it adds tiering, roughly 2.5× the question count, and the render/layout/state-propagation depth a SwiftUI-focused round probes for. **Three places where this report corrects or contradicts task 19 are marked ⚠️ inline** and collected in the cross-cutting analysis.

---

## Question bank

### Tier 1 — Fundamentals

---

**T1.1 — Q: SwiftUI is declarative. What does that actually mean for how you write a view, and what is `some View`?** `sourced`

**What it's testing.** Whether "declarative" is a slogan to you or a constraint you design around.

**Answer.** A SwiftUI view is a **value** — a `struct` describing what the UI should look like for the current state — not an object you mutate. You never call "reload"; you change state, SwiftUI re-invokes `body`, and it reconciles the description against what is on screen. The practical constraint: **`body` must be cheap and free of side effects**, because it may be invoked at any time and more often than you expect.

`some View` is an opaque return type: the concrete type is a deeply nested generic (`VStack<TupleView<(Text, Button<Text>)>>`) that you neither want to write nor should depend on, but which the compiler *does* know statically. That static type is what gives SwiftUI structural identity (T2.1) and lets it diff efficiently.

```swift
struct Counter: View {
    @State private var count = 0
    var body: some View {                 // no side effects here
        Button("Tapped \(count)") { count += 1 }
    }
}
```

**Traps.** Treating `body` as `viewDidLoad` and starting network requests in it. Believing `some View` is the same as `any View`/`AnyView` — the opaque type keeps the concrete type; `AnyView` erases it (T3.2).

---

**T1.2 — Q: What's the difference between `@State` and `@Binding`?** `sourced`

**What it's testing.** Single source of truth. It is the simplest question in the set and still filters people.

**Answer.** `@State` **owns** a piece of value-type state; SwiftUI allocates storage for it outside the view struct, keyed to the view's identity, so it survives the constant recreation of the struct. `@Binding` does **not** own anything — it is a read/write reference to state owned by an ancestor, produced with the `$` projection.

```swift
struct Parent: View {
    @State private var isOn = false          // owner
    var body: some View { Toggle("On", isOn: $isOn) }   // passes a Binding
}

struct Child: View {
    @Binding var isOn: Bool                  // borrower
    var body: some View { Button("Flip") { isOn.toggle() } }
}
```

Mark `@State` `private` — it is an implementation detail of the view, and initialising it from outside is almost always a design error.

**Traps.** Passing a value down and expecting the child's mutation to be visible to the parent. Using `@State` for a reference type in pre-`@Observable` code (that was `@StateObject`'s job). Making `@State` non-private and setting it in an initialiser, which does not do what people expect — the value is only used the first time the identity appears.

---

**T1.3 — Q: `@StateObject` vs `@ObservedObject` — which do you use and why?** `sourced`

**What it's testing.** The highest-frequency SwiftUI question in the surveyed material. It is really a question about view-struct lifetime.

**Answer.** **If the view creates the object, `@StateObject`. If the view receives it, `@ObservedObject`.** SwiftUI recreates the view struct on every update; `@StateObject` initialises its object **once per view identity** and keeps it alive across those recreations, while `@ObservedObject` simply holds whatever it is given. So:

```swift
struct BadView: View {
    @ObservedObject var model = ProfileModel()   // ✗ re-created on every update: state resets,
    var body: some View { … }                    //    in-flight work restarts, "my view model keeps resetting"
}

struct GoodView: View {
    @StateObject private var model = ProfileModel()   // ✓ created once per identity
    var body: some View { … }
}
```

**The current answer must not stop there.** Under the Observation framework (iOS 17+), both are replaced: ownership becomes `@State`, and a passed-in object needs **no wrapper at all** (`let model: ProfileModel`), or `@Bindable` if you need bindings. `@StateObject`/`@ObservedObject` remain correct and non-deprecated when you support iOS 16 or earlier.

**Traps.** Giving the ownership rule with no mechanism ("`@StateObject` is more stable"). Not knowing the `@Observable` replacement — the follow-up is near-guaranteed. Believing `@StateObject`'s initialiser is lazy in a way that makes an expensive constructor free; it runs once, but on the main actor during the first update, so expensive work still belongs in `.task` (WWDC23 "Demystify SwiftUI performance").

---

**T1.4 — Q: `@EnvironmentObject` vs `@Environment` — and how do you add your own environment value?** `sourced`

**What it's testing.** Whether you can distinguish the two environment mechanisms, which the Observation framework collapsed into one.

**Answer.** Historically they were different systems: `@Environment(\.keyPath)` read framework or custom **values**, while `@EnvironmentObject` resolved an `ObservableObject` **by type**. With `@Observable`, `@Environment` does both:

```swift
@Observable final class Session { var user: User? }

ContentView()
    .environment(session)                 // not .environmentObject

struct ProfileView: View {
    @Environment(Session.self) private var session          // traps if not injected
    @Environment(\.colorScheme) private var colorScheme
    var body: some View { Text(session.user?.name ?? "—") }
}
```

For a custom value, the modern form is the `@Entry` macro (Xcode 16 / iOS 18 SDK), which replaces the `EnvironmentKey` + `EnvironmentValues` extension boilerplate:

```swift
extension EnvironmentValues {
    @Entry var userService: UserService = .live
}
```

**Traps.** Not knowing that a missing `@Environment(Type.self)` **crashes at runtime** exactly as `@EnvironmentObject` did — declare it as `Type?` if absence is legal. Using the environment as a global variable store: it is dependency injection scoped to a subtree, and everything in it becomes an invalidation source.

---

**T1.5 — Q: What is `@Observable`, and how is it different from `ObservableObject` + `@Published`?** `sourced`

**What it's testing.** The single most reliable recency probe in SwiftUI interviewing.

**Answer.** `@Observable` (Swift macro, iOS 17+) makes every stored property of a class observable with no per-property annotation. The substantive difference is **invalidation granularity**: with `ObservableObject`, any `@Published` mutation fires `objectWillChange` and invalidates **every** view observing the object. With `@Observable`, SwiftUI records **which properties each view actually read while computing `body`** and invalidates only the views that read the property that changed (WWDC23 "Discover Observation in SwiftUI").

```swift
@Observable final class CartModel {
    var items: [Item] = []
    var promoCode = ""
    var total: Decimal { items.reduce(0) { $0 + $1.price } }   // computed: tracked via `items`
}

struct TotalLabel: View {
    let model: CartModel                    // no property wrapper needed
    var body: some View { Text(model.total, format: .currency(code: "USD")) }
}                                           // typing in the promo field does NOT re-render this
```

**Migration map:** `@StateObject` → `@State` · `@ObservedObject` → plain `let` · `@EnvironmentObject` → `@Environment` · `.environmentObject(_:)` → `.environment(_:)` · `@Published` → delete · `$model.field` → `@Bindable var model` (or `@State`).

**Traps.** "It's shorthand for `ObservableObject`." Keeping `@StateObject` on an `@Observable` type — it does not conform to `ObservableObject`, so it will not compile. Assuming *every* computed property is tracked: it is tracked only if it reads tracked stored properties (T3.4).

---

**T1.6 — Q: What causes SwiftUI to re-invoke a view's `body`?** `sourced`

**What it's testing.** Whether you have a dependency model or a folk model.

**Answer.** A view's `body` is re-invoked when one of its **dependencies** changes. Dependencies are (WWDC21 "Demystify SwiftUI"):

- its own `@State` / `@StateObject` storage,
- values passed in from the parent, when the new view value differs,
- environment values it read,
- observed object properties it read.

SwiftUI builds a dependency graph whose backbone is view identity, and routes each change to just the invalidated nodes. Two consequences worth stating: a `body` re-invocation is **not** a redraw — SwiftUI still diffs the result and may render nothing; and a parent's `body` re-running does not necessarily re-run its children's, only those whose inputs changed.

**[community-observed]** `body` can also be invoked more often than a strict dependency reading would predict — during animation, layout passes with different proposals, and previews. This is why `body` must be pure. The exact conditions are not documented.

**Traps.** "It re-renders when `@State` changes" — incomplete, and misses the environment and observation paths. Treating a `body` call as equivalent to a redraw, which makes people optimise the wrong thing.

---

**T1.7 — Q: Explain SwiftUI's layout system.** `sourced`

**What it's testing.** The expected phrase is "parent proposes, child chooses." The follow-up separates the memorisers.

**Answer.** Layout is a three-step negotiation per level of the hierarchy:

1. The **parent proposes** a size (a `ProposedViewSize`, whose dimensions may be `nil`, zero, or infinity).
2. The **child chooses** its own size. A parent cannot force a size on a child.
3. The **parent places** the child within its own bounds.

The proposal values are meaningful signals, not just numbers: `nil`/`.unspecified` means "what is your ideal size?", zero means "how small can you be?", and infinity means "how large would you like to be?" — SwiftUI probes children with all three during layout (WWDC22 "Compose custom layouts").

**The follow-up: so what does `.frame(width: 100)` do?** It does **not** resize the child. `.frame` inserts a new view *around* the child that claims the 100-point width for itself and proposes 100 to the child, then positions the child inside according to the alignment (centre by default). The child may still choose to be wider and will overflow. `.fixedSize()` is the counterpart: it tells the child to ignore the proposal and take its ideal size.

**Traps.** "`.frame` sets the size of the view." Not knowing that modifier order matters because each modifier is a new wrapping view — `.padding().background(.red)` and `.background(.red).padding()` produce different results.

---

**T1.8 — Q: `VStack`, `LazyVStack`, `List` — when do you use which?** `sourced`

**What it's testing.** Whether you know what "lazy" actually buys and what it doesn't.

**Answer.**

- **`VStack`** — creates all children immediately. Correct for a handful of views.
- **`LazyVStack`** (in a `ScrollView`) — creates children as they scroll into view, but **does not release them**; created views persist until the container is destroyed. Memory and diffing cost grow monotonically with how far the user has scrolled.
- **`List`** — backed by UIKit's cell-reusing machinery (`UITableView` in iOS 13–15, `UICollectionView` from iOS 16), so it genuinely **recycles** rows, and brings swipe actions, edit mode, selection, and platform-standard styling for free.

For large or unbounded collections, `List` is the right default; published benchmarks show `LazyVStack` degrading dramatically at scale precisely because nothing is released. **But `List` is not automatically faster**: for small collections its overhead is real, and its styling is opinionated. Choose `LazyVStack` when you need a layout `List` cannot express (custom grids, non-row content, interleaved headers) and the item count is bounded.

**Traps.** "Lazy means it releases views" — it does not. Putting `.navigationDestination` inside a lazy container, where it may never be registered (T1.9). Building a chat or feed on `LazyVStack` and being surprised by memory growth.

---

**T1.9 — Q: How do you do navigation in current SwiftUI?** `sourced`

**What it's testing.** Recency, and whether your navigation state is data you own.

**Answer.** `NavigationStack` with **value-based** links (iOS 16+). A `NavigationLink` presents a *value*; a `navigationDestination(for:)` modifier maps the value's type to a view; the stack's `path` binding is an array (or `NavigationPath`) that you own.

```swift
enum Route: Hashable, Codable { case item(Item.ID), settings, profile(User.ID) }

struct RootView: View {
    @State private var path: [Route] = []
    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .item(let id):    ItemDetail(id: id)
                    case .settings:        SettingsScreen()
                    case .profile(let id): ProfileScreen(id: id)
                    }
                }
        }
        .onOpenURL { path = Route.parse($0) }     // deep link = replace the array
    }
}
```

Because the path is plain data: deep linking is assignment, pop-to-root is `path.removeAll()`, and state restoration is `Codable` on the path plus `@SceneStorage`. `NavigationSplitView` covers multi-column. `NavigationView` is deprecated (iOS 16), as is `NavigationLink(destination:isActive:)`.

**Traps.** A `@State private var showDetail = false` per destination — it cannot express an arbitrary deep link, which is the whole point of the question. Registering `navigationDestination` **inside** a `List` row or other lazy container, where it may not be installed until the row is created; register it once on the stack's root content. Storing whole model objects in the path when IDs are what survives a relaunch.

---

**T1.10 — Q: How do you load data when a view appears?** `added-for-coverage`

**What it's testing.** The one place SwiftUI and Swift concurrency meet in every app, and where `onAppear` habits persist.

**Answer.** `.task { }`, not `.onAppear { }`. `.task` runs an `async` closure when the view appears and — critically — **cancels it when the view disappears**, tying the work's lifetime to the view's. `.task(id:)` additionally cancels and restarts when the id changes, which is the idiomatic way to react to a changing input.

```swift
struct ItemDetail: View {
    let id: Item.ID
    @State private var item: Item?

    var body: some View {
        Group { if let item { DetailBody(item) } else { ProgressView() } }
            .task(id: id) { item = try? await api.item(id) }   // cancels + restarts on id change
    }
}
```

The closure is main-actor isolated by default (it inherits the view's isolation), so assigning to `@State` from it is safe without a hop.

**Traps.** `.onAppear { Task { … } }` — the task is unstructured and is **not** cancelled when the view goes away, so it keeps running and keeps `self` alive. Using `.onAppear` for data loading and being surprised it fires again on every navigation return. Not handling the error and empty states, which any Tier-4 grader looks for.

---

### Tier 2 — Intermediate

---

**T2.1 — Q: My view's `@State` resets when I toggle a condition. Why?** `sourced`

**What it's testing.** View identity and lifetime — the concept that unifies most of Tier 2 and 3.

**Answer.** SwiftUI identifies views two ways (WWDC21 "Demystify SwiftUI"):

- **Structural identity** — the view's **type and position** in the hierarchy, derived from the static generic type `ViewBuilder` produces.
- **Explicit identity** — `.id(_:)`, or the identifiers `ForEach` derives from `Identifiable`/a key path.

**Lifetime is scoped to identity, and `@State` storage is scoped to lifetime.** An `if`/`else` compiles to `_ConditionalContent<TrueBranch, FalseBranch>`: the two branches have *different* structural identities, so switching branches destroys the first view's state storage and allocates fresh storage for the second.

```swift
if isEditing {                       // ✗ two identities: state and animation continuity are lost
    RowView().opacity(0.5)
} else {
    RowView()
}

RowView()                            // ✓ one identity, two states of the same view
    .opacity(isEditing ? 0.5 : 1.0)
```

The rule Apple gives: when you write a branch, ask whether you are describing **two different views** or **two states of one view**. For the latter, use an inert modifier rather than a branch.

**Traps.** Blaming SwiftUI for "randomly losing state." Not knowing that `.id(newValue)` is the *deliberate* way to reset a subtree — and that `.id(UUID())` inside `body` mints a new identity every invocation, destroying and rebuilding the subtree continuously.

---

**T2.2 — Q: What's wrong with `ForEach(items, id: \.self)`?** `sourced`

**What it's testing.** Identifier stability and uniqueness — the most commonly planted bug in SwiftUI live coding.

**Answer.** `id: \.self` uses the element's **value** as its identity. For a mutable model, editing an item changes its value, so SwiftUI sees the old identity disappear and a new one appear: a delete plus an insert. State inside the row is lost, the row animates as a replacement rather than an update, and the storage churns. For a collection with duplicate values, two rows share an identity, which produces genuinely wrong list behaviour.

Apple's two requirements for identifiers are **stability** (does not change over time) and **uniqueness** (one identifier maps to one view):

```swift
ForEach(items, id: \.self) { ItemRow(item: $0) }   // ✗ identity == contents
ForEach(items) { ItemRow(item: $0) }               // ✓ Item: Identifiable with a persistent id
ForEach(items, id: \.serialNumber) { … }           // ✓ explicit stable, unique key
```

`id: \.self` is fine for a genuinely immutable, unique, static collection — a fixed array of enum cases, for example. Say that; blanket condemnation is a weaker answer than the rule.

**Traps.** `id: \.self` on models. Generating `UUID()` inside `body` or inside the model's computed `id`. Using an array index as the id, which is stable only until something is inserted.

---

**T2.3 — Q: When is `GeometryReader` the wrong tool?** `sourced`

**What it's testing.** Whether you understand `GeometryReader`'s own layout behaviour, not just its API.

**Answer.** `GeometryReader` reports the size **proposed to it**, and it accepts the full proposal — it is greedy. Used as an outer container it therefore expands to fill everything available, collapses its content to the top-leading corner, and destroys the parent's ability to size itself from its content. That is the failure mode behind most "my layout is suddenly full-screen" bugs.

Correct uses and alternatives:

- **Measuring a sibling's size** — put the `GeometryReader` in a `.background` or `.overlay` of the view being measured, where it inherits that view's size rather than dictating one.
- **Responsive layout** — `ViewThatFits`, `containerRelativeFrame`, or a custom `Layout` (T3.3) express the intent directly.
- **Reading a value into state** — `onGeometryChange(for:of:action:)` (iOS 18+) replaces the `GeometryReader` + `PreferenceKey` sandwich for the common case.

```swift
Text("Title")
    .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }   // iOS 18+
```

**Traps.** Wrapping a whole screen in `GeometryReader` to get the screen width. Writing measured geometry into `@State` that feeds back into the layout that produced it — an oscillation. Believing `GeometryReader` gives you the *screen*; it gives you the proposal.

---

**T2.4 — Q: How does data flow from a child up to a parent? Explain `PreferenceKey`.** `sourced`

**What it's testing.** The direction question: the environment flows down, preferences flow up. Many candidates only know the downward half.

**Answer.** A `PreferenceKey` lets a descendant publish a value that ancestors can read, with a `reduce` function that combines values from multiple children.

```swift
private struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

extension View {
    func measureWidth(_ binding: Binding<CGFloat>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
            }
        )
        .onPreferenceChange(WidthKey.self) { binding.wrappedValue = $0 }
    }
}
```

The `reduce` function is what makes this more than a callback: it defines how sibling contributions merge (max, sum, concatenation into an array), which is how "align all these labels to the widest one" is implemented.

**Traps.** Not implementing `reduce` meaningfully, so only one child's value survives. Forgetting that preference propagation happens during layout, so writing a preference into state that changes layout can loop. Using preferences where `onGeometryChange` (iOS 18+) or a plain `Binding` would do.

---

**T2.5 — Q: `.onChange(of:)` changed in iOS 17. What changed, and what should you use instead of it?** `sourced`

**What it's testing.** A precise, checkable recency fact, and a design opinion underneath it.

**Answer.** The single-parameter `onChange(of:perform:)` was **deprecated in iOS 17** in favour of two forms — a zero-parameter closure and a two-parameter `{ oldValue, newValue in }` closure — plus an `initial:` parameter controlling whether the action also runs on first appearance. The old form was ambiguous about whether its parameter was the old or new value.

```swift
.onChange(of: query) { }                                  // iOS 17+, zero-parameter
.onChange(of: query, initial: true) { old, new in … }     // iOS 17+, both values
```

The design follow-up: `onChange` is an imperative escape hatch, and much of what people use it for is better expressed declaratively. Deriving one value from another belongs in a computed property; restarting async work on an input change belongs in `.task(id:)` (T1.10), which also cancels the previous run — something `onChange` gives you no help with.

**Traps.** Using `onChange` to keep two pieces of `@State` in sync, creating two sources of truth. Not knowing the deprecation, which flags a candidate as pre-iOS-17.

---

**T2.6 — Q: Explain implicit vs. explicit animation. Why does my animation glitch?** `sourced`

**What it's testing.** Whether you understand that SwiftUI animates *state changes*, not views.

**Answer.**

- **Explicit:** `withAnimation { state.toggle() }` — animates everything that changes as a result of *this* state change, anywhere in the hierarchy.
- **Implicit:** `.animation(_:value:)` on a view — animates that subtree's changes, but only when the specified `value` changes.

The value-less `.animation(_:)` was deprecated (iOS 15) precisely because it animated *every* change in the subtree, including unrelated ones — the classic source of "why is my whole screen sliding?"

```swift
Circle()
    .scaleEffect(isBig ? 2 : 1)
    .animation(.spring, value: isBig)     // ✓ scoped to isBig
```

**Why animations glitch,** in rough order of frequency: (1) **the identity changed** rather than the value — an `if`/`else` or an unstable `ForEach` id means SwiftUI sees a removal and an insertion, not an interpolation (T2.1, T2.2); (2) the animated property is derived from a value that changes in steps rather than continuously; (3) two animations with different `Transaction`s collide. `Transaction` is the mechanism underneath both forms, and `.transaction { }` lets you inspect or override the animation attached to an update — useful when a parent's `withAnimation` is animating a child you want to stay still.

**Traps.** Wrapping the *view creation* rather than the *state mutation* in `withAnimation`. Using the deprecated value-less `.animation(_:)`. Expecting `.transition` to fire without an identity change — transitions apply on insertion/removal.

---

**T2.7 — Q: What is `matchedGeometryEffect` for, and when does it fail?** `added-for-coverage`

**What it's testing.** Advanced animation, and — again — identity.

**Answer.** `matchedGeometryEffect(id:in:)` interpolates geometry between two views that share an id within a `@Namespace`, producing a hero-style transition even though the two views are structurally unrelated:

```swift
struct Gallery: View {
    @Namespace private var ns
    @State private var expanded: Photo?

    var body: some View {
        ZStack {
            if let photo = expanded {
                DetailView(photo: photo)
                    .matchedGeometryEffect(id: photo.id, in: ns)
            } else {
                Grid { ForEach(photos) { photo in
                    Thumb(photo).matchedGeometryEffect(id: photo.id, in: ns)
                } }
            }
        }
    }
}
```

It fails when **both views with the same id are on screen simultaneously** (SwiftUI cannot decide which is the source of truth), when the two are in different `@Namespace`s, or when the change is not inside an animation transaction. Since iOS 18, `NavigationTransition`/zoom transitions handle the common push-a-detail case more robustly and should be preferred where they fit.

**Traps.** Using it across a sheet or navigation boundary, where the two views are not in the same rendering context. Reusing an id across items.

---

**T2.8 — Q: Wrap a UIKit view for SwiftUI. What are `makeUIView`, `updateUIView`, and the `Coordinator` responsible for?** `sourced`

**What it's testing.** Interop mechanics and the update-loop trap. In a UIKit-heavy codebase this is a daily task, so it is asked often.

**Answer.** `makeUIView` is called **once** to create and configure the view. `updateUIView` is called **whenever the SwiftUI state the representable depends on changes** — it must be idempotent and must not blindly write values back. The `Coordinator` is the `NSObject` that owns delegate/target-action conformances, since a `struct` cannot be a UIKit delegate.

```swift
struct GrowingTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.isScrollEnabled = false            // let it grow instead of scrolling
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ view: UITextView, context: Context) {
        if view.text != text { view.text = text }        // guard: without this you loop
        let fitting = view.sizeThatFits(
            CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)
        )
        if height != fitting.height {
            DispatchQueue.main.async { height = fitting.height }   // don't mutate state during layout
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }

    final class Coordinator: NSObject, UITextViewDelegate {
        private let text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        func textViewDidChange(_ textView: UITextView) { text.wrappedValue = textView.text }
    }
}
```

Two graded details beyond the boilerplate: the **write-back guard** in `updateUIView` (delegate sets the binding → SwiftUI updates → `updateUIView` sets the text → delegate fires → infinite loop), and the fact that **mutating SwiftUI state from inside `updateUIView` is mutating state during a layout pass**, which SwiftUI warns about — defer it. Going the other direction, `UIHostingController` embeds SwiftUI in UIKit, and its `sizingOptions` gives it an intrinsic content size that older code had to compute by hand.

**Traps.** Storing state in the representable struct — it is recreated constantly; state belongs in the `Coordinator` or in SwiftUI. Recreating the UIKit view in `updateUIView`. Forgetting `dismantleUIView` for teardown of observers or timers.

---

**T2.9 — Q: How do you get a `Binding` into an `@Observable` object's property?** `added-for-coverage`

**What it's testing.** A small but universally hit mechanic in the post-Observation world, and one prep material almost never covers.

**Answer.** `@Bindable`. A plain `let model: Model` gives you read access but no `$` projection; `@Bindable` adds it without claiming ownership.

```swift
struct EditForm: View {
    @Bindable var donut: Donut               // does not own; just projects bindings
    var body: some View { TextField("Name", text: $donut.name) }
}
```

If the view **owns** the object, `@State` already projects bindings, so `@Bindable` is unnecessary. If the object comes from the environment, you need a local rebinding, because `@Environment` alone does not project:

```swift
struct SettingsScreen: View {
    @Environment(Session.self) private var session
    var body: some View {
        @Bindable var session = session      // local shadow to get the projection
        Toggle("Notifications", isOn: $session.notificationsEnabled)
    }
}
```

**Traps.** Reaching for `@ObservedObject`, which does not compile against an `@Observable` type. Not knowing the `@Bindable var x = x` shadowing idiom for environment objects — it looks strange and is the documented approach.

---

**T2.10 — Q: Your `@Observable` view model is `@MainActor`. What breaks under Swift 6?** `added-for-coverage`

**What it's testing.** The SwiftUI/concurrency seam — explicitly in scope for this report, and a live source of friction in real migrations.

**Answer.** Two things bite in practice.

**1. Initialising a `@MainActor` model in a stored-property initialiser.** `View` is a `struct` whose `body` is main-actor isolated, but the struct's *stored property initialisers* are not, so under Swift 6 strict checking `@State private var model = MainActorModel()` can be rejected as calling a main-actor-isolated initialiser from a non-isolated context. The fixes: mark the view `@MainActor`, make the model's `init` `nonisolated` when it touches no isolated state, or (Swift 6.2) build the module with default main-actor isolation, which is the direction Apple is steering new projects.

**2. `Sendable` requirements on model payloads.** The moment your model calls a `nonisolated` async API, the values crossing that boundary must be `Sendable`. This is why domain models want to be value types.

```swift
@MainActor @Observable
final class FeedModel {
    private(set) var items: [Item] = []            // Item must be Sendable
    private let load: @Sendable () async throws -> [Item]

    nonisolated init(load: @escaping @Sendable () async throws -> [Item]) {
        self.load = load                           // nonisolated: constructible from anywhere
    }

    func refresh() async {
        items = (try? await load()) ?? []          // hops back to the main actor automatically
    }
}
```

**Traps.** Sprinkling `DispatchQueue.main.async` inside a `@MainActor` type. Marking the model `@unchecked Sendable` to silence errors instead of isolating it. Putting `@MainActor` on the *networking* layer so the compiler stops complaining — that moves real work onto the main thread.

---

### Tier 3 — Advanced / senior-level

---

**T3.1 — Q: A screen re-renders too much. Walk me through diagnosing it.** `sourced`

**What it's testing.** Methodology. The wrong answer is a list of optimisations; the right answer is a measurement loop.

**Answer.** Apple's framing is symptom → measure → identify cause → optimise → re-measure. Concretely:

1. **Reproduce and measure first.** Use the SwiftUI template in Instruments (view body counts, update groups) or profile the hitch. Do not change code before you know which bodies run.
2. **Find out *why* a body ran.** `let _ = Self._printChanges()` at the top of `body` prints which dependency triggered the update. It is **undocumented and debug-only — never ship it** (WWDC23 "Demystify SwiftUI performance"); you can also call it from LLDB as `expression Self._printChanges()`.
3. **Classify the cause.** Three buckets: too many *invalidations* (dependency scope too wide), too much *work in `body`*, or slow *identification* (`List`/`ForEach` churn).
4. **Scope dependencies.** Pass a view the narrowest data it needs — `var image: Image`, not `var dog: Dog` — and extract subviews so an unrelated property change stops invalidating them. Migrating to `@Observable` does much of this automatically (T1.5).
5. **Get work out of `body`.** Sorting, filtering, `DateFormatter` construction, string building — hoist to the model or into `.task`.
6. **Re-measure.**

```swift
struct RowView: View {
    var body: some View {
        let _ = Self._printChanges()      // debug only; remove before shipping
        …
    }
}
```

**Traps.** Optimising by adding `EquatableView` before knowing what is slow (T3.3). Equating "body ran" with "pixels redrew." Shipping `_printChanges`.

---

**T3.2 — Q: What does `AnyView` actually cost?** `sourced`

**What it's testing.** Whether you can distinguish a mechanism from a superstition. Almost everyone says "AnyView is slow"; few can say why, and the common explanation is wrong.

**Answer.** `AnyView` erases the static type of its content. Since **structural identity is derived from that static type**, SwiftUI loses the ability to tell that "the view here last time and the view here now" are the same kind of thing. Three real consequences:

1. **Identity and state loss.** Two branches wrapped in `AnyView` present the same erased type, so SwiftUI cannot use the type structure to distinguish them; state and animation continuity across updates become unreliable.
2. **List/Table row counting.** A `List` needs the number of rows per element to be statically determinable. `AnyView` hides it, so `List` must build all the views to discover the identifiers — defeating exactly the laziness you wanted (WWDC23).
3. **Compile-time diagnostics and inlining** are worse, because the concrete type is gone.

⚠️ **Correction to task 19 Part E4**, which states that `AnyView` "defeats structural diffing" as a general performance claim. The identity and List consequences above are real and documented; the implication that diffing an `AnyView` is *inherently* much slower is not supported — published micro-benchmarks comparing `AnyView` against a `Group`-based conditional found their diffing performance "practically the same," with `EquatableView` the only variant that moved the needle. The accurate senior answer is that **`AnyView`'s cost is structural (identity and laziness), not arithmetic (diff speed)**, and that this is what makes it bad in `List` rows specifically.

The fix is nearly always `@ViewBuilder`:

```swift
@ViewBuilder                                  // ✓ preserves _ConditionalContent structure
func cell(for dog: Dog) -> some View {
    if dog.likesFetch { FetchCell(dog) } else { NapCell(dog) }
}
```

Legitimate uses remain: heterogeneous collections built at runtime, and breaking type-checker blowups in very large bodies — though extracting a subview is usually the better fix.

**Traps.** Reciting "AnyView is slow" with no mechanism. Believing `some View` and `AnyView` are equivalent.

---

**T3.3 — Q: What does `EquatableView` do, and when does it backfire?** `sourced`

**What it's testing.** A genuinely advanced optimisation that is easy to apply incorrectly — a good senior filter.

**Answer.** Making a view `Equatable` and wrapping it (`.equatable()` or `EquatableView`) tells SwiftUI to use **your** `==` to decide whether the view changed, instead of its own comparison of the view's stored properties. It pays off when computing `body` is much more expensive than the equality check.

```swift
struct ExpensiveChart: View, Equatable {
    let samples: [Sample]
    let highlighted: Sample.ID?

    static func == (a: Self, b: Self) -> Bool {
        a.highlighted == b.highlighted && a.samples.count == b.samples.count   // ⚠️ approximation
    }

    var body: some View { /* expensive */ }
}
```

**When it backfires:** an `==` that is *cheaper than correct* — like the `count`-based one above — makes SwiftUI skip updates it should have performed, producing stale UI that is extremely hard to debug. A correct-but-expensive `==` over a large array can also cost more than the body it saves. And an `Equatable` view whose real dependencies include environment values or observed objects is comparing the wrong thing entirely, because those inputs are not stored properties and your `==` cannot see them.

**Traps.** Applying it prophylactically instead of after measuring (T3.1). Writing an `==` that ignores a property the body reads.

---

**T3.4 — Q: What exactly does `@Observable` track, and where does the tracking miss?** `added-for-coverage`

**What it's testing.** Depth on the framework that replaced the framework most candidates learned. Prep material covers "what is `@Observable`"; nobody covers its edges.

**Answer.** The macro rewrites each stored property's accessors to call `access(keyPath:)` on read and `withMutation(keyPath:)` on write. SwiftUI wraps each `body` evaluation in observation tracking, records the (instance, keyPath) pairs read, and registers an invalidation for exactly those.

Four consequences, in increasing subtlety:

1. **Reads must happen inside `body`** (or another tracked scope) to be registered. A property read in an initialiser, in `onAppear`, or inside a closure that runs later does **not** create a dependency.
2. **Computed properties are tracked transitively** — only because reading them reads tracked stored properties. A computed property backed by something *else* (a singleton, `UserDefaults`, a C API) is invisible to tracking; you must call `access`/`withMutation` manually.
3. **Collections track the container, not the elements** — unless the elements are themselves `@Observable`, in which case each element's property reads are tracked per instance. `var items: [Item]` where `Item` is a struct invalidates on any mutation of the array.
4. **Non-`@Observable` nested reference types are opaque.** Mutating a property of a plain class held by an `@Observable` model changes nothing observable, and the UI silently fails to update — this is the single most common "why isn't my view updating?" bug in migrated code.

```swift
@Observable final class Model {
    var name = ""                        // tracked
    private var raw = Settings()         // plain class: NOT tracked

    var theme: String {                  // manual tracking required
        get { access(keyPath: \.theme); return raw.theme }
        set { withMutation(keyPath: \.theme) { raw.theme = newValue } }
    }
}
```

**Traps.** Assuming `@Observable` makes an object graph deeply observable. Reading a property outside `body` and expecting invalidation. Assuming per-property tracking means you can stop thinking about view extraction — narrow views still matter, because the tracked scope is one whole `body`.

---

**T3.5 — Q: Implement a custom `Layout`. What is the contract?** `sourced`

**What it's testing.** Whether the layout model from T1.7 is deep enough to implement, not just describe.

**Answer.** Two required methods (iOS 16+):

- `sizeThatFits(proposal:subviews:cache:)` — report your size given a proposal, having asked each subview proxy what *it* wants.
- `placeSubviews(in:proposal:subviews:cache:)` — place each subview at a point with an anchor and a proposal. **`bounds.origin` is not necessarily `(0,0)`** — always place relative to `bounds.minX`/`minY`.

```swift
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.replacingUnspecifiedDimensions().width
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0; y += rowHeight + spacing; rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize,
                       subviews: Subviews, cache: inout Void) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX; y += rowHeight + spacing; rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), anchor: .topLeading,
                          proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
```

**Graded extras.** The `cache` parameter exists so `sizeThatFits` and `placeSubviews` can share expensive intermediate results — add it when Instruments says to, not before. `LayoutValueKey` passes per-subview data from the view tree into the layout. `AnyLayout` swaps between layout types *while preserving view identity*, so the change animates instead of teleporting. And knowing `ViewThatFits` and `Grid` exist is part of the answer — a custom `Layout` you did not need to write is the best answer of all.

**Traps.** Ignoring `bounds.origin`. Calling `subview.sizeThatFits` with a hard-coded proposal instead of `.unspecified` when you want the ideal size. Writing a `Layout` for something `ViewThatFits` already does.

---

**T3.6 — Q: How do you architect a SwiftUI app? Do view models belong in SwiftUI?** `sourced`

**What it's testing.** Judgement on a genuinely contested question. An interviewer asserting one right answer is testing conformity; you should present the trade-off.

**Answer — and this is contested, so say so.** Three defensible positions:

- **MVVM with `@Observable`** — a `@MainActor @Observable` model per screen, owned with `@State`, dependencies constructor-injected. The current mainstream default: cheap, testable, no third-party dependency. Its failure mode is the Massive View Model; keep formatting in the view and side effects in services.
- **No view model** — `@State` plus `.task` plus small extracted views. The argument, which has real weight, is that a SwiftUI `View` **is** already a view model: it is a value describing UI as a function of state, with its own dependency tracking, so a parallel object duplicates machinery. Correct for simple screens; strains when a screen has genuine multi-step logic to test.
- **TCA (or a similar unidirectional library)** — exhaustive state modelling, time-travel debugging, excellent testability, at the cost of a steep learning curve, compile times, and a hard external dependency. Defensible in a large team with strong conventions; expensive in a small one.

Whichever you pick, the SwiftUI-specific mechanics are the same: dependencies through `@Environment` or the initialiser, navigation state as data you own (T1.9), and no `import SwiftUI` in the layer below the view model.

**Traps.** Declaring one architecture universally correct. Being unable to name a downside of your own preference — the single most reliable senior signal in this question. Putting navigation in the view model *and* in the view.

---

**T3.7 — Q: What can and can't you unit-test in SwiftUI?** `sourced`

**What it's testing.** Realism. SwiftUI has no first-party view-testing API, and the honest answer says so.

**Answer.** Split it three ways:

- **Testable directly:** everything in the model layer — an `@Observable` view model's state transitions, formatting, and the reducer-ish logic that decides what to show. This is the main argument for having a view model at all.
- **Testable indirectly:** rendered output, via **snapshot tests** — good at catching layout regressions across Dynamic Type sizes and locales, bad at asserting behaviour, and brittle across OS releases.
- **Not meaningfully unit-testable:** gesture handling, animation timing, and the framework's own layout. Cover these with UI tests (XCUITest) sparingly, since they are slow and flaky.

Determinism is the practical problem, and it is a concurrency problem: inject a clock rather than sleeping, and give the model a way to await its in-flight work.

⚠️ **Correction to task 19 Part F2.** That entry's test uses `ImmediateClock()`. There is no `ImmediateClock` in the Swift standard library — it comes from Point-Free's `swift-clocks` package. Injecting `any Clock<Duration>` is the right idea, but with the stdlib alone you must supply your own test clock (or inject the sleep as a closure). Presenting `ImmediateClock` as a language feature in an interview would be a factual error.

```swift
@MainActor @Test func searchPopulatesResults() async {
    let model = SearchModel(search: { _ in [Item.fixture] }, sleep: { _ in })   // no clock package needed
    await model.run("swift")
    #expect(model.results.count == 1)
}
```

**Traps.** Claiming SwiftUI views are "fully testable." Tests that sleep. Snapshot suites so large that every OS update produces a day of triage.

---

**T3.8 — Q: How do you make a SwiftUI screen accessible, and why is this asked in senior rounds?** `sourced`

**What it's testing.** Whether accessibility is a checklist or a design input. It appears in senior rounds because it is where "I ship real apps" and "I follow tutorials" diverge.

**Answer.** SwiftUI gives you a great deal by default — standard controls are labelled, Dynamic Type works with semantic fonts, and the accessibility tree is derived from the view tree. Your job is the places where the default is wrong:

```swift
Button { like() } label: { Image(systemName: "heart") }
    .accessibilityLabel("Like")                              // icon-only buttons have no label

HStack { Image(avatar); VStack { Text(name); Text(subtitle) } }
    .accessibilityElement(children: .combine)                // one element, not three
    .accessibilityHint("Opens the profile")

DecorativeSwoosh().accessibilityHidden(true)
```

The senior-level points: **Dynamic Type is a layout problem, not a font problem** — use semantic fonts, let text wrap, cap with `.dynamicTypeSize(...upTo:)` rather than fixed point sizes, and test at the accessibility sizes where fixed-height rows break; honour `@Environment(\.accessibilityReduceMotion)` in animations and `accessibilityReduceTransparency` in materials; and use `.accessibilityRepresentation` when a custom control should announce as a standard one. Verify with VoiceOver and the Accessibility Inspector's audit, not by reading the code.

**Traps.** Adding labels and stopping. Fixed `.frame(height:)` on rows containing text — the most common Dynamic Type break. Treating accessibility as a post-launch task, which is the answer that ends the topic badly.

---

### Tier 4 — Coding assessments / take-home style

---

**T4.1 — Task: Build a searchable list screen backed by an async API.** `sourced`

**What it's testing.** The most common SwiftUI take-home shape. Graders look at state modelling, cancellation, and whether you handled the states other than "success."

```swift
@MainActor @Observable
final class SearchModel {
    enum State: Equatable { case idle, loading, empty, loaded([Item]), failed(String) }

    var query = ""
    private(set) var state: State = .idle

    private let search: @Sendable (String) async throws -> [Item]
    private let sleep: @Sendable (Duration) async throws -> Void

    nonisolated init(
        search: @escaping @Sendable (String) async throws -> [Item],
        sleep: @escaping @Sendable (Duration) async throws -> Void = { try await Task.sleep(for: $0) }
    ) {
        self.search = search
        self.sleep = sleep
    }

    func run(_ text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { state = .idle; return }
        state = .loading
        do {
            try await sleep(.milliseconds(300))          // debounce; cancelled if the query changes
            let results = try await search(trimmed)
            state = results.isEmpty ? .empty : .loaded(results)
        } catch is CancellationError {
            return                                       // superseded: leave state to the new run
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

struct SearchScreen: View {
    @State private var model = SearchModel(search: API.search)

    var body: some View {
        Group {
            switch model.state {
            case .idle:               ContentUnavailableView("Search", systemImage: "magnifyingglass")
            case .loading:            ProgressView()
            case .empty:              ContentUnavailableView.search(text: model.query)
            case .loaded(let items):  List(items) { ItemRow(item: $0) }
            case .failed(let message):
                ContentUnavailableView("Couldn't load", systemImage: "exclamationmark.triangle",
                                       description: Text(message))
            }
        }
        .searchable(text: $model.query)
        .task(id: model.query) { await model.run(model.query) }
    }
}
```

**Grading points.** `.task(id:)` gives cancellation of the superseded request for free — this is the difference between a correct answer and a working one, because without it results arrive out of order and the slowest response wins. State is **one enum**, not four booleans, so impossible combinations cannot be represented. Empty and error states exist. The debounce is injected, so the model is testable without sleeping (T3.7). Note the `CancellationError` catch: swallowing it in a generic `catch` would flash an error banner every keystroke — and be ready to say that a `URLSession` cancellation surfaces as `URLError.cancelled`, not `CancellationError`.

**Traps.** Debouncing with `onChange` + a manually managed `Task`. `isLoading`/`hasError`/`isEmpty` as separate `@State`. No cancellation, then blaming flicker on SwiftUI.

---

**T4.2 — Task: This view re-renders on every keystroke and drops frames. Fix it.** `sourced`

```swift
struct FeedScreen: View {                        // before
    @State private var query = ""
    let posts: [Post]

    var body: some View {
        VStack {
            TextField("Filter", text: $query)
            List(posts.filter { $0.title.contains(query) }.sorted { $0.date > $1.date }) { post in
                PostRow(post: post, formatter: DateFormatter())
            }
        }
    }
}
```

**What it's testing.** The T3.1 methodology applied to a planted bug. Four defects, and graders count how many you find.

1. **Filtering and sorting run in `body`** — on every keystroke, over the whole collection.
2. **A `DateFormatter` is constructed per row, per update** — formatter construction is notoriously expensive.
3. **The `TextField` and the `List` share one `body`**, so every keystroke invalidates the entire screen including rows whose content did not change.
4. **`posts` is passed whole to `PostRow`** if the row only needs a title and a date — an over-wide dependency.

```swift
@Observable @MainActor
final class FeedModel {                          // after
    var query = "" { didSet { recompute() } }
    private(set) var visible: [Post] = []
    private let all: [Post]

    init(posts: [Post]) { all = posts; recompute() }

    private func recompute() {
        visible = all.lazy
            .filter { query.isEmpty || $0.title.localizedCaseInsensitiveContains(query) }
            .sorted { $0.date > $1.date }
    }
}

struct FeedScreen: View {
    @State private var model: FeedModel

    var body: some View {
        VStack {
            FilterField(model: model)            // extracted: owns the keystroke invalidation
            List(model.visible) { PostRow(title: $0.title, date: $0.date) }
        }
    }
}

struct PostRow: View {
    let title: String
    let date: Date                               // narrow dependencies
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(date, format: .dateTime.day().month().year())   // no DateFormatter allocation
        }
    }
}
```

**Grading points.** Say how you'd *verify* it — `Self._printChanges()` to confirm which body reruns, Instruments to confirm the win — rather than asserting the fix works. Mention that with `@Observable`, `FilterField` reading `model.query` and `List` reading `model.visible` means a keystroke that does not change the filtered set invalidates only the field. If the collection is genuinely large, move `recompute` off the main actor and back.

**Traps.** Reaching for `EquatableView` or `AnyView` removal first. Caching the formatter in a global but leaving the sort in `body`.

---

**T4.3 — Task: Implement a wrapping tag ("flow") layout.** `sourced`

**What it's testing.** Whether you can implement the layout contract rather than fake it with `GeometryReader` and hard-coded widths.

**Answer.** The `FlowLayout` in **T3.5** is the expected solution; use it here. Points beyond the code:

- **Why not `GeometryReader`?** Because a flow layout needs to *report its own height* back to its parent, and a `GeometryReader` accepts the parent's proposal instead of choosing — you end up computing height in state, feeding it back into a `.frame`, and oscillating.
- **Why `.unspecified`?** Tags should take their ideal width; proposing a concrete width would let them stretch.
- **Follow-up they will ask:** "What if a single tag is wider than the container?" It overflows — a child chooses its own size and the parent cannot force it. Handle it by proposing a bounded width to over-wide subviews (`ProposedViewSize(width: maxWidth, height: nil)`) so `Text` can truncate or wrap.
- **Follow-up two:** "Make it animate when the container width changes." Wrap in `AnyLayout` if you are swapping layout types, and ensure the tags' identities are stable so SwiftUI interpolates positions rather than replacing views.

**Traps.** Computing positions in `sizeThatFits` and recomputing them differently in `placeSubviews` — the two must agree. Ignoring `bounds.origin`. Hard-coding a container width.

---

**T4.4 — Task: Wrap a UIKit control with `UIViewRepresentable`, including its delegate.** `sourced`

**What it's testing.** Interop under real conditions — the update loop, the coordinator, and reporting size back.

**Answer.** The `GrowingTextView` in **T2.8** is the expected solution. What graders look for beyond compiling code:

- The **write-back guard** in `updateUIView`.
- The `Coordinator` as the delegate owner, constructed in `makeCoordinator`, with `context.coordinator` wired in `makeUIView`.
- Not mutating SwiftUI state synchronously during `updateUIView`.
- `dismantleUIView(_:coordinator:)` if there is anything to tear down (observers, timers, KVO).
- Knowing the reverse direction: `UIHostingController` for embedding SwiftUI in UIKit, and its `sizingOptions` for intrinsic sizing.

**The incremental-adoption follow-up** is common in UIKit-heavy shops: adopt SwiftUI **leaf-first** — new screens hosted in `UIHostingController` inside the existing navigation stack — rather than trying to convert the navigation layer, which is where UIKit and SwiftUI disagree most.

**Traps.** Putting mutable state in the representable struct. Recreating the UIKit view in `updateUIView`. Assuming the representable is retained — it is a value recreated on every update.

---

**T4.5 — Task: Migrate this `ObservableObject` view model to `@Observable`.** `sourced`

```swift
final class ProfileViewModel: ObservableObject {          // before
    @Published var user: User?
    @Published var isLoading = false
    @Published var draftName = ""
}

struct ProfileScreen: View {
    @StateObject private var vm = ProfileViewModel()
    var body: some View {
        VStack {
            TextField("Name", text: $vm.draftName)
            SummaryView(vm: vm)
        }
    }
}
struct SummaryView: View {
    @ObservedObject var vm: ProfileViewModel
    var body: some View { Text(vm.user?.name ?? "—") }
}
```

**What it's testing.** Whether the migration is mechanical to you, and whether you can name what actually improves.

```swift
@Observable @MainActor                                     // after
final class ProfileViewModel {
    var user: User?
    var isLoading = false
    var draftName = ""
}

struct ProfileScreen: View {
    @State private var vm = ProfileViewModel()             // was @StateObject
    var body: some View {
        @Bindable var vm = vm                              // for the $ projection
        VStack {
            TextField("Name", text: $vm.draftName)
            SummaryView(vm: vm)
        }
    }
}
struct SummaryView: View {
    let vm: ProfileViewModel                               // was @ObservedObject; no wrapper needed
    var body: some View { Text(vm.user?.name ?? "—") }
}
```

**Grading points.** State the behavioural win precisely: **before**, typing in the `TextField` mutated `draftName`, fired `objectWillChange`, and re-rendered `SummaryView` on every keystroke; **after**, `SummaryView` reads only `user`, so it is not invalidated at all. Then name the migration hazards: `@Observable` types do **not** conform to `ObservableObject`, so `@StateObject`/`@ObservedObject`/`@EnvironmentObject` and any `.objectWillChange` subscribers stop compiling; `.environmentObject(_:)` becomes `.environment(_:)`; Combine pipelines built on `$published` publishers have no direct equivalent and must be rewritten (typically as `.task(id:)` or `withObservationTracking`); and the deployment target rises to iOS 17. If the app must support iOS 16, you cannot migrate — say so rather than inventing a backport.

**Traps.** Keeping `@Published` (it does nothing and adds a Combine dependency). Forgetting `@Bindable` and wondering where `$` went. Migrating half the graph, so an `@Observable` model holds an `ObservableObject` child whose changes never propagate.

---

## Cross-cutting analysis

**Which concepts dominate.** The surveyed material is heavily weighted toward **state and data flow**: `@State`/`@Binding`/`@StateObject`/`@ObservedObject`/`@EnvironmentObject` account for a large share of every question bank, with declarative-vs-imperative and SwiftUI-vs-UIKit close behind. Layout appears mostly as the single phrase "parent proposes, child chooses"; performance appears as folklore lists; the Observation framework, `Layout`, and measurement methodology are almost absent. That distribution reflects what is easy to write a blog post about. The topics that actually distinguish engineers — identity, invalidation scope, and measurement — are exactly the ones prep material under-serves, which is good news for anyone willing to learn them.

**Which topics separate junior from senior.** The line is **whether identity is in your model of the framework.** Junior answers describe property wrappers as a lookup table ("use this one when…"); senior answers explain that the view struct is ephemeral, that storage is keyed to identity, and that this single fact explains `@StateObject`, `if`/`else` state loss, `ForEach` id churn, `AnyView`'s cost, and half of all animation bugs. The three highest-separation questions in this bank are **T2.1 (identity and lost state)**, **T3.2 (what `AnyView` actually costs)**, and **T3.4 (where `@Observable` tracking misses)** — none can be answered from API familiarity.

**How Observation and `NavigationStack` changed what gets asked.** Both created a **recency seam**, and interviewers now use them deliberately. `@Observable` did not just rename things: it changed the *unit of invalidation* from the object to the property, which makes "why is my view re-rendering?" a different question than it was in 2022. `NavigationStack` changed navigation from a tree of booleans into a value you own, which turned deep linking and state restoration from hard problems into array manipulation — so those are now *reasonable* interview questions where before they were unfair ones. The practical effect: a candidate whose answers are all pre-iOS-16 is identifiable within two questions, and much published prep material would fail that test.

**Misconceptions that recur across sources.** Five appear repeatedly in the prep material itself, not merely in candidate answers:

- **"`.frame` sets the view's size."** It does not; it wraps (T1.7).
- **"`LazyVStack` is the efficient one."** Lazy means deferred creation, not recycling; `LazyVStack` never releases (T1.8).
- **"`AnyView` is slow."** The cost is structural — identity loss and defeating `List`'s static row counting — not diff arithmetic (T3.2).
- **"`@Observable` is shorthand for `ObservableObject`."** It changes invalidation granularity, which is the whole point (T1.5).
- **Deprecated APIs presented as current** — `NavigationView`, `NavigationLink(isActive:)`, the single-parameter `onChange`, the value-less `.animation(_:)`. The largest public SwiftUI question bank surveyed still teaches the first two.

**Where this report corrects task 19's Parts D–F.** Two corrections and one refinement:

1. **Part E4** treats `AnyView` as a general performance problem ("defeats structural diffing"). The documented costs are identity loss and `List` row-count opacity; comparative benchmarks show diffing cost roughly on par with a `Group`-based conditional. The correction matters because it changes *where* you avoid `AnyView` — critically in `List`/`ForEach` rows, much less so in a one-off branch (T3.2).
2. **Part F2** uses `ImmediateClock()` in a test as though it were standard library. It is from Point-Free's `swift-clocks`. The injection idea is right; the type is not first-party (T3.7).
3. **Refinement, not a contradiction:** Part E1 describes structural identity as "position in the tree." Apple's formulation is **type *and* position** — the type half is what `AnyView` erases and what `_ConditionalContent` splits, so it is the operative half in exactly the cases the question is about (T2.1).

Everything else checked in task 19's Parts D–F — the `@StateObject` mechanism, the `@Observable` migration map, the `.frame` explanation, the `GeometryReader`-in-a-background pattern, the `NavigationStack` router, the `updateUIView` write-back guard — is correct as written.

---

## Version-shift notes

The seams interviewers probe. The left column is the answer that *used* to be right.

| Topic | Older answer | Current answer | Since |
|---|---|---|---|
| Navigation container | `NavigationView` | `NavigationStack` / `NavigationSplitView` | iOS 16 |
| Programmatic navigation | `NavigationLink(destination:isActive:)` | value links + `navigationDestination(for:)` + `path` | iOS 16 |
| Object observation | `ObservableObject` + `@Published` | `@Observable` (per-property tracking) | iOS 17 |
| Owning a model object | `@StateObject` | `@State` | iOS 17 |
| Passing a model down | `@ObservedObject` | plain `let` | iOS 17 |
| Bindings into a model | `$vm.field` via `@ObservedObject` | `@Bindable` (or `@State`) | iOS 17 |
| Environment objects | `@EnvironmentObject` / `.environmentObject` | `@Environment(T.self)` / `.environment` | iOS 17 |
| Custom environment value | `EnvironmentKey` + `EnvironmentValues` extension | `@Entry` macro | Xcode 16 / iOS 18 SDK |
| Reacting to a value change | `onChange(of:perform:)` (one parameter) | `onChange(of:) { }` or `{ old, new in }`, plus `initial:` | iOS 17 |
| Implicit animation | `.animation(_:)` (no value) | `.animation(_:value:)` | iOS 15 (deprecation) |
| Multi-step animation | chained `withAnimation` + delays | `PhaseAnimator`, `KeyframeAnimator` | iOS 17 |
| Custom layout | `GeometryReader` + manual math | `Layout` protocol, `Grid`, `ViewThatFits`, `AnyLayout` | iOS 16 |
| Measuring a child | `GeometryReader` + `PreferenceKey` | `onGeometryChange(for:of:action:)` | iOS 18 |
| Scroll control | `ScrollViewReader` only | `scrollPosition(id:)`, `scrollTargetBehavior` | iOS 17 |
| Empty/error states | hand-rolled `VStack` | `ContentUnavailableView` | iOS 17 |
| Persistence in SwiftUI | Core Data + `@FetchRequest` | SwiftData `@Model` + `@Query` | iOS 17 |
| Async work on appear | `.onAppear { Task { … } }` | `.task { }` / `.task(id:)` (auto-cancelling) | iOS 15 |
| Main-thread hop | `DispatchQueue.main.async` | `@MainActor` on the type | Swift 5.5+ |
| Tests | XCTest `XCTAssert…` | Swift Testing `@Test` / `#expect` (XCTest still needed for UI tests) | Xcode 16 |

---

## Study plan

1. **Watch "Demystify SwiftUI" (WWDC21) and internalise identity, lifetime, dependencies.** Everything hard in SwiftUI is downstream of these three ideas. Do this before anything else on this list.
2. **Property wrappers as an ownership question, not a lookup table.** Be able to state, for each, who owns the storage and what its lifetime is tied to.
3. **The Observation framework.** Watch "Discover Observation in SwiftUI," then migrate a real `ObservableObject` screen (T4.5) and observe which views stop re-rendering.
4. **Layout, hands-on.** Implement one custom `Layout` (T3.5). One implementation teaches the proposal semantics better than any amount of reading, and it permanently fixes the `.frame` misconception.
5. **Performance as measurement.** Watch "Demystify SwiftUI performance," then take a slow screen, run `Self._printChanges()` and the SwiftUI Instruments template, and fix what they show — not what you assume.
6. **Navigation as data.** Build a `NavigationStack` with a `Codable` route enum, a deep link, and state restoration (T1.9).
7. **Interop and accessibility.** Write one `UIViewRepresentable` with a delegate (T4.4), and run one screen through VoiceOver and the largest Dynamic Type size (T3.8).
8. **Last, the comparison questions** — SwiftUI vs UIKit, declarative vs imperative, `List` vs `LazyVStack`. They are the most-asked and the easiest, and they answer themselves once the model above is in place.

---

## Sources

**Primary — Apple (WWDC sessions, retrieved in full)**

1. *Demystify SwiftUI*, WWDC21 session 10022 — https://developer.apple.com/videos/play/wwdc2021/10022/ — identity (structural vs. explicit), lifetime, dependency graph, `AnyView` guidance, stable/unique identifier rules, inert modifiers vs. branches.
2. *Demystify SwiftUI performance*, WWDC23 session 10160 — https://developer.apple.com/videos/play/wwdc2023/10160/ — the measure→identify→optimise loop, `Self._printChanges()` (debug-only), dependency scoping, `AnyView` in `List`, constant-row-count requirement.
3. *Discover Observation in SwiftUI*, WWDC23 session 10149 — https://developer.apple.com/videos/play/wwdc2023/10149/ — `@Observable`, per-property tracking, `@State`/`@Environment`/`@Bindable`, computed properties, manual `access`/`withMutation`.
4. *The SwiftUI cookbook for navigation*, WWDC22 session 10054 — https://developer.apple.com/videos/play/wwdc2022/10054/ — `NavigationStack`, value-based links, `navigationDestination`, `NavigationPath`, deep linking, `SceneStorage` restoration, `NavigationSplitView`.
5. *Compose custom layouts with SwiftUI*, WWDC22 session 10056 — https://developer.apple.com/videos/play/wwdc2022/10056/ — `Layout` protocol, `ProposedViewSize` semantics, layout cache, `LayoutValueKey`, `ViewThatFits`, `Grid`, `AnyLayout`.

**Primary — Apple documentation** (page bodies were not retrievable from this environment; cited as pointers, no claim rests on them)

6. *Migrating from the Observable Object protocol to the Observable macro* — https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro — **[title only retrieved]**.

**Community engineering blogs** — technically strong, not official

7. Alexey Naumov, "Performance Battle: AnyView vs Group" — https://nalexn.github.io/anyview-vs-group/ — the benchmark behind the T3.2 correction. **[index]**
8. Majid Jabrayilov, "Optimizing views in SwiftUI using EquatableView" — https://swiftwithmajid.com/2020/01/22/optimizing-views-in-swiftui-using-equatableview/ **[index]**
9. The SwiftUI Lab, "The Mystery Behind View Equality" — https://swiftui-lab.com/equatableview/ **[index]**
10. Donny Wals, "Choosing between LazyVStack, List, and VStack in SwiftUI" — https://www.donnywals.com/choosing-between-lazyvstack-list-and-vstack-in-swiftui/ **[index]**
11. STRV, "SwiftUI: List vs LazyVStack" — https://www.strv.com/blog/swiftui-list-vs-lazyvstack — the scroll-to-bottom benchmark cited in T1.8. **[index]**
12. fatbobman, "List or LazyVStack — Choosing the Right Lazy Container in SwiftUI" — https://fatbobman.com/en/posts/list-or-lazyvstack/ **[index]**
13. Nil Coalescing, "Overview of the onChange() modifier in SwiftUI" — https://nilcoalescing.com/blog/OverviewOfonChangeInSwiftUI/ **[index]**
14. Use Your Loaf, "SwiftUI onChange Deprecation" — https://useyourloaf.com/blog/swiftui-onchange-deprecation/ **[index]**
15. Sagar Unagar, "Mastering Geometry in SwiftUI — GeometryReader, GeometryProxy & onGeometryChange" — https://www.sagarunagar.com/blog/geometry-in-swiftui **[index]**
16. Josh Hrach, "UIViewRepresentable: Working with delegates in SwiftUI" — https://www.joshspadd.com/2024/01/swiftui-view-representable-delegates/ **[index]**
17. Paul Hudson, "How to find which data change is causing a SwiftUI view to update," *Hacking with Swift* — https://www.hackingwithswift.com/quick-start/swiftui/how-to-find-which-data-change-is-causing-a-swiftui-view-to-update **[index; blocked]**
18. Chetansinh Rajput, "SwiftUI Performance Optimization: Preventing Excessive View Re-renders" — https://medium.com/mobile-innovation-network/swiftui-performance-optimization-a-guide-to-preventing-excessive-view-re-renders-28cbfe95173b **[index]**
19. Swift Crafted, "SwiftUI Layout Protocol Guide (iOS 26)" — https://swiftcrafted.dev/article/swiftui-custom-layout-protocol-ios-26 **[index]**

**Interview-prep sources** — where the *questions* came from; answers not relied upon

20. shobhakartiwari, *SwiftUI-Interview-Questions*, GitHub — https://github.com/shobhakartiwari/SwiftUI-Interview-Questions (retrieved in full) — the largest public bank surveyed; **no Observation coverage, still teaches `NavigationView`**. Cited in "Where these questions came from" and the cross-cutting analysis as evidence of staleness.
21. InterviewPrep, "Top 25 SwiftUI Interview Questions and Answers" — https://interviewprep.org/swiftui-interview-questions/ **[index]**
22. ResumeKraft, "Top 33 SwiftUI Interview Questions (With Answers & Explanation)" — https://resumekraft.com/swift-ui-interview-questions/ **[index]**
23. Curotec, "125 iOS Swift Interview Questions in 2026" — https://www.curotec.com/interview-questions/125-ios-swift-interview-questions/ **[index]**
24. Hyring, "SwiftUI Interview Questions, Answers, Examples & Prep Guide" — https://hyring.com/jobseeker-toolkit/interview-questions/technical/swiftui **[index]**
25. byby.dev, "iOS Interview Questions (SwiftUI)" — https://byby.dev/ios-interview-swiftui **[index]**
26. Mihail Salari, "Top 25 SwiftUI Interview Questions and Answers" — https://mihailsalari.com/top-25-swiftui-interview-questions-and-answers/ **[index]**
27. Niraj Paul, "SwiftUI Interview Questions and Answers" — https://nirajpaul2.medium.com/swiftui-interview-questions-and-answers-c9c082cbd6b8 **[index]**
28. Aayushi, "SwiftUI Interview Questions: Beginner level" — https://medium.com/@aayushi9555/swiftui-interview-questions-beginner-level-521f25597f59 **[index]**
29. Ahil NS, "Top Senior iOS Developer Interview Questions: SwiftUI (Part 1)" — https://medium.com/@eahilendran/ios-developer-interview-question-2025-part-1-swift-20d2517f1e32 **[index]**
30. Teesma, "Top 25 UIKit & SwiftUI Interview Questions with Answers (2026 iOS Developer Guide)" — https://medium.com/@teesma-dev/top-25-uikit-and-swiftui-interview-questions-with-answers-with-examples-63616169f7d3 **[index]**
31. Yogesh Raut, "Mastering State Management in SwiftUI: From @State to @Observable" — https://medium.com/@yogeshraut.dev/mastering-state-management-in-swiftui-from-state-to-observable-126c01a252f9 **[index]**
32. "Top 30 iOS Interview Questions and Answers (2026 Edition)," *DEV Community* — https://dev.to/__be2942592/top-30-ios-interview-questions-and-answers-2026-edition-4695 **[index]**
33. Quizlet, "iOS Interview Questions — SwiftUI Flashcards" — https://quizlet.com/638977020/ios-interview-questions-swiftui-flash-cards/ **[index]**

**Sourcing caveat.** No source here is company-confirmed; no employer publishes its SwiftUI question list. Items 20–33 are individual-author or aggregator prep content of variable quality and recency, and several visibly recycle one another. Every entry tagged `sourced` reflects a question that appears in that body of material; its **answer** is grounded in items 1–5. Where prep material and primary sources conflict, the primary source wins and the conflict is flagged inline (T1.3, T1.8, T1.9, T2.5, T3.2). Statements about undocumented framework internals are labelled **[community-observed]**. Nothing presented by any source as confidential or under NDA is reproduced here.

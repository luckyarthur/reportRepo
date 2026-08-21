# Building a Startup in the Current Age — and Whether a Speechify-Class TTS App Is a Business

**Coverage:** (1) how startups are actually built and funded now that AI has collapsed build cost; (2) the idea-to-business operating playbook; (3) a worked case on a Speechify-class text-to-speech reading app, including an explicit COGS model; (4) whether a real world market exists, sized and segmented.

**Research performed:** 2026-08-21. **All figures are point-in-time and will go stale.** API prices, platform commission rates, and funding figures in particular change on timescales of weeks.

> **Not financial, legal, or investment advice.** This is a market-research and operator-strategy report. Regulatory material below describes published rules, not legal guidance. Nothing here is a prediction of outcomes for any specific venture, and no path described is easy or likely to succeed — see the base rates in Part 1.

---

## Verification constraint — read before the numbers

Research was conducted under a **partial web-access constraint**. Web *search* was available. **Direct page fetching was blocked by this environment's network egress proxy for nearly every host attempted** — `elevenlabs.io`, `aws.amazon.com`, `platform.openai.com`, `azure.microsoft.com`, and `revenuecat.com` all returned `EGRESS_BLOCKED`. `cloud.google.com` resolved but returned truncated content that did not include the pricing table.

This bears directly on this task's own instruction to **"quote API pricing and platform commission rates with access dates"** because stale pricing invalidates the COGS model downstream. **That verification was not achievable for any TTS provider.**

What was done instead: every price below is drawn from **multiple secondary sources that agree with each other and cite the vendor's own pricing page**, and is labelled **(A\*)** — official in origin, secondary in verification. **Treat every API price and commission rate in this report as "consistently reported as of August 2026" rather than "read off the vendor's pricing page."** The COGS model in Part 3 inherits that uncertainty and is labelled illustrative throughout. Anyone acting on it should re-price against the live vendor pages before committing capital. This is recorded again in Open Questions.

A second constraint: **search results for commercial topics in 2026 are dominated by SEO content farms.** A large share of what surfaces for queries like "MVP cost" or "CAC benchmarks" is agency marketing with no stated methodology. Those are tiered (C) below and several such figures are reported here *as evidence that no reliable figure exists*, not as findings.

---

## Evidence-tier note

Every figure carries a tier:

- **(A) Primary/official** — company press releases and blogs, official pricing and developer documentation, regulation text, government statistics, app-store listings, founder statements on the record.
- **(A\*)** — official in origin, verified only through consistent secondary reporting (see constraint above).
- **(B) Independent** — business and tech press with its own sourcing, app-intelligence vendors (Sensor Tower, Appfigures), peer-reviewed academic work, and market-research firms **where methodology is stated**.
- **(C) Industry/community-reported** — VC and vendor blogs, founder interviews, consultancy TAM projections, SEO "statistics" aggregators, agency content marketing.

**Consultancy TAM projections are treated as tier (C) unless methodology is published.** They are marketing collateral for the firm selling the report. Where a widely-repeated market-size number traces to a single press release, this report says so instead of repeating the number as fact. Part 4 shows three firms publishing 2026 TTS market sizes that differ by ~47% for the same year — that spread *is* the finding.

**The survivorship problem is load-bearing in Parts 1 and 2.** Startup advice is the most survivorship-biased genre in business writing: visible companies are selected on success and failures publish nothing. Any tactic attributed to a named company below is colour, tier (C), and is never generalised into a rate.

---

## TL;DR

- **Building is cheap; distribution is not, and the cost collapse is symmetric.** AI-assisted coding is credibly reported at 25–50% faster cycles overall but under 10% on complex work **(C, vendor-adjacent surveys, no consistent methodology)**. Every competitor gets the same discount, so a cheap build is not a moat.
- **Capital is real but extraordinarily concentrated.** AI firms took **61% of global VC in 2025 (USD 258.7B of 427.1B)** per OECD **(B)**, rising to a reported **~80% in Q1 2026** with four labs taking 65% of the quarter **(C/B, tracker-dependent)**. Median seed is ~$3.0–3.2M on a record ~$24M post **(B, Carta-derived)** — but only ~0.05% of companies ever raise VC at all **(C)**.
- **AI apps have structurally worse economics than classic SaaS.** ICONIQ-sourced reporting puts inference at **~23% of revenue** for scaling AI companies, with AI gross margins of **50–60% vs. 75–90%** for SaaS **(C, secondary reporting of a private dataset)**.
- **Most subscription apps never become businesses.** RevenueCat's dataset of 115,000+ apps: **~80.8% never reach $1,000/month** in subscription revenue by year two **(B)**. Median AI-app Year-1 realised LTV is **$30.16 (B)** — below plausible paid-acquisition CAC per payer in most channels.
- **AI apps monetise better and retain worse:** +41% revenue per payer but ~30% faster churn, and AI monthly plans retain **36% worse over 12 months (B, RevenueCat 2026)**.
- **Speechify's public numbers do not reconcile.** Company/founder claims of **50–60M users (A, promotional)** sit against a third-party estimate of **$17.6M ARR (C, Latka)** and a founder statement of **$500K/month on ad creative testing alone (A, 20VC, May 2026)**. At least one of those is wrong; this report does not know which.
- **The COGS crux: a flat-rate TTS subscription goes underwater fast at premium voice prices.** Illustrative model below: at ElevenLabs Multilingual pricing (~$100/1M chars, A\*), a $139/year subscription breaks even at **~1.8 listening-hours/month**. At Google WaveNet pricing (~$4/1M chars, A\*) it survives to **~46 hours/month**. **Voice choice, not user acquisition, decides whether the business exists.**
- **The platform ships the product for free.** Apple Spoken Content, Chrome "Listen to this page", Android TalkBack and Kindle Virtual Voice are all free and pre-installed **(A)**. Any paid reader must beat "free and already on the device."
- **Regulation creates real institutional demand, but not for a consumer app.** The European Accessibility Act applied from **28 June 2025 (A)**; the US DOJ Title II rule's deadlines were **extended one year in April 2026, to April 2027/2028 (A)**. These push budget toward procurement-grade vendors, not App Store subscriptions.
- **Verdict (argued in full below): do not build a general-purpose Speechify clone.** The consumer category is closing. The defensible forms are narrow: a hard-ingestion vertical, an institutional/accessibility-procurement product, or a non-English wedge — all with usage-aware pricing and none with an uncapped flat rate.

---

## Part 1 — What has actually changed about building a startup

### The cost curve

The honest answer is that **nobody has published a methodologically sound before/after on software build cost**, and the search space for this question is almost entirely agency marketing. What is available:

- Current custom MVP quotes cluster at **$15,000–$120,000, with agencies naming $40,000–$80,000 as typical, and $140,000–$300,000+ for AI-enabled builds (C, agency price lists — these are sell-side quotes, not observed costs)**.
- Timelines are quoted at **8–30+ weeks**, against "hours instead of months" for AI-app-builder output **(C)**.
- On AI coding assistance specifically: **25–50% faster development cycles** and **30–60% faster completion on coding tasks**, but **under 10% gain on complex work (C)**. That last number is the important one and it is the one least often quoted.

I found no tier (A) or (B) longitudinal dataset comparing 2015 and 2026 build costs for a comparable product. **This question cannot be answered rigorously with public data.** What would answer it: a panel of comparable products with audited engineering spend at both dates, or a controlled trial of matched teams — neither exists publicly.

What *is* defensible: managed infrastructure, app-store distribution rails, payment infrastructure, and code generation have removed most of the fixed cost of reaching a first shipped version. The residual cost is not code.

### The consequence nobody likes

If building is cheap for you, it is cheap for everyone. This is directly observable in the App Store: **new-app submissions climbed ~30% in 2025 and are on pace to nearly double again in 2026, while global App Store downloads grew ~3% in 2025 and ~2% through H1 2026 (C, aggregator synthesis)**. Supply of apps is expanding far faster than demand for apps.

When the build is not the moat, the remaining moats are: **distribution** (owned channel, installed base, default placement), **proprietary data** (data you generate that competitors cannot buy), **brand** (which in consumer apps largely means paid-acquisition scale plus review volume), **switching costs** (accumulated user state), **regulatory position** (certifications and procurement approvals that take years), and **supply-side relationships** (content licences, in this category: audiobook and publisher rights). Note that four of those six are *bought*, not built — which is why the cost collapse in engineering has not democratised outcomes.

### Funding reality

| Metric | Figure | Tier |
|---|---|---|
| AI share of global VC, FY2025 | 61% — USD 258.7B of USD 427.1B | (B) OECD, Feb 2026 |
| Alternative estimates, FY2025 | ~48% (CB Insights); ~$202B ≈ half of global VC (Crunchbase) | (B) |
| AI share of global VC, Q1 2026 | ~80%; OpenAI + Anthropic + xAI + Waymo = $188B = 65% of the quarter | (C/B) tracker-dependent |
| Median seed round size | ~$3.0–3.2M | (B) Carta-derived |
| Median seed post-money | ~$24M (record, Q4 2025) | (B) Carta-derived |
| Median pre-seed round | ~$1M on $4–6M post | (C) aggregator synthesis |
| AI premium at seed | ~$4.6M median round vs. ~$3.1M non-AI; ~42% valuation premium | (C) aggregator synthesis of Carta data |
| Share of companies that ever raise VC | ~0.05% | (C) widely repeated, original denominator unclear |

Two readings matter. First, **the averages are distorted beyond usefulness by AI concentration** — when four companies take 65% of a quarter, "the funding environment" is not one environment. Second, **for a consumer TTS reading app in 2026, institutional venture capital is a poor fit**: it is not a foundation-model play, it will not clear a fund-returner bar, and the category has a well-funded incumbent.

**The bootstrap path is a genuine alternative here, not a consolation prize.** Sourced examples of companies that scaled without institutional VC: **Zoho** (no external funding, 55+ products, 60M+ users claimed) **(C)**; **Atlassian** (>$3.5B revenue, minimal early funding) **(C)**; **Midjourney** (~$500M ARR by 2025, bootstrapped) **(C)**; **Tally** ($0 → $100K MRR in 3.5 years, two founders) **(C)**. Every one of these is a survivorship-selected example. **They are evidence that the path exists, not evidence of its base rate.** The base rate for bootstrapped app businesses is in the RevenueCat distribution in Part 2, and it is grim.

### Team shape

The data here is contradictory and should be treated as unresolved:

- Among 200+ analysed unicorns, **46% had three co-founders, 21% two, 9% solo**; **80% had two or more (C)**.
- Against that: research reported from Howell & Bingham (Wharton-hosted working paper) finds **solo-founded ventures last longer and reach higher revenue** in the non-unicorn population, and that solo founders are **2.6× as likely to still own an ongoing for-profit venture** than 3+ founder teams **(B, academic working paper)**.
- **First Round-attributed claim: solo founders raise 30% less capital and face 2.3× higher failure rates (C, not independently verified.)**

These are not actually in conflict — they measure different outcome variables on different populations. **Unicorn-conditioned statistics are pure survivorship bias and should not inform a founder's decision.** The defensible statement: co-founding correlates with raising more capital and with extreme upside outcomes; solo founding correlates with survival and with modest profitable outcomes. For a bootstrapped app, that points to small teams.

### Where AI startup costs actually land

The structural change is that **inference is COGS, not R&D**. Every generation is a variable cost that scales with usage.

| Metric | Classic SaaS | AI-native | Tier |
|---|---|---|---|
| COGS as % revenue | ~10–25% | ~40–50% | (C) |
| Gross margin | 75–90% | 50–60% | (C) |
| Inference alone | n/a | ~23% of revenue at scaling stage (ICONIQ-attributed) | (C, secondary reporting) |

Every figure in this table is secondary reporting of private benchmark datasets. **None of it is auditable.** It is directionally consistent across independent sources, which is the most that can be said. The mechanism, though, is not in doubt and is arithmetic: Part 3 models it explicitly.

### Base rates

| Statistic | Figure | Source & tier |
|---|---|---|
| US private-sector businesses failing within 1 year | 20.4% | (B) BLS BED-derived |
| Alternative 1-year figure | 22.1% | (B) LendingTree analysis of Census data |
| Failing within 5 years | ~49.8% | (B) BLS-derived |
| Failing within 10 years | ~65.3% | (B) BLS-derived |
| Information sector 10-year survival | 29.1% — lowest of any BLS-tracked sector | (B) |
| Subscription apps never reaching $1,000/mo by year 2 | 80.83% | (B) RevenueCat, 115,000+ apps |

**Why most quoted failure statistics are unreliable.** The famous "90% of startups fail" is not a measured rate of anything; it circulates without a denominator. BLS measures *establishment deaths* — a business that is sold, merged, or quietly wound down while solvent counts identically to one that fails. Meanwhile venture-outcome statistics describe **the ~0.05% of companies that raise VC**, a population selected on ambition and access. The RevenueCat number is the most relevant here because its denominator is explicit and the population — apps that shipped and integrated a subscription SDK — matches what a founder in this category would actually be doing. Note it also *excludes* every app that never got far enough to integrate an SDK, so **it understates failure**.

**Plainly: most apps and most startups fail. The outcome distribution is extremely skewed, and the median outcome of shipping a subscription app is under $1,000/month.**

---

## Part 2 — Idea to business: the operating playbook

### Validation before building

Meaningful early signals are the ones that cost the user something: a paid pre-order, a completed onboarding on a fake-door landing page, an unprompted repeat visit, a request to pay before you offer to charge. Noise: waitlist signups, social engagement, "I would definitely use that", and friends' installs.

**Honest caveat: I found no tier (A) or (B) evidence establishing how long validation should take or what conversion thresholds are meaningful at small scale.** The entire genre is founder folklore. What can be said with sourcing is a lower bound: if a paid channel cannot produce payers at a cost below the LTV benchmarks in the next section, no amount of validation ritual changes the answer.

### Distribution is the hard part

**Platform economics, as of August 2026:**

| Platform | Rate | Tier |
|---|---|---|
| Apple standard commission | 30%, or 15% under the Small Business Program (<$1M annual proceeds) and on subscriptions after year one | (A\*) |
| Apple, external payment links (US) | Currently permitted with no commission following the Epic contempt ruling; **Apple has petitioned the court for 5–15% tiered fees and the Supreme Court has cleared a path for further litigation (Aug 2026)** — this is unsettled and could change within months | (B) |
| Google Play service fee | **From 30 June 2026: starts at 10% on first $1M annual earnings and 10% on all auto-renewing subscriptions**, US/EEA/UK first; applies regardless of billing system used | (A\*) Play Console Help |
| Google Play, non-recurring purchases | 20% (installs on/after 30 Jun 2026) / 25% (earlier installs), with 15%/20% programme rates | (A\*) |

**The takeaway for modelling: assume 15% platform take on an annual consumer subscription on iOS as a base case and 30% in year one, and re-check before finalising any model — the US external-link position is actively in litigation.**

**Discovery reality.** ~2.4–2.5M apps on the App Store; ~3,666 new apps released per day; downloads growing ~2–3% while submissions grow ~30–100% **(C, aggregator synthesis)**. ASO is a necessary hygiene practice and is not a growth strategy at this ratio.

**Paid acquisition economics.** Every figure below is **(C)** — agency and aggregator benchmarks with no published methodology — and the spread is wide enough that they are useful only as an order of magnitude:

| Metric | Reported range | Tier |
|---|---|---|
| Cost per install, general | ~$1–5 (up to $26 in some categories/geos) | (C) |
| Google UAC blended CPI | ~$3.77 | (C) |
| iOS vs Android CPI | iOS ~2.3× Android | (C) |
| Cost per paying user | ~$20–80, "20–50× CPI" | (C) |
| North America average CPI | ~$5.28 vs. $0.50–2.00 LatAm | (C) |

### Monetization models

| Model | Economics | Benchmark | Tier |
|---|---|---|---|
| Hard paywall (trial required) | Highest conversion, lowest top-of-funnel | **Median day-35 trial-to-paid 10.7%** | (B) RevenueCat 2026 |
| Freemium | Large free base, weak conversion | **Median day-35 conversion 2.1%** | (B) |
| Trial length | Longer trials convert better | 17+ day trials convert **70% better** (42.5% vs 25.5%) | (B) |
| Subscription, AI category | Higher ARPU, worse retention | **+41% revenue per payer; ~30% faster churn; monthly plans retain 36% worse over 12 months** | (B) |
| One-time purchase | No recurring COGS coverage — **structurally incompatible with per-use inference costs** | Voice Dream's move from one-time to ~$80/yr is the illustrative case | (C) |
| Usage-based | Aligns price to inference cost; higher friction | No public benchmark found | — |
| Ads | Requires scale most reading apps never reach | No reliable benchmark found | — |

### Unit economics — worked example (illustrative)

**All assumptions are labelled. This is a model, not a measurement.**

Assumptions: blended CPI **$3.00** (C, mid-range); install → trial start **20%** (**unsourced assumption — no reliable benchmark found**); trial → paid **10.7%** (B, RevenueCat median for hard paywalls). Therefore install → payer = 2.14%.

- **CAC per payer = $3.00 ÷ 0.0214 = $140.**
- Compare against **median AI-app Year-1 realised LTV of $30.16 (B, RevenueCat 2026)**.
- Even against a $139/year subscription at 100% year-one retention: gross $139, less 15% platform = **$118 net**, less COGS (Part 3), before any support, refund, or infrastructure cost. **Payback exceeds twelve months at CAC $140, on a product whose median peer realises $30 in year one.**

Sensitivity: at CPI $1.50 and 4% install→payer, CAC per payer falls to $37 and the model becomes arguable. At CPI $5.00 and 1.5%, CAC is $333 and it is hopeless. **The entire business lives inside a factor-of-nine band determined by numbers no public source reports reliably.** That is the actual state of knowledge, and any plan that treats CAC as a known input is fooling itself.

Benchmarks for judging the result: LTV:CAC of **3:1 minimum, 4–5:1 expected**, CAC payback **under 12 months** (3–6 months in competitive consumer categories) **(C)**. And note: **bootstrapped companies need higher ratios than venture-backed ones**, because they fund acquisition from operations rather than from a balance sheet.

### The failure modes

**No distribution** (the modal death: a good app nobody finds). **No differentiation** (when the build is cheap, feature parity arrives in weeks). **Negative unit economics on inference** — the specific AI-era failure, where growth in engaged usage increases losses; see Part 3. **Platform dependence** — commission rates, review policy, and the availability of external payment links all changed materially in the twelve months before this report. **Founder burnout**, which is not measurable but is the most-cited reason in founder post-mortems (C). **Premature scaling** — buying installs before retention is established converts cash into churned users. **Building for a market that doesn't pay** — the geography problem in Part 4: the users and the revenue are in different countries.

---

## Part 3 — The worked case: a Speechify-class TTS app

### What Speechify is

Founded **2017 by Cliff Weitzman**, who built the first version to work around his own dyslexia; headquartered in Miami **(A/C)**. Product: read-aloud across iOS, Android, web, and a Chrome extension, plus a Studio/voice-generation product.

| Claim | Figure | Tier |
|---|---|---|
| Funding round | $10M at $100M valuation, announced Jan 2024 | (A) Speechify press release |
| Later round | "$50M led by Northstar Ventures at $120M valuation" | (C) tracker, **date unconfirmed, treat as unverified** |
| Revenue | $17.6M ARR (2025) | (C) Latka |
| Users | "50 million people"; founder later says "60 million+" | (A, promotional) |
| Employees | 192 as of 30 Jun 2026 | (C) tracker |
| Consumer pricing | Premium **$139/year (~$11.58/mo)**; **$29/month** monthly | (A\*) |
| Paid acquisition | **~1,300 AI-generated ads tested daily; ~$500,000/month on creative experimentation** | (A) founder, 20VC, May 2026 |
| Inference cost | driven to **"single-digit dollars per million characters"** | (A) founder, same interview |
| Third-party app estimate | ~500K downloads / ~$2M revenue in one month (Mar 2026) | (C) Sensor Tower estimate via secondary report |

**These numbers do not reconcile and I am not going to pretend they do.** $500K/month on ad *creative testing* is $6M/year against a claimed $17.6M ARR. Either the ARR estimate is badly stale, or the ad-spend figure is a founder overstatement, or the company is spending at a rate that only makes sense with capital not publicly disclosed. The Sensor Tower monthly estimate (~$2M/month gross, ~$24M/year run-rate before platform commission) is closer to consistent with heavy spend, which suggests **the $17.6M ARR figure is the stale one**. That is inference, not evidence.

Two of the founder's statements are, however, directly load-bearing for this analysis regardless of which revenue figure is true: **the company competes on paid-creative volume, and it has driven per-character inference cost to single digits per million.** Both are exactly what the COGS model below predicts a survivor must do.

### The competitive field

| Product | What it is | Price (Aug 2026) | Tier |
|---|---|---|---|
| **Speechify** | Cross-platform reader + Studio | $139/yr; $29/mo | (A\*) |
| **ElevenReader** (ElevenLabs) | Reader app from the leading TTS lab | **Free: 10 hrs/mo + thousands of audiobooks**; Ultra $11/mo or $99/yr | (A) elevenreader.io |
| ElevenLabs (parent) | Voice-AI platform | **~$500M ARR (Apr 2026), $11B valuation, $500M Series D led by Sequoia (Feb 2026)** | (A/B) |
| **NaturalReader** | Long-standing reader | Free 20 min/day; ~$9.99/mo Plus; ~$19.99/mo Premium | (A\*) |
| **Voice Dream Reader** | Accessibility-community favourite | Moved from one-time purchase to **~$80/yr** | (C) |
| **Play.ht** | Voice generation, creator-oriented | Usage-tiered; not a reader | (C) |
| **Audible / Amazon** | Human-narrated audiobook subscription | Subscription; separate market | (A) |
| **Kindle Virtual Voice** | AI-narrated audiobooks from KDP titles | **Free to produce; 40,000–50,000+ titles reported** | (A/C) |
| **Apple Spoken Content / Speak Screen** | OS-level read-aloud, incl. Siri Enhanced voices | **Free, pre-installed** | (A) |
| **Chrome "Listen to this page"** | Browser read-aloud, plus AI playback | **Free** | (A) Google support |
| **Android TalkBack** | OS screen reader | **Free, pre-installed** | (A) |
| **Pocket** (read-later) | **Shut down 8 July 2025** by Mozilla | n/a | (A/B) |

Pocket's shutdown is worth dwelling on: a read-later app with a decade of brand equity, owned by a well-resourced parent, was closed because usage patterns moved. **That is the base rate for this adjacent category, not an anomaly.**

### The build: what is commodity and what is hard

**Commodity (weeks, mostly API integration):** TTS synthesis itself; account/subscription plumbing via RevenueCat or equivalent; basic web-article extraction; audio playback and speed control; a browser extension.

**Genuinely hard:**
- **Document ingestion at quality.** PDF is the problem. Reading order in multi-column layouts, headers/footers, footnotes, tables, figure captions, ligatures, hyphenation across line breaks, and scanned pages needing OCR. A reader that says "column two, page header, footnote 14" aloud in the middle of a sentence is unusable, and **this is where most clones actually fail** — not on voice.
- **Word-level highlight/audio sync**, especially after speed changes and across page boundaries, and especially when the ingestion layer above is imperfect.
- **Offline playback**, which forces pre-synthesis, which forces you to spend inference money *before* you know whether the user will listen — an important COGS interaction most models ignore.
- **Accessibility conformance** to WCAG 2.1 AA / EN 301 549, which is slow, expert, and unglamorous work — and, per Part 4, the one hard part that doubles as a moat.
- **Cross-device continuity** at library scale.

### The cost structure — the crux

**Published TTS pricing, per 1M characters, as of August 2026 (all A\*, secondary-verified — see the verification constraint):**

| Provider / voice tier | Price per 1M chars | Notes |
|---|---|---|
| Google Standard / WaveNet | **$4** | WaveNet reportedly cut to $4 in early 2026; free tier 4M chars/mo |
| Amazon Polly Standard | **~$4.80** | |
| OpenAI `tts-1` | **$15** | `tts-1-hd` $30 |
| Google Neural2 | **$16** | |
| Azure Neural | **$16** | HD $22 (cut from $30 in Mar 2026); commitment tiers to ~$7.50 |
| Google Chirp 3: HD | **$30** | |
| ElevenLabs Flash/Turbo | **~$50** ($0.05/1K) | Cut up to 55% in May 2026 |
| ElevenLabs Multilingual v2/v3 | **~$100** ($0.10/1K) | |
| Google Studio | **$160** | |
| Self-hosted open-source (Kokoro, Chatterbox, Orpheus — Apache/MIT) | **~$0.005–0.04 per minute of audio ≈ $0.30–2.40/hr** before engineering and idle-GPU cost | (C) |

**Illustrative COGS model — assumptions stated explicitly:**

- English speech at a normal listening pace ≈ **150 words/minute**; ≈ **6 characters per word including spaces**; therefore **≈ 54,000 characters per hour of synthesised audio**. *(Modelled, not measured.)*
- Subscription: **$139/year = $11.58/month gross**. Platform commission **15%** (Apple Small Business Program / post-year-one subscription rate) → **$9.84/month net**. At 30% it is **$8.11/month net**.
- Cost is per *character synthesised*, and caching means re-listening is free. Assume **no cache benefit** (worst case) and **no wasted pre-synthesis**.

| Voice tier | $/1M chars | Cost per audio-hour | Break-even hrs/mo @ $9.84 net | @ $8.11 net (30%) |
|---|---|---|---|---|
| Google WaveNet / Standard | $4 | $0.216 | **45.6 h** | 37.5 h |
| Founder-claimed Speechify level (~$5) | ~$5 | $0.270 | **36.4 h** | 30.0 h |
| OpenAI `tts-1` | $15 | $0.810 | **12.1 h** | 10.0 h |
| Azure Neural / Google Neural2 | $16 | $0.864 | **11.4 h** | 9.4 h |
| Chirp 3: HD / `tts-1-hd` | $30 | $1.620 | **6.1 h** | 5.0 h |
| ElevenLabs Flash | ~$50 | $2.700 | **3.6 h** | 3.0 h |
| ElevenLabs Multilingual | ~$100 | $5.400 | **1.8 h** | 1.5 h |

**Read that table again, because it is the whole business.** At the voice quality that makes the product feel premium — the reason a user would pay rather than use Apple's free Spoken Content — **the subscription goes underwater somewhere between 1.8 and 6 hours of listening per month.** A committed user (a student with a reading load, a professional clearing a paper queue) will do 20–40 hours. **Your best users are your biggest losses.**

Three compounding effects the naive model misses:

1. **Playback speed multiplies consumption.** A user listening at 2× consumes ~108,000 characters per *listening* hour, halving every break-even figure above.
2. **Offline pre-synthesis is spent whether or not the user listens.** Downloading a 12-hour book that the user abandons after 20 minutes costs the full 12 hours of synthesis.
3. **Annual up-front billing hides the problem for eleven months.** Cash arrives in January; the inference bill arrives monthly all year. A cohort can look profitable for two quarters and be deeply negative by renewal.

**The mitigations are the actual product strategy, not optimisations:** aggressive caching and shared synthesis across users reading the same public text; cheap voices as the default with premium voices metered or reserved for a higher tier; usage caps stated in the pricing (ElevenReader's *"10 hours a month"* free tier is exactly this, and its Ultra tier's "unlimited" claim is only survivable because ElevenLabs owns the model and pays marginal compute cost, not API list price); and self-hosted open-weight models for the bulk case. **A pure API reseller on a flat-rate uncapped subscription is not a viable structure at premium voice tiers. That is arithmetic, not opinion.**

Note what this implies competitively: **ElevenLabs is vertically integrated and its reader app is a distribution channel for its model.** It can price a reader at a level that is structurally unprofitable for anyone buying inference at list price. That is the single most important fact in this section.

### The defensibility question

If the engine is an API call, what is the product? Assessed honestly:

| Candidate moat | Real? | Assessment |
|---|---|---|
| Voice quality/selection | **No** | You are reselling; ElevenLabs, Google, and OpenAI sell to everyone. Cut up to 55% in a single May 2026 announcement. |
| Ingestion quality (PDF/OCR/EPUB/web) | **Partly** | Genuinely hard, genuinely differentiating, and *invisible in marketing* — which is why it is under-invested in by clones. The most defensible engineering asset here. |
| Sync/highlighting UX | **Thin** | Replicable in weeks once ingestion is solved. |
| Library management / continuity | **Thin, but sticky** | Weak as a moat, real as a switching cost once a user has a large library. |
| Offline | **Thin** | Table stakes; and it makes COGS worse. |
| Accessibility conformance | **Yes, but only for B2B** | Slow, expert, auditable, and required by procurement. Worthless in consumer App Store competition. |
| Content licences (audiobooks) | **Yes** | ElevenReader's 200,000+ licensed audiobooks are a supply-side asset a solo builder cannot replicate. |

**Three of seven are thin. Two are real and both point away from the consumer app.**

### Platform risk

Apple ships Spoken Content and Speak Screen with free Siri Enhanced voices; Google ships TalkBack and Chrome "Listen to this page" including an AI playback mode; Amazon ships Virtual Voice narration on tens of thousands of Kindle titles at no extra cost **(all A)**. These are pre-installed, free, and improving on the platform vendors' own schedules.

**The surviving wedge against free-and-preinstalled is narrow and specific:** cross-platform continuity (OS features don't sync between iOS, Android and desktop); ingestion of documents the OS handles badly (scanned PDFs, complex layouts, DRM-free EPUB libraries, research papers); library and progress management across hundreds of documents; and voices materially better than the OS default. That is a real wedge. It is also a *feature list*, and the honest reading of a feature-list wedge is that it holds only until the platform decides the feature is worth shipping.

---

## Part 4 — Is there a world market?

### Market sizing — and why the numbers should not be trusted

Three market-research firms, three sizes for the *same* TTS market in *roughly the same year*:

| Source | Figure | Tier |
|---|---|---|
| The Business Research Company (Feb 2026) | **$2.97B in 2026** → $5.65B by 2030 (17.5% CAGR) | **(C)** no published methodology |
| Polaris Market Research | **$4.13B in 2025**, 3.7% CAGR to 2034 | **(C)** |
| Mordor Intelligence (2026) | **$4.36B in 2026** | **(C)** |
| The Business Research Company (alt. series) | **$11.49B by 2030** at 18.5% | **(C)** |

**A ~47% spread on the current-year figure and CAGRs from 3.7% to 18.5% for the same market.** These cannot all be right; most likely none is measuring the same thing. **Treat every TTS TAM number in circulation as unusable for decision-making.** Use them only to establish that this is a low-single-digit-billions market, not a hundred-billion one — which is itself the important finding: **the whole TTS category is smaller than Duolingo plus ElevenLabs combined at their current run rates.**

Adjacent markets, with the tier distinction doing real work:

| Market | Figure | Tier |
|---|---|---|
| **US audiobook publisher net revenue, 2025** | **$2.43B, +9% YoY**; 750,000+ active titles (+43%); audio-first titles $91.1M → $136M (+50%) | **(B)** Audio Publishers Association survey, via Publishers Weekly — **methodology stated (publisher survey), the strongest sizing figure in this report** |
| Global audiobook market 2025 | $11.0B (Grand View) vs. $7.85B (Mordor) — **40% apart** | (C) |
| Language-learning apps, 2025 | $1.54B, +18.8%; Duolingo alone **$1,037.6M FY2025 revenue (+39%), 52.7M DAU, 12.2M paid subs** | Duolingo figures **(A)** — public-company reporting; market total **(C)** |
| Assistive technology, global | ~$25–26B (2025/2026) | (C) |
| Screen-reader software | ~$1.4–1.8B (2025) | (C) |
| Digital accessibility software | ~$5.8B (2025) | (C) |

The one number here worth building a plan on is the APA's, because its methodology is stated and its denominator is knowable.

### Who actually pays, and why

| Segment | Size (sourced where possible) | Willingness to pay | Currently served by |
|---|---|---|---|
| **Dyslexia** | **5–10% of US population (NIH-attributed); 5–17% depending on threshold (IDA)** — (C, secondary) | Moderate–high; often institutionally funded | Kurzweil 3000, Read&Write, Bookshare, Learning Ally |
| **ADHD (adults)** | **Pooled prevalence 3.10% (95% CI 2.60–3.60)** — **(B)**, peer-reviewed umbrella review | Moderate; consumer-paid | Consumer apps, OS features |
| **Blind / low vision** | **43.3M blind; 295M moderate-to-severe VI; 2.2B any VI** — (B, GBD/WHO) | High, but heavily served by free/subsidised tools | JAWS, NVDA (free), VoiceOver, TalkBack, Bookshare (free in US) |
| **Students** | Not sizeable from public data at the level needed | Low individually; high institutionally | University disability services, LMS integrations |
| **Professionals with reading loads** | **Not publicly available** | Highest per-seat consumer WTP | Speechify, ElevenReader, browser tools |
| **ESL / language learners** | $1.54B app market; Duolingo 52.7M DAU (A) | Proven — but for *learning*, not for read-aloud | Duolingo et al. |
| **Commuters** | **Not publicly available** | Overlaps audiobook/podcast spend | Audible, Spotify, podcasts |
| **Creators wanting voice generation** | Overlaps ElevenLabs' ~$500M ARR (A) | High, usage-based | ElevenLabs, Play.ht, Kindle Virtual Voice |

**Note the pattern.** The segments with the highest need — blind and low-vision users, students with documented disabilities — are the ones already served by free or institutionally-funded tools, often by legal mandate. The segment with the highest consumer willingness to pay, busy professionals, is **the one segment for which no public sizing data exists at all**. That is not a gap in this report; it is a gap in the world's data, and it is the single most commercially important unknown in this analysis.

### Geography — where the users are vs. where the revenue is

| Market | Downloads | Consumer spend | Implication |
|---|---|---|---|
| **India** | **#1 globally, ~19.1B installs, ~17% of global (C)** | Low per-user | Volume without revenue; requires ad or very low-price model |
| **United States** | #2, ~12.6B, ~11.2% (C) | **Largest revenue market — ~$60B consumer app spend in 2025 (B, Sensor Tower)** | Where the money is |
| **Brazil, Indonesia, Mexico** | 4–8% of installs each (C) | Low | Same as India |
| **EU/UK** | Moderate | High, plus **EAA-driven institutional demand** | Best combined consumer + regulatory market |
| **iOS vs Android (global)** | Android dominates volume | **~$14/user/month iOS vs ~$6 Android (C)** | iOS-first for a paid reader |

**Conflicting figures flagged:** Sensor Tower's *State of Mobile 2025* is reported as ~$150B global consumer spend, while a separate Sensor Tower forecast article projects $270B by 2025. **These cannot be reconciled from the snippets available and neither report could be opened.** The US figure (~$60B) is the one used above and is the more consistently reported.

**The multilingual question determines whether the addressable market is bigger than "English-speaking professionals in high-income countries."** Current coverage: **ElevenLabs v3 and Gemini 3.1 Flash TTS at 70+ languages; Fish Audio S2 Pro at 80+ (open tier); Meta MMS-TTS at 1,100+ languages (B/C)**. But academic work is explicit that **quality degrades sharply outside high-resource languages, and only a handful of commercial providers go beyond the top 20–30 languages at usable quality (B, arXiv 2026 benchmark work)**. So: the languages where TTS is good are largely the languages already served, and the populations where TTS quality is poor are largely the populations with the lowest willingness to pay. **Multilingual expansion enlarges the user count far more than it enlarges the revenue.**

### Accessibility regulation as a demand driver

| Regime | Requirement | Dates | Tier |
|---|---|---|---|
| **European Accessibility Act (Dir. (EU) 2019/882)** | Accessibility for e-commerce, e-books and e-readers, banking, transport, computers/phones; technical standard **EN 301 549** (exceeds WCAG 2.1 AA with native-app and hardware requirements) | **Applied from 28 June 2025**; transposed in all 27 Member States; first French lawsuits Nov 2025; enforcement expected to intensify through 2026 | (A/B) |
| EAA micro-enterprise exemption | **<10 employees AND ≤€2M turnover/balance sheet — both conditions; services only, not products.** E-books/e-readers are classed as products | — | (A\*) |
| EAA penalties | Reported €60,000 (Ireland) to ~€900,000 (Sweden) | — | (C) |
| **ADA Title II (DOJ final rule)** | State/local government web content and mobile apps to **WCAG 2.1 Level AA** | Published **24 Apr 2024**, effective 24 Jun 2024; compliance **originally 24 Apr 2026 / 26 Apr 2027** — **DOJ interim final rule of 17 Apr 2026 extended both by one year, to 26 Apr 2027 and 26 Apr 2028** | (A/B) |
| Section 508 | Federal procurement accessibility | Long-standing | (A) |

**This is real institutional demand — and note the direction of the 2026 news is a one-year delay in the US, not an acceleration.** Regulation creates budget for vendors that can produce conformance documentation, pass procurement review, and sign a data-processing agreement. It creates almost no demand for a $139/year consumer App Store subscription. **If regulation is your thesis, you are building a B2B company, and you should know that on day one.**

### The B2B / institutional path

| Dimension | Consumer subscription | Institutional (schools, universities, libraries, publishers, enterprises) |
|---|---|---|
| CAC | $37–333 per payer, model-dependent (illustrative) | High absolute, low per seat; relationship- and RFP-driven |
| Churn | Severe — **AI monthly plans retain 36% worse over 12 months (B)** | Low; annual/multi-year contracts, switching costs are institutional |
| Contract size | $99–139/yr | **Kurzweil 3000: ~$500/yr single user; $2,000/10 users; $3,000/30; $4,000 site licence. Read&Write: ~$150/yr single; ~$15/student/yr at 150+; ~$2.25/student/yr district-wide (C, secondary)** |
| Sales cycle | Instant | Months to a full budget year |
| Competitive pressure | Extreme; free OS alternatives | Moderate; entrenched incumbents but procurement-gated |
| Moat | Thin | **Conformance, references, integrations, procurement approval** |

Note what the Read&Write district pricing implies: **$2.25 per student per year district-wide.** The institutional path is not high-margin-per-seat; it is high-*retention* and high-*volume* per sale, and it is gated by exactly the slow conformance work that consumer competitors will not do. Bookshare being **free to qualifying US users** also caps what can be charged for the disability-access use case specifically.

### The bear case, argued properly

This is the strongest version of the argument, and I think it is closer to correct than the bull case.

1. **TTS is commoditised and still deflating.** ElevenLabs cut TTS pricing by **up to 55% in a single announcement (May 2026)**; Azure HD went **$30 → $22 in March 2026**; Google WaveNet reportedly fell to **$4/1M**. Open-weight models under Apache/MIT licences — Kokoro at 82M parameters running 210× real-time on a consumer 4090, Chatterbox reportedly preferred over ElevenLabs in **63.75%** of blind comparisons (C) — mean the floor is approaching the cost of electricity. **A product whose value proposition is "good voices" is selling something that is becoming free.**
2. **The OS ships it.** Free, pre-installed, improving, on both platforms, plus in Chrome, plus in Kindle. You are not competing with NaturalReader; you are competing with a two-finger swipe.
3. **The best-funded competitor is vertically integrated and gives yours away.** ElevenReader's free tier is **10 hours/month plus thousands of audiobooks**, backed by an **$11B, ~$500M-ARR** parent that pays marginal compute cost where you pay list price.
4. **The unit economics punish success.** The COGS table shows engaged users destroying margin at premium voice tiers. Combined with the RevenueCat finding that **AI apps churn ~30% faster**, you get the worst combination available: expensive users who leave.
5. **The category's adjacent graveyard is well-populated.** Pocket — a decade-old brand with a corporate parent — shut down in July 2025.
6. **It may be a feature, not a company.** Read-aloud is a capability that belongs in the reading surface: the browser, the OS, the e-reader, the LMS, the PDF viewer. Every one of those surfaces has an owner with more distribution than a standalone app can buy. The historical pattern for such capabilities is absorption.

**The bull case, stated fairly, is narrower than it looks:** the *ingestion* problem is genuinely unsolved by the platforms, cross-platform continuity is genuinely absent from OS features, accessibility conformance is genuinely a procurement moat, and institutional budgets are genuinely mandated by law. Those are four real things. **None of them is "a better TTS app."**

---

## Verdict

**Do not build a general-purpose Speechify clone. The consumer flat-rate read-aloud category is closing, not opening.**

The reasoning is not vibes, it is three facts that compound: the platform gives the core function away free and pre-installed; the best-capitalised competitor owns its own model and can price below your marginal cost; and the flat-rate subscription arithmetic goes negative at 2–6 listening hours per month at any voice quality good enough to justify paying. Add the RevenueCat base rate — **~81% of subscription apps never reach $1,000/month** — and the expected value of the generic version of this product is close to zero.

**Three forms remain defensible, in descending order of my confidence:**

1. **A vertical where the hard part is the document, not the voice.** Scientific papers with equations and figure references, legal filings with citation structure, financial disclosures, technical standards, clinical documents. The buyer has money, the corpus defeats OS-level readers and general clones alike, and the moat is ingestion engineering that is invisible from the outside and therefore not quickly copied. Price per seat or per usage, sell to the institution.
2. **An institutional accessibility product in one jurisdiction and one buyer type.** Ride the EAA (applied 28 June 2025) and Title II (now 2027/2028) obligations into education or public-sector procurement. Accept a two-to-three-year runway to first meaningful revenue, invest early in EN 301 549 / WCAG 2.1 AA conformance and documentation, and expect per-seat prices closer to Read&Write's $2.25–15 than to $139. This is a slow, real, defensible business, and it is not a venture-scale one.
3. **A non-English wedge in a language where commercial TTS quality is poor and no local reader exists** — but only combined with an institutional or education buyer, because consumer willingness to pay in those geographies does not support the COGS.

**Whichever form: never sell an uncapped flat rate over metered inference.** Cap hours explicitly, meter premium voices, default to cheap or self-hosted open-weight synthesis, and cache aggressively. ElevenReader's "10 hours a month" is the correct shape of the offer, and it is stated on the pricing page for a reason.

**And do not raise venture capital for this.** It does not clear a fund-returner bar, the category TAM is low-single-digit billions on the most credible reading, and taking institutional money forces growth rates the unit economics cannot fund. The honest form of this business is small, bootstrapped, deliberately niche, and profitable — which is a legitimate outcome, and a far more probable one than the alternative.

**The general lesson, which outlives this case:** when the build gets cheap, the value migrates to whatever did *not* get cheap. Here that is document ingestion, content licences, procurement approval, and distribution. A founder starting today should pick a problem where the expensive part is one of those, and specifically should not pick one where the expensive part used to be code.

---

## Open questions / what could not be verified

1. **No TTS API price was read from a vendor pricing page.** Egress was blocked for ElevenLabs, AWS, OpenAI, and Azure; Google returned truncated content. Every price in Part 3 is (A\*). **Re-price against live vendor pages before using the COGS model for any decision.**
2. **Speechify's actual revenue is unknown.** $17.6M ARR (C) is irreconcilable with $500K/month creative spend (A) and with a ~$2M single-month third-party estimate (C). No audited figure exists; Speechify is private.
3. **The reported "$50M at $120M valuation, Northstar Ventures" round could not be dated or corroborated.** Treat as unverified.
4. **Whether Speechify acquired Voice Dream could not be confirmed or refuted.** Searches surfaced only cross-linked marketing pages on both domains. Left unstated in the report rather than guessed.
5. **No sound before/after data on software build cost (2015 vs 2026) exists publicly.** Everything available is agency sell-side pricing. Answering it would require audited engineering spend for matched products at both dates.
6. **Install→trial-start conversion has no public benchmark.** The 20% used in the worked example is an unsourced assumption and drives the result heavily.
7. **The "professionals with reading loads" segment — the highest-WTP consumer segment — has no public sizing.** This is the most commercially important unknown here. Answering it needs primary research: a survey with a screening question on reading volume and a price-sensitivity instrument.
8. **CAC by channel for this specific category is unavailable.** All CPI/CAC figures are cross-category agency benchmarks (C).
9. **Global consumer app spend figures conflict** (~$150B vs. $270B, both Sensor Tower-attributed). Neither report was accessible.
10. **US external-payment-link commission is in active litigation** as of August 2026 and could change materially within months.
11. **Learning Ally pricing, and OCR/document-AI per-page costs, could not be sourced** and are therefore absent from the COGS model — which consequently *understates* the true cost of scanned-document ingestion.
12. **No independent audit exists for any of the AI gross-margin benchmarks** (ICONIQ-attributed 23% inference-as-share-of-revenue and the 50–60% margin range are secondary reporting of private datasets).

---

## Sources

**Funding, base rates, and startup economics**
1. "AI firms capture 61% of global venture capital in 2025", OECD, oecd.org, Feb 2026 — accessed 2026-08-21. **(B)**
2. "Venture capital investments in artificial intelligence through 2025 (full report)", OECD, oecd.org, 2026 — accessed 2026-08-21. **(B)**
3. "Q1 2026 Shatters Venture Funding Records As AI Boom Pushes Startup Investment To $300B", Crunchbase News, news.crunchbase.com, 2026 — accessed 2026-08-21. **(B)**
4. "State of Pre-Seed: Q1 2026", Carta, carta.com — accessed 2026-08-21. **(B)**
5. "Solo Founders Report 2025", Carta, carta.com — accessed 2026-08-21. **(B)**
6. Howell, T. & Bingham, C., "Solo vs. Co: Under What Conditions Can Solo-Founded Ventures Perform as Well as Co-Founded Ventures", Mack Institute, Wharton, mackinstitute.wharton.upenn.edu — accessed 2026-08-21. **(B)**
7. "22.1% of New US Businesses Close Within a Year", LendingTree, lendingtree.com, 2025 — accessed 2026-08-21. **(B)**
8. "Business Failure Statistics: What the Data Says About Startup Survival", Founder Reports, founderreports.com — accessed 2026-08-21. **(C)**, reporting BLS BED data.
9. "AI Startup Gross Margins Run 50 to 60 Percent Not the SaaS 80 Percent", Avante Ventures, avanteventures.com, 2026 — accessed 2026-08-21. **(C)**
10. "The AI COGS Problem: SaaS Gross Margin Compression 2026", SaaS Mag, saasmag.com — accessed 2026-08-21. **(C)**
11. "40+ Successful Bootstrapped Startups Without Funding", Eqvista, eqvista.com — accessed 2026-08-21. **(C)**
12. "MVP Development Cost in 2026", Ideas2IT / TeaCode / Enacton (agency price lists) — accessed 2026-08-21. **(C)**
13. "AI Code Generation Statistics 2026", Uvik, uvik.net — accessed 2026-08-21. **(C)**

**App-market benchmarks, platform rules, distribution**
14. "State of Subscription Apps 2026", RevenueCat, revenuecat.com — accessed 2026-08-21 (page blocked; figures via secondary reporting). **(B)**
15. "The State of Subscription Apps in 10 minutes: benchmarks for 2026", RevenueCat blog — accessed 2026-08-21. **(B)**
16. "The Top 10 Learnings From RevenueCat's State of Subscription Apps", SaaStr, saastr.com, 2026 — accessed 2026-08-21. **(B)**
17. "Report: 80% of mobile apps fail to earn $1,000/month in subscription revenue", Start.io, start.io — accessed 2026-08-21. **(B)**
18. "Expanded billing choice and lower fees on Google Play", Android Developers Blog, android-developers.googleblog.com, Jun 2026 — accessed 2026-08-21. **(A\*)**
19. "Service fees" and "Understanding Google Play's lower service fees", Play Console Help, support.google.com — accessed 2026-08-21. **(A\*)**
20. "Apple Wants to Charge Developers Up to 15 Percent for Linking Outside the App Store", MacRumors, macrumors.com, 13 Aug 2026 — accessed 2026-08-21. **(B)**
21. "Apple Wins Ability to Charge Fees on External Payment Links as Appeals Court Modifies Epic Injunction", MacRumors, 11 Dec 2025 — accessed 2026-08-21. **(B)**
22. "Apple must allow External Payment Links: what the ruling means", RevenueCat blog — accessed 2026-08-21. **(B)**
23. "2026 State of Mobile" and "5-Year Market Forecast", Sensor Tower, sensortower.com — accessed 2026-08-21 (conflicting figures; see Open Questions). **(B)**
24. "App downloads statistics: Top countries by app downloads in 2025", AppTweak, apptweak.com — accessed 2026-08-21. **(C)**
25. "Mobile App User Acquisition Cost: Benchmarks, Formula & Why Intent Matters (2026)", AdAction, adaction.com — accessed 2026-08-21. **(C)**
26. "CAC Payback Period for Mobile Apps", Admiral Media, admiral.media — accessed 2026-08-21. **(C)**
27. "App Store Statistics 2026", SQ Magazine / Axis Intelligence — accessed 2026-08-21. **(C)**

**TTS products, pricing, and the competitive field**
28. "Speechify Raises $10M at a $100M Valuation", Speechify newsroom, speechify.com/news, Jan 2024 — accessed 2026-08-21. **(A)**
29. "20VC: What I Learned from 100 of the Best CEOs… How We Will Spend More on Tokens than Salaries with Cliff Weitzman, Speechify", The Twenty Minute VC, May 2026 — accessed 2026-08-21. **(A, founder statement)**
30. "Cliff Weitzman: AI Tokens Will Outspend Salaries as Speechify Runs 1,300 Ads a Day", BigGo Finance, finance.biggo.com, 2026 — accessed 2026-08-21. **(C)**
31. "Speechify Revenue 2025: $17.6M ARR, $100M Valuation", Latka, getlatka.com — accessed 2026-08-21. **(C)**
32. "Pricing", ElevenReader, elevenreader.io/pricing — accessed 2026-08-21 via secondary reporting. **(A\*)**
33. "200,000 premium audiobooks are now available in ElevenReader", ElevenLabs blog, elevenlabs.io — accessed 2026-08-21. **(A)**
34. "ElevenLabs raises $500M Series D at $11B valuation", ElevenLabs blog, Feb 2026 — accessed 2026-08-21. **(A)**
35. "ElevenLabs Cuts API Pricing Up to 55% and Introduces Pay-as-you-go", CreateWith, createwith.com, May 2026 — accessed 2026-08-21. **(C)**
36. "Google Cloud Text-to-Speech Pricing: $4–$160/1M Chars Across 7 Voice Types (2026)", TextToLab, texttolab.com — accessed 2026-08-21. **(A\*)**
37. "Azure Text to Speech Pricing (2026)" and "OpenAI TTS Pricing (2026)", TextToLab — accessed 2026-08-21. **(A\*)**
38. "Best TTS APIs in 2026: ElevenLabs, Google, AWS & 9 More Compared", Speechmatics, speechmatics.com — accessed 2026-08-21. **(C)**
39. "Best Open Source TTS Models in 2026: Kokoro, Chatterbox, Fish Audio Compared", Speakeasy, tryspeakeasy.io — accessed 2026-08-21. **(C)**
40. "Best Text-to-Speech TTS Models in 2026: A Benchmark-Based Comparison", MarkTechPost, marktechpost.com, 30 May 2026 — accessed 2026-08-21. **(B)**
41. "OpenBibleTTS: Large-Scale Speech Resources and TTS Models for Low-Resource Languages", arXiv:2606.09553 — accessed 2026-08-21. **(B)**
42. "Use Listen to this page mode in Chrome", Google Chrome Help, support.google.com — accessed 2026-08-21. **(A)**
43. "Use TalkBack to browse the web with Chrome", Android Accessibility Help, support.google.com — accessed 2026-08-21. **(A)**
44. "Learn more about audiobooks with virtual voice", Amazon KDP Help, kdp.amazon.com — accessed 2026-08-21. **(A)**
45. "Audible is expanding its AI-narrated audiobook library", TechCrunch, techcrunch.com, 13 May 2025 — accessed 2026-08-21. **(B)**
46. "Mozilla is shutting down read-it-later app Pocket", TechCrunch, 22 May 2025 — accessed 2026-08-21. **(B)**
47. NaturalReader and Voice Dream pricing, via aggregator comparisons (aisotools.com, frateca.com) — accessed 2026-08-21. **(C)**

**Market sizing, demand segments, regulation**
48. "U.S. Audiobook Sales Grew 9% in 2025, to $2.43 Billion", Publishers Weekly, publishersweekly.com, 2026, reporting the Audio Publishers Association Sales Survey — accessed 2026-08-21. **(B)**
49. "Audio Publishers Association Reports Audiobook Sales Jump 9% to $2.43 Billion", Library Journal infoDOCKET, 5 Jun 2026 — accessed 2026-08-21. **(B)**
50. "Audiobooks Market Size, Share & Trends Report, 2026-2033", Grand View Research — accessed 2026-08-21. **(C, no published methodology)**
51. "Audiobook Market Size, Trends & Industry Overview, 2031", Mordor Intelligence — accessed 2026-08-21. **(C)**
52. "Text-To-Speech Market Size Analysis Report 2026-2030", The Business Research Company — accessed 2026-08-21. **(C)**
53. "Text-to-Speech Market Size, Share & Trends Report 2026-2034", Polaris Market Research — accessed 2026-08-21. **(C)**
54. "Duolingo Revenue and Usage Statistics (2026)", Business of Apps, businessofapps.com, reporting Duolingo's public filings — accessed 2026-08-21. **(A/B)**
55. "Language Learning Revenue and Usage Statistics (2026)", Business of Apps — accessed 2026-08-21. **(C)**
56. "Vision impairment and blindness", WHO fact sheet, who.int — accessed 2026-08-21. **(A)**
57. "Trends in prevalence of blindness and distance and near vision impairment over 30 years", Global Burden of Disease Study analysis, PMC7820390 — accessed 2026-08-21. **(B)**
58. "Prevalence of ADHD in Adults: An Umbrella Review of International Studies", PMC11859750 — accessed 2026-08-21. **(B)**
59. Dyslexia prevalence (NIH- and International Dyslexia Association-attributed figures), via secondary aggregators — accessed 2026-08-21. **(C, secondary)**
60. "European Accessibility Act Goes Live", Davis Wright Tremaine, dwt.com, Jul 2025 — accessed 2026-08-21. **(B)**
61. "European Accessibility Act 2026: EAA Compliance Guide", Level Access, levelaccess.com — accessed 2026-08-21. **(C)**
62. "Are Microenterprises Exempt from EAA Requirements?", Kris Rivenburgh, krisrivenburgh.com — accessed 2026-08-21. **(C)**
63. "ADA Title II Website Accessibility Regulations: Will Your Organization Meet the April 24, 2026 Compliance Deadline?", Venable LLP, venable.com, Apr 2026 — accessed 2026-08-21. **(B)**
64. "DOJ Extends Title II ADA Web Accessibility Rule Compliance Deadlines", Consumer Financial Services Law Monitor, Apr 2026 — accessed 2026-08-21. **(B)**
65. "Comprehensive Guide to Kurzweil 3000: Pricing, Features, and Comparison", Speechify blog — accessed 2026-08-21. **(C, competitor-published)**
66. "What Reading Tools Are Teachers Using in Their Classrooms?", Bookshare, bookshare.org — accessed 2026-08-21. **(A)**
67. "Assistive Technology Statistics and Facts (2026)", Market.us — accessed 2026-08-21. **(C)**

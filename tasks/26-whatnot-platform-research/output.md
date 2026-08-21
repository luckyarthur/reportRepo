# Whatnot — Audience Segmentation, Seller Economics, Growth, Earnings Distribution, and Platform Risk

**Coverage:** Buyer base and segmentation, seller monetization and unit economics, growth playbook, earnings distribution, geographic distribution, and enforcement/ban risk.
**Research performed:** 2026-08-21. **All figures are point-in-time.** **Whatnot is a private company: it publishes no audited financials and no creator-payout report.** Every headline number about it is unaudited.

> **Not financial, legal, or tax advice.** This is a market-research report. The gambling-law and 1099/tax material below describes reported facts and disputed claims, not legal guidance. Consult a qualified professional before acting on any of it.

---

## Methodology and access constraint — read before the numbers

Research was conducted under a **partial web-access constraint**: web *search* was available, but **direct page fetching was blocked by this environment's network egress policy for every external host attempted**, including `whatnot.com` and `help.whatnot.com`. Every attempt returned `EGRESS_BLOCKED`.

This bears directly on this task's central instruction — that fee schedules and policy text be **quoted from Whatnot's official Help pages with an access date**, because "an out-of-date fee percentage invalidates every unit-economics calculation downstream." **That verification was not achievable.**

What was done instead: fee and policy figures below are drawn from **multiple independent secondary sources that agree with one another**, are linked to the official Help Center article they describe, and are labelled **(A\*)** — official in origin, secondary in verification. **Treat every fee and policy figure here as "consistently reported as of 2026-08" rather than "read from the official page."** The worked unit-economics models in Part 2 inherit this uncertainty and are labelled illustrative throughout.

A second gap: **tier (C) community sources could not be retrieved.** Repeated searches for r/whatnotapp and seller-forum discussion of margins, shipping costs, and bans returned no usable Reddit or Discord threads. Since community reporting is often the only window into real seller economics and into ban experiences, **this is a material gap**, and the report says so rather than substituting invention. See Open Questions.

---

## Evidence-tier note

Every figure carries a tier:

- **(A) Company-stated** — Whatnot's blog, newsroom, press releases, Help Center and policy pages, funding announcements, executive statements. **GMV and seller-earnings figures in this tier are self-reported, unaudited, and promotional in purpose.** They are selected and framed by a company raising capital.
- **(A\*)** — Official in origin but verified only through consistent secondary reporting (see constraint above).
- **(B) Independent** — business press with its own sourcing, app-store and traffic intelligence (Similarweb, Sensor Tower), court and regulatory filings, analyst reports.
- **(C) Community-reported** — seller posts, forums, agency/consultancy blogs, fee-calculator sites. **Anecdotal and non-representative; never aggregated into a rate.**

Where a widely-repeated figure traces back to a company press release, this report says so explicitly.

---

## TL;DR

- **Whatnot was valued at $20 billion in August 2026** after a **$545M Series G** led by Iconiq, Lightspeed, and Avra — up from $4.97B in January 2025 and $11.5B in October 2025. Roughly **4× in nineteen months. (B)**
- **Company-stated GMV: >$8 billion in 2025**, roughly doubling year over year from ~$3B in 2024 — and **>$8 billion in the first half of 2026 alone**, matching all of 2025 in six months. **(A, unaudited)**
- **The fee stack is ~11–13% all-in**: 8% commission (US/CA/AU) or 6.67% + VAT (UK/EU), plus **2.9% + $0.30** processing. **The $0.30 flat fee is the dominant margin killer at low price points** — it alone is 6% of a $5 item. **(A\*)**
- **Company-stated seller earnings are extraordinarily selected**: "sellers who stream daily average approaching $60,000/month" and "two-thirds of active sellers earn over $10,000/month" both apply to **filtered subsets** (daily streamers; 6+ months tenure and 2+ streams/week). **These are not typical-seller figures and should never be read as such. (A, promotional)**
- **500+ sellers have passed $1M in annualized sales**, and **1 in 8 sellers is full-time** (+20% YoY) — which also means **roughly 7 in 8 are not**. **(A)**
- **The total seller count, the median seller's earnings, and the top-decile share of GMV are all not publicly available.** The distribution's shape is **assumed** power-law by analogy, **not measured** for Whatnot. **(Open question)**
- **Whatnot faces active arbitration claims alleging its randomized card breaks constitute an illegal lottery** under California Penal Code §319, with RICO allegations and an "unregulated online casino" characterization. **15 claims filed, ~30 more expected. (B)** This is the single largest platform-level risk to the break-driven segment.
- **The enforcement ladder is documented and unusually specific**: warnings → loss of early payout privileges (≤30 days) → **increased commission (≤30 days)** → suspension (≤30 days) → permanent ban; balances after a permanent ban are paid **~60 days** after the action. **(A\*)**
- **Nine markets**: US, Canada, UK, Germany, France, Netherlands, Belgium, Austria, Australia. **European sellers grew 600% YoY. (A)** Per-country buyer and GMV shares are **not publicly available**.

---

## Background — what Whatnot is and where it came from

**The mechanic.** A seller runs a live video stream and sells inventory in real time, either by **live auction** (a timed countdown per item, bids in chat, lowest starting prices often $1) or **buy-it-now**. Buyers watch, bid, and check out without leaving the stream; payment is stored, and multiple wins to one buyer can be **combined into a single shipment** — a detail that turns out to be central to seller margins. A distinctive third format is the **break** (or "rip"): the seller sells "spots" — a team, a division, a random slot — then opens sealed product live, and whatever hits belongs to whoever bought that spot. This format is both a major GMV driver and the subject of the litigation in Part 6.

**Funding and valuation history (B):**

| Round | Date | Amount | Valuation | Lead investors |
|---|---|---|---|---|
| Series E | Jan 2025 | $265M | **$4.97B** | Greycroft, DST Global, Avra |
| Series F | Oct 2025 | $225M | **$11.5B** | DST Global, CapitalG |
| Series G | **Aug 2026** | **$545M** | **$20B** | Iconiq, Lightspeed, Avra |

Total raised is reported at approximately **$1.52B across 9 rounds from 31 investors (C, Tracxn)**. Note that the Series G closed roughly two weeks before this report's research date, and that **the valuation more than doubled in the ten months between Series F and G.**

**Category expansion.** Whatnot began in collectibles — Funko Pops, then trading cards — and expanded into **sports cards, TCG, sneakers, comics, vintage fashion, jewelry, coins, and electronics**. As of 2026, **baseball cards and trading card games remain the largest categories (C)**, while **lifestyle categories (fashion, beauty, electronics, jewelry) are the fastest-growing (A)**. Sneakers are a notable vertical, with one report citing an average sneaker shopper spending **$500/month (C)**.

**Markets.** US first, then **Canada and the UK (2023/24)**, then **France, Germany, Netherlands, Belgium, Austria**, and **Australia (early 2025)** — nine markets. **(A/B)**

**Competitive position.** The direct comparison set:

| Platform | Position | Fee note |
|---|---|---|
| **TikTok Shop Live** | Largest threat by reach — **150M+ US users (C)**, algorithmic push of live content | **5% first 90 days, then 8% (C)** |
| **eBay Live** | Incumbent marketplace with vast audience, weaker live-native culture | eBay standard rates |
| **Fanatics Live** | Direct competitor in **sports cards and breaks**, with licensing and supply advantages | Not verified |
| **Poshmark Posh Shows** | Fashion resale live, **~100M member community (B)**; up to 50 items per show | Poshmark standard rates |
| **CommentSold** | Software for sellers running live commerce on their own channels | SaaS model |

**The reference case is China.** Live commerce there is mature in a way the US market is not: **Douyin's live commerce drove ~40% of its e-commerce revenue in 2025, on the order of $480B GMV (C)**, in a fully closed loop — content, ads, payment, and fulfilment in one app. Whatnot's US GMV of $8B sits roughly **two orders of magnitude** below that. Read either as enormous headroom or as evidence that Western live commerce may not replicate Chinese adoption; the honest position is that **the format's Western ceiling is unmeasured.**

---

## Part 1 — The user picture and segmentation

### Demographics — measured vs. inferred

**Measured (B, traffic intelligence):** Whatnot.com's audience is reported at **57.19% male / 42.81% female**, with **25–34 the largest age bracket**.

**Company-stated (A):** **Gen Z and Millennials are ~75% of users**, 18–34 dominant, and **the share of women has doubled in the past year** — consistent with the stated pivot into fashion, beauty, and jewelry.

**Inferred, not measured:** income and household composition. No credible income data was found. Any claim about Whatnot buyer income is inference from category composition, and this report does not make one. Location is covered in Part 5.

**A caution on the traffic-intelligence figures:** Similarweb-type data measures **web** visitors. Whatnot is **app-first**, so the web panel may not represent the buying population. Treat the gender and age splits as directional.

### Behavioural profile

This is the weakest-sourced area of the report, and the gap is worth naming. **Session length, purchase frequency, average order value, repeat-purchase rate, and time-of-day patterns are not published by Whatnot and were not found in independent measurement.** What is documented:

- **Over 20 million new accounts were created in the last year (A)** — an acquisition figure, not an active-buyer figure.
- **European sellers host over 20,000 hours of shows weekly (A)** — a supply-side proxy for viewing volume.
- The **impulse/entertainment dimension** is structurally central: an auction with a countdown, a live host, and a chat room is designed to compress the decision window. That is a design observation, not a measured behaviour.

### Motivations

Why buy this way rather than from a static listing:
- **Auction thrill and price discovery** — the possibility of winning below market.
- **Scarcity and FOMO** — one item, one countdown, no second chance.
- **The rip** — the break format's chance-based payoff, which is entertainment and wager simultaneously.
- **Community and parasocial connection** — buyers return to a *seller*, not to a catalogue. Regulars are greeted by name.
- **Discovery and serendipity** — the stream surfaces things the buyer wasn't searching for, which static marketplaces cannot do.
- **Trust** — graded slabs and authenticated items reduce the risk that makes remote collectible buying hard.

### The gambling-adjacent dynamic

This must be stated plainly, without moralizing and without omission. **Breaks and sealed/mystery products have a chance-based payoff structure**: the buyer pays a fixed price for a randomized outcome with a wide value distribution and a negative expected value in aggregate (the seller's margin comes out of the pool). The buyers most engaged with this format are, structurally, the buyers most exposed to loss.

This is not merely an observation — **it is the subject of active litigation.** As of 2026, arbitration claims allege that randomized breaks constitute an **illegal lottery under California Penal Code §319**, and characterize the platform as an "unregulated online casino" operating without the self-exclusion lists and spending limits required of licensed operators **(B)**. Full detail in Part 6.

Industry commentary has also flagged that the format "blurs the line between shopping and gambling-style engagement" **(B)**. For a seller, the practical implication is that **the highest-velocity segment is also the segment carrying the most regulatory risk**, and business models built entirely on it are exposed to an outcome no seller controls.

### Segmentation model

Eight segments, defined on category interest, motivation, price sensitivity, AOV, frequency, auction susceptibility, and — the decisive column — **whether they are profitable to court**.

| # | Segment | Primary category | Motivation | Price sensitivity | Typical AOV | Frequency | Auction susceptibility | Profitable to court? |
|---|---|---|---|---|---|---|---|---|
| 1 | **The Break Regular** | Sports cards, TCG sealed | Chance payoff, community ritual | **Low** | Med–High | **Very high** (multiple/week) | **Very high** | **Yes — highest velocity**, but the segment carrying regulatory risk |
| 2 | **The Set Collector** | TCG/sports singles, comics, coins | Completing a defined set | Medium | **Low** ($10–40) | High | Medium | **Yes** — predictable, loyal, but $0.30 fee bites hard |
| 3 | **The Investor / Reseller** | Graded slabs, sealed, sneakers | Margin; buying below comp | **Very high** | **High** | Medium | **Low** — disciplined bidders | **Marginal** — they compress your margin by design |
| 4 | **The Whale** | High-end graded, rare, luxury | Trophy acquisition, status | **Very low** | **Very high** ($500+) | **Low** | Medium | **Yes — disproportionately**; the 0% commission above $1,500 targets exactly this |
| 5 | **The Entertainment Viewer** | Any | The show; the host; ambient company | High | **Very low / zero** | High viewing, low buying | Low | **No directly** — but they are your concurrency, which drives placement |
| 6 | **The Bargain Hunter** | Bulk lots, clearance, mixed | Winning cheap | **Extreme** | **Very low** | Medium | **High** for $1 starts | **No** — the classic margin trap |
| 7 | **The Nostalgia Buyer** | Vintage toys, retro games, 90s cards | Emotional recall | Low–Medium | Medium | **Low**, episodic | Medium | **Yes, selectively** — high margin, low frequency |
| 8 | **The Fashion/Lifestyle Buyer** | Vintage clothing, jewelry, beauty | Style, thrift discovery, value | Medium | Medium ($40–80) | Medium–High | Medium | **Yes — the growth segment**; skews female, lower COGS |

**Which are growing.** Company-stated data points to segment 8: **lifestyle is the fastest-growing category set and the female share of users has doubled (A)**. Segment 1 remains the GMV engine but is the one exposed to the litigation. Segments 3 and 6 are where new sellers lose money — the reseller buys only below your cost basis, and the bargain hunter trains your audience to expect $1 outcomes.

**The strategic read:** a seller's profitability depends less on total audience than on the **mix** between segments 1/2/4/7/8 and segments 3/5/6. A stream full of segment 5 and 6 viewers can show high concurrency and produce no margin.

---

## Part 2 — Seller monetization and unit economics

### The fee stack

**(A\*) — official in origin, verified via consistent secondary reporting, 2026-08. Not read from the Help Center. Verify before relying on it.**

| Component | Rate | Charged on |
|---|---|---|
| **Commission — US / Canada / Australia** | **8%** | **Sale price only** (excludes shipping and taxes) |
| **Commission — UK / EU** | **6.67% + VAT** | Sale price only |
| **Payment processing** | **2.9% + $0.30 per order** | **Total order value** (sale price **+ shipping + taxes**) |
| **High-value promotion** (from **2026-01-14**) | **0% commission on the portion of sale price above $1,500**, select categories | Standard processing still applies |
| **Effective all-in** | **~11–13%** of sale price | Varies with price point and shipping |

**The structural insight most fee summaries miss:** the two fees have **different bases**. Commission is charged on the item; processing is charged on item + shipping + tax. **This means shipping revenue is taxed by the processing fee even though it is not seller margin** — the seller pays 2.9% on money that passes straight through to the carrier.

**And the flat $0.30 is regressive to the point of being decisive at low AOV:**
- On a **$5** item, $0.30 alone is **6%** of revenue **(C, and arithmetically verifiable)**.
- On a **$3** sale, total fees are ~$0.63 — the seller nets **$2.37, losing ~21%** to fees **(C, arithmetic confirmed: 8% = $0.24; 2.9% = $0.09; + $0.30)**.

**A $20-AOV business and a $150-AOV business are not the same business.** The former loses roughly 13% to fees; the latter roughly 11%. Combined with per-order labor and packing costs that are near-constant regardless of price, **AOV is the single most important structural variable a seller chooses.**

### Revenue models a seller can run

1. **Straight retail resale** — buy wholesale/clearance, sell live. Predictable, capital-hungry, margin set at sourcing.
2. **Auction arbitrage** — source from undervalued channels (estate sales, local, bulk) and let the live auction find market price. Highest skill component.
3. **Breaks / rips** — sell spots, open sealed product live. **Highest velocity and engagement; carries the regulatory exposure in Part 6.** Margin is the spread between spot revenue and box cost.
4. **Consignment** — sell others' inventory for a cut. **Near-zero inventory capital** — structurally the best risk-adjusted entry for an undercapitalized seller, and underused.
5. **Grading and flipping** — buy raw, grade, sell slabbed. Long capital cycle, grading fees, real downside if grades disappoint.
6. **Personal-collection liquidation** — one-time, not a business.
7. **Made-by-seller goods** — highest margin, capped by production capacity.
8. **Bulk/lot clearing** — moves dead inventory; low margin, high labor.
9. **Affiliate/referral programs** — Whatnot has run referral incentives; **current terms not verified** and excluded from the models below.

### Worked unit economics — three category profiles

> **All three models are ILLUSTRATIVE.** Fee rates are (A\*); **every other input is a stated assumption**, not measured data. They assume **100% sell-through**, and exclude returns, chargebacks, unsold-inventory carry, equipment, and taxes. A **reality adjustment** follows. These are arithmetic demonstrations of fee structure, not earnings claims.

**Model A — TCG singles, $20 AOV**

| Line | Value |
|---|---|
| Assumptions | 3-hr stream, 60 orders, $20 AOV, $5 shipping collected/order, COGS 50% |
| Gross item sales | $1,200.00 |
| Shipping collected | $300.00 |
| **Total in** | **$1,500.00** |
| Commission (8% × $1,200) | −$96.00 |
| Processing (2.9% × $1,500 + $0.30 × 60) | −$61.50 |
| COGS / sourcing (50%) | −$600.00 |
| Actual shipping paid ($4.50 × 60) | −$270.00 |
| Supplies ($0.75 × 60) | −$45.00 |
| **Net margin** | **$427.50** (35.6% of item sales) |
| Labor: 3 stream + 4 pack/ship + 3 source/prep | **10 hours** |
| **Effective hourly** | **~$42.75** |

**Model B — Sports cards, $150 AOV**

| Line | Value |
|---|---|
| Assumptions | 3-hr stream, 20 orders, $150 AOV, $8 shipping collected, COGS 65% |
| Gross item sales | $3,000.00 |
| Shipping collected | $160.00 |
| **Total in** | **$3,160.00** |
| Commission (8% × $3,000) | −$240.00 |
| Processing (2.9% × $3,160 + $0.30 × 20) | −$97.64 |
| COGS / sourcing (65%) | −$1,950.00 |
| Actual shipping paid ($7 × 20) | −$140.00 |
| Supplies ($2 × 20) | −$40.00 |
| **Net margin** | **$692.36** (23.1% of item sales) |
| Labor: 3 stream + 2 pack/ship + 5 source/research | **10 hours** |
| **Effective hourly** | **~$69.24** |

**Note the trade-off:** Model B earns 62% more per hour than Model A but requires **$1,950 of inventory capital per stream** versus $600 — and carries far more concentrated inventory risk if a category cools.

**Model C — Vintage fashion, $60 AOV**

| Line | Value |
|---|---|
| Assumptions | 3-hr stream, 35 orders, $60 AOV, $7 shipping collected, COGS 30% |
| Gross item sales | $2,100.00 |
| Shipping collected | $245.00 |
| **Total in** | **$2,345.00** |
| Commission (8% × $2,100) | −$168.00 |
| Processing (2.9% × $2,345 + $0.30 × 35) | −$78.51 |
| COGS / sourcing (30%) | −$630.00 |
| Actual shipping paid ($7.50 × 35) | −$262.50 |
| Supplies ($0.60 × 35) | −$21.00 |
| **Net margin** | **$1,184.99** (56.4% of item sales) |
| Labor: 3 stream + 4 pack/ship + 8 sourcing + 3 photo/prep | **18 hours** |
| **Effective hourly** | **~$65.83** |

**Vintage fashion has the best margin percentage and the worst labor intensity** — sourcing is done one garment at a time. Its advantage is **low capital requirement**; its constraint is that it does not scale without hiring.

**Reality adjustment.** Apply plausible real-world frictions to Model A: 15% of sourced inventory never sells (−$90 carry), 3% of orders end in a return or claim (−$36), and self-employment tax at ~15% on net. Net falls from $427.50 to roughly **$256**, and the effective hourly from ~$42.75 to **~$25.60** — before any equipment, moderator pay, or software. **The gap between the headline model and the adjusted one is the gap most new sellers discover in month three.**

### The cost lines sellers underestimate

- **Sourcing capital and inventory risk** — the largest cash requirement, and it precedes all revenue.
- **Unsold-inventory carry** — the silent killer. Streams show what sold, never what didn't.
- **Shipping errors and lost packages** — absorbed by the seller.
- **Returns, buyer-protection claims, and chargebacks.**
- **Packing labor** — routinely **exceeds stream hours**, as every model above shows. This is the most consistently underestimated line in live selling.
- **Setup** — lighting, camera, audio, and a table; modest but real.
- **Co-host and moderator pay** — a solo seller cannot run chat, take bids, and present simultaneously past a certain concurrency.
- **Taxes and 1099 reporting** — payouts are reportable income. Sellers who treat gross payouts as profit and don't reserve for tax face a Q1 problem. *(Not tax advice.)*

### Off-platform leverage

Sellers naturally want to move regulars to Discord, Instagram, or a direct storefront — the audience is genuinely theirs. **But the platform's rules govern what may be solicited in-stream, and taking transactions off-platform to avoid fees is a circumvention violation** (Part 6). The defensible version is **building brand and audience off-platform while keeping transactions on it**; the undefensible version is soliciting direct payment. **The precise current boundary was not verifiable** — see Open Questions.

### Ranking of monetization approaches

| Approach | Margin | Capital required | Scalability | Risk |
|---|---|---|---|---|
| **Consignment** | Medium (cut of sale) | **Very low** | High — inventory is someone else's | **Low** — but reputational exposure to others' goods |
| **Made-by-seller goods** | **Highest** | Low–Medium | **Low** — capped by production | Low |
| **Vintage/thrift resale** | **High (30–55%)** | Low | **Low** — labor-bound sourcing | Low |
| **Breaks / rips** | Medium, **very high velocity** | **High** — sealed product is expensive | High | **Highest — active litigation risk** |
| **Retail/wholesale resale** | Medium (20–35%) | **High** | High | Medium — inventory obsolescence |
| **Grading and flipping** | Variable, potentially high | High + long cycle | Low | **High** — grade risk, long capital lock |
| **Bulk/lot clearing** | **Low** | Medium | Medium | Low |

**The best risk-adjusted entry point for a new, undercapitalized seller is consignment**, and it is the least discussed of these.

---

## Part 3 — Fastest realistic path to a profitable new channel

Each tactic is labelled **[Documented]** (platform guidance or verifiable policy) or **[Inferred]** (community/analyst inference — tier C, treat as hypothesis).

### Getting started

- **Seller application and approval** **[Documented]** — Whatnot gates selling behind an application, with category selection at signup. **Specific approval criteria and rejection reasons could not be verified** (Help Center inaccessible).
- **[Inferred]** Common rejection themes reported by analysts: incomplete identity verification, no sourcing/selling track record, and applying into a restricted category.
- **[Documented]** Whatnot maintains a **Seller Hub** and seller-education material.

### Category choice — a short rubric

Score a candidate category 1–5 on: **buyer demand depth**, **seller competition**, **capital required to stock**, **margin profile**, **AOV** (critical, per the $0.30 fee analysis), and **your genuine domain knowledge** — which in collectibles is not optional, because buyers detect ignorance instantly and it destroys trust in real time.

**The two structural rules the fee data supports:**
1. **Avoid sub-$10 AOV as a primary model.** The flat fee, packing labor, and shipping cost per order are near-constant; at $5 AOV they consume the business.
2. **Highest demand and highest competition are the same categories.** Sports cards and TCG have the deepest buyer pools *and* the most entrenched sellers. A new entrant generally does better in a **specific, defensible niche** within a large category than competing broadly.

### Discovery mechanics

**[Documented]:** streams surface through browse, category pages, follows, and notifications.

**[Inferred] — hypothesis, not fact.** Community and analyst consensus holds that placement responds to **concurrent viewership, sell-through rate, scheduling consistency, stream length, and follower engagement**, and that new sellers may receive some initial placement support. **Whatnot does not publish its ranking mechanics**, and no source found here documents them. **Anyone stating a specific placement formula is guessing.**

### Stream craft

- **Cadence** **[Inferred]** — a fixed, repeated schedule so regulars can find you. Consistency is the most-cited factor in seller commentary.
- **Opening** **[Inferred]** — early concurrency compounds; leading with a strong item builds the audience the rest of the stream sells to.
- **Auction pacing and starting prices** **[Inferred]** — **the "$1 start" debate**: low starts maximize participation and can exceed market price with enough concurrent bidders, but **with thin viewership they realize losses**, and the fee math is brutal (a $3 sale nets $2.37). The defensible position: **low starts require an audience you have not yet built** — start low only once concurrency supports it.
- **Giveaways** **[Documented as governed]** — subject to platform rules; see Part 6.
- **Moderation** **[Inferred]** — a moderator is effectively required past modest concurrency.
- **Repeat-buyer recognition** **[Inferred]** — naming regulars is the mechanism by which buyer loyalty transfers from category to seller. This is the durable asset.
- **Bundling and combined shipping** **[Documented feature]** — **the single most effective margin lever available, and it costs nothing.** Combining several wins into one shipment cuts per-order shipping and eliminates duplicate $0.30 charges. Analyst reporting states sellers who combine consistently report materially better margins on identical gross sales **(C)**.

### The first 90 days

**Milestones are illustrative, not measured.** Expect unprofitability through most of this period.

| Weeks | Focus | Realistic expectation |
|---|---|---|
| **1–2** | Application, category choice, setup, watch 20+ competitor streams end to end | **No revenue.** Learn pacing and pricing before broadcasting |
| **3–4** | First 4–6 streams, small inventory, deliberately modest goals | **Low single-digit viewers.** Losses likely after labor. Goal: operational fluency |
| **5–8** | Fixed schedule (2–3×/week), test formats, build shipping process | First repeat buyers. **Shipping ops become the bottleneck — this is where most sellers break** |
| **9–12** | Double down on what sold; cut what didn't; raise AOV; combine shipping | **Approaching breakeven on cash, rarely on labor** |

**Honest expectation:** most sellers who reach profitability are **not** profitable on an hourly-wage basis within 90 days. Cash-positive is a realistic 90-day goal; a defensible hourly rate is a 6–12 month goal, and many never get there.

### Metrics to track

| Metric | What it tells you | A bad reading implies |
|---|---|---|
| **Sell-through rate** | Pricing and demand match | Sourcing at too high a cost basis, or wrong category |
| **GMV per stream hour** | The core productivity number | Pacing too slow, or inventory too cheap |
| **AOV** | Fee efficiency and buyer quality | Below ~$15: the flat fee is eating you |
| **Viewer-to-buyer conversion** | Whether your audience is buyers or spectators | Segment 5/6 heavy audience — high viewers, no margin |
| **Repeat-buyer rate** | Whether you have a business or a series of transactions | No parasocial bond formed; you're competing on price |
| **Follower growth** | Compounding distribution | Inconsistent scheduling |
| **Net margin per stream** | Whether any of the above matters | Revisit sourcing before anything else |
| **Effective hourly rate** | **The only number that decides if this is a job** | You have bought yourself a demanding, low-wage job |

### Main failure modes

Drawn from analyst reporting and the structural economics above (**community-source corroboration was unavailable — see the access constraint**):

1. **Undercapitalization** — running out of sourcing capital before the audience exists.
2. **Sourcing at too high a cost basis** — the most common and least visible; the margin is lost at purchase, not at sale.
3. **Shipping operations collapsing under volume** — packing exceeds stream hours in every model above. Success creates this failure.
4. **Inconsistent scheduling** — destroys the regulars who are the whole business.
5. **Competing on price alone** — trains segment 6 and destroys margin permanently.
6. **Burnout** — the hours are the product. Streaming, sourcing, packing, and moderating is a 40+ hour week before it pays like one.

---

## Part 4 — Distribution of seller earnings

### What is actually known

All company-stated **(A)**, all unaudited, all released in a fundraising context:

| Claim | Population it applies to | Reading |
|---|---|---|
| **Sellers who stream daily average approaching $60,000/month** | **Daily streamers only** | **Extremely selected.** Daily streaming is close to a full-time job plus fulfilment. Says nothing about typical sellers |
| **Two-thirds earn over $10,000/month** | **Active sellers: 6+ months tenure AND 2+ streams/week** | **Double-filtered** — excludes everyone who quit and everyone casual. Survivors of survivors |
| **500+ sellers with $1M+ annualized sales** | Absolute count | Real and meaningful — but a **count**, not a rate. Without the denominator it implies nothing about odds |
| **Number earning >$10,000/month doubled YoY** | Growth rate | Consistent with platform growth; no base disclosed |
| **Count of sellers passing $1M cumulative doubled in 2025** | Growth rate | Same caveat |
| **1 in 8 sellers is full-time (+20% YoY)** | All sellers | **The most useful figure disclosed** — and it means **~7 in 8 are not full-time** |
| **20M+ new accounts created last year** | Accounts, not sellers | Buyer-heavy; not a seller metric |

**The "1 in 8" figure is the one to hold onto**, precisely because it is the only one framed over the whole seller population rather than a filtered subset. Read in the direction the company did not emphasize: **roughly 87.5% of sellers are not full-time.**

### The shape of the distribution — assumed, not measured

**State this clearly: the shape of Whatnot's seller earnings distribution has not been measured publicly.** Whatnot has never released a payout distribution, and no independent study was found.

Power-law concentration is the **expected** shape **by analogy** with measured distributions on comparable platforms — Twitch payouts, Etsy, eBay, TikTok Shop — all of which show extreme top-end concentration. **This is analogy, explicitly labelled as such, and is not evidence about Whatnot specifically.**

Three pieces of indirect support, none conclusive: the coexistence of "500+ sellers above $1M" with "1 in 8 full-time"; the "streams daily → ~$60K/month" figure, which describes a small, intensely committed tail; and the general structure of attention markets, where discovery concentrates on established sellers.

### Earnings bands

| Earnings band | Estimated share of sellers | Source | Tier | Confidence |
|---|---|---|---|---|
| $1M+ annualized sales | **500+ sellers** (absolute count; share **not publicly available**) | Whatnot | A | Medium — count credible, denominator absent |
| >$10K/month | **Two-thirds of *active* sellers** (6mo+, 2+ streams/wk). Share of **all** sellers **not publicly available** | Whatnot | A | **Low as a general rate** — heavily filtered |
| Full-time equivalent | **~1 in 8 sellers (~12.5%)** | Whatnot | A | **Medium — the most representative figure disclosed** |
| Part-time / supplemental | **Not publicly available** | — | — | — |
| Marginal or unprofitable | **Not publicly available** | — | — | — |
| **Median seller earnings** | **NOT PUBLICLY AVAILABLE** | — | — | — |
| **Top-decile share of GMV** | **NOT PUBLICLY AVAILABLE** | — | — | — |
| **Total number of sellers** | **NOT PUBLICLY AVAILABLE** | — | — | — |

**No number has been modelled into these blank cells.** Filling them would require a seller-payout distribution that Whatnot does not publish.

### Median vs. mean

**"Sellers who stream daily average approaching $60,000/month" is a mean over a selected group, and means are the wrong statistic for this distribution.** On a power-law, a handful of top sellers drag the average far above what any typical member earns. The median of that same group would be dramatically lower; the median across **all** sellers, lower still.

**Every publicly available Whatnot earnings figure is either a mean, a filtered subset, or an absolute count of top performers. Not one is a median over all sellers.** That is a choice about what to disclose, and readers should weight it accordingly.

### The survivorship-bias problem

This applies to essentially all evidence in this section. The visible sellers — in press coverage, testimonials, YouTube tutorials, and the company's own reports — **are selected on success**. The "6+ months and 2+ streams/week" filter is survivorship bias written directly into the metric's definition: sellers who tried and quit at month two are **excluded by construction**.

Sellers who quit leave no trace. They do not post retrospectives, they are not in the company's active-seller cohort, and they are not in the press. **The denominator of any honest success rate is unobservable from outside.** Anyone estimating "what fraction of Whatnot sellers make it" from public data is estimating from a sample that has had its failures removed.

---

## Part 5 — Geographic distribution

*Interpretation note: "geometry of user and creator distribution" is read as geographic distribution, covered here. The distributional **shape** is covered in Part 4.*

### Market table

| Market | Launched | Buyer share | Seller presence | Dominant categories | Source | Tier |
|---|---|---|---|---|---|---|
| **United States** | Founding market (2019/20) | **Not publicly available** — reported as the large majority | **Highest** | Sports cards, TCG, sneakers, comics | Company/press | A/B |
| **Canada** | **2023/24** | Not publicly available | Established | Cards, collectibles | Company | A |
| **United Kingdom** | **2023/24** | Not publicly available | Established, growing | Cards, TCG, vintage fashion | Company | A |
| **Germany** | 2024 | Not publicly available | Growing | TCG, collectibles | Company | A |
| **France** | 2024 | Not publicly available | Growing | TCG, collectibles | Company | A |
| **Netherlands** | 2024 | Not publicly available | Growing | TCG, collectibles | Company | A |
| **Belgium** | 2024 | Not publicly available | Smaller | TCG, collectibles | Company | A |
| **Austria** | 2024 | Not publicly available | Smaller | TCG, collectibles | Company | A |
| **Australia** | **Early 2025** | Not publicly available | Newest, smallest | Cards, sneakers | Company | A |

**Cells that could not be sourced are the majority of this table.** Whatnot publishes **no per-country buyer share, GMV share, or seller count.** Only one geographic growth figure was found: **European sellers grew 600% year over year, hosting 20,000+ hours of shows weekly (A)** — a growth rate off an undisclosed base, which cannot be converted into a share.

### Buyer vs. seller distribution

**The two distributions differ, and the direction is inferable even where the magnitudes are not.** Whatnot's US origin, its 8% commission structure keyed to US/CA/AU, and the depth of US sports-card and TCG sourcing infrastructure all concentrate **sellers** in the US more heavily than **buyers**. The 600% European seller growth suggests the platform has been deliberately correcting a seller shortage in Europe — which is what you would do if European buyer demand had outrun local supply.

**Quantifying this is not possible from public data.**

### Cross-border dynamics

- **Fee structure differs by region** — 8% (US/CA/AU) vs 6.67% + VAT (UK/EU) **(A\*)** — the clearest evidence that the platform operates regionalized markets rather than one global pool.
- **Shipping, customs, duties, and currency** are the practical constraints on cross-border purchase. For low-AOV categories, international shipping is usually prohibitive: a $20 card cannot absorb $25 of international postage and customs handling.
- **Whether and how buyers can purchase from sellers in other markets was not verifiable** in this environment. Given the regional fee structures and VAT handling, markets are likely at least partially segmented — **but this is inference, not established fact.**

### Sub-national patterns

**No sourceable data was found** on urban/suburban concentration, proximity to card shops and wholesale sourcing, or regional category skews such as sports-team-driven card demand. These are plausible and frequently asserted, but **nothing found here documents them**, so nothing is asserted.

### Category by geography

Partially sourceable: **baseball cards are structurally US-centric** (the sport's collector base is), while **TCG (Pokémon, Magic) travels globally** and is reported as a major European driver. **Vintage fashion** has strong UK/EU presence. **The implication for a seller choosing where to compete: TCG is the most geographically portable category; US sports cards are the least.**

---

## Part 6 — Downside: restrictions, suspensions, and bans

**All policy details in this section are (A\*)** — sourced from independent descriptions of Whatnot's Help Center articles, **not read directly** (see the access constraint). The specific Help Center articles are linked. **Verify current text before relying on any of it.**

### Prohibited and restricted items

Whatnot states that its restrictions exist because some items pose **legal or safety risk**, some **negatively impact other users' experience**, and some are **not well-suited to the platform at this time** — the third being a discretionary category worth noting.

Documented prohibitions include **counterfeit items** (explicitly illegal and barred from both sale and giveaway), **sex toys and sexually explicit items**, and **items violating Whatnot's IP Policy**. Whatnot maintains a **Counterfeit Policy and Restricted Branded Items Policy** distinct from its general Prohibited Items policy — relevant to sneakers, streetwear, and luxury, where brand restrictions can bar items that are genuine.

**The full enumerated list — weapons, regulated goods, hazardous materials, recalled products, live animals, protected wildlife, stolen goods — could not be retrieved.** These categories are standard across marketplaces, but this report will not assert Whatnot's specific text where it could not read it. **Any seller in a borderline category must read the Prohibited or Restricted Items page directly.**

### Conduct violations

Documented or clearly implied by the guidelines: **shill bidding and bid manipulation**, **fake or misrepresented items**, **misgraded or misrepresented card condition**, **undisclosed damage**, **non-shipment and chronic late shipping**, **cancellation abuse**, **harassment and hate speech**, **NSFW conduct on stream**, and **underage users**.

**Condition misrepresentation deserves special emphasis in a live format.** A card described on camera as "near mint" that arrives with a soft corner is a defect claim, and at volume these compound into performance penalties. **The live format makes description an unrecorded verbal act at speed** — which is precisely the risk. Sellers who describe conservatively and photograph flaws are protecting the account, not just the buyer.

### Circumvention

Taking transactions off-platform to avoid fees, soliciting direct payment, and promoting competing platforms in-stream are treated as violations. **The precise current wording could not be verified**, and the boundary between *building an off-platform audience* (generally acceptable) and *soliciting off-platform transactions* (not) is exactly the kind of detail where the specific text matters. **Read the Community Guidelines directly before running any cross-platform strategy.**

### Giveaways, breaks, and chance-based formats — the live legal exposure

**This is the most significant risk item in the report, and it is active.**

Attorney **Paul Lesko filed 15 arbitration claims against Whatnot**, with **approximately 30 more expected**, and arbitration proceedings reported as beginning by **mid-July 2026 (B)**. The allegations:

- Whatnot's **randomized break format** — paying for a "spot" where a randomized tool determines which team or player you receive from an unopened box — **constitutes an illegal lottery under California Penal Code §319**.
- The platform operates as an **"unregulated online casino,"** encouraging compulsive spending while generating substantial revenue **without the safeguards required of licensed gambling operators**.
- Specifically, California-regulated operators must offer **self-exclusion lists and spending limits** to customers showing problem-gambling behaviour; the complaints allege Whatnot has operated **without equivalent protections**.
- **RICO and illegal-lottery allegations** have been reported in connection with these claims **(B)**.

**Relief sought:** legal recognition that breaks constitute illegal gambling; restitution, compensatory and punitive damages; and **court orders requiring warnings, spending limits, self-exclusion tools, and a halt to randomized box and repack breaks.**

**How to weight this, fairly:** these are **allegations in arbitration, not findings**. No court has ruled that Whatnot's breaks are illegal gambling; no regulator has been documented here as taking action. Arbitration also means proceedings are largely non-public and will not produce binding public precedent the way litigation would.

**But the risk to a seller is real and asymmetric even if Whatnot prevails.** A seller whose entire business is randomized breaks is exposed to an outcome they do not control: an adverse result, a settlement, or a precautionary policy change could **restrict or end the format**, stranding sealed inventory bought at break-economics prices. **Sellers concentrated in randomized formats should treat format diversification as risk management, not as a growth strategy.**

**Giveaway rules** are governed by platform policy; **the specific current rules could not be retrieved.** Giveaways in many jurisdictions require no-purchase-necessary structures to avoid lottery characterization — a relevant consideration given the above. *(Not legal advice.)*

### Performance-based penalties

Whatnot operates rating thresholds, cancellation and defect rate limits, and shipping-time requirements. **Specific numeric thresholds could not be verified.** Falling below them triggers the ladder below — notably including **reduced discovery**, which is the penalty sellers often experience without recognizing it as one.

### The enforcement ladder

Documented actions **(A\*)**, in escalating order:

| Step | Action | Duration |
|---|---|---|
| 1 | **Warning** | Recorded; most violations **expire after 180 days** |
| 2 | **Loss of early payout privileges** | **Up to 30 days** — a direct cash-flow hit for a seller funding sourcing from payouts |
| 3 | **Increased commission** | **Up to 30 days** — an unusual, directly financial penalty |
| 4 | **Listing removal / stream takedown** | Immediate |
| 5 | **Reduced discovery / visibility** | Indefinite; often unannounced |
| 6 | **Suspension** | **Up to 30 days**; stays in place until review completes |
| 7 | **Loss of selling access** | **Permanent** — can still buy |
| 8 | **Permanent ban** | **Permanent** — cannot buy or sell |

**Payout treatment on enforcement (A\*)** — the detail sellers most need:
- **Temporary suspension:** payouts can be started **once account access is restored**.
- **Permanent ban or loss of selling access:** eligible balances are typically paid out **60 days after the action**.

**Most violations expire after 180 days; permanent penalties do not expire.**

The **increased-commission** penalty (step 3) is worth flagging as unusual — most marketplaces limit themselves to visibility and access penalties. A temporary commission increase directly reprices a seller's unit economics for a month.

### Appeals and consistency

Whatnot documents an appeals process and has published material on how it evaluates user reports and enforces policies. **Community reporting on appeal consistency could not be retrieved** in this environment (see the access constraint). This report therefore **makes no claim about whether enforcement is consistent or appeals effective** — a genuine unknown, not an implied criticism.

**On disputed enforcement accounts generally:** where suspended sellers publish accounts of unfair treatment, these are **one-sided by structure**. The platform will not discuss individual accounts publicly, so only the seller's version ever appears. **A single account of an unfair ban is not evidence of a pattern**, and this report does not present one. Equally, the absence of retrievable accounts here is not evidence that enforcement is fair.

### Platform-dependence risk more broadly

- **Payout delays and holds** — funds are held by the platform; a hold is a working-capital event for a business funding sourcing from cash flow.
- **Sudden fee or policy changes** — the January 2026 high-value commission promotion shows fees move. They can move the other way.
- **Algorithm-driven visibility loss** — an unannounced penalty that looks like bad luck.
- **Category rule changes stranding inventory** — the acute risk for break sellers given Part 6's litigation.
- **Account loss destroying a years-built audience** — the audience lives on the platform. A ban does not transfer followers anywhere.

### Risk mitigation for a seller

1. **Document everything** — photograph every item before shipping, including flaws; retain sourcing receipts.
2. **Disclose condition conservatively** — under-promise on camera. Verbal description at speed is the live format's core liability.
3. **Hold shipping SLAs strictly** — late shipping is among the most common route into performance penalties.
4. **Diversify formats** — do not build the whole business on randomized breaks while that format is under active legal challenge.
5. **Diversify platforms** — maintain presence on at least one other channel so an account action is a setback, not an ending.
6. **Hold capital reserves** — enough to survive a 30-day payout hold without stopping sourcing.
7. **Build brand off-platform, keep transactions on-platform** — the audience relationship should be portable; the transactions must stay compliant.
8. **Reserve for taxes from every payout** — treat payouts as gross, never net. *(Not tax advice.)*

---

## Synthesis — who this platform actually works for

**The seller profile that succeeds** has five characteristics, and they are more specific than "works hard":

1. **Genuine domain expertise** in a category — buyers detect ignorance live, instantly, and it is unrecoverable.
2. **Working capital** sufficient to source ahead of revenue and absorb a 30-day payout hold.
3. **An operational temperament** — because the business is 60% fulfilment logistics and 40% performance, and the fulfilment half is what breaks people. Every unit-economics model above shows packing hours meeting or exceeding stream hours.
4. **A high enough AOV to escape the flat-fee trap** — sub-$10 average orders are structurally hard to make work.
5. **The stamina for a fixed schedule over months**, since the repeat-buyer relationship is the only durable asset and it is built by showing up.

**The profile that does not succeed:** the undercapitalized seller sourcing at retail prices, competing on $1 starts to an audience of bargain hunters and spectators, streaming irregularly, and discovering in month three that packing takes longer than streaming. This is not a rare outcome — the "1 in 8 sellers is full-time" figure implies it is the common one.

**The honest framing of the opportunity.** The platform is genuinely growing — **$8B GMV in 2025, matched in the first half of 2026, and a $20B valuation (A/B)** — and growth means real opportunity for sellers who arrive prepared. But **growth in platform GMV is not the same as growth in the median seller's income**, and Whatnot publishes nothing that would let anyone check the difference. **The most representative figure the company has disclosed is that roughly seven in eight sellers are not full-time.**

**Two structural risks sit above everything:** the platform's most engaging format is under active legal challenge on gambling grounds, and every seller's audience, discovery, and payment rails are owned by a private company that publishes no audited numbers and can change fees and rules at will. Neither is a reason not to sell here. Both are reasons not to make it the only thing you do.

---

## Open questions / what could not be verified

**This section is substantial, and per the task framing that is the correct outcome, not a failure.** Whatnot publishes very little, and this environment's egress policy blocked what it does publish.

**Blocked by the access constraint:**
1. **Whatnot Help Center pages** — fees, prohibited items, community guidelines, enforcement, suspension/ban policy. **All fee and policy figures are secondary-verified only.** This is the most consequential gap, since it invalidates the "quote with access date" standard for every number in Part 2.
2. **whatnot.com** — seller resources, Seller Hub, any official education material.
3. **Community sources (tier C)** — r/whatnotapp, seller Discords, seller vlogs. Searches returned nothing usable. This removes the only real window into unvarnished seller economics and into ban/payout-hold experiences.

**Not published by Whatnot, and unavailable anywhere:**
4. **Total number of sellers** — the denominator for every success-rate question.
5. **Median seller earnings** — never disclosed. Only means over filtered subsets exist.
6. **Top-decile / top-percentile share of GMV** — never disclosed. The power-law shape is **assumed by analogy, not measured**.
7. **Per-country buyer share and GMV share** — never disclosed for any of the nine markets.
8. **Seller counts by market** — only the 600% European growth rate, off an undisclosed base.
9. **Behavioural metrics** — session length, purchase frequency, platform-wide AOV, repeat-purchase rate, time-of-day patterns.
10. **Buyer income data** — no credible source found.
11. **Seller application approval and rejection criteria.**
12. **Numeric performance thresholds** — rating, cancellation rate, defect rate, shipping-time limits.
13. **The full enumerated prohibited-items list.**
14. **Current circumvention policy wording** — specifically where audience-building ends and transaction-solicitation begins.
15. **Current giveaway rules.**
16. **Whether buyers can purchase cross-border**, and under what shipping/customs terms.
17. **Sub-national geographic patterns** — asserted often, documented nowhere found here.
18. **Referral/affiliate program current terms.**
19. **Appeals-process consistency** — no retrievable evidence in either direction.
20. **Arbitration outcomes** — proceedings reported to begin mid-July 2026; **no outcome documented as of 2026-08-21**, and arbitration is largely non-public.

**What would be needed to close the big ones:** a Whatnot-published seller payout distribution (as Twitch and Etsy have at times released), independent survey research with a properly constructed seller sample **including sellers who quit**, or disclosure through litigation. Absent one of those, **no honest answer to "what does a typical Whatnot seller earn?" exists.**

---

## Sources

**Tier A — Company-stated (self-reported, unaudited, promotional in purpose)**
- [Whatnot's 2026 State of Live Selling Report: Time to Go Live](https://blog.teamwhatnot.com/unitedstates/2026livesellingreport) — Whatnot Blog, 2026.
- [Europe's Live Selling Revolution: Whatnot's 2025 Market Report](https://blog.teamwhatnot.com/unitedstates/livesellingreport) — Whatnot Blog, 2025.
- [Our Easier-to-Read-and-Understand Policies](https://blog.teamwhatnot.com/unitedstates/easier-to-read-guidelines) — Whatnot Blog.
- [How We Evaluate User Reports and Enforce Policies](https://blog.teamwhatnot.com/united-kingdom-blog/blog-how-we-evaluate-user-reports-and-enforce-policies-m62ma-p94aw) — Whatnot Blog.

**Tier A\* — Official Help Center pages (linked; could not be fetched — egress blocked; access date not achieved)**
- [Prohibited or Restricted Items on Whatnot](https://help.whatnot.com/hc/en-us/articles/360061224972-Prohibited-or-Restricted-Items-on-Whatnot)
- [Whatnot Community Guidelines](https://help.whatnot.com/hc/en-us/articles/360061197472-Whatnot-Community-Guidelines)
- [What Actions We Take](https://help.whatnot.com/hc/en-us/articles/5380505120269-What-Actions-We-Take) — source of the enforcement ladder.
- [If your account is suspended or banned](https://help.whatnot.com/hc/en-us/articles/44133015373837-If-your-account-is-suspended-or-banned) — source of payout-on-ban timing.
- [Counterfeit Policy and Restricted Branded Items Policy](https://help.whatnot.com/hc/en-us/articles/360061604031-Counterfeit-Policy)
- [Whatnot Listing Guidelines](https://help.whatnot.com/hc/en-us/articles/360061195612-Whatnot-Listing-Guidelines)
- [Reduced Commission on High-Value Orders](https://help.whatnot.com/hc/en-us/articles/27912945518733-Reduced-Commission-on-High-Value-Orders) — source of the 2026-01-14 promotion.

**Tier B — Independent**
- [Whatnot valued at $20 billion as live shopping continues to boom](https://www.cnbc.com/2026/08/07/whatnot-live-shopping-valuation-20-billion.html) — CNBC, 2026-08-07. *(Series G, $545M, $20B.)*
- [Whatnot Just Clinched a $20 Billion Valuation](https://www.inc.com/jennifer-conrad/whatnot-just-clinched-a-20-billion-valuation/91386777) — Inc., 2026-08.
- [Whatnot valuation tops $11 billion following $225 million funding round](https://sports.yahoo.com/article/whatnot-valuation-tops-11-billion-145200365.html) — Yahoo, Oct 2025. *(Series F.)*
- [Live shopping firm Whatnot bags $265 million in Series E as valuation hits $4.97 billion](https://retailtechinnovationhub.com/home/2025/1/8/live-shopping-specialist-whatnot-bags-265-million-in-series-e-funding-with-valuation-hitting-497-billion) — Retail Technology Innovation Hub, 2025-01-08.
- [Livestream shopping app Whatnot raises $265M, pinning valuation at nearly $5B](https://techcrunch.com/2025/01/08/livestream-shopping-app-whatnot-raises-265m-pinning-valuation-at-nearly-5b/) — TechCrunch, 2025-01-08.
- [Whatnot doubled sales to more than $8 billion in 2025](https://www.cllct.com/sports-collectibles/memorabilia/whatnot-doubled-sales-to-more-than-8-billion-in-2025) — cllct, 2026.
- [Whatnot's Global GMV Doubles Year-over-Year to Reach $8 Billion in 2025](https://english.ebrun.com/20260211/640428.shtml) — Ebrun, 2026-02-11.
- [Whatnot — CNBC Disruptor 50](https://www.cnbc.com/2026/05/19/whatnot-cnbc-disruptor-50-ranking.html) — CNBC, 2026-05-19.
- [Whatnot 2026 Live Selling Report: Growth, Friction, and the Future of Live Commerce](https://www.valueaddedresource.net/whatnot-2026-live-selling-report/) — Value Added Resource, 2026. *(Independent analysis flagging thin margins, uneven buyer protection, and the shopping/gambling blur.)*
- [Whatnot breaks down $22 billion live shopping industry](https://www.tubefilter.com/2026/01/28/whatnot-state-of-live-selling-report-2026-shopping-ecommerce/) — Tubefilter, 2026-01-28.
- [Lawsuit Accuses Breaking Platform Whatnot Of Being 'Unregulated Online Casino'](https://www.baseballamerica.com/stories/lawsuit-accuses-breaking-platform-whatnot-of-being-unregulated-online-casino-for-sports-cards-report/) — Baseball America, 2026.
- [Whatnot Faces RICO, Illegal Lottery Allegations Tied To Sports Card Breaks](https://www.sahmcapital.com/news/content/whatnot-faces-rico-illegal-lottery-allegations-tied-to-sports-card-breaks-2026-03-18) — Sahm Capital, 2026-03-18.
- [Whatnot's $8 Billion Sports Card Empire Faces Gambling Lawsuit Over Random Breaks](https://easternherald.com/2026/06/26/whatnot-sports-card-breaking-gambling-lawsuit-california/) — Eastern Herald, 2026-06-26.
- [Whatnot Faces Legal Challenges Over Card Breaking Practices](https://www.si.com/collectibles/whatnot-faces-legal-challenges-over-breaking-practices) — Sports Illustrated.
- [whatnot.com Traffic Analytics & Audience](https://www.similarweb.com/website/whatnot.com/) — Similarweb, June 2026. *(Gender/age splits — web panel only.)*
- [Whatnot revenue, valuation & funding](https://sacra.com/c/whatnot/) — Sacra. *Analyst estimates.*
- [WhatNot nears $1bn revenues as live-commerce demand surges](https://www.sgieurope.com/retail/auction-shopping-app-nears-1bn-in-annual-revenue/118609.article) — Sporting Goods Intelligence.
- [Poshmark Introduces Posh Shows](https://www.prnewswire.com/news-releases/poshmark-introduces-posh-shows-a-new-approach-to-live-shopping-for-the-fashion-resale-community-301790370.html) — PR Newswire.
- [Fanatics Officially Launches Fanatics Live](https://www.fanaticsinc.com/press-releases/fanatics-officially-launches-fanatics-live-a-next-gen-live-commerce-platform) — Fanatics Inc.
- [Douyin's Live Commerce: 40% of China's E-Commerce Pie in 2025](https://ecommercechinaagency.com/douyins-live-commerce-40-of-chinas-e-commerce-pie-in-2025/) — E-Commerce China Agency. *Agency analysis.*

**Tier C — Community/industry-reported (anecdotal, non-representative; never aggregated into a rate)**
- [$8 Billion in Sales. What Do Sellers Actually Keep?](https://www.thegraildrop.com/p/8-billion-in-sales-what-do-sellers-actually-keep) — The Grail Drop, 2026.
- [Whatnot Fees 2026: Complete Seller Fee Breakdown (8% + More)](https://www.voolist.com/blog/whatnot-fees-2026) — Voolist, 2026.
- [Whatnot Seller Fees 2026: 8% Commission + Processing Fee Explained](https://feescal.com/blog/whatnot-seller-fees-2026) — FeesCal, 2026.
- [Whatnot Seller Fees 2026: What Sellers Actually Pay](https://www.underpriced.app/blog/whatnot-seller-fees-2026) — Underpriced, 2026. *(Source of the $3-sale/$2.37-net and $5-item flat-fee illustrations.)*
- [Whatnot Selling Fees: What Sellers Actually Pay in 2026](https://closo.co/blogs/fees/whatnot-selling-fees) — CLOSO, 2026.
- [Inside the Whatnot Seller Hub: A Survival Guide for Live Auctions in 2026](https://closo.co/blogs/platform-specific-guides/inside-the-whatnot-seller-hub-a-survival-guide-for-live-auctions-in-2026) — CLOSO, 2026.
- [Whatnot Fees for Sellers: How Much Does Whatnot Take?](https://crosslist.com/blog/whatnot-fees-for-sellers) — Crosslist.
- [Selling on Whatnot in 2026: How to Capture the Live-Commerce Boom Profitably](https://ecomcpa.com/selling-on-whatnot-in-2026-how-to-capture-the-live-commerce-boom-profitably/) — EcomCPA, 2026.
- [22 Whatnot Statistics For 2026: Revenue, User Count, And Growth](https://ecommercebonsai.com/whatnot-statistics/) — Ecommerce Bonsai, 2026. *Aggregator.*
- [How Does Whatnot Work? How to Sell on Whatnot App in 2026](https://blog.vendoo.co/whatnot-app-a-guide-for-sellers-and-buyers) — Vendoo, 2026.
- [The 10 Best Categories to Sell on Whatnot in 2026](https://leliveboost.com/blog/best-whatnot-categories-2026) — LeLiveBoost, 2026.
- [Whatnot — Funding Rounds & Investors](https://tracxn.com/d/companies/whatnot/__uDL2ItSrNAAhaz26cJMWEL-19y_nvdU0Do_yLVW9BmI/funding-and-investors) — Tracxn. *(Total raised ~$1.52B / 9 rounds / 31 investors.)*
- [Whatnot Alternatives: 8 Best Live Selling Platforms in 2026](https://bundlelive.com/blog/whatnot-alternatives-live-selling-platforms) — BundleLive, 2026.
- [Whatnot GMV 2024/2025, Revenue, Monthly Visitors](https://getauctioncompass.com/blog/whatnot-growth-history) — Auction Compass.

---

*Prepared 2026-08-21. Whatnot is a private company; all GMV, seller-earnings, and user figures originate from the company and are unaudited. Fee and policy figures were verified through consistent secondary reporting rather than direct access to official pages — verify at source before relying on them for any financial calculation. Not financial, legal, or tax advice.*

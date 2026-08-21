# Task: Building a Startup in the Current Age — App-Led Company Building, with a Speechify-Class TTS App as the Worked Case

Write the result to `output.md` in this folder.

## Objective
Search the web and produce a single evidence-grounded report answering four questions:
1. **How are startups actually built and funded in the current age** — what has changed now that AI has collapsed the cost of building software, and what that means for a founder starting today.
2. **How do you take an app from idea to a real business** — validation, distribution, monetization, and the failure modes that kill most attempts.
3. **Using a Speechify-class app as the worked case** (text-to-speech / read-aloud / listen-to-anything), what does it actually take to build and ship one, and what does the competitive and cost structure look like?
4. **Is there a real world market for it** — sized with sourced figures, segmented by geography, and assessed honestly, including the case that the market is closing rather than opening.

This is a market-research and operator-strategy report grounded in verifiable data. It is **not** a motivational "how to build a startup" piece, and it must not promise outcomes.

## Framing — read this before writing
The central discipline here is **separating what is knowable from what is folklore**. Startup advice is the most survivorship-biased genre of business writing in existence: the visible companies are selected on success, the failures leave no blog posts, and most "lessons" are post-hoc narratives. Meanwhile, market-size figures for AI categories are dominated by consultancy TAM projections that are marketing collateral for the consultancy.

Label every figure with a tier:
- **(A) Primary/official** — company filings and press releases, official pricing and API docs, app-store listings, government statistics, funding announcements, court filings.
- **(B) Independent** — reputable business and tech press with its own sourcing, app intelligence (Sensor Tower, Appfigures, data.ai), academic work, established market-research firms where the methodology is stated.
- **(C) Industry/community-reported** — VC blog posts, founder interviews and podcasts, indie-hacker revenue screenshots, SEO "market size" aggregators, agency content marketing.

Treat **TAM projections as tier (C) unless the methodology is stated**, and say so plainly. Where a widely-repeated market-size number traces to a single consultancy press release, **name that** rather than repeating the number as fact. Where (A) and (B) conflict, give both.

**Be explicit about the survivorship problem** in the startup-advice sections. A tactic that worked for one company is not evidence that it generalizes.

If a question cannot be answered with sourced data, **say so and explain what would be needed to answer it.** A report that marks its unknowns clearly is worth more than one that fills gaps with plausible invention.

## Part 1 — What has actually changed about building a startup
- **The cost curve.** What it cost to build and ship a software product 10 years ago versus now; the effect of AI coding tools, managed infrastructure, and no-/low-code on time-to-first-version and on team size. Use sourced figures, not vibes.
- **The consequence nobody likes:** if building is cheap for you, it is cheap for everyone. Address directly what happens to defensibility when the build is no longer the moat, and what the remaining moats actually are (distribution, data, brand, switching costs, regulatory position, supply-side relationships).
- **Funding reality.** Current state of pre-seed/seed — round sizes, valuations, how much AI concentration distorts the averages, and what proportion of companies raise at all. Cover the bootstrap and indie path as a genuine alternative, not a consolation prize, with sourced examples of app businesses that never raised.
- **Team shape** — solo founder vs. co-founders, what the data says about outcomes, and the rise of very small teams with meaningful revenue.
- **Where AI startup costs actually land now** — inference costs, GPU/API spend as COGS, and why AI products can have materially worse gross margins than classic SaaS. Quantify with published API pricing.
- **Base rates.** Startup and app failure rates, with sources and with a clear statement of what the denominators are and why most quoted failure statistics are unreliable.

## Part 2 — Idea to business: the operating playbook
- **Validation before building** — how to test demand cheaply, what signals are meaningful at small scale and which are noise, and how long validation should take.
- **Distribution is the hard part.** App Store and Play Store discovery reality, ASO, paid acquisition economics (CAC by channel with sourced ranges), organic/content, and why "build it and they will come" fails. Cover the platform tax (Apple/Google commission rates and the current state of external-payment rules) with sourced, dated figures.
- **Monetization models** for consumer and prosumer apps — freemium, subscription, one-time, usage-based, ads — with the economics of each, typical conversion rates from free to paid, and churn benchmarks. Source every benchmark and mark unsourceable ones as such.
- **Unit economics** — LTV, CAC, payback period, and the specific way AI inference costs break the classic SaaS margin model. Include a worked example with explicit, labelled assumptions.
- **The failure modes** — no distribution, no differentiation, negative unit economics on inference, platform dependence, founder burnout, premature scaling, and building for a market that doesn't pay.

## Part 3 — The worked case: a Speechify-class TTS app
- **What Speechify actually is** — product, history, funding and valuation if disclosed, reported user and revenue figures with tiers, and pricing. Do the same, more briefly, for the main competitors: **ElevenLabs Reader, Audible/Amazon, Apple's built-in Spoken Content and Google's TalkBack/Read Aloud, NaturalReader, Voice Dream, Pocket-style read-later apps, Play.ht, and the browser/OS-native readers.**
- **The build.** What a credible v1 requires: TTS engine choice (commercial API vs. open-source models), document ingestion (PDF, EPUB, web, OCR for scans), highlighting/sync, offline playback, mobile + browser extension, and accessibility conformance. Be concrete about which parts are commodity and which are genuinely hard.
- **The cost structure.** Published per-character or per-minute pricing for the major TTS APIs, with dates. Build a worked COGS model for a subscriber listening a given number of hours per month, and show at what usage level a flat-rate subscription goes underwater. **This is the crux of the business and must be modelled explicitly**, with assumptions labelled.
- **The defensibility question.** If the TTS engine is an API call, what is the actual product? Address: content ingestion quality, sync/highlighting UX, library management, cross-device continuity, voice quality and selection, offline, and accessibility compliance as a moat. Be honest about how thin some of these are.
- **The platform risk.** Apple and Google ship free read-aloud functionality in the OS. Assess what that means for a paid third-party app, and what the surviving wedge is.

## Part 4 — Is there a world market?
- **Market sizing** — TTS, audiobooks, accessibility tech, and language-learning adjacency. Give figures with source, date, and methodology where stated, and **flag every projection that is a consultancy TAM without published methodology.**
- **Who actually pays, and why** — segment the demand: students, professionals with reading loads, people with dyslexia or ADHD, blind and low-vision users, ESL/language learners, commuters, and content creators wanting voice generation. For each: size where sourceable, willingness to pay, and how they are currently served.
- **Geography.** Where the paying market is versus where the users are — the gap that determines revenue. Cover the US/EU willingness-to-pay concentration, the large non-English populations, and what multilingual TTS quality does to addressable market. Include a table.
- **Accessibility regulation as a demand driver** — the **European Accessibility Act**, ADA/Section 508 in the US, and equivalent regimes; what they require, when they took effect, and whether they create real institutional buying. Cite the regulations with dates.
- **The B2B/institutional path** — schools, universities, libraries, publishers, enterprises — and whether it is a better business than consumer subscriptions. Compare on CAC, churn, contract size, and sales cycle.
- **The bear case, argued properly.** Commoditized TTS, OS-native free alternatives, price compression from open-source models, and the possibility that this is a feature rather than a company. **Give this section genuine weight — do not stage it as a strawman to knock down.**

## Required structure of `output.md`
1. **Title + scope line** — coverage, and the date the research was performed; note all figures are point-in-time.
2. **Evidence-tier note** — the (A)/(B)/(C) convention in one short paragraph, including the warning about consultancy TAM figures.
3. **TL;DR** — 7–10 bullets, each carrying its key finding and source tier.
4. **Part 1 — What has changed about building a startup** (with the base-rates discussion).
5. **Part 2 — Idea to business** (with the unit-economics worked example).
6. **Part 3 — The Speechify-class worked case** (with the competitor table and the **COGS model**).
7. **Part 4 — World market assessment** (with the segment table, the geography table, and the bear case).
8. **Verdict** — a direct, honest answer to "should someone build this, and if so in what form?" Take a position and justify it. Hedging everything is not an answer.
9. **Open questions / what could not be verified** — an explicit list.
10. **Sources** — every source with title, publisher, URL, publication or access date, and evidence tier.

## Rules & cautions
- **Accuracy over completeness.** Do not fabricate funding figures, revenue, user counts, API prices, conversion rates, or market sizes. Every figure needs a named source, a date, and a tier.
- **Never invent a statistic to complete a table.** Write "not publicly available" and note it in open questions.
- **Quote API pricing and platform commission rates with access dates** — these change, and stale pricing invalidates the COGS model downstream.
- **Distinguish measured from modelled.** Any worked example or projection must be labelled illustrative, with assumptions listed.
- **No income or outcome promises.** Present startup outcomes as base rates, emphasize that the distribution is extremely skewed, and state plainly that most apps and most startups fail. Do not frame any path as easy or guaranteed.
- **Handle founder anecdotes carefully** — useful as colour, tier (C) always, never generalized into a rate.
- **Be fair to the bear case.** A report that concludes "yes, build it" without seriously engaging the commoditization argument has not done the work.
- Prefer primary sources (official pricing pages, filings, regulation text, app-store listings) over SEO listicles and "top 10 startup ideas" content, which are the main vector for invented market sizes.
- This is not financial, legal, or investment advice; include a brief note to that effect.

## Style
- ~3000–4500 words plus tables and the sources list.
- Neutral, analytical tone — written for someone deciding whether to actually commit years to this.
- Use tables wherever data is comparative (competitors, COGS, segments, geography, monetization models).
- Mark every uncertain figure inline with its tier — e.g. "$X TTS market by 2030 (C, consultancy projection, no published methodology)" — rather than relegating all sourcing to footnotes.
- Use clear section headings matching the structure above.

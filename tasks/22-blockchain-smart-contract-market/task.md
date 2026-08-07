# Task: Blockchain Smart Contract Platforms — Market Landscape, Features, and Business Models

Write the result to `output.md` in this folder.

## Objective
Search the web to research the current smart contract blockchain market and produce a report answering four questions:
1. **Which chains are actually popular for smart contracts**, measured by real usage data rather than marketing claims.
2. **What technical features each offers** and what kind of application each is genuinely good for.
3. **What the revenue and monetization paths are** for someone building in this space.
4. **Which business models have demonstrably worked**, with real revenue figures and an honest account of which have failed.

This is a market-research task grounded in verifiable data, not a promotional piece and not investment advice.

## Framing — read this before writing
Question 3 ("how can I get profit from it") should be answered as **"what are the revenue models available to a builder or operator in this market"** — i.e. how businesses in this sector actually make money. The report should cover:
- **Building and operating protocols/products** (the primary focus — fee capture, take rates, unit economics).
- **Infrastructure and service provision** (validators/staking, RPC, indexing, oracles, audits, tooling).
- **Passive on-chain yield mechanisms** (staking, liquidity provision, lending) — described **mechanically and with their risks** (impermanent loss, slashing, smart-contract risk, depeg risk), as market structure, not as a recommendation.

The report must **not** give personalized investment advice, recommend buying any specific token, or present speculative trading strategies as a reliable income path. Where returns are cited, cite them as historical/reported figures with dates and sources, and state plainly that past performance does not indicate future results. Include an explicit disclaimer that the report is informational and that the reader should consult a qualified professional and their own jurisdiction's regulations.

## Scope
### Chain landscape
Cover the major smart contract platforms and compare them on evidence, at minimum:
- **Ethereum** and the EVM as the reference platform; the L2 ecosystem (Arbitrum, Optimism, Base, zkSync, Polygon, Scroll, Linea, etc.) and how optimistic vs. ZK rollups differ.
- **Solana** — parallel execution, fee structure, and the application types it has actually attracted.
- **Move-based chains** (Sui, Aptos) and what the Move resource model changes about contract safety.
- **BNB Chain, Avalanche, Tron, TON, Near, Cardano, Cosmos/CosmWasm, Polkadot** — include those with meaningful usage; state plainly if a chain's activity is concentrated in one narrow use case (e.g. stablecoin transfers).
- Note where Bitcoin-adjacent smart contract activity sits, if material.

### How "popular" is measured
Do not rely on a single metric. Compare across several, name the source and date for each, and explain what each metric can be gamed by:
- Total value locked (TVL) — e.g. DefiLlama.
- Daily active addresses and transaction counts — and why these are inflatable by bots/airdrop farming.
- Developer activity — e.g. the Electric Capital Developer Report.
- Protocol/chain fees and revenue — e.g. Token Terminal, DefiLlama fees.
- Stablecoin supply and settlement volume.

### Technical features to compare
Virtual machine and execution model (sequential vs. parallel), contract languages (Solidity/Vyper, Rust/Anchor, Move, Cairo) and their tooling maturity, gas costs and fee predictability, throughput and finality, data availability, account abstraction (e.g. ERC-4337) and wallet UX, MEV and its handling, interoperability/bridging, upgradeability patterns, and the security track record of each ecosystem.

### Revenue models and business models
- **Protocol fee capture** — DEX swap fees, lending spreads, perpetuals fees/funding, liquid staking commissions, bridge fees, marketplace and launchpad fees.
- **Infrastructure** — validators and staking-as-a-service, RPC providers, indexers, oracles, block building/sequencing, rollup-as-a-service.
- **Services and tooling** — security audits, analytics/dev-tooling SaaS, wallet-integrated swap fees.
- **Stablecoin issuance** — reserve interest income, and why it has been among the most profitable models in the sector.
- **Tokenization / RWAs and payments** — where real traction exists versus where it is still pilot-stage.

For each model, address: who pays, what the take rate is, what the moat is (liquidity network effects, developer ecosystem, distribution, regulatory license), and whether value accrues to **equity, a token, or neither** — the token-value-accrual problem is central and must be addressed directly.

### Case studies
Include roughly 6-10 concrete case studies with **actual, sourced revenue or fee figures and dates** — a mix of clear successes, and at least two or three that declined or failed, with the reason (e.g. incentive-dependent TVL that left when emissions stopped, a marketplace that lost share, a chain whose activity was largely airdrop farming, a protocol lost to an exploit).

### Risks and failure modes — required, do not soften
Smart contract exploits and total historical losses (with sourced figures), rug pulls and scams, regulatory uncertainty across jurisdictions (US, EU/MiCA, Asia), extreme market cyclicality, mercenary capital, token emissions masking negative unit economics, key-management/custody risk, and the base rate of failure for new protocols.

## Required structure of `output.md`
1. **Title + scope line** — coverage, and the date the research was performed (state that all figures are point-in-time and that this market moves fast).
2. **Disclaimer** — informational only, not investment advice.
3. **TL;DR** — 6-8 bullets.
4. **Chain comparison table** — Chain | VM/Language | Key technical feature | Dominant use case | Popularity metrics (with source + date) | Best suited for.
5. **The chain landscape** — narrative analysis of who leads on what, and why.
6. **Technical feature comparison** — the deeper dive.
7. **Revenue models** — organized by category as listed above, each with who pays, take rate, moat, and value-accrual analysis.
8. **Case studies** — the successes and the failures, with figures and sources.
9. **Business model analysis** — what the winners have in common, what durable moats look like here, and why most projects fail.
10. **Risks and failure modes** — the required section above.
11. **Practical starting paths** — a grounded section on realistic entry points by profile (developer, infrastructure operator, service provider), including required skills, capital requirements, and time horizons. Keep this concrete and honest about difficulty; do not frame any of it as easy or guaranteed.
12. **Sources** — every source with title, URL, and access date; note the source type (on-chain data platform, official docs, research report, news).

## Rules & cautions
- **Accuracy over completeness.** Do not fabricate TVL, revenue, user numbers, or exploit losses. Every figure needs a named source and a date. If a number is disputed or self-reported by the project, say so.
- **Date everything.** Crypto metrics move fast; an undated figure is useless. State the snapshot date for all data.
- Distinguish clearly between **on-chain measurable facts**, **company-reported figures**, and **analyst estimates or projections**.
- Be explicit about **wash trading, airdrop farming, and bot activity** inflating headline metrics — this is the single biggest trap in reading this market's data.
- Prefer primary/neutral sources (DefiLlama, Token Terminal, Dune, Electric Capital, official docs, regulatory filings) over project marketing or promotional media.
- Do not recommend specific tokens to buy, promise returns, or present speculation as a business plan.

## Style
- ~2500-3500 words plus tables and sources.
- Neutral, analytical tone — this is market research, written for someone deciding where to build.
- Use clear section headings matching the structure above.

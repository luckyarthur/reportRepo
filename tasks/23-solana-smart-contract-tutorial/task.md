# Task: Solana Smart Contracts — Features and a Hands-On Build Tutorial

Write the result to `output.md` in this folder.

## Objective
Search the web for current, authoritative material on Solana smart contract development, then produce a report that does two things:
1. **Explains what makes Solana's smart contract model distinct** — its account model, execution model, and the features that follow from them.
2. **Teaches the reader to actually build one**, with complete, explained, working example programs and the exact commands to build, test, and deploy them.

The tutorial half is the priority. It must be detailed enough that a competent developer who has never written a Solana program can follow it end to end.

## Relationship to task 22
`tasks/22-blockchain-smart-contract-market/` covers the cross-chain market landscape and business models. **This task is a technical deep dive on Solana specifically** — no market sizing, no business models, no chain comparison beyond what's needed to explain a design decision (e.g. why the account model differs from the EVM's storage model). It is independent and does not require task 22 to be complete.

## Part 1 — Solana's smart contract model (the concepts)
Explain, with the reasoning behind each design choice, not just the definition:
- **Terminology** — on Solana, smart contracts are called **programs**; state up front that the terms map onto each other.
- **The account model** — everything is an account; accounts hold lamports and a data buffer; the `owner` field and what it actually controls. Contrast explicitly with the EVM's contract-storage model, since this is the single biggest source of confusion for developers arriving from Ethereum.
- **Stateless programs** — programs are (by default) immutable code that own no state directly; all mutable state lives in separate accounts passed into each instruction.
- **Rent and rent exemption** — the minimum balance requirement and why accounts must be funded.
- **Program Derived Addresses (PDAs)** — seeds, bump seeds, canonical bumps, why PDAs have no private key, and how programs sign with them.
- **Cross-Program Invocation (CPI)** — calling other programs, `invoke` vs. `invoke_signed`, and CPI depth limits.
- **The transaction and instruction model** — instructions, the account list, signers vs. writable accounts, and why every account a transaction touches must be declared **up front**.
- **Sealevel / parallel execution** — how declaring accounts in advance enables parallel transaction processing, and what that means for how you design state (including write-lock contention on hot accounts).
- **Compute units and the compute budget** — limits, how to measure usage, priority fees, and optimization basics.
- **Fees** — base fees, prioritization fees, and how they differ from EVM gas.
- **The SPL/Token ecosystem** — the Token Program, **Token-2022** and its extensions, Associated Token Accounts, and the System Program.
- **Versioned transactions and Address Lookup Tables**, at least briefly.
- Note where **Anchor** sits: a framework that removes boilerplate, versus writing a native Rust program directly.

## Part 2 — The build tutorial (the core deliverable)
### Environment setup
Exact, current commands for: installing Rust, the Solana CLI (note the Anza/Agave toolchain naming), Anchor (via `avm`), and Node for the client. State the version numbers the tutorial was written against, and mention **Solana Playground** as a zero-install alternative.

### Example 1 — Counter program (the fundamentals)
A complete Anchor program that initializes a PDA-backed counter account and increments it. Use it to teach, with **line-by-line explanation**:
- `declare_id!`, the `#[program]` module, instruction handlers and `Context<T>`.
- `#[derive(Accounts)]` and the constraints that matter: `init`, `mut`, `seeds`, `bump`, `payer`, `space`, `has_one`, `constraint`, `close`.
- `#[account]` state structs and how to size them (`InitSpace` / the 8-byte discriminator).
- Custom errors with `#[error_code]`, and emitting events.
- The generated **IDL** and what it's for.

### Example 2 — A realistic program
A second, more substantial program that exercises tokens, PDA signing, and CPI. Choose **one** and justify the choice in the report: an SPL-token **vault/escrow**, a **token staking** program, or a simple **on-chain voting/registry** program. It must demonstrate: PDA as authority, CPI into the Token Program, `invoke_signed`, per-user PDA state, and at least one meaningful validation/authorization check.

### Example 3 — The same thing without Anchor
A short native-Rust version of a simple instruction (`entrypoint!`, `process_instruction`, manual account iteration, Borsh serialization, manual validation) so the reader sees **what Anchor is doing for them** and can read non-Anchor codebases. This can be brief — the point is the contrast.

### Testing
- Anchor's TypeScript tests (`anchor test`), with a full example test file for the counter program.
- Rust-side testing options and modern fast alternatives (e.g. **LiteSVM**, `solana-program-test`, Mollusk) — explain when each is appropriate.
- What to assert, and how to test failure cases (unauthorized caller, bad PDA, arithmetic overflow).

### Client integration
Calling the program from TypeScript: connecting, deriving PDAs client-side, building and sending a transaction with the Anchor client, and reading account state back. Note the `@solana/web3.js` v1 vs. the newer `@solana/kit` (v2) split and which the example targets.

### Deploy
`anchor build` / `anchor deploy`, localnet → devnet → mainnet progression, airdropping on devnet, program IDs and keypairs, the **upgrade authority** (and how to make a program immutable), program size/buffer accounts, deployment costs, and verifiable builds.

## Part 3 — Security
A dedicated section on Solana-specific vulnerability classes, each with a **vulnerable snippet and its fix**:
- Missing **signer** checks.
- Missing **owner** checks / account-type confusion.
- Unvalidated PDAs and **bump seed** canonicalization.
- **Arbitrary CPI** (not verifying the invoked program ID).
- Integer **overflow/underflow** (and Rust release-mode wrapping behavior).
- **Reinitialization** attacks and correct account closing (revival attacks).
- **Duplicate mutable accounts**.
Reference the well-known community resources on these (e.g. the `sealevel-attacks` catalogue) and note that audits are standard before mainnet.

## Part 4 — Going further
Brief pointers with links: zero-copy accounts for large state, state compression / compressed NFTs, Token-2022 extensions in depth, compute-unit optimization, localnet forking, and the main documentation and learning resources.

## Required structure of `output.md`
1. **Title + scope line** — coverage, the Solana CLI / Anchor / Rust versions targeted, and the date the research was performed.
2. **TL;DR** — 5-7 bullets on what's genuinely different about building on Solana.
3. **Part 1 — The programming model** (concepts above).
4. **EVM → Solana translation table** — a table mapping familiar Ethereum concepts to their Solana equivalents (contract storage → accounts, `msg.sender` → signer accounts, `require` → constraints/errors, contract calls → CPI, `CREATE2` → PDAs, gas → compute units), since most readers arrive with EVM assumptions.
5. **Part 2 — Environment setup**.
6. **Part 3 — Example 1: counter program**, with full code and line-by-line explanation.
7. **Part 4 — Example 2: the realistic program**, with full code and explanation.
8. **Part 5 — Example 3: native Rust, no Anchor**.
9. **Part 6 — Testing**.
10. **Part 7 — Client integration**.
11. **Part 8 — Deployment**.
12. **Part 9 — Security** (vulnerable/fixed pairs).
13. **Part 10 — Going further**.
14. **Sources** — every source with title, URL, and access date, noting type (official Solana/Anchor docs, Solana Cookbook, course material, blog, audit firm).

## Rules & cautions
- **Version everything.** Solana tooling changes fast and breaking changes are common — Anchor 0.29 → 0.30 → 0.31 changed APIs, and the toolchain moved from Solana Labs to **Anza/Agave**. State the exact versions the tutorial targets and flag where an older tutorial's syntax would now fail.
- **Code must be complete and internally consistent** — imports included, account structs matching handlers, seeds matching between program and client. A reader should be able to copy each file as given.
- **Do not claim the code was compiled or run if it wasn't.** State plainly which parts were verified against documentation versus executed. (The sandbox this task runs in likely has no Rust/Solana toolchain — do not fake test output.)
- Prefer **primary sources** (`solana.com/docs`, the Anchor Book, `spl.solana.com`, Anza docs) over blog tutorials, which are frequently outdated. Where a widely-circulated tutorial pattern is now deprecated, say so.
- Use **devnet/localnet** for all examples. Include a plain warning that deploying to mainnet involves real funds and that unaudited programs holding user funds are a well-documented way to lose them.
- Do not fabricate URLs, crate versions, or CLI flags.

## Style
- Tutorial format: heavy on fenced code blocks and commands, with explanation immediately following each block.
- Length is secondary to completeness — roughly 3000-5000 words including code is expected.
- All Rust in ```rust blocks, TypeScript in ```typescript blocks, shell in ```bash blocks.
- Instructional, precise tone. Assume a competent developer who is new to Solana, not new to programming.

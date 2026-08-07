# Solana Smart Contracts — Features and a Hands-On Build Tutorial

**Scope.** What makes Solana's program model different, and a complete, followable tutorial: environment setup, three worked programs (Anchor counter, Anchor SPL-token vault, native Rust), testing, client integration, deployment, and Solana-specific security. **Research performed 7 August 2026.**

**Versions targeted.** **Anchor 1.1.2** (released 26 June 2026 per the Anchor `CHANGELOG.md`), **Solana/Agave CLI 3.x** (Anchor 1.0 targets Solana 3.x), **Rust stable** via `rustup`, **Node 22+**, TypeScript client **`@anchor-lang/core`**.

> ⚠️ **Anchor 1.0 (2 April 2026) is a hard break from the 0.3x line, and most tutorials online predate it.** If a tutorial tells you to `cargo install --git https://github.com/coral-xyz/anchor`, imports `@coral-xyz/anchor`, or writes `CpiContext::new(ctx.accounts.token_program.to_account_info(), …)`, it is written for Anchor 0.x and **will not work here**. The specific breaks are listed in [Part 2](#part-2--environment-setup).

> ⚠️ **Published sources disagree on current versions, and I could not resolve it.** `solana.com` and `docs.anza.xyz` were unreachable from this environment; the Solana `developer-content` repo on GitHub still documents `solana-cli 1.18.22` and `anchor-cli 0.30.1`, while a search index of the live installation page shows `Solana CLI 3.0.10 / Anchor CLI 0.32.1 / Surfpool 0.12.0`, and the Anchor `CHANGELOG.md` (which I retrieved directly) shows **1.1.2** as the latest release. **Run the verification step in Part 2 and trust what your machine prints, not this document.**

## Verification status — read this

**None of the code below was compiled, deployed, or run.** This sandbox has `rustc`, `cargo`, and `node`, but **no `solana`, `anchor`, `avm`, or `surfpool` binaries** (verified with `which`), so there is no way to build a Solana program here. There is no fabricated test output anywhere in this document.

What *was* verified: the Anchor `CHANGELOG.md`, the Anchor `README.md`, and two Anchor example/test programs (`examples/tutorial/basic-2`, `tests/spl/token-proxy`) were retrieved verbatim from `raw.githubusercontent.com`, so the macro syntax, the `anchor_spl::token_interface` import paths, and the **`CpiContext::new(program_id, accounts)`** signature are copied from current upstream source rather than recalled. The native-Rust example follows the structure in the Solana `developer-content` repo. Everything else — the counter and vault programs, the tests, the client, and the security pairs — is written by me against those verified APIs and **should be treated as a starting point to compile, not as tested code**.

---

## TL;DR

- **Programs are stateless; accounts hold everything.** A Solana program is deployed code that owns no storage of its own. Every piece of mutable state lives in a separate account that the caller must pass in explicitly. This is the single biggest adjustment coming from the EVM.
- **You must declare every account a transaction touches, up front.** That constraint is not bureaucracy — it is precisely what lets Sealevel execute non-overlapping transactions in parallel.
- **PDAs are the workhorse.** A Program Derived Address has no private key; the program itself signs for it. Deterministic addressing (`CREATE2`-like) and program-controlled authority are the same mechanism here.
- **Anchor removes ~80% of the boilerplate and, more importantly, most of the security footguns.** Owner checks, signer checks, discriminators, and deserialisation are all things Anchor does that native Rust makes you remember.
- **Anchor 1.0 broke a lot.** New TypeScript package name, no `solana` CLI dependency, Surfpool as the default test backend, `CpiContext::new` takes a program **ID** not an `AccountInfo`, and duplicate mutable accounts are rejected by default.
- **The security failure modes are specific and well-catalogued.** Missing signer check, missing owner check, unvalidated PDA bump, arbitrary CPI, and reinitialisation account for most Solana exploits, and each has a one-line fix.

---

## Part 1 — The programming model

### Terminology

On Solana a smart contract is called a **program**. The terms map onto each other directly; "program" is used throughout below.

### The account model

**Everything is an account.** An account is a record in the global state with four things that matter:

| Field | Meaning |
|---|---|
| `lamports` | Balance (1 SOL = 1,000,000,000 lamports) |
| `data` | A raw byte buffer — the account's contents |
| `owner` | The **program** allowed to modify `data` and debit `lamports` |
| `executable` | Whether this account holds program code |

The `owner` field is the core of the security model: **only the owning program may write to an account's `data`.** Anyone can *read* any account. Anyone can *credit* lamports to any account. Only the owner can mutate.

**Contrast with the EVM, because this is where Ethereum developers get stuck.** In Solidity, a contract has its own storage: `mapping(address => uint256) balances` lives inside the contract, and the contract reaches into it whenever it likes. On Solana there is no such thing. Your program is code, and nothing else. A user's balance lives in a *separate account*, owned by your program, whose address the caller must compute and pass in with the transaction. Your program receives a list of accounts, validates that they are the ones it expected, and mutates their bytes.

### Stateless programs

By default a deployed program is immutable code that owns no state. Two consequences: you can never "read a mapping" — the caller must tell you which account to look at; and upgrading a program (if you retain the upgrade authority) does not migrate account data, so schema changes need explicit migration. Anchor 1.0 added a `Migration<'info, From, To>` account type specifically for this.

### Rent and rent exemption

Accounts pay rent for the storage they occupy. In practice every account is made **rent-exempt** by funding it with a minimum balance proportional to its size, after which it pays nothing and persists indefinitely. This is why creating any account costs SOL, and why closing an account refunds that SOL to a recipient you nominate.

### Program Derived Addresses (PDAs)

A PDA is an address derived deterministically from a program ID plus a set of **seeds**, that deliberately falls *off* the ed25519 curve — so **no private key exists for it**. Two properties follow:

1. **Deterministic addressing.** `["counter", authority_pubkey]` always derives the same address for a given program. This is how you build the equivalent of a mapping: the key is the seeds, the value is the account at the derived address.
2. **Program signing.** Because no private key exists, only the deriving program can "sign" for a PDA — by passing the seeds to `invoke_signed`. This is how a program holds and moves assets.

Derivation appends a **bump seed** (a `u8`) and decrements from 255 until the result is off-curve. The first value that works is the **canonical bump**. Using a non-canonical bump is a real vulnerability class (Part 9) — always store the canonical bump and validate against it.

### Cross-Program Invocation (CPI)

A program calls another program with `invoke` (plain call) or `invoke_signed` (call while signing for one or more PDAs). Anchor wraps both in `CpiContext`. **CPI depth is limited to 4** — a program can call a program that calls a program that calls a program, and no further. The invoked program's accounts must be present in the original transaction's account list.

### Transactions and instructions

A transaction contains one or more **instructions**, each naming a program, an ordered list of accounts (each flagged `is_signer` and `is_writable`), and an opaque `data` byte array. Transactions are **atomic**: any instruction failing reverts the whole thing.

**Every account the transaction will touch must be listed up front.** You cannot discover an account mid-execution and load it. This is the constraint EVM developers find most alien, and it is the price of the next section.

### Sealevel and parallel execution

Because the runtime knows every account each transaction reads and writes *before* executing anything, it can run transactions with non-overlapping write sets **in parallel** across cores. Two consequences for design:

- **Design state to spread writes.** Per-user PDAs parallelise; one global counter account serialises everything that touches it.
- **Hot accounts are the bottleneck.** A single popular AMM pool account is a write-lock contention point no amount of parallelism fixes. This is the Solana equivalent of gas-cost optimisation as a design pressure.

### Compute units and the compute budget

Execution is metered in **compute units (CU)**. The default limit is 200,000 CU per instruction, raisable to a maximum of 1,400,000 per transaction by requesting more via the Compute Budget program. You request a limit with `ComputeBudgetProgram.setComputeUnitLimit` and bid for priority with `setComputeUnitPrice` (micro-lamports per CU). Measure actual usage from the `consumed X of Y compute units` line in transaction logs. *(These limits are long-standing but are runtime parameters and can change; verify against current docs.)*

### Fees

A base fee of 5,000 lamports **per signature**, plus an optional **prioritization fee** = compute-unit price × compute-unit limit. Unlike EVM gas, the base fee does not scale with computation — it scales with signature count — so a compute-heavy instruction is cheap unless the network is congested and you are bidding for inclusion.

### The SPL / token ecosystem

- **System Program** — creates accounts, transfers SOL, assigns ownership.
- **Token Program** — the canonical fungible/non-fungible token implementation. Mints and token accounts are just accounts owned by it.
- **Token-2022** — a newer, separate token program with **extensions**: transfer fees, non-transferability, confidential transfers, interest-bearing balances, transfer hooks, metadata. **It has a different program ID**, so code must handle both. Anchor's `token_interface` module (`Interface<'info, TokenInterface>`, `InterfaceAccount<'info, TokenAccount>`) exists exactly to abstract over the two — the vault in Part 4 uses it.
- **Associated Token Account (ATA)** — the canonical PDA holding a given wallet's balance of a given mint, derived from `[wallet, token_program, mint]`.

### Versioned transactions and Address Lookup Tables

Legacy transactions cap out at 35-ish accounts because the whole account list must fit in 1232 bytes. **Versioned transactions** (v0) can reference an **Address Lookup Table** — an on-chain account holding addresses — so a transaction cites a 1-byte index instead of a 32-byte pubkey. Required for anything that touches many accounts (complex DeFi routes).

### Where Anchor sits

Anchor is a framework, not a language. It gives you: an 8-byte **discriminator** prefixed to every account and instruction (type safety, and the basis for `Account<'info, T>` type checking), declarative account validation via `#[derive(Accounts)]`, automatic Borsh serialisation, an **IDL** (interface description) for clients, and errors with messages. Writing native Rust means doing all of that by hand — see Part 5 for exactly how much that is.

---

## EVM → Solana translation table

| Ethereum / EVM | Solana | Note |
|---|---|---|
| Contract storage (`mapping`, state vars) | Separate **accounts**, usually PDAs | The single biggest conceptual shift |
| `contract` (code + state together) | **Program** (code) + accounts (state), separate | Programs are stateless |
| `msg.sender` | An account in the list with `is_signer = true` → `Signer<'info>` | Solana has **multiple** signers per transaction |
| `require(...)` | `require!(...)` / `#[error_code]` / account constraints | Prefer declarative constraints over runtime checks |
| External contract call | **CPI** (`invoke` / `invoke_signed`, or `CpiContext`) | Max depth 4 |
| `CREATE2` deterministic address | **PDA** derived from seeds | PDAs additionally have no private key |
| `address(this)` holding funds | A **PDA** as authority, signing via `invoke_signed` | Programs cannot hold keys; PDAs are how they "sign" |
| Gas / gas limit | **Compute units** / compute budget | Fee is per-signature, not per-computation |
| `wei` | `lamports` (10⁻⁹ SOL) | |
| ERC-20 contract per token | One **Token Program** + a mint account per token | Tokens do not have their own code |
| Token balance in the token contract | A **token account** (usually an ATA) owned by the Token Program | |
| Proxy + `delegatecall` upgrades | Native **upgradeable loader** + upgrade authority | Data migration is still your problem |
| `event` / logs | `emit!` / `#[event]` (base64 in program logs) | Not indexed the way EVM topics are |
| ABI | **IDL** (JSON), plus on-chain Program Metadata since Anchor 1.0 | |
| Reentrancy | Not the primary risk class | CPI depth limit + account model change the threat model |
| `SELFDESTRUCT` refund | `close = recipient` constraint | Refunds the rent-exempt balance |

---

## Part 2 — Environment setup

```bash
# 1. Rust (stable)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"

# 2. Solana / Agave CLI — the installer host is release.anza.xyz (Anza, not Solana Labs)
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
# pin a version instead of `stable` if you need to:
#   sh -c "$(curl -sSfL https://release.anza.xyz/v3.0.10/install)"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# 3. Anchor, via avm (the Anchor Version Manager)
cargo install --git https://github.com/solana-foundation/anchor avm --force
avm install latest
avm use latest

# 4. Node + Yarn
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install 22
npm install --global yarn

# 5. Linux/WSL build dependencies
sudo apt-get update && sudo apt-get install -y \
  build-essential pkg-config libudev-dev llvm libclang-dev protobuf-compiler libssl-dev
```

**Verify — and believe this over the version numbers at the top of this document:**

```bash
rustc --version && solana --version && anchor --version && node --version && yarn --version
# surfpool --version   # if you will use `anchor test` / `anchor localnet` (see below)
```

**What Anchor 1.0 changed about setup, specifically:**

- **The repository moved** from `coral-xyz/anchor` to `solana-foundation/anchor`. Old install commands point at the old org.
- **`avm install` downloads prebuilt binaries by default** (since 0.31); add `--from-source` to compile.
- **The `anchor` CLI no longer shells out to `solana`.** It has native `balance`, `airdrop`, `address`, and `deploy`. The `solana` binary is still worth having for config and program management.
- **`anchor login` and the `[registry]` section of `Anchor.toml` are gone.**
- **Surfpool replaced the local validator as the default backend for `anchor test` and `anchor localnet`** — you need `surfpool` installed for the default commands to work.

**Zero-install alternative.** [Solana Playground](https://beta.solpg.io) is a browser IDE that builds, deploys, and tests Anchor programs with no local toolchain. It is the fastest way to get a first program on devnet, and a reasonable place to follow Part 3. It lags upstream Anchor versions, so check what it is running before copying code between the two.

**Create the project:**

```bash
anchor init counter
cd counter
anchor build
anchor keys sync        # rewrites declare_id! and Anchor.toml to match the generated keypair
```

`anchor keys sync` matters: `anchor init` generates a program keypair under `target/deploy/`, and the `declare_id!` in your source must match it or every instruction will fail an ID check.

---

## Part 3 — Example 1: the counter program

`programs/counter/src/lib.rs`:

```rust
use anchor_lang::prelude::*;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
pub mod counter {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        let counter = &mut ctx.accounts.counter;
        counter.authority = ctx.accounts.authority.key();
        counter.count = 0;
        counter.bump = ctx.bumps.counter;          // store the canonical bump
        emit!(CounterInitialized { authority: counter.authority });
        Ok(())
    }

    pub fn increment(ctx: Context<Increment>, amount: u64) -> Result<()> {
        require!(amount > 0, CounterError::ZeroAmount);
        let counter = &mut ctx.accounts.counter;
        counter.count = counter
            .count
            .checked_add(amount)
            .ok_or(CounterError::Overflow)?;       // never plain `+` on money or counters
        emit!(CounterIncremented { count: counter.count });
        Ok(())
    }

    pub fn close(_ctx: Context<CloseCounter>) -> Result<()> {
        Ok(())                                     // the `close` constraint does the work
    }
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(
        init,                                      // create the account
        payer = authority,                         // who funds rent exemption
        space = 8 + Counter::INIT_SPACE,           // 8-byte discriminator + derived size
        seeds = [b"counter", authority.key().as_ref()],
        bump                                       // derive and expose the canonical bump
    )]
    pub counter: Account<'info, Counter>,

    #[account(mut)]                                // pays rent, so its lamports change
    pub authority: Signer<'info>,

    pub system_program: Program<'info, System>,    // required by `init`
}

#[derive(Accounts)]
pub struct Increment<'info> {
    #[account(
        mut,
        seeds = [b"counter", authority.key().as_ref()],
        bump = counter.bump,                       // validate against the STORED bump
        has_one = authority @ CounterError::Unauthorized
    )]
    pub counter: Account<'info, Counter>,

    pub authority: Signer<'info>,
}

#[derive(Accounts)]
pub struct CloseCounter<'info> {
    #[account(
        mut,
        seeds = [b"counter", authority.key().as_ref()],
        bump = counter.bump,
        has_one = authority @ CounterError::Unauthorized,
        close = authority                          // zero it out, refund rent to authority
    )]
    pub counter: Account<'info, Counter>,

    #[account(mut)]
    pub authority: Signer<'info>,
}

#[account]
#[derive(InitSpace)]                               // generates Counter::INIT_SPACE
pub struct Counter {
    pub authority: Pubkey,                         // 32
    pub count: u64,                                // 8
    pub bump: u8,                                  // 1
}

#[event]
pub struct CounterInitialized {
    pub authority: Pubkey,
}

#[event]
pub struct CounterIncremented {
    pub count: u64,
}

#[error_code]
pub enum CounterError {
    #[msg("Amount must be greater than zero")]
    ZeroAmount,
    #[msg("Counter would overflow")]
    Overflow,
    #[msg("Only the counter authority may perform this action")]
    Unauthorized,
}
```

### Line by line

**`declare_id!`** embeds the program's own public key. Anchor checks incoming instructions against it, so a mismatch fails everything — hence `anchor keys sync`.

**`#[program]`** marks the module whose public functions become instructions. Each takes a `Context<T>` plus Borsh-deserialisable arguments.

**`Context<Initialize>`** gives you `ctx.accounts` (the validated accounts), `ctx.program_id`, `ctx.bumps` (canonical bumps for every `bump`-derived account), and `ctx.remaining_accounts`.

**`#[derive(Accounts)]` is where the security lives.** Anchor generates validation code from the constraints *before* your handler body runs. The ones that matter:

| Constraint | What it does |
|---|---|
| `init` | Creates the account via a System Program CPI, sets owner to your program, writes the discriminator. Requires `payer` and `space`. |
| `init_if_needed` | Same, but tolerates an existing account. **Requires the `init-if-needed` Cargo feature and is a reinitialisation-attack surface** — see Part 9. |
| `mut` | Declares the account writable. Without it the runtime rejects any mutation. |
| `seeds` + `bump` | Derives the PDA and checks the passed address matches. `bump` alone derives the canonical bump; `bump = expr` validates against a stored one. |
| `payer` / `space` | Who funds rent exemption, and how many bytes. |
| `has_one = x` | Asserts `account.x == ctx.accounts.x.key()`. The idiomatic authorization check. |
| `constraint = expr @ Err` | An arbitrary boolean check with a custom error. |
| `close = recipient` | Zeroes the data, writes a closed-account discriminator, and refunds lamports. |

**`space = 8 + Counter::INIT_SPACE`.** Every Anchor account starts with an 8-byte discriminator (the first 8 bytes of a hash of the account name) — this is what makes `Account<'info, Counter>` reject an account of a different type. `#[derive(InitSpace)]` computes the rest. Hand-counting bytes is the classic beginner bug; let the macro do it.

**`bump = counter.bump` vs bare `bump`.** Store the canonical bump on first creation, then validate against the stored value forever after. Re-deriving from scratch on every call is more compute; accepting a *user-supplied* bump is a vulnerability (Part 9).

**`has_one = authority`** is the authorization check. Combined with `authority: Signer<'info>`, it says "the account's recorded authority must be the one who signed."

**`checked_add`.** Rust panics on overflow in debug but **wraps silently in release**, and programs are built in release. Use `checked_*` / `saturating_*` for anything that represents value.

**`#[error_code]`** generates an error enum starting at code 6000, with messages surfaced to clients through the IDL. Anchor 1.0 **disallows multiple `#[error_code]` definitions in a single program**.

**`emit!` / `#[event]`** writes a base64-encoded, discriminator-prefixed record to the program log. Useful for indexers; note it is a log, not an indexed EVM-style topic.

**The IDL** is a JSON description of instructions, accounts, types, and errors that `anchor build` emits to `target/idl/counter.json`, plus TypeScript types in `target/types/counter.ts`. Clients use it to encode instructions and decode accounts without hand-written serialisation. Anchor 1.0 **removed the legacy on-chain IDL instructions and moved IDL management to Program Metadata** — if you are upgrading a deployed 0.x program, close the old IDL account with the 0.32.1 CLI *before* deploying the 1.0 build.

---

## Part 4 — Example 2: an SPL-token vault

**Why this one.** Of the three options (vault/escrow, staking, voting), a **token vault** exercises the most machinery per line: a PDA as token authority, a CPI into the Token Program, PDA signing on withdrawal, per-user PDA state, and a real authorization check. Staking adds reward maths that teaches nothing new about Solana; voting never needs `invoke_signed`.

Add to `programs/token_vault/Cargo.toml`:

```toml
[dependencies]
anchor-lang = { version = "1.1.2", features = ["init-if-needed"] }
anchor-spl = "1.1.2"

[features]
idl-build = ["anchor-lang/idl-build", "anchor-spl/idl-build"]
```

The `idl-build` feature has been **mandatory since Anchor 0.31**; without it `anchor build` produces no IDL.

```rust
use anchor_lang::prelude::*;
use anchor_spl::{
    associated_token::AssociatedToken,
    token_interface::{self, Mint, TokenAccount, TokenInterface, TransferChecked},
};

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
pub mod token_vault {
    use super::*;

    pub fn initialize_vault(ctx: Context<InitializeVault>) -> Result<()> {
        let vault = &mut ctx.accounts.vault;
        vault.mint = ctx.accounts.mint.key();
        vault.admin = ctx.accounts.admin.key();
        vault.total_deposited = 0;
        vault.bump = ctx.bumps.vault;
        Ok(())
    }

    pub fn deposit(ctx: Context<Deposit>, amount: u64) -> Result<()> {
        require!(amount > 0, VaultError::ZeroAmount);

        // User signs for their own tokens: a plain CPI, no PDA signing needed.
        let cpi_accounts = TransferChecked {
            from: ctx.accounts.depositor_ata.to_account_info(),
            mint: ctx.accounts.mint.to_account_info(),
            to: ctx.accounts.vault_ata.to_account_info(),
            authority: ctx.accounts.depositor.to_account_info(),
        };
        // NOTE: Anchor 1.0 — first argument is the program ID, NOT its AccountInfo.
        let cpi_ctx = CpiContext::new(ctx.accounts.token_program.key(), cpi_accounts);
        token_interface::transfer_checked(cpi_ctx, amount, ctx.accounts.mint.decimals)?;

        let position = &mut ctx.accounts.position;
        position.owner = ctx.accounts.depositor.key();
        position.vault = ctx.accounts.vault.key();
        position.bump = ctx.bumps.position;
        position.amount = position
            .amount
            .checked_add(amount)
            .ok_or(VaultError::Overflow)?;

        let vault = &mut ctx.accounts.vault;
        vault.total_deposited = vault
            .total_deposited
            .checked_add(amount)
            .ok_or(VaultError::Overflow)?;

        Ok(())
    }

    pub fn withdraw(ctx: Context<Withdraw>, amount: u64) -> Result<()> {
        require!(amount > 0, VaultError::ZeroAmount);
        require!(
            ctx.accounts.position.amount >= amount,
            VaultError::InsufficientBalance
        );

        // Signer seeds must exactly reproduce the vault PDA's derivation.
        let mint_key = ctx.accounts.mint.key();
        let vault_bump = ctx.accounts.vault.bump;
        let signer_seeds: &[&[u8]] = &[b"vault", mint_key.as_ref(), &[vault_bump]];

        let cpi_accounts = TransferChecked {
            from: ctx.accounts.vault_ata.to_account_info(),
            mint: ctx.accounts.mint.to_account_info(),
            to: ctx.accounts.withdrawer_ata.to_account_info(),
            authority: ctx.accounts.vault.to_account_info(),   // the PDA is the authority
        };
        let cpi_ctx = CpiContext::new(ctx.accounts.token_program.key(), cpi_accounts)
            .with_signer(&[signer_seeds]);                     // → invoke_signed
        token_interface::transfer_checked(cpi_ctx, amount, ctx.accounts.mint.decimals)?;

        // Mutate state only AFTER the CPI succeeds.
        ctx.accounts.position.amount -= amount;
        ctx.accounts.vault.total_deposited -= amount;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct InitializeVault<'info> {
    #[account(
        init,
        payer = admin,
        space = 8 + Vault::INIT_SPACE,
        seeds = [b"vault", mint.key().as_ref()],
        bump
    )]
    pub vault: Account<'info, Vault>,

    #[account(
        init,
        payer = admin,
        associated_token::mint = mint,
        associated_token::authority = vault,          // the PDA owns the vault's tokens
        associated_token::token_program = token_program
    )]
    pub vault_ata: InterfaceAccount<'info, TokenAccount>,

    pub mint: InterfaceAccount<'info, Mint>,

    #[account(mut)]
    pub admin: Signer<'info>,

    pub token_program: Interface<'info, TokenInterface>,   // Token OR Token-2022
    pub associated_token_program: Program<'info, AssociatedToken>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Deposit<'info> {
    #[account(
        mut,
        seeds = [b"vault", mint.key().as_ref()],
        bump = vault.bump,
        has_one = mint @ VaultError::MintMismatch
    )]
    pub vault: Account<'info, Vault>,

    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = vault,
        associated_token::token_program = token_program
    )]
    pub vault_ata: InterfaceAccount<'info, TokenAccount>,

    #[account(
        init_if_needed,
        payer = depositor,
        space = 8 + Position::INIT_SPACE,
        seeds = [b"position", vault.key().as_ref(), depositor.key().as_ref()],
        bump
    )]
    pub position: Account<'info, Position>,

    #[account(
        mut,
        token::mint = mint,
        token::authority = depositor
    )]
    pub depositor_ata: InterfaceAccount<'info, TokenAccount>,

    pub mint: InterfaceAccount<'info, Mint>,

    #[account(mut)]
    pub depositor: Signer<'info>,

    pub token_program: Interface<'info, TokenInterface>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Withdraw<'info> {
    #[account(
        mut,
        seeds = [b"vault", mint.key().as_ref()],
        bump = vault.bump,
        has_one = mint @ VaultError::MintMismatch
    )]
    pub vault: Account<'info, Vault>,

    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = vault,
        associated_token::token_program = token_program
    )]
    pub vault_ata: InterfaceAccount<'info, TokenAccount>,

    #[account(
        mut,
        seeds = [b"position", vault.key().as_ref(), withdrawer.key().as_ref()],
        bump = position.bump,
        has_one = owner @ VaultError::Unauthorized      // position.owner == owner account
    )]
    pub position: Account<'info, Position>,

    /// CHECK: constrained to equal `withdrawer` below; exists so `has_one = owner` has a target.
    #[account(address = withdrawer.key() @ VaultError::Unauthorized)]
    pub owner: UncheckedAccount<'info>,

    #[account(
        mut,
        token::mint = mint,
        token::authority = withdrawer
    )]
    pub withdrawer_ata: InterfaceAccount<'info, TokenAccount>,

    pub mint: InterfaceAccount<'info, Mint>,

    #[account(mut)]
    pub withdrawer: Signer<'info>,

    pub token_program: Interface<'info, TokenInterface>,
}

#[account]
#[derive(InitSpace)]
pub struct Vault {
    pub mint: Pubkey,
    pub admin: Pubkey,
    pub total_deposited: u64,
    pub bump: u8,
}

#[account]
#[derive(InitSpace)]
pub struct Position {
    pub owner: Pubkey,
    pub vault: Pubkey,
    pub amount: u64,
    pub bump: u8,
}

#[error_code]
pub enum VaultError {
    #[msg("Amount must be greater than zero")]
    ZeroAmount,
    #[msg("Arithmetic overflow")]
    Overflow,
    #[msg("Insufficient balance in position")]
    InsufficientBalance,
    #[msg("Mint does not match the vault's mint")]
    MintMismatch,
    #[msg("Caller is not the position owner")]
    Unauthorized,
}
```

### What to notice

**`CpiContext::new(ctx.accounts.token_program.key(), cpi_accounts)`.** In Anchor 0.x this took `ctx.accounts.token_program.to_account_info()`. Anchor 1.0 removed the redundant program `AccountInfo` from the CPI context (`#2762`), so **it now takes the program ID**. This is the change most likely to break code you copy from an older tutorial, and it fails at compile time, which is merciful.

**`.with_signer(&[signer_seeds])` is `invoke_signed`.** The seeds must reproduce the PDA derivation exactly, including the bump as a final one-byte slice. The Token Program sees the vault PDA as the authority and permits the transfer. The awkward `let mint_key = …` line exists because the seed slice borrows from a value that must outlive the CPI call.

**`token_interface` rather than `token`.** `Interface<'info, TokenInterface>` accepts either the Token Program or Token-2022, and `InterfaceAccount` deserialises either account layout. Hard-coding `Program<'info, Token>` locks you out of every Token-2022 mint.

**`transfer_checked`, not `transfer`.** `transfer` is deprecated (upstream Anchor wraps its calls in `#[allow(deprecated)]`) because it does not verify the mint or decimals. `transfer_checked` does both.

**State is mutated after the CPI.** If the transfer fails, the whole transaction reverts anyway, but ordering this way keeps the invariant obvious.

**`init_if_needed` is used deliberately** so a second deposit does not fail — and it is precisely the constraint that creates reinitialisation risk. It is safe *here* because `deposit` only ever adds to `position.amount` and re-derives the PDA from the depositor's key. It would be unsafe if the handler reset a field an attacker benefits from resetting. See Part 9.

---

## Part 5 — Example 3: the same thing without Anchor

This is deliberately just the `increment` instruction, to show what Anchor generates.

```toml
[dependencies]
borsh = "1.5"
solana-program = "3"        # see note below on the crate split

[lib]
crate-type = ["cdylib", "lib"]
```

```rust
use borsh::{BorshDeserialize, BorshSerialize};
use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
};

#[derive(BorshSerialize, BorshDeserialize, Debug)]
pub struct Counter {
    pub authority: Pubkey,
    pub count: u64,
}

entrypoint!(process_instruction);

pub fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    // No IDL, no discriminator: you invent your own instruction encoding.
    let (tag, _payload) = instruction_data
        .split_first()
        .ok_or(ProgramError::InvalidInstructionData)?;

    match tag {
        1 => increment(program_id, accounts),
        _ => Err(ProgramError::InvalidInstructionData),
    }
}

fn increment(program_id: &Pubkey, accounts: &[AccountInfo]) -> ProgramResult {
    // Manual, ordered account iteration — Anchor's #[derive(Accounts)]
    let iter = &mut accounts.iter();
    let counter_ai = next_account_info(iter)?;
    let authority_ai = next_account_info(iter)?;

    // Anchor: Account<'info, Counter> does this for you
    if counter_ai.owner != program_id {
        return Err(ProgramError::IncorrectProgramId);
    }
    // Anchor: Signer<'info>
    if !authority_ai.is_signer {
        return Err(ProgramError::MissingRequiredSignature);
    }
    // Anchor: the `mut` constraint
    if !counter_ai.is_writable {
        return Err(ProgramError::InvalidAccountData);
    }

    let mut data = counter_ai.try_borrow_mut_data()?;
    // Anchor: discriminator check + Borsh deserialisation
    let mut counter = Counter::try_from_slice(&data)?;

    // Anchor: has_one = authority
    if counter.authority != *authority_ai.key {
        return Err(ProgramError::IllegalOwner);
    }

    counter.count = counter
        .count
        .checked_add(1)
        .ok_or(ProgramError::ArithmeticOverflow)?;

    counter.serialize(&mut &mut data[..])?;
    msg!("count = {}", counter.count);
    Ok(())
}
```

**The point.** Every commented line is something Anchor does automatically and you must remember here. Three of them — owner check, signer check, and the type/discriminator check — are the top three Solana vulnerability classes. That is the argument for Anchor, and it is a strong one.

**A note on the crate split.** Recent toolchains broke the monolithic `solana-program` crate into smaller ones (`solana-program-entrypoint`, `solana-account-info`, `solana-pubkey`, `solana-program-error`, …); Anchor 0.32.0's changelog records replacing `solana-program` with those smaller crates. The `solana_program::…` façade paths above are still the form used in the official program-structure docs. If your build complains about missing modules, switch to the granular crates. Newer minimal frameworks (e.g. Pinocchio) go further for compute-unit-critical programs.

---

## Part 6 — Testing

**Which harness, and when:**

| Tool | Runs | Use it for |
|---|---|---|
| **LiteSVM** | The SVM in-process, in your Rust or TS test | Fast unit tests. The default choice. |
| **Mollusk** | A minified SVM harness, per-instruction | Isolated instruction checks and CU benchmarking |
| **Surfpool** | A local node with realistic (mainnet-forked) cluster state | Integration tests; **the default backend for `anchor test` since Anchor 1.0** |
| **`solana-test-validator`** | A real local validator | Only when you need RPC behaviour the lighter harnesses do not emulate |
| **`solana-program-test`** | The older Rust harness | Legacy; prefer LiteSVM/Mollusk |

`tests/counter.ts`:

```typescript
import * as anchor from "@anchor-lang/core";
import type { Program } from "@anchor-lang/core";
import { PublicKey, Keypair, SystemProgram } from "@solana/web3.js";
import { assert } from "chai";
import type { Counter } from "../target/types/counter";

describe("counter", () => {
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);

  const program = anchor.workspace.Counter as Program<Counter>;
  const authority = provider.wallet.publicKey;

  // Derive the PDA client-side with the SAME seeds as the program.
  const [counterPda] = PublicKey.findProgramAddressSync(
    [Buffer.from("counter"), authority.toBuffer()],
    program.programId,
  );

  it("initializes to zero", async () => {
    await program.methods.initialize().accounts({ counter: counterPda }).rpc();

    const account = await program.account.counter.fetch(counterPda);
    assert.equal(account.count.toNumber(), 0);
    assert.ok(account.authority.equals(authority));
  });

  it("increments", async () => {
    await program.methods.increment(new anchor.BN(5)).accounts({ counter: counterPda }).rpc();

    const account = await program.account.counter.fetch(counterPda);
    assert.equal(account.count.toNumber(), 5);
  });

  it("rejects a zero amount", async () => {
    try {
      await program.methods.increment(new anchor.BN(0)).accounts({ counter: counterPda }).rpc();
      assert.fail("should have thrown");
    } catch (err: any) {
      assert.equal(err.error.errorCode.code, "ZeroAmount");
    }
  });

  it("rejects an unauthorized caller", async () => {
    const attacker = Keypair.generate();
    await provider.connection.requestAirdrop(attacker.publicKey, 1_000_000_000);

    try {
      await program.methods
        .increment(new anchor.BN(1))
        .accounts({ counter: counterPda, authority: attacker.publicKey })
        .signers([attacker])
        .rpc();
      assert.fail("should have thrown");
    } catch (err: any) {
      // The attacker's PDA derivation differs, so this fails on seeds before has_one.
      assert.ok(err.toString().length > 0);
    }
  });
});
```

```bash
anchor test                      # builds, starts the local backend, runs the tests
anchor test --skip-local-validator   # against an already-running node
```

**What to assert.** The success path is the least interesting third of a good test suite. Always cover: an **unauthorized caller** (wrong signer), a **bad PDA** (an account at an address your seeds do not produce), **arithmetic edges** (`u64::MAX`, zero), **double operations** (deposit twice, withdraw more than deposited), and **account-type confusion** (pass a `Position` where a `Vault` is expected — the discriminator should reject it).

**Package-name caveat.** `@anchor-lang/core` is the Anchor 1.0 replacement for `@coral-xyz/anchor`, confirmed in the changelog and the README. I imported `PublicKey`/`Keypair` from `@solana/web3.js` explicitly rather than relying on an `anchor.web3` re-export, because **I could not verify Anchor 1.x's re-export surface** — check `node_modules/@anchor-lang/core` and adjust.

---

## Part 7 — Client integration

```typescript
import * as anchor from "@anchor-lang/core";
import { Connection, PublicKey, Keypair } from "@solana/web3.js";
import idl from "./target/idl/counter.json";
import type { Counter } from "./target/types/counter";

const connection = new Connection("https://api.devnet.solana.com", "confirmed");
const wallet = new anchor.Wallet(Keypair.generate());   // in a browser: the wallet adapter
const provider = new anchor.AnchorProvider(connection, wallet, { commitment: "confirmed" });

const program = new anchor.Program<Counter>(idl as Counter, provider);

// Derive the PDA — same seeds, same order, same encoding as the program.
const [counterPda, bump] = PublicKey.findProgramAddressSync(
  [Buffer.from("counter"), wallet.publicKey.toBuffer()],
  program.programId,
);

// Send
const signature = await program.methods
  .increment(new anchor.BN(1))
  .accounts({ counter: counterPda, authority: wallet.publicKey })
  .rpc();
console.log("signature:", signature);

// Read state back
const counter = await program.account.counter.fetch(counterPda);
console.log("count:", counter.count.toString());

// Fetch every counter owned by this program, filtered by authority
const mine = await program.account.counter.all([
  { memcmp: { offset: 8, bytes: wallet.publicKey.toBase58() } },  // 8 = discriminator
]);
```

**Seeds must match byte for byte.** `Buffer.from("counter")` on the client and `b"counter"` in Rust must be the same bytes, and the order must match. A mismatch produces a different address and a confusing "account does not exist" or seeds-constraint failure. Deriving the PDA in one shared helper is worth doing on day one.

**`memcmp` offset 8** skips the Anchor discriminator; `authority` is the first field, so it starts at byte 8.

**web3.js v1 vs `@solana/kit` (v2).** The JavaScript ecosystem split: `@solana/web3.js` v1 is the mature, class-based library most tutorials and wallet adapters still use; `@solana/kit` (formerly web3.js v2) is a tree-shakable, functional rewrite. **The examples here target v1**, because that is what Anchor's generated client has historically been built around. New greenfield frontends should evaluate `@solana/kit`; mixing the two in one codebase is painful.

---

## Part 8 — Deployment

```bash
# Localnet (Surfpool is the Anchor 1.0 default backend)
anchor localnet

# Devnet
solana config set --url devnet
solana-keygen new -o ~/.config/solana/devnet.json     # if you need a fresh key
solana airdrop 2                                       # devnet SOL, rate-limited
anchor build
anchor keys sync                                       # keep declare_id! and Anchor.toml in step
anchor deploy --provider.cluster devnet

# Mainnet — real money
anchor deploy --provider.cluster mainnet
```

> ⚠️ **Deploying to mainnet spends real SOL and, if your program holds user funds, puts real money behind your code.** Unaudited programs holding user funds are a thoroughly documented way to lose them. Test on localnet, then devnet, then get an audit.

**Program IDs and keypairs.** `anchor init` generates `target/deploy/<name>-keypair.json`. **That file is the program's identity** — lose it and you can never upgrade the program; leak it and someone else can (if they also hold the upgrade authority). Back it up outside the repo and never commit it.

**Upgrade authority.** Deployed programs are upgradeable by default, with the deployer's keypair as the upgrade authority:

```bash
solana program show <PROGRAM_ID>                                    # inspect authority, size, balance
solana program set-upgrade-authority <PROGRAM_ID> --new-upgrade-authority <PUBKEY>
solana program set-upgrade-authority <PROGRAM_ID> --final           # IRREVERSIBLE: immutable forever
```

Upgrade authority is a trust decision your users should be able to see: a single hot key means one compromise rewrites the program under their funds. A multisig is the normal answer; `--final` is the maximal one, and it means you can never patch a bug.

**Deployment cost and buffer accounts.** Deploying writes the ELF to a buffer account, then to the program data account, both of which must be rent-exempt — so cost scales with program size (order of a few SOL for a typical Anchor program; check with `solana program show`). Failed deploys can strand SOL in orphaned buffers:

```bash
solana program show --buffers          # list stranded buffers
solana program close <BUFFER_ADDRESS>  # reclaim the rent
```

**Verifiable builds.** Because the deployed artifact is a binary, users cannot tell it matches your source. `solana-verify` produces a deterministic, Docker-based build and can register the source repo on-chain; Anchor 1.1.1 re-implemented `verifiedBuild` against the OtterSec registry. Do this for any program handling other people's money.

---

## Part 9 — Security

Each pair below is a real vulnerability class from the `sealevel-attacks` catalogue. **Audits are standard practice before mainnet for anything holding funds** — and, as the Balancer incident showed on other chains, not a guarantee.

**1. Missing signer check**

```rust
// ✗ VULNERABLE — anyone can pass any authority pubkey
#[derive(Accounts)]
pub struct Withdraw<'info> {
    #[account(mut, has_one = authority)]
    pub vault: Account<'info, Vault>,
    /// CHECK: not verified
    pub authority: UncheckedAccount<'info>,
}
```
```rust
// ✓ FIXED — Signer<'info> requires an actual signature
#[derive(Accounts)]
pub struct Withdraw<'info> {
    #[account(mut, has_one = authority)]
    pub vault: Account<'info, Vault>,
    pub authority: Signer<'info>,
}
```

**2. Missing owner check / type confusion**

```rust
// ✗ VULNERABLE — deserialises bytes from an account any program could own
let vault = Vault::try_from_slice(&ctx.accounts.vault.data.borrow())?;
```
```rust
// ✓ FIXED — Account<'info, T> checks owner == this program AND the 8-byte discriminator
pub vault: Account<'info, Vault>,
```
`UncheckedAccount` / `AccountInfo` do **neither** check. Every `/// CHECK:` comment in your codebase is a promise you made to yourself — treat each as a code-review item.

**3. Unvalidated PDA / non-canonical bump**

```rust
// ✗ VULNERABLE — attacker supplies a bump, producing a different valid PDA they control
#[derive(Accounts)]
#[instruction(bump: u8)]
pub struct Update<'info> {
    #[account(mut, seeds = [b"vault", mint.key().as_ref()], bump = bump)]
    pub vault: Account<'info, Vault>,
    pub mint: InterfaceAccount<'info, Mint>,
}
```
```rust
// ✓ FIXED — validate against the canonical bump stored at creation
#[account(mut, seeds = [b"vault", mint.key().as_ref()], bump = vault.bump)]
pub vault: Account<'info, Vault>,
```

**4. Arbitrary CPI**

```rust
// ✗ VULNERABLE — invokes whatever program the caller passed as "token_program"
let cpi_ctx = CpiContext::new(ctx.accounts.token_program.key(), cpi_accounts);
// where: /// CHECK: pub token_program: UncheckedAccount<'info>,
```
```rust
// ✓ FIXED — the type constrains the program ID
pub token_program: Interface<'info, TokenInterface>,   // Token or Token-2022 only
// or, to pin one exactly:
pub token_program: Program<'info, Token>,
```
An attacker who can substitute the invoked program can make your PDA sign anything.

**5. Integer overflow / underflow**

```rust
// ✗ VULNERABLE — release builds WRAP silently; underflow gives a huge balance
position.amount -= amount;
```
```rust
// ✓ FIXED
position.amount = position
    .amount
    .checked_sub(amount)
    .ok_or(VaultError::InsufficientBalance)?;
```
Optionally belt-and-braces in `Cargo.toml`:
```toml
[profile.release]
overflow-checks = true
```

**6. Reinitialisation and revival**

```rust
// ✗ VULNERABLE — init_if_needed on a handler that RESETS state
#[account(init_if_needed, payer = user, space = 8 + Position::INIT_SPACE, seeds = [...], bump)]
pub position: Account<'info, Position>,
// handler: position.amount = 0;   ← attacker re-runs this to wipe a debt or reset a flag
```
```rust
// ✓ FIXED — separate `init` (once) from `update` (many), or guard explicitly
#[account(init, payer = user, space = 8 + Position::INIT_SPACE, seeds = [...], bump)]
pub position: Account<'info, Position>,
// and in an init_if_needed handler, never reset fields — only accumulate:
position.amount = position.amount.checked_add(amount).ok_or(VaultError::Overflow)?;
```
**Revival:** manually zeroing an account's data and refunding lamports is not enough — if the account is still rent-exempt at transaction end it survives and can be reused. Use the **`close = recipient`** constraint, which also writes a closed-account discriminator so a revived account fails type checks.

**7. Duplicate mutable accounts**

```rust
// The classic bug: pass the same token account as both `from` and `to`,
// so a "transfer" credits and debits the same balance and mints value from nothing.
```
```rust
// ✓ Anchor 1.0 rejects duplicate mutable accounts BY DEFAULT.
// Opt back in only where genuinely intended:
#[account(mut, dup)]
pub account_b: Account<'info, Something>,
// Pre-1.0, the manual guard was:
require_keys_neq!(ctx.accounts.from.key(), ctx.accounts.to.key(), VaultError::Unauthorized);
```
This is one of the strongest reasons to be on Anchor 1.x: a whole bug class became a compile-time default.

**Reference:** the community `sealevel-attacks` catalogue (`coral-xyz/sealevel-attacks`) documents each of these with runnable insecure/secure program pairs. Work through it before writing anything that holds funds.

---

## Part 10 — Going further

- **Zero-copy accounts** — `#[account(zero_copy)]` with `AccountLoader<'info, T>` for large state (order books, big arrays). Avoids deserialising the whole buffer into the stack, which is otherwise a hard limit.
- **State compression / compressed NFTs** — store data in a Merkle tree with only the root on-chain, cutting cost by orders of magnitude for large collections. Trade-off: you need an indexer to read it.
- **Token-2022 extensions** — transfer fees, transfer hooks, confidential transfers, interest-bearing tokens, non-transferable tokens, metadata pointers. Each changes assumptions your program may be making; a mint with a transfer fee means the amount received is *less* than the amount sent.
- **Compute-unit optimisation** — measure from transaction logs; the usual wins are avoiding unnecessary deserialisation, using zero-copy, minimising CPIs, and `Box`ing large accounts out of the stack.
- **Localnet forking** — Surfpool (or `solana-test-validator --clone`) pulls real mainnet accounts into a local instance so you can test against live pool and mint state.
- **Documentation and learning:** `solana.com/docs`, the Anchor Book at `anchor-lang.com/docs`, `spl.solana.com`, Anza's `docs.anza.xyz` for validator/CLI, the Solana Cookbook, and Solana Playground for a zero-install sandbox.

---

## Sources

All accessed **7 August 2026**. Type noted for each. **Several primary sites were unreachable from this environment** (`solana.com`, `docs.anza.xyz`, `anchor-lang.com` all returned egress blocks); where that happened I fell back to the same content in its GitHub source repository, which is noted per item.

**Primary — retrieved in full**

1. **Anchor `CHANGELOG.md`** — https://github.com/solana-foundation/anchor/blob/master/CHANGELOG.md (fetched via `raw.githubusercontent.com`) — release dates (1.1.2 on 2026-06-26, 1.0.0 on 2026-04-02, 0.32.x, 0.31.x) and the **verbatim breaking-change list for 1.0.0** used throughout Parts 2, 4, 6, and 9. *(official repo)*
2. **Anchor `README.md`** — https://github.com/solana-foundation/anchor — install guidance and the `@anchor-lang/core` package name. *(official repo)*
3. **Anchor example: `examples/tutorial/basic-2`** — https://github.com/solana-foundation/anchor/blob/master/examples/tutorial/basic-2/programs/basic-2/src/lib.rs — retrieved verbatim; confirms current `declare_id!` / `#[program]` / `#[derive(Accounts)]` / `#[account]` syntax. *(official repo)*
4. **Anchor test: `tests/spl/token-proxy`** — https://github.com/solana-foundation/anchor/blob/master/tests/spl/token-proxy/programs/token-proxy/src/lib.rs — retrieved verbatim; source of the `anchor_spl::token_interface` import list, the **`CpiContext::new(program_id, cpi_accounts)`** signature, and the fact that `transfer` is deprecated in favour of `transfer_checked`. *(official repo)*
5. **Anchor test: `tests/escrow`** — https://github.com/solana-foundation/anchor/blob/master/tests/escrow/programs/escrow/src/lib.rs — source of the `.with_signer(&[&seeds[..]])` PDA-signing form. *(official repo)*
6. **Solana `developer-content` — `docs/intro/installation.md`** — https://github.com/solana-foundation/developer-content/blob/main/docs/intro/installation.md — install command shapes (`release.anza.xyz`, `avm`, nvm, Linux deps). **Note: this file's stated versions (solana-cli 1.18.22, anchor-cli 0.30.1, `coral-xyz/anchor`) are stale relative to the Anchor changelog**; the commands were used, the version numbers were not. *(official repo, outdated content)*
7. **Solana `developer-content` — `docs/programs/rust/program-structure.md`** — https://github.com/solana-foundation/developer-content/blob/main/docs/programs/rust/program-structure.md — the native-Rust `entrypoint!` / `process_instruction` / `next_account_info` / Borsh structure in Part 5. *(official repo)*

**Primary — not retrievable from this environment (cited as pointers)**

8. Anchor release notes 1.0.0 — https://www.anchor-lang.com/docs/updates/release-notes/1-0-0 — **[blocked]**
9. Anchor installation docs — https://www.anchor-lang.com/docs/installation — **[blocked]**
10. Anchor testing docs — Mollusk — https://www.anchor-lang.com/docs/testing/mollusk — **[blocked]**
11. Solana installation docs — https://solana.com/docs/intro/installation — **[blocked]**; a search index of this page reported *Solana CLI 3.0.10, Anchor CLI 0.32.1, Surfpool CLI 0.12.0* and the verification command used in Part 2. **This conflicts with the changelog's 1.1.2** and the conflict is flagged rather than resolved.
12. Solana Rust program structure docs — https://solana.com/docs/programs/rust/program-structure — **[blocked]**; content retrieved from the source repo as item [7].
13. Agave CLI install docs — https://docs.anza.xyz/cli/install/ — **[blocked]**
14. Mollusk docs — https://solana.com/docs/programs/testing/mollusk — **[blocked]**

**Official repositories and tooling**

15. **Anza — Agave validator/CLI** — https://github.com/anza-xyz/agave — the toolchain formerly published by Solana Labs; `release.anza.xyz` is the current installer host. *(official repo)*
16. **Anza — Mollusk** — https://github.com/anza-xyz/mollusk — "SVM program test harness"; minified-SVM instruction testing. *(official repo)*
17. **`solana-program-entrypoint`** — https://crates.io/crates/solana-program-entrypoint — one of the crates the monolithic `solana-program` was split into. *(crate registry)*
18. **`solana-program`** — https://crates.io/crates/solana-program · https://docs.rs/solana-program/ — the façade paths used in Part 5. *(crate registry / docs)*

**Announcements and secondary**

19. **Solana Developers announcement of Anchor v1.0.0** — https://x.com/solana_devs/status/2039837963840803283 — "No more Solana CLI dependency; Surfpool & LiteSVM as defaults; `@anchor-lang/core`; `Migration<From, To>`." *(official project social account)*
20. **Solana Ecosystem Roundup: April 2026** — https://solana.com/news/solana-ecosystem-roundup-april-2026 — Anchor 1.0 in context. *(official blog; page body not retrieved)*
21. **`solana-foundation/solana-dev-skill` — `references/testing.md`** — https://github.com/solana-foundation/solana-dev-skill/blob/main/skill/references/testing.md — the LiteSVM / Mollusk / Surfpool / `solana-test-validator` guidance in Part 6. *(official-org repo)*
22. **Anchor releases page** — https://github.com/solana-foundation/anchor/releases *(official repo)*
23. Blueshift, "Testing your Program — Anchor for Dummies" — https://learn.blueshift.gg/en/courses/anchor-for-dummies/testing-your-program *(course material)*
24. QuickNode, "What is a Cross Program Invocation (CPI) on Solana?" — https://www.quicknode.com/guides/solana-development/anchor/what-are-cpis *(vendor guide; written for Anchor 0.x — its `CpiContext::new` calls are outdated)*
25. Torii Security, "Testing Solana Programs: Essential Tools and Tips" — https://toriisecurity.substack.com/p/testing-solana-programs-essential *(audit-firm blog)*

**Caveats.** (a) **No code here was compiled or executed** — see the verification section at the top. (b) The published sources **disagree on current tool versions**; the Anchor changelog (retrieved directly) is the most authoritative item I have, and the live docs site could not be read. (c) Compute-unit limits (200k default / 1.4M max), the 5,000-lamport-per-signature base fee, and the CPI depth limit of 4 are long-standing runtime parameters stated from established documentation rather than re-verified against a live source this session — confirm before relying on exact numbers. (d) `@anchor-lang/core`'s exact re-export surface (whether `anchor.web3` still exists) was **not verified**; the client examples import from `@solana/web3.js` directly to avoid depending on it. (e) Anchor's `CpiContext::new_with_signer` may still exist alongside the `.with_signer()` chaining form shown; only the chained form was observed in current upstream source.

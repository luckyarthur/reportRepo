# How to Become an AI Agent Engineer — A Concept Handbook and Study Map

**Scope.** The complete set of concepts a working AI agent engineer must understand, and the path from a general software engineering background to doing the job. Covers model interaction primitives, the agent loop, tools and MCP, context engineering, memory and retrieval, multi-agent architectures, evaluation, observability, security, cost/latency, and product design — plus the stack, a staged learning path, and hiring. **Research performed 24 September 2026.**

**Volatility warning.** Model identifiers, context limits, pricing multipliers, API parameter names and protocol revision dates in this field change on a scale of weeks. Every such figure here is marked as a point-in-time value with an access date and a citation. **Re-verify all of them against the provider's own documentation before relying on them.** The concepts are durable; the numbers are not.

**What this is not.** Not a framework tutorial, not a motivational career piece, and not a survey of agent products. Part 3 is the centre of gravity; everything else supports it.

---

## How to read this

### Evidence tiers

Every non-obvious claim carries a tier marker.

| Tier | Meaning |
|---|---|
| **(A)** | Primary — official API/model docs, protocol specs, model and system cards, framework reference docs and source, published benchmark definitions. |
| **(B)** | Independent — peer-reviewed papers and arXiv preprints, reproducible benchmark results, first-hand production engineering write-ups, security research from recognised bodies. |
| **(C)** | Reported/promotional — vendor blog claims without reproducible method, recruiter and course content, unsourced numbers. |

**Rule applied throughout: no capability claim, benchmark number, price or limit rests on (C) alone.** Where only (C) exists, it is labelled and the report says what verification would require.

A fourth marker, **(A-idx)** or **(B-idx)**, means the source is primary or independent but this environment could only reach a search-engine summary of it, not the full text. See *Retrieval limitations* below.

### The five-part concept template

Every concept in Part 3 gets the same treatment, compressed:

1. **What** — one or two precise sentences.
2. **Mechanism** — what concretely enters and leaves the context window, or what the harness does between calls.
3. **When** — and when not.
4. **Fails** — the symptom an engineer actually observes in production.
5. **Test** — what an eval for it looks like.

If a concept cannot be stated mechanically in step 2, that is flagged explicitly. Several popular terms fail that test and are called out.

### Retrieval limitations (honest gap statement)

Web access was available. Four domains needed for primary verification were **blocked by this environment's egress proxy** and could not be fetched full-text:

- `modelcontextprotocol.io` — the MCP specification itself. MCP claims below are marked **(A-idx)** and drawn from the search index of the spec changelog plus secondary engineering write-ups. **Verify the revision date and primitive list against the spec directly.**
- `arxiv.org` — all paper PDFs. Paper titles, authors, venues and headline findings are from search-index summaries, publisher landing pages and author repositories. Marked **(B-idx)**. Titles and arXiv IDs are reported as found; **no paper is cited here that did not appear in at least two independent search results.**
- `genai.owasp.org` — the OWASP GenAI project site. The OWASP Top 10 for LLM Applications 2025 PDF on `owasp.org` appeared in results; the agentic-applications list is **(C/B-idx)**.
- `axialsearch.com` — the 43,500-posting job-market analysis. Part 6's market data is therefore weaker than the rest of this report and is labelled accordingly.

Full text **was** retrieved for: Anthropic's context-engineering, building-effective-agents and advanced-tool-use engineering posts; the Claude platform prompt-caching documentation; and the OpenTelemetry GenAI span conventions at tag v1.41.0.

**Nothing in this report is a fabricated citation.** Where a number could not be traced to a source, the pattern is described without the number.

---

## TL;DR

1. **An agent is a model in a loop with tools and a stopping condition, operating over a context it does not fully control.** If the control flow is fixed in your code, it is a workflow, not an agent — Anthropic draws exactly this line (A, Anthropic Engineering, 19 Dec 2024).
2. **Most of the job is ordinary backend engineering.** HTTP, retries, idempotency, queues, schemas, observability. The LLM-specific part is real but is a minority of the working week.
3. **Context engineering has displaced prompt engineering as the central skill.** The unit of work is "what configuration of tokens is in the window right now", not "what words are in the prompt" (A, Anthropic Engineering, 29 Sep 2025).
4. **Long context windows do not mean uniform context performance.** Recall degrades with position and with input length, measured across 18 models (B, Chroma, Jul 2025; B-idx, Liu et al., TACL 2024). Treat context as a budget, not a bucket.
5. **Commonly believed and wrong #1: "more tools = more capable agent."** Tool-selection accuracy measured at 43.13% with retrieval-based tool selection vs 13.62% with all schemas in-context on an MCP stress test (B-idx, RAG-MCP, arXiv 2505.03275). Anthropic's own deferred-loading feature reports an 85% token reduction and MCP-eval accuracy moving 79.5% → 88.1% on one model (A, Anthropic Engineering, 24 Nov 2025).
6. **Commonly believed and wrong #2: "agents can reliably self-correct if you ask them to reflect."** Intrinsic self-correction without external feedback does not reliably help and sometimes degrades performance (B-idx, Huang et al., ICLR 2024). Reflection works when there is a *real* signal — a test suite, a compiler, a validator — not when the model grades itself.
7. **Commonly believed and wrong #3: "vector RAG is the default retrieval layer for agents."** For agents that can act in a loop, lexical search plus file reads frequently outperforms embedding retrieval, and removes an index that can go stale (B-idx, arXiv 2605.15184; A-idx, Anthropic on agentic search). Vector search still wins in specific regimes; it is not the default.
8. **Multi-agent is usually a cost multiplier, not a capability multiplier.** Anthropic reports its multi-agent research system using roughly **15× the tokens of a chat interaction** (A-idx, Jun 2025); Cognition's production position is that additional agents should contribute *intelligence*, not *actions*, and that writes stay single-threaded (B-idx, Cognition).
9. **Evaluation is the discipline, and it is where most teams are weakest.** Non-determinism breaks pass/fail testing. `pass^k` ("all k trials succeeded") is a more honest reliability metric than `pass@k` — at 90% per-trial success, `pass^8` is ~57% (B-idx, τ-bench, arXiv 2406.12045).
10. **Public agent benchmarks are substantially broken.** Up to 100% over- or under-estimation of agent performance from task-setup and reward-design flaws; SWE-bench Verified uses insufficient tests; τ-bench counted empty responses as successes (B-idx, Zhu et al., arXiv 2507.02825). An earlier audit found ~32.67% solution leakage in successful SWE-bench patches (B-idx, arXiv 2410.06992).
11. **Prompt injection is structurally unsolved.** Instructions and data share one channel. It is #1 on the OWASP LLM Top 10 for the second consecutive edition (B/C-idx, OWASP 2025). No complete mitigation exists; the practical defence is architectural — break the *lethal trifecta* of private data + untrusted content + an outbound channel (B, Willison, 16 Jun 2025).
12. **You probably do not need a framework to start, and starting without one teaches more.** A competent agent loop is a few dozen lines around an HTTP call. Anthropic's own guidance is to start with direct API calls (A, 19 Dec 2024).
13. **Cost scales super-linearly with turns**, because each turn re-sends the whole conversation. Prompt caching changes the architecture, not just the bill — cache reads were priced at 0.1× base input with cache writes at 1.25× (5-min TTL) or 2× (1-hour TTL) (A, Claude platform docs, accessed 2026-09-24; point-in-time).
14. **Observability standards are not settled.** Every `gen_ai.*` attribute and span in the OpenTelemetry GenAI conventions carried the **Development** (pre-stable) badge at v1.41.0 (A, verified 2026-09-24). Do not architect on the assumption of a stable spec.
15. **Hiring is portfolio-led.** A project with evals, a readable trace, explicit failure handling and a stated limitations section beats a certificate and beats a demo.

---

## Part 1 — What the job actually is

### 1.1 A definition that survives scrutiny

An **AI agent** is a language model invoked repeatedly in a loop, where:

- the model can emit **tool calls** that the harness executes,
- tool results are appended to the context and the model is called again,
- the loop has a **stopping condition** (the model emits no tool call, a budget is exhausted, or a guard fires),
- and the **control flow is decided by the model**, not by your code.

The last clause is the line. Anthropic states it directly: workflows are "systems where LLMs and tools are orchestrated through predefined code paths"; agents are "systems where LLMs dynamically direct their own processes and tool usage, maintaining control over how they accomplish tasks" (A, Anthropic Engineering, 19 Dec 2024).

Contrast table:

| Shape | Who decides the next step | Tools | Loop | Is it an agent? |
|---|---|---|---|---|
| Single prompt call | You | No | No | No |
| Fixed chain / pipeline | You | Maybe | No | No |
| Workflow engine with an LLM step | You (the DAG) | Yes | Bounded, fixed | No |
| Router (LLM picks branch, code executes) | Model picks once, you execute | Maybe | No | Borderline — "LLM routing", not an agent |
| Chatbot with retrieval | You (retrieve → answer) | No | No | No |
| **Model loop with tools + stop condition** | **Model, each turn** | **Yes** | **Yes, open-ended** | **Yes** |

**Say it plainly: a large fraction of what is marketed as an "agent" is a fixed pipeline with an LLM inside it.** That is not a criticism of the product — pipelines are more predictable, cheaper, easier to evaluate, and are often the correct engineering choice. It is a criticism of the vocabulary, which makes it hard to reason about what you are actually building and what will go wrong.

A second, subtler clause matters: **operating over a context it does not fully control.** Once tool results, retrieved documents or user-supplied files enter the window, content you did not author is influencing the model's next action. Nearly every hard problem in Parts 3I (security) and 3D (context) descends from that single fact.

### 1.2 What the role is not

| Role | Core artefact | Overlap with agent engineering | Load-bearing for this job? |
|---|---|---|---|
| **ML engineer** | Trained/served models, feature pipelines | Serving, batching, latency | Partially — serving intuition helps; training does not |
| **Research scientist** | Papers, novel methods | Reading the literature | No, except the ability to read papers critically |
| **Data scientist** | Analyses, models, dashboards | Experiment design, statistics | **Yes** — eval design *is* experiment design |
| **MLOps / platform engineer** | Infra, CI/CD, monitoring | Deploys, observability, cost | **Yes** — large overlap |
| **"Prompt engineer"** | Prompts | Prompt iteration | **Largely obsolete as a title.** The skill survives; the job title has been absorbed into agent/AI engineering |
| **Backend engineer** | Services, APIs, data | Almost everything else | **Yes — this is the base class** |

The honest summary: **an AI agent engineer is a backend engineer with an evaluation habit, a token budget, and a threat model.**

### 1.3 A day in the job

A realistic breakdown for someone shipping a production agent. Percentages are **an estimate from the structure of the work, not survey data** — treat as an ordering, not a measurement.

| Activity | Rough share | Notes |
|---|---|---|
| Ordinary software engineering (APIs, data, deploys, glue, review) | ~35–45% | Not LLM-specific |
| Tool and integration plumbing | ~15% | Schemas, auth, error mapping, pagination, truncation |
| Failure triage from traces | ~10–15% | The distinctive skill: debugging from a recorded trajectory, not a repro |
| Eval writing and maintenance | ~10–15% | Underinvested almost everywhere |
| Prompt and context iteration | ~5–10% | Far smaller than the discourse implies |
| Cost and latency work | ~5–10% | Caching, routing, parallelism, truncation |
| Security review / permission design | ~5% | Rises sharply with blast radius |

The single most role-specific activity is **failure triage from traces**, because agents fail in ways that do not reproduce. That skill is not transferable from a framework tutorial.

### 1.4 Where the role sits

| Setting | What the work is dominated by | What is hardest |
|---|---|---|
| **Product-facing agents** (support, assistants) | Latency, refusal/escalation behaviour, trust UX | Consistency across users; `pass^k` reliability |
| **Internal automation** | Integration breadth, permissions | Blast radius; nobody is watching the output |
| **Coding agents** | Long-horizon context, tool granularity, sandboxing | Context management across hours-long runs |
| **Customer support** | Policy adherence, deterministic backends, handoff | Cost per conversation; injection via user content |
| **Research / analysis agents** | Breadth of search, synthesis, citation integrity | Cost (this is where multi-agent occasionally pays) |
| **Agent platform teams** | Harness, tracing, eval infra, guardrails | Building for use cases you cannot see |

---

## Part 2 — Prerequisites and the honest skill floor

### 2.1 Software engineering fundamentals that are actually load-bearing

- **One language fluently.** Python and TypeScript dominate, for a structural reason, not a fashion one: provider SDKs, agent frameworks, eval tooling and MCP server implementations ship first-class support for both and often nothing else. Python leads in eval/data tooling; TypeScript leads where the agent lives next to a web product.
- **Async and concurrency.** An agent run is a long chain of I/O waits. Parallel tool execution, streaming, and timeouts are the difference between a 6-second and a 40-second response.
- **HTTP and streaming.** Server-Sent Events specifically — token streaming is SSE in most provider APIs; you will debug partial frames, mid-stream errors, and client disconnects.
- **Retries, backoff, idempotency.** Providers rate-limit and occasionally fail mid-stream. Tools have side effects. An agent that retries a non-idempotent tool will double-charge a customer.
- **Queues and job runners.** Long agent runs do not belong in a request/response handler.
- **Databases.** Conversation state, run records, eval results, traces. Ordinary relational modelling; nothing exotic.
- **Containers and sandboxes.** If the agent executes code or drives a browser, isolation is a hard requirement, not a nicety.
- **Distributed-systems reasoning.** Partial failure, at-least-once delivery, and replay are the daily reality of a multi-step agent run.

### 2.2 How much ML is genuinely required

**Required, because engineering decisions depend on it:**

- **Tokenisation** — why costs and limits are in tokens; why token counts differ per provider; why a "10,000-character document" has no fixed token cost.
- **The context window as a hard budget** — including that output tokens and reasoning tokens consume it.
- **Attention cost scaling** — enough to know that doubling context is not free in latency, and that "just put everything in context" has a price curve.
- **Sampling parameters** — temperature, top-p, and the fact that `temperature=0` is *not* a determinism guarantee in practice (batching, hardware non-determinism, and provider-side changes all break it).
- **Autoregressive generation** — why the model cannot revise an emitted token, which explains a whole class of structured-output and self-correction failures.
- **Why models confabulate** — next-token prediction has no truth oracle; there is no internal "I don't know" flag to read.

**Safe to treat as a black box:**

- Transformer internals, attention head mechanics, positional encoding schemes.
- Pre-training data curation, tokenizer training, optimiser choice.
- Quantisation internals (you need the *effect*, not the method).
- RLHF/DPO mechanics.

**This report deliberately does not contain a transformer tutorial.** If you can explain what a token is, what the context window costs, and why the model cannot take back a token it already emitted, you have enough.

### 2.3 Fine-tuning, RLHF, distillation — when they matter here

Mostly they do not. Ranked by how often they are the right answer for an agent team:

1. **Almost always wrong first move:** fine-tuning to fix agent behaviour. Behaviour problems are usually context problems or tool-design problems, and fine-tuning freezes them into weights you then have to maintain across model upgrades.
2. **Occasionally right:** distilling a large model's behaviour into a small one for a **narrow, high-volume, stable** sub-task (a classifier, a router, an extraction step). This is a cost play with a real payback calculation.
3. **Right for a small minority:** organisations with proprietary formats, unusual output grammars, or strict latency budgets at very high volume.
4. **Essentially never the agent engineer's job:** RLHF. If you are doing RLHF you are on a model team, not an agent team.

The counter-pressure is real: every fine-tune you own is a migration cost the next time a materially better base model ships, which in this field is measured in months.

### 2.4 Honest gap analysis

| Starting point | What you already have | What is missing | Rough time to competent (deliberate practice, part-time) |
|---|---|---|---|
| **Backend engineer (3+ yrs)** | ~70% of the job: services, data, retries, deploys, debugging | Token/context intuition; eval discipline; prompt and tool-description craft; injection threat model | **2–4 months** to first production-quality agent; ~6 months to judgement |
| **Data scientist** | Experiment design, statistics, evaluation instinct (the rarest piece) | Production engineering: async, services, deploys, observability, security | **4–8 months**, dominated by software engineering, not AI |
| **New graduate** | Fundamentals, time, no legacy habits | Everything production: failure modes, on-call, integration reality, plus all of the above | **9–18 months** to be trusted with a live agent; the binding constraint is production experience, not AI knowledge |

The uncomfortable conclusion: **the fastest route in is to become a solid backend engineer first.** There is no version of this job that skips that.

---

## Part 3 — The concept map

### Index of concepts covered

**A — Model interaction primitives (11)**
A1 Tokens and tokenisation · A2 Context windows as a budget · A3 Message/turn structure and roles · A4 Sampling and the determinism myth · A5 Streaming · A6 Stop conditions and finish reasons · A7 Structured output · A8 Tool calling as an API primitive · A9 Prompt caching · A10 Batching · A11 Multimodal input · A12 Reasoning / extended thinking modes

**B — The agent loop (9)**
B1 The core loop · B2 ReAct: contribution vs mythology · B3 Planning vs reactive execution · B4 Task decomposition · B5 Reflection and self-critique · B6 Tool-choice forcing · B7 Budget and iteration guards · B8 Interruption, human-in-the-loop, resumability · B9 Idempotency, replay, checkpointing and durable execution

**C — Tools (10)**
C1 Tool descriptions as a prompt surface · C2 Parameter schema design · C3 Error messages as model input · C4 Tool granularity and count · C5 Result size and truncation · C6 Read-only vs side-effecting tools · C7 Permissioning, confirmation, dry-run · C8 Sandboxing and code execution · C9 Computer and browser use · C10 MCP and interop

**D — Context engineering (9)**
D1 Why context engineering displaced prompt engineering · D2 Context as a budgeted resource · D3 System prompt design · D4 Few-shot examples and when they hurt · D5 Instruction conflict and ordering · D6 Context rot and long-context degradation · D7 Compaction and hand-off · D8 Scratchpads and external state · D9 Sub-agent context isolation

**E — Memory and retrieval (9)**
E1 Short-term vs long-term memory · E2 Session and conversation state · E3 Embeddings and vector search · E4 Chunking · E5 Hybrid and lexical search · E6 Reranking · E7 Agentic search vs one-shot RAG (and why grep often wins) · E8 Knowledge graphs · E9 Freshness, invalidation, and what must never be written to memory

**F — Multi-agent systems (6)**
F1 Orchestrator/worker · F2 Pipeline and peer patterns · F3 Hand-off and state transfer · F4 Shared vs isolated context · F5 Coordination overhead · F6 The evidence, including negative results

**G — Evaluation (11)**
G1 Why non-determinism breaks testing · G2 The eval hierarchy · G3 Building a test set from real traces · G4 Golden datasets and their maintenance cost · G5 LLM-as-judge · G6 Judge validation and circularity · G7 pass@k vs pass^k and variance · G8 Regression testing across model versions · G9 Cost and latency as first-class metrics · G10 Public benchmarks and their validity problems · G11 "Did my change help?" — the practical protocol

**H — Observability and operations (8)**
H1 Tracing an agent run · H2 What to log and what must never be logged · H3 Token accounting and cost attribution · H4 Latency budgets · H5 Debugging from a trace · H6 Failure taxonomy · H7 Versioning prompts, tools and models together · H8 Rollout, rollback, and on-call

**I — Security and safety (10)**
I1 Prompt injection: direct and indirect · I2 The lethal trifecta · I3 Tool output as untrusted input · I4 Exfiltration channels · I5 Confused deputy and credential scope · I6 Sandboxing and least privilege · I7 Approval gates and irreversible actions · I8 Supply chain risk in third-party tools/MCP servers · I9 Secrets, PII, residency · I10 Jailbreaks vs injections; standards and compliance

**J — Cost, latency and scale (9)**
J1 The arithmetic of an agent run · J2 Why cost scales super-linearly · J3 Caching and context reuse · J4 Model routing and cascades · J5 Streaming for perceived latency · J6 Parallel tool execution · J7 Batching and offline queues · J8 Rate limits, backoff, quota · J9 Self-hosting and open weights

**K — Product and interface (7)**
K1 Designing for a system that is wrong sometimes · K2 Showing work and intermediate state · K3 Trust calibration and honest uncertainty · K4 Permission and confirmation UX · K5 Interruption and steering · K6 Latency perception · K7 When an agent is the wrong product shape

---

### Cluster A — Model interaction primitives

**A1 — Tokens and tokenisation**
- *What.* The model reads and writes sub-word units; every limit, price and latency figure is denominated in them.
- *Mechanism.* Text → tokenizer → integer IDs → embedding lookup. Tokenizers differ per provider and per model family, so the same string has different token counts across providers. Whitespace, casing, non-English scripts and long identifiers all change the ratio.
- *When.* Always, for budgeting. You need a token counter in your codebase from week one.
- *Fails.* Silent truncation at the window boundary; cost estimates off by 2–3× on non-English or code-heavy content; a "short" document blowing a limit because it is JSON with long keys.
- *Test.* Assert token counts for representative payloads in CI; alert when a prompt template's rendered size drifts beyond a threshold.

**A2 — Context windows and what "fitting" costs**
- *What.* The hard ceiling on tokens in one request — input, output and (where applicable) reasoning tokens together.
- *Mechanism.* Everything the model sees is re-sent on every turn: system prompt, tool schemas, full message history, all prior tool results. There is no server-side memory between calls unless the provider offers an explicit stateful API.
- *When.* Every design decision touches it. "Fitting" is necessary, not sufficient — see D6.
- *Fails.* Hard API errors at the boundary; worse, *soft* failure where everything fits and quality quietly degrades. The second is far more dangerous because there is no error to alert on.
- *Test.* Track p50/p95/p99 input tokens per run. Run the same eval at short and long context and compare — if scores drop, you have a budget problem, not a capability problem.

**A3 — Message/turn structure and roles**
- *What.* The request is a typed sequence: a system instruction plus alternating user / assistant / tool-result messages.
- *Mechanism.* A tool-using turn looks like this:
  ```
  system:     "You are ... Rules: ..."
  user:       "refund order 4417"
  assistant:  [tool_use id=t1 name=get_order input={"id":"4417"}]
  tool:       [tool_result id=t1 content="{...order json...}"]
  assistant:  [tool_use id=t2 name=issue_refund input={"id":"4417","amount":42.00}]
  tool:       [tool_result id=t2 content="{\"status\":\"ok\"}"]
  assistant:  "Refunded $42.00 to the original payment method."
  ```
  The harness owns everything between `assistant` and the next `assistant`. **That code is the agent.**
- *When.* Always. Understanding the exact wire shape is the single highest-leverage piece of knowledge in this list.
- *Fails.* Orphaned tool-call IDs (a tool_use with no matching tool_result) cause hard API errors; role confusion where user content is placed in a system slot weakens instruction hierarchy and widens injection surface.
- *Test.* Assert well-formedness of the message array before every call — every `tool_use` has exactly one matching `tool_result`, roles alternate legally.

**A4 — Sampling parameters and the determinism myth**
- *What.* Temperature, top-p and related knobs shape the sampling distribution over next tokens.
- *Mechanism.* Logits → (temperature scaling) → (nucleus/top-p truncation) → sample. Temperature 0 approximates greedy decoding.
- *When.* Low temperature for extraction, routing and tool-argument generation. Higher for drafting and ideation. Most agent work wants low.
- *Fails.* **Temperature 0 does not give you reproducibility.** Batching effects, floating-point non-associativity on GPUs, and silent provider-side model updates all break byte-identical replay. Engineers who assume determinism write flaky tests and then disable them.
- *Test.* Run the same input N times (N ≥ 5) and measure variance of the outcome metric, not of the string. If your eval cannot tolerate run-to-run variance, your eval is wrong (see G7).

**A5 — Streaming**
- *What.* Incremental delivery of tokens as they are generated, usually over SSE.
- *Mechanism.* The response arrives as a sequence of typed events (content deltas, tool-call deltas, usage, stop reason). Tool-call arguments stream as partial JSON fragments and are only valid once complete.
- *When.* Any user-facing surface. Rarely worth the complexity for batch/offline work.
- *Fails.* Parsing partial JSON as if complete; mid-stream errors after you have already shown the user text; client disconnects that leave a tool half-executed; usage/cost data arriving only in the final event and being dropped.
- *Test.* Inject a mid-stream disconnect in an integration test; assert no side-effecting tool executes twice and that partial output is handled.

**A6 — Stop conditions and finish reasons**
- *What.* Why generation ended: natural end, max-tokens hit, stop sequence, tool call requested, or a safety refusal.
- *Mechanism.* The response carries a discriminated finish/stop reason. The agent loop branches on it: tool-call → execute and continue; end-turn → return to user; max-tokens → **you have a truncated response, not a complete one**.
- *When.* Every loop iteration. This is the loop's actual control flow.
- *Fails.* Treating a max-tokens truncation as a complete answer — the classic source of silently malformed JSON and half-written files.
- *Test.* Assert on the stop reason in unit tests; deliberately set a tiny max-tokens and confirm the agent surfaces truncation rather than proceeding.

**A7 — Structured output (JSON mode, schema-constrained decoding)**
- *What.* Forcing the model's output to conform to a schema.
- *Mechanism.* Two distinct techniques, commonly conflated. (i) *Prompted JSON*: ask nicely, then parse and retry. Fails at a measurable rate. (ii) *Constrained decoding*: the inference engine masks tokens that cannot continue a valid parse of the grammar, so invalid tokens get probability zero (A, OpenAI, "Introducing Structured Outputs in the API"). The second gives syntactic guarantees; **neither gives semantic guarantees.**
- *When.* Any machine-consumed output. Prefer constrained decoding where the provider offers it.
- *Fails.* (a) *Valid but wrong* — schema-conformant garbage, the dominant failure mode. (b) Truncation at max-tokens producing incomplete JSON regardless of constraints. (c) Schema restrictions: strict modes typically require all properties listed as required with `additionalProperties: false`, so "optional" fields become nullable unions (A, OpenAI docs). (d) **Format constraints can degrade task performance** — reported by "Let Me Speak Freely? A Study on the Impact of Format Restrictions on Performance of Large Language Models" (B-idx, arXiv 2408.02442). Schema difficulty across engines is benchmarked by JSONSchemaBench (B-idx, arXiv 2501.10868).
- *Test.* Two separate assertions: schema-validity rate (should be ~100% under constrained decoding) and **semantic correctness rate** (will not be). Only the second one matters.

**A8 — Function/tool calling as an API primitive**
- *What.* The model emits a structured request to invoke a named function with typed arguments; your code executes it and returns the result.
- *Mechanism.* Tool schemas are serialised into the prompt (they consume input tokens and are typically the cache prefix — see A9). The model emits a tool_use block; **the provider never executes anything.** Your harness dispatches, captures the result, appends it as a tool message, and calls again.
- *When.* Any time the agent must read or change state outside the context window.
- *Fails.* Hallucinated tool names or arguments; correct tool, wrong argument (the most common and hardest to detect); the model narrating a tool call in prose instead of emitting one; parallel tool calls the harness executes serially.
- *Test.* A fixture set of user inputs → expected tool name and argument assertions. This is the cheapest high-value eval in the whole discipline and most teams skip it.

**A9 — Prompt caching, and why it changes architecture**
- *What.* Providers cache the computed state for a prompt *prefix* so repeated requests sharing that prefix skip recomputation.
- *Mechanism.* You mark a breakpoint; the provider hashes everything up to it. On a match, those tokens are billed and processed at a steep discount. **Point-in-time figures (A, Claude platform docs, accessed 2026-09-24):** up to 4 breakpoints per request; the cache covers `tools` → `system` → `messages` **in that order**; 5-minute TTL by default with a 1-hour option; cache writes billed at 1.25× base input (5-min) or 2× (1-hour); cache reads at 0.1× base input, with model-specific exceptions; minimum cacheable prefix varies by model (values from 512 to 4,096 tokens were listed). **Changing tool definitions invalidates the entire cache.** Other providers implement caching with different mechanics — verify each.
- *When.* Any agent with a large stable prefix, which is nearly all of them.
- *Fails.* Cache thrash from putting a timestamp, a session ID or a user name near the top of the system prompt — every request becomes a cache write. TTL expiry between turns on a slow conversation. Reordering tools between deploys silently destroying hit rate.
- *Test.* Log cache-read vs cache-write vs uncached token counts per run and alert on hit-rate regression. A prompt change that drops cache hit rate from 90% to 10% is a cost incident, and it will not show up in any quality eval.

**A10 — Batching**
- *What.* Submitting many independent requests as one asynchronous job, usually at a discount and with a long completion window.
- *Mechanism.* Submit a file of requests, poll for completion, collect results. Latency is measured in minutes to hours.
- *When.* Offline evals (the biggest use), bulk classification, backfills. Never in an interactive path.
- *Fails.* Teams run their eval suite through the interactive API and pay several times over; conversely, teams try to serve users from a batch queue.
- *Test.* Not a behaviour to test — a cost line item to check.

**A11 — Multimodal inputs**
- *What.* Images, PDFs, audio and video in the input.
- *Mechanism.* Media is tokenised into a token count that depends on resolution/duration; those tokens occupy the same context budget as text.
- *When.* Document understanding, screenshot-driven computer use, chart reading.
- *Fails.* Cost blowup — a handful of high-resolution screenshots can dominate a run's token bill. Fine detail (small text, dense tables) is read unreliably. **Images are an injection surface**: text rendered inside an image is instruction-bearing content your text filters never see.
- *Test.* Evals on real, degraded inputs (skewed scans, low-res screenshots), plus an explicit image-borne injection case in the security suite.

**A12 — Reasoning / extended-thinking modes**
- *What.* Modes where the model produces internal reasoning tokens before its answer, usually with a configurable budget.
- *Mechanism.* Reasoning tokens are generated, billed (typically as output), and count against the window; depending on the provider they may be partly or wholly hidden from you.
- *When.* Genuinely hard planning, ambiguous debugging, multi-constraint decisions. **Not** for routing, extraction, or simple tool selection — you pay latency and tokens for nothing.
- *Fails.* Latency inflation on interactive surfaces; cost surprises; harness bugs when reasoning blocks must be preserved across turns (some providers require echoing them back, and dropping them changes behaviour and can invalidate caching — see A9).
- *Test.* A/B the same eval with reasoning on and off, reporting **three** numbers: quality, cost, latency. Report all three or the comparison is dishonest.

---

### Cluster B — The agent loop

**B1 — The core loop**
- *What.* The whole thing, in about 30 lines.
- *Mechanism.*
  ```python
  messages = [{"role": "user", "content": task}]
  for step in range(MAX_STEPS):
      resp = client.create(system=SYSTEM, tools=TOOLS, messages=messages)
      messages.append({"role": "assistant", "content": resp.content})
      calls = [b for b in resp.content if b.type == "tool_use"]
      if not calls:
          return resp                      # stop: model ended its turn
      results = []
      for c in calls:                      # parallelise where safe
          try:
              out = TOOL_IMPL[c.name](**c.input)
          except ToolError as e:
              out = f"ERROR: {e}"          # errors go back as model input (C3)
          results.append({"type": "tool_result", "tool_use_id": c.id,
                          "content": truncate(out)})
      messages.append({"role": "user", "content": results})
  raise MaxStepsExceeded()                 # stop: guard fired (B7)
  ```
  Everything in Clusters C, D, E, H, I and J is an elaboration of `TOOL_IMPL`, `truncate`, `SYSTEM`, and what you do with `messages` when it gets long.
- *When.* Always. Write this once by hand before touching a framework.
- *Fails.* No step cap (infinite loop, unbounded spend); no token cap; exceptions escaping instead of being returned to the model; growing `messages` without bound.
- *Test.* Unit-test the loop with a stub model: assert it terminates on no-tool-call, on max steps, and on a token budget.

**B2 — ReAct: contribution vs mythology**
- *What.* Interleaving reasoning traces with actions — "Thought / Action / Observation" (B-idx, Yao et al., *ReAct: Synergizing Reasoning and Acting in Language Models*, ICLR 2023, arXiv 2210.03629).
- *Mechanism.* In the original formulation, the model emits free-text reasoning and an action in a text format the harness parses. Its real contribution was showing that reasoning traces help the model *track and revise plans* and handle exceptions, and that actions ground reasoning in external state.
- *When.* Conceptually, always — it is the intellectual ancestor of the loop in B1. **As an implementation, almost never today.** Native tool-calling APIs and native reasoning modes have absorbed both halves; hand-rolled Thought/Action/Observation string parsing is a legacy pattern that adds a parser you must maintain.
- *Fails.* The mythology: that "using ReAct" is an architectural choice that makes an agent smarter. It is not. If you are calling tools in a loop, you are already doing the thing ReAct described.
- *Test.* If you cannot state what ReAct adds *over your provider's native tool calling*, you do not need it.

**B3 — Planning vs reactive execution**
- *What.* Produce a plan up front and follow it, versus decide one step at a time.
- *Mechanism.* Planning inserts a first turn whose output is a plan, then keeps that plan in context as a persistent instruction. Reactive execution has no such artefact — each turn sees the history and decides.
- *When.* Plan when steps are interdependent, when a human should approve the approach before spend, or when the run is long enough that drift is likely. Stay reactive for short runs and where the environment changes under you.
- *Fails.* **Plan lock-in** — the model follows a plan invalidated by what it learned at step 3, because the plan is sitting in context asserting itself. Plans also consume budget and become stale context.
- *Test.* Evaluate on tasks with a deliberate mid-run surprise (a tool returns something that should change the approach). Measure whether the agent revises.

**B4 — Task decomposition**
- *What.* Breaking a task into sub-tasks, either in-context or by dispatching sub-agents.
- *Mechanism.* Either a list in the context that the agent works through (cheap, shared context) or separate model calls with their own windows (expensive, isolated context — see D9/F1).
- *When.* When sub-tasks are genuinely independent, or when a sub-task would flood the main context with material that is not needed afterwards.
- *Fails.* Over-decomposition — coordination overhead exceeding the benefit; sub-tasks that need context they were not given; the classic "the sub-task succeeded but the whole task failed" pattern.
- *Test.* End-to-end task success only. Sub-task success rates are a trap: they can all pass while the composite fails.

**B5 — Reflection and self-critique — and the evidence**
- *What.* Having the model review and revise its own output.
- *Mechanism.* Append the output plus a critique instruction and call again; feed the critique into a revision turn. Reflexion (B-idx, Shinn et al., NeurIPS 2023, arXiv 2303.11366) formalised keeping verbal self-reflections in an episodic buffer across trials.
- *When.* **Only with a real external signal.** Test output, a compiler, a linter, a schema validator, a diff against ground truth — something outside the model that says "this is wrong".
- *Fails.* **Intrinsic self-correction — critique with no external feedback — does not reliably improve reasoning and can degrade it** (B-idx, Huang et al., *Large Language Models Cannot Self-Correct Reasoning Yet*, ICLR 2024, arXiv 2310.01798). The observed production symptom is an agent that "reconsiders" a correct answer into a wrong one, and a doubled token bill. Note the tension in the literature: Reflexion reports gains *in settings with environment feedback*; Huang et al. attack the *feedback-free* case. These are compatible, and conflating them is how the myth spread.
- *Test.* Run the identical eval with reflection on and off. If quality does not improve by more than run-to-run variance (G7), delete it — you are paying for nothing.

**B6 — Tool-choice forcing**
- *What.* Constraining whether and which tool the model may call on a given turn (`auto` / `any` / `none` / a specific tool, in typical provider vocabulary).
- *Mechanism.* A request parameter that alters decoding constraints for that call.
- *When.* Forcing a specific tool for a first step (always search before answering); forcing `none` on a final summarisation turn so the agent stops talking to tools and talks to the user.
- *Fails.* Forcing a tool when no tool is appropriate produces fabricated arguments. Forcing `any` in a loop can prevent termination entirely.
- *Test.* Assert the forced call happens; assert the loop still terminates with forcing enabled.

**B7 — Max-iteration and budget guards**
- *What.* Hard limits on steps, tokens, wall-clock time, and money per run.
- *Mechanism.* Counters in the harness checked before each model call and before each tool dispatch; exceeding one raises a typed error the harness converts into a graceful stop.
- *When.* **Always. Non-negotiable.** An unguarded loop is an unbounded liability.
- *Fails.* Absent guards → runaway spend, usually discovered on the invoice. Guards that abort hard → the user gets an error after two minutes of work instead of a partial result.
- *Test.* Force each guard in an integration test and assert a graceful, informative stop with partial results preserved.

**B8 — Interruption, human-in-the-loop, and resumability**
- *What.* Pausing the loop for a human decision, then continuing.
- *Mechanism.* The harness classifies a pending tool call as requiring approval, persists the run state (messages + pending call), returns to the caller, and resumes by appending the approval decision as a tool result. A three-tier model is the common industry shape (C, multiple 2026 practitioner sources; the pattern is uncontroversial): **auto-approve** for reversible reads, **notify** for recoverable writes, **block** for irreversible actions.
- *When.* Any side-effecting tool whose reversal is expensive; any action outside a well-tested envelope.
- *Fails.* State not persisted, so an approval means re-running from scratch; approval prompts that show the user a tool name and raw JSON instead of what will actually change; approval fatigue producing reflexive clicking, which is worse than no gate because it manufactures false assurance.
- *Test.* Resume-after-restart integration test: kill the process mid-approval, restart, resume, assert the tool executes exactly once.

**B9 — Idempotency, replay, checkpointing and durable execution**
- *What.* Making a partially-executed agent run safe to retry, and making runs survive process death.
- *Mechanism.* Idempotency keys on side-effecting tools; an append-only log of (call, result) pairs; on replay, completed calls return their logged result rather than re-executing. **Checkpointing your state is not durable execution.** A graph library that persists state still dies with the process; something outside must detect the failure and re-enter. Durable-execution engines (Temporal-style) make the *execution* recoverable, not just the data (B, Diagrid and Temporal engineering write-ups, 2026; the distinction is well-argued and matches first principles).
- *When.* Any run longer than a request timeout; any run with irreversible side effects.
- *Fails.* Double-charging on retry; "resume" that replays a `send_email` tool; a run that silently dies on deploy with no record of how far it got.
- *Test.* Chaos test — kill the worker at each step boundary, resume, assert exactly-once semantics on side-effecting tools.

---

### Cluster C — Tools

**C1 — Tool descriptions are a prompt surface, not API documentation**
- *What.* The natural-language description of each tool, which is the model's *only* information about when to use it.
- *Mechanism.* Descriptions are serialised into the prompt as tokens. The model does semantic matching between the user's need and your prose. It has never read your codebase and never will.
- *When.* Every tool, always. This is where the highest-leverage prompt engineering still lives.
- *Fails.* Two tools with overlapping descriptions → the model picks inconsistently. Anthropic's formulation is sharp: if a human engineer cannot say definitively which tool applies in a given situation, the model cannot be expected to do better (A, Anthropic Engineering, 29 Sep 2025). Descriptions that document parameters but never state *when to use this and not that*.
- *Test.* A disambiguation eval: inputs that sit near the boundary between two tools, asserting the right choice. Adding a tool should trigger this suite.

**C2 — Parameter schema design**
- *What.* The JSON Schema for each tool's arguments.
- *Mechanism.* The schema both constrains decoding (where supported) and instructs the model via field names, descriptions, enums and defaults.
- *When.* Every tool.
- *Fails.* Free-form strings where an enum belongs (the model invents values); deeply nested objects the model fills inconsistently; ambiguous units (`amount` — cents or dollars?) producing correctly-typed, catastrophically wrong calls; dates without a stated format.
- *Test.* Argument-level assertions on a fixture set — not just "called `issue_refund`" but "called it with `amount=4200` in cents".

**C3 — Error messages as model input**
- *What.* Tool failures are returned into the context, so error text is prompt text.
- *Mechanism.* Catch, translate to an actionable message, return as a tool result. `"ERROR: order_id must be 8 digits; you passed '4417'. Call list_orders to find the full ID."` gives the model a recovery path. A stack trace gives it noise.
- *When.* Every tool, every failure path.
- *Fails.* Raw exceptions and 500-page HTML error bodies burning thousands of tokens; errors that do not say what to do next, producing a retry loop with the identical wrong arguments until the step guard fires.
- *Test.* Inject each error class and assert the agent recovers or stops cleanly — never that it loops.

**C4 — Tool granularity and count**
- *What.* How many tools, and how much each one does.
- *Mechanism.* Every tool schema occupies input tokens on **every** call, and every additional tool adds a discrimination decision.
- *When.* Fewer, more powerful tools is the better default. Prefer a tool that matches a *task* the user has over one that matches an *endpoint* you have.
- *Fails.* Measured degradation with tool count. On an MCP stress test, tool-selection accuracy was **13.62%** with all schemas in context versus **43.13%** with retrieval-based selection (B-idx, RAG-MCP, arXiv 2505.03275). Anthropic's deferred-loading approach reports ~77K → ~8.7K tokens of tool definitions (**85% reduction**) and internal MCP-eval accuracy moving 49% → 74% on one model and 79.5% → 88.1% on another (A, Anthropic Engineering, 24 Nov 2025). Widely-circulated specific thresholds ("degrades past 50 tools", "5–7 MCP servers max") are **(C)** — directionally consistent with the above, but unverified; treat them as heuristics, not measurements.
- *Test.* Measure tool-selection accuracy as a function of tool count on your own tool set. The curve is yours, not the paper's.

**C5 — Tool result size and truncation**
- *What.* Deciding how much of a tool's output enters the context.
- *Mechanism.* Truncate, summarise, or return a handle. The handle pattern — return an ID plus a preview, and offer a `read_more(id, offset)` tool — is the just-in-time retrieval idea applied to tool output (A, Anthropic Engineering, 29 Sep 2025).
- *When.* Any tool that can return unbounded output: search, file reads, SQL, HTTP.
- *Fails.* A single `SELECT *` consuming the entire window and evicting the task; naive head-truncation cutting off the answer, which was in the tail; truncation with no marker, so the model believes it saw everything.
- *Test.* Cap-enforcement unit tests; an eval where the needed fact sits past the truncation boundary, asserting the agent fetches more rather than confabulating.

**C6 — Read-only vs side-effecting tools**
- *What.* The classification that drives everything in permissioning, retry and approval.
- *Mechanism.* Tag each tool `read` / `write` / `irreversible` in its registry entry. The harness reads the tag to decide parallelisation, retry safety and approval requirement.
- *When.* Day one. Retrofitting this classification onto a live agent is painful.
- *Fails.* A "read" tool that writes an audit row or increments a counter and is therefore not retry-safe; parallel execution of writes that race.
- *Test.* A registry-completeness test asserting every tool carries a classification; a lint that fails the build when a new tool lacks one.

**C7 — Permissioning, confirmation and dry-run**
- *What.* Bounding what the agent may do, and letting it preview consequences.
- *Mechanism.* Scope credentials per tool, not per agent. Offer `preview=true` variants that return "this would delete 1,204 rows" without deleting. Route `irreversible` tools through the approval gate from B8.
- *When.* Any blast radius larger than a single user's own data.
- *Fails.* One broad service account shared by all tools (see I5); confirmation dialogs showing raw JSON; dry-run that diverges from the real path and so provides false confidence.
- *Test.* An authorisation eval: prompts that try to induce out-of-scope actions, asserting refusal **at the harness layer**, not the model layer. If your only defence is the model declining, you have no defence.

**C8 — Sandboxing and code execution as a tool**
- *What.* Letting the agent write and run code.
- *Mechanism.* Generated code runs in an isolated container/VM with no ambient credentials, a filesystem allowlist, an egress allowlist and CPU/memory/time limits. Output returns as a tool result.
- *When.* Data analysis, transformation, and as the **programmatic tool-calling** pattern: rather than round-tripping every intermediate result through the context, the agent writes code that calls tools and returns only the final answer. Anthropic reports average usage on complex research tasks dropping from 43,588 to 27,297 tokens (**37%**) with this pattern (A, 24 Nov 2025).
- *Fails.* Sandbox escape; network egress enabling exfiltration (I4); resource exhaustion; unbounded stdout flooding context.
- *Test.* A red-team suite of escape attempts; resource-limit tests; assert egress is denied by default.

**C9 — Computer and browser use**
- *What.* Agents that drive a GUI or browser via screenshots and synthetic input.
- *Mechanism.* Screenshot → model → coordinate/keystroke action → screenshot. Every step costs image tokens and a full round trip.
- *When.* Only when no API exists. It is the slowest, most expensive and least reliable tool modality.
- *Fails.* Cost and latency (tens of image-bearing turns for one task); brittleness to UI changes; **page content is untrusted input** — text on a rendered page is an indirect injection vector (I1); destructive misclicks.
- *Test.* Record-and-replay against pinned page fixtures; measure cost per task explicitly; include an injected-page case in the security suite.

**C10 — MCP (Model Context Protocol) and interop**
- *What.* An open client–server protocol standardising how an AI application connects to external tools and data, so an integration is written once rather than once per product.
- *Mechanism.* JSON-RPC 2.0 between a **host** application, its **clients**, and **servers**. Servers expose three primitives: **tools** (model-invocable functions), **resources** (read-only context) and **prompts** (reusable templates). Transports: stdio for local subprocesses and a streamable HTTP transport for remote servers (superseding an earlier dual-endpoint HTTP+SSE model). The spec is dated-revision versioned; search results indicate a **2025-11-25** revision following **2025-06-18** (**A-idx** — `modelcontextprotocol.io` was egress-blocked from this environment; verify directly).
- *When.* When integrations must be reused across multiple hosts, or consumed from an ecosystem. If you have one application and five tools, MCP is indirection with no payoff — just write the functions.
- *Fails.* **Tool bloat** — connecting several servers can consume a large fraction of the window in schemas before any work begins (C for the specific figures circulating; the mechanism and direction are solidly established by C4's evidence). **Supply-chain risk** — a third-party server's tool descriptions are prompt text executing inside your agent's context (I8). Version skew between host and server. Debugging across a process boundary is materially harder.
- *Test.* Contract tests per server; a token-budget assertion on total tool-schema size; an injection test where a server returns hostile content in a tool description **and** in a tool result.
- *Other interop efforts.* An agent-to-agent protocol (A2A) exists and has drawn published security analysis (B-idx, "A2ABreak", arXiv 2609.10871). **This report does not assess its adoption**, because adoption claims in this area are overwhelmingly tier (C). Verify current status before building on any of them.

---

### Cluster D — Context engineering

**D1 — Why context engineering displaced prompt engineering**
- *What.* The shift from "what words are in the prompt" to "what configuration of tokens is in the window at this moment".
- *Mechanism.* In a multi-turn agent, the prompt you wrote is a small and shrinking fraction of the context. The rest is history, tool results, retrieved documents and notes — assembled dynamically by your harness. Anthropic defines the discipline as "the set of strategies for curating and maintaining the optimal set of tokens (information) during LLM inference" (A, 29 Sep 2025).
- *When.* Any agent beyond one turn.
- *Fails.* Teams iterate endlessly on system-prompt wording while the actual problem is a tool returning 40K tokens of JSON on turn three.
- *Test.* Log and inspect the *rendered* context of failing runs. Most "prompt problems" visibly resolve into context problems the moment you look at the real window.

**D2 — Context as a budgeted resource**
- *What.* Explicit allocation of the window across system prompt, tools, history, retrieval and output.
- *Mechanism.* A written budget: e.g. system 2K / tools 6K / history 40K / retrieval 20K / output reserve 8K. The harness enforces each line and degrades gracefully when one is exceeded. The guiding principle: find "the smallest possible set of high-signal tokens that maximize the likelihood of some desired outcome" (A, Anthropic, 29 Sep 2025).
- *When.* Any production agent.
- *Fails.* No budget → one component starves the others, non-deterministically, depending on user input.
- *Test.* Assert per-component token caps in the harness; alert when any component exceeds its allocation in production.

**D3 — System prompt design**
- *What.* The durable instruction block: role, constraints, tool-use policy, output format, escalation rules.
- *Mechanism.* Sits at the front of every request, typically inside the cache prefix (A9). What belongs: stable behavioural rules, the decision policy for tools, safety boundaries, formatting contracts. What does not: anything volatile (timestamps, user IDs, session state — they destroy cache hits), anything retrievable on demand, and long reference material.
- *When.* Always.
- *Fails.* Growth by accretion — every incident adds a rule until the prompt contradicts itself (D5); volatile content thrashing the cache; instructions the model cannot act on because it has no tool for them.
- *Test.* Version the system prompt; require an eval run on every change; keep a regression suite of the specific behaviours each rule was added to fix, so you can find out when a rule stops earning its tokens.

**D4 — Few-shot examples, and when they hurt**
- *What.* Demonstrations of desired behaviour in the prompt.
- *Mechanism.* Examples occupy the prefix and strongly shape output form. Anthropic's guidance: curate "a set of diverse, canonical examples" rather than stuffing a laundry list of edge cases (A, 29 Sep 2025).
- *When.* Unusual output formats, subtle tone or policy requirements, ambiguous classification boundaries.
- *Fails.* Over-anchoring — the model copies example structure onto inputs where it does not fit; example rot as the domain moves; cost, since examples are paid for on every single call; and edge-case collections that teach the model the edge case is the norm.
- *Test.* Ablate. Remove the examples and re-run the eval. Teams are routinely surprised by how often examples cost tokens and buy nothing on current models.

**D5 — Instruction conflict and ordering effects**
- *What.* The model's behaviour when instructions contradict, and the sensitivity of behaviour to where instructions sit.
- *Mechanism.* There is no formal precedence engine. Role separation (system vs user) creates a *soft* hierarchy that models are trained to respect but do not enforce. Position matters — beginning and end of context are attended to more reliably than the middle (B-idx, Liu et al., TACL 2024).
- *When.* Any prompt over a page; any prompt assembled from multiple sources.
- *Fails.* Rule 14 silently overriding rule 3; a rule added at the end of a long prompt being the one that "works" while the same rule in the middle does not — which makes prompt debugging feel like superstition.
- *Test.* Adversarial conflict cases in the eval suite. Also: shuffle-invariance testing — reorder independent prompt sections and check the outcome is stable. If it is not, the prompt is fragile.

**D6 — Context rot and long-context degradation**
- *What.* Performance degradation as input length grows, independent of whether content fits.
- *Mechanism.* Not a hard failure — a gradual decline in reliable retrieval and instruction-following. Chroma's technical report evaluated 18 models and found that models "do not use their context uniformly", with performance growing "increasingly unreliable as input length grows, even on simple tasks", modulated by needle–question similarity, distractors and haystack structure (B, Hong, Troynikov & Huber, Chroma, Jul 2025). Positionally, the middle of a long context is the weak region (B-idx, Liu et al., TACL 2024). Anthropic states the same constraint plainly: as token count increases, accurate recall decreases (A, 29 Sep 2025).
- *When.* Understanding this is mandatory for any long-horizon agent.
- *Fails.* The agent "forgets" an instruction from turn 2 at turn 40; a fact that is provably in context is not used; quality declines smoothly through a long session with no error anywhere.
- *Test.* Run the identical eval at 5K, 50K and 200K input tokens by padding with irrelevant-but-plausible content. The delta is your degradation curve. **Needle-in-a-haystack tests are insufficient** — near-perfect NIAH scores coexist with real degradation on tasks requiring reasoning over the content.

**D7 — Compaction, summarisation and hand-off between windows**
- *What.* Replacing a long history with a shorter representation and continuing.
- *Mechanism.* At a threshold, summarise the conversation and reinitialise with the condensed version plus recent turns verbatim. Anthropic describes preserving "architectural decisions, unresolved bugs, and implementation details while discarding redundant tool outputs" (A, 29 Sep 2025). Note the asymmetry: **tool results compress well; decisions and constraints do not.**
- *When.* Any session that outgrows the window; also as a cost control well before the limit.
- *Fails.* Losing the one detail that mattered; compounding drift across repeated compactions (a summary of a summary of a summary); compaction destroying the cache prefix and spiking cost; the agent repeating work it already did because the record of doing it was compacted away.
- *Test.* Long-horizon evals with a fact introduced early and required late, spanning at least two compaction events. Note that a naive alternative — simply masking old tool observations — has been reported as competitive with LLM summarisation (B-idx, "The Complexity Trap", arXiv 2508.21433), so **measure before building a summarisation pipeline.**

**D8 — Scratchpads and external state**
- *What.* Durable notes the agent writes and re-reads, outside the context window.
- *Mechanism.* A file or table the agent maintains (`NOTES.md`, a todo list, a plan). Survives compaction. Anthropic describes structured note-taking as letting agents "track progress across complex tasks, maintaining critical context and dependencies" (A, 29 Sep 2025).
- *When.* Long-horizon tasks; anything crossing a context boundary; anything a human may need to inspect mid-run.
- *Fails.* Notes that grow without bound and become the context problem they were solving; stale notes contradicting reality; the agent writing notes and never reading them (a surprisingly common no-op that only a trace reveals).
- *Test.* Assert notes are read back after compaction; cap note size; include a case where a note becomes stale and check the agent reconciles.

**D9 — Sub-agent context isolation as a budgeting technique**
- *What.* Giving a sub-task its own fresh window and returning only a summary.
- *Mechanism.* Spawn a call with a narrow prompt and its own tools; the sub-agent burns 50K tokens exploring; the parent receives a condensed distillation — Anthropic cites "often 1,000–2,000 tokens" (A, 29 Sep 2025).
- *When.* Sub-tasks that generate large volumes of intermediate material the parent does not need. **This is the strongest single argument for multi-agent architectures, and it is a budgeting argument, not an intelligence argument.**
- *Fails.* Information loss at the boundary — the parent cannot see what the sub-agent saw, so it cannot tell a confident wrong summary from a right one. Cost multiplication (F5). Sub-agents lacking context needed to judge relevance.
- *Test.* Compare against a single-agent baseline on the same tasks, reporting quality, total tokens **and** latency. If quality is equal, the single agent wins.

---

### Cluster E — Memory and retrieval

**E1 — Short-term vs long-term memory**
- *What.* Short-term = what is in the current window. Long-term = anything persisted across sessions.
- *Mechanism.* Short-term memory is not a feature — it is just the message array. Long-term memory is a database you built plus a retrieval step that injects rows into context. **There is no third thing.** "The agent remembers" always decomposes into "your code wrote something down and later put it back in the prompt."
- *When.* Long-term memory whenever cross-session continuity has real product value — which is less often than it is built.
- *Fails.* Treating "memory" as a capability of the model; unbounded memory growth; retrieval that surfaces stale or wrong memories with full confidence.
- *Test.* Cross-session evals: establish a fact in session 1, require it in session 5. Also test the negative: the agent should *not* apply a memory that no longer holds.

**E2 — Conversation state and session design**
- *What.* What persists between turns and between sessions, and where it lives.
- *Mechanism.* Persist the full message array plus run metadata (model, prompt version, tool versions, token usage). Reconstruct the request each turn from persisted state.
- *When.* Every multi-turn product.
- *Fails.* Storing rendered prompts instead of structured messages, making migration impossible; no session boundary, so one conversation grows for months; PII in session storage with no retention policy (I9).
- *Test.* Round-trip serialisation tests; retention-policy enforcement tests.

**E3 — Embeddings and vector search, and its real failure modes**
- *What.* Mapping text to vectors and retrieving by nearest neighbour.
- *Mechanism.* Embed chunks at index time; embed the query at read time; return top-k by cosine similarity; inject into context.
- *When.* Large unstructured corpora where lexical match is genuinely insufficient, and where paraphrase-heavy queries dominate.
- *Fails.* **Similarity is not relevance** — top-k always returns k things, including when the answer is absent. **No negation** — "contracts without an indemnity clause" retrieves contracts *with* one. **Fixed k** — the right number of documents is not a constant. **Index staleness** — the corpus moved and the index did not. **Domain mismatch** — a general-purpose embedding model on specialised jargon. **Exact identifiers** — error codes, SKUs and function names are exactly what embeddings handle worst.
- *Test.* Retrieval quality measured separately from answer quality: recall@k and MRR on a labelled query set. If you cannot tell whether a failure was retrieval or generation, you cannot fix either.

**E4 — Chunking**
- *What.* Splitting documents into indexable units.
- *Mechanism.* Fixed-size with overlap, or structure-aware (by heading, function, section). Each chunk is embedded independently, so each chunk must be independently meaningful.
- *When.* Any vector index.
- *Fails.* Splitting mid-argument so neither half answers the question; chunks lacking the context that gives them meaning (a table row without its header); code chunking that severs a function from its signature, imports and callers — a specific reason lexical search does well on code (B-idx/A-idx).
- *Test.* Ablate chunking strategies against the same retrieval eval. Chunking choices routinely move retrieval quality more than embedding-model choice does.

**E5 — Hybrid and keyword search**
- *What.* Combining lexical (BM25, grep, regex) with vector retrieval.
- *Mechanism.* Run both, fuse rankings (reciprocal rank fusion is the common default), return the merged set.
- *When.* Almost any corpus with identifiers, names, codes, or exact phrases — which is most real corpora.
- *Fails.* Fusion weights tuned once and never revisited; lexical matches dominating on common words; two systems to keep in sync instead of one.
- *Test.* Report retrieval metrics for lexical-only, vector-only and hybrid on the same query set. Hybrid is usually best, but **lexical-only is a strikingly strong baseline** and is often skipped on the assumption that it is primitive.

**E6 — Reranking**
- *What.* A second-stage model that reorders a candidate set with full query–document attention.
- *Mechanism.* Retrieve top-50 cheaply, rerank to top-5, inject those. The reranker sees query and document jointly, which a bi-encoder embedding never does.
- *When.* When retrieval recall is adequate but precision is not — which is the common case.
- *Fails.* Added latency on the critical path; cost per query; a reranker trained on a different domain hurting rather than helping.
- *Test.* Precision@5 with and without reranking, plus the latency delta. Both numbers or neither.

**E7 — Agentic search vs one-shot RAG, and why grep often wins**
- *What.* Letting the agent search iteratively with tools, versus retrieving once and generating.
- *Mechanism.* One-shot RAG: `query → retrieve → stuff → answer`. Agentic search: the agent issues a search, reads results, refines, reads a file, greps for a symbol, and decides when it has enough. **The agent's loop does the job the ranking function does in RAG — and it can see the actual content before deciding.**
- *When.* Whenever the agent has a loop and the corpus is navigable (a filesystem, a repo, a wiki with links). One-shot RAG remains correct for single-turn Q&A where latency is tight and no loop exists.
- *Evidence.* "Is Grep All You Need? How Agent Harnesses Reshape Agentic Search" evaluates lexical against semantic vector search across a custom harness and three provider CLI harnesses, on a 116-question subset of LongMemEval, under both inline and file-based result delivery — finding that **the harness, not the retriever, dominates outcomes** (B-idx, arXiv 2605.15184). Anthropic has publicly described moving Claude Code away from a local vector index to agentic search (A-idx). The engineering argument is strong independent of any benchmark: **no index to build, no chunking to tune, no embedding pipeline to operate, and no staleness — the agent reads the current state of the files.** The counter-argument is real: grep-style exploration burns tokens, and on very large corpora or with weaker/cheaper models the cost curve flips back toward a precomputed index (C/B-idx).
- *Fails.* Agentic search on a corpus with no structure to navigate; unbounded exploration burning the budget; search tools that return too much (C5).
- *Test.* Head-to-head on your corpus, measuring answer quality, tokens and latency. Report all three. **Do not adopt either as a default on the strength of a blog post — including this one.**

**E8 — Knowledge graphs**
- *What.* Explicit entity–relation structure over a domain.
- *Mechanism.* The agent queries the graph as a tool; results enter as structured facts.
- *When.* Genuinely relational questions — multi-hop traversals, ownership chains, dependency graphs — where the relations are curated and maintained.
- *Fails.* Construction and maintenance cost usually exceeds the benefit; LLM-extracted graphs inherit extraction errors and present them as structure, which is more dangerous than unstructured text because it *looks* authoritative; queries the schema cannot express.
- *Test.* Multi-hop question evals; compare against a plain retrieval baseline before committing to the maintenance burden.

**E9 — Freshness, invalidation, and what must never be written to memory**
- *What.* Keeping stored knowledge correct, and bounding what is stored at all.
- *Mechanism.* Timestamp every memory; carry a TTL; invalidate on source change; prefer reading the source of truth over a cached memory of it.
- *When.* Any long-term memory.
- *Fails.* Confidently stated stale facts — the worst memory failure, because the agent has no way to know the memory is old. Contradictory memories with no resolution rule. **A memory poisoned by injected content persists across sessions and re-enters context on every future run — this is prompt injection with persistence, and it is the most under-appreciated risk in this cluster (I1).**
- *Never write to memory:* secrets and credentials; PII beyond what the retention policy permits; **anything derived from untrusted content without review**; anything you cannot invalidate.
- *Test.* Staleness evals (change the source, assert the agent notices); a memory-poisoning red-team case; an automated scan for secrets in the memory store.

---

### Cluster F — Multi-agent systems

**Read this cluster's conclusion first: a single well-built agent beats a multi-agent architecture in most reported cases.** The conditions under which that flips are narrow and specific, and they are almost always about *context budget* or *parallel breadth*, not about "specialisation".

**F1 — Orchestrator/worker**
- *What.* A lead agent decomposes a task, dispatches workers, and synthesises results.
- *Mechanism.* The lead's context holds the plan and the workers' summaries; each worker has its own window. Anthropic's research system is described as a lead agent planning and spawning 3–5 parallel subagents with a separate citation pass (A-idx, Jun 2025).
- *When.* Breadth-first tasks where independent paths must be explored and the total material exceeds one window — research, broad codebase surveys, competitive analysis.
- *Fails.* Cost. Anthropic reports the multi-agent research system using roughly **15× the tokens of a chat interaction**, and attributes a large share of performance variance to token usage (A-idx, Jun 2025). That multiplier compounds if a worker spawns workers or a tool returns oversized results, and the published architecture is not a drop-in with circuit breakers — you must add per-run caps yourself.
- *Test.* Single-agent baseline on identical tasks. Quality, total cost, wall-clock latency. All three.

**F2 — Pipeline and peer patterns**
- *What.* Sequential specialists (research → draft → review) or peer agents conversing.
- *Mechanism.* Pipeline: each stage's output is the next stage's input — this is a workflow, and should be built as one, with your code controlling the flow. Peer/debate: agents exchange messages in a loop.
- *When.* Pipelines are frequently correct and should not be called multi-agent. Peer patterns have a much weaker case.
- *Fails.* Peer conversations that converge on agreement rather than correctness, or fail to terminate; cost scaling with the square of participants.
- *Test.* Compare against a single agent with the same tools. For debate patterns specifically, demand an effect larger than run-to-run variance (G7) before shipping.

**F3 — Hand-off and state transfer**
- *What.* Moving work from one agent to another.
- *Mechanism.* Either full context transfer (expensive, preserves everything) or a summary (cheap, lossy). There is no third option, and the choice is the design.
- *When.* Any multi-agent topology.
- *Fails.* The receiving agent lacking a constraint the sender knew; hand-off summaries that omit *why* a decision was made, so the receiver undoes it.
- *Test.* Hand-off-specific cases where the critical constraint is established pre-hand-off and must hold post-hand-off.

**F4 — Shared vs isolated context**
- *What.* Whether agents see the same context.
- *Mechanism.* Shared: consistent decisions, but every agent pays for every agent's tokens, so the budget problem returns immediately. Isolated: cheap per agent, but decisions can conflict.
- *When.* Isolate for read-heavy exploration (D9). Share for anything where conflicting decisions are expensive.
- *Fails.* Isolated agents making mutually incompatible changes to the same artefact — the canonical multi-agent failure. Cognition's stated principles are to share as much context as possible and to avoid splitting decision-making in ways that could conflict (B-idx).
- *Test.* Conflict-detection evals: tasks where two agents could plausibly make incompatible choices.

**F5 — Coordination overhead**
- *What.* The cost of agents agreeing.
- *Mechanism.* Every hand-off is model calls and tokens. Every summary is lossy. Every disagreement is more turns. Overhead scales with the number of interaction edges, not the number of agents.
- *When.* Always present; estimate it before adopting the architecture.
- *Fails.* An architecture that is 5× the cost and 3× the latency for a quality gain inside the noise band.
- *Test.* Measure coordination tokens as a distinct line item in your token accounting (H3).

**F6 — The evidence, including negative results**
- **For:** Anthropic reports its multi-agent research system outperforming a single-agent configuration by **90.2%** on an internal research evaluation, at roughly 15× chat token usage, with the economics working only for high-value research (A-idx, Jun 2025). The mechanism is parallel token throughput on breadth-first search — something a single sequential agent structurally cannot do.
- **Against:** Cognition's "Don't Build Multi-Agents" argues from production experience that multi-agent systems are brittle, and advocates sharing context and not splitting decision-making. Their later refinement is the sharpest available rule: **multi-agent systems work best when writes stay single-threaded and additional agents contribute intelligence rather than actions** (B-idx).
- **Reconciliation.** These do not conflict. Anthropic's win is on a *read-only, breadth-first* task with a *single* synthesising writer. Cognition's warning is about *concurrent writers*. Both point at the same rule.
- **Adopt multi-agent when:** the task is breadth-first and read-heavy; sub-tasks are genuinely independent; material exceeds one window; exactly one component writes; and the value per run justifies a multiple of cost.
- **Do not adopt when:** the sub-tasks are sequential; the agents would edit shared state; or the motivation is "specialised agents feel more organised". That last one is an org chart, not an architecture.

---

### Cluster G — Evaluation

*The longest cluster, deliberately. This is where agent engineering is actually hard and where most teams are weakest.*

**G1 — Why non-determinism breaks conventional testing**
- *What.* The same input can produce different outputs, so `assertEqual` does not apply.
- *Mechanism.* Sampling is stochastic; even at temperature 0, batching and hardware effects break byte-equality (A4). Providers also update models under stable aliases.
- *When.* From the first test you write.
- *Fails.* Teams write exact-match tests, watch them flake, and disable them — arriving at zero tests plus the belief that agents cannot be tested.
- *Test.* Assert on *properties*, not strings: was the right tool called, is the schema valid, is the required fact present, is the forbidden action absent, is the cost under budget. Run N trials and assert on the distribution.

**G2 — The eval hierarchy**

| Level | What it asserts | Cost | Speed | Use |
|---|---|---|---|---|
| **Unit** | Tool selection, argument correctness, schema validity, guard behaviour | Very low | Seconds | Every commit |
| **Trajectory** | The *path*: required steps taken, forbidden steps absent, no loops, step count in range | Low | Minutes | Every commit |
| **End-to-end task success** | Final state is correct (DB row right, file correct, answer accurate) | Medium | Minutes–hours | Every PR / nightly |
| **Human review** | Quality, tone, judgement, things you cannot codify | High | Days | Weekly on a sample |
| **Online metrics** | Real users: task completion, escalation rate, thumbs-down, retention | Highest value, slowest signal | Days–weeks | Continuous |

**Build them in that order.** The commonest mistake is starting at LLM-as-judge on end-to-end output, which is expensive, noisy, and diagnoses nothing. Unit-level tool-selection evals cost almost nothing and catch a large share of real regressions.

**G3 — Building a test set from real traces**
- *What.* Deriving eval cases from production runs rather than imagination.
- *Mechanism.* Sample traces (weighted toward failures, escalations and negative feedback), strip PII, freeze inputs and tool responses, label the correct outcome. Replay with recorded tool responses so the eval is hermetic.
- *When.* As soon as you have any production traffic. Before that, write cases from the requirements and expect them to be unrepresentative.
- *Fails.* Cases drawn only from failures, producing a pathological distribution; PII leaking into the eval repo; non-hermetic evals that fail because a live dependency changed.
- *Test.* Every production incident becomes a permanent eval case. That single policy is the highest-value process change most teams can make.

**G4 — Golden datasets and their maintenance cost**
- *What.* A curated input → expected-outcome set.
- *Mechanism.* Expensive to label, expensive to keep correct, and it decays as the product changes.
- *When.* Necessary. Budget for the maintenance explicitly, or it rots into a suite everyone ignores because "those failures are expected".
- *Fails.* Expected outputs that encode obsolete behaviour; the suite becoming a ratchet against intended change; over-fitting the prompt to the golden set until it generalises worse than before.
- *Test.* Hold out a slice never used during iteration. Re-label a sample periodically and measure label drift.

**G5 — LLM-as-judge**
- *What.* Using a model to score outputs against a rubric.
- *Mechanism.* Judge prompt = rubric + (optional reference) + candidate → score plus reasoning. Best practice is a small discrete scale with explicit anchors, not a 1–10 continuum the judge cannot use consistently.
- *When.* Open-ended quality where no programmatic check exists, and only after the cheaper levels in G2 exist.
- *Fails.* **Position bias** (preference for the first-presented response — reported as high as 75% in one audit), **verbosity bias** (longer rated higher independent of quality), **self-preference** (a model favouring its own outputs, reported in the 10–25% range) (B-idx, multiple 2024–2026 audits; the specific magnitudes are study- and model-specific and should not be treated as constants). Also: rubric drift, and judges that reward confident prose over correctness.
- *Test.* Mitigate what you can — randomise position and run both orders (A/B and B/A), control for length, and never let a model judge its own output in a comparison. Then validate (G6).

**G6 — Judge validation and the circularity risk**
- *What.* Establishing that the judge agrees with humans before you trust it.
- *Mechanism.* Label a few hundred examples by hand. Measure agreement (Cohen's κ, or exact agreement) between judge and humans. Also measure human–human agreement — **that is your ceiling.** Published results show strong judges reaching agreement with humans in the range of human–human agreement on some benchmark settings (B-idx), but this **does not transfer** to your domain, rubric or risk level without re-validation.
- *When.* Before any judge score influences a shipping decision.
- *Fails.* **Circularity** — optimising the agent against a judge means optimising against the judge's biases, and your metric improves while the product does not. If the judge shares a model family with the agent, this is worse.
- *Test.* Re-validate against fresh human labels on a schedule. Track judge–human agreement as a first-class metric that can regress. If it drops, every downstream number is suspect.

**G7 — pass@k, pass^k, and variance**
- *What.* Two metrics with opposite meanings, routinely confused.
- *Mechanism.* `pass@k` = at least one of k attempts succeeded (optimistic; appropriate when a human filters candidates). `pass^k` = **all** k attempts succeeded (pessimistic; appropriate when the agent acts unsupervised). τ-bench introduced `pass^k` precisely because customer-service agents need reliability, not best-of-k (B-idx, arXiv 2406.12045). The arithmetic is brutal: at 90% per-trial success, `pass^8 ≈ 0.9^8 ≈ 57%`.
- *When.* Report `pass^k` for any agent that acts without review. Report `pass@k` only where a human genuinely picks from candidates.
- *Fails.* Reporting `pass@1` on a single run as if it were a stable number. A headline "94% success" from one trial per task is not a measurement.
- *Test.* Minimum 5 trials per task. Report mean and standard deviation. **A change smaller than your run-to-run standard deviation is not an improvement**, however good the story.

**G8 — Regression testing across model versions**
- *What.* Detecting behaviour change when the model changes underneath you.
- *Mechanism.* Pin explicit model versions where the provider permits. Run the full eval suite against a candidate before switching. Diff not just scores but *behaviour*: tool-choice distribution, average step count, token usage, refusal rate.
- *When.* Every model upgrade, and continuously if you are on a floating alias.
- *Fails.* Silent behaviour change on a floating alias; a prompt tuned around one model's quirks breaking on the next; an upgrade that improves aggregate quality while doubling step count and cost.
- *Test.* A model-upgrade checklist that gates on quality **and** cost **and** latency **and** tool-choice distribution. Any one regressing is a blocker until explained.

**G9 — Cost and latency as first-class metrics**
- *What.* Treating tokens, dollars and seconds as eval outputs, not operational trivia.
- *Mechanism.* Every eval run emits cost and latency per task alongside quality. Dashboards plot the frontier, not a single number.
- *When.* Always.
- *Fails.* A "quality improvement" that triples cost and ships because nobody measured it. This is the single most common unforced error in agent engineering.
- *Test.* Cost and latency budgets as CI gates, with the same authority as a quality gate.

**G10 — Public benchmarks and their validity problems**
- *What.* Standard agent benchmarks — and why headline numbers mislead.

| Benchmark | Measures | Documented problems |
|---|---|---|
| **SWE-bench / Verified** | Resolving real GitHub issues | SWE-bench+ reported **32.67%** of successful patches involved solution leakage from issue text/comments, and ~31% of passing instances had test suites too weak to catch incomplete fixes (B-idx, arXiv 2410.06992). Zhu et al. report SWE-bench Verified uses insufficient test cases (B-idx, arXiv 2507.02825). |
| **τ-bench / τ²-bench** | Tool–agent–user interaction in service domains; `pass^k` | Zhu et al. report τ-bench counted **empty responses as successful** (B-idx, arXiv 2507.02825). The `pass^k` design is nonetheless the most honest reliability framing in wide use. |
| **GAIA** | 466 human-verified general-assistant questions requiring tools and browsing | At publication, humans scored 92% vs 15% for a then-current model with plugins (B-idx, Mialon et al., arXiv 2311.12983). Later score claims circulate widely at tier (C) and should not be repeated without a verifiable submission. |
| **WebArena / OSWorld** | Self-hosted web and desktop task completion | Broken links and environment drift reported among validity issues (B-idx, arXiv 2507.02825). Reported leaderboard numbers move fast and are frequently quoted without a date. |

  The systemic finding is the important one: **task-setup and reward-design flaws can lead to over- or under-estimation of agent performance by up to 100%** (B-idx, Zhu et al., *Establishing Best Practices for Building Rigorous Agentic Benchmarks*, arXiv 2507.02825), which introduces an Agentic Benchmark Checklist and applies it to ten evaluations. A separate line of work argues validity failures **compound multiplicatively** across an evaluation pipeline (B-idx, arXiv 2608.00794).
- *When.* Useful for tracking the field. **Nearly useless for deciding whether your change helped.**
- *Fails.* Contamination (models trained on the tasks); construct invalidity (a trivial agent passing without the target capability); grader errors awarding credit for wrong answers; harness differences making cross-paper comparison meaningless.
- *Test.* Build a private eval set from your own traces. Treat public benchmarks as weak priors about models, never as evidence about your system.

**G11 — "How do I know my change made it better?" — the practical protocol**
1. Freeze an eval set (≥50 cases; include known failures).
2. Run baseline **5×**. Record mean and standard deviation for quality, cost and latency.
3. Make **one** change.
4. Run **5×** again.
5. If Δquality < 1 SD, you have no evidence of improvement. Say so.
6. If quality improved and cost/latency regressed, state the trade explicitly and let a human decide.
7. Ship, then watch the online metric (G2) that the eval is a proxy for.
8. Add the case that motivated the change to the permanent suite.

That is the whole method. Most disagreements about agent quality dissolve the moment someone runs step 2.

---

### Cluster H — Observability and operations

**H1 — Tracing an agent run**
- *What.* A structured record of everything that happened in one run.
- *Mechanism.* Nested spans: run → each model call (input tokens, output tokens, cached tokens, model version, latency, stop reason) → each tool call (name, arguments, result size, duration, error) → retries. The OpenTelemetry GenAI conventions define span naming as `{gen_ai.operation.name} {gen_ai.request.model}` with operations including `chat`, `embeddings`, `execute_tool`, `invoke_agent` and `retrieval` (A, verified at semantic-conventions v1.41.0, 2026-09-24). **Status matters: every `gen_ai.*` attribute and span carried the "Development" (pre-stable) badge.** Adopt the naming for portability; do not assume stability. An opt-in environment variable (`OTEL_SEMCONV_STABILITY_OPT_IN`) exists precisely because the conventions move.
- *When.* Before your first production user. Retrofitting tracing is far more expensive than building it in.
- *Fails.* Logging only the final answer, which makes every failure unexplainable; traces without token counts, making cost attribution impossible; traces so verbose nobody opens them.
- *Test.* Assert trace completeness in integration tests — every model call and tool call produces a span with required attributes.

**H2 — What to log, and what must never be logged**
- *Log:* run and session IDs, model and prompt versions, tool names and durations, token counts by type (input / output / cache-read / cache-write), stop reasons, error classes, guard activations, approval decisions.
- *Never log:* secrets and credentials; raw PII beyond policy; full document contents from regulated corpora; anything you cannot delete on a subject-access request.
- *Mechanism.* Redact at the point of capture, not at display time. A redaction layer that runs at query time still means the secret is at rest in your log store.
- *Fails.* Prompts containing customer PII sitting in a third-party observability SaaS with no DPA; API keys captured in tool arguments; the *model's own output* echoing a secret it read from a tool result.
- *Test.* Automated secret and PII scanning over a sample of stored traces, running as a scheduled job with alerting.

**H3 — Token accounting and cost attribution**
- *What.* Knowing what each run, feature, customer and tool costs.
- *Mechanism.* Sum tokens per category from every model call, multiply by the current per-category rate, attribute to a run ID carrying feature and tenant tags. Cache-read and cache-write tokens are billed at different rates and **must be tracked separately** (A9).
- *When.* From day one. Cost surprises in this field are step functions, not gradients.
- *Fails.* A single aggregate spend number with no attribution, so nobody can find the runaway; missing the tool-schema tokens that are paid on every turn; not noticing a cache hit-rate collapse.
- *Test.* Reconcile your computed cost against the provider invoice monthly. A persistent gap means your accounting is wrong.

**H4 — Latency budgets and where time actually goes**
- *What.* An explicit end-to-end target, decomposed.
- *Mechanism.* Typical decomposition: time-to-first-token, generation time (proportional to output tokens), tool execution, retries, harness overhead. Multiply by step count. A 6-step agent with 3-second model calls and 1-second tools is 24 seconds before anything goes wrong.
- *When.* Any interactive surface.
- *Fails.* Blaming the model when a slow tool dominates; serial execution of independent tool calls (J6); retries silently doubling p99.
- *Test.* Latency breakdown per span in the trace; p50/p95/p99 tracked per component, not just end to end.

**H5 — Debugging from a trace rather than from a reproduction**
- *What.* The distinctive operational skill of this role.
- *Mechanism.* You usually cannot reproduce — the model is stochastic and the world has moved. So you read the trace and ask, in order: (1) What was actually in the context at the failing turn? (2) Was the needed information present at all? (3) If present, was it in a position or form the model could use? (4) Was the tool description adequate for the choice it needed to make? (5) Did an error message point anywhere useful?
- *When.* Every failure investigation.
- *Fails.* Engineers reflexively editing the system prompt without reading the rendered context. The overwhelming majority of "the model is dumb" reports resolve into "the information was not in the window", "it was in the window at position 60K", or "the tool description was ambiguous".
- *Test.* Not a test — a practice. Trace-reading should be a standard part of code review for agent changes.

**H6 — Failure taxonomy**

| Failure | Observed symptom | Usual root cause | First move |
|---|---|---|---|
| Hallucinated tool arguments | Tool rejects input; wrong entity acted on | Weak schema; ambiguous units; missing enum | C2 |
| Wrong tool selected | Plausible but useless action | Overlapping descriptions; too many tools | C1, C4 |
| Loop | Same call repeated to the guard limit | Uninformative error message; no state change | C3, B7 |
| Premature stop | Partial answer presented as complete | Weak stopping criteria; max-tokens truncation | A6 |
| Context overflow | Hard API error, or silent quality decline | No budget enforcement; oversized tool results | C5, D2 |
| Context degradation | "Forgets" earlier instructions late in a long run | Context rot | D6, D7 |
| Tool error cascade | One failure derails the whole run | Errors not returned as actionable model input | C3 |
| Refusal | Agent declines a legitimate task | Over-broad safety instruction; ambiguous phrasing | D3 |
| Truncation | Malformed JSON; half-written file | max-tokens hit, stop reason ignored | A6 |
| Injection | Agent takes an action nobody asked for | Untrusted content in context | Cluster I |
| Cost spike | Invoice anomaly with no quality change | Cache invalidation; retry storm; sub-agent recursion | A9, F1, J8 |

**H7 — Versioning prompts, tools and model choice together**
- *What.* Treating the (prompt, tool schemas, model version) triple as one deployable unit.
- *Mechanism.* Version the triple; stamp every run with it; make eval results addressable by it. Changing any one of the three changes behaviour.
- *When.* Always.
- *Fails.* A prompt edit deployed without an eval run; a tool schema change invalidating the entire prompt cache (A9) with no one connecting the cost spike to the deploy; inability to answer "what configuration produced this bad run?".
- *Test.* Assert that every trace carries the full version triple; block deploys where the triple changed without an eval run.

**H8 — Rollout, rollback, and on-call**
- *What.* Shipping behaviour changes safely.
- *Mechanism.* Prompt and tool changes are **code changes** and belong in the same pipeline: review, eval gate, canary on a traffic slice, monitor quality/cost/latency/refusal-rate, roll back by reverting the version triple. Keep the previous triple warm so rollback is a config flip, not a redeploy.
- *When.* Any production agent.
- *Fails.* Prompts edited in a web console with no version control (still distressingly common); no rollback path; on-call engineers with no runbook for "the agent is doing something weird" — which is a different alarm from "the service is down" and needs different instrumentation.
- *Test.* Practise a rollback. Alert on: error rate, p95 latency, cost per run, refusal rate, guard-activation rate, and cache hit rate. The last three are agent-specific and are the ones teams forget.

---

### Cluster I — Security and safety

**Framing.** This content is defensive. Mechanisms are described at the level needed to build controls. No payloads or evasion techniques are provided.

**I1 — Prompt injection: direct and indirect**
- *What.* Attacker-controlled text in the context causes the model to take instructions from the attacker.
- *Mechanism.* **The model has one channel for instructions and data.** Role separation is a training-time convention, not an enforced boundary. *Direct* injection: the user types the hostile instruction. *Indirect* injection: hostile text arrives through a document, web page, email, code comment, tool result, or an MCP server's tool description — content the user never saw and the operator never reviewed. It is #1 on the OWASP Top 10 for LLM Applications for the second consecutive edition (B/C-idx, OWASP 2025).
- *When.* Any agent that reads content it did not author. That is effectively all useful agents.
- *Fails.* **State plainly: there is no complete mitigation.** Filters, classifiers, delimiters, spotlighting and instruction-hierarchy training all raise the cost of an attack; none makes it impossible, because the defence is trying to classify natural language that the model itself must interpret. Treating any of them as a solution is the dangerous failure. The honest posture is **architectural containment** (I2) plus assumption of eventual compromise.
- *Test.* A maintained injection corpus run in CI: injected content in each ingestion path (document, page, tool result, memory, image, tool *description*). Assert the **harness** blocks the resulting action, not that the model declines.

**I2 — The lethal trifecta**
- *What.* The condition under which injection becomes data theft: **private data + untrusted content + an outbound communication channel**, all reachable in one execution path (B, Simon Willison, 16 Jun 2025).
- *Mechanism.* Any two are survivable. All three mean attacker text can instruct the agent to read your data and send it out.
- *When.* Design-review every agent against it.
- *Fails.* Teams evaluate tools one at a time and never notice the combination. Outbound channels are also easy to miss: a URL the agent renders, an image the client fetches, a webhook, an error-reporting endpoint, a DNS lookup, a "share" tool.
- *Test.* A documented capability audit: classify every tool against the three legs and prove that at least one leg is absent from every path. Make it a merge gate when a new tool is added — that is the moment a safe agent silently becomes unsafe.

**I3 — Tool output as an untrusted input surface**
- *What.* Everything a tool returns is attacker-influenceable in general.
- *Mechanism.* A web fetch returns page text; a database returns a user-supplied field; a file read returns a file someone uploaded; an MCP server returns whatever it wants. All of it lands in the context with the same standing as your system prompt.
- *When.* Every tool that touches data you did not write.
- *Fails.* Treating "internal" tools as trusted. A support ticket body is user-controlled; a code comment is contributor-controlled; a CRM note is whatever a customer typed.
- *Test.* Injected payloads in each tool's return path, asserting no privileged action follows.

**I4 — Data exfiltration channels**
- *What.* The mechanisms by which data leaves.
- *Mechanism.* Rendered markdown images and links with data in the URL (the client fetches them, so the agent never "sends" anything); outbound HTTP from a tool or sandbox; email/webhook/message tools; DNS resolution; writing to a shared location an attacker can read; error reporting with payloads attached.
- *When.* Enumerate them for every agent. They are a superset of "tools that obviously send things".
- *Fails.* Blocking the obvious `send_email` tool while markdown image rendering quietly does the same job.
- *Test.* Egress allowlisting in the sandbox; content-security policy on rendered output; strip or proxy external references in model output before rendering; assert in tests that a rendered response cannot trigger an arbitrary outbound fetch.

**I5 — Confused deputy and credential scope**
- *What.* The agent acting with more authority than the requesting user has.
- *Mechanism.* The agent holds a service credential. A user asks for something; the agent uses its own authority, not the user's. Classic confused deputy.
- *When.* Any multi-tenant or multi-role system.
- *Fails.* One broad service account for all tools; authorisation checked in the prompt ("only show the user their own orders") rather than in the tool; tenant isolation that depends on the model passing the right ID.
- *Test.* Per-tenant authorisation tests where the *tool* rejects out-of-scope requests regardless of what the model asked for. **Authorisation belongs in the tool implementation. A model is not an access-control system.**

**I6 — Sandboxing and least privilege**
- *What.* Bounding what the agent can reach.
- *Mechanism.* Per-tool credentials with minimal scope; network egress allowlists; filesystem allowlists; ephemeral containers; no ambient cloud credentials in the execution environment.
- *When.* Always; strictly required for code execution and browser use.
- *Fails.* Cloud instance metadata reachable from the sandbox; a "read-only" database credential that can read every tenant; an allowlisted domain that proxies arbitrary requests.
- *Test.* Escape and privilege-escalation red-team suite, re-run on every infrastructure change.

**I7 — Approval gates and irreversible actions**
- *What.* Requiring human authorisation for actions that cannot be undone.
- *Mechanism.* The three-tier model from B8: auto-approve reversible reads; notify-and-allow-undo for recoverable writes; hard-block pending explicit approval for irreversible actions. At the gate, show **what** action, **why**, **what changes**, and **how to undo** — not a tool name and a JSON blob.
- *When.* Money movement, deletion, external communication, production configuration, anything with legal effect.
- *Fails.* Approval fatigue — too many prompts produce reflexive approval, which is worse than no gate because it creates a false audit trail of "human-reviewed" actions. Gates that can be bypassed by the model rephrasing the request. Research has specifically examined whether framework control primitives actually enforce stops (B-idx, arXiv 2607.14166) — **verify your framework's stop actually stops.**
- *Test.* Assert that an irreversible tool cannot execute without a recorded approval token, enforced in the tool layer.

**I8 — Supply-chain risk in third-party tools and MCP servers**
- *What.* Third-party tool servers are code you run and prompt text you execute.
- *Mechanism.* A server's tool *descriptions* enter your context — hostile text there is injection with high privilege, because it looks like system-level instruction. Server *results* are untrusted input (I3). The server binary itself may execute arbitrary code locally. Servers can update without notice.
- *When.* Every third-party server, and every internal one you did not review.
- *Fails.* Installing servers because they are convenient; no pinning; no review of description text; no monitoring of what the server actually does.
- *Test.* Pin versions; review tool descriptions as you would review a system prompt (because it is one); run servers with least privilege; diff descriptions on upgrade and gate the diff on review.

**I9 — Secrets, PII and data residency**
- *What.* Handling regulated and sensitive data in a system that logs everything by default.
- *Mechanism.* Secrets never enter the context — the tool holds the credential and the model passes a reference. PII is minimised before it reaches the prompt and redacted before it reaches logs. Residency constraints determine which provider regions and which observability vendors are usable at all.
- *When.* Any regulated domain; in practice, any consumer product.
- *Fails.* Credentials in tool arguments; PII in traces shipped to a third-party SaaS; a memory store that accumulates PII with no retention policy; a provider region that does not match your commitments.
- *Test.* Automated scanning of prompts and traces; documented data-flow diagram; retention enforcement tests.

**I10 — Jailbreaks vs injections; standards and compliance**
- *What.* Two different problems, constantly conflated.
- *Mechanism.* A **jailbreak** is the *user* trying to make the model violate its own policy — the user is the adversary, and they are attacking the model's training. An **injection** is a *third party* making the agent act against the user's and operator's interests — the user is the victim, and the adversary is attacking your architecture. Different threat actors, different defences, different severity.
- *When.* Threat modelling. Conflating them leads to the error of buying a jailbreak classifier and believing you have addressed injection.
- *Standards.* OWASP's Top 10 for LLM Applications 2025 keeps prompt injection at #1 and adds categories reflecting agentic use (B/C-idx; `genai.owasp.org` was egress-blocked, the PDF is hosted on `owasp.org`). An OWASP Top 10 for Agentic Applications was reported as announced at Black Hat Europe 2025 (**C-idx — verify before citing in a compliance document**). NIST published **AI 600-1**, the Generative AI Profile of the AI RMF, on **26 July 2024**, mapping GOVERN/MAP/MEASURE/MANAGE to generative-AI risk categories (B-idx). Reports of further NIST agent-specific work in 2026 appeared in search results but **could not be verified from a primary source here and should not be cited without checking nist.gov directly.**
- *Test.* Separate suites for the two threats. Track them as separate metrics. Map controls to a named framework if you have compliance obligations — auditors want the mapping, and building it retroactively is expensive.

---

### Cluster J — Cost, latency and scale

**J1 — The arithmetic of an agent run**
- *What.* Computing what a run costs before you are surprised by it.
- *Mechanism.* Per turn: (system + tool schemas + full history + new tool results) input tokens, plus output tokens, plus reasoning tokens where applicable. Sum across turns. Because history is re-sent every turn, the input cost of turn *n* includes everything from turns 1..*n*−1.
- *When.* At design time, before writing code.
- *Fails.* Estimating from a single-turn cost and multiplying by turns — which understates by a large factor. Forgetting tool schemas are paid every turn.
- *Test.* A cost model in a spreadsheet, validated against a real run's token counts. If the model is off by more than ~20%, something in your architecture is not what you think it is.

**J2 — Why cost scales super-linearly with turns**
- *What.* The core cost dynamic of agents.
- *Mechanism.* With a roughly constant per-turn addition to history, cumulative input tokens across *n* turns grow with *n*² rather than *n*. A 20-turn run is not twice a 10-turn run — it is closer to four times, before caching.
- *When.* Every multi-turn agent.
- *Fails.* Budgets built on linear assumptions; a prompt change that adds two turns on average and quietly adds far more than 20% to the bill.
- *Test.* Plot cost against turn count from real traces and confirm the shape. Alert on mean turn count as a leading indicator of cost.

**J3 — Prompt caching and context reuse**
- *What.* The main structural lever against J2.
- *Mechanism.* Keep a large stable prefix (system + tools + early history) and mark a breakpoint so repeated turns read it at the cache rate. Architecturally this means: **stable content first, volatile content last, never a timestamp near the top.** Point-in-time rates in A9.
- *When.* Every agent with a stable prefix.
- *Fails.* Cache thrash from volatile prefix content; TTL expiry on slow conversations; tool-schema changes invalidating everything (A9); appending to the middle of the message array.
- *Test.* Cache hit rate as a monitored metric with an alert. It is a cost metric with no quality signal, so nothing else will catch its regression.

**J4 — Model routing and cascades**
- *What.* Send easy work to a cheap model; escalate the rest.
- *Mechanism.* A classifier or heuristic picks a model per request, or a small model answers first and a verifier decides whether to escalate. Published results include RouteLLM and FrugalGPT reporting large cost reductions at near-frontier quality (B-idx; **the specific percentages circulate widely at tier (C) and are benchmark- and workload-specific — do not quote them for your workload**).
- *When.* High volume with a wide difficulty distribution; clearly separable sub-tasks (routing, extraction, classification) that do not need the frontier model.
- *Fails.* **Self-reported model confidence is poorly calibrated** — a model can be fluent, confident and wrong, which makes confidence-threshold escalation unreliable (B-idx). Routing errors concentrating in exactly the hard cases. Two models to evaluate, prompt and version instead of one. Escalation logic that costs more than it saves.
- *Test.* Per-route quality evals, not just aggregate. The aggregate can look fine while the cheap route fails badly on a small, important slice.

**J5 — Streaming for perceived latency**
- *What.* Reducing felt latency without reducing real latency.
- *Mechanism.* Time-to-first-token is what users experience as responsiveness. Streaming the model's text, and streaming *tool-call status* ("searching…", "reading 3 files…"), converts dead time into visible progress.
- *When.* Every interactive surface.
- *Fails.* Streaming that shows an answer the agent then contradicts after a tool call; no progress indication during long tool executions, which is where the real dead time is.
- *Test.* Measure time-to-first-token separately from total latency and track both.

**J6 — Parallel tool execution**
- *What.* Executing independent tool calls concurrently.
- *Mechanism.* When a turn emits multiple tool calls, dispatch them concurrently and assemble results in the order the API requires. Latency becomes max() rather than sum().
- *When.* Any turn with multiple read-only calls.
- *Fails.* Parallelising writes that race; ordering assumptions broken; error handling that fails the whole batch when one call fails; unbounded concurrency hitting rate limits (J8).
- *Test.* Assert independent calls run concurrently; assert write-classified tools (C6) are serialised.

**J7 — Batching and offline queues**
- *What.* Moving non-interactive work off the interactive path.
- *Mechanism.* Batch APIs for evals and bulk processing (A10); job queues for long agent runs with results delivered asynchronously.
- *When.* Evals, backfills, scheduled analysis, any run longer than a user will wait.
- *Fails.* Running the eval suite through the interactive API at full price; holding an HTTP connection open for a ten-minute agent run.
- *Test.* A cost review of what runs where.

**J8 — Rate limits, backoff and quota management**
- *What.* Operating inside provider limits.
- *Mechanism.* Limits apply to requests and to tokens per minute, usually separately. Respect retry-after headers; exponential backoff with jitter; a client-side concurrency limiter so you shed load before the provider does.
- *When.* Any production traffic.
- *Fails.* Retry storms amplifying an incident; one noisy tenant consuming the org quota; parallel sub-agents (F1) multiplying request rate in a burst.
- *Test.* Load tests that deliberately hit the limit and assert graceful degradation rather than cascading failure.

**J9 — Self-hosting and open weights**
- *What.* Running models yourself instead of calling an API.
- *Mechanism.* Serving runtime, GPU capacity, quantisation choices, autoscaling, on-call for inference.
- *When.* Genuine data-residency prohibitions on external providers; very high sustained volume on a narrow task; hard latency requirements a provider cannot meet.
- *Fails.* Underestimating total cost — GPUs are billed while idle, so utilisation dominates economics; capability gap against frontier hosted models on agentic tasks specifically (tool use and long-horizon coherence are where open-weight models have historically lagged most); an inference on-call rotation you did not budget for; a fine-tune that pins you to a base model the field moves past.
- *Test.* A real total-cost-of-ownership comparison including engineering time and idle capacity, plus a capability eval on **your** agentic tasks, not on general benchmarks.

---

### Cluster K — Product and interface

**K1 — Designing for a system that is wrong sometimes**
- *What.* Product design that assumes a non-trivial error rate.
- *Mechanism.* Every surface answers: how does the user notice an error, how do they correct it, and what does an error cost them? Reversibility is a product feature.
- *When.* Always. An agent with 95% task success fails one interaction in twenty — visibly.
- *Fails.* UI that presents output as authoritative with no correction affordance; irreversible actions with no undo; error states designed only for system failures, not for confident wrong answers.
- *Test.* Usability testing **on failure cases specifically**. Most teams only demo the happy path, which is also how most teams ship an agent nobody trusts.

**K2 — Showing work and intermediate state**
- *What.* Surfacing what the agent is doing as it does it.
- *Mechanism.* Stream tool activity in human terms ("searching orders", "reading contract.pdf"), not raw tool names and JSON.
- *When.* Any run over a few seconds.
- *Fails.* A spinner for 40 seconds (users abandon); raw traces dumped at users (noise); showing reasoning that contradicts the final answer, which destroys trust faster than a plain wrong answer.
- *Test.* Abandonment rate by run duration; comprehension testing of the progress language.

**K3 — Trust calibration and honest uncertainty**
- *What.* Making user trust track actual reliability.
- *Mechanism.* Cite sources so claims are checkable; distinguish retrieved fact from inference; escalate rather than guess when the agent is outside its envelope.
- *When.* Any consequential output.
- *Fails.* Uniform confident tone regardless of grounding — the single largest driver of misplaced trust. Note the hard constraint: **model-reported confidence is poorly calibrated (J4)**, so "the model says it is 80% sure" is not a usable uncertainty signal. Prefer structural signals: did retrieval return anything, did the tool succeed, is this within the tested envelope.
- *Test.* Measure whether users catch errors. If they do not, your interface is over-selling.

**K4 — Permission and confirmation UX**
- *What.* Making approval gates (I7) usable.
- *Mechanism.* Show the consequence in domain language ("refund $42.00 to Jane Doe, order 4417"), not the mechanism (`issue_refund({"id":"4417","amount":4200})`). Batch related approvals. Remember durable preferences.
- *When.* Every gate.
- *Fails.* Approval fatigue; gates on reversible actions (noise that trains users to click through); no batching, so a ten-file edit becomes ten dialogs.
- *Test.* Measure approval-dialog dwell time. Sub-second approvals mean nobody is reading, which means the gate is decorative.

**K5 — Interruption and steering**
- *What.* Letting users redirect a running agent.
- *Mechanism.* A stop control that actually stops (and does not leave a tool half-executed — B9), plus the ability to inject a correction and continue from current state rather than restarting.
- *When.* Any long-running agent.
- *Fails.* No stop button; a stop that abandons state so the user loses the work; correction requiring a full restart.
- *Test.* Interrupt at each step boundary; assert clean state and correct resume.

**K6 — Latency perception**
- *What.* Managing felt time.
- *Mechanism.* Fast acknowledgement, streamed progress (K2), realistic expectations set up front ("this usually takes about a minute"), asynchronous delivery for genuinely long runs.
- *When.* Anything over ~2 seconds.
- *Fails.* Silent waits; progress indicators that stall at 90%; synchronous UX for a five-minute task.
- *Test.* Abandonment by duration bucket; satisfaction against perceived rather than measured wait.

**K7 — When an agent is the wrong product shape**
- *What.* Recognising that a deterministic feature is better.
- *Mechanism.* If the task has a known procedure, a stable input format, and a correctness criterion you can express in code, **write the code.** It is cheaper, faster, testable, auditable, and right every time.
- *When.* Far more often than the current market assumes.
- *Fails.* An agent built for a task a form and three API calls would do — inheriting non-determinism, cost, latency and an injection surface as pure downside. The reverse error also exists: a rigid workflow for genuinely open-ended work, producing endless special-case branches.
- *Test.* Before building: can you write the acceptance test as a deterministic assertion? If yes, you may not need a model in the loop at all. Say so out loud — a recommendation of "don't build this agent" is a legitimate engineering outcome, and often the most valuable thing an experienced agent engineer contributes.

---

## Part 4 — The stack, surveyed honestly

### 4.1 Comparison

Maturity and feature claims below are **(C) unless marked**, because framework capabilities change faster than any report can track. Treat the *columns* as the evaluation criteria and re-fill the cells yourself.

| Approach | What it actually gives you | What it hides | Lock-in | Debuggability | When to choose |
|---|---|---|---|---|---|
| **Raw provider SDK / HTTP** | Nothing but the API. You write the loop (B1). | Nothing. | Low (one provider's message format) | **Highest** — you can print the exact request | Learning; most production agents; anything where you need to know exactly what is in the window |
| **Provider agent SDKs** | Loop, tool dispatch, handoffs, tracing, session state | The loop and the prompt assembly | Medium–high | Medium | You are committed to one provider and want their conventions |
| **Graph orchestration (LangGraph and similar)** | Explicit state graph, cycles, checkpointing, interrupts, streaming | Prompt assembly, retry semantics, sometimes the message array | Medium — your logic becomes graph nodes | Medium; better than chain-style abstractions | Complex branching state machines; teams that want the control flow to be an inspectable artefact |
| **Role/crew frameworks (CrewAI, Autogen-style)** | Fast multi-agent prototyping via roles and tasks | Almost everything: prompts, loop, context assembly | High | **Lowest** — failures are hard to attribute | Prototypes and demos. Be very cautious about production, given Cluster F |
| **Typed agent libraries (Pydantic AI and similar)** | Validated structured I/O, dependency injection, typed tools | Modest — thin over the API | Low–medium | High | Python teams who want type safety around structured output without a heavy runtime |
| **Durable execution engines (Temporal-style)** | **Execution** that survives process death, retries, timers, long-running lifecycle, exactly-once activity semantics | Distributed-systems complexity, at real operational cost | Medium–high (a new runtime to operate) | High for the workflow; orthogonal to the model call | Long-running agents, irreversible side effects, multi-day human-in-the-loop (B9) |
| **Eval/observability tooling (LangSmith, Braintrust, Langfuse, Phoenix, …)** | Trace storage, eval runners, dataset management, judge tooling, diffing | Little — mostly additive | Low–medium (your traces live there) | N/A — this *is* the debuggability layer | **Adopt something early.** This is the category most worth buying rather than building |

Two structural points that outlast any particular tool:

1. **Checkpointing is not durable execution.** A graph library that persists state still dies with its process; something outside must detect the failure and re-enter (B, engineering write-ups, 2026). If your agent must survive a deploy, you need a durable runtime or you need to build one.
2. **The eval/observability row is the one to buy.** The orchestration rows are things you can write; the trace store, dataset manager and eval runner are not, and building them badly is how teams end up without evals at all.

### 4.2 The case for no framework

Anthropic's own guidance is to start with direct API calls, noting that frameworks add abstraction layers that obscure prompts and responses, make debugging harder, and tempt developers toward unnecessary complexity (A, 19 Dec 2024).

The worked example is B1 above. That is a complete, correct agent loop in about 20 lines. Add to it:

| Addition | Approximate size |
|---|---|
| Tool registry with schemas and read/write classification (C6) | ~30 lines |
| Truncation with a `read_more` handle (C5) | ~25 lines |
| Structured error mapping (C3) | ~20 lines |
| Token accounting and tracing hooks (H1, H3) | ~40 lines |
| Budget guards: steps, tokens, wall-clock, money (B7) | ~20 lines |
| Approval gate with persisted pending state (B8) | ~50 lines |
| Compaction at a threshold (D7) | ~40 lines |

**Roughly 250 lines of ordinary Python or TypeScript is a production-shaped agent harness.** Every one of those lines corresponds to a concept in Part 3 that you will otherwise have to learn through a framework's abstraction of it. That is the real argument: not that frameworks are bad, but that the concepts are the durable asset and writing the harness once is the cheapest way to own them.

Adopt a framework when you hit something genuinely infrastructural — durable execution, distributed workers, a state machine too complex to read as code — not because "everyone uses one".

### 4.3 Vector stores, serving runtimes and gateways — enough to choose

**Vector stores.** The decision tree is short. Already on Postgres and under ~10M vectors → use `pgvector` and stop. Need hybrid lexical+vector with filtering at scale → a dedicated search engine or a managed vector database. Prototyping locally → an embedded library. **First, apply E7 and ask whether you need a vector index at all.** The most common over-engineering in this field is a vector database serving a corpus that `ripgrep` handles better.

**Serving runtimes** (only if self-hosting, J9). The choice is a throughput-vs-simplicity trade; the questions that matter are continuous batching, quantisation support, tool-calling and structured-output support, and whether the project's release cadence matches your model upgrade cadence.

**Gateways / proxies.** A single ingress in front of multiple providers gives you: one place for keys, per-tenant rate limits and budgets, retries and failover, a cache, and unified logging. The cost is a hop of latency and a component that can fail. For anything multi-provider or multi-tenant, it usually earns its place; for a single-provider single-tenant service, it is premature.

### 4.4 How to evaluate a new tool in this space in a week

Given the churn rate, a fixed protocol beats reading reviews.

| Day | Activity | Kill criterion |
|---|---|---|
| 1 | Read the source of the core loop. Can you find where the HTTP request is assembled? | If you cannot, in under 30 minutes, **stop**. You will not be able to debug it. |
| 2 | Port one real, non-trivial agent you already have. | If a real requirement needs an escape hatch on day one, note it — it will recur. |
| 3 | Break it deliberately: tool error, timeout, context overflow, mid-stream disconnect. | If failures produce unattributable stack traces, stop. |
| 4 | Run your existing eval suite through it. Compare quality, cost, latency to your baseline. | Any unexplained cost delta is a red flag — it means the framework is changing your prompt. |
| 5 | Check the exits: can you print the exact request it sends? Can you leave without rewriting your tools? | If the answer to either is no, the lock-in is higher than advertised. |

**Signals to weight:** number of open issues about *debugging* specifically; whether the changelog has breaking changes every minor release; whether the maintainers publish their own production usage. **Signals to ignore:** GitHub stars, download counts, benchmark charts in the README, and the length of the integrations list.

---

## Part 5 — The learning path

### 5.1 Staged plan

Each stage has a **falsifiable check** — something you either can or cannot do. No stage is complete because you read about it.

| Stage | Understand | Build | Check (falsifiable) |
|---|---|---|---|
| **0. Foundations** | Tokens, context window, message roles, sampling, stop reasons (A1–A6) | A token counter and a raw HTTP call with no SDK | Predict the token count and cost of a request to within 10% before sending it |
| **1. First agent, no framework** | The loop, guards, stop conditions (B1, B7) | The 20-line loop with two tools, by hand | Draw the exact message array after three turns from memory, and explain every field |
| **2. Tools and structured output** | Descriptions as prompts, schemas, errors as input, truncation (C1–C5, A7, A8) | 6–8 tools with real APIs, typed errors, truncation with `read_more` | Add a 9th tool and show tool-selection accuracy did not drop (you have a test that would catch it) |
| **3. Evaluation** | Non-determinism, the eval hierarchy, variance, judges (G1–G7) | 50-case eval set; unit + trajectory + E2E levels; 5-trial protocol | Run G11's protocol and correctly conclude "no evidence of improvement" on a change you were excited about |
| **4. Retrieval and memory** | Retrieval failure modes, agentic vs one-shot, memory hygiene (E1–E9) | Both a vector pipeline **and** a lexical/agentic search over the same corpus | Report recall@k, cost and latency for both, and defend your choice with your own numbers |
| **5. Context engineering** | Budgeting, compaction, context rot (D1–D9) | Compaction with a scratchpad, surviving a task that exceeds the window twice | Run a task spanning two compactions where a fact from the first window is required in the third |
| **6. Production concerns** | Tracing, cost attribution, failure taxonomy, versioning, rollback (H1–H8) | Full tracing, cost per run, a version triple, a canary + rollback path | Take a failing production trace and diagnose the root cause without reproducing it |
| **7. Security** | Injection, the trifecta, scopes, approvals (I1–I10) | Trifecta audit of your own agent; injection suite in CI; per-tool credentials; approval gate | Write the capability audit and prove at least one leg of the trifecta is absent on every path |
| **8. Scale** | Cost curve, caching, routing, parallelism, limits (J1–J9) | Caching with a monitored hit rate; parallel tools; a cascade | Cut cost per run by ≥50% with no quality regression outside the noise band, and show the numbers |

### 5.2 Project ladder

Eight projects, in order. Each is buildable by one person. **The point of each is the failure it forces you to meet.**

| # | Project | Learning objective | Acceptance test | The failure it is designed to teach |
|---|---|---|---|---|
| **1** | **Bare loop, two tools.** CLI agent with `get_weather` and `calculate`. No SDK helpers, no framework — raw HTTP. | The message array and the loop | Handles a 3-step task; terminates on no-tool-call and on max-steps; prints the full request on demand | Orphaned tool-call IDs, and discovering that *you* are the thing executing tools |
| **2** | **Tool-heavy agent.** 8 tools over a real API (GitHub, a ticket system, your own service) with typed errors and truncation. | Tool description craft, schema design, error-as-input | A disambiguation suite over boundary cases passes; every tool has a classification and an error-path test | The model picking the wrong tool because two descriptions overlap — and the fix being prose, not code |
| **3** | **Eval harness.** 50 cases over project 2, at unit + trajectory + E2E levels, with the 5-trial protocol. | That evaluation is the job | Produces mean ± SD for quality, cost and latency; CI-runnable; you can answer "did this help?" | Watching a "clearly better" prompt change land inside the noise band |
| **4** | **Retrieval bake-off.** Same corpus, two systems: chunked vector RAG, and agentic lexical search with file reads. | Retrieval failure modes and E7 | recall@k, answer accuracy, cost and latency reported for both; a written recommendation | Vector search confidently returning top-k when the answer is not in the corpus at all |
| **5** | **Long-horizon agent.** A task needing 50+ turns (repo refactor, multi-document analysis) with compaction and a scratchpad. | Context rot, compaction, external state | Completes a task requiring ≥2 compactions; a fact from window 1 is correctly used in window 3 | The agent forgetting a constraint it was given on turn 2 — with no error anywhere |
| **6** | **Traced and costed.** Add full tracing, per-run cost attribution, and a dashboard to project 5. | Observability, cost arithmetic | Given any run ID, produce the full trace and exact cost; cost model matches invoice within 20% | Discovering that one tool's oversized results account for most of your spend |
| **7** | **Adversarial agent.** Give project 2 a tool that fetches untrusted web content. Then attack it. | Injection, the lethal trifecta | A written capability audit proving one trifecta leg is absent on every path; an injection suite in CI; the *harness* blocks, not the model | Your own agent exfiltrating a "secret" you planted, via a channel you did not classify as outbound |
| **8** | **Cost-optimised agent.** Take project 5 and halve its cost. | Caching, routing, truncation, parallelism | ≥50% cost reduction with quality inside the noise band on the project-3 suite; all three numbers reported | A cache hit rate collapsing to near zero because you put a timestamp in the system prompt |

Project 7 is the one people skip and the one hiring managers ask about.

### 5.3 What to read

19 items. Each with what it teaches and where it is dated or overstated. Tier markers as elsewhere; **(-idx)** means this environment reached only a search-index summary (see *Retrieval limitations*).

| # | Item | Teaches | Caveat |
|---|---|---|---|
| 1 | Yao et al., *ReAct: Synergizing Reasoning and Acting in Language Models*, ICLR 2023, arXiv 2210.03629 (B-idx) | The foundational reason to interleave reasoning and action | The implementation is obsolete — native tool calling absorbed it. Read for the idea, not the format |
| 2 | Schick et al., *Toolformer: Language Models Can Teach Themselves to Use Tools*, NeurIPS 2023 (B-idx) | That tool use could be learned rather than prompted | Historical. Tool calling is now a trained-in API primitive; do not build on the method |
| 3 | Shinn et al., *Reflexion*, NeurIPS 2023, arXiv 2303.11366 (B-idx) | Verbal feedback across trials as a learning signal without weight updates | Gains depend on **external** feedback; read together with #4 or you will over-apply it |
| 4 | Huang et al., *Large Language Models Cannot Self-Correct Reasoning Yet*, ICLR 2024, arXiv 2310.01798 (B-idx) | Intrinsic self-correction does not reliably help and can hurt | Scoped to reasoning tasks without external feedback. Not a claim that all reflection is useless |
| 5 | Yao et al., *Tree of Thoughts: Deliberate Problem Solving with Large Language Models*, NeurIPS 2023 (B-idx) | Search over reasoning paths as an explicit algorithm | Cost is usually prohibitive in production; largely superseded by trained-in reasoning modes |
| 6 | Liu et al., *Lost in the Middle: How Language Models Use Long Contexts*, TACL 2024, arXiv 2307.03172 (B-idx) | Position matters: beginning and end beat middle | Measured on then-current models; the **shape** persists, the magnitudes do not. Do not quote 2023 numbers |
| 7 | Hong, Troynikov & Huber, *Context Rot*, Chroma technical report, Jul 2025 (B) | Length itself degrades reliability, across 18 models; NIAH is insufficient | Vendor-published (a vector DB company), though the replication toolkit is open. Read the method |
| 8 | Anthropic, *Building Effective AI Agents*, 19 Dec 2024 (A) | The workflow-vs-agent distinction; five workflow patterns; start without a framework | **Carries its own supersession note** about the tooling landscape having changed. The taxonomy holds; the tooling does not |
| 9 | Anthropic, *Effective Context Engineering for AI Agents*, 29 Sep 2025 (A) | Context as a curated, finite resource; compaction, note-taking, sub-agents, just-in-time retrieval | Vendor perspective shaped by their own products. The principles generalise; the examples are Claude-shaped |
| 10 | Anthropic, *Advanced Tool Use* (Tool Search, Programmatic Tool Calling), 24 Nov 2025 (A) | Deferred tool loading and code-mode tool calling, with measured token and accuracy deltas | All numbers are **internal** evaluations on Anthropic models. Directionally strong, not independently reproduced |
| 11 | Anthropic, *How we built our multi-agent research system*, Jun 2025 (A-idx) | The strongest published case for orchestrator/worker, with its cost multiplier stated honestly | Internal eval; ~15× token cost; no circuit breakers in the described architecture. Read with #12 |
| 12 | Yan (Cognition), *Don't Build Multi-Agents* (B-idx) | Why concurrent agents conflict; share context, keep writes single-threaded | Position piece from production experience, not a controlled study. It is the correct default anyway |
| 13 | Yao et al., *τ-bench: A Benchmark for Tool-Agent-User Interaction*, arXiv 2406.12045 (B-idx) | `pass^k` — the reliability metric agent work actually needs | The benchmark itself has documented scoring flaws (see #15). The metric is the durable contribution |
| 14 | Mialon et al., *GAIA: a benchmark for General AI Assistants*, ICLR 2024, arXiv 2311.12983 (B-idx) | What a genuinely hard assistant task looks like; the original human-vs-model gap | Headline scores are two-plus years old and widely misquoted. Cite the task design, not the numbers |
| 15 | Zhu et al., *Establishing Best Practices for Building Rigorous Agentic Benchmarks*, arXiv 2507.02825 (B-idx) | The Agentic Benchmark Checklist; concrete flaws in ten widely used evaluations | If you read one evaluation paper, read this. It will make you distrust leaderboards permanently |
| 16 | *SWE-Bench+*, arXiv 2410.06992 (B-idx) | Solution leakage and weak test suites in the field's flagship coding benchmark | Findings are about specific dataset snapshots; later curated variants address some of it |
| 17 | *RAG-MCP: Mitigating Prompt Bloat in LLM Tool Selection*, arXiv 2505.03275 (B-idx) | The measured tool-count degradation curve, and retrieval as the fix | Measured on a specific MCP stress-test setup; the curve's shape transfers, the exact percentages do not |
| 18 | Willison, *The lethal trifecta for AI agents*, 16 Jun 2025 (B) | The clearest available framing of agent data-exfiltration risk | Not a mitigation technique — an architectural test. Pair with OWASP for coverage |
| 19 | OWASP, *Top 10 for LLM Applications 2025* (B/C-idx) + NIST AI 600-1, *Generative AI Profile*, 26 Jul 2024 (B-idx) | The vocabulary auditors and security teams use; risk categories and control mappings | Compliance-shaped, not engineering-shaped; both lag the agentic threat landscape. Verify current revisions before citing in an audit |

**Also read, continuously:** the **primary API documentation** of whichever provider you use — tool use, caching, streaming, structured output, rate limits — and the **MCP specification** if you touch MCP. These are tier (A) and change under you; nothing secondary substitutes.

### 5.4 Staying current without drowning

**The cadence that works:**

| Frequency | Action |
|---|---|
| **On every provider release** | Read the changelog and the model card. Run your eval suite. Do not read the launch blog and form an opinion |
| **Weekly, ~30 min** | One engineering write-up from a team actually running agents. Skip anything with a "10 frameworks compared" title |
| **Monthly** | Re-verify your hard-coded facts: context limits, pricing, rate limits, protocol revisions. Put this on a calendar — it is the single highest-value recurring task in this list |
| **Quarterly** | Re-run the Part 4.4 protocol on one tool you are curious about. Adopt at most one new thing per quarter |
| **Ignore entirely** | Framework release announcements, benchmark leaderboard movements, "agents are/aren't the future" discourse, and any claim with a percentage and no method |

**Signal sources.** Provider engineering blogs and changelogs (A). Named engineers publishing from production with numbers and methods (B). Papers with released code and replication toolkits (B). **Noise sources:** anything comparing frameworks without running them; any post whose evidence is a screenshot; salary and market posts from recruiting firms with no stated methodology.

The single best filter: **does this source state a method and a date?** If not, skip it. That filter would have excluded most of what has been written about this field.

---

## Part 6 — Getting hired

### 6.1 What the market asks for

**Methodological warning up front.** The best available aggregate analysis found (a 43,500-posting study) was **egress-blocked from this environment** and could not be read. Compensation figures in this section come from recruiting-firm and career-blog posts that **do not state a methodology, a sample, or a date range** — these are **tier (C)** and are reported as a range with that caveat attached, not as a finding. To verify properly you would need: postings pulled from a named source over a named window, or a compensation dataset with a stated methodology (a self-reported aggregator's data is still self-reported).

**Titles seen in postings (C-idx):** AI Engineer, AI Agent Engineer, Agentic AI Engineer, Applied AI Engineer, Forward-Deployed Engineer, LLM Engineer. Adjacent and often the same job: Software Engineer (AI Platform), ML Engineer (Applied), Solutions Engineer at an AI vendor.

**Skills repeatedly requested (C-idx, consistent across several 2026 recruiter analyses):**

| Skill | Notes |
|---|---|
| Python | Near-universal; TypeScript common where the agent sits in a web product |
| Cloud platform experience | Reported in a majority of postings |
| RAG / retrieval | Requested far more often than it is the right solution (E7) |
| An orchestration framework by name | LangGraph most cited; treat the name as a keyword filter, not a competence signal |
| MCP | Increasingly named; postings citing it reportedly pay more (C — unverified, and confounded with company stage) |
| Evaluation / observability | Named less often than it should be, given that it is the actual bottleneck |
| Security / guardrails | Growing, concentrated in regulated industries |

**Experience:** most postings target roughly 2–6 years of general engineering experience (C-idx). The field is too young for a decade of agent-specific experience to exist, which is why portfolio evidence carries unusual weight.

**Compensation (C — treat as folklore until verified):** recruiter-published US ranges for 2026 cluster around $150K–$210K base at mid-level and $210K–$290K at senior, with frontier-lab total compensation reported far higher. **None of these sources published a methodology.** Do not negotiate from them; use a compensation aggregator that publishes its sample, and discount self-reported data.

### 6.2 Portfolio over credentials

A convincing portfolio project has four properties. Missing any one of them makes it a demo.

1. **It has evals.** A test set, a protocol, mean ± SD, and a documented case where the numbers said your change did not help — and you believed them.
2. **It has a trace.** You can show one run end to end: every model call, every tool call, tokens, cost, latency, stop reasons.
3. **It handles failure.** Tool errors, truncation, budget exhaustion, injection attempts. Show the guard firing.
4. **It states its own limitations.** A README section naming what it does badly, with evidence. **This is the strongest possible signal**, because it proves you measured rather than hoped.

Add a fifth if you can: **a cost number.** "This agent costs $0.04 per run at p50 and $0.31 at p95, and here is where the p95 goes" separates you from essentially every other candidate.

What does **not** help: certificates; a project that only wraps a framework's quickstart; a multi-agent architecture with no single-agent baseline (it signals the opposite of judgement — see Cluster F); a demo video with no repository.

### 6.3 Interview reality

Loops reported in 2026 typically include a screen, a take-home or portfolio review, an agent system-design round, an evaluation/debugging round, and a security or cross-functional round (C-idx). The distinctive rounds are **trace debugging** and **eval design** — these are the ones that cannot be crammed.

Format note: this section follows the question/answer-outline structure used by `tasks/18-ios-interview-questions/`, `tasks/19-swift-swiftui-interview-questions/`, `tasks/20-swift-concurrency-interview-questions/` and `tasks/21-swiftui-interview-questions/` in this repository. The content is unrelated; only the shape is shared. **Provenance: these 16 questions are `added-for-coverage`** — authored here from the concept map, because no company-confirmed agent-engineering question set was found in public sources. The recruiter-published question lists that do exist are tier (C) and visibly recycled from one another. Treat these as a study framework, not as leaked questions.

---

**Q1 — What is the difference between an agent and a workflow, and which have you actually built?**
*Testing:* whether you use the vocabulary precisely. **Answer:** a workflow has control flow fixed in your code; an agent lets the model decide the next step each turn. Then — critically — say which one your last system was, and why that was correct. Candidates who claim "agent" for a three-step pipeline are marking themselves. The strong answer usually ends "…and we deliberately kept it a workflow, because the task had a known procedure and we wanted a deterministic test."

**Q2 — Walk me through exactly what your code sends and receives in one turn of an agent loop.**
*Testing:* whether you know the wire format or only a framework's abstraction. **Answer:** the message array (A3), tool schemas, the tool_use block, the tool_result with a matching ID, the stop reason branch. If you cannot do this from memory, you have only used a framework. Mention that the provider never executes anything — your harness does.

**Q3 — Your agent worked yesterday and is worse today. Nothing in your repo changed. What happened?**
*Testing:* operational reasoning. **Answer outline:** model version moved under a floating alias; a tool's upstream API changed its response shape or size; a data source grew and now overflows a truncation boundary; cache TTL behaviour changed with traffic pattern; a third-party MCP server updated. **The meta-answer is "check the trace and diff the version triple"** (H7) — and the follow-up point that you pin model versions precisely so this question has an answer.

**Q4 — Design an agent for customer refunds. Take it to production.**
*Testing:* whether you reach for guardrails unprompted. **Answer outline:** tools classified read/write/irreversible (C6); authorisation in the **tool**, scoped to the requesting user, never in the prompt (I5); approval gate on refunds over a threshold (I7); idempotency keys so a retry does not double-refund (B9); step and cost guards (B7); trajectory evals asserting policy compliance; `pass^k` not `pass@k` because it acts unsupervised (G7); full tracing with cost attribution (H1, H3). **Injection surface:** the ticket body is user-controlled (I3).

**Q5 — Here is a trace of a failed run. Diagnose it.**
*Testing:* the core role-specific skill. **Answer:** work H5's checklist in order — what was in the context at the failing turn; was the needed information present; if present was it usable (position, format, buried in 40K tokens of JSON); was the tool description adequate; did the error message point anywhere. Name the failure from the H6 taxonomy. **Do not start by proposing a prompt change** — that is the tell that you do not read traces.

**Q6 — How do you know a prompt change made things better?**
*Testing:* evaluation discipline. This is the single highest-signal question in the loop. **Answer:** G11's protocol verbatim — frozen eval set, 5 trials baseline, one change, 5 trials, compare against standard deviation, report quality *and* cost *and* latency. The answer that gets the offer includes: **"and most of the time the honest conclusion is that the change is inside the noise band."**

**Q7 — Design an eval suite for an agent that books travel.**
*Testing:* whether you build the hierarchy bottom-up. **Answer:** unit (right tool, right arguments — `search_flights` with the right date and airport codes); trajectory (searched before booking; never booked twice; step count in range); end-to-end (correct booking exists in the test system); human review on a weekly sample for judgement calls; online (completion rate, support-contact rate). Cost and latency as gates (G9). Cases built from real traces (G3). Mention `pass^k` and why.

**Q8 — When would you use an LLM-as-judge, and how would you keep it honest?**
*Testing:* whether you know judges are instruments needing calibration. **Answer:** only for open-ended quality with no programmatic check, and only after cheaper eval levels exist. Keep it honest: small discrete rubric with anchors; randomise position and run both orders; control for length; never let a model judge its own output in a comparison; **validate against human labels and re-validate on a schedule** (G6); treat judge–human agreement as a metric that can regress. Name the circularity risk explicitly.

**Q9 — Your agent costs 5× what you projected. Find it.**
*Testing:* cost arithmetic. **Answer outline:** check mean turn count first — cost grows with the square of turns (J2). Then cache hit rate (a prefix change can collapse it silently — A9/J3). Then tool result sizes (one oversized return, re-sent every turn thereafter). Then retry storms. Then sub-agent recursion if multi-agent. Then reasoning-token usage. **Say you'd look at the trace's token breakdown by category, not the invoice total.**

**Q10 — Explain prompt injection to a product manager, and tell them what we're going to do about it.**
*Testing:* whether you overclaim. **Answer:** instructions and data share one channel; the model cannot reliably tell your instruction from text it read in a document. Then the part that matters: **there is no complete fix.** We defend architecturally — audit every tool against the lethal trifecta and ensure one leg is always absent (I2); authorisation in tools, not prompts; approval gates on irreversible actions; egress allowlists. A candidate who says "we'll add a guardrail model and that handles it" has failed the question.

**Q11 — An agent reads customer emails and can query our database and send replies. What's wrong?**
*Testing:* trifecta recognition on sight. **Answer:** that is all three legs — untrusted content (email), private data (database), outbound channel (send). Fixes, in order of preference: remove the outbound channel (draft for human send); scope the database credential to the specific customer in the thread; hard approval gate on send. Note the non-obvious channels too: a link the agent renders, an image the mail client fetches.

**Q12 — When is multi-agent the right architecture?**
*Testing:* scepticism. **Answer:** rarely — when the task is breadth-first and read-heavy, sub-tasks are genuinely independent, the material exceeds one window, and exactly one component writes. Cite the token multiplier (roughly 15× in Anthropic's published case) and the single-writer principle. **Then say you would build the single-agent baseline first and only adopt multi-agent if it beat it on quality, cost and latency together.** Candidates who enthuse about specialised agent teams are describing an org chart.

**Q13 — Your agent has 40 tools and picks the wrong one 15% of the time. Fix it.**
*Testing:* tool-design judgement. **Answer:** first, build the disambiguation eval so you can measure (C1). Then: consolidate overlapping tools; rewrite descriptions to say *when to use this and not that*; tighten schemas with enums; consider deferred tool loading or retrieval-based tool selection — cite the measured degradation curve (C4). Finally: 40 tools is usually a sign the tools mirror your API surface rather than the user's tasks.

**Q14 — How do you make a long-running agent survive a deploy?**
*Testing:* distributed-systems thinking. **Answer:** persist the message array and pending state; idempotency keys on side-effecting tools; an append-only log so replay returns logged results rather than re-executing (B9). Then the distinction that separates seniors: **checkpointing state is not durable execution** — something outside the process must detect failure and re-enter, which is either a durable-execution engine or code you write and operate.

**Q15 — Would you use RAG here? (Interviewer describes a codebase Q&A tool.)**
*Testing:* whether "RAG" is a reflex. **Answer:** probably not as a vector index. For a codebase the agent can navigate, lexical search plus file reads avoids an index that goes stale, avoids chunking that severs functions from their context, and reads the current state of the files. Cite the evidence and its limits (E7) — and then say you would measure both on this corpus and report recall, cost and latency, because the answer is regime-dependent.

**Q16 — What's a thing you built with an agent that you'd now build without one?**
*Testing:* judgement and honesty. There is no model answer; a real one is required. The shape that lands: a task with a known procedure and a checkable correctness criterion, where the agent added non-determinism, cost, latency and an injection surface for no benefit, and where a form plus three API calls would have been right. **A candidate who cannot name one has either not shipped much or is not being straight.**

---

## Part 7 — What is genuinely unsettled

*Presented as live disagreements. This section does not resolve them.*

**7.1 Is prompt injection solvable at all?**
*One view:* it is structural. Instructions and data share one channel and the model must interpret both; any filter is itself a natural-language classification problem with an adversary. On this view the only real defences are architectural containment and least privilege, permanently. *The other view:* it is an engineering problem like SQL injection or XSS, and a combination of trained instruction hierarchy, provenance tracking, capability-based tool access and formal information-flow control will reduce it to a managed risk. **Current state:** it has been #1 on the OWASP LLM list for two consecutive editions, and no published defence claims completeness. Both camps agree on what to do *today*; they disagree about 2030.

**7.2 Do multi-agent architectures pay for themselves?**
*For:* Anthropic's published research-system result is a large measured gain on breadth-first research. *Against:* Cognition's production position is that concurrent agents are brittle and that additional agents should add intelligence, not actions. **Unsettled:** how wide the class of tasks is where parallel breadth beats a single agent with a bigger budget. The honest summary is that the evidence base is two positions from two companies about two different task shapes, and there is no controlled cross-organisation study.

**7.3 Do long-context models obsolete retrieval?**
*For:* context windows keep growing; caching makes large stable prefixes cheap; retrieval is a pipeline you must build and keep in sync. *Against:* context rot means fitting is not using (D6); cost grows with what you put in; and agentic search reads the *current* state rather than an index of a past one. **Unsettled:** whether degradation curves flatten enough that "load everything" becomes correct. Note that the two most-cited pieces of evidence here come from a vector-database company and from model providers respectively — read both with that in mind.

**7.4 Do reasoning models change agent design fundamentally?**
*For:* if the model plans well internally, external planning scaffolds, decomposition frameworks and much of the orchestration layer become redundant — the harness shrinks toward "a loop and good tools". *Against:* reasoning raises cost and latency, does not address context management, memory, permissions or evaluation, and the hard parts of production agent work are unchanged by it. **Unsettled**, and it is the disagreement with the largest implication for which of today's skills stay valuable.

**7.5 How much current agent capability is benchmark contamination?**
Documented flaws are severe: solution leakage in a flagship coding benchmark; grader errors awarding credit for wrong answers; task-setup issues capable of moving reported performance by up to 100%. *One view:* headline agent progress is substantially inflated and real-world reliability lags far behind leaderboards. *The other:* the flaws are real but roughly constant across models, so *relative* progress is still informative. **Unsettled**, with the important practical consequence that **private evaluation is not optional.**

**7.6 Are frameworks net-positive?**
*For:* they encode hard-won patterns, provide durable state and tracing, and let teams ship faster. *Against:* they obscure the request, make debugging harder, add churn, and the primitive they abstract is a few hundred lines. **Unsettled**, and probably unsettleable in general — it depends on team size, task complexity and how much of the concept map the team already owns. Note the provider whose interests would be served by framework adoption publishes advice to start without one.

**7.7 How much of this stack survives the next model generation?**
Almost certainly durable: evaluation, observability, cost accounting, security architecture, tool design, and the fact that authorisation belongs in code. Plausibly transient: manual context management (if degradation flattens), hand-built planning scaffolds, prompt-engineering micro-technique, much of today's orchestration layer, and possibly today's retrieval architectures. **The honest hedge: invest in the concepts that are really distributed-systems and product concepts wearing LLM clothing. Those have survived every generation so far.**

### 7.8 Widely repeated claims that are wrong

| Claim | Why it is wrong |
|---|---|
| "Temperature 0 makes the model deterministic." | Batching effects and floating-point non-associativity break byte-equality; providers also update models under stable aliases. Test on distributions, not strings (A4) |
| "A bigger context window solves context management." | Fitting is not using. Degradation with length is measured across many models, and cost grows with what you include (D6) |
| "More tools make the agent more capable." | Tool-selection accuracy degrades measurably with tool count; the published fix is *fewer in context*, not more (C4) |
| "Agents can self-correct if you tell them to reflect." | Intrinsic self-correction without external feedback does not reliably help and can degrade performance (B5) |
| "Multi-agent systems are more capable than single agents." | Usually a cost multiplier. The one strong published win is breadth-first read-only research at ~15× tokens with a single writer (F6) |
| "RAG is the standard retrieval architecture for agents." | For agents with a loop over navigable corpora, lexical/agentic search frequently wins, and removes a staleness problem (E7) |
| "Prompt injection can be fixed with a guardrail model." | Guardrails raise attack cost; none is complete. The working defence is architectural (I1, I2) |
| "Benchmark scores tell you which model to use for your task." | Documented contamination, leakage and grader errors; harness differences make cross-report comparison unsound (G10) |
| "Structured output guarantees correct output." | It guarantees *syntax*. Schema-valid nonsense is the dominant failure, and format constraints can reduce task performance (A7) |
| "Prompt engineering is the core skill." | It is a sub-skill of context engineering, which is itself mostly harness engineering (D1) |
| "You need to understand transformers to build agents." | You need tokens, windows, sampling and autoregression. Attention internals are not load-bearing (2.2) |
| "Checkpointing gives you durable agents." | Checkpoints persist data, not execution. The run still dies with the process (B9) |
| "LLM-as-judge scores are objective measurements." | Judges carry position, verbosity and self-preference biases and must be validated against humans and re-validated (G5, G6) |

---

## One-page concept checklist

Use as self-assessment. For each, you should be able to state the mechanism, one production failure mode, and how you would test it.

**A — Model interaction primitives**
- [ ] A1 Tokens and tokenisation
- [ ] A2 Context windows as a budget
- [ ] A3 Message/turn structure and roles
- [ ] A4 Sampling and the determinism myth
- [ ] A5 Streaming
- [ ] A6 Stop conditions and finish reasons
- [ ] A7 Structured output
- [ ] A8 Tool calling as an API primitive
- [ ] A9 Prompt caching
- [ ] A10 Batching
- [ ] A11 Multimodal inputs
- [ ] A12 Reasoning / extended thinking modes

**B — The agent loop**
- [ ] B1 The core loop
- [ ] B2 ReAct: contribution vs mythology
- [ ] B3 Planning vs reactive execution
- [ ] B4 Task decomposition
- [ ] B5 Reflection and self-critique
- [ ] B6 Tool-choice forcing
- [ ] B7 Budget and iteration guards
- [ ] B8 Interruption, HITL, resumability
- [ ] B9 Idempotency, replay, durable execution

**C — Tools**
- [ ] C1 Tool descriptions as a prompt surface
- [ ] C2 Parameter schema design
- [ ] C3 Error messages as model input
- [ ] C4 Tool granularity and count
- [ ] C5 Result size and truncation
- [ ] C6 Read-only vs side-effecting tools
- [ ] C7 Permissioning, confirmation, dry-run
- [ ] C8 Sandboxing and code execution
- [ ] C9 Computer and browser use
- [ ] C10 MCP and interop

**D — Context engineering**
- [ ] D1 Context engineering vs prompt engineering
- [ ] D2 Context as a budgeted resource
- [ ] D3 System prompt design
- [ ] D4 Few-shot examples and when they hurt
- [ ] D5 Instruction conflict and ordering
- [ ] D6 Context rot and long-context degradation
- [ ] D7 Compaction and hand-off
- [ ] D8 Scratchpads and external state
- [ ] D9 Sub-agent context isolation

**E — Memory and retrieval**
- [ ] E1 Short-term vs long-term memory
- [ ] E2 Session and conversation state
- [ ] E3 Embeddings and vector search
- [ ] E4 Chunking
- [ ] E5 Hybrid and keyword search
- [ ] E6 Reranking
- [ ] E7 Agentic search vs one-shot RAG
- [ ] E8 Knowledge graphs
- [ ] E9 Freshness, invalidation, memory hygiene

**F — Multi-agent systems**
- [ ] F1 Orchestrator/worker
- [ ] F2 Pipeline and peer patterns
- [ ] F3 Hand-off and state transfer
- [ ] F4 Shared vs isolated context
- [ ] F5 Coordination overhead
- [ ] F6 The evidence, including negative results

**G — Evaluation**
- [ ] G1 Non-determinism vs conventional testing
- [ ] G2 The eval hierarchy
- [ ] G3 Test sets from real traces
- [ ] G4 Golden datasets and maintenance cost
- [ ] G5 LLM-as-judge
- [ ] G6 Judge validation and circularity
- [ ] G7 pass@k vs pass^k and variance
- [ ] G8 Regression across model versions
- [ ] G9 Cost and latency as first-class metrics
- [ ] G10 Public benchmarks and their validity
- [ ] G11 The "did it help?" protocol

**H — Observability and operations**
- [ ] H1 Tracing an agent run
- [ ] H2 What to log and never log
- [ ] H3 Token accounting and cost attribution
- [ ] H4 Latency budgets
- [ ] H5 Debugging from a trace
- [ ] H6 Failure taxonomy
- [ ] H7 Versioning the prompt/tool/model triple
- [ ] H8 Rollout, rollback, on-call

**I — Security and safety**
- [ ] I1 Prompt injection, direct and indirect
- [ ] I2 The lethal trifecta
- [ ] I3 Tool output as untrusted input
- [ ] I4 Exfiltration channels
- [ ] I5 Confused deputy and credential scope
- [ ] I6 Sandboxing and least privilege
- [ ] I7 Approval gates and irreversible actions
- [ ] I8 Supply-chain risk in tools/MCP servers
- [ ] I9 Secrets, PII, residency
- [ ] I10 Jailbreaks vs injections; standards

**J — Cost, latency and scale**
- [ ] J1 The arithmetic of an agent run
- [ ] J2 Super-linear cost scaling
- [ ] J3 Caching and context reuse
- [ ] J4 Model routing and cascades
- [ ] J5 Streaming for perceived latency
- [ ] J6 Parallel tool execution
- [ ] J7 Batching and offline queues
- [ ] J8 Rate limits, backoff, quota
- [ ] J9 Self-hosting and open weights

**K — Product and interface**
- [ ] K1 Designing for a system that is wrong sometimes
- [ ] K2 Showing work and intermediate state
- [ ] K3 Trust calibration and honest uncertainty
- [ ] K4 Permission and confirmation UX
- [ ] K5 Interruption and steering
- [ ] K6 Latency perception
- [ ] K7 When an agent is the wrong product shape

---

## Glossary

**Agent** — a model called in a loop with tools and a stopping condition, where the model decides the next step.
**Agentic search** — retrieval performed by the agent iteratively using tools, rather than a single pre-generation retrieval step.
**Batch API** — asynchronous bulk request submission, typically discounted with a long completion window.
**Breakpoint (cache)** — the marker designating the end of the cacheable prompt prefix.
**Chunking** — splitting documents into independently indexable units.
**Compaction** — replacing a long conversation history with a summary and continuing.
**Confused deputy** — a system acting with its own authority on behalf of a less-privileged requester.
**Constrained decoding** — masking tokens that cannot continue a valid parse, guaranteeing syntactic schema conformance.
**Context engineering** — curating and maintaining the set of tokens present during inference.
**Context rot** — degradation in reliability as input length grows, independent of the hard window limit.
**Context window** — the maximum tokens in one request, spanning input, output and reasoning.
**Durable execution** — an execution model where a run survives process death and resumes, distinct from checkpointing state.
**Embedding** — a vector representation of text used for similarity retrieval.
**Eval** — an automated assessment of agent behaviour against expected properties.
**Few-shot** — including demonstrations in the prompt to shape behaviour.
**Golden dataset** — a curated input→expected-output set used as a quality reference.
**Grounding** — tying model output to retrieved or tool-returned evidence.
**Guard** — a harness-enforced limit on steps, tokens, time or money.
**Hallucination / confabulation** — fluent output not supported by evidence or reality.
**Harness** — the code around the model call: loop, tool dispatch, context assembly, guards. **The harness is the agent.**
**HITL (human-in-the-loop)** — pausing execution for human approval or correction.
**Idempotency** — the property that repeating an operation has no additional effect.
**Indirect prompt injection** — hostile instructions reaching the model through content it retrieves rather than from the user.
**Jailbreak** — a *user* attempting to make the model violate its own policy (distinct from injection).
**Lethal trifecta** — private data + untrusted content + an outbound channel in one execution path.
**LLM-as-judge** — using a model to score outputs against a rubric.
**MCP (Model Context Protocol)** — an open JSON-RPC client–server protocol for exposing tools, resources and prompts to AI applications.
**Multimodal** — inputs beyond text (images, audio, PDFs, video).
**Orchestrator/worker** — a lead agent dispatching sub-agents and synthesising their results.
**pass@k** — at least one of k attempts succeeded (optimistic).
**pass^k** — all k attempts succeeded (pessimistic; the reliability metric for unsupervised agents).
**Prompt caching** — provider-side reuse of computed state for a repeated prompt prefix, billed at a discount.
**Prompt injection** — attacker-controlled text in context causing the model to follow the attacker's instructions.
**Programmatic tool calling** — having the agent write code that calls tools, so intermediate results bypass the context window.
**ReAct** — interleaving reasoning traces with actions; the conceptual ancestor of the modern tool-calling loop.
**Reranking** — a second-stage model reordering retrieval candidates with joint query–document attention.
**Reasoning tokens** — tokens generated as internal deliberation before the answer; billed and counted against the window.
**Reflection** — having a model critique and revise its own output.
**Retrieval (RAG)** — fetching external content into the context before generation.
**Scratchpad** — durable external notes the agent writes and re-reads.
**Sub-agent** — a separate model call with its own context window, returning a condensed summary.
**Stop reason / finish reason** — why generation ended (end turn, max tokens, tool call, stop sequence, refusal).
**Structured output** — model output constrained to a schema.
**Tool** — a function the model can request the harness to execute.
**Tool calling** — the API primitive by which a model emits a structured function-invocation request.
**Trajectory** — the sequence of steps an agent took in one run.
**Trace** — the structured record of a run: spans over model calls, tool calls and retries.
**Truncation** — cutting content to fit a budget, whether of tool results or of generated output.
**Version triple** — the (prompt, tool schemas, model version) unit that must be versioned and deployed together.

---

## Sources

Ordered by cluster relevance. **Tier** as defined in *How to read this*. **"Accessed"** means retrieved in this research session (2026-09-24); **"index only"** means this environment could reach only a search-engine summary because the domain was egress-blocked — see *Retrieval limitations*.

### Primary — provider and specification documentation

| # | Source | Publisher / date | Tier | Access |
|---|---|---|---|---|
| S1 | *Building Effective AI Agents* — https://www.anthropic.com/engineering/building-effective-agents | Anthropic, 19 Dec 2024 (carries its own supersession note) | A | Full text, accessed 2026-09-24 |
| S2 | *Effective Context Engineering for AI Agents* — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents | Anthropic, 29 Sep 2025 | A | Full text, accessed 2026-09-24 |
| S3 | *Advanced Tool Use* (Tool Search Tool, Programmatic Tool Calling, Tool Use Examples) — https://anthropic.com/engineering/advanced-tool-use | Anthropic, 24 Nov 2025 | A | Full text, accessed 2026-09-24 |
| S4 | *Prompt caching* — https://platform.claude.com/docs/en/build-with-claude/prompt-caching | Anthropic (Claude Platform Docs) | A | Full text, accessed 2026-09-24. **All caching figures are point-in-time as of that date** |
| S5 | *Semantic Conventions for GenAI spans*, tag v1.41.0 — https://github.com/open-telemetry/semantic-conventions/blob/v1.41.0/docs/gen-ai/gen-ai-spans.md | OpenTelemetry | A | Full text, accessed 2026-09-24. **Status badge: Development (pre-stable)** |
| S6 | *Introducing Structured Outputs in the API* — https://openai.com/index/introducing-structured-outputs-in-the-api/ | OpenAI | A | Index only |
| S7 | MCP specification changelog, revision 2025-11-25 — https://modelcontextprotocol.io/specification/2025-11-25/changelog | Model Context Protocol | A-idx | **Domain egress-blocked.** Index only. Prior revision reported as 2025-06-18 |
| S8 | *How we built our multi-agent research system* | Anthropic, Jun 2025 | A-idx | Index only. Source of the ~15× token multiplier and the 90.2% internal-eval figure |

### Independent — papers, benchmarks and technical reports

| # | Source | Publisher / date | Tier | Access |
|---|---|---|---|---|
| S9 | Yao et al., *ReAct: Synergizing Reasoning and Acting in Language Models*, arXiv 2210.03629 | ICLR 2023 | B-idx | arxiv.org egress-blocked; index + author repo (`ysymyth/ReAct`) |
| S10 | Shinn et al., *Reflexion: Language Agents with Verbal Reinforcement Learning*, arXiv 2303.11366 | NeurIPS 2023 | B-idx | Index + author repo (`noahshinn/reflexion`) + NeurIPS poster page |
| S11 | Huang et al., *Large Language Models Cannot Self-Correct Reasoning Yet*, arXiv 2310.01798 | ICLR 2024 | B-idx | Index + ICLR proceedings page |
| S12 | Liu et al., *Lost in the Middle: How Language Models Use Long Contexts*, arXiv 2307.03172 | TACL 2024 (ACL Anthology 2024.tacl-1.9) | B-idx | Index + ACL Anthology landing page |
| S13 | Hong, Troynikov & Huber, *Context Rot: How Increasing Input Tokens Impacts LLM Performance* — https://research.trychroma.com/context-rot | Chroma, Jul 2025 | B | Index; replication toolkit at `chroma-core/context-rot`. **Vendor-published — read the method** |
| S14 | Yao, Shinn, Razavi & Narasimhan, *τ-bench: A Benchmark for Tool-Agent-User Interaction in Real-World Domains*, arXiv 2406.12045 (Jun 2024); τ²-bench at `sierra-research/tau2-bench` | Sierra, 2024–2026 | B-idx | Index + GitHub. Source of `pass^k` |
| S15 | Zhu et al., *Establishing Best Practices for Building Rigorous Agentic Benchmarks*, arXiv 2507.02825 | 2025 | B-idx | Index. Source of the "up to 100%" over/under-estimation finding and the Agentic Benchmark Checklist |
| S16 | *SWE-Bench+: Enhanced Coding Benchmark for LLMs*, arXiv 2410.06992 | 2024 | B-idx | Index. Source of the 32.67% solution-leakage figure |
| S17 | Mialon, Fournier, Wolf, LeCun & Scialom, *GAIA: a benchmark for General AI Assistants*, arXiv 2311.12983 | ICLR 2024 (preprint Nov 2023) | B-idx | Index. 466 questions; humans 92% vs 15% for a then-current model with plugins |
| S18 | *RAG-MCP: Mitigating Prompt Bloat in LLM Tool Selection via Retrieval-Augmented Generation*, arXiv 2505.03275 | May 2025 | B-idx | Index + HuggingFace papers page. Source of 43.13% vs 13.62% tool-selection accuracy |
| S19 | Sen et al., *Is Grep All You Need? How Agent Harnesses Reshape Agentic Search*, arXiv 2605.15184 | 2026 | B-idx | Index. LongMemEval 116-question subset across four harnesses |
| S20 | *Let Me Speak Freely? A Study on the Impact of Format Restrictions on Performance of Large Language Models*, arXiv 2408.02442 | 2024 | B-idx | Index |
| S21 | *JSONSchemaBench: A Rigorous Benchmark of Structured Outputs for Language Models*, arXiv 2501.10868 | 2025 | B-idx | Index |
| S22 | *The Complexity Trap: Simple Observation Masking Is as Efficient as LLM Summarization for Agent Context Management*, arXiv 2508.21433 | 2025 | B-idx | Index |
| S23 | *Measurement Without Validity: The Compounding Reliability Problem in Agentic AI Evaluation*, arXiv 2608.00794 | 2026 | B-idx | Index |
| S24 | *Stop Means Stop: Measuring and Repairing the Enforcement Gap in Agent-Framework Control Primitives*, arXiv 2607.14166 | 2026 | B-idx | Index |
| S25 | *A2ABreak: Systematic Security Analysis of the A2A Protocol*, arXiv 2609.10871 | 2026 | B-idx | Index. Cited only as evidence that A2A exists and has drawn security scrutiny |
| S26 | *Dynamic Model Routing and Cascading for Efficient LLM Inference: A Survey*, arXiv 2603.04445 | 2026 | B-idx | Index. Basis for the cascade mechanism and the calibration caveat |

### Independent — engineering write-ups and security material

| # | Source | Publisher / date | Tier | Access |
|---|---|---|---|---|
| S27 | Willison, *The lethal trifecta for AI agents: private data, untrusted content, and external communication* — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ | 16 Jun 2025 | B | Index |
| S28 | Yan (Cognition), *Don't Build Multi-Agents* — https://cognition.com/blog/dont-build-multi-agents, and the follow-up on production multi-agent patterns | Cognition | B-idx | Index |
| S29 | *OWASP Top 10 for LLM Applications 2025* — https://owasp.org/www-project-top-10-for-large-language-model-applications/assets/PDF/OWASP-Top-10-for-LLMs-v2025.pdf | OWASP GenAI Security Project | B/C-idx | `genai.owasp.org` egress-blocked; index only |
| S30 | *NIST AI 600-1: AI RMF Generative Artificial Intelligence Profile* — https://www.nist.gov/itl/ai-risk-management-framework | NIST, 26 Jul 2024 | B-idx | Index. Reports of 2026 agent-specific NIST work were **not verifiable from a primary source here** |
| S31 | Temporal and Diagrid engineering write-ups on durable execution vs checkpointing for agent workflows | 2026 | B | Index. Vendor-authored but the mechanical argument is verifiable from first principles |
| S32 | Framework comparison material (Langfuse, Speakeasy and other 2026 surveys) covering LangGraph, CrewAI, OpenAI Agents SDK, Pydantic AI | 2025–2026 | C | Index. **Used only for the shape of Part 4's table, not for any capability claim** |

### Weak sources, used and labelled as such

| # | Source | Used for | Tier | Note |
|---|---|---|---|---|
| S33 | Recruiter and career-site 2026 salary and skills posts (KORE1, HeroHunt, GSDC, 365 Data Science and similar) | Part 6 titles, skills and compensation ranges | C | **No published methodology, sample or date range in any of them.** Verify before using |
| S34 | Axial Search, *Inside the AI Engineering Job Market: 43,500 Postings Analyzed* — https://axialsearch.com/insights/ai-engineering-jobs | Would have been the best market source | — | **Egress-blocked. Not read. Not relied on.** |
| S35 | 2026 practitioner blog posts on MCP tool overload (AgentPMT, DEV.to and similar) | Directional support only for C4 | C | Specific thresholds ("50 tools", "5–7 servers", "143,000 of 200,000 tokens") are **unverified**. The direction is corroborated by S3 and S18; the numbers are not |
| S36 | 2026 practitioner posts on human-in-the-loop approval tiers | The three-tier pattern in B8/I7 | C | The pattern is uncontroversial and mechanically obvious; no primary source was needed or found |

### Cross-references within this repository

- `tasks/27-startup-building-speechify-like-app/` — a worked product build, for how a real product's constraints shape technical choices.
- `tasks/23-solana-smart-contract-tutorial/` — tutorial format used in this repository.
- `tasks/18-ios-interview-questions/`, `tasks/19-swift-swiftui-interview-questions/`, `tasks/20-swift-concurrency-interview-questions/`, `tasks/21-swiftui-interview-questions/` — the interview-question format Part 6.3 follows. Content is unrelated and is not restated here.

---

*Research performed 24 September 2026. Every model-specific figure, price multiplier, protocol revision and benchmark number in this report is a point-in-time value. Re-verify against primary documentation before relying on any of them.*

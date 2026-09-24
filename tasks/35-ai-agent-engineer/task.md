# Task: How to Become an AI Agent Engineer — The Complete Concept Map

Write the result to `output.md` in this folder.

## Objective

Search wide and deep — official provider documentation (Anthropic, OpenAI, Google, Meta, Mistral and others), framework and protocol specifications, peer-reviewed and arXiv research, production engineering write-ups from teams actually running agents at scale, security advisories and standards bodies — and produce a single **concept handbook and study map for the AI agent engineer role**.

The deliverable answers two linked questions:

1. **What is the complete set of concepts a working AI agent engineer must actually understand** — each explained well enough that a competent software engineer who has never built an agent can follow it, and deep enough that someone already building agents learns something.
2. **How does a person get from where they are to doing this job** — the skill ladder, what to build, what to read, what the role actually involves day to day, and how it is hired for.

This is a **technical reference**, not a career-motivation piece. The centre of gravity is Part 3 (the concept map). Everything else supports it.

## Framing — the discipline of this task

This subject is saturated with content produced by people who have built a demo but never operated an agent. Five failure modes must be actively resisted:

1. **Vocabulary without mechanism.** Terms like "ReAct", "RAG", "memory", "planning", and "multi-agent" are used as incantations. Every concept in this report must be explained by *what actually happens in the request/response loop* — what goes into the context window, what comes back, what the harness does with it. If a concept cannot be explained mechanically, say so and say why it may be marketing.
2. **Framework tutorials masquerading as understanding.** LangChain/LangGraph/CrewAI/Autogen/Agents SDK knowledge is not agent engineering. Explain the **underlying primitive first**, then show which framework abstracts it and at what cost. Be explicit that a production agent can be a few hundred lines of ordinary code around an HTTP call.
3. **Demo-to-production blindness.** The overwhelming majority of published agent content stops at the happy path. The hard parts — evaluation, non-determinism, partial failure, cost, latency, token budgets, tool errors, long-horizon context, security — get the most space here, not the least.
4. **Stale facts presented as current.** This field's specifics change every few months. Model names, context limits, pricing, API parameters, and protocol versions must be **cited to official documentation with an access date**, or stated as a pattern rather than a number. Do not write pricing or model identifiers from memory.
5. **Hype about autonomy.** Claims about what agents can reliably do autonomously should be checked against published benchmark results and their known limitations, not against vendor announcements.

### Evidence tiers — label claims where it matters
- **(A) Primary** — official API/model documentation, protocol specifications (e.g. MCP), framework source code and reference docs, model cards and system cards, published benchmark definitions.
- **(B) Independent** — peer-reviewed papers and arXiv preprints, reproducible benchmark results, first-hand engineering write-ups from teams running agents in production, security research from recognised organisations (OWASP, NIST, academic security groups).
- **(C) Reported/promotional** — vendor blog claims without a reproducible method, influencer threads, course material, unsourced benchmark numbers.

**Rule: no capability claim, benchmark number, price, or limit may rest on tier (C) alone.** Where only (C) exists, label it and say what would be needed to verify it.

## Scope

### Part 1 — What the job actually is (required, keep it tight)
- **A working definition** of an AI agent that survives scrutiny: a model in a loop with tools and a stopping condition, operating over a context it does not fully control. Contrast explicitly with: a single prompt call, a fixed chain/pipeline, a workflow engine with an LLM step, and a chatbot. **Draw the line where the loop and the tool access are** — say plainly that much of what is marketed as an "agent" is a fixed pipeline.
- **What the role is not** — distinguish AI agent engineer from ML engineer, research scientist, data scientist, MLOps/platform engineer, and "prompt engineer". Which of these skills are load-bearing, which are optional, and which are obsolete titles.
- **A day in the job** — the realistic breakdown of time: prompt and context iteration, tool/API plumbing, eval writing, failure triage from traces, cost and latency work, ordinary backend engineering. Be honest about the proportion that is conventional software engineering (it is most of it).
- **Where the role sits** — product-facing agents, internal automation, coding agents, customer support, research/analysis agents, and agent-platform teams. Say how the work differs in each.

### Part 2 — Prerequisites and the honest skill floor (required)
- **Software engineering fundamentals** actually needed: one language fluently (Python and/or TypeScript dominate — say why), async and concurrency, HTTP and streaming (SSE/websockets), retries, idempotency, queues and job runners, databases, containers, and basic distributed-systems reasoning.
- **How much ML is genuinely required** — and what is not. Cover what an engineer must understand about transformers, tokenisation, sampling (temperature, top-p), context windows, and attention cost *in order to make correct engineering decisions*, and state clearly what can be treated as a black box. **Do not pad this with a transformer tutorial.**
- **Fine-tuning, RLHF, distillation, and when they matter to this role** — mostly they do not; say when they do.
- **The honest gap analysis** — for three starting points (backend engineer, data scientist, new graduate), what is missing and roughly how long it takes to close.

### Part 3 — The concept map (required — this is the core of the report)

This is the heart of the deliverable. Group concepts into the clusters below. **Every concept gets the same five-part treatment:**

1. **What it is** — one or two precise sentences.
2. **The mechanism** — what concretely happens in the loop, the request, or the context window. Show a short code or message-trace sketch where it clarifies.
3. **When you need it** — and, importantly, when you do not.
4. **Failure modes** — how it breaks in production, with the symptom an engineer would actually observe.
5. **How it is tested** — what an eval for this concept looks like.

Cover at minimum the following, adding anything genuinely load-bearing that is missing:

**Cluster A — Model interaction primitives**
Tokens and tokenisation; context windows and what "fitting" really costs; the message/turn structure (system, user, assistant, tool roles); sampling parameters and determinism; streaming; stop conditions; structured output (JSON mode, schema-constrained decoding, and how each fails); function/tool calling as an API primitive; prompt caching and why it changes architecture; batching; multimodal inputs; reasoning/extended-thinking modes and their cost and latency trade-offs.

**Cluster B — The agent loop**
The core loop (model → tool call → result → model) and its termination conditions; ReAct and its actual contribution versus its mythology; planning versus reactive execution; task decomposition; reflection and self-critique (and the published evidence on whether self-critique actually helps); tool-choice forcing; max-iteration and budget guards; interruption, human-in-the-loop, and resumability; idempotency and replay of a partially-executed agent run; checkpointing and durable execution.

**Cluster C — Tools**
What makes a tool description good (this is a prompt-engineering surface, not an API doc — explain why); parameter schema design; error messages as model input; granularity (few powerful tools vs. many narrow ones) and the evidence either way; tool result size and truncation strategy; side-effecting versus read-only tools; permissioning, confirmation, and dry-run patterns; sandboxing and code execution as a tool; computer/browser use; **MCP (Model Context Protocol)** — what problem it solves, its architecture (hosts, clients, servers, transports, tools/resources/prompts), where it helps and where it adds indirection; other interop efforts, described accurately and with sources rather than hype.

**Cluster D — Context engineering**
Why this has displaced "prompt engineering" as the central skill; context as a budgeted resource; system prompt design and what belongs in it; few-shot examples and when they hurt; instruction conflict and ordering effects; context rot and long-context degradation (cite the research); compaction, summarisation, and hand-off between context windows; scratchpads and external state; sub-agent context isolation as a budgeting technique; retrieval as just-in-time context; the "everything in context vs. retrieve on demand" trade-off.

**Cluster E — Memory and retrieval**
Short-term versus long-term memory; conversation state and session design; embeddings and vector search (and its real failure modes); chunking; hybrid and keyword search; reranking; **why plain file/grep-based retrieval frequently outperforms vector RAG for agents** — argue this with evidence; knowledge graphs; agentic search versus one-shot RAG; freshness, invalidation, and stale memory; what should never be written to memory.

**Cluster F — Multi-agent systems**
Orchestrator/worker, pipeline, and peer patterns; when parallel sub-agents genuinely pay for themselves and when they multiply cost and error; hand-off and state transfer; shared versus isolated context; the coordination-overhead problem; published results on multi-agent performance, including negative results. **Be sceptical here** — state plainly that a single well-built agent beats a multi-agent architecture in most reported cases, and show the conditions under which that flips.

**Cluster G — Evaluation (give this the most space of any cluster)**
Why non-determinism breaks conventional testing; the eval hierarchy (unit-level assertions → trajectory evals → end-to-end task success → human review → online metrics); building a test set from real traces; golden datasets and their maintenance cost; LLM-as-judge (rubric design, position and verbosity bias, judge validation against human labels, and the circularity risk); pass@k and variance; regression testing across model versions; measuring cost and latency as first-class metrics; public agent benchmarks — what they measure, their known contamination and validity problems; and the practical answer to "how do I know my change made it better?"

**Cluster H — Observability and operations**
Tracing an agent run (spans over model calls, tool calls, retries); what to log and what must never be logged; token accounting and per-run cost attribution; latency budgets and where time actually goes; debugging from a trace rather than from a reproduction; failure taxonomy (hallucinated tool args, loops, premature stopping, context overflow, tool errors, refusals, truncation); on-call realities; versioning prompts, tools, and model choices together; rollout and rollback of prompt changes; OpenTelemetry semantics for LLM spans, if standardised — cite the spec, do not assume.

**Cluster I — Security and safety**
Prompt injection (direct and indirect) as the field's unsolved structural problem — explain the mechanism clearly and state honestly that no complete mitigation exists; the lethal trifecta (private data + untrusted content + exfiltration channel); tool-output as an untrusted input surface; data exfiltration via rendered content and outbound requests; confused-deputy and credential-scope problems; sandboxing and least privilege; approval gates and irreversible actions; supply-chain risk in third-party tool/MCP servers; secrets handling; PII and data residency; jailbreaks versus injections (distinguish them); OWASP's LLM/agentic risk material and NIST guidance, cited properly; auditability and compliance obligations.

**Cluster J — Cost, latency and scale**
Token economics and the arithmetic of an agent run; why agent cost scales super-linearly with turns; prompt caching, context reuse and their real effects; model routing and cascades (small model first, escalate); streaming for perceived latency; parallel tool execution; batching and offline queues; rate limits, backoff and quota management; capacity planning; build-vs-buy for inference; the open-weights/self-hosting decision and what it actually costs.

**Cluster K — Product and interface**
Designing for a system that is wrong sometimes; showing work and intermediate state; trust calibration and honest uncertainty; permission and confirmation UX; interruption and steering; latency perception; failure communication; when an agent is the wrong product shape and a deterministic feature is better. Include this cluster — agent engineers who ignore it ship things people do not use.

### Part 4 — The stack, surveyed honestly (required)
- **A comparison table** of the major approaches: raw provider SDK; provider agent SDKs; orchestration frameworks (LangGraph, CrewAI, Autogen, Agents SDK, Pydantic AI, and others current at the research date); durable-execution engines (Temporal-style); and eval/observability tooling (LangSmith, Braintrust, Langfuse, Phoenix, and others). Columns: what it actually gives you, what it hides, lock-in, debuggability, maturity, when to choose it.
- **The case for no framework** — argued properly, with a worked example of how small a competent agent loop is.
- **Vector stores, serving runtimes, and gateway/proxy layers** — enough to choose, not a product catalogue.
- **How to evaluate a new tool in this space** in a week, given how fast it churns.

### Part 5 — The learning path (required)
- **A staged plan** — roughly: foundations → a first agent with no framework → tools and structured output → evals → retrieval and memory → production concerns → security → scale. For each stage: what to understand, what to build, and the falsifiable check that tells you the stage is done.
- **A project ladder — 6 to 8 projects, in order, each with a stated learning objective, an acceptance test, and the specific failure the project is designed to teach.** These should be genuinely buildable by one person. This section should be concrete enough to follow without further research.
- **What to read** — 15–25 items: papers (ReAct, Toolformer, Reflexion, Tree of Thoughts, the long-context degradation work, agent-benchmark papers), specifications, official documentation sets, and a small number of genuinely good engineering write-ups. Each with author/title, venue or publisher, year, and **one line on what it teaches and where it is out of date or overstated.**
- **How to stay current without drowning** — a small, named set of sources and a sane cadence. Be specific about which sources are signal.

### Part 6 — Getting hired (required, but keep it proportionate)
- **What the job market actually asks for**, drawn from real job postings at the research date — required skills, common titles, and adjacent titles. Cite postings or aggregators; where compensation data is quoted, name the source and its methodology, and give ranges rather than a headline number.
- **Portfolio over credentials** — what a convincing portfolio project looks like, specifically: it has evals, it has a trace, it handles failure, and it states its own limitations.
- **Interview reality** — the kinds of questions actually asked (system design for an agent, debugging a bad trajectory, eval design, cost reduction, prompt-injection threat modelling), with **12–18 sample questions and model answers or answer outlines.** Cross-reference the interview-question folders in this repo for format (`tasks/18-ios-interview-questions/`, `tasks/19-swift-swiftui-interview-questions/`, `tasks/20-swift-concurrency-interview-questions/`, `tasks/21-swiftui-interview-questions/`) — match their structure, do not restate their content.

### Part 7 — What is genuinely unsettled (required)
Separate from the rest, and clearly labelled. Honest open problems and live disagreements: whether prompt injection is solvable at all; whether multi-agent architectures pay for themselves; whether long-context models obsolete RAG; whether reasoning models change agent design fundamentally; how much of current agent capability is benchmark contamination; whether frameworks are net-positive; how much of this stack survives the next model generation. **Present the disagreement; do not resolve it for the reader.** Also include a short list of widely-repeated claims that are wrong, and why.

## Required structure of `output.md`
1. **Title + scope line** — coverage, the date the research was performed, and an explicit note that model-specific details change quickly and must be re-verified against official docs.
2. **How to read this** — the evidence-tier convention and the five-part concept template.
3. **TL;DR** — 12–15 bullets. At least three must be things commonly believed that are wrong.
4. **Part 1 — what the job is.**
5. **Part 2 — prerequisites and the skill floor.**
6. **Part 3 — the concept map**, clusters A–K, each concept in the five-part format. Open the part with a **one-page index of every concept covered**, so the report is usable as a checklist.
7. **Part 4 — the stack**, including the comparison table.
8. **Part 5 — the learning path**, including the project ladder table and the reading list.
9. **Part 6 — getting hired**, including the interview questions.
10. **Part 7 — open problems and common misconceptions.**
11. **A one-page concept checklist** — every concept as a bare checkbox list, for self-assessment.
12. **Glossary** — every term of art used, one line each.
13. **Sources** — author/title, publisher, URL, publication or access date, and evidence tier.

## Rules & cautions
- **Accuracy over completeness.** Do not fabricate paper titles, authors, benchmark numbers, API parameters, framework features, or company practices. A shorter verified report beats a padded one.
- **Do not state model identifiers, context limits, pricing, or rate limits from memory.** Either cite the provider's own documentation with an access date, or describe the pattern without the number. Where a figure is quoted, mark it as a point-in-time value.
- **Be provider-neutral in the concepts, specific in the citations.** The concept map should hold regardless of which model is behind it; where a capability is provider-specific, say which provider and cite it.
- **Explain mechanisms, not vibes.** Any concept that cannot be described in terms of what enters and leaves the context window should be flagged as such.
- **Show the negative results.** Where research found a technique does not help, or helps only under narrow conditions, report that with equal prominence.
- **Security content is defensive.** Explain prompt injection and exfiltration mechanisms at the level needed to defend against them; do not write deployable attack payloads or evasion recipes.
- **No "agents will replace engineers" editorialising**, in either direction. Where capability claims are made, tie them to a measured result.
- If web access is unavailable or a claim cannot be verified, say so explicitly and list what was attempted — an honest gap is a correct output.
- **Cross-references** — `tasks/27-startup-building-speechify-like-app/` (a worked product build), `tasks/23-solana-smart-contract-tutorial/` (tutorial format in this repo), and the iOS/Swift interview folders listed above. Reference by path; do not restate their content.

## Style
- ~6,000–8,000 words plus tables, the concept index, and sources.
- **Plain, technical, sceptical tone** — written for an experienced software engineer deciding whether and how to move into this work. No hype, no motivational register, no second person cheerleading.
- Use short code or message-trace sketches where they clarify a mechanism (a tool-call round trip, a compaction step, an eval assertion). Keep them minimal and language-agnostic where possible; Python or TypeScript where not.
- Use tables wherever the material is comparative (frameworks, failure taxonomy, eval types, project ladder, reading list, job-market data).
- Mark uncertain or fast-moving facts inline with their tier and date — e.g. "(A, provider docs, accessed 2026-09)".
- Where a popular technique is not worth it, say so and show why. A section that recommends "don't" is a legitimate outcome.
- Use clear section headings matching the structure above.

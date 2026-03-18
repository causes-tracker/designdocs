# Architecture Decision Records

Decisions extracted from [Raw-Discussion.md](Raw-Discussion.md), [Manifesto.md](Manifesto.md), and [Design-Choices.md](Design-Choices.md).
Each record follows the format: **context → decision → status → consequences**.

---

## ADR-001: Distributed and replicated data model

**Status:** Accepted

**Context:** A centralised model is simpler to build but prevents offline use, private/behind-firewall deployments, and integration with external data sources (crash databases, downstream trackers).
The team had extensive experience with Launchpad's centralised model and its limitations.

**Decision:** Support both distributed and replicated operation.
Not all data sets need to be replicated everywhere (e.g. crash reports may be too voluminous), but the architecture must accommodate local repositories that sync with a remote.

**Consequences:** Increased implementation complexity.
Conflict resolution and eventual consistency must be designed in from the start.
Enables offline-first operation and private deployments without a separate codebase.

---

## ADR-002: Signs / Symptoms / Plans separation

**Status:** Accepted

**Context:** Traditional bug trackers conflate machine-gathered crash data (signs), human-reported issues (symptoms), and proposed fixes (plans) into a single "bug" entity.
This causes friction: duplicating two symptoms because they share a fix loses the ability to triangulate the problem if the fix turns out to be wrong.

**Decision:** Model these as three distinct entity types.
Signs are machine-oriented and typically processed in aggregate.
Symptoms are human-authored and discussion-heavy.
Plans are developer-authored proposals for change, linked to one or more signs or symptoms.

**Consequences:** Richer data model but more cognitive overhead for users new to the system.
The UI must guide users to the right entity type.
See Manifesto.md for the full rationale.

---

## ADR-003: No hard dependencies on proprietary or hosted-only web services

**Status:** Accepted

**Context:** The project must support private/air-gapped deployments.
Any dependency on an external hosted service (e.g. a specific SMTP relay, a cloud push service) would prevent this.

**Decision:** Only use components for which a fully offline or self-hosted implementation exists.
The reference implementation must be deployable with no external service dependencies beyond standard protocols (HTTP, SMTP).

**Consequences:** Excludes some convenient hosted services.
Pushes toward standard protocols (WebSub, Atom, SMTP) over proprietary APIs.

---

## ADR-004: API-first; CLI builds on the same API

**Status:** Accepted

**Context:** Keeping the CLI and HTTP API as separate code paths leads to divergence and duplication.

**Decision:** The CLI is a client of the same local HTTP API that remote clients use.
The HTTP daemon provides API services; the CLI calls it.
This keeps layers clean and makes the API a first-class deliverable.

**Consequences:** The HTTP daemon must be running for CLI operations, or the CLI must embed the same logic.
Local-only mode needs consideration.

---

## ADR-005: Open source licence

**Status:** Accepted

**Context:** The team has day jobs and no interest in competing commercially with Atlassian, GitHub, Linear, etc.

**Decision:** Apache 2.0 or MIT licence.
Final choice between them is not yet made but both are acceptable.
Contributions must be dual-licensed under both to allow downstream users to choose.

**Consequences:** No commercial restrictions.
Anyone can fork and self-host.

---

## ADR-006: Federation strategy — distribute, don't federate by default

**Status:** Accepted (with caveats)

**Context:** Full peer-to-peer federation (as in ActivityPub) is complex and hard to get right.
The team discussed whether upstream/downstream relationships (e.g. a distro tracking upstream bugs) require true federation or can be handled by asymmetric replication.

**Decision:** Default to distribution (pull everything from a remote into a local repository).
True federation (pushing selected data upstream) is supported but not the primary model.
Downstream chooses what to push upstream; upstream can pull everything if desired.

**Consequences:** Simpler than full federation.
Downstream operators have control.
Does not preclude ActivityPub-style federation in the future.

---

## ADR-007: Push notifications via WebSub (formerly PubSubHubbub)

**Status:** Accepted — _review recommended_

**Context:** The original design used PubSubHubbub (PSHB) for server-to-server push and websockets for browser clients, via a stateless proxy daemon.

**Decision:** Use WebSub (the W3C standardisation of PSHB, Recommendation 2018) for server-to-server content push.
Use websockets for browser clients.
A stateless proxy daemon subscribes to WebSub feeds and delivers events to connected browser clients.

**Consequences:** WebSub is a W3C standard but has limited adoption outside the IndieWeb community.
Review whether Server-Sent Events (SSE) better fits the browser-client use case (simpler, unidirectional); ADR-009 has since adopted SSE for browser updates.
Webhooks are now more widely understood than WebSub for server-to-server push and may be a more pragmatic choice.

---

## ADR-008: Language / stack — OPEN

**Status:** Open — decision required before implementation

**Context:** Discussions in 2012–2013 mentioned Haskell, Clojure, Python, and PyPy as possibilities.
No decision was recorded.
The `.gitignore` in this repo suggests Haskell/Cabal was considered at some point.

**Decision:** _Not yet made._

**Options to consider:**

- **Python** (broad contributor base, good web frameworks, fast prototyping)
- **Go** (easy deployment as a single binary, strong concurrency story, good for API servers)
- **Rust** (performance, safety, single binary — but steeper learning curve)
- **Haskell** (original preference of some contributors — strong type safety, but small contributor pool)
- **TypeScript/Node** (large ecosystem, full-stack possibility)

**Criteria:** Easy for contributors to onboard, produces easily-deployed binaries or containers, has mature web framework and test ecosystem.

---

## ADR-009: API specification format — Protobuf

**Status:** Accepted — reversible (2-way door)

**Context:** The design specifies a RESTful JSON API.
Protobuf provides a language-agnostic schema with strong typing and multi-language code generation, which fits the distributed, multi-implementation nature of the project.
Because components may be implemented in different languages (see ADR-008), the proto definition is the contract at component boundaries — language is an implementation detail per component.

**Decision:** Define the API in `.proto` files.
Generate an OpenAPI spec as a published artifact via `protoc-gen-openapi` for third-party integrations and documentation.
Use Server-Sent Events (SSE) for real-time browser updates — SSE is native in all browsers, requires no client library, and has built-in reconnect; it is the right tool for this concern regardless of the RPC framework.
The choice of server-side RPC framework (Connect, grpc-gateway, tonic, etc.) is left to ADR-008 once the backend language is known.

**Consequences:** Component boundaries defined by proto services make per-component language rewrites possible without changing callers.
Browser streaming is handled by SSE, sidestepping gRPC/Connect streaming complexity in the browser.
OpenAPI is a generated artifact, not the source of truth.
If a specific RPC framework proves problematic, proto definitions remain valid and the framework can be swapped.

---

## ADR-010: Security model — OPEN

**Status:** Open — must be resolved before any public deployment

**Context:** The original docs have no mention of authentication, authorisation, or security hardening.
For a system that can hold private bug data (e.g. security vulnerabilities), this is a critical gap.

**Decision:** _Not yet made._
Areas to define:

- Authentication: OAuth 2.0 / OIDC for browser users; API tokens for CLI and service-to-service
- Authorisation: role-based (user / developer / project admin) with per-repository ACLs
- Transport: HTTPS mandatory for any networked deployment
- Security disclosure workflow: private plans/symptoms visible only to authorised parties until disclosed

---

## ADR-011: Build system — Bazel + BuildBuddy

**Status:** Accepted

**Context:** The repository will contain at least three distinct build targets: a TypeScript web UI, a CLI (command-line API client), and a backend server in a memory-safe systems language (Go or Rust, per ADR-008).
Builds must work efficiently on developer machines (Windows, macOS, Linux) and in CI (GitHub Actions).
Remote caching is required to keep CI fast as the codebase grows.
The system must remain usable by both human contributors and AI coding agents.

Options evaluated: Bazel + BuildBuddy, Buck2, Nx, Moon, Earthly, Gradle.
Earthly was abandoned by its maintainers in mid-2025.
Gradle has no genuine build-graph support for Go or Rust.
Buck2 has a small external community and no managed caching offering.
Moon (v2.0, February 2026) has first-class polyglot support but only ~79 contributors versus Bazel's 1000+; too new for a project that values stability.
Nx is well-suited to TypeScript-primary monorepos but has no Rust plugin as of early 2026.

**Decision:** Use [Bazel](https://bazel.build) as the build system with [BuildBuddy](https://www.buildbuddy.io) for remote caching and build observability.
Use [Bazelisk](https://github.com/bazelbuild/bazelisk) to pin and auto-install the correct Bazel version — contributors never install Bazel directly.
Use [Gazelle](https://github.com/bazel-contrib/bazel-gazelle) to auto-generate and maintain `BUILD` files for Go targets (eliminates the main maintenance burden for Go).
Use `rules_ts` for TypeScript and `rules_rust` for Rust if Rust is chosen (ADR-008).

**Windows strategy:** `rules_rust` disables its own Windows CI tests due to lack of maintainer expertise.
Windows developers building Rust targets must use a Dev Container (VSCode Remote Containers or GitHub Codespaces) which provides a Linux environment.
Windows developers working only on TypeScript targets may build natively.
If the backend language decision (ADR-008) lands on Go rather than Rust, the Windows constraint disappears — `rules_go` is CI-tested on Windows.

**Remote caching:** BuildBuddy free tier (10 users, 100 GB cache transfer/month, up to 80 remote execution cores) is sufficient for early development.
Self-hosted `bazel-remote` is an alternative if the free tier is outgrown or data residency is a concern.

**Consequences:** Bazel's hermetic, reproducible builds make CI reliable and agent-friendly — any machine produces identical outputs.
BUILD file authoring has a learning curve; Gazelle reduces this significantly for Go.
`MODULE.bazel` (bzlmod) is the current dependency management approach; some rulesets still have rough edges with bzlmod.
If scale demands it in future (remote execution, very large codebase), the same Bazel infrastructure scales without a migration.

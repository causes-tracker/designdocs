# Causes — Design Documentation

Causes is a bug tracker designed to free developers from the tedium of manual bug gardening.
It models defects as the interaction between four entities: a **project timeline**, **signs** (machine-observed anomalies), **symptoms** (human-reported issues), and **plans** (intended changes).
See [Manifesto.md](Manifesto.md) for the full concept.

This directory contains all design documentation.
No implementation code lives here yet.

## Documents

| File | Description |
| --- | --- |
| [Manifesto.md](Manifesto.md) | Core vision, feature rationale, architecture overview, and prior art |
| [Design-Choices.md](Design-Choices.md) | Technical design decisions (data model, protocols, UI layer) |
| [Decisions.md](Decisions.md) | Architecture Decision Records (ADRs) — distilled from discussions |
| [Raw-Discussion.md](Raw-Discussion.md) | Historical: raw IRC logs and braindumps from 2012–2013 |
| [Contributing.md](Contributing.md) | How to contribute to the design docs and (eventually) the code |

## Quick orientation

* **New to the project?** Read [Manifesto.md](Manifesto.md) then [Design-Choices.md](Design-Choices.md).
* **Want to understand why a decision was made?** Check [Decisions.md](Decisions.md).
* **Curious about the original discussions?** See [Raw-Discussion.md](Raw-Discussion.md).
* **Want to contribute?** See [Contributing.md](Contributing.md).

## Status

Design-only.
Implementation has not started.
The language and stack are not yet decided — see the open ADR in [Decisions.md](Decisions.md).

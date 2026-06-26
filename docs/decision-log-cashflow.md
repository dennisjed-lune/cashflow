# Decision Log — Cashflow Module

Material product decisions, assumptions, conflicts, and overrides for the
Cashflow PRD (`prd-cashflow.md`). Newest first.

---

## 2026-06-17 — PRD authored from the cashflow spec

**Context:** Expanded the thin draft PRD into a design-ready PRD package, sourced
primarily from `opportunity-brief-cashflow.md` and `prd-lite-cashflow.md`.

### Decisions

- **D-01 — Scope is cashflow only.** No Expenses content, and no linkage between
  the modules. Confirmed explicitly by the user ("not expenses — only cashflow").
  The Expenses prototype is reused as a *visual style reference only*.
- **D-02 — Three-screen perimeter:** upgraded Landing → Outflow view + Inflow
  view, reached by push navigation. Matches the opportunity brief's narrowest
  wedge.
- **D-03 — Asymmetric metrics by design.** Inflow is organised by *type* with
  source/regularity/stability and **no brands**; Outflow is a money-movement lens
  (total out, over time, net vs inflow) with only a **high-level**
  category/brand summary. Encoded as separate value slices (VS-2, VS-3).
- **D-04 — Outflow is not the Expenses drill.** The high-level summary is capped
  at "glance" depth; no category→brand→transaction drill. Made an explicit
  distinctiveness guardrail in the design handoff (FR-6).
- **D-05 — Historical only.** Forecasting/projection held out of scope for this
  slice (timelines are historical).
- **D-06 — Build a prototype next.** After this PRD, build a `Cashflow.html`
  prototype (landing → Outflow + Inflow) matching the Expenses design system.

### Assumptions recorded

- **A-01 (gating)** — transaction classification (income/government/transfer-in/
  other-outflow) is reliable enough for distinct metrics. Flagged as blocker
  B-01; validate via an early data-feasibility spike.
- **A-02** — recurring inflows and an income-stability signal are detectable.
- **A-03** — SDK is white-labelled; visuals must use neutral themeable tokens.
- **A-04** — primary user is the bank's consumer end-customer.
- **A-05** — AED/UAE is the reference market for the prototype.

### Status

`draft`. Not handoff-ready: blocker **B-01** (classification feasibility) is
open. Non-blocking follow-ups OQ-01..05 recorded in the PRD.

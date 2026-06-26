---
title: Cashflow Module — Liquidity Lens
status: draft
created: 2026-06-09
updated: 2026-06-17
changelog: |
  2026-06-17 — Expanded thin draft into design-ready PRD: added Source Inputs, Value Slices (VS-1..3), globally-stable FRs with acceptance outcomes, user journeys, cross-cutting requirements, design + architecture handoff, assumptions index, and blockers/follow-ups. Scope held to cashflow only — no Expenses content or linkage.
parent: opportunity-brief-cashflow.md
---

# PRD: Cashflow (Lune SDK)

## Source Inputs

- `opportunity-brief-cashflow.md` — framing, user, problem, the Outflow-is-not-Expenses distinction, non-goals, assumptions, unknowns (primary spec)
- `prd-lite-cashflow.md` — condensed scope and success signal
- Design reference: `../../../ux/Expenses.html` — **visual system only** (Plus Jakarta Sans, AED/UAE conventions, deep-teal accent, rounded cards, push navigation, canonical Lune category taxonomy + hues). No content or linkage is shared; Cashflow is a separate module.
- Context: the Cashflow module is **live with clients today as a single landing screen** showing inflow vs outflow with no drill-down.

---

## Product Alignment

### User / Customer

**Primary user:** the bank/fintech's **end-customers** (everyday consumers) using the embedded PFM experience inside their banking app. Comfortable reading a balance; not financially sophisticated. They want a fast, glanceable answer to "am I okay this month?"

**Buyer / beneficiary:** Lune's **clients** (banks and fintechs) who integrate the SDK and already ship this module. They want their app to feel modern and complete next to competitors.

### Problem

Banking apps tell a customer their **balance** but not their **cashflow**. Today the Cashflow module is one screen deep: it contrasts inflow vs outflow but offers no way to go deeper into either side. That single undifferentiated landing cannot answer either real question, because **inflow and outflow are different kinds of thing**:

- **Inflow** = income + government payments + transfers in. It has **no brands**; what matters is **source, regularity, and income stability**.
- **Outflow** = all money leaving the account (bills, transfers out, large movements). What matters is **total out, timing, and net position vs inflow** — money *movement*, seen at a glance.

A layout that serves one side cannot serve the other, and there is currently no view for either.

### Why It Matters

- **For end-customers:** Cashflow is the headline "am I net positive this month, and where is my money flowing?" surface. Done well, it gives a sense of control a raw balance never can.
- **For bank clients:** The module is already in customers' hands but only one screen deep. Giving it real depth raises the perceived quality of the whole SDK; leaving it thin makes the PFM offering look incomplete next to competitors.
- **Timing:** It is live but shallow now — the right moment to get the Inflow/Outflow model correct before more is built on the thin version.

### Evidence

- `User-stated`: Cashflow is live with clients as a single landing page showing inflow vs outflow.
- `User-stated`: Tapping Inflow/Outflow should open dedicated views (per the Cashflow & Expenses wireframes v1); these don't exist yet.
- `User-stated`: Inflow = income + transfers (no brands) and needs different metrics than Outflow.
- `User-stated`: Cashflow Outflow is a different product from Expenses; the modules are separate and unconnected.
- `Assumption`: Transaction data can distinguish income vs government vs transfer vs other-outflow reliably enough to drive distinct metrics. [ASSUMPTION: A-01]
- `Assumption`: Recurring-income / regularity can be detected well enough to show a stability signal. [ASSUMPTION: A-02]
- `Assumption`: The SDK is themed per client (white-label), so visuals must use neutral, themeable tokens. [ASSUMPTION: A-03]

### Goals

1. Let a customer answer **"am I net positive this period?"** at a glance on the landing.
2. Give **Outflow** a purpose-built money-movement view (total out, over time, net vs inflow, high-level category/brand summary).
3. Give **Inflow** a purpose-built view organised by **type** (income, government services, transfers, …) with **source / regularity / stability** insight and **no brands**.
4. Keep Outflow legible as money movement — explicitly **not** the deep Expenses optimisation drill.
5. Make the experience themeable so any client bank can brand it.

### Non-Goals

- Any connection to, linkage with, or merging into the **Expenses** module. Cashflow is standalone.
- The deep category → brand → transaction **optimisation drill** — that is Expenses' job. Outflow's category/brand summary stays high-level only.
- **Forecasting / projection.** Timelines are historical.
- **Brand-level analytics on the Inflow side** (income has no brands).
- Multi-account aggregation, budgeting/goals, and notifications (not this slice).

### Success Metrics / Signals

- **Comprehension (primary, prototype-testable):** a user lands on Cashflow and correctly reads **net position + income steadiness within seconds**.
- **Distinctiveness:** in testing, a user taps Outflow and describes a **money-movement story** (how much left, when, net vs inflow) that is clearly *not* an Expenses category breakdown; and taps Inflow to get **source/regularity** insight an outflow-style layout couldn't provide.
- **Adoption:** repeat use of the Inflow/Outflow views within partner banks' apps after rollout.

---

## Solution Alignment

### Product Perimeter

Three connected mobile screens reached by **push navigation** from the existing landing:

```
Cashflow Landing  ──tap Outflow──▶  Outflow view
       │
       └────────tap Inflow───────▶  Inflow view
```

In scope: the landing (upgraded), the Outflow view, the Inflow view, a shared date-range control, and themeable visuals. Out of scope: everything in Non-Goals.

### Value Slices

- **VS-1 — Net position at a glance (Landing).** The customer sees money in vs money out vs net for the period and can enter either side.
- **VS-2 — Outflow as money movement.** A dedicated view answering "how much left, when, and am I net positive?" with high-level category/brand summary.
- **VS-3 — Inflow as income insight.** A dedicated view answering "where does my money come from and how steady is it?" organised by type, no brands.

---

### VS-1 — Net Position at a Glance (Landing)

**FR-1 — In / Out / Net summary.** The landing shows, for the selected period: total **money in**, total **money out**, and **net** (in − out), with net clearly signed (positive/negative) and colour-reinforced.
- Acceptance: with in > out, net renders positive and visually "healthy"; with out > in, net renders negative; the three figures are mutually consistent (net = in − out) for the selected range.

**FR-2 — Cashflow timeline.** The landing shows a historical timeline contrasting inflow and outflow across recent periods so the customer sees the trend, not just one number.
- Acceptance: timeline reflects the selected range; inflow and outflow are visually distinguishable; no projected/future values are shown.

**FR-3 — Entry points to Inflow and Outflow.** The landing provides two clear, tappable entry points — Inflow and Outflow — each opening its dedicated view via push navigation.
- Acceptance: tapping Inflow opens the Inflow view (VS-3); tapping Outflow opens the Outflow view (VS-2); a back affordance returns to the landing.

---

### VS-2 — Outflow as Money Movement

**FR-4 — Total out + net vs inflow.** The Outflow view shows **total money out** for the period and its **net relationship to inflow** (e.g. out vs in, and resulting net).
- Acceptance: total out matches the landing's "money out" for the same range; the net-vs-inflow framing makes it obvious whether outflow exceeded inflow.

**FR-5 — Outflow over time.** The view shows outflow across recent periods so the customer sees how their outgoings move.
- Acceptance: chart values are legible (not decorative); reflects the selected range; historical only.

**FR-6 — High-level category/brand summary.** The view surfaces a **glanceable** top-categories (and optionally top-brand) summary of where money went — explicitly capped at summary depth, with **no** drill into category → brand → transactions.
- Acceptance: a small ranked summary (top categories by amount) is shown; tapping a category does **not** open an Expenses-style drill; the depth reads as "glance," not "optimise."

**FR-7 — Outflow transaction list.** The view lists outflow transactions for the period (merchant/source, date, amount shown as money leaving).
- Acceptance: amounts render as outgoing (signed/coloured per the SDK convention); list respects the selected range; a missing logo shows a clean monogram/icon, never an error glyph.

---

### VS-3 — Inflow as Income Insight

**FR-8 — Breakdown by type.** The Inflow view organises inflow by **type** — income, government services, transfers (in), and other inflow categories — **not** by brand.
- Acceptance: each inflow type shows its total and share of inflow; no brand-level breakdown appears anywhere in this view.

**FR-9 — Source & regularity.** The view surfaces **top income sources** and a **regularity/recurrence** signal (e.g. which inflows recur and how often).
- Acceptance: recurring inflows are distinguishable from one-off inflows; top sources are ranked by amount.

**FR-10 — Income stability over time.** The view shows an **income-stability** signal across recent periods (how steady inflow has been).
- Acceptance: stability is shown over the selected/recent range and is historical; the signal makes "steady vs erratic" income legible at a glance.

**FR-11 — Inflow transaction list.** The view lists inflow transactions (source, date, amount shown as money arriving).
- Acceptance: amounts render as incoming; list respects the selected range; sources without a logo show a clean monogram/icon.

---

### Cross-Cutting Requirements

**FR-12 — Date-range selection.** A date-range control appears on every screen (landing, Outflow, Inflow) and drives all figures, charts, and lists. Changing it on one screen carries through the flow.
- Acceptance: a date-range pill is present and tappable on all three screens; changing the range updates summary figures, timelines, and lists consistently.

**FR-13 — White-label theming.** All colour, type, and accent usage flows from neutral, themeable tokens so a client bank can rebrand the module without layout changes. [ASSUMPTION: A-03]
- Acceptance: swapping the accent token re-themes accents across all three screens without breaking legibility or layout.

**FR-14 — Localisation & currency.** Currency (AED for the reference market) and number/date formatting follow the host locale; the layout tolerates mixed English/Arabic source names.
- Acceptance: amounts and dates render in the configured locale; long/mixed-script names do not break rows.

**FR-15 — Accessibility & motion.** Charts pair colour with text values (no colour-only meaning); transitions respect reduced-motion preferences.
- Acceptance: every chart value is readable as text; with reduced-motion set, slide/animation is suppressed.

**FR-16 — Empty / sparse data.** Each view degrades gracefully when a period has little or no inflow/outflow data.
- Acceptance: an empty period shows a clear empty state, not a broken chart or a misleading zero.

---

### User Journeys

**UJ-1 — "Am I okay this month?" (VS-1).** Customer opens Cashflow → reads in / out / net for the current period → sees net is positive (or not) and glances at the timeline trend → done in seconds, or taps in for more.

**UJ-2 — "Where did my money go and am I net positive?" (VS-1 → VS-2).** From the landing, customer taps **Outflow** → sees total out, outflow-over-time, and net vs inflow → scans the high-level category summary → optionally scrolls the transaction list → backs out. Crucially, they do **not** fall into a category→brand→transaction drill.

**UJ-3 — "Where does my money come from and is it steady?" (VS-1 → VS-3).** From the landing, customer taps **Inflow** → sees breakdown by type (income/government/transfers), top sources, recurrence, and an income-stability signal over time → understands their income picture in a way an outflow-style layout could not show.

**UJ-4 — Compare periods (FR-12).** On any screen, customer taps the date-range pill, picks a different range, and every figure/chart/list updates to that range.

---

## Handoff

### Design Handoff

- **Platform & form factor:** mobile (iOS-first), embedded inside a host banking app. Single-column, thumb-reachable, push navigation (each level slides in; back returns). Not stacked modals.
- **Visual system (reuse from the Expenses prototype as a sibling, not its content):** Plus Jakarta Sans; generous white space; rounded cards; one calm accent (deep teal/green) drawn from a **themeable token**; category accent hues used sparingly from the canonical Lune taxonomy.
- **Money sign convention:** outflow shown as money leaving (minus/red per SDK convention); inflow shown as money arriving (positive). Keep consistent with the rest of the SDK.
- **Charts:** legible values always — ranked summaries or labelled bars over decorative donuts. Outflow's category/brand summary must look deliberately *shallow* (a glance), to read as distinct from Expenses.
- **Logos:** missing merchant/source logos render as a clean circular monogram or neutral icon — never an error/warning glyph.
- **Distinctiveness guardrail:** the Outflow view must not visually invite a deep drill. No "tap category → brands → transactions" affordances.
- **States to design:** loading, empty/sparse period, negative-net (out > in), single-source income, very long/Arabic source names.
- **Next step:** route to `author-ux` (or `explore-ux` if comparing landing/Outflow chart directions) to produce the UX spec before/with the prototype.

### Architecture / Engineering Handoff (product-facing)

- **Critical data dependency (gating):** distinct metrics on both sides require classifying transactions into **income vs government vs transfer-in vs other inflow**, and **outflow movement types**. Validate classification quality **early** as a spike — if it's weak, it gates VS-2 and VS-3. [ASSUMPTION: A-01]
- **Recurrence detection:** FR-9/FR-10 depend on detecting recurring inflows and a stability signal from available transaction history. [ASSUMPTION: A-02]
- **Reuses existing module:** Cashflow is already live (the landing). This builds on it; it must not introduce a dependency on or shared state with the Expenses module.
- **Theming:** consume neutral design tokens so per-client white-label theming works without code branches. [ASSUMPTION: A-03]
- **Data is historical only** — no forecasting/projection services needed for this slice.

### Launch / Readiness

- Module is already shipped (thin landing); this is an expansion, so rollout can be incremental per client. Flag the classification-quality spike as the gating pre-launch check. Detailed GTM is out of scope for this PRD.

---

## Assumptions Index

- **A-01** — Transaction data can reliably classify income vs government vs transfer-in vs other-outflow well enough for distinct Inflow/Outflow metrics. *(Gating; validate via spike.)*
- **A-02** — Recurring inflows and an income-stability signal can be detected from available history.
- **A-03** — The SDK is white-labelled per client; visuals must use neutral, themeable tokens.
- **A-04** — Primary user is the bank's consumer end-customer (not an analyst or bank staff).
- **A-05** — AED / UAE is the reference market for the prototype; the design generalises to other locales.

---

## Open Questions

### Blockers Before Handoff

- **B-01 (A-01):** How reliably can transactions be classified into income / government / transfer-in / other-outflow on real client data? This gates both VS-2 and VS-3. Resolve via an early data-feasibility spike.

### Non-Blocking Follow-Ups

- **OQ-01:** Exactly what the current live landing screen shows today (totals only? a timeline? insights?) — confirm so VS-1 builds on it rather than replacing it blindly.
- **OQ-02:** Which Outflow metric leads — total out, outflow-over-time, or net-vs-inflow? (Order/emphasis; refine in UX.)
- **OQ-03:** Which Inflow signal leads — top sources, recurrence, or stability-over-time?
- **OQ-04:** How is "income stability" defined and computed (variance band, streak of regular deposits, etc.)?
- **OQ-05:** Date-range presets to offer (this month, last 3 months, custom?).

---

## Glossary

- **Inflow** — money arriving: income, government payments, transfers in. No brands; characterised by source, regularity, stability.
- **Outflow** — money leaving: bills, transfers out, purchases, large movements. Characterised by magnitude, timing, and net position vs inflow.
- **Net position** — inflow minus outflow for a period; the "am I okay this month?" number.
- **Liquidity lens** — Cashflow's framing: money movement and net position, distinct from spending optimisation.
- **The depth line** — Outflow shows category/brand *at a glance*; the deep category→brand→transaction drill belongs to the separate **Expenses** module.

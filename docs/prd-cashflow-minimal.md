---
title: Cashflow — Minimal PRD
status: draft
created: 2026-06-30
parent: opportunity-brief-cashflow.md
built_on: PRODUCT.md (Lune platform spec), Cashflow.dc.html (current prototype)
---

# PRD: Cashflow (Lune SDK) — minimal

A one-page PRD anchored to the Lune product spec. For the full design-ready
package see `prd-cashflow.md`; for scope/stories see `prd-lite-cashflow.md`.

## Where it sits in the product

Lune is a real-time transaction-intelligence platform: it enriches raw
transactions (clean merchant names, logos, categories, source identity) and
exposes that through its products — **Enrich**, **Target**, **Engage** (embedded
PFM), and **Pulse**. **Cashflow** is a module inside the embedded PFM: the
*liquidity lens* a bank ships to its end-customers. Enrichment is the input;
Cashflow is one read-only surface that turns it into a glanceable answer.

It is a **separate product from Expenses**. Cashflow answers *"am I net positive,
and where is my money flowing?"*; Expenses is the deep category→brand→transaction
optimisation drill. The line is **interaction depth, not topic** — in Cashflow,
taps never open a drill.

## Problem

Banking apps show a **balance**, not a **cashflow**. The module is live with
clients but only one screen deep (inflow vs outflow), with no way into either
side — and inflow and outflow are different kinds of thing, so one undifferentiated
screen serves neither well.

## Users

- **Primary:** the bank/fintech's **end-customers** — everyday consumers, not
  financially sophisticated, wanting a fast "am I okay this month?" read.
- **Beneficiary:** Lune's **bank/fintech clients**, who already ship the module
  and want it to feel complete next to competitors.

## Scope (three screens + period control)

1. **Landing** — money in vs out vs **net** for the selected period (in/out donut,
   net figure), enriched insights, link to a historical timeline.
2. **Outflow** — money-movement lens: total out, over time, **net vs inflow**, and
   a **high-level** category/brand summary (glance only — *not* the Expenses drill).
3. **Inflow** — broken down by **type** (income, government, transfers…) with
   source, regularity, and income-stability signals; **no brands**.
4. **Period control** — preset ranges (this/last month, last 3/6 months, this year)
   **plus a custom-date calendar range picker**; the selected range labels every
   screen.

## Key requirements

- **FR-1** Landing shows in / out / net for the active period.
- **FR-2** Outflow and Inflow are reachable by push navigation and back.
- **FR-3** Outflow is a money-movement story (total, timing, net vs inflow); its
  category/brand summary is capped at glance depth — no drill-through.
- **FR-4** Inflow is organised by type with source/regularity/stability; brand-free.
- **FR-5** Period selection (preset or custom range) updates the date label across
  all screens; future dates are not selectable.
- **FR-6** Enrichment (clean names, logos, categories, source) is read-only
  throughout — a glance, never a tap-through.
- **CC-1** White-label: neutral, themeable tokens (light/dark + accent); no Lune
  brand chrome. **CC-2** AED/UAE is the reference market. **CC-3** Historical only.

## Out of scope

Any link to or merge with Expenses · the deep category→brand→txn drill ·
forecasting/projection · brand-level analytics on inflow.

## Dependency / risk

**B-01 (blocker):** Inflow's distinctive metrics depend on reliably classifying
transactions (income vs government vs transfer vs other outflow) and detecting
recurrence/stability. Validate with an early data-feasibility spike — if weak, it
gates the Inflow view (total-in stays real; the breakdown is mock until resolved).

## Success signal

In testing, a user taps **Outflow** and reads a money-movement story (how much
left, net vs inflow) that is clearly *not* the Expenses breakdown, and taps
**Inflow** to get source/regularity insight an outflow-style layout couldn't give.

## Current state

Prototype `Cashflow.dc.html` implements all three screens, the preset + custom
calendar range picker, light/dark + accent theming, and enriched insights. Inflow
breakdown metrics are mock pending **B-01**.

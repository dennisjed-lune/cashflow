---
title: Cashflow Module — Liquidity Lens (Inflow / Outflow)
status: draft
---

# Opportunity Brief: Cashflow Module

## Raw Idea
The Cashflow module in the Lune SDK is live with clients but is only **one
screen** — a single landing page showing the difference between inflow and
outflow. Tapping Inflow or Outflow should open dedicated views, but those don't
exist yet. Build them out: a proper Inflow view and a proper Outflow view, each
with metrics that fit what it actually is. Cashflow is a fully separate module
from Expenses — different place in the SDK, no link between them.

## Classification
Improvement / build-out. The entry point is live but shallow (one summary
screen); the depth behind Inflow and Outflow is missing.

## User/Customer
Primary: the bank/fintech's **end-customers** (consumers) using the embedded PFM
experience. Beneficiary: Lune's **clients** (banks), who already ship this module.

## Cashflow Outflow Is Not Expenses
This is the central point. Both involve money leaving the account, but they are
different products answering different questions:
- **Cashflow Outflow = money-movement / liquidity.** All money leaving the
  account (incl. transfers out, bills, large movements), seen as magnitude,
  timing, and *net position against inflow*. It *can* surface category and brand
  metrics, but **high-level only** (a glanceable summary), not a drill-down.
  Question: *"How much left, and am I net positive this month?"*
- **Expenses = spending behaviour.** The *deep* categorised, brand-level drill
  (category → category trend → brand trend → transactions), built for
  optimisation. Question: *"What am I spending on and how do I cut back?"*
The dividing line is depth, not topic: Outflow shows category/brand at a glance;
Expenses is the full optimisation drill. They live in different parts of the SDK
with no connection.

## Problem
A consumer wants to answer "is more coming in than going out, and where is my
money flowing?" Today they get a single screen contrasting inflow vs outflow with
no way to go deeper. Worse, Inflow and Outflow are not the same kind of thing —
**Inflow = income + transfers** (no brands; cares about source, regularity,
income stability), while **Outflow = all money leaving** (cares about total out,
timing, and net vs inflow). A single undifferentiated landing can't answer
either side properly. Inflow itself categorises by type — **income, government
services, transfers, etc.** — not by brand.

## Current Workaround Or Status Quo
One landing screen, live with clients, showing the inflow-vs-outflow difference
(with whatever summary/timeline framing it currently has). Functional as a
glance, but there's no Inflow view and no Outflow view to drill into.

## Stakes
Cashflow is the headline "am I okay this month" surface and it's already in
clients' hands as a single thin screen. Expanding it credibly raises the whole
SDK's perceived depth; leaving it thin makes the PFM offering look incomplete
next to competitors.

## Proposed Opportunity
Turn the single Cashflow screen into a true **liquidity lens** with two
purpose-built halves reached from the landing:
- **Outflow view** — money-movement lens: total out, outflow over time, and
  outflow vs inflow / net position, plus **high-level** category/brand summaries.
  Distinct from Expenses by depth (glance, not the optimisation drill).
- **Inflow view** — categorised by type (income, government services, transfers,
  etc.), with source / regularity / income-stability metrics (no brands).
Both reachable from the existing inflow-vs-outflow landing.

## Narrowest Wedge
Build the **two dedicated views (Inflow and Outflow) off the existing landing**,
as one coherent flow: landing → Outflow view + Inflow view, each with its own
metric set and transaction list. The slice is "make the landing's two buttons
lead somewhere real and correct." Outflow proves the money-movement lens is
distinct from Expenses; Inflow proves income needs its own metrics.

## Why Now
The module is live with clients but only one screen deep, and the Spend/Expenses
surface is being reworked in parallel — the right moment to give Cashflow real
depth and get the Inflow/Outflow model right before more is built on the thin
version.

## Evidence
- `User-stated`: Cashflow is live with clients but is currently a single landing
  page showing inflow vs outflow.
- `User-stated`: tapping Inflow/Outflow should open dedicated views (per the
  Cashflow & Expenses wireframes v1); these don't exist yet.
- `User-stated`: Inflow = income + transfers (not brands); needs different
  metrics than Outflow.
- `User-stated`: Cashflow Outflow is a totally different product from Expenses.
- `User-stated`: Cashflow and Expenses are separate, unconnected modules.

## Assumptions
- Primary user is the bank's consumer end-customer.
- Transaction data can distinguish income vs transfer (inflow side) and identify
  outflow movements (transfers/bills vs other) reliably enough for distinct
  metrics.

## Unknowns
- Exactly what the current single landing screen shows (timeline? insights?
  totals only?) — I haven't seen that UI.
- Which Outflow metrics matter most: total out, outflow timeline, net vs inflow,
  largest movements?
- Which Inflow metrics matter most: top sources, recurrence/regularity, income
  stability over time?
- How reliably can data classify income vs transfer vs other outflow?
- Does the SDK theme per-client (white-label), constraining the visual system?

## Non-Goals
- Not merging with or linking to Expenses.
- Not the deep category → brand → transaction optimisation drill — that's
  Expenses' job. Outflow keeps category/brand high-level only.
- Not building forecasting/projection in this slice.

## Success Signal
Earliest signal: in a prototype test, a user taps Outflow and reads a money-
movement story (how much left, when, net vs inflow) that is clearly *not* the
Expenses category breakdown — and taps Inflow to get source/regularity insight
that an outflow-style layout couldn't give.

## Recommendation
**prototype**, with one flagged dependency: validate the inflow/outflow data
classification (income vs transfer vs other) early as a `research`/spike, since
both views' metrics depend on it. If classification is shaky, that's the gating
risk.

## Suggested Next Artifact
A high-fidelity prototype of the landing → Outflow view + Inflow view flow, each
with its own metrics and transaction list, plus a one-page data-feasibility
check on inflow/outflow classification.

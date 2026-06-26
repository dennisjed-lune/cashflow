---
title: Lite PRD — Cashflow Module
status: draft
---

# Lite PRD: Cashflow Module (Lune SDK)

## Problem (one line)
Cashflow is live but only one screen deep (inflow vs outflow), with no way to
drill in — and inflow and outflow need different metrics to be useful.

## User Stories
- As a bank customer, I want to see money in vs money out vs net for a period, so
  I know if I'm net positive this month.
- As a bank customer, I want to open an **Outflow** view showing how much left,
  over time and against my inflow, plus a high-level category/brand summary, so I
  understand my money movement (without the full Expenses drill).
- As a bank customer, I want to open an **Inflow** view broken down by type
  (income, government services, transfers, etc.) with source and regularity
  insight, so I understand where my money comes from and how steady it is.

## In Scope
- Landing: inflow vs outflow with net position (building on the current screen).
- Outflow view: total out, outflow over time, outflow vs inflow, plus high-level
  category/brand summary + transaction list.
- Inflow view: breakdown by type, source/regularity/stability metrics, no brands,
  + transaction list.
- Date-range selection.

## Out of Scope
- Any connection to or merging with the Expenses module.
- The deep category → brand → transaction optimisation drill (that's Expenses);
  Outflow stays high-level.
- Forecasting / projection (timeline is historical).
- Brand-level analytics on the Inflow side.

## Dependency / Risk
Inflow and Outflow metrics depend on reliably classifying transactions
(income vs government vs transfer vs other outflow). Validate this early — if
classification is weak, it gates both views.

## Success Signal
In testing, a user taps Outflow and reads a money-movement story (how much left,
net vs inflow) that is clearly not the Expenses breakdown, and taps Inflow to get
source/regularity insight an outflow-style layout couldn't give.

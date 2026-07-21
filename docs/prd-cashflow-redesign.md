---
title: Cashflow Redesign — Design Handoff PRD
status: draft
created: 2026-07-21
updated: 2026-07-21
parent: prd-cashflow.md
changelog: |
  2026-07-21 (2) — Dennis resolved handoff decisions: drill depth goes to
  transaction level (supersedes parent glance-only rule); search + filters are
  in scope on the lists; Subscriptions integration removed from this PRD
  (revisit post-alpha); projected cashflow now sits behind a "Next stage"
  toggle in the prototype.
---

# Cashflow Redesign

**What this is.** The requirements for redesigning the shipped Cashflow module.
Visual source: the Figma page **"Cashflow New Implimentation"**. Behavioral
source: the working prototype **`cashflow-flow.html`** (repo root — open it,
everything below is demonstrated there). Where they disagree, the prototype
wins; the disagreements are the numbered list below. Decisions and their
reasons: `decision-log-cashflow-redesign.md`.

## The one rule

**Pick a period first; everything follows from one set of transactions.**
Every number on every screen is derived from the selected period + cards and
the same underlying transactions. Nothing is authored twice, so no two screens
can ever contradict each other (the Figma frames currently do: ₯5,760 total vs
4,326 surplus; a 23.8K donut over a 19,240 total).

## Drill depth (decided)

The journey drills to **transaction level**: Landing → Inflow/Outflow →
source/merchant → transaction detail (tags, notes, enrichment feedback). This
supersedes the parent PRD's glance-only rule for Outflow (decision D-11).

## What changes vs the Figma

1. **Date first.** The period + card selectors sit above all figures on the
   landing. Presets (This / Last month, 3 / 6 months) + a month grid with a
   year stepper. No funnel-icon detour.
2. **Trends is its own surface.** The Timeline is renamed **Trends**:
   Inflow | Outflow toggle, stacked bars in the same colors as the breakdown
   donuts, full retained history, scrollable, newest first. Tap a month → its
   split, in/out, kept, vs-average. The trend modules come **out** of the
   Inflow/Outflow sheets — one time scope per screen.
3. **The monthly breakdown cards are dropped.** The tap-a-month panel carries
   the same info. (If a glanceable net view is missed, propose a "Net" toggle
   — not a card list.)
4. **Valid month labels.** "Feb 1–28", "Jul 1–21 · so far". Never
   "Feb 1st–31st"; never a mid-month range over monthly bars. Current month is
   always marked month-to-date and excluded from lowest/average/highest.
5. **Tap affordances everywhere** something drills: chevron + press state.
6. **Empty states** for landing and both sheets, with a recovery action.
7. **Copy is period-true.** "This month / this period" only when the period
   contains today; otherwise name it ("in June"). "Last received", not
   "recieved". Raw descriptions match the merchant.
8. **Legends never truncate.** One row per group: label · share % · amount.
9. **No mixed-scope decoration.** A chart either shows the screen's own
   period or it doesn't exist (use an icon, or link to Trends). Counts always
   reconcile with lists ("Showing 12 of 16"). The in-minus-out metric has one
   name — **Total cashflow** — and negatives always show the minus sign.
10. **Search and filters, inline.** The Inflow/Outflow transaction lists get a
    search field and category/tag filter chips, presented inline on the sheet
    (not behind a funnel icon). Filtered views obey the same rules: counts
    reconcile, empty-filter results get an empty state with a clear-filters
    action.

## Rules that apply everywhere

- **Retention is law.** Banks keep 6 months, fintechs 12. Every window, label,
  and the period picker bind to the configured value. "All time" is banned.
- **Short history, loading, errors need designs** — skeletons, retry, and
  what stats do with < 3 full months. Missing from Figma today (see decisions
  needed).
- **Accessibility:** WCAG AA. Note: DS tokens `Grey/G100 #7C8186` and
  `#F02727` fail 4.5:1 for body-size text — DS team to bless AA text variants
  (prototype uses `#6B7075` / `#CC1E1E`; charts can keep DS colors).
  Keyboard + visible focus, sheets are dialogs, 44px targets, reduced motion.
- **RTL/Arabic + Dynamic Type**: not handoff-blocking, but release-blocking.

## Not in this stage

- **Projected cashflow** — validated in the prototype (hidden behind its
  "Next stage" toggle), ships next stage.
- **Subscriptions integration** (committed-spending glance, deposit-bound
  recurrence, report-subscription hand-off) — not in this PRD; revisit once
  the Lune Subscriptions alpha ships.
- Per-brand trend analytics (Expenses territory) · cancellation flows ·
  notifications.

## Decisions needed before handoff

1. **Loading / error / short-history states** (design team): skeletons,
   retry, and stats behavior with < 3 full months.
2. **Search + filter visual design** (design team): the inline pattern for
   change #10 — search field + filter chips on the sheets.
3. **Arbitrary date ranges** (Dennis + eng): the Figma implies free ranges
   ("15 Jan – 14 Jun"); the prototype ships presets + single months. Support
   free ranges (with bucketing rules) or descope.
4. **The enrichment-feedback form** (design team): the entry point exists;
   the form doesn't.

## For engineering (two lines)

One ledger per period+card scope; all aggregates, insights, and copy derived
from it — nothing pre-authored. The retention window comes from tenant config,
and search/filter operate on the same ledger the totals are computed from.

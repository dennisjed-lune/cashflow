---
title: Cashflow Redesign — Design Handoff PRD
status: draft
created: 2026-07-21
updated: 2026-07-21
parent: prd-cashflow.md
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

## Subscriptions (consume, don't build)

Lune Subscriptions v3 (handoff-ready, `~/cowork/prds/`) owns recurring
detection. Cashflow only consumes it:

- Outflow gets a read-only **committed-spending glance**: Confirmed recurring
  groups by type (subscriptions / billers / other). Likely-tier never counts
  toward headlines.
- Inflow's "your salary lands every month" binds to **deposit** groups.
- Taps hand off to the Subscriptions module's own list/detail. Cashflow builds
  no subscription list and no detection.

## Not in this stage

- **Projected cashflow** — validated in the prototype (badged NEXT STAGE),
  ships next stage.
- Per-brand trend analytics (Expenses territory) · cancellation flows ·
  notifications.

## Decisions needed before handoff

1. **Drill depth (Dennis).** The Figma adds a merchant → transaction drill
   inside Cashflow; the parent PRD says Outflow stays a glance. Adopt the
   drill (amend parent) or cap at glance?
2. **Search / filter / sort** on the transaction lists (design team): design
   them inline, or defer explicitly.
3. **Loading / error / short-history states** (design team).
4. **Arbitrary date ranges** (Dennis + eng): the Figma implies free ranges
   ("15 Jan – 14 Jun"); the prototype ships presets + single months. Support
   free ranges (with bucketing rules) or descope.
5. **The enrichment-feedback form** (design team): the entry point exists;
   the form doesn't.

## For engineering (two lines)

One ledger per period+card scope; all aggregates, insights, and copy derived
from it — nothing pre-authored. Retention window and the Subscriptions alpha
API (groups with type + confidence tier) come from tenant config.

---
title: Cashflow Redesign — Design Handoff PRD
status: draft
created: 2026-07-21
updated: 2026-07-21
parent: prd-cashflow.md
changelog: |
  2026-07-21 — First draft, built around the validated prototype
  cashflow-flow.html. Sources: the design team's Figma "Cashflow New
  Implimentation" page, their Research-page problem stickies, the UX review of
  the prototype, the numbers audit, and the Lune Subscriptions PRD v3.
---

# PRD: Cashflow Redesign (Lune SDK)

This PRD governs the **redesign** of the shipped Cashflow module. It is written
for the design team: the design source is their Figma page **"Cashflow New
Implimentation"**, and the behavioral contract is the working prototype
**`cashflow-flow.html`** (repo root; also
github.com/dennisjed-lune/cashflow — `index.html` points at it). Where the
Figma and the prototype disagree, the disagreement is deliberate and is
enumerated in §Design Handoff as a numbered delta with its rationale.

User, problem, and market framing are inherited from the parent
`prd-cashflow.md` and are not restated. This document covers what the redesign
must change and the constraints every screen must obey.

## Source Inputs

- Figma **"Cashflow New Implimentation"** page (file `AWadIEBv3Vjl8ykgMgkTiV`,
  canvas node `2379-2065`): Main Screens, Bottom Sheets for Inflow & Outflow,
  Transaction Details, Iterations, ADIB Bank Preview.
- Figma **Research page** (node `0:1`) — the design team's own problem stickies
  (e.g. "Amount depends on the date, so date should come first", "No empty
  state design", "No quick presets", "No tap affordance") and their user-flow
  map, which shows **Trends as its own branch** off the landing.
- **`cashflow-flow.html`** — validated prototype: one deterministic transaction
  ledger, every screen derived from it; verified in-browser (numbers audit,
  keyboard access, WCAG AA contrast). The in-page notes panel maps each flow
  fix to this PRD.
- UX review of the prototype (2026-07-21) — blockers B-1..B-5 below.
- **Lune Subscriptions — PRD v3** (`~/cowork/prds/Lune-Subscriptions-PRD-v3.md`,
  handoff-ready) + `[ERD] Subscriptions.md` — recurring groups, Confirmed/Likely
  tiers, deposit type, "expectation not forecast" doctrine.
- `prd-cashflow.md` (2026-06) — parent product PRD, incl. the glance-vs-drill
  rule now under question (B-1).

## Goals

1. Ship the redesigned Cashflow journey — Landing → Trends → Inflow/Outflow →
   detail — with the flow defects found in the Figma corrected.
2. Make every number trustworthy: all figures derive from one transaction set;
   no two screens can contradict each other.
3. Make time honest: one time scope per screen, retention-bound windows,
   period-named copy, valid month labels.

## Non-Goals

- **Projected cashflow** — validated in the prototype (badged NEXT STAGE) but
  explicitly deferred to the next PRD stage (D-05).
- Building recurring/subscription **detection** — Lune Subscriptions owns it;
  Cashflow only consumes (VS-6).
- Per-brand trend analytics (category → brand-trend → txn drill) — Expenses
  territory, per the parent PRD.
- Cancellation flows, payment controls, notifications.

---

## Value Slices & Functional Requirements

### VS-1 — Date-first landing

The period is the first decision, and everything follows from it.
*(Fixes stickies: "date should come first: pick period → see result", "no
quick presets", "no clear way to select year", "filter funnel extra tap".)*

- **FR-1 Period control primacy.** The period selector and card selector sit
  at the top of the landing screen, above all figures. Every figure on every
  screen derives from the selected period (except the Trends surface, which
  declares its own fixed window — FR-8).
  - *Acceptance:* changing the period visibly updates the total, tiles,
    insights, and all downstream sheets; no figure anywhere reflects a period
    other than the one named on its screen.
- **FR-2 Presets + month picker.** One-tap presets (This month, Last month,
  Last 3 months, Last 6 months) plus a month grid with a year stepper. Months
  outside the retained data window and future months are disabled, with a note
  stating the available window.
  - *Acceptance:* no reachable selection can produce a "we never had this
    data" state; year navigation requires no more than two taps.
- **FR-3 Card scope.** A card selector (all cards / per-card multi-select, min
  one) scopes the same ledger; all figures react.
  - *Acceptance:* deselecting the card that receives salary flips the landing
    to a deficit consistently across total, tiles, insights.
- **FR-4 Landing anatomy.** Total cashflow (inflow − outflow, signed), inflow
  and outflow tiles with transaction counts and drill affordance, Cashflow
  history banner → Trends, Smart insights (summary + financial cushion).
  - *Acceptance:* inflow − outflow equals the displayed total exactly; tile
    counts equal the sheet counts; the cushion equals inflow ÷ outflow, with a
    defined zero-outflow state ("nothing to cover") instead of 0.00x.
- **FR-5 Empty states.** Landing and both flow sheets have empty states with a
  recovery action (change period / check card selection) for any period+card
  combination with no transactions.

### VS-2 — One data model (number coherence)

*(Fixes the Figma's internal contradictions: total ₯5,760 vs surplus 4,326;
donut 23.8K vs total 19,240; "37 transactions" over a 4-row list.)*

- **FR-6 Single derivation.** Every displayed figure — totals, donut segments,
  legend amounts and shares, trend bars, top lists, counts, insights — is
  derived from the same transaction set. Nothing is authored twice.
  - *Acceptance:* donut center = legend sum = sheet total; legend shares sum
    to 100 ±1; month-panel parts sum to the bar total; stated counts equal
    list counts, with "Showing N of M" whenever a list is truncated.
- **FR-7 Sign and name discipline.** The in-minus-out metric has exactly one
  name — **Total cashflow** — everywhere it appears, and negative values carry
  the minus sign in every instance. Decorative visuals whose data scope
  differs from the screen's scope are not allowed (use an icon or link to
  Trends instead).

### VS-3 — Trends surface (replaces "Timeline")

One dedicated over-time surface; period-scoped screens carry no trend charts.
*(Matches the design team's own user-flow map, which had Trends as its own
branch.)*

- **FR-8 Trends anatomy.** Renamed **Trends**. Inflow | Outflow toggle;
  stacked monthly bars in the same group palettes as the breakdown donuts;
  window = the full retained history, labeled (e.g. "Last 12 months ·
  Aug '25 – Jul '26"); horizontally scrollable, opening at the most recent
  months; year marker on January bars; current month flagged month-to-date.
  - *Acceptance:* palette identical between donut, legend, and trend stacks;
    the window label always matches the configured retention.
- **FR-9 Month drill-in (in place).** Tapping a bar shows that month's detail
  panel: group split with shares and amounts, in/out totals, net-kept chip,
  and a comparison to the monthly average (suppressed for the MTD month).
  - *Acceptance:* panel parts sum to the bar total; the MTD month never shows
    an average comparison.
- **FR-10 Valid time labels.** Whole calendar months only; labels are real
  date ranges ("Feb 1–28", "Jul 1–21 · so far"). No impossible labels
  ("Feb 1st–31st") and no cross-month ranges bucketed as months.
- **FR-11 Computed insights.** Trend insights (income steadiness ±N%, spend
  peak month) are computed from the data, name their window, and exclude the
  MTD month from full-month statistics (lowest/average/highest).

### VS-4 — Inflow & Outflow sheets (period-pure)

- **FR-12 Sheet anatomy.** Each sheet shows, for the selected period only:
  signed total with transaction count, breakdown donut with on-ring group
  icons, full-width legend rows (label · share % · amount — labels never
  truncate), Top sources / Top merchants (recurrence chips, drill chevrons),
  and the transactions list. No trend module (FR-8 owns over-time).
- **FR-13 List discipline.** Rows have tap affordances (chevron + press
  state); truncated lists disclose "Showing N of M".
- **FR-14 Search / filter / sort.** The user-flow map requires search, tag &
  category filters, and sorts on these lists; neither the new Figma nor the
  prototype designs them. Resolve via B-2: design them inline (not behind a
  funnel icon) **or** explicitly defer with rationale.

### VS-5 — Source / merchant / transaction detail

- **FR-15 Entity detail.** Brand header, window-bound total ("last N months"),
  detail rows (category, frequency, last received/transaction, average, first
  seen — derived from data, never hard-coded), single-color per-month history
  in the entity's group color, transaction list.
- **FR-16 Transaction detail.** Brand, amount, date · category, raw
  description consistent with the merchant, tags (add/edit inline chips),
  notes (add/edit), enrichment feedback entry ("Improve brand name, logo or
  category" — copy: "it trains Lune's enrichment") with submitted state and
  cancel. The feedback **form** itself is undesigned in the new set (B-5).
- **FR-17 Copy standards.** "Last received" (not "recieved"); relative time
  words ("this period", "this month") only when the period contains today —
  otherwise copy names the period ("in June", "in March 2025"). Every
  over-time label states its window.

### VS-6 — Subscriptions integration (gated on Lune Subscriptions alpha)

- **FR-18 Committed-spending glance (Outflow).** A read-only module on the
  Outflow sheet summing **Confirmed** recurring groups by type (subscriptions /
  billers / other recurring): total, share of outflow, per-type counts.
  Likely-tier groups are excluded from headline figures, per Subscriptions v3.
- **FR-19 Deposit-powered inflow recurrence.** Inflow's recurrence story
  ("N of M sources recur — your salary lands every month") binds to
  Subscriptions **deposit** groups rather than bespoke logic.
- **FR-20 Hand-off, not drill.** Taps on the glance route to the Subscriptions
  module's own List/Detail. Cashflow builds no subscription list of its own.

## User Journeys

- **UJ-1 Period ripple** (VS-1, VS-2): user opens Cashflow → sees this month
  so far → switches to Last month via preset → every figure updates; opens
  Outflow → same period, donut/tops/transactions agree with the tile.
- **UJ-2 Over-time exploration** (VS-3): user taps View trends → toggles
  Inflow/Outflow → scrolls back through retained history → taps a month →
  reads its split and net → returns; no other screen changed.
- **UJ-3 Transaction correction** (VS-5): user drills Outflow → Carrefour →
  a transaction → adds tags + note → submits an enrichment suggestion → sees
  the submitted state → cancels it.
- **UJ-4 Empty recovery** (VS-1): user picks a period/card combo with no
  data → empty state names the period → one tap back into the period picker.

## Cross-Cutting Requirements

- **Retention binding.** Tenant retention is 6 months (banks) or 12 months
  (fintechs). Every over-time window, label, and picker bound derives from the
  configured value — no hard-coded "last 6 months" / "12 months" copy. The
  prototype exposes this as a single constant (`RETENTION_MONTHS`).
- **Short-history behavior.** All statistics that assume N full months
  (lowest/average/highest, variance, averages) must define behavior for users
  with < 3 full months of history (B-3).
- **Loading & error states.** Skeletons (not spinners) for every async
  surface; failed-fetch states with retry. Undesigned in Figma and prototype
  (B-3).
- **Accessibility (WCAG 2.1 AA).** Verified in the prototype and required in
  production: text contrast ≥ 4.5:1 — note the DS tokens `Grey/G100 #7C8186`
  (3.93:1) and `#F02727` (4.18:1) **fail** for body-size text; the DS team
  should bless AA-passing text variants (prototype uses `#6B7075` /
  `#CC1E1E`; charts may keep DS colors at the 3:1 graphics bar). Keyboard
  operability + visible focus, dialog semantics on sheets, Escape/back to
  dismiss, ≥ 44px touch targets, reduced-motion path.
- **Localization.** RTL/Arabic and Dynamic Type are unaddressed in both Figma
  and prototype; required for UAE-market production (non-blocking for design
  handoff, blocking for release).
- **White-label theming.** Accent-token driven, per the existing module;
  brand marks must come from the approved logo chain (no bad/blurry logos —
  the prototype uses monograms deliberately).
- **Analytics.** Instrument period changes, card-scope changes, Trends opens,
  toggle switches, month taps, drill-ins, feedback submissions (non-blocking;
  spec follow-up).

## Design Handoff — Figma deltas

The prototype's notes panel enumerates these; each is "Figma shows X → ship Y":

1. **Date first** — period control leads the landing; Figma shows results
   before any period choice.
2. **One data model** — Figma frames contradict themselves (₯5,760 vs 4,326;
   23.8K donut vs 19,240 total); production derives everything from one set.
3. **Valid month labels** — no "Feb 1st – 31st"; no "15 Jan – 14 Jun" range
   over monthly bars.
4. **One scope per screen** — trend modules leave the Inflow/Outflow sheets;
   Trends (renamed from Timeline) is the only over-time surface.
5. **Presets + year picker** — replaces the funnel-icon detour; retention-
   aware.
6. **Tap affordances** — chevrons/press states on all drillable rows.
7. **Empty states** — designed for landing + sheets.
8. **Copy fixes** — spelling, merchant-consistent raw descriptions,
   period-named insight copy.
9. **Full-label legends** — one row per group (label · % · amount); the
   two-column legend truncated "Everyday spending".

Also: the Figma's monthly breakdown cards on Timeline are **removed** — the
month detail panel (FR-9) carries the same information on demand; if a
glanceable net-per-month view is wanted, propose it as a "Net" toggle option
rather than a card list.

## Architecture / Engineering Handoff

- One transaction ledger per period+card scope; **all** aggregates derived.
  No endpoint should return pre-authored summary copy that can drift from the
  numbers.
- Period model: preset | single month; arbitrary ranges pending B-4.
- Retention window from tenant config; exposed to the client so labels and
  pickers bind to it.
- Subscriptions dependency (VS-6): read Confirmed recurring groups + deposit
  groups from the Subscriptions alpha API; no local detection.
- Insights (steadiness, peak, cushion) computed server- or client-side from
  the same data — never hand-authored.

## Blockers Before Handoff

- **B-1 Drill depth.** The new Figma adds a merchant → transaction drill
  inside Cashflow, contradicting the parent PRD's glance-only rule (D-04
  there). Owner: Dennis. Decide: adopt the drill (amend parent PRD) or cap at
  glance + hand off to Expenses/Subscriptions.
- **B-2 Search / filter / sort** on Inflow/Outflow lists: design inline or
  explicitly defer (FR-14). Owner: design team.
- **B-3 Loading / error / short-history states**: design required (skeletons,
  retry, < 3-months behavior). Owner: design team.
- **B-4 Arbitrary date ranges**: Figma headers imply free ranges
  ("15 Jan – 14 Jun"); prototype supports presets + single months. Decide
  whether the API/product supports free ranges (and how they bucket) or
  descope. Owner: Dennis + engineering.
- **B-5 Enrichment feedback form**: the entry point exists; the form itself
  (brand/logo/category correction, selection states, free-text) is undesigned
  in the new set. Owner: design team.

## Non-Blocking Follow-Ups

- Analytics event spec.
- RTL/Arabic + Dynamic Type design pass (release-blocking, not
  handoff-blocking).
- DS team to bless AA text variants of `Grey/G100` and the red.
- Committed-spending glance visual design (FR-18) once Subscriptions alpha API
  shape is final.
- "Net" toggle option on Trends, if the removed breakdown cards are missed.
- Legend share rounding rule (largest-remainder vs round) for edge months.

## Assumptions Index

- [ASSUMPTION: retention defaults — banks 6mo, fintechs 12mo — match the
  Subscriptions v3 statement and current tenant configs.]
- [ASSUMPTION: the Subscriptions alpha API will expose Confirmed/Likely tier
  and type (subscription/biller/recurring/deposit) per group, per the ERD.]
- [ASSUMPTION: the SDK ships to a fixed period model (presets + single
  months) unless B-4 resolves otherwise.]
- [ASSUMPTION: monogram marks are acceptable wherever the logo chain lacks a
  crisp asset (standing "no bad logos" rule).]

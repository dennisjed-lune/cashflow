# Cashflow — Lune SDK

The **Cashflow** module is an embedded liquidity lens for a bank's consumer
end-customers: *am I net positive this period, and where is my money flowing?*
It is a standalone product, separate from **Expenses** (the deep spending-
optimisation drill).

## The product line

| | Cashflow | Expenses (sister product) |
| --- | --- | --- |
| Question | Net position · money movement · income quality | What do I cut back on? |
| Enrichment | Brand / category / source as a **glance** (read-only) | The analytical **drill** (category → brand-trend → txns) |

Enrichment (clean names, logos, categories, source identity) appears throughout
both — Lune is an enrichment provider. The products differ by **interaction depth**,
not by whether enrichment shows. In Cashflow, taps never open a trend/drill — that
tap-through is what Expenses sells.

## Contents

- **`cashflow-flow.html`** — the CURRENT canonical prototype (2026-07-21; React via
  CDN, single file). Serve locally: `python3 -m http.server 8080` →
  http://localhost:8080/cashflow-flow.html
  - Built from the design team's Figma page "Cashflow New Implimentation", with
    eight flow fixes over those designs (documented in the in-page notes panel):
    date-first period control, one data model (no contradicting totals), valid
    whole-month labels, presets + year-aware month picker, tap affordances, empty
    states, copy fixes, and one time scope per screen (over-time views moved to a
    dedicated **Trends** surface — Inflow/Outflow toggle, breakdown palettes,
    all-time scrollable history, tap-a-month detail panel).
  - Journey: Landing → Trends → Inflow / Outflow sheets → source/merchant detail →
    transaction detail (tags, notes, enrichment feedback) + card selector + period
    picker. WCAG AA contrast, keyboard operable, dialog semantics, reduced motion.
  - **Open product question:** following the new Figma, this prototype includes a
    merchant → transaction drill inside Cashflow, which contradicts the glance-only
    rule above. Either the rule changed or the design drifted — to be settled in the
    upcoming design-team PRD before implementation.
- **`Cashflow.html`** / **`Cashflow.dc.html`** — previous iterations (pre-Figma-redesign),
  kept for reference.
  - Landing (net position + in/out + 6-month timeline) → **Outflow** (money-movement:
    total out, net vs inflow, over-time, high-level category + top-merchant glance) →
    **Inflow** (by type, enriched sources, recurrence, income stability).
  - Light/dark + white-label accent theming.
- **`docs/`** — PRD, lite PRD, opportunity brief, decision log.
- **`ios/`** — the production SwiftUI module (LuneSDK). Fragments only; builds inside
  the LuneSDK Xcode project. New in this round: `CashflowView+OutflowSummary.swift`
  (net-vs-inflow compare bars) and `CashflowView+InflowSummary.swift` (dedicated
  Inflow lens). The Inflow by-type/source/recurrence data is **mock**, gated on the
  enrichment-classification dependency (PRD blocker **B-01**); total-in is real.

## Status

Prototype + design-ready PRD complete. SwiftUI changes are syntax-validated but need
an Xcode build in the LuneSDK repo to verify. Inflow's distinctive metrics are blocked
on inflow classification (income / government / transfer) + recurrence detection.

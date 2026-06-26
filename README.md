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

- **`Cashflow.html`** — interactive prototype (React via CDN, single file). Open in
  a browser, or serve locally: `python3 -m http.server 8080` → http://localhost:8080/Cashflow.html
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

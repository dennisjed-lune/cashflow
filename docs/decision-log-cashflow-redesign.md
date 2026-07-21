# Decision Log — Cashflow Redesign

Material decisions for `prd-cashflow-redesign.md`. Newest first. The parent
module's log is `decision-log-cashflow.md`.

---

## 2026-07-21 (2) — Dennis resolves the handoff decisions

### Decisions

- **D-11 — Drill depth: transaction level.** The Cashflow journey drills
  Landing → Inflow/Outflow → source/merchant → transaction detail. This
  SUPERSEDES the parent PRD's D-04 ("Outflow is not the Expenses drill" /
  glance-only). Former blocker B-1 closed. (Dennis: "drill depth is to
  transaction level.")
- **D-12 — Search + filters are in scope.** Inline search field +
  category/tag filter chips on the Inflow/Outflow transaction lists (change
  #10 in the PRD). Former blocker B-2 closed; visual design remains with the
  design team.
- **D-13 — Subscriptions integration removed from this PRD.** The
  committed-spending glance, deposit-bound recurrence, and report-subscription
  hand-off move to "Not in this stage"; revisit once the Lune Subscriptions
  alpha ships. (Dennis: "do not add report subscription here.")
- **D-14 — Projected cashflow hidden behind a demo toggle.** The prototype
  hides the projection card by default; a "Next stage" toggle in the side
  panel reveals it. Keeps the current-scope demo clean while preserving the
  next-stage preview.

## 2026-07-21 — Redesign PRD drafted around the validated prototype

**Context:** The design team produced the Figma "Cashflow New Implimentation"
page; Dennis found flow-level issues and chose prototype-first: build the
corrected flow (`cashflow-flow.html`), UX-review it, polish it, then write
this PRD around it. All decisions below were made with Dennis in that session.

### Decisions

- **D-01 — Prototype is the behavioral contract.** Where Figma and prototype
  disagree, the prototype wins; each delta is enumerated in the PRD's Design
  Handoff section with rationale. Figma remains the visual source.
- **D-02 — Trends split (one scope per screen).** Trend modules were removed
  from the period-scoped Inflow/Outflow sheets; the Timeline surface was
  renamed **Trends** and is the only over-time view (Inflow|Outflow toggle,
  group palettes, full retained history). Rationale: a "Last 6 months" chart
  under a "Last 3 months" period chip mixes scopes; the design team's own
  user-flow map had Trends as its own branch. (Dennis: "maybe we should split
  trend and inflow and outflow — trends can sit somewhere else.")
- **D-03 — Breakdown cards removed from Trends.** The monthly "You kept"
  card list duplicated the chart; replaced by the tap-a-month detail panel
  (split + %s + in/out + kept chip + vs-average). Dennis questioned the cards;
  agreed they're not required. A "Net" toggle is logged as a follow-up option.
- **D-04 — Retention window is law.** Lune keeps 6 (banks) / 12 (fintechs)
  months. "All time" copy is banned; windows, labels, and the period picker
  bind to the configured retention. Prototype constant `RETENTION_MONTHS=12`
  (fintech profile). (Dennis: "we keep data for 6-12 months.")
- **D-05 — Projected cashflow deferred to the next PRD stage.** Validated in
  the prototype (MTD actuals + recurring pattern rolled forward, following the
  Subscriptions v3 "expectation, not a forecast" doctrine) and kept there with
  a NEXT STAGE badge, but out of current scope. (Dennis: "lets keep projected
  cashflow for next stage on prd.")
- **D-06 — Subscriptions v3 is the recurring engine.** Cashflow consumes
  Confirmed recurring groups (committed-spending glance) and deposit groups
  (inflow recurrence); taps hand off to the Subscriptions module. Cashflow
  builds no detection and no subscription list. Supersedes the earlier
  flags-only framing.
- **D-07 — Terminology: "Total cashflow".** One name for the in-minus-out
  metric everywhere (was Net kept / Surplus / Total cashflow across screens);
  negative values always carry the minus sign.
- **D-08 — Period-named copy.** Relative time words only when the period
  contains today; otherwise sentences name the period ("in June"). Triggered
  by Dennis catching "this period" describing June while in July.
- **D-09 — No mixed-scope decoration.** The summary card's 11-month sparkline
  (different scope from the card's headline) was replaced with a sentiment
  icon. Rule: a visual either shares its screen's scope or links to Trends.
  (Dennis: "lets just use an icon if the chart is not accurate.")
- **D-10 — Accessibility floor from the audit.** AA-passing text colors
  (#6B7075 / #CC1E1E where DS tokens fail), keyboard operability, dialog
  semantics, 44px targets — carried as cross-cutting requirements; DS team to
  bless official token variants.

### Conflicts / Open

- **B-1 (unresolved, escalated):** the new Figma's in-Cashflow
  merchant→transaction drill contradicts parent D-04 ("Outflow is not the
  Expenses drill"). Owner: Dennis. This PRD stays `draft`-honest about it.

### Assumptions

- Retention defaults per tenant type match Subscriptions v3.
- Subscriptions alpha API exposes tier + type per recurring group.
- Period model is presets + single months pending B-4.

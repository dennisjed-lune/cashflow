//
//  CashflowView+InflowSummary.swift
//  LuneSDK
//
//  Dedicated Inflow view: income organised BY TYPE (income / government /
//  transfers) with enriched SOURCES and recurrence — never retail brands.
//  This is the Cashflow-distinct income lens that has zero overlap with Expenses.
//
//  ⚠️ DATA DEPENDENCY (PRD blocker B-01): the by-type breakdown, source identity
//  and recurrence below are MOCK so the view can be built and demoed now. Wire to
//  the enrichment-classified inflow API once income/government/transfer
//  classification + recurrence detection ship. Total-in is already real.
//

import SwiftUI

private struct InflowTypeDatum: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}

private struct InflowSourceDatum: Identifiable {
    let id = UUID()
    let name: String
    let kind: String
    let amount: Double
    let recurring: String?
    let symbol: String
}

extension CashflowView {

    // MARK: Mock inflow enrichment — replace with API data (B-01)

    private var mockInflowTypes: [InflowTypeDatum] {
        [
            .init(name: "Salary & income", amount: 18500, color: incomeColor),
            .init(name: "Transfers in",    amount: 3800,  color: incomeColor.opacity(0.7)),
            .init(name: "Government",       amount: 1500,  color: Color(red: 0.36, green: 0.42, blue: 0.40)),
            .init(name: "Other income",    amount: 1000,  color: Color(red: 0.55, green: 0.48, blue: 0.90)),
        ]
    }

    private var mockInflowSources: [InflowSourceDatum] {
        [
            .init(name: "Emirates NBD Payroll",       kind: "Salary",       amount: 18500, recurring: "Monthly",   symbol: "creditcard.fill"),
            .init(name: "Transfer from Savings",      kind: "Transfer in",  amount: 2500,  recurring: "Monthly",   symbol: "arrow.left.arrow.right"),
            .init(name: "Ministry of Community Dev.", kind: "Government",    amount: 1500,  recurring: "Quarterly", symbol: "building.columns.fill"),
            .init(name: "Transfer from Ahmed K.",     kind: "Transfer in",  amount: 1300,  recurring: nil,         symbol: "arrow.left.arrow.right"),
            .init(name: "Interest — Emirates NBD",    kind: "Other income", amount: 600,   recurring: "Monthly",   symbol: "percent"),
        ]
    }

    // MARK: Composed view

    @ViewBuilder
    func buildInflowSummary() -> some View {
        VStack(alignment: .leading, spacing: 18) {
            buildInflowHeader()
            buildInflowBreakdown()
            buildInflowSources()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: Header — total in (real) + steady-income chip

    @ViewBuilder
    private func buildInflowHeader() -> some View {
        let total = (viewModel.cashflow?.totalIncome ?? 0).magnitude

        VStack(alignment: .leading, spacing: 8) {
            Text("Total in")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(config.hintColor(colorScheme))

            AmountView(
                amount: total,
                font: .system(size: 24, weight: .bold),
                foregroundColor: incomeColor,
                interactive: false,
                config: config
            )

            HStack(spacing: 5) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 11, weight: .bold))
                Text("Steady income · recurs monthly")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(incomeColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(incomeColor.opacity(0.12)))
        }
    }

    // MARK: Breakdown by TYPE (never by brand)

    @ViewBuilder
    private func buildInflowBreakdown() -> some View {
        let total = max((viewModel.cashflow?.totalIncome ?? 0).magnitude, 1)

        VStack(alignment: .leading, spacing: 12) {
            Text("Income breakdown · by type")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(config.fg(colorScheme))

            GeometryReader { geo in
                HStack(spacing: 3) {
                    ForEach(mockInflowTypes) { t in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(t.color)
                            .frame(width: max(4, geo.size.width * CGFloat(t.amount / total)))
                    }
                }
            }
            .frame(height: 36)

            ForEach(mockInflowTypes) { t in
                HStack(spacing: 9) {
                    Circle().fill(t.color).frame(width: 9, height: 9)
                    Text(t.name)
                        .font(.system(size: 13))
                        .foregroundColor(config.fg(colorScheme))
                    Spacer()
                    Text("\(Int((t.amount / total * 100).rounded()))%")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(config.hintColor(colorScheme))
                }
            }
        }
    }

    // MARK: Top sources — enriched source identity + recurrence

    @ViewBuilder
    private func buildInflowSources() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Top sources · enriched by Lune")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(config.fg(colorScheme))
                .padding(.bottom, 4)

            ForEach(mockInflowSources) { s in
                HStack(spacing: 12) {
                    Image(systemName: s.symbol)
                        .font(.system(size: 14))
                        .foregroundColor(incomeColor)
                        .frame(width: 38, height: 38)
                        .background(RoundedRectangle(cornerRadius: 11).fill(incomeColor.opacity(0.12)))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(s.name)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(config.fg(colorScheme))

                        HStack(spacing: 8) {
                            Text(s.kind)
                                .font(.system(size: 12))
                                .foregroundColor(config.hintColor(colorScheme))

                            if let recurring = s.recurring {
                                HStack(spacing: 3) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 9, weight: .bold))
                                    Text(recurring)
                                        .font(.system(size: 11, weight: .semibold))
                                }
                                .foregroundColor(incomeColor)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(incomeColor.opacity(0.12)))
                            }
                        }
                    }

                    Spacer()

                    AmountView(
                        amount: s.amount,
                        font: config.textCustom(15),
                        foregroundColor: incomeColor,
                        interactive: false,
                        config: config
                    )
                }
                .padding(.vertical, 8)
            }
        }
    }
}

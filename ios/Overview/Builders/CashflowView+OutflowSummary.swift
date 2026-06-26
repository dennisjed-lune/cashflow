//
//  CashflowView+OutflowSummary.swift
//  LuneSDK
//
//  Net-vs-inflow "money movement" header for the Outflow sheet.
//  Cashflow-distinct: it relates outflow TO inflow (Expenses never references
//  income). Uses only existing Cashflow fields — no new data dependency.
//

import SwiftUI

extension CashflowView {

    @ViewBuilder
    func buildOutflowSummary() -> some View {
        let income = (viewModel.cashflow?.totalIncome ?? 0).magnitude
        let outgoing = (viewModel.cashflow?.totalSpend ?? 0).magnitude
        let net = income - outgoing
        let peak = max(income, outgoing, 1)

        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Out vs in")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(config.fg(colorScheme))

                Spacer()

                HStack(spacing: 4) {
                    Text(net >= 0 ? "Net +" : "Net −")
                        .font(.system(size: 13, weight: .bold))

                    AmountView(
                        amount: net.magnitude,
                        font: config.textCustom(13),
                        foregroundColor: net >= 0 ? incomeColor : expenseColor,
                        interactive: false,
                        config: config
                    )
                }
                .foregroundColor(net >= 0 ? incomeColor : expenseColor)
            }

            compareRow(
                label: "lune_sdk_str_inflow".tr,
                value: income,
                fraction: income / peak,
                color: incomeColor
            )

            compareRow(
                label: "lune_sdk_str_outflow".tr,
                value: outgoing,
                fraction: outgoing / peak,
                color: expenseColor
            )
        }
        .padding(14)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(config.hintColor(colorScheme).opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func compareRow(label: String, value: Double, fraction: Double, color: Color) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(config.hintColor(colorScheme))
                .frame(width: 56, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(config.hintColor(colorScheme).opacity(0.12))
                    Capsule()
                        .fill(color)
                        .frame(width: max(8, geo.size.width * CGFloat(fraction)))
                }
            }
            .frame(height: 12)

            AmountView(
                amount: value,
                font: config.textCustom(12),
                foregroundColor: config.fg(colorScheme),
                interactive: false,
                config: config
            )
        }
    }
}

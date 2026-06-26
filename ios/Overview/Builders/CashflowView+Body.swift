//
//  CashflowBuilders.swift
//  LuneSDK
//
//  Created by Zamorite on 15/10/2024.
//

import SwiftUI

extension CashflowView {
    @ViewBuilder
    func buildBody() -> some View {
        DatePickerView(
            initialDates: viewModel.dates,
            config: config,
            onSelectDates: { dates in
                Task {
                    viewModel.selectDates(dateFilter: dates)
                    await viewModel.getCashflow()
                }
            },
            content: Group {
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // 3. Visual Chart Section
                        VStack(alignment: .center, spacing: 16) {
                            buildCashflowAmount()
                            
                            CashflowChartView(config: config, viewModel: viewModel, showLegend: false)
                                .padding(.vertical, 30)
                            
                            buildCashflowNewTitles()
                          
                            buildViewTimelineButton()
                            
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(config.hintColor(colorScheme).opacity(0.1), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        buildSummaryText()
                        
                        
                        // 5. Injected Slot Content
                        AnyView(slotContent)
                        
                    }
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity)
                }
            },
            parentMeta: meta
        )
        .sheet(isPresented: $viewingTimeline) {
            buildTimelineSheet().resolveDirectionality()
        }
    }
    
    @ViewBuilder
    private func buildCashflowAmount() -> some View {
        let net = viewModel.cashflow?.difference ?? 0.0
        let isPositive = net >= 0
        // Net is the headline "am I okay this period?" signal — colour it by sign
        // (sentiment), and use theme tokens instead of flat black so dark mode and
        // per-client white-label theming keep working.
        let netColor: Color = net == 0
            ? config.hintColor(colorScheme)
            : (isPositive ? incomeColor : expenseColor)

        VStack(spacing: 8) {
            Text("lune_sdk_str_cashflow".tr)
                .font(Font.system(size: 14, weight: .regular))
                .foregroundColor(config.hintColor(colorScheme))

            AmountView(amount: net,
                       font: Font.system(size: 24, weight: .bold),
                       foregroundColor: netColor,
                       config: config,
                       parentMeta: meta)

            // Plain-language sentiment badge. This net framing is distinct to
            // Cashflow — Expenses has no "net position" concept, so it does not
            // overlap the sister product.
            if viewModel.cashflow != nil {
                HStack(spacing: 5) {
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 11, weight: .bold))
                    Text(isPositive
                         ? "You're net positive this period"
                         : "You spent more than came in")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(netColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(netColor.opacity(0.12)))
            }
        }
    }
}

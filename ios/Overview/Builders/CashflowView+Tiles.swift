//
//  Overview+CashflowTiles.swift
//  LuneSDK
//
//  Created by Zamorite on 13/01/2025.
//

import Foundation

extension CashflowView {
    
    // Old Cashflow Titles 
    @ViewBuilder
    func buildCashflowTiles() -> some View {
        VStack {
            if cashflowConfig?.structure.incomeBeforeExpense == true {
                CashflowTile(
                    (viewModel.cashflow?.totalIncome ?? 0).magnitude,
                    config: config,
                    isExpense: false,
                    onTap: {
                        viewingIncome = true
                    },
                    viewTag: .widget(.inflow_tile),
                    parentMeta: meta
                )
                .sheet(isPresented: $viewingIncome) { buildIncomeSheet().resolveDirectionality() }
                .logTap("income_tile", parentMeta: meta)
                .padding(.bottom, 16)
            }
            
            CashflowTile(
                (viewModel.cashflow?.totalSpend ?? 0).magnitude,
                config: config,
                onTap: {
                    viewingExpenses = true
                },
                viewTag: .widget(.outflow_tile),
                parentMeta: meta
            )
            .sheet(isPresented: $viewingExpenses) {
                buildExpenseSheet().resolveDirectionality()
            }
            .logTap("expense_tile", parentMeta: meta)
            
            if cashflowConfig?.structure.incomeBeforeExpense != true {
                CashflowTile(
                    (viewModel.cashflow?.totalIncome ?? 0).magnitude,
                    config: config,
                    isExpense: false,
                    onTap: {
                        viewingIncome = true
                    },
                    viewTag: .widget(.inflow_tile),
                    parentMeta: meta
                )
                .sheet(isPresented: $viewingIncome) { buildIncomeSheet().resolveDirectionality() }
                .logTap("income_tile", parentMeta: meta)
                .padding(.top, 16)
            }
        }
        .padding(.vertical).padding(.horizontal, 32)
    }

    // MARK: - New Titles

    @ViewBuilder
    func buildCashflowNewTitles() -> some View {
        let incomeFirst = cashflowConfig?.structure.incomeBeforeExpense == true

        HStack(spacing: 12) {
            if incomeFirst {
                incomeCard
                expenseCard
            } else {
                expenseCard
                incomeCard
            }
        }
    }

    // MARK: - Income Card

    private var incomeCard: some View {
        cashflowCard(
            title: "Income",
            icon: Config.loadImage(config.global.assets.getIncome),
            accentColor: incomeColor,
            transactionCount: viewModel.cashflow?.incomeTransactionCount ?? 0,
            amount: viewModel.cashflow?.totalIncome ?? 0,
            onTap: { viewingIncome = true }
        )
        .sheet(isPresented: $viewingIncome) {
            buildIncomeSheet().resolveDirectionality()
        }
        .logTap("income_tile", parentMeta: meta)
    }

    // MARK: - Expense Card

    private var expenseCard: some View {
        cashflowCard(
            title: "Outgoing",
            icon: Config.loadImage(config.global.assets.getExpense),
            accentColor: expenseColor,
            transactionCount: viewModel.cashflow?.outgoingTransactionCount ?? 0,
            amount: viewModel.cashflow?.totalSpend ?? 0,
            onTap: { viewingExpenses = true }
        )
        .sheet(isPresented: $viewingExpenses) {
            buildExpenseSheet().resolveDirectionality()
        }
        .logTap("expense_tile", parentMeta: meta)
    }

    // MARK: - Card Component

    @ViewBuilder
    private func cashflowCard(
        title: String,
        icon: Image,
        accentColor: Color,
        transactionCount: Int,
        amount: Double,
        onTap: @escaping () -> Void
    ) -> some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .tint(Color.red)
                        .foregroundColor(.white)
                        .padding(3)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(accentColor)
                                
                        )
                    
                    Text(title)
                        .font(config.textCustom(12))
                        .fontWeight(.regular)
                        .foregroundColor(config.fg(colorScheme))
                    Spacer()
                    
                }//: HStack
                
                HStack {
                    AmountView(
                        amount: amount,
                        font: Font.system(size: 14, weight: .bold),
                        trailingFont: Font.system(size: 11, weight: .regular),
                        foregroundColor: .black, config: config, parentMeta: meta)
                    
                    Spacer()
                }
                
                HStack {
                    Text(transactionLabel(transactionCount))
                        .font(config.textCustom(11))
                        .foregroundColor(config.hintColor(colorScheme))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(accentColor.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(accentColor.opacity(0.25), lineWidth: 1)
            )
            .overlay(
                Image(systemName: "chevron.forward")
                    .frame(width: 12)
                    .foregroundColor(accentColor)
                    .padding(.trailing, 8)
                , alignment: .trailing
            )
        }
        .buttonStyle(.plain)

    }

    // MARK: - Helpers

    private func transactionLabel(_ count: Int) -> String {
        if count == 0 { return "lune_sdk_str_no_transactions".tr }
        return count == 1 ? "1 \("lune_sdk_str_transaction".tr)" : "\(count) \("lune_sdk_str_transactions".tr)"
    }
}


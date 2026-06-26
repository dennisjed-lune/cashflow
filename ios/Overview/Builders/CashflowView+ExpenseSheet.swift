//
//  Overview+ExpenseSheet.swift
//  LuneSDK
//
//  Created by Zamorite on 13/01/2025.
//

import Foundation

extension CashflowView {
	@ViewBuilder
	func buildExpenseSheet() -> some View {
		VStack {
            ZStack(alignment: .trailing) {
                HStack {
                    Text(usingModalHeader ? "lune_sdk_str_outflow".tr : "").font(config.heading0)
                    Spacer()
                }

                Button(
                    action: {
                        viewingExpenses = false
                        reportModalTappedClose(.outflow_modal)
                    },
                    label: {
                        Image("lune_sdk_asset_close", bundle: Bundle(identifier: "io.lunedata.LuneSDK"))
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(config.fg(colorScheme))
                            .padding(8)
                            .background(Circle().fill(config.fg(colorScheme).opacity(0.05)))
                    }
                )
                .buttonStyle(.plain).padding(8)
            }
            .padding(.horizontal, 20).padding(.top, 30)

			// Money-movement header: total out related to inflow (net position).
			buildOutflowSummary()

			TransactionListView(
				config: config,
				credentials: credentials,
				dateFilter: viewModel.dates,
				showSavings: true,
				forExpense: true,
				forCashflow: true
			)
		}
		.onAppear {
			report(.initialized, target: .modal(.outflow_modal))

			//			reportModalLaunched("expense_transactions")
		}
		//    .onDisappear { reportModalClosed("expense_transactions") }
	}
}

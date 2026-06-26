//
//  Overview+IncomeSheet.swift
//  LuneSDK
//
//  Created by Zamorite on 13/01/2025.
//

import Foundation

extension CashflowView {
	@ViewBuilder
	func buildIncomeSheet() -> some View {
		VStack {
            ZStack(alignment: .trailing) {
                HStack {
                    Text(usingModalHeader ? "lune_sdk_str_inflow".tr : "").font(config.heading0)
                    Spacer()
                }

				Button(
					action: {
						viewingIncome = false
						reportModalTappedClose(.inflow_modal)
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

			// Dedicated Inflow lens: by-type breakdown + enriched sources + recurrence.
			buildInflowSummary()

			TransactionListView(
				config: config,
				credentials: credentials,
				dateFilter: viewModel.dates,
				showSavings: true,
				forIncome: true,
				forCashflow: true,
				withTrends: false
			)
		}
		.onAppear {
			report(.initialized, target: .modal(.inflow_modal))

			//			reportModalLaunched("income_transactions")
		}
		//    .onDisappear { reportModalClosed("income_transactions") }
	}
}

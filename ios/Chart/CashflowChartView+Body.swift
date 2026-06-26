//
//  CashflowChartView+Body.swift
//  LuneSDK
//
//  Created by Zamorite on 13/01/2025.
//

import Foundation

extension CashflowChartView {
	@ViewBuilder
	func buildBody() -> some View {
		HStack(spacing: 0) {
			CashflowChart(cashflow: viewModel.cashflow, config: self.config, dateFilters: viewModel.dates)

			//            .blur(radius: noData ? 5 : 0)
				.allowsHitTesting(!noData).frame(minWidth: 0, maxWidth: .infinity)

			if showLegend {
				VStack(alignment: .leading) {
					Spacer()

					CashflowLegendTile(
						(viewModel.cashflow?.totalIncome ?? 0).magnitude,
						config: config,
						isExpense: false
					)
					.padding(.bottom, 16)

					CashflowLegendTile(
						(viewModel.cashflow?.totalSpend ?? 0).magnitude,
						config: config,
						isExpense: true
					)

					Spacer()
				}
				.frame(minWidth: 0, maxWidth: .infinity)

				Spacer()
			}
		}
		.frame(minWidth: 0, maxWidth: .infinity)//        .fixedSize(horizontal: false, vertical: true)
	}
}

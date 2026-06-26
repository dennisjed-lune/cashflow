//
//  Overview+Header.swift
//  LuneSDK
//
//  Created by Zamorite on 13/01/2025.
//

import Foundation

//extension CashflowView {
//	@ViewBuilder
//	func buildCenteredHeader(_ header: any DatePickerheaderProtocol, showErrorColor: Bool)
//	-> some View {
//		Group {
//			let subtitle = header.subtitle(config)
//
//			if header.showSubtitle, !subtitle.isEmpty {
//				Text(subtitle)
//					.font(config.body)
//					.foregroundColor(config.hintColor(colorScheme))
//					.padding(.top, 0.5)
//			}
//		}
//
//		if header.showAmount {
//			AmountView(
//				amount: header.amount,
//				//                                signed: true,
//				font: config.heading0,
//				trailingFont: minifyingTitleDecimal ? config.hint : nil,
//				foregroundColor: showErrorColor
//				? config.errorColor(colorScheme) : config.fg(colorScheme),
//				//                                prefixCurrency: true,
//				trailingColor: config.hintColor(colorScheme),
//				config: config
//			)
//		}
//	}
//
//	@ViewBuilder
//	func buildHeader(_ header: any DatePickerheaderProtocol) -> some View {
//		let shouldShowErrorColor = ((header.amount < 0.0) && (header.showRed && !overridingHeaderColor))
//
//		VStack(alignment: useCenteredHeader ? .center : .leading) {
//			if useCenteredHeader {
//                buildNewHeader(header)
//			//	buildCenteredHeader(header, showErrorColor: shouldShowErrorColor)
//			} else {
//				HStack {
//					if (header.icon) != nil {
//						ImageView(
//							url: header.leadingImage(colorScheme),
//							width: 32.0,
//							config: config,
//							withErrorBg: true
//						)
//						.padding(.trailing, 10)
//					}
//
//					Text(header.title).font(config.heading0).foregroundColor(config.fg(colorScheme))
//
//					Spacer()
//
//					if header.showAmount {
//						AmountView(
//							amount: header.amount,
//							//                                    signed: true,
//							font: config.heading0,
//							trailingFont: config.hint,
//							foregroundColor: shouldShowErrorColor
//							? config.errorColor(colorScheme) : config.fg(colorScheme),
//							trailingColor: config.hintColor(colorScheme),
//							config: config
//						)
//					}
//				}
//
//				Group {
//					let subtitle = header.subtitle(config)
//
//					if header.showSubtitle, !subtitle.isEmpty {
//						Text(subtitle)
//							.font(config.body)
//							.foregroundColor(config.hintColor(colorScheme))
//							.padding(.top, 0.5)
//					}
//				}
//			}
//		}
//		.padding(.horizontal, 20)
//		.padding(.top, usingModalHeader ? 0 : 17)
//		.padding(.bottom, 17)
//	}
//    
//    
//    // MARK: - Cashflow Header
//
//    @ViewBuilder
//    func buildNewHeader(_ header: any DatePickerheaderProtocol) -> some View {
//        VStack(spacing: 0) {
//            buildBalanceSection(header)
//
//            Divider()
//                .padding(.horizontal, 12)
//
//            buildCashflowRow()
//        }
//        .padding(14)
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(config.secondaryColor(colorScheme).opacity(0.04))
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(config.hintColor(colorScheme).opacity(0.1), lineWidth: 1)
//        )
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
//    }
//
//    // MARK: - Balance Section
//
//    @ViewBuilder
//    private func buildBalanceSection(_ header: any DatePickerheaderProtocol) -> some View {
//        VStack(spacing: 4) {
//            
//            Text("Cashflow")
//                .font(config.textCustom(14))
//                .fontWeight(.semibold)
//            
//
//            AmountView(
//                amount: header.amount,
//                font: config.heading0,
//                trailingFont: minifyingTitleDecimal ? config.hint : nil,
//                foregroundColor: balanceColor(for: header.amount),
//                trailingColor: config.hintColor(colorScheme),
//                config: config
//            )
//            
//
//        }
//        .padding(.bottom, 12)
//    }
//
//    // MARK: - Cashflow Row
//    @ViewBuilder
//    private func buildCashflowRow() -> some View {
//        HStack(spacing: 0) {
//            cashflowColumn(
//                title: "Income",
//                amount: (viewModel.cashflow?.totalIncome ?? 0).magnitude,
//                color: incomeColor
//            )
//
//            Divider()
//                .frame(height: 44)
//                .padding(.horizontal, 16)
//
//            cashflowColumn(
//                title: "Outgoing",
//                amount: (viewModel.cashflow?.totalSpend ?? 0).magnitude,
//                color: expenseColor
//            )
//        }
//        .padding(.top, 12)
//    }
//
//    // MARK: - Cashflow Column
//    @ViewBuilder
//    private func cashflowColumn(
//        title: String,
//        amount: Double,
//        color: Color
//    ) -> some View {
//        VStack(spacing: 4) {
//       
//            Text(title)
//                .font(config.textCustom(16))
//                .fontWeight(.semibold)
//                .foregroundColor(config.fg(colorScheme))
//            
//            
//            AmountView(
//                amount: amount,
//                font: config.heading1,
//                trailingFont: minifyingTitleDecimal ? config.hint : nil,
//                foregroundColor: color,
//                trailingColor: config.hintColor(colorScheme),
//                config: config
//            )
//        }
//        .frame(maxWidth: .infinity)
//    }
//
//    // MARK: - Helpers
//    private func balanceColor(for amount: Double) -> Color {
//        switch amount {
//        case ..<0:    return expenseColor
//        case 0:       return config.hintColor(colorScheme)
//        default:      return incomeColor
//        }
//    }
//}

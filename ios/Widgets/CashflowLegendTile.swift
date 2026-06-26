//
//  CashflowLegendTile.swift
//  LuneSDK
//
//  Created by Zamorite on 01/02/2024.
//

import SwiftUI

struct CashflowLegendTile: View {
  @Environment(\.colorScheme)
  var colorScheme

  let amount: Double

  let config: Config

  var isExpense: Bool

  var title: String { isExpense ? "lune_sdk_str_outflow".tr : "lune_sdk_str_inflow".tr }

  var color: Color {
    isExpense
      ? config.cashflowColors(colorScheme)
        .expense.asColor()
      : config.cashflowColors(colorScheme)
        .income.asColor()
  }

  init(_ amount: Double, config: Config, isExpense: Bool = true) {
    self.amount = amount
    self.config = config
    self.isExpense = isExpense
  }

  @ViewBuilder
  func buildContent() -> some View {
    HStack(alignment: .top) {
      Circle()
        .foregroundColor(color)
        .frame(width: 12)
        .fixedSize()
        .padding(.top, 4)

      VStack(alignment: .leading) {
        Text(title)
          .foregroundColor(config.fg(colorScheme))  // or cardFg
          .font(config.body)

        AmountView(
          amount: amount,
          //                    signed: true,
          font: config.heading1,
          //                     trailingFont: config.body,
          foregroundColor: config.fg(colorScheme),
          interactive: false,
          //                    prefixCurrency: false,
          config: config
        )
      }  //            .background(Color.green)
    }  //        .background(Color.pink)
  }

  var body: some View {
    buildContent()
      .fixedSize(horizontal: false, vertical: true)
  }
}

struct CashflowLegendTile_Previews: PreviewProvider {
  static var config = Config.defaultConfig()

  static var previews: some View {
    CashflowTile(
      2450, config: config, viewTag: .widget(.inflow_tile),
      parentMeta: .init(viewTag: .not_implemented, credentials: LuneAuthCredentials.empty)
    )
    .padding()
    .previewLayout(.sizeThatFits)
  }
}

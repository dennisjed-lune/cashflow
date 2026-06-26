//
//  CashflowTile.swift
//  LuneKit
//
//  Created by Zamorite on 20/12/2022.
//

import SwiftUI

struct CashflowTile: View {
  @Environment(\.colorScheme)
  var colorScheme

  let amount: Double

  let config: Config

  var isExpense: Bool

  var icon: String { isExpense ? config.global.assets.getExpense : config.global.assets.getIncome }

  var title: String { isExpense ? "lune_sdk_str_outflow".tr : "lune_sdk_str_inflow".tr }

  var color: Color {
    isExpense
      ? config.cashflowColors(colorScheme)
        .expense.asColor()
      : config.cashflowColors(colorScheme)
        .income.asColor()
  }

  var onTap: (() -> Void)?

  var viewTag: AnalyticsTarget
  var parentMeta: PageMeta

  init(
    _ amount: Double, config: Config, isExpense: Bool = true, onTap: (() -> Void)? = nil,
    viewTag: AnalyticsTarget,
    parentMeta: PageMeta
  ) {
    self.amount = amount
    self.config = config
    self.isExpense = isExpense

    self.onTap = onTap

    self.viewTag = viewTag
    self.parentMeta = parentMeta
  }

  var tileConfig: Config.Global.Tiles? { config.global.tiles }

  var usingCardTile: Bool { tileConfig?.useCards == true }

  @ViewBuilder
  func buildContent() -> some View {
    HStack {
      Config.loadImage(icon)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 37.0, height: 37.0)  //                    .foregroundColor(color)
        .padding(.trailing)

      Text(title)
        .foregroundColor(config.fg(colorScheme))  // or cardFg
        .font(config.actionFont)

      Spacer()

      AmountView(
        amount: amount,
        //                    signed: true,
        font: config.actionFont,
        //                trailingFont: config.hint,
        foregroundColor: usingCardTile ? color : config.fg(colorScheme),
        //                    prefixCurrency: false,
        config: config,
        tag: .widget(viewTag == .widget(.inflow_tile) ? .inflow_amount : .outflow_amount),
        parentMeta: parentMeta
      )
    }
    .frame(maxWidth: .infinity, alignment: .leading)  //            .padding(10)
    .contentShape(Rectangle())
  }

  var body: some View {
    if usingCardTile {
      LuneCard(
        config: config, content: { buildContent() },
        onTap: {
          if let tapCallback = onTap {
            tapCallback()
          }

          logTap(
            target: viewTag,
            parentMeta: parentMeta
          )
        })
    } else {
      Button {
        if let onTap = onTap { onTap() }

        logTap(
          target: viewTag,
          parentMeta: parentMeta
        )
      } label: {
        buildContent()
      }
      .buttonStyle(.plain)
    }
  }
}

struct CashflowTile_Previews: PreviewProvider {
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

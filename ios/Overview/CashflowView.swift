//
//  CashflowView.swift
//  LuneKit
//
//  Created by Zamorite on 20/12/2022.
//

import SwiftUI

struct CashflowView: LuneView {
  var viewTag: AnalyticsTarget = .view(.cashflow_view)

  @Environment(\.colorScheme)
  var colorScheme

  @StateObject internal var viewModel: CashflowViewModel

  var credentials: LuneAuthCredentials
  var config: Config

  var slotContent: any View

  var noData: Bool { viewModel.cashflow == nil }

  var loading: Bool { viewModel.loading }

  var cashflowConfig: Config.ComponentSpecific.LCCashflow? { config.componentSpecific.cashflow }

  var minifyingTitleDecimal: Bool { config.global.structure.minifyTitleDecimalValue == true }

  var showingTopAmount: Bool { cashflowConfig?.structure.showTopAmount == true }

  var usingModalHeader: Bool { config.global.structure.useModalHeader == true }
    
    var incomeColor:Color {
        cashflowConfig?.theme.getCashflowColor(colorScheme).income.asColor() ?? .green
    }
    
    var expenseColor:Color {
        cashflowConfig?.theme.getCashflowColor(colorScheme).expense.asColor() ?? .red
    }

  @State var viewingExpenses: Bool = false
  @State var viewingIncome: Bool = false
  @State var viewingTimeline: Bool = false
    

  init(
    config: Config,
    credentials: LuneAuthCredentials,
    dateFilter: (Date?, Date?)? = nil,
    slotContent: (() -> some View) = { EmptyView() }
  ) {
    self.config = config
    self.credentials = credentials

    self.slotContent = slotContent()

    _viewModel = StateObject(
      wrappedValue: CashflowViewModel(
        credentials: credentials,
        dateFilter: dateFilter,
        withHousekeeping: false
      )
    )
  }

  var useCenteredHeader: Bool { config.global.structure.useCenteredHeader == true }

  var usingTrendAction: Bool { config.global.structure.useActionForTrends == true }

  var overridingHeaderColor: Bool { config.global.structure.overrideHeaderColor == true }

  var verticalPadding: Double { config.global.dateRangeButton.structure.verticalPadding }

  var horizontalPadding: Double { config.global.dateRangeButton.structure.horizontalPadding }

  public var body: some View {
    ZStack { buildBody() }
      .onAppear {
        if noData { viewModel.fetchData() }

				report(.initialized, target: .view(.cashflow_view))
//        reportInit()
      }
      //   .onDisappear { reportDestroy() }
      .foregroundColor(config.fg(colorScheme))
  }
}

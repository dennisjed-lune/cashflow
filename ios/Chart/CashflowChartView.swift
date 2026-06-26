//
//  _CashflowChart.swift
//  LuneKit
//
//  Created by Zamorite on 19/12/2022.
//

import SwiftUI

struct CashflowChartView: View {
  @ObservedObject internal var viewModel: CashflowViewModel

  var credentials: LuneAuthCredentials
  var config: Config

  var showLegend: Bool

  var noData: Bool { viewModel.cashflow == nil }

  var loading: Bool { viewModel.loading }

  init(
    config: Config,
    credentials: LuneAuthCredentials,
    showLegend: Bool = true,
    startDate: String? = nil,
    endDate: String? = nil//        dateFilter: (Date?, Date?)? = nil
  ) {
    self.config = config
    self.credentials = credentials

    self.showLegend = showLegend

    viewModel = CashflowViewModel(
      credentials: credentials,
      dateFilter: (startDate?.date(), endDate?.date())
    )

    //        print("Init: \(viewModel.dates); s: \(startDate); e: \(endDate)")
  }

  init(config: Config, viewModel: CashflowViewModel, showLegend: Bool = true) {
    self.config = config

    self.credentials = viewModel.credentials

    self.showLegend = showLegend

    self.viewModel = viewModel
  }

  public var body: some View {
    ZStack {
      if loading {
        buildBody().redactedIOS13().shimmer().disabled(true)
      } else {
        buildBody()
      }
    }//        .fixedSize(horizontal: false, vertical: true)
  }
}

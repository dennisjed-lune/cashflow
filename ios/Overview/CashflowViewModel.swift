//
//  CashflowViewModel.swift
//  LuneSDK
//
//  Created by Zamorite on 14/08/2023.
//

import Foundation

class CashflowViewModel: LuneViewModel {
  @Published var cashflow: Cashflow?
    
    var days: Int {
        super.getSelectedDaysCount()
    }
    
  init(
    credentials: LuneAuthCredentials,
    dateFilter: (Date?, Date?)? = nil,
    withHousekeeping: Bool = true
  ) {
    super.init(credentials: credentials, dateFilter: dateFilter)

    if withHousekeeping { fetchData() }
  }

  func fetchData() {
    print("init count: ")

    super.doHousekeeping()

    // fetch cashflow data

    Task { await getCashflow() }
  }

  func getCashflow() async {
    let dateFilters = getPeriodParams(dateFilter: getDates())

      self.showLoading()
    do {
      let resData: LuneResponse<Cashflow>? = try await self.makeRequest(
        endpoint: "/cashflows?\(dateFilters)"
      )

      DispatchQueue.main.async { self.cashflow = resData?.data }
    } catch {
      LuneDelegates.handleError(.NetworkError(error))//            print(">>> Error: \(error)")
    }

      self.hideLoading()
  }
}

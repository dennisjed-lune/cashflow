//
//  CashflowChart.swift
//  LuneSDK
//
//  Created by Zamorite on 16/08/2023.
//

import Foundation

struct CashflowChart: View {
  var data: [NPieChartData] = []

  @Environment(\.colorScheme)
  var colorScheme

  var config: Config

  var displayAmount: Double = 0.0

  var dateFilters: (Date?, Date?)?

  var onTapSegment: ((Int) -> Void)?

  var isForCashflow: Bool

  var shouldAnnotate: Bool { isForCashflow ? false : true }

  var periodAnnotation: String? {
    if let filters = dateFilters {
      return Date.getCycleLabel(cycle: filters, config: config)
    } else {
      return nil
    }
  }

  @State private var selectedSegment: NPieChartData?

  let donutThickness: CGFloat = 0.9

  var cashflowConfig: Config.ComponentSpecific.LCCashflow? { config.componentSpecific.cashflow }

  var usingRoudedCap: Bool { cashflowConfig?.structure.chartRoundStrokeCap == true }

  //    Initialize with CategorySpend array
  init(
    cashflow: Cashflow?,
    config: Config,
    dateFilters: (Date?, Date?)? = nil,
    onTapSegment: ((Int) -> Void)? = nil
  ) {
    self.config = config
    self.isForCashflow = true
    self.dateFilters = dateFilters

    self.onTapSegment = onTapSegment

    self.displayAmount = cashflow?.difference ?? 0.0
    //        print("Init: \(cashflow); s: \(dateFilters?.0); e: \(dateFilters?.1)")

    // Assign to self.data
    if let cashflow = cashflow {
      self.data = CashflowChart.createCashflowChartData(from: cashflow, config: config)
    } else {
      self.data = [
        // income
        NPieChartData(
          id: +1,
          value: 0,
          colorIndex: nil,
          name: "lune_sdk_str_inflow".tr,
          annotation: nil
        ),

        // expense
        NPieChartData(
          id: -1,
          value: 0,
          colorIndex: nil,
          name: "lune_sdk_str_outflow".tr,
          annotation: nil
        )
      ]
    }
  }

  static func createCashflowChartData(from cashflow: Cashflow, config: Config) -> [NPieChartData] {
    return [
      // income
      NPieChartData(
        id: +1,
        value: cashflow.totalIncome,
        colorIndex: nil,
        name: "lune_sdk_str_inflow".tr,
        annotation: nil
      ),

      // expense
      NPieChartData(
        id: -1,
        value: cashflow.totalSpend,
        colorIndex: nil,
        name: "lune_sdk_str_outflow".tr,
        annotation: nil
      )
    ]
  }

  var missingOneSegment: Bool {
    data.count == 2 && data.filter { datum in datum.value == 0 }.count == 1
  }

  var strokeOffset: Double {
    missingOneSegment ? 0.0 : cashflowConfig?.structure.chartStrokeOffset ?? 0
  }
    var body: some View {
        GeometryReader { geometry in
          ZStack {
            // 1. Calculate the total value once so we can find the percentages
            let totalValue = data.map { $0.value.magnitude }.reduce(0, +)
              
            ForEach(Array(data.enumerated()), id: \.1.id) { index, segment in
              let next = nextSegment(after: segment, in: data)

              let startAngle = angle(for: segment, in: data) + Angle(degrees: strokeOffset)

              let endAngle =
                (next != nil ? angle(for: next!, in: data) : Angle(degrees: 270))
                - Angle(degrees: strokeOffset)

              let arcFits = startAngle <= endAngle

              let colorOpacity = segment.value.magnitude > 0 ? nil : 20

              // -1 here for expense
              let color =
                (segment.id == -1
                ? config.cashflowColors(colorScheme).expense
                : config.cashflowColors(colorScheme).income)
                .asColor(colorOpacity)

              // 2. Draw the Arc
              Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let radius = min(width, height) / 2

                if arcFits {
                  path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                  )
                }
              }
              .stroke(
                color,
                style: StrokeStyle(
                  lineWidth: cashflowConfig?.structure.chartStrokeWidth ?? 6,
                  lineCap: usingRoudedCap ? .round : .square
                )
              )
              .onTapGesture {
                if let callback = onTapSegment { callback(segment.id) }
              }
                
              // 3. LABEL BESIDE THE ARC — show the % AND the amount, so the
              // user reads the actual figure at a glance (no tap into a sheet).
              if segment.value.magnitude > 0 && totalValue > 0 {
                  let percentage = (segment.value.magnitude / totalValue) * 100

                  VStack(spacing: 1) {
                      Text("\(Int(percentage.rounded()))%")
                          .font(.system(size: 14, weight: .bold))
                          .foregroundColor(color) // Matches the text colour to the arc colour

                      AmountView(
                          amount: segment.value.magnitude,
                          font: config.textCustom(11),
                          trailingFont: config.textCustom(9),
                          foregroundColor: config.hintColor(colorScheme),
                          interactive: false,
                          config: config
                      )
                  }
                  // Uses the math function that places it beside the arc.
                  .position(iconPosition(for: segment, in: data, in: geometry.size))
              }
            }

            // Center Amounts (Unchanged)
            VStack {
              if cashflowConfig?.structure.showChartCenterAmount == true {
                AmountView(
                  amount: displayAmount,
                  font: config.textCustom(26),
                  trailingFont: config.textCustom(14),
                  foregroundColor: config.fg(colorScheme),
                  interactive: false,
                  config: config
                )

                if let periodAnnotation = periodAnnotation {
                  Text(periodAnnotation).font(config.hint)
                    .foregroundColor(config.hintColor(colorScheme))
                }
              } else if cashflowConfig?.structure.showChartCenterLabel == true {
                Text("lune_sdk_str_cashflow".tr).font(config.heading1)
              }
            }
          }
        }
        .frame(height: 180)
      }

  static private func angle(for segment: CategorySpend, in data: [CategorySpend]) -> Angle {
    let total = data.map { $0.amount.magnitude }.reduce(0, +)
    let value = data.prefix { $0 != segment }.map { $0.amount.magnitude }.reduce(0, +)
    let degrees = (value / total) * 360 - 90  // Subtract 90 degrees
    return Angle(degrees: degrees)
  }

  private func angle(for segment: NPieChartData, in data: [NPieChartData]) -> Angle {
    let total = data.map { $0.value.magnitude }.reduce(0, +)
    let value = data.prefix { $0 != segment }.map { $0.value.magnitude }.reduce(0, +)
    let degrees = (value / total) * 360 - 90  // Subtract 90 degrees

    //        print("t: \(total); v: \(value); d: \(degrees)")

    if total == 0.0 && value == 0.0 {
      //            +1 here for income
      return segment.id == +1 ? Angle(degrees: -90) : Angle(degrees: 90)
    }

    return Angle(degrees: degrees)
  }

  private func nextSegment(after segment: NPieChartData, in data: [NPieChartData]) -> NPieChartData? {
    guard let currentSegmentIndex = (data.firstIndex { $0 == segment }) else { return nil }
    let nextSegmentIndex = currentSegmentIndex + 1
    return nextSegmentIndex < data.count ? data[nextSegmentIndex] : nil
  }

  static private func nextCategory(after category: CategorySpend, in data: [CategorySpend])
    -> CategorySpend? {
    guard let currentCategoryIndex = (data.firstIndex { $0 == category }) else { return nil }
    let nextCategoryIndex = currentCategoryIndex + 1
    return nextCategoryIndex < data.count ? data[nextCategoryIndex] : nil
  }

  private func iconPosition(for segment: NPieChartData, in data: [NPieChartData], in size: CGSize)
    -> CGPoint {
    let center = CGPoint(x: size.width / 2, y: size.height / 2)
    let radius = min(size.width, size.height) / 2
    let startAngle = self.angle(for: segment, in: data).radians

    let endAngle: Double
    if let nextSegment = nextSegment(after: segment, in: data) {
      endAngle = self.angle(for: nextSegment, in: data).radians
    } else {
      endAngle = 1.5 * .pi  // This corresponds to the top center of the circle
    }

    let middleAngle = (startAngle + endAngle) / 2
    let padding: CGFloat = 30
    let x = center.x + CGFloat(cos(middleAngle)) * (radius + padding)
    let y = center.y + CGFloat(sin(middleAngle)) * (radius + padding)

    return CGPoint(x: x, y: y)
  }

  private func labelPosition(for segment: NPieChartData, in data: [NPieChartData], in size: CGSize)
    -> CGPoint {
    let center = CGPoint(x: size.width / 2, y: size.height / 2)
    let radius = min(size.width, size.height) / 2
    let startAngle = self.angle(for: segment, in: data).radians

    let endAngle: Double
    if let nextSegment = nextSegment(after: segment, in: data) {
      endAngle = self.angle(for: nextSegment, in: data).radians
    } else {
      endAngle = 1.5 * .pi  // This corresponds to the top center of the circle
    }

    let middleAngle = (startAngle + endAngle) / 2
    let padding: CGFloat = 45
    let x = center.x + CGFloat(cos(middleAngle)) * (radius + padding)
    var y = center.y + CGFloat(sin(middleAngle)) * (radius + padding)

    // translate y by radius-ish
    if let averageAngle = averageAngle(for: segment, in: data) {
      if averageAngle < -(.pi / 2) || averageAngle > .pi / 2 {
        y -= radius * 0.4
      } else {
        y += radius * 0.4
      }
    }

    return CGPoint(x: x, y: y)
  }

  private func averageAngle(for segment: NPieChartData, in data: [NPieChartData]) -> Double? {
    let startAngle = self.angle(for: segment, in: data).radians
    let endAngle: Double
    if let nextSegment = nextSegment(after: segment, in: data) {
      endAngle = self.angle(for: nextSegment, in: data).radians
    } else {
      endAngle = 1.5 * .pi
    }
    return (startAngle + endAngle) / 2 - .pi / 2
  }

  private func shouldAnnotate(for segment: NPieChartData, in data: [NPieChartData]) -> Bool {
    let startAngle = self.angle(for: segment, in: data).degrees
    let endAngle: Double
    if let nextSegment = nextSegment(after: segment, in: data) {
      endAngle = self.angle(for: nextSegment, in: data).degrees
    } else {
      endAngle = Angle(radians: (1.5 * .pi)).degrees
    }

    return endAngle - startAngle >= 27.5
  }

  static private func segmentSpan(for category: CategorySpend, in data: [CategorySpend]) -> Double {
    let startAngle = self.angle(for: category, in: data).degrees
    let endAngle: Double
    if let nextCategory = nextCategory(after: category, in: data) {
      endAngle = self.angle(for: nextCategory, in: data).degrees
    } else {
      endAngle = Angle(radians: (1.5 * .pi)).degrees
    }

    return endAngle - startAngle
  }

  static private func shouldAnnotateCategory(for category: CategorySpend, in data: [CategorySpend])
    -> Bool {
    let startAngle = self.angle(for: category, in: data).degrees
    let endAngle: Double
    if let nextCategory = nextCategory(after: category, in: data) {
      endAngle = self.angle(for: nextCategory, in: data).degrees
    } else {
      endAngle = Angle(radians: (1.5 * .pi)).degrees
    }

    return endAngle - startAngle >= 27.5
  }
}

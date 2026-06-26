//
//  Overview+SmartInsights.swift
//  LuneSDK
//
//  Created by Zamorite on 13/01/2025.
//

import SwiftUI

extension CashflowView {
    
    // MARK: - Smart Insights Entry Point
    
    @ViewBuilder
    func buildSummaryText() -> some View {
        if let cashflow = viewModel.cashflow {
            let insights = buildInsights(from: cashflow)
            
            if !insights.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    // Section header
                    HStack(spacing: 6) {
                        
                        Text("Smart Insights")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(config.fg(colorScheme))
                    }
                    .padding(.horizontal, 20)
                    
                    // Cards
                    VStack(spacing: 10) {
                        ForEach(insights.indices, id: \.self) { index in
                            InsightCard(insight: insights[index], config: config)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Insight Builder
    
    private func buildInsights(from cashflow: Cashflow) -> [Insight] {
        var insights: [Insight] = []
        
        if let summary = summaryInsight(from: cashflow) {
            insights.append(summary)
        }
        
        if let net = netCashflowInsight(from: cashflow) {
            insights.append(net)
        }
        
        if let saving = savingRateInsight(from: cashflow) {
            insights.append(saving)
        }
        
        if let dailyBurnRate = dailyBurnRateInsight(from: cashflow) {
            insights.append(dailyBurnRate)
        }
        
        if let cushion = financialCushionInsight(from: cashflow) {
            insights.append(cushion)
        }
        
        if let efficiency = incomeEfficiencyInsight(from: cashflow) {
            insights.append(efficiency)
        }
        
        if let risk = riskLevelInsight(from: cashflow) {
            insights.append(risk)
        }
        
        return insights
    }
    
    // MARK: - Insight Builders (Dynamic Range)
    
    private func summaryInsight(from cashflow: Cashflow) -> Insight? {
        guard !cashflow.summaryTexts.isEmpty else { return nil }
        
        return Insight(
            icon: cashflow.signifiesLoss ? "exclamationmark.triangle.fill" : "checkmark.seal.fill",
            title: "Period Summary",
            body: cashflow.summaryTexts.joined(),
            sentiment: cashflow.signifiesLoss ? .negative : .positive
        )
    }
    
    private func netCashflowInsight(from cashflow: Cashflow) -> Insight? {
        let income = cashflow.totalIncome
        let outgoing = abs(cashflow.totalSpend)
        
        let net = income - outgoing
        
        if net > 0 {
            return Insight(
                icon: "plus.circle.fill",
                title: "Net Cashflow",
                body: "You ended this period with a surplus of **\(Int(net)) AED**.",
                sentiment: .positive
            )
        } else if net == 0 {
            return Insight(
                icon: "equal.circle.fill",
                title: "Net Cashflow",
                body: "You broke even during this period. Income matched expenses exactly.",
                sentiment: .neutral
            )
        } else {
            return Insight(
                icon: "minus.circle.fill",
                title: "Net Cashflow",
                body: "You had a deficit of **\(Int(abs(net))) AED** over this period.",
                sentiment: .negative
            )
        }
    }
    
    private func financialCushionInsight(from cashflow: Cashflow) -> Insight? {
        let income = cashflow.totalIncome
        let outgoing = abs(cashflow.totalSpend)
        
        guard outgoing > 0 else { return nil }
        
        let net = income - outgoing
        
        if net <= 0 {
            return Insight(
                icon: "shield.slash.fill",
                title: "Financial Cushion",
                body: "You did not build a financial buffer during this timeframe.",
                sentiment: .negative
            )
        }
        
        let bufferPercentage = Int(((net / outgoing) * 100).rounded())
        
        return Insight(
            icon: "shield.fill",
            title: "Financial Cushion",
            body: "Your surplus could cover an additional **\(bufferPercentage)%** of this period's expenses.",
            sentiment: bufferPercentage >= 50 ? .positive : .warning
        )
    }
    
    private func incomeEfficiencyInsight(from cashflow: Cashflow) -> Insight? {
        let income = cashflow.totalIncome
        let outgoing = abs(cashflow.totalSpend)
        
        guard income > 0 else { return nil }
        
        let savingRate = (income - outgoing) / income
        let score = max(0, min(100, Int((savingRate * 100).rounded())))
        
        switch score {
        case 70...100:
            return Insight(
                icon: "star.fill",
                title: "Efficiency Score",
                body: "Excellent income utilization for this period. You're managing money efficiently. Score: **\(score)/100**",
                sentiment: .positive
            )
        case 40..<70:
            return Insight(
                icon: "star.leadinghalf.filled",
                title: "Efficiency Score",
                body: "Moderate financial efficiency over this timeframe. There's room to improve. Score: **\(score)/100**",
                sentiment: .warning
            )
        default:
            return Insight(
                icon: "star",
                title: "Efficiency Score",
                body: "Low efficiency. Expenses consumed most of your income during this period. Score: **\(score)/100**",
                sentiment: .negative
            )
        }
    }
    
    private func riskLevelInsight(from cashflow: Cashflow) -> Insight? {
        let income = cashflow.totalIncome
        let outgoing = abs(cashflow.totalSpend)
        
        guard income > 0 else { return nil }
        
        let ratio = outgoing / income
        
        switch ratio {
        case ..<0.6:
            return Insight(
                icon: "checkmark.shield.fill",
                title: "Risk Level",
                body: "Spending is low relative to income for this timeframe. Financial risk is **minimal**.",
                sentiment: .positive
            )
        case 0.6..<0.9:
            return Insight(
                icon: "exclamationmark.shield.fill",
                title: "Risk Level",
                body: "Spending approached your income level during this period. Monitor **carefully**.",
                sentiment: .warning
            )
        default:
            return Insight(
                icon: "flame.fill",
                title: "Risk Level",
                body: "Spending was very close to or exceeded income. Financial stress risk is **high**.",
                sentiment: .negative
            )
        }
    }
    
    private func savingRateInsight(from cashflow: Cashflow) -> Insight? {
        let income   = cashflow.totalIncome
        let outgoing = abs(cashflow.totalSpend)
        
        guard income > 0 else { return nil }
        
        let rate       = (income - outgoing) / income
        let percentage = Int((rate * 100).rounded())
        
        switch percentage {
        case 20...:
            return Insight(
                icon: "arrow.up.circle.fill",
                title: "Saving Rate",
                body: "You saved **\(percentage)%** of your income over this period. Keep it up!",
                sentiment: .positive
            )
        case 1..<20:
            return Insight(
                icon: "arrow.up.circle",
                title: "Saving Rate",
                body: "You saved **\(percentage)%** of your income during this timeframe.",
                sentiment: .warning
            )
        case 0:
            return Insight(
                icon: "minus.circle.fill",
                title: "Saving Rate",
                body: "You spent exactly what you earned during this period — nothing left over.",
                sentiment: .neutral
            )
        default:
            let overspent = abs(percentage)
            return Insight(
                icon: "arrow.down.circle.fill",
                title: "Saving Rate",
                body: "You overspent by **\(overspent)%** beyond your income during this selected period.",
                sentiment: .negative
            )
        }
    }
    
    // MARK: - 3. Daily Burn Rate Insight
    
    private func dailyBurnRateInsight(from cashflow: Cashflow) -> Insight? {
        let outgoing = abs(cashflow.totalSpend)
        let days = viewModel.days
        
        // Don't show the insight if they haven't spent anything
        guard outgoing > 0 else { return nil }
        
        let dailyAverage = outgoing / Double(days)
        let dailyIncome = cashflow.totalIncome / Double(days)
        
        // If they are burning more per day than they earn per day, flag it as a warning!
        let sentiment: Insight.Sentiment = (dailyAverage > dailyIncome && cashflow.totalIncome > 0) ? .warning : .neutral
        
        return Insight(
            icon: "flame.fill",
            title: "Daily Burn Rate",
            body: "You are spending an average of **\(Int(dailyAverage)) AED** per day during this timeframe.",
            sentiment: sentiment
        )
    }
}

// MARK: - Insight Model

struct Insight {
    enum Sentiment { case positive, warning, negative, neutral }
    
    let icon: String          // SF Symbol name
    let title: String         // Short label e.g. "Saving Rate"
    let body: String          // Full sentence e.g. "You saved 40% of your income this month."
    let sentiment: Sentiment
}

// MARK: - InsightCard

struct InsightCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    let insight: Insight
    let config: Config
    
    // MARK: Derived Colors
    
    private var accentColor: Color {
        switch insight.sentiment {
        case .positive: return Color.green
        case .warning:  return Color.orange
        case .negative: return Color.red
        case .neutral:  return Color.blue
        }
    }
    
    private var backgroundColor: Color {
        accentColor.opacity(colorScheme == .dark ? 0.12 : 0.06)
    }
    
    // MARK: Body
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            // Icon bubble
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: insight.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(accentColor)
            }
            
            // Text block
            VStack(alignment: .leading, spacing: 3) {
                Text(insight.title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(accentColor)
                    .textCase(.uppercase)
                
                // .init parses the markdown formatting (**) into bold text automatically!
                Text(.init(insight.body))
                    .font(config.hint)
                    .foregroundColor(config.fg(colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
            }
            
            Spacer(minLength: 8)
        }
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(config.hintColor(colorScheme).opacity(0.2), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(insight.title). \(insight.body)")
    }
}

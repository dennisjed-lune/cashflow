//
//  CashflowView+TimelineButton.swift
//  LuneSDK
//
//  Created by Eslam Ali on 30/03/2026.
//

import Foundation

extension CashflowView {
    
    @ViewBuilder
    func buildViewTimelineButton() -> some View {
        Button(action: {
            self.viewingTimeline = true
        }) {
            Text("View Timeline")
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity)
                .foregroundColor(config.primaryColor(colorScheme))
                .padding(.vertical, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(config.hintColor(colorScheme).opacity(0.1), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    //    .padding(.horizontal, 16)
    }
}

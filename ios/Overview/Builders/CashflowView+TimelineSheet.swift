//
//  CashflowView+TimelineSheet.swift
//  LuneSDK
//
//  Created by Eslam Ali on 30/03/2026.
//

import Foundation

extension CashflowView {
    
    @ViewBuilder
    func buildTimelineSheet() -> some View {
        
        VStack {
            buildHeader()
            
            CashflowTimelineView(config: config, credentials: credentials)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func buildHeader() -> some View {
        HStack {
            Text("Cashflow Timeline")
                .font(config.heading0)
            
            Spacer()
            
            Button(
                action: {
                    viewingTimeline = false
                    reportModalTappedClose(.timeline_modal)
                },
                label: {
                    Image("lune_sdk_asset_close", bundle: Bundle(identifier: "io.lunedata.LuneSDK"))
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(config.fg(colorScheme))
                        .padding(8)
                        .background(
                            Circle().fill(config.fg(colorScheme).opacity(0.05))
                        )
                }
            )
        }
        .padding()
        .padding(.top)
    }
}


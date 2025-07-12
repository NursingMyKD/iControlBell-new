//
//  RaulandConnectionView.swift
// Ensure this file is included in the main app target
//  iControlBell - Rauland Responder 5 Connection Status View
//
//  Created by GitHub Copilot on 12/25/24.
//

import SwiftUI


/// View showing Rauland Responder 5 connection status and controls
struct RaulandConnectionView: View {
    @ObservedObject var raulandManager: RaulandAPIManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject var appState: AppState
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact || DeviceUtils.screenSize == .iPhoneSmall
    }
    
    private var isIPad: Bool {
        DeviceUtils.isIPad
    }
    
    var body: some View {
        VStack(spacing: dynamicSpacing) {
            // Connection Status Header
            connectionStatusHeader
            
            // Placeholder Mode Indicator
            placeholderModeIndicator
            
            // Facility Information (if connected)
            if raulandManager.isConnected, let facilityInfo = raulandManager.facilityInfo {
                facilityInfoSection(facilityInfo)
            }
            
            // Connection Controls
            connectionControls
            
            // Error Display
            if let error = raulandManager.lastError {
                errorSection(error)
            }
        }
        .padding(containerPadding)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .background(Color.adaptiveCardBackground)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("rauland_connection_status".localized)
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var connectionStatusHeader: some View {
        HStack(spacing: 12) {
            // Status Icon
            statusIcon
                .font(.system(size: iconSize))
                .foregroundColor(statusColor)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("rauland_connection_title".localized)
                    .font(titleFont)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(raulandManager.connectionState.displayName)
                    .font(statusFont)
                    .foregroundColor(statusColor)
            }
            
            Spacer()
            
            // Connection Indicator
            connectionIndicator
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\("rauland_connection_title".localized): \(raulandManager.connectionState.displayName)")
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        switch raulandManager.connectionState {
        case .connected:
            Image(systemName: "checkmark.circle.fill")
        case .connecting, .authenticating:
            Image(systemName: "arrow.triangle.2.circlepath")
        case .error:
            Image(systemName: "exclamationmark.triangle.fill")
        case .suspended:
            Image(systemName: "pause.circle.fill")
        case .disconnected:
            Image(systemName: "circle")
        }
    }
    
    @ViewBuilder
    private var connectionIndicator: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 12, height: 12)
            .opacity(raulandManager.connectionState == .connecting || 
                    raulandManager.connectionState == .authenticating ? 0.5 : 1.0)
            .scaleEffect(raulandManager.connectionState == .connecting || 
                        raulandManager.connectionState == .authenticating ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), 
                      value: raulandManager.connectionState)
    }
    
    @ViewBuilder
    private func facilityInfoSection(_ facilityInfo: RaulandFacilityInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
                
                Text(facilityInfo.name)
                    .font(bodyFont)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            if !facilityInfo.features.isEmpty {
                HStack {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                    
                    Text("rauland_features".localized + ": " + facilityInfo.features.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .background(Color.adaptiveSecondaryBackground)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\("rauland_facility".localized): \(facilityInfo.name)")
    }
    
    @ViewBuilder
    private var connectionControls: some View {
        HStack(spacing: dynamicSpacing) {
            if raulandManager.connectionState.allowsConnection {
                // Connect Button
                Button(action: {
                    Task {
                        HapticUtils.impact(.medium)
                        let result = await raulandManager.connect()
                        
                        switch result {
                        case .success:
                            appState.showToast("rauland_connection_successful".localized)
                        case .failure(let error):
                            appState.showToast(error.localizedDescription, isError: true)
                        }
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "power")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text("rauland_connect".localized)
                            .font(buttonFont)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .background(Color.accentColor)
                    )
                }
                .disabled(raulandManager.connectionState == .connecting || 
                         raulandManager.connectionState == .authenticating)
                .accessibilityLabel("rauland_connect_button".localized)
                .accessibilityHint("double_tap_to_connect_rauland".localized)
                
            } else if raulandManager.isConnected {
                // Disconnect Button
                Button(action: {
                    HapticUtils.impact(.light)
                    raulandManager.disconnect()
                    appState.showToast("rauland_disconnected".localized)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "power")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text("rauland_disconnect".localized)
                            .font(buttonFont)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .background(Color.red)
                    )
                }
                .accessibilityLabel("rauland_disconnect_button".localized)
                .accessibilityHint("double_tap_to_disconnect_rauland".localized)
            }
            
            // Refresh/Test Connection Button
            if raulandManager.isConnected {
                Button(action: {
                    Task {
                        HapticUtils.impact(.light)
                        let result = await raulandManager.refreshSession()
                        
                        switch result {
                        case .success:
                            appState.showToast("rauland_session_refreshed".localized)
                        case .failure(let error):
                            appState.showToast(error.localizedDescription, isError: true)
                        }
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))
                        
                        if !isCompact {
                            Text("rauland_refresh".localized)
                                .font(buttonFont)
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, isCompact ? 12 : 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.accentColor, lineWidth: 1.5)
                            )
                    )
                }
                .accessibilityLabel("rauland_refresh_button".localized)
                .accessibilityHint("double_tap_to_refresh_rauland".localized)
            }
        }
    }
    
    @ViewBuilder
    private func errorSection(_ error: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 16))
            
            Text(error)
                .font(bodyFont)
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .background(Color.red.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\("error".localized): \(error)")
    }
    
    // MARK: - Dynamic Properties
    
    private var statusColor: Color {
        switch raulandManager.connectionState {
        case .connected:
            return .green
        case .connecting, .authenticating:
            return .orange
        case .error:
            return .red
        case .suspended:
            return .yellow
        case .disconnected:
            return .secondary
        }
    }
    
    @ViewBuilder
    private var placeholderModeIndicator: some View {
        // Show placeholder mode indicator when connected (since we're always in placeholder mode)
        if raulandManager.isConnected {
            HStack(spacing: 8) {
                Image(systemName: "testtube.2")
                    .foregroundColor(.orange)
                    .font(.system(size: 14))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("rauland_placeholder_mode".localized)
                        .font(.caption)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.orange)
                    
                    Text("rauland_placeholder_demo_note".localized)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .background(Color.orange.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel("rauland_placeholder_mode".localized)
        }
    }
    
    // MARK: - Dynamic Properties
    
    private var dynamicSpacing: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 12, regular: 16, iPad: 20) *
        (AccessibilityUtils.isVoiceOverRunning ? 1.3 : 1.0)
    }
    
    private var containerPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 12, regular: 16, iPad: 20)
    }
    
    private var iconSize: CGFloat {
        let baseSize = DeviceUtils.dynamicSpacing(compact: 20, regular: 24, iPad: 28)
        return baseSize * (AccessibilityUtils.isVoiceOverRunning ? 1.2 : 1.0)
    }
    
    private var titleFont: Font {
        DeviceUtils.dynamicFont(
            compact: .system(size: 16, weight: .semibold),
            regular: .system(size: 18, weight: .semibold),
            iPad: .system(size: 20, weight: .semibold)
        )
    }
    
    private var statusFont: Font {
        DeviceUtils.dynamicFont(
            compact: .system(size: 14),
            regular: .system(size: 16),
            iPad: .system(size: 18)
        )
    }
    
    private var bodyFont: Font {
        DeviceUtils.dynamicFont(
            compact: .system(size: 13),
            regular: .system(size: 15),
            iPad: .system(size: 17)
        )
    }
    
    private var buttonFont: Font {
        DeviceUtils.dynamicFont(
            compact: .system(size: 14, weight: .semibold),
            regular: .system(size: 16, weight: .semibold),
            iPad: .system(size: 18, weight: .semibold)
        )
    }
}



#Preview {
    let mockManager = RaulandAPIManager(networkService: MockNetworkService())
    VStack {
        RaulandConnectionView(raulandManager: mockManager)
            .environmentObject(AppState(raulandManager: mockManager))
    }
    .padding()
    .background(Color.adaptiveBackground)
}

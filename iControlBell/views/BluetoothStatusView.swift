// BluetoothStatusView.swift
// SwiftUI view to show Bluetooth connection status and allow triggering the call bell

import SwiftUI

/// Displays Bluetooth connection status and allows triggering the call bell.
struct BluetoothStatusView: View {
    @ObservedObject var bluetooth: BluetoothManager
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var statusFont: Font {
        DeviceUtils.dynamicFont(
            compact: .caption,
            regular: .body,
            iPad: .title3
        )
    }
    
    private var buttonFont: Font {
        DeviceUtils.dynamicFont(
            compact: .footnote,
            regular: .body,
            iPad: .title3
        )
    }
    
    private var circleSize: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 12, regular: 16, iPad: 20)
    }
    
    private var buttonPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 8, regular: 12, iPad: 16)
    }
    
    private var cornerRadius: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 6, regular: 8, iPad: 12)
    }
    
    var body: some View {
        VStack(spacing: isIPad ? 20 : (isCompact ? 12 : 16)) {
            // Connection status indicator
            HStack(spacing: isIPad ? 12 : 8) {
                Circle()
                    .fill(bluetooth.isConnected ? Color.green : Color.red)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .opacity(bluetooth.isConnected ? 1 : 0)
                            .scaleEffect(bluetooth.isConnected ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: bluetooth.isConnected)
                    )
                
                Text(bluetooth.isConnected ? "bluetooth_connected".localized : "bluetooth_not_connected".localized)
                    .font(statusFont)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .accessibilityLabel(bluetooth.isConnected ? "bluetooth_connected_accessibility".localized : "bluetooth_not_connected_accessibility".localized)
            }
            
            // Call bell trigger button
            Button(action: {
                bluetooth.triggerCallBell()
                SoundManager.shared.playConfirmationSound()
                appState.showToast("Call bell activated!")
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: isIPad ? 20 : (isCompact ? 14 : 16)))
                    
                    Text("trigger_call_bell".localized)
                        .font(buttonFont)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, buttonPadding * 1.5)
                .padding(.vertical, buttonPadding)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(bluetooth.isConnected ? Color.accentColor : Color.gray)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .foregroundColor(.white)
                .opacity(bluetooth.isConnected ? 1.0 : 0.6)
            }
            .disabled(!bluetooth.isConnected)
            .buttonStyle(ScaleButtonStyle())
            .accessibilityLabel("trigger_call_bell".localized)
            .accessibilityHint(bluetooth.isConnected ? "Double tap to activate call bell" : "Call bell unavailable - Bluetooth not connected")
            
            // Error display
            if let error = bluetooth.lastError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: isIPad ? 16 : 12))
                    
                    Text("Bluetooth Error: \(error)")
                        .font(isCompact ? .caption2 : .caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .onAppear {
                    appState.showBluetoothError(error)
                }
            }
            
            // Scanning indicator
            if !bluetooth.isConnected {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(isCompact ? 0.8 : 1.0)
                    
                    Text("Scanning for devices...")
                        .font(isCompact ? .caption2 : .caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(isIPad ? 20 : (isCompact ? 12 : 16))
        .background(Color(.systemGray6))
        .cornerRadius(isIPad ? 16 : 12)
        .onAppear {
            bluetooth.startScanning()
        }
        .onDisappear {
            bluetooth.stopScanning()
        }
    }
}

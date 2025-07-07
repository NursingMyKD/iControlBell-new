// BluetoothStatusView.swift
// SwiftUI view to show Bluetooth connection status and allow triggering the call bell

import SwiftUI

/// Displays Bluetooth connection status and allows triggering the call bell.
struct BluetoothStatusView: View {
    @ObservedObject var bluetooth: BluetoothManager
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Circle()
                    .fill(bluetooth.isConnected ? Color.green : Color.red)
                    .frame(width: 16, height: 16)
                Text(bluetooth.isConnected ? "bluetooth_connected".localized : "bluetooth_not_connected".localized)
                    .accessibilityLabel(bluetooth.isConnected ? "bluetooth_connected_accessibility".localized : "bluetooth_not_connected_accessibility".localized)
            }
            Button(action: {
                bluetooth.triggerCallBell()
            }) {
                Text("trigger_call_bell".localized)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!bluetooth.isConnected)
            if let error = bluetooth.lastError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .onAppear {
                        appState.showBluetoothError(error)
                    }
            }
        }
        .padding()
        .onAppear {
            bluetooth.startScanning()
        }
        .onDisappear {
            bluetooth.stopScanning()
        }
    }
}

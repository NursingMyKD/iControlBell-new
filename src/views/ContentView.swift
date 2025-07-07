// ContentView.swift
// Main Home Screen for iControlBell

import SwiftUI

/// The main home screen for iControlBell, displaying logo, language selector, Bluetooth status, call requests, and soundboard.
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var soundboardData = SoundboardData(language: .english)
    @StateObject private var callRequestData = CallRequestData(language: .english)
    
    var body: some View {
        NavigationStack {
            ScrollView { // Use ScrollView for large screens
                VStack(spacing: 24) {
                    LogoView()
                        .accessibilityHidden(true)
                    Text("app_title".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .accessibilityAddTraits(.isHeader)
                    Text("app_description".localized)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    LanguageSelectorView(selectedLanguage: $appState.selectedLanguage)
                    Divider()
                    BluetoothStatusView(bluetooth: BluetoothManager.shared).environmentObject(appState)
                    Divider()
                    CallRequestGridView(selectedLanguage: appState.selectedLanguage, callRequests: callRequestData.options)
                        .environmentObject(appState)
                    Divider()
                    SoundboardView(selectedLanguage: appState.selectedLanguage, categories: soundboardData.categories)
                    Spacer()
                }
                .padding()
            }
            .onChange(of: appState.selectedLanguage) { newLanguage in
                soundboardData.language = newLanguage
                callRequestData.loadOptions(for: newLanguage)
            }
            .overlay(
                Group {
                    if let message = appState.toastMessage {
                        ToastView(message: message, isError: appState.toastIsError)
                            .zIndex(1)
                    }
                }, alignment: .top
            )
        }
    }
}

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
}

#Preview {
    ContentView().environmentObject(AppState())
}

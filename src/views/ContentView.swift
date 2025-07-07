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
            ZStack {
                // Dark background to match the image
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header Section
                        VStack(spacing: 16) {
                            // Logo and title
                            VStack(spacing: 8) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                
                                Text("iControlBell")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            // Description
                            Text("Focus your gaze on the button below that best describes your need to call for assistance, or use the soundboard to speak.")
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                            
                            // Language selector
                            VStack(spacing: 8) {
                                Text("Select Language:")
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                LanguageSelectorView(selectedLanguage: $appState.selectedLanguage)
                            }
                        }
                        
                        // Call Request Grid - exactly 5 buttons in a row
                        CallRequestGridView(selectedLanguage: appState.selectedLanguage, callRequests: callRequestData.options)
                            .environmentObject(appState)
                        
                        // Soundboard
                        SoundboardView(selectedLanguage: appState.selectedLanguage, categories: soundboardData.categories)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .onChange(of: appState.selectedLanguage) { newLanguage in
                soundboardData.updateLanguage(newLanguage)
                callRequestData.updateLanguage(newLanguage)
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

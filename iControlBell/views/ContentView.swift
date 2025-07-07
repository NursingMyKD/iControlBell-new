// ContentView.swift
// Main Home Screen for iControlBell

import SwiftUI
import Foundation

/// The main home screen for iControlBell, displaying logo, language selector, Bluetooth status, call requests, and soundboard.
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var soundboardData = SoundboardData(language: .english)
    @StateObject private var callRequestData = CallRequestData(language: .english)
    
    // Environment values for responsive design
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    // Device utilities for responsive design
    private var isIPad: Bool {
        DeviceUtils.isIPad
    }
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact || DeviceUtils.screenSize == .iPhoneSmall
    }
    
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Adaptive background
                Color.adaptiveBackground
                    .ignoresSafeArea()
                
                if isLandscape && !isIPad {
                    // Landscape layout for iPhone
                    landscapeLayout
                } else {
                    // Portrait layout for iPhone and all iPad orientations
                    portraitLayout
                }
            }
            .navigationBarHidden(true)
            .accessibilityAware()
            .onChange(of: appState.selectedLanguage) { newLanguage in
                soundboardData.updateLanguage(newLanguage)
                callRequestData.updateLanguage(newLanguage)
                HapticUtils.selection() // Haptic feedback for language change
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
        .navigationViewStyle(StackNavigationViewStyle()) // Prevents split view on iPad
    }
    
    // MARK: - Layout Variations
    
    @ViewBuilder
    private var portraitLayout: some View {
        ScrollView {
            VStack(spacing: dynamicSpacing) {
                // Header Section
                headerSection
                
                // Call Request Grid
                CallRequestGridView(
                    selectedLanguage: appState.selectedLanguage, 
                    callRequests: callRequestData.options,
                    isIPad: isIPad,
                    isCompact: isCompact
                )
                .environmentObject(appState)
                
                // Soundboard
                SoundboardView(
                    selectedLanguage: appState.selectedLanguage, 
                    categories: soundboardData.categories,
                    isIPad: isIPad,
                    isCompact: isCompact
                )
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
    }
    
    @ViewBuilder
    private var landscapeLayout: some View {
        HStack(spacing: 20) {
            // Left side - Header and Language
            VStack(spacing: 16) {
                headerSection
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            // Right side - Call requests and soundboard
            VStack(spacing: 20) {
                CallRequestGridView(
                    selectedLanguage: appState.selectedLanguage, 
                    callRequests: callRequestData.options,
                    isIPad: isIPad,
                    isCompact: isCompact
                )
                .environmentObject(appState)
                
                SoundboardView(
                    selectedLanguage: appState.selectedLanguage, 
                    categories: soundboardData.categories,
                    isIPad: isIPad,
                    isCompact: isCompact
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: headerSpacing) {
            // Logo and title
            VStack(spacing: 8) {
                Image(systemName: "phone.fill")
                    .font(.system(size: logoSize))
                    .foregroundColor(.primary)
                
                Text("iControlBell")
                    .font(titleFont)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Description
            Text("Focus your gaze on the button below that best describes your need to call for assistance, or use the soundboard to speak.")
                .font(bodyFont)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, isIPad ? 60 : 20)
            
            // Language selector
            VStack(spacing: 8) {
                Text("Select Language:")
                    .font(bodyFont)
                    .foregroundColor(.primary)
                
                LanguageSelectorView(selectedLanguage: $appState.selectedLanguage)
            }
            
            // Bluetooth status (only show on iPad or in landscape mode)
            if isIPad || isLandscape {
                BluetoothStatusView(bluetooth: BluetoothManager.shared)
                    .environmentObject(appState)
            }
        }
    }
    
    // MARK: - Dynamic Properties
    
    private var dynamicSpacing: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 20, regular: 32, iPad: 40) *
        (AccessibilityUtils.isVoiceOverRunning ? 1.5 : 1.0)
    }
    
    private var headerSpacing: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 12, regular: 16, iPad: 20) *
        (AccessibilityUtils.isVoiceOverRunning ? 1.5 : 1.0)
    }
    
    private var horizontalPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 16, regular: 20, iPad: 40) *
        (AccessibilityUtils.isVoiceOverRunning ? 1.5 : 1.0)
    }
    
    private var verticalPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 12, regular: 20, iPad: 30) *
        (AccessibilityUtils.isVoiceOverRunning ? 1.5 : 1.0)
    }
    
    private var logoSize: CGFloat {
        let baseSize = DeviceUtils.dynamicSpacing(compact: 30, regular: 40, iPad: 60)
        return baseSize * (AccessibilityUtils.isVoiceOverRunning ? 1.2 : 1.0)
    }
    
    private var titleFont: Font {
        DeviceUtils.dynamicFont(
            compact: .system(size: 22, weight: .bold),
            regular: .system(size: 28, weight: .bold),
            iPad: .system(size: 34, weight: .bold)
        )
    }
    
    private var bodyFont: Font {
        DeviceUtils.dynamicFont(
            compact: .system(size: 13),
            regular: .system(size: 17),
            iPad: .system(size: 20)
        )
    }
}

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
}

#Preview {
    ContentView().environmentObject(AppState())
}

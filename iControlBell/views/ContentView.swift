// ContentView.swift
// Main Home Screen for iControlBell

import SwiftUI
import Foundation

/// The main home screen for iControlBell, displaying logo, language selector, Bluetooth status, call requests, and soundboard.
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var soundboardData = SoundboardData(language: .english)
    @StateObject private var callRequestData = CallRequestData(language: .english)
    
    // Device type detection
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact
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
        let baseSpacing: CGFloat
        if isIPad {
            baseSpacing = 40
        } else if isCompact {
            baseSpacing = 20
        } else {
            baseSpacing = 32
        }
        return AccessibilityUtils.accessibleSpacing(base: baseSpacing)
    }
    
    private var headerSpacing: CGFloat {
        let baseSpacing: CGFloat = isIPad ? 20 : 16
        return AccessibilityUtils.accessibleSpacing(base: baseSpacing)
    }
    
    private var horizontalPadding: CGFloat {
        let basePadding: CGFloat
        if isIPad {
            basePadding = 40
        } else if isCompact {
            basePadding = 16
        } else {
            basePadding = 20
        }
        return AccessibilityUtils.accessibleSpacing(base: basePadding)
    }
    
    private var verticalPadding: CGFloat {
        let basePadding: CGFloat
        if isIPad {
            basePadding = 30
        } else if isCompact {
            basePadding = 12
        } else {
            basePadding = 20
        }
        return AccessibilityUtils.accessibleSpacing(base: basePadding)
    }
    
    private var logoSize: CGFloat {
        let baseSize: CGFloat
        if isIPad {
            baseSize = 60
        } else if isCompact {
            baseSize = 30
        } else {
            baseSize = 40
        }
        return AccessibilityUtils.accessibleFontSize(base: baseSize)
    }
    
    private var titleFont: Font {
        if isIPad {
            return .system(size: AccessibilityUtils.accessibleFontSize(base: 34), weight: .bold)
        } else if isCompact {
            return .system(size: AccessibilityUtils.accessibleFontSize(base: 22), weight: .bold)
        } else {
            return .system(size: AccessibilityUtils.accessibleFontSize(base: 28), weight: .bold)
        }
    }
    
    private var bodyFont: Font {
        if isIPad {
            return .system(size: AccessibilityUtils.accessibleFontSize(base: 20))
        } else if isCompact {
            return .system(size: AccessibilityUtils.accessibleFontSize(base: 13))
        } else {
            return .system(size: AccessibilityUtils.accessibleFontSize(base: 17))
        }
    }
}

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
}

#Preview {
    ContentView().environmentObject(AppState())
}

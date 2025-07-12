// ContentView.swift
// Main Home Screen for iControlBell

import SwiftUI
import Foundation


/// The main home screen for iControlBell, displaying logo, language selector, call requests, and soundboard.
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var soundboardData = SoundboardData(language: .english)
    @StateObject private var callRequestData = CallRequestData(language: .english)
    @State private var showingSettings = false
    
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
                Color.adaptiveBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Prominent connection status banner
                    ConnectionStatusBanner(
                        status: appState.getConnectionStatus(),
                        isConnected: appState.raulandManager.isConnected,
                        isConnecting: appState.raulandManager.connectionState == .connecting || appState.raulandManager.connectionState == .authenticating
                    )
                    .padding(.bottom, 4)
                    if isLandscape && !isIPad {
                        landscapeLayout
                    } else {
                        portraitLayout
                    }
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
                ZStack(alignment: .top) {
                    // Persistent confirmation banner
                    if appState.showConfirmationBanner {
                        ConfirmationBanner(text: appState.confirmationBannerText, seconds: appState.confirmationBannerSeconds)
                            .zIndex(3)
                            .padding(.top, 8)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    // Toast overlay
                    if let message = appState.toastMessage {
                        ToastView(message: message, isError: appState.toastIsError)
                            .zIndex(1)
                    }
                    // Onboarding overlay
                    if appState.showOnboarding {
                        OnboardingOverlayView {
                            appState.showOnboarding = false
                        }
                        .zIndex(2)
                    }
                }, alignment: .top
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Layout Variations
    
    @ViewBuilder
    private var portraitLayout: some View {
        ScrollView {
            VStack(spacing: dynamicSpacing) {
                // Header Section
                headerSection
                
                // Rauland Connection Status
                RaulandConnectionView(raulandManager: appState.raulandManager)
                    .environmentObject(appState)
                
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
            // Left side - Header, Language, and Connection
            VStack(spacing: 16) {
                headerSection
                
                // Rauland Connection Status (compact view for landscape)
                RaulandConnectionView(raulandManager: appState.raulandManager)
                    .environmentObject(appState)
                
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
            // Logo and title with settings button
            HStack {
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: logoSize))
                        .foregroundColor(.primary)
                    
                    Text("app_title".localized)
                        .font(titleFont)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Settings button
                Button(action: {
                    HapticUtils.selection()
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.adaptiveCardBackground)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                }
                .accessibilityLabel("settings".localized)
                .accessibilityHint("double_tap_to_open_settings".localized)
            }
            
            // Description
            Text("main_description".localized)
                .font(bodyFont)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, isIPad ? 60 : 20)
            
            // Language selector
            VStack(spacing: 8) {
                Text("select_language".localized)
                    .font(bodyFont)
                    .foregroundColor(.primary)
                
                LanguageSelectorView(selectedLanguage: $appState.selectedLanguage)
            }
        }
        .sheet(isPresented: $showingSettings) {
            RaulandConfigurationView()
                .environmentObject(appState)
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


#Preview {
    let mockManager = RaulandAPIManager(networkService: MockNetworkService())
    ContentView().environmentObject(AppState(raulandManager: mockManager))
}

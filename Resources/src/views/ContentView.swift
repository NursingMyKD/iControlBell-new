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
    @State private var connectionStatus: String = ""
    
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
                Color(.systemBackground).ignoresSafeArea()
                VStack(spacing: 0) {
                    // Main content
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
            .onAppear {
                Task {
                    connectionStatus = await appState.getConnectionStatus()
                }
            }
            .onChange(of: appState.raulandManager.connectionState) { _ in
                Task {
                    connectionStatus = await appState.getConnectionStatus()
                }
            }
            .onChange(of: appState.isRaulandConfigured) { _ in
                Task {
                    connectionStatus = await appState.getConnectionStatus()
                }
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
            VStack(spacing: dynamicSpacing * 0.7) {
                // Header Section
                headerSection



                // Call Request Grid - visually grouped
                GroupBox(label: Label("Requests", systemImage: "bell.fill").font(.title2).foregroundColor(.accentColor)) {
                    CallRequestGridView(
                        selectedLanguage: appState.selectedLanguage,
                        callRequests: callRequestData.options,
                        isIPad: isIPad,
                        isCompact: isCompact
                    )
                    .environmentObject(appState)
                }
                .groupBoxStyle(DefaultGroupBoxStyle())
                .padding(.vertical, 8)

                // Soundboard - visually grouped
                GroupBox(label: Label("soundboard".localized, systemImage: "speaker.wave.2.fill").font(.title2).foregroundColor(.accentColor)) {
                    SoundboardView(
                        selectedLanguage: appState.selectedLanguage,
                        categories: soundboardData.categories,
                        isIPad: isIPad,
                        isCompact: isCompact
                    )
                }
                .groupBoxStyle(DefaultGroupBoxStyle())
                .padding(.vertical, 8)

                Spacer(minLength: 20)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
    }
    
    @ViewBuilder
    private var landscapeLayout: some View {
        HStack(spacing: 12) {
            // Left side - Header, Language, and Connection
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
        VStack(spacing: headerSpacing * 0.7) {
            // Logo, title, status indicator, and settings button
            HStack(alignment: .center) {
                // Small connectivity indicator
                Circle()
                    .frame(width: 14, height: 14)
                    .foregroundColor(
                        appState.raulandManager.connectionState == .connected ? .green :
                        (appState.raulandManager.connectionState == .connecting || appState.raulandManager.connectionState == .authenticating ? .yellow : .red)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                    .accessibilityLabel(appState.raulandManager.connectionState == .connected ? "Connected" : (appState.raulandManager.connectionState == .connecting || appState.raulandManager.connectionState == .authenticating ? "Connecting" : "Disconnected"))
                    .accessibilityHint("Connection status indicator")
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: logoSize, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("app_title".localized)
                        .font(titleFont)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .accessibilityAddTraits(.isHeader)
                }
                Spacer()
                // Settings button
                Button(action: {
                    HapticUtils.selection()
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("settings".localized)
                .accessibilityHint("double_tap_to_open_settings".localized)
            }
            // Description
            // ...removed main_description and select_language UI...
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

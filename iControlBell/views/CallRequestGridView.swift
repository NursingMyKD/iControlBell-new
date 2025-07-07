// CallRequestGridView.swift
// Grid of call request buttons

import SwiftUI
import Foundation

/// Displays a grid of call request buttons for the patient UI.
struct CallRequestGridView: View {
    var selectedLanguage: Language
    var callRequests: [CallRequestOption]
    var isIPad: Bool
    var isCompact: Bool
    @EnvironmentObject var appState: AppState
    
    // Dynamic layout properties using DeviceUtils
    private var columns: Int {
        DeviceUtils.adaptiveColumns(for: "callRequests")
    }
    
    private var buttonHeight: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 100, regular: 120, iPad: 140)
    }
    
    private var iconSize: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 24, regular: 32, iPad: 40)
    }
    
    private var buttonFont: Font {
        DeviceUtils.dynamicFont(
            compact: .caption,
            regular: .body,
            iPad: .title3
        )
    }
        } else {
            return .body
        }
    }
    
    private var buttonSpacing: CGFloat {
        if isIPad {
            return 20
        } else if isCompact {
            return 12
        } else {
            return 16
        }
    }
    
    private var horizontalPadding: CGFloat {
        if isIPad {
            return 24
        } else if isCompact {
            return 12
        } else {
            return 16
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if isIPad || (!isCompact && callRequests.count <= 5) {
                // Single row layout for iPad or when 5 or fewer buttons on regular iPhone
                HStack(spacing: buttonSpacing) {
                    ForEach(callRequests.prefix(5)) { option in
                        callRequestButton(for: option)
                    }
                }
                .padding(.horizontal, horizontalPadding)
            } else {
                // Grid layout for compact devices or when more than 5 buttons
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: buttonSpacing), count: columns),
                    spacing: buttonSpacing
                ) {
                    ForEach(callRequests) { option in
                        callRequestButton(for: option)
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
    }
    
    @ViewBuilder
    private func callRequestButton(for option: CallRequestOption) -> some View {
        Button(action: {
            // Simple haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            // Play confirmation sound
            SoundManager.shared.playConfirmationSound()
            
            let message = option.label(for: selectedLanguage) + " request sent!"
            appState.showToast(message)
            
            // Success haptic
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let success = UINotificationFeedbackGenerator()
                success.notificationOccurred(.success)
            }
        }) {
            VStack(spacing: isCompact ? 4 : 8) {
                Image(systemName: option.iconName)
                    .font(.system(size: iconSize))
                    .foregroundColor(.white)
                    .frame(height: iconSize)
                
                Text(option.label(for: selectedLanguage))
                    .font(buttonFont)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(isCompact ? 2 : 3)
                    .minimumScaleFactor(0.8)
            }
            .padding(.vertical, isIPad ? 32 : (isCompact ? 16 : 24))
            .padding(.horizontal, isIPad ? 20 : (isCompact ? 8 : 16))
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        UIAccessibility.isDarkerSystemColorsEnabled ? 
                            Color(red: 0.0, green: 0.5, blue: 0.6) : Color(red: 0.0, green: 0.7, blue: 0.7),
                        UIAccessibility.isDarkerSystemColorsEnabled ? 
                            Color(red: 0.0, green: 0.3, blue: 0.4) : Color(red: 0.0, green: 0.5, blue: 0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(isIPad ? 20 : (isCompact ? 12 : 16))
            .shadow(
                color: .black.opacity(UIAccessibility.isDarkerSystemColorsEnabled ? 0.5 : 0.2), 
                radius: isIPad ? 8 : 4, 
                x: 0, 
                y: 2
            )
        }
        .frame(minWidth: 44, minHeight: max(buttonHeight, 44)) // Ensure minimum touch target
        .accessibilityLabel("\(option.label(for: selectedLanguage)) request button")
        .accessibilityHint("Double tap to send \(option.label(for: selectedLanguage).lowercased()) assistance request")
        .accessibilityIdentifier("button_\(option.id)")
        .accessibilityAddTraits(.isButton)
        .buttonStyle(ScaleButtonStyle())
    }
}

// Custom button style for better touch feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

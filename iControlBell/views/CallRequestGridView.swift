// CallRequestGridView.swift
// Grid of call request buttons

import SwiftUI
import Foundation

/// Displays a grid of call request buttons for the patient UI.
struct CallRequestGridView: View {
    var selectedLanguage: Language
    var callRequests: [CallRequestOption]
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 16) {
            // Five call request buttons in a horizontal row
            HStack(spacing: 16) {
                ForEach(callRequests.prefix(5)) { option in
                    Button(action: {
                        // Play confirmation sound
                        SoundManager.shared.playConfirmationSound()
                        
                        let message = option.label(for: selectedLanguage) + " request sent!"
                        appState.showToast(message)
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: option.iconName)
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                            Text(option.label(for: selectedLanguage))
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color(red: 0.0, green: 0.6, blue: 0.6)) // Teal color matching image
                        .cornerRadius(16)
                    }
                    .accessibilityLabel(option.label(for: selectedLanguage))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Double tap to send request.")
                    .accessibilityIdentifier("button_\(option.id)")
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

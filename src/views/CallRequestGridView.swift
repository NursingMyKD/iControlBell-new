// CallRequestGridView.swift
// Grid of call request buttons

import SwiftUI

/// Displays a grid of call request buttons for the patient UI.
struct CallRequestGridView: View {
    var selectedLanguage: Language
    var callRequests: [CallRequestOption]
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("call_request_grid_title".localized)
                .font(.headline)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
                ForEach(callRequests) { option in
                    Button(action: {
                        let message = option.label(for: selectedLanguage) + " request sent!"
                        appState.showToast(message)
                    }) {
                        VStack {
                            Image(systemName: option.iconName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.bottom, 8)
                                .accessibilityIdentifier("icon_\(option.id)")
                            Text(option.label(for: selectedLanguage))
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("label_\(option.id)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 2)
                    }
                    .accessibilityLabel(option.label(for: selectedLanguage))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Double tap to send request.")
                    .accessibilityIdentifier("button_\(option.id)")
                }
            }
        }
        .padding(.vertical)
    }
}

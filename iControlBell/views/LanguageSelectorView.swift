// LanguageSelectorView.swift
// Language picker for iControlBell

import SwiftUI
import Foundation

/// Displays a language picker for selecting the app's language.
struct LanguageSelectorView: View {
    @Binding var selectedLanguage: Language
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }
    
    private var pickerFont: Font {
        if isIPad {
            return .title3
        } else if isCompact {
            return .body
        } else {
            return .body
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
    
    private var verticalPadding: CGFloat {
        if isIPad {
            return 12
        } else if isCompact {
            return 6
        } else {
            return 8
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Picker("Language", selection: $selectedLanguage) {
                ForEach(Language.allCases) { lang in
                    Text(lang.displayName)
                        .font(pickerFont)
                        .tag(lang)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .font(pickerFont)
            .foregroundColor(.primary)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(Color(.systemGray6))
            .cornerRadius(isIPad ? 12 : 8)
            .accessibilityLabel("Select Language")
            .accessibilityHint("Double tap to change language.")
            .accessibilityIdentifier("language_picker")
        }
    }
}

#Preview {
    LanguageSelectorView(selectedLanguage: .constant(.english))
}

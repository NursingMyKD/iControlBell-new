// LanguageSelectorView.swift
// Language picker for iControlBell

import SwiftUI
import Foundation

/// Displays a language picker for selecting the app's language.
struct LanguageSelectorView: View {
    @Binding var selectedLanguage: Language
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var pickerFont: Font {
        DeviceUtils.dynamicFont(
            compact: .body,
            regular: .body,
            iPad: .title3
        )
    }
    
    private var horizontalPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 12, regular: 16, iPad: 24)
    }
    
    private var verticalPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 6, regular: 8, iPad: 12)
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

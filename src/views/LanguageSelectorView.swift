// LanguageSelectorView.swift
// Language picker for iControlBell

import SwiftUI

/// Displays a language picker for selecting the app's language.
struct LanguageSelectorView: View {
    @Binding var selectedLanguage: Language
    
    var body: some View {
        VStack(spacing: 8) {
            Picker("Language", selection: $selectedLanguage) {
                ForEach(Language.allCases) { lang in
                    Text(lang.displayName).tag(lang)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .cornerRadius(8)
            .accessibilityLabel("Select Language")
            .accessibilityHint("Double tap to change language.")
        }
    }
}

#Preview {
    LanguageSelectorView(selectedLanguage: .constant(.english))
}

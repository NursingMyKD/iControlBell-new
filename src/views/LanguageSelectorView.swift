// LanguageSelectorView.swift
// Language picker for iControlBell

import SwiftUI

/// Displays a language picker for selecting the app's language.
struct LanguageSelectorView: View {
    @Binding var selectedLanguage: Language
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("language_selector_label".localized)
                .font(.headline)
            Picker("language_selector_label".localized, selection: $selectedLanguage) {
                ForEach(Language.allCases) { lang in
                    Text(lang.displayName).tag(lang)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accessibilityLabel("language_selector_label".localized)
            .accessibilityHint("Double tap to change language.")
        }
        .padding(.vertical)
    }
}

#Preview {
    LanguageSelectorView(selectedLanguage: .constant(.english))
}

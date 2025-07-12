// CallRequestOption.swift
// Model for call request options

import Foundation

/// Represents a single call request option (e.g., Help, Water) for the patient UI.
struct CallRequestOption: Identifiable, Decodable, Equatable, Hashable {
    /// Deterministic id for easier diffing/testing
    var id: String { type }
    /// The type identifier (e.g., "help", "water")
    let type: String
    /// The SF Symbol name for the icon
    let iconName: String
    /// Localized labels for each language (languageCode: label)
    let labels: [String: String]
    
    /// Returns the localized label for the given language, or a capitalized fallback.
    func label(for language: Language) -> String {
        labels[language.rawValue] ?? type.capitalized
    }
}

/// Observable object for managing and loading call request options.
@MainActor
class CallRequestData: ObservableObject {
    @Published private(set) var options: [CallRequestOption] = []
    @Published private(set) var language: Language

    init(language: Language) {
        self.language = language
        loadOptions(for: language)
    }

    /// Public method to update the language and reload options
    func updateLanguage(_ newLanguage: Language) {
        loadOptions(for: newLanguage)
    }

    /// Loads call request options for the given language from the Plist.
    func loadOptions(for language: Language) {
        self.language = language
        guard let loaded: [CallRequestOption] = PlistLoader.load("CallRequestOptions") else {
            print("[CallRequestData] Failed to load CallRequestOptions.plist for language: \(language.rawValue)")
            self.options = []
            return
        }
        self.options = loaded
    }
}

// SoundboardCategory.swift
// Model for soundboard categories and phrases

import Foundation

/// Represents a soundboard category (e.g., Greetings, Needs) and its phrases.
struct SoundboardCategory: Identifiable, Hashable, Decodable {
    let id: String
    let displayNames: [String: String] // languageCode: displayName
    let phrases: [String: [String]] // languageCode: [phrases]
    /// Returns the localized display name for the given language.
    func displayName(for language: Language) -> String {
        displayNames[language.rawValue] ?? id.capitalized
    }
}

/// Observable object for managing and loading soundboard categories.
@MainActor
class SoundboardData: ObservableObject {
    @Published private(set) var categories: [SoundboardCategory] = []
    private(set) var language: Language

    init(language: Language) {
        self.language = language
        loadCategories(for: language)
    }

    /// Loads soundboard categories for the given language from the Plist.
    func loadCategories(for language: Language) {
        self.language = language
        guard let loaded: [SoundboardCategory] = PlistLoader.load("SoundboardCategories") else {
            print("[SoundboardData] Failed to load SoundboardCategories.plist for language: \(language.rawValue)")
            self.categories = []
            return
        }
        self.categories = loaded
    }
}

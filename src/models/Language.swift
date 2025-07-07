// Language.swift
// Supported languages for iControlBell

/// Supported languages for the iControlBell app.
enum Language: String, CaseIterable, Identifiable {
    case english = "en" // English
    case spanish = "es" // Español
    case french = "fr" // Français
    case german = "de" // Deutsch
    case portuguese = "pt" // Português
    case italian = "it" // Italiano
    case japanese = "ja" // 日本語
    case dutch = "nl" // Nederlands
    case russian = "ru" // Русский
    case chinese = "zh" // 中文
    case hindi = "hi" // हिन्दी
    case arabic = "ar" // العربية
    case bengali = "bn" // বাংলা
    case korean = "ko" // 한국어
    case turkish = "tr" // Türkçe
    case polish = "pl" // Polski
    case swedish = "sv" // Svenska
    case vietnamese = "vi" // Tiếng Việt
    case indonesian = "id" // Bahasa Indonesia
    case urdu = "ur" // اردو
    case tagalog = "tl" // Tagalog
    case thai = "th" // ภาษาไทย
    case greek = "el" // Ελληνικά
    case czech = "cs" // Čeština
    case hungarian = "hu" // Magyar
    case romanian = "ro" // Română
    case danish = "da" // Dansk
    case finnish = "fi" // Suomi
    var id: String { rawValue }
    /// Returns the display name for the language, localized if possible.
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .portuguese: return "Português"
        case .italian: return "Italiano"
        case .japanese: return "日本語"
        case .dutch: return "Nederlands"
        case .russian: return "Русский"
        case .chinese: return "中文"
        case .hindi: return "हिन्दी"
        case .arabic: return "العربية"
        case .bengali: return "বাংলা"
        case .korean: return "한국어"
        case .turkish: return "Türkçe"
        case .polish: return "Polski"
        case .swedish: return "Svenska"
        case .vietnamese: return "Tiếng Việt"
        case .indonesian: return "Bahasa Indonesia"
        case .urdu: return "اردو"
        case .tagalog: return "Tagalog"
        case .thai: return "ภาษาไทย"
        case .greek: return "Ελληνικά"
        case .czech: return "Čeština"
        case .hungarian: return "Magyar"
        case .romanian: return "Română"
        case .danish: return "Dansk"
        case .finnish: return "Suomi"
        }
    }
}

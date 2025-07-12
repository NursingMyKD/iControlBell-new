// StringExtensions.swift
// Localization utilities for iControlBell

import Foundation

extension String {
    /// Returns the localized version of the string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns the localized version with arguments
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
    
    /// Returns localized string with a specific table name
    func localized(tableName: String) -> String {
        return NSLocalizedString(self, tableName: tableName, comment: "")
    }
    
    /// Returns localized string with fallback
    func localized(fallback: String) -> String {
        let localized = NSLocalizedString(self, comment: "")
        return localized == self ? fallback : localized
    }
}

/// Localization helper for healthcare-specific terms
struct HealthcareLocalizations {
    static let emergencyCall = "emergency_call".localized
    static let medicalAssistance = "medical_assistance".localized
    static let nurseCall = "nurse_call".localized
    static let patientCare = "patient_care".localized
}

/// Localization helper for UI elements
struct UILocalizations {
    static let ok = "ok".localized
    static let cancel = "cancel".localized
    static let retry = "retry".localized
    static let done = "done".localized
    static let save = "save".localized
    static let close = "close".localized
    static let back = "back".localized
    static let settings = "settings".localized
    static let help = "help".localized
}

/// Localization helper for accessibility
struct AccessibilityLocalizations {
    static let languagePicker = "language_picker_accessibility".localized
    static let callRequestButton = "call_request_button_accessibility".localized
    static let soundboardPhrase = "soundboard_phrase_accessibility".localized
    static let currentlySpeaking = "currently_speaking_accessibility".localized
    static let tapToSpeak = "tap_to_speak_accessibility".localized
}

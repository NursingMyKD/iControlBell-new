// ErrorHandler.swift
// Global error handler for iControlBell

import Foundation

/// Centralized error handler for user-facing and developer errors
class ErrorHandler {
    static let shared = ErrorHandler()
    private init() {}
    
    /// Handle an error and return a localized, user-friendly message
    func handle(_ error: Error, context: String? = nil) -> String {
        // If error is already localized, use it
        if let localizedError = error as? LocalizedError, let desc = localizedError.errorDescription {
            return desc.localized
        }
        // If error is a custom RaulandHealthcareError
        if let raulandError = error as? RaulandHealthcareError {
            return raulandError.localizedDescription.localized
        }
        // Fallback: use error's description
        let base = error.localizedDescription.localized
        if let context = context {
            return "\(context): \(base)"
        }
        return base
    }
}

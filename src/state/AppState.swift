// AppState.swift
// Global app state for iControlBell

import SwiftUI

/// Global app state for language selection and toast notifications.
@MainActor
class AppState: ObservableObject {
    @Published var selectedLanguage: Language = .english
    @Published var toastMessage: String? = nil
    @Published var toastIsError: Bool = false
    /// Shows a toast message for 2 seconds.
    func showToast(_ message: String, isError: Bool = false) {
        toastMessage = message
        toastIsError = isError
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.toastMessage = nil
        }
    }
    /// Shows a Bluetooth error as a toast.
    func showBluetoothError(_ error: String) {
        showToast(error, isError: true)
    }
}

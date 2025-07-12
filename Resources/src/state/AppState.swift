// AppState.swift
// Global app state for iControlBell with Rauland Responder 5 connectivity

import SwiftUI

/// Global app state for language selection, connectivity, and toast notifications.
@MainActor
class AppState: ObservableObject {
    @Published var selectedLanguage: Language = .english
    @Published var toastMessage: String? = nil
    @Published var toastIsError: Bool = false
    
    // Rauland Connectivity State
    @Published var raulandManager = RaulandAPIManager.shared
    @Published var isRaulandConfigured: Bool = false
    @Published var facilityName: String = ""
    
    /// Shows a toast message for 2 seconds.
    func showToast(_ message: String, isError: Bool = false) {
        toastMessage = message
        toastIsError = isError
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.toastMessage = nil
        }
    }
    
    /// Configure Rauland connection with facility details
    func configureRauland(baseURL: String, apiKey: String, deviceID: String, facilityID: String, roomNumber: String? = nil) {
        let config = RaulandConfiguration(
            baseURL: baseURL,
            apiKey: apiKey,
            deviceID: deviceID,
            roomNumber: roomNumber,
            facilityID: facilityID,
            timeout: 30.0
        )
        
        raulandManager.configure(with: config)
        isRaulandConfigured = !apiKey.isEmpty && !facilityID.isEmpty
        
        if isRaulandConfigured {
            facilityName = facilityID // Will be updated with actual facility name on connection
            showToast("rauland_configured".localized)
        }
    }
    
    /// Send a call request through Rauland API
    func sendRaulandCallRequest(_ callType: RaulandCallType, message: String? = nil) async {
        guard raulandManager.isConnected else {
            showToast("rauland_not_connected".localized, isError: true)
            return
        }
        
        let result = await raulandManager.sendCallRequest(callType, message: message)
        
        switch result {
        case .success:
            let successMessage = "\(callType.displayName) \("call_request_sent".localized)"
            showToast(successMessage)
        case .failure(let error):
            showToast(error.localizedDescription, isError: true)
        }
    }
    
    /// Get connection status information
    func getConnectionStatus() -> String {
        if raulandManager.isConnected {
            if let facilityInfo = raulandManager.facilityInfo {
                return "\("rauland_connected_to".localized) \(facilityInfo.name)"
            } else {
                return "rauland_status_connected".localized
            }
        } else if isRaulandConfigured {
            return raulandManager.connectionState.displayName
        } else {
            return "rauland_not_configured".localized
        }
    }
}

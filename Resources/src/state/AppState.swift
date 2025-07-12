// ...existing code...
// AppState.swift
// Global app state for iControlBell with Rauland Responder 5 connectivity
//
//  AppState.swift
//  iControlBell
//
//  Created by shane stone on 7/6/25.
//

import Foundation

// AppState.swift
// Global app state for iControlBell with Rauland Responder 5 connectivity
//
//  AppState.swift
//  iControlBell
//
//  Created by shane stone on 7/6/25.
//

import Foundation
import Combine
import SwiftUI
import os.log



class AppState: ObservableObject {
    // Persistent confirmation banner state
    @Published var showConfirmationBanner: Bool = false
    @Published var confirmationBannerText: String = ""
    @Published var confirmationBannerSeconds: Int = 0
    private var confirmationBannerTimer: Timer?
    // Offline call request queue
    private var callRequestQueue: [RaulandCallRequest] {
        get { CallRequestQueueManager.shared.loadQueue() }
        set { CallRequestQueueManager.shared.saveQueue(newValue) }
    }
    // Onboarding state
    @Published var showOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(!showOnboarding, forKey: "onboardingComplete")
        }
    }
    @Published var selectedLanguage: Language = .english
    @Published var toastMessage: String? = nil
    @Published var toastIsError: Bool = false
    /// Show a toast notification with a message and error/success state
    func showToast(_ message: String, isError: Bool = false) {
        toastMessage = message
        toastIsError = isError
        // Optionally, clear after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            if self?.toastMessage == message {
                self?.toastMessage = nil
            }
        }
    }
    // Rauland Connectivity State
    @Published var raulandManager: RaulandAPIManager
    @Published var isRaulandConfigured: Bool = false
    @Published var facilityName: String = ""
    /// Allow dependency injection of RaulandAPIManager
    init(raulandManager: RaulandAPIManager = RaulandAPIManager.shared) {
        let onboardingComplete = UserDefaults.standard.bool(forKey: "onboardingComplete")
        self.showOnboarding = !onboardingComplete
        self.raulandManager = raulandManager
    }

    /// Configure Rauland connection with facility details
    @MainActor
    func configureRauland(baseURL: String, apiKey: String, deviceID: String, facilityID: String, roomNumber: String? = nil) async {
        let config = RaulandConfiguration(
            baseURL: baseURL,
            apiKey: apiKey,
            deviceID: deviceID,
            roomNumber: roomNumber,
            facilityID: facilityID,
            timeout: 30.0
        )
        await raulandManager.configure(with: config)
        isRaulandConfigured = !apiKey.isEmpty && !facilityID.isEmpty
        if isRaulandConfigured {
            facilityName = facilityID // Will be updated with actual facility name on connection
            showToast("rauland_configured".localized)
        }
    }

    /// Send a call request through Rauland API
    func sendRaulandCallRequest(_ callType: RaulandCallType, message: String? = nil) async {
        let config = await (raulandManager as? RaulandAPIManager)?.configuration ?? RaulandConfiguration.default
        let request = RaulandCallRequest(
            config: config,
            callType: callType,
            message: message
        )
        if await raulandManager.isConnected {
            let result = await raulandManager.sendCallRequest(callType, message: message)
            switch result {
            case .success:
                showConfirmationBannerWithTimer(text: "help_on_the_way_confirmation".localized, seconds: 10)
            case .failure(let error):
                let errorMsg = ErrorHandler.shared.handle(error)
                showToast(errorMsg, isError: true)
                // Optionally, queue if failure is due to network
            }
        } else {
            // Queue the request for later
            CallRequestQueueManager.shared.append(request)
            showToast("call_request_queued".localized, isError: false)
        }
    }

    /// Show a persistent confirmation banner with a countdown timer
    func showConfirmationBannerWithTimer(text: String, seconds: Int) {
        confirmationBannerText = text
        confirmationBannerSeconds = seconds
        showConfirmationBanner = true
        confirmationBannerTimer?.invalidate()
        confirmationBannerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.confirmationBannerSeconds > 1 {
                self.confirmationBannerSeconds -= 1
            } else {
                self.showConfirmationBanner = false
                timer.invalidate()
            }
        }
    }

    /// Call this when connection is restored
    @MainActor
    func sendQueuedCallRequests() async {
        guard await raulandManager.isConnected else { return }
        var queue = CallRequestQueueManager.shared.loadQueue()
        guard !queue.isEmpty else { return }
        var sentCount = 0
        var failedCount = 0
        for req in queue {
            if let callType = RaulandCallType(rawValue: req.callType) {
                let result = await raulandManager.sendCallRequest(callType, message: req.message)
                switch result {
                case .success:
                    sentCount += 1
                case .failure:
                    failedCount += 1
                }
            } else {
                failedCount += 1
            }
        }
        CallRequestQueueManager.shared.clear()
        if sentCount > 0 {
            showToast("\(sentCount) \("call_requests_sent_after_reconnect".localized)")
        }
        if failedCount > 0 {
            showToast("\(failedCount) \("call_requests_failed_after_reconnect".localized)", isError: true)
        }
    }

    /// Get connection status information
    @MainActor
    func getConnectionStatus() async -> String {
        if await raulandManager.isConnected {
            if let facilityInfo = await raulandManager.facilityInfo {
                return "\("rauland_connected_to".localized) \(facilityInfo.name)"
            } else {
                return "rauland_status_connected".localized
            }
        } else if isRaulandConfigured {
            return await raulandManager.connectionState.displayName
        } else {
            return "rauland_not_configured".localized
        }
    }
}

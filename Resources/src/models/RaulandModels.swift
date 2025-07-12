import UIKit
//
//  RaulandModels.swift
//  iControlBell - Rauland Responder 5 Integration Models
//
//  Created by GitHub Copilot on 12/25/24.
//

import Foundation

// MARK: - Rauland API Configuration

/// Configuration for Rauland Responder 5 API connection
struct RaulandConfiguration {
    let baseURL: String
    let apiKey: String
    let deviceID: String
    let roomNumber: String?
    let facilityID: String
    let timeout: TimeInterval
    
    static let `default` = RaulandConfiguration(
        baseURL: "https://placeholder.rauland.demo", // Placeholder URL
        apiKey: "demo-api-key", // Placeholder API key
        deviceID: UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString,
        roomNumber: nil, // Optional room assignment
        facilityID: "Demo-Healthcare-Facility", // Demo facility ID
        timeout: 30.0
    )
    
    static let placeholder = RaulandConfiguration(
        baseURL: "https://placeholder.rauland.demo",
        apiKey: "demo-api-key",
        deviceID: UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString,
        roomNumber: "Room-Demo",
        facilityID: "Demo-Healthcare-Facility",
        timeout: 30.0
    )
}

// MARK: - Connection State

/// Rauland connection states for healthcare monitoring
enum RaulandConnectionState: String, CaseIterable {
    case disconnected = "Disconnected"
    case connecting = "Connecting"
    case authenticating = "Authenticating"
    case connected = "Connected"
    case error = "Error"
    case suspended = "Suspended"
    
    var isOperational: Bool {
        self == .connected
    }
    
    var allowsConnection: Bool {
        self == .disconnected || self == .error
    }
    
    var displayName: String {
        switch self {
        case .disconnected:
            return "rauland_status_disconnected".localized
        case .connecting:
            return "rauland_status_connecting".localized
        case .authenticating:
            return "rauland_status_authenticating".localized
        case .connected:
            return "rauland_status_connected".localized
        case .error:
            return "rauland_status_error".localized
        case .suspended:
            return "rauland_status_suspended".localized
        }
    }
}

// MARK: - Call Request Types

/// Rauland Responder 5 call request types
enum RaulandCallType: String, CaseIterable {
    case emergency = "emergency"
    case nurse = "nurse"
    case general = "general"
    case maintenance = "maintenance"
    case housekeeping = "housekeeping"
    
    var priority: RaulandCallPriority {
        switch self {
        case .emergency:
            return .critical
        case .nurse:
            return .urgent
        case .general:
            return .normal
        case .maintenance, .housekeeping:
            return .low
        }
    }
    
    var displayName: String {
        switch self {
        case .emergency:
            return "rauland_call_emergency".localized
        case .nurse:
            return "rauland_call_nurse".localized
        case .general:
            return "rauland_call_general".localized
        case .maintenance:
            return "rauland_call_maintenance".localized
        case .housekeeping:
            return "rauland_call_housekeeping".localized
        }
    }
}

/// Call request priority levels
enum RaulandCallPriority: Int, CaseIterable {
    case low = 1
    case normal = 2
    case urgent = 3
    case critical = 4
    
    var displayName: String {
        switch self {
        case .low:
            return "priority_low".localized
        case .normal:
            return "priority_normal".localized
        case .urgent:
            return "priority_urgent".localized
        case .critical:
            return "priority_critical".localized
        }
    }
}

// MARK: - API Request/Response Models

/// Call request payload for Rauland API
struct RaulandCallRequest: Codable {
    let deviceID: String
    let facilityID: String
    let roomNumber: String?
    let callType: String
    let priority: Int
    let message: String?
    let timestamp: Date
    let patientID: String?
    let staffID: String?
    
    init(config: RaulandConfiguration, callType: RaulandCallType, message: String? = nil) {
        self.deviceID = config.deviceID
        self.facilityID = config.facilityID
        self.roomNumber = config.roomNumber
        self.callType = callType.rawValue
        self.priority = callType.priority.rawValue
        self.message = message
        self.timestamp = Date()
        self.patientID = nil // To be set if patient context available
        self.staffID = nil // To be set if staff context available
    }
}

/// Authentication request for Rauland API
struct RaulandAuthRequest: Codable {
    let apiKey: String
    let deviceID: String
    let facilityID: String
    let deviceType: String = "iControlBell"
    let version: String = "1.0"
}

/// Authentication response from Rauland API
struct RaulandAuthResponse: Codable {
    let success: Bool
    let sessionToken: String?
    let expiresAt: Date?
    let permissions: [String]
    let facilityInfo: RaulandFacilityInfo?
    let message: String?
}

/// Facility information from Rauland system
struct RaulandFacilityInfo: Codable {
    let name: String
    let timezone: String
    let features: [String]
    let maxSessionDuration: TimeInterval
}

/// API response wrapper
struct RaulandAPIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: RaulandAPIError?
    let timestamp: Date
    let requestID: String
}

/// API error structure
struct RaulandAPIError: Codable, LocalizedError {
    let code: String
    let message: String
    let details: [String: String]?
    
    var errorDescription: String? {
        return message
    }
}

// MARK: - Healthcare Error Types

/// Rauland-specific healthcare errors
enum RaulandHealthcareError: LocalizedError, CaseIterable {
    case networkUnavailable
    case authenticationFailed
    case sessionExpired
    case apiKeyInvalid
    case facilityNotFound
    case deviceNotAuthorized
    case callRequestFailed
    case connectionTimeout
    case serverUnavailable
    case invalidConfiguration
    case rateLimitExceeded
    case emergencyCallFailed
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "rauland_error_network".localized
        case .authenticationFailed:
            return "rauland_error_auth_failed".localized
        case .sessionExpired:
            return "rauland_error_session_expired".localized
        case .apiKeyInvalid:
            return "rauland_error_invalid_api_key".localized
        case .facilityNotFound:
            return "rauland_error_facility_not_found".localized
        case .deviceNotAuthorized:
            return "rauland_error_device_unauthorized".localized
        case .callRequestFailed:
            return "rauland_error_call_failed".localized
        case .connectionTimeout:
            return "rauland_error_timeout".localized
        case .serverUnavailable:
            return "rauland_error_server_unavailable".localized
        case .invalidConfiguration:
            return "rauland_error_invalid_config".localized
        case .rateLimitExceeded:
            return "rauland_error_rate_limit".localized
        case .emergencyCallFailed:
            return "rauland_error_emergency_failed".localized
        }
    }
    
    var priority: RaulandCallPriority {
        switch self {
        case .emergencyCallFailed:
            return .critical
        case .authenticationFailed, .sessionExpired, .callRequestFailed:
            return .urgent
        case .networkUnavailable, .connectionTimeout, .serverUnavailable:
            return .normal
        default:
            return .low
        }
    }
    
    var shouldRetry: Bool {
        switch self {
        case .networkUnavailable, .connectionTimeout, .serverUnavailable, .rateLimitExceeded:
            return true
        case .authenticationFailed, .sessionExpired:
            return true
        default:
            return false
        }
    }
}

// MARK: - Result Types

/// Result type for Rauland API operations
typealias RaulandResult<T> = Result<T, RaulandHealthcareError>


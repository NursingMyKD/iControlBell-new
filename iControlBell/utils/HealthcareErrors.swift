//
//  HealthcareErrors.swift
//  iControlBell - Enhanced Error Handling for Healthcare Environments
//
//  Created by GitHub Copilot on 7/8/25.
//

import Foundation

// MARK: - Healthcare-Specific Error Types

/// Comprehensive error types for healthcare communication scenarios
enum HealthcareError: LocalizedError, CaseIterable {
    case bluetoothUnavailable
    case bluetoothPermissionDenied
    case deviceConnectionTimeout
    case callBellDeviceNotFound
    case callBellServiceUnavailable
    case callBellCharacteristicNotFound
    case emergencyCallFailed
    case audioSystemUnavailable
    case soundFileCorrupted
    case languageDataCorrupted
    case networkRequiredButUnavailable
    case securityValidationFailed
    case sessionExpired
    case insufficientPermissions
    
    var errorDescription: String? {
        switch self {
        case .bluetoothUnavailable:
            return "Bluetooth is not available. Please enable Bluetooth in device settings and try again."
        case .bluetoothPermissionDenied:
            return "Bluetooth permission is required for hospital call bell integration. Please allow Bluetooth access in Settings > Privacy & Security > Bluetooth."
        case .deviceConnectionTimeout:
            return "Connection to call bell device timed out. Please ensure the device is powered on and within range, then try again."
        case .callBellDeviceNotFound:
            return "Hospital call bell device not found. Please contact your IT administrator to verify device setup."
        case .callBellServiceUnavailable:
            return "Call bell communication service is not available. Please check device compatibility or contact technical support."
        case .callBellCharacteristicNotFound:
            return "Call bell communication interface unavailable. Please restart the call bell device and try again."
        case .emergencyCallFailed:
            return "Emergency call transmission failed. Please use backup communication methods and retry. If this persists, contact technical support immediately."
        case .audioSystemUnavailable:
            return "Audio feedback system unavailable. App functionality continues, but confirmation sounds may not play."
        case .soundFileCorrupted:
            return "Audio feedback file is corrupted. App will use system sounds as fallback."
        case .languageDataCorrupted:
            return "Language data is corrupted. App will use English as fallback. Please reinstall the app if this persists."
        case .networkRequiredButUnavailable:
            return "Network connection required for this feature, but none is available. This app is designed to work offline."
        case .securityValidationFailed:
            return "Security validation failed. Please restart the app. If this persists, contact your IT administrator."
        case .sessionExpired:
            return "Your session has expired for security reasons. Please authenticate again to continue."
        case .insufficientPermissions:
            return "Insufficient permissions for this operation. Please contact your administrator for proper access rights."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .bluetoothUnavailable:
            return "Bluetooth hardware is not available or is turned off"
        case .bluetoothPermissionDenied:
            return "App does not have permission to use Bluetooth"
        case .deviceConnectionTimeout:
            return "Unable to establish connection within timeout period"
        case .callBellDeviceNotFound:
            return "Hospital call bell device is not broadcasting or is out of range"
        case .callBellServiceUnavailable:
            return "Device does not support the required communication protocol"
        case .callBellCharacteristicNotFound:
            return "Communication interface is not available on the connected device"
        case .emergencyCallFailed:
            return "Failed to transmit emergency call signal to hospital system"
        case .audioSystemUnavailable:
            return "iOS audio system is not available or has encountered an error"
        case .soundFileCorrupted:
            return "Audio file is damaged or in an unsupported format"
        case .languageDataCorrupted:
            return "Language configuration files are damaged or missing"
        case .networkRequiredButUnavailable:
            return "Operation requires network access but device is offline"
        case .securityValidationFailed:
            return "Security checks failed, potentially due to device compromise"
        case .sessionExpired:
            return "User session has exceeded maximum allowed time"
        case .insufficientPermissions:
            return "User account does not have required access permissions"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .bluetoothUnavailable:
            return "Enable Bluetooth in Settings > Bluetooth, then restart the app."
        case .bluetoothPermissionDenied:
            return "Go to Settings > Privacy & Security > Bluetooth and enable access for iControlBell."
        case .deviceConnectionTimeout:
            return "Move closer to the call bell device, ensure it's powered on, and try connecting again."
        case .callBellDeviceNotFound:
            return "Verify the call bell device is powered on and contact your IT administrator for device pairing instructions."
        case .callBellServiceUnavailable:
            return "Check device compatibility with your IT administrator or try a different call bell device."
        case .callBellCharacteristicNotFound:
            return "Restart both the app and the call bell device, then try connecting again."
        case .emergencyCallFailed:
            return "Use backup communication methods immediately. Try the emergency call again, and contact technical support if the issue persists."
        case .audioSystemUnavailable:
            return "Restart the app. If the issue persists, restart your device."
        case .soundFileCorrupted:
            return "App will function normally with system sounds. Consider reinstalling the app for full audio experience."
        case .languageDataCorrupted:
            return "Reinstall the app to restore language support, or continue using English."
        case .networkRequiredButUnavailable:
            return "This app is designed to work offline. No action needed unless you need specific online features."
        case .securityValidationFailed:
            return "Restart the app. If this continues, contact your IT administrator for security clearance."
        case .sessionExpired:
            return "Re-authenticate using your credentials or biometric authentication to continue."
        case .insufficientPermissions:
            return "Contact your healthcare facility's IT administrator to request proper access permissions."
        }
    }
    
    /// Priority level for healthcare environment error handling
    var priority: ErrorPriority {
        switch self {
        case .emergencyCallFailed:
            return .critical
        case .bluetoothUnavailable, .deviceConnectionTimeout, .callBellDeviceNotFound:
            return .high
        case .bluetoothPermissionDenied, .callBellServiceUnavailable, .securityValidationFailed:
            return .medium
        case .audioSystemUnavailable, .soundFileCorrupted, .languageDataCorrupted:
            return .low
        case .networkRequiredButUnavailable, .sessionExpired, .insufficientPermissions:
            return .informational
        case .callBellCharacteristicNotFound:
            return .medium
        }
    }
    
    /// Whether this error should be logged for healthcare compliance auditing
    var shouldAudit: Bool {
        switch self {
        case .emergencyCallFailed, .securityValidationFailed, .sessionExpired, .insufficientPermissions:
            return true
        default:
            return false
        }
    }
}

/// Error priority levels for healthcare environments
enum ErrorPriority: Int, Comparable {
    case informational = 0
    case low = 1
    case medium = 2
    case high = 3
    case critical = 4
    
    static func < (lhs: ErrorPriority, rhs: ErrorPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var displayName: String {
        switch self {
        case .informational: return "Info"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .critical: return "Critical"
        }
    }
    
    var requiresImmediateAttention: Bool {
        self >= .high
    }
}

// MARK: - Error Context for Healthcare Environments

/// Provides additional context for errors in healthcare settings
struct HealthcareErrorContext {
    let timestamp: Date
    let userAction: String
    let deviceState: String
    let sessionId: String?
    let additionalInfo: [String: Any]
    
    init(userAction: String, deviceState: String, sessionId: String? = nil, additionalInfo: [String: Any] = [:]) {
        self.timestamp = Date()
        self.userAction = userAction
        self.deviceState = deviceState
        self.sessionId = sessionId
        self.additionalInfo = additionalInfo
    }
}

// MARK: - Result Type for Healthcare Operations

/// Result type that includes healthcare-specific error context
typealias HealthcareResult<T> = Result<T, HealthcareError>

/// Enhanced result type with context for audit trails
struct ContextualResult<T> {
    let result: HealthcareResult<T>
    let context: HealthcareErrorContext
    
    var isSuccess: Bool {
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
    
    var error: HealthcareError? {
        switch result {
        case .success: return nil
        case .failure(let error): return error
        }
    }
    
    var value: T? {
        switch result {
        case .success(let value): return value
        case .failure: return nil
        }
    }
}

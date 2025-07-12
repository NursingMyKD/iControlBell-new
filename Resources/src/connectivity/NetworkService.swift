// NetworkService.swift
// Abstraction for Rauland API networking

import Foundation

protocol NetworkService {
    func post<T: Codable, U: Codable>(url: String, body: T?, headers: [String: String]?) async throws -> U
}

// Placeholder/mock implementation for development
class MockNetworkService: NetworkService {
    func post<T: Codable, U: Codable>(url: String, body: T?, headers: [String: String]?) async throws -> U {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        // Return a dummy value for U if possible
        if U.self == RaulandAuthResponse.self {
            let mockFacilityInfo = RaulandFacilityInfo(
                name: "Demo Facility",
                timezone: TimeZone.current.identifier,
                features: ["Emergency Calls", "Nurse Station"],
                maxSessionDuration: 3600
            )
            let mockAuth = RaulandAuthResponse(
                success: true,
                sessionToken: "mock_token",
                expiresAt: Date().addingTimeInterval(3600),
                permissions: ["call.emergency", "call.nurse"],
                facilityInfo: mockFacilityInfo,
                message: nil
            )
            return mockAuth as! U
        }
        if U.self == RaulandAPIResponse<[String: String]>.self {
            let resp = RaulandAPIResponse<[String: String]>(
                success: true,
                data: ["result": "ok"],
                error: nil,
                timestamp: Date(),
                requestID: UUID().uuidString
            )
            return resp as! U
        }
        throw NSError(domain: "MockNetworkService", code: 0)
    }
}

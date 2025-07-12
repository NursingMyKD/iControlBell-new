// AuditLogManager.swift
// File-based audit log for Rauland call requests

import Foundation

class AuditLogManager {
    static let shared = AuditLogManager()
    private let fileName = "audit_log.json"
    private var logURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName)
    }

    func saveLog(_ log: [RaulandCallRequest]) {
        do {
            let data = try JSONEncoder().encode(log)
            try data.write(to: logURL, options: .atomic)
        } catch {
            print("[AuditLogManager] Failed to save audit log: \(error)")
        }
    }

    func loadLog() -> [RaulandCallRequest] {
        do {
            let data = try Data(contentsOf: logURL)
            return try JSONDecoder().decode([RaulandCallRequest].self, from: data)
        } catch {
            return []
        }
    }

    func append(_ entry: RaulandCallRequest) {
        var log = loadLog()
        log.append(entry)
        saveLog(log)
    }
}

// CallRequestQueueManager.swift
// Persistent queue for offline call requests

import Foundation

class CallRequestQueueManager {
    static let shared = CallRequestQueueManager()
    private let fileName = "pending_call_requests.json"
    private var queueURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName)
    }

    func saveQueue(_ queue: [RaulandCallRequest]) {
        do {
            let data = try JSONEncoder().encode(queue)
            try data.write(to: queueURL, options: .atomic)
        } catch {
            print("[CallRequestQueueManager] Failed to save queue: \(error)")
        }
    }

    func loadQueue() -> [RaulandCallRequest] {
        do {
            let data = try Data(contentsOf: queueURL)
            return try JSONDecoder().decode([RaulandCallRequest].self, from: data)
        } catch {
            return []
        }
    }

    func append(_ entry: RaulandCallRequest) {
        var queue = loadQueue()
        queue.append(entry)
        saveQueue(queue)
    }

    func clear() {
        saveQueue([])
    }
}

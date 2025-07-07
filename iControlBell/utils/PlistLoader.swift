import Foundation

/// Loads and decodes Plist files from the app bundle.
struct PlistLoader {
    /// Loads and decodes a plist file into the specified Decodable type.
    /// - Parameter filename: The name of the plist file (without extension).
    /// - Returns: The decoded object, or nil if loading or decoding fails.
    static func load<T: Decodable>(_ filename: String) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            print("[PlistLoader] Could not find or load plist: \(filename)")
            return nil
        }
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("[PlistLoader] Decoding error for \(filename): \(error)")
            return nil
        }
    }
}

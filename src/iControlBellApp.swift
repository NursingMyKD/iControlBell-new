// iControlBellApp.swift
// Main entry point for the iOS app using SwiftUI

import SwiftUI
import SharedCode // Import your shared code module here

@main
struct iControlBellApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// Removed duplicate definitions for AppState, Language, SoundboardCategory, CallRequestOption, and related extensions/static data.
// All types are now imported from modularized model/state files.
// If any static data or extensions are needed, move them to the appropriate model or utility file.

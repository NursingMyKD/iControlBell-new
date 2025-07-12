// OnboardingOverlayView.swift
// Ensure this file is included in the main app target
// Simple onboarding/help overlay for first-time users

import SwiftUI

struct OnboardingOverlayView: View {
    var dismiss: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "bell.badge.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.accentColor)
                Text("Welcome to iControlBell!")
                    .font(.title)
                    .bold()
                Text("This app lets you send nurse call requests, play soundboard messages, and connect to Rauland Responder 5. Tap the bell to get started!")
                    .multilineTextAlignment(.center)
                    .padding()
                Button(action: dismiss) {
                    Text("Got it!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(32)
        }
    }
}

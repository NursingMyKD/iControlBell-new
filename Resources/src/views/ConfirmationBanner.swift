// ConfirmationBanner.swift
// Persistent confirmation banner for call request feedback

import SwiftUI

struct ConfirmationBanner: View {
    let text: String
    let seconds: Int
    var body: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.green)
                .font(.system(size: 22, weight: .bold))
            Text(text)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            if seconds > 0 {
                Text("\(seconds)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(14)
        .shadow(radius: 6)
        .padding(.horizontal, 16)
        .transition(.move(edge: .top).combined(with: .opacity))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
    }
}

// Simple BlurView for background
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

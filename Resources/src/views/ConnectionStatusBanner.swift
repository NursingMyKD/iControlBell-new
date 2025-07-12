// ConnectionStatusBanner.swift
// Ensure this file is included in the main app target
// Prominent Rauland connection status indicator
import SwiftUI

/// Symbol-based banner for Rauland connection status
struct ConnectionStatusBanner: View {
    let status: String
    let isConnected: Bool
    let isConnecting: Bool

    var symbol: some View {
        Group {
            if isConnected {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            } else if isConnecting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.yellow)
            } else {
                Image(systemName: "xmark.octagon.fill")
                    .foregroundColor(.red)
            }
        }
        .frame(width: 28, height: 28)
        .accessibilityHidden(true)
    }

    var bannerColor: Color {
        if isConnected {
            return Color.green.opacity(0.12)
        } else if isConnecting {
            return Color.yellow.opacity(0.12)
        } else {
            return Color.red.opacity(0.12)
        }
    }

    var borderColor: Color {
        if isConnected {
            return Color.green
        } else if isConnecting {
            return Color.yellow
        } else {
            return Color.red
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            symbol
            Text(status)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(bannerColor)
        )
        .overlay(
            Capsule()
                .stroke(borderColor, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(status)
    }
}

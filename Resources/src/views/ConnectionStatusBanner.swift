// ConnectionStatusBanner.swift
// Prominent Rauland connection status indicator

import SwiftUI

struct ConnectionStatusBanner: View {
    let status: String
    let isConnected: Bool
    let isConnecting: Bool
    @State private var animate = false
    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: isConnected ? "checkmark.circle.fill" : (isConnecting ? "arrow.triangle.2.circlepath.circle.fill" : "xmark.octagon.fill"))
                .foregroundColor(isConnected ? .green : (isConnecting ? .yellow : .red))
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .scaleEffect(animate ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isConnected)
            Text(status)
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundColor(isConnected ? .green : (isConnecting ? .yellow : .red))
                .accessibilityLabel(status)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .shadow(color: Color.black.opacity(0.13), radius: 1, x: 0, y: 1)
            Spacer()
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: isConnected ? [Color.green.opacity(0.25), Color.green.opacity(0.10)] : (isConnecting ? [Color.yellow.opacity(0.25), Color.yellow.opacity(0.10)] : [Color.red.opacity(0.25), Color.red.opacity(0.10)])),
                startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isConnected ? Color.green : (isConnecting ? Color.yellow : Color.red), lineWidth: 2.5)
        )
        .cornerRadius(18)
        .shadow(color: (isConnected ? Color.green : (isConnecting ? Color.yellow : Color.red)).opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
        .padding(.top, 10)
        .accessibilityElement(children: .combine)
        .onChange(of: isConnected) { _ in animate = true; DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { animate = false } }
    }
}

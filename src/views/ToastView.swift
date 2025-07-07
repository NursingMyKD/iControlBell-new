// ToastView.swift
// Toast/notification UI

import SwiftUI

/// Displays a toast notification with a message and error/success color.
struct ToastView: View {
    let message: String
    let isError: Bool
    var body: some View {
        Text(message)
            .padding()
            .background(isError ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 4)
            .padding(.top, 40)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut, value: message)
    }
}

// LogoView.swift
// Displays the app logo

import SwiftUI

/// Displays the app logo image.
struct LogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 180, height: 180)
            .padding(.top, 16)
    }
}

#Preview {
    LogoView()
}

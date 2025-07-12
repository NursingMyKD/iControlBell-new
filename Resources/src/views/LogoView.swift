// LogoView.swift
// Displays the app logo

import SwiftUI

/// Displays the app logo image.
struct LogoView: View {
    private var logoSize: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 120, regular: 180, iPad: 240)
    }
    
    private var topPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 8, regular: 16, iPad: 24)
    }
    
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: logoSize, height: logoSize)
            .padding(.top, topPadding)
            .accessibilityLabel("iControlBell Logo")
            .accessibilityHidden(true) // Logo is decorative
    }
}

#Preview {
    LogoView()
}

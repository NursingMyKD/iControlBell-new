// ToastView.swift
// Toast/notification UI

import SwiftUI
import Foundation

/// Displays a toast notification with a message and error/success color.
struct ToastView: View {
    let message: String
    let isError: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var toastFont: Font {
        DeviceUtils.dynamicFont(
            compact: .caption,
            regular: .body,
            iPad: .title3
        )
    }
    
    private var horizontalPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 12, regular: 16, iPad: 24)
    }
    
    private var verticalPadding: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 8, regular: 12, iPad: 16)
    }
    
    private var cornerRadius: CGFloat {
        if isIPad {
            return 12
        } else if isCompact {
            return 6
        } else {
            return 8
        }
    }
    
    private var shadowRadius: CGFloat {
        if isIPad {
            return 8
        } else if isCompact {
            return 2
        } else {
            return 4
        }
    }
    
    private var topPadding: CGFloat {
        if isIPad {
            return 60
        } else if isCompact {
            return 20
        } else {
            return 40
        }
    }
    
    var body: some View {
        Text(message)
            .font(toastFont)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isError ? Color.red : Color.green)
                    .shadow(color: .black.opacity(0.3), radius: shadowRadius, x: 0, y: 2)
            )
            .foregroundColor(.white)
            .padding(.top, topPadding)
            .padding(.horizontal, 20)
            .transition(.asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .opacity
            ))
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: message)
            .accessibilityLabel(message)
            .accessibilityAddTraits(isError ? .isStaticText : .playsSound)
    }
}

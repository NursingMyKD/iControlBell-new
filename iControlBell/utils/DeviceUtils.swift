// DeviceUtils.swift
// Device detection and responsive design utilities

import SwiftUI
import UIKit

/// Utility struct for device-specific properties and responsive design
struct DeviceUtils {
    
    /// Current device type
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// Screen size categories
    static var screenSize: ScreenSize {
        let bounds = UIScreen.main.bounds
        let area = bounds.width * bounds.height
        
        if isIPad {
            return area > 1_000_000 ? .iPadLarge : .iPadRegular
        } else {
            return area > 200_000 ? .iPhoneLarge : (area > 150_000 ? .iPhoneRegular : .iPhoneSmall)
        }
    }
    
    /// Dynamic spacing based on device
    static func dynamicSpacing(compact: CGFloat, regular: CGFloat, iPad: CGFloat) -> CGFloat {
        switch screenSize {
        case .iPhoneSmall:
            return compact * 0.8
        case .iPhoneRegular:
            return regular
        case .iPhoneLarge:
            return regular * 1.2
        case .iPadRegular, .iPadLarge:
            return iPad
        }
    }
    
    /// Dynamic font size
    static func dynamicFont(compact: Font, regular: Font, iPad: Font) -> Font {
        switch screenSize {
        case .iPhoneSmall:
            return compact
        case .iPhoneRegular, .iPhoneLarge:
            return regular
        case .iPadRegular, .iPadLarge:
            return iPad
        }
    }
    
    /// Safe area insets
    static var safeAreaInsets: UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    /// Check if device is in landscape orientation
    static var isLandscape: Bool {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.interfaceOrientation.isLandscape
        }
        return false
    }
}

/// Screen size categories for responsive design
enum ScreenSize {
    case iPhoneSmall  // iPhone SE, iPhone 12 mini
    case iPhoneRegular // iPhone 12, iPhone 13
    case iPhoneLarge   // iPhone 12 Pro Max, iPhone 13 Pro Max
    case iPadRegular   // iPad, iPad Air
    case iPadLarge     // iPad Pro 12.9"
}

/// View modifier for responsive design
struct ResponsiveModifier: ViewModifier {
    let compact: () -> AnyView
    let regular: () -> AnyView
    let iPad: () -> AnyView
    
    func body(content: Content) -> some View {
        Group {
            switch DeviceUtils.screenSize {
            case .iPhoneSmall:
                compact()
            case .iPhoneRegular, .iPhoneLarge:
                regular()
            case .iPadRegular, .iPadLarge:
                iPad()
            }
        }
    }
}

/// Extension to make responsive design easier
extension View {
    func responsive<CompactContent: View, RegularContent: View, IPadContent: View>(
        compact: @escaping () -> CompactContent,
        regular: @escaping () -> RegularContent,
        iPad: @escaping () -> IPadContent
    ) -> some View {
        self.modifier(ResponsiveModifier(
            compact: { AnyView(compact()) },
            regular: { AnyView(regular()) },
            iPad: { AnyView(iPad()) }
        ))
    }
}

/// Color scheme utilities
extension Color {
    /// Dynamic colors that adapt to device and appearance
    static var adaptiveBackground: Color {
        if DeviceUtils.isIPad {
            return Color(.systemGroupedBackground)
        } else {
            return Color(.systemBackground)
        }
    }
    
    static var adaptiveSecondaryBackground: Color {
        Color(.secondarySystemBackground)
    }
    
    static var adaptiveTertiary: Color {
        Color(.tertiarySystemBackground)
    }
}

// AccessibilityUtils.swift
// Accessibility utilities and Dynamic Type support

import SwiftUI
import UIKit

/// Accessibility utilities for improved user experience
struct AccessibilityUtils {
    
    /// Check if VoiceOver is running
    static var isVoiceOverRunning: Bool {
        UIAccessibility.isVoiceOverRunning
    }
    
    /// Check if user prefers reduced motion
    static var prefersReducedMotion: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
    
    /// Check if user prefers increased contrast
    static var prefersIncreasedContrast: Bool {
        UIAccessibility.isDarkerSystemColorsEnabled
    }
    
    /// Get current Dynamic Type category
    static var currentContentSizeCategory: ContentSizeCategory {
        UITraitCollection.current.preferredContentSizeCategory.swiftUICategory
    }
    
    /// Check if accessibility size is being used
    static var isAccessibilitySize: Bool {
        currentContentSizeCategory.isAccessibilityCategory
    }
    
    /// Dynamic spacing based on content size category
    static func accessibleSpacing(base: CGFloat) -> CGFloat {
        switch currentContentSizeCategory {
        case .extraSmall, .small:
            return base * 0.8
        case .medium, .large:
            return base
        case .extraLarge, .extraExtraLarge, .extraExtraExtraLarge:
            return base * 1.2
        case .accessibilityMedium, .accessibilityLarge:
            return base * 1.5
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return base * 2.0
        @unknown default:
            return base
        }
    }
    
    /// Dynamic font size scaling
    static func accessibleFontSize(base: CGFloat) -> CGFloat {
        switch currentContentSizeCategory {
        case .extraSmall:
            return base * 0.8
        case .small:
            return base * 0.9
        case .medium:
            return base
        case .large:
            return base * 1.1
        case .extraLarge:
            return base * 1.2
        case .extraExtraLarge:
            return base * 1.3
        case .extraExtraExtraLarge:
            return base * 1.4
        case .accessibilityMedium:
            return base * 1.6
        case .accessibilityLarge:
            return base * 1.8
        case .accessibilityExtraLarge:
            return base * 2.0
        case .accessibilityExtraExtraLarge:
            return base * 2.2
        case .accessibilityExtraExtraExtraLarge:
            return base * 2.4
        @unknown default:
            return base
        }
    }
    
    /// Minimum touch target size for accessibility (44x44 points)
    static let minimumTouchTargetSize: CGFloat = 44
    
    /// Ensure view meets minimum touch target requirements
    static func ensureMinimumTouchTarget(width: CGFloat, height: CGFloat) -> (width: CGFloat, height: CGFloat) {
        return (
            width: max(width, minimumTouchTargetSize),
            height: max(height, minimumTouchTargetSize)
        )
    }
    
    /// Accessibility scale factor for spacing and sizing
    static var accessibilityScaleFactor: CGFloat {
        if isVoiceOverRunning {
            return 1.5
        } else if isAccessibilitySize {
            return 1.3
        } else {
            return 1.0
        }
    }
    
    /// Scale a value based on accessibility preferences
    static func scaledValue(_ value: CGFloat) -> CGFloat {
        return value * accessibilityScaleFactor
    }
}

/// View modifier for accessibility-aware styling
struct AccessibilityAwareModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(.medium ... .accessibility3)
            .animation(AccessibilityUtils.prefersReducedMotion ? .none : .default, value: AccessibilityUtils.currentContentSizeCategory)
    }
}

/// Extension for UIContentSizeCategory to SwiftUI ContentSizeCategory conversion
extension UIContentSizeCategory {
    var swiftUICategory: ContentSizeCategory {
        switch self {
        case .extraSmall: return .extraSmall
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .extraLarge: return .extraLarge
        case .extraExtraLarge: return .extraExtraLarge
        case .extraExtraExtraLarge: return .extraExtraExtraLarge
        case .accessibilityMedium: return .accessibilityMedium
        case .accessibilityLarge: return .accessibilityLarge
        case .accessibilityExtraLarge: return .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge: return .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge: return .accessibilityExtraExtraExtraLarge
        default: return .large
        }
    }
}

/// High contrast color utilities
extension Color {
    /// Colors that automatically adjust for high contrast preferences
    static var accessiblePrimary: Color {
        AccessibilityUtils.prefersIncreasedContrast ? .black : .primary
    }
    
    static var accessibleSecondary: Color {
        AccessibilityUtils.prefersIncreasedContrast ? .black.opacity(0.7) : .secondary
    }
    
    static var accessibleBackground: Color {
        AccessibilityUtils.prefersIncreasedContrast ? .white : Color(.systemBackground)
    }
    
    static var accessibleTeal: Color {
        if AccessibilityUtils.prefersIncreasedContrast {
            return Color(red: 0.0, green: 0.4, blue: 0.5) // Darker teal for better contrast
        } else {
            return Color(red: 0.0, green: 0.6, blue: 0.6) // Original teal
        }
    }
}

/// View extension for common accessibility improvements
extension View {
    /// Apply accessibility-aware styling
    func accessibilityAware() -> some View {
        self.modifier(AccessibilityAwareModifier())
    }
    
    /// Ensure minimum touch target size
    func accessibleTouchTarget(minSize: CGFloat = AccessibilityUtils.minimumTouchTargetSize) -> some View {
        self.frame(minWidth: minSize, minHeight: minSize)
    }
    
    /// Apply accessibility-friendly animations
    func accessibleAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        if AccessibilityUtils.prefersReducedMotion {
            return AnyView(self)
        } else {
            return AnyView(self.animation(animation, value: value))
        }
    }
    
    /// Voice-over friendly label with hint
    func voiceOverLabel(_ label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}



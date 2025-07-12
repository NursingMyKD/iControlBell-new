//  HapticUtils.swift
//  iControlBell - Shared Haptic Utilities
//
//  Created by GitHub Copilot on 7/12/25.

import UIKit

struct HapticUtils {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard !AccessibilityUtils.prefersReducedMotion else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func selection() {
        guard !AccessibilityUtils.prefersReducedMotion else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard !AccessibilityUtils.prefersReducedMotion else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

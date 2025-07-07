// SoundboardView.swift
// Soundboard for speaking phrases

import SwiftUI
import AVFoundation
import Foundation

/// Displays a soundboard for speaking phrases in the selected language.
struct SoundboardView: View {
    var selectedLanguage: Language
    var categories: [SoundboardCategory]
    var isIPad: Bool
    var isCompact: Bool
    @State private var selectedCategoryIndex: Int = 0
    @State private var isSpeaking = false
    @State private var speechSynth = AVSpeechSynthesizer()
    
    // Dynamic layout properties
    private var gridColumns: Int {
        if isIPad {
            return 6
        } else if isCompact {
            return 3
        } else {
            return 4
        }
    }
    
    private var buttonHeight: CGFloat {
        if isIPad {
            return 120
        } else if isCompact {
            return 80
        } else {
            return 100
        }
    }
    
    private var titleFont: Font {
        if isIPad {
            return .largeTitle
        } else if isCompact {
            return .title3
        } else {
            return .title2
        }
    }
    
    private var bodyFont: Font {
        if isIPad {
            return .title3
        } else if isCompact {
            return .caption
        } else {
            return .body
        }
    }
    
    private var buttonFont: Font {
        if isIPad {
            return .body
        } else if isCompact {
            return .caption2
        } else {
            return .caption
        }
    }
    
    private var iconSize: CGFloat {
        if isIPad {
            return 32
        } else if isCompact {
            return 20
        } else {
            return 24
        }
    }
    
    private var horizontalPadding: CGFloat {
        if isIPad {
            return 24
        } else if isCompact {
            return 12
        } else {
            return 16
        }
    }
    
    private var sectionSpacing: CGFloat {
        if isIPad {
            return 32
        } else if isCompact {
            return 16
        } else {
            return 24
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: sectionSpacing) {
            // Soundboard title and description
            VStack(spacing: 16) {
                Text("Soundboard")
                    .font(titleFont)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Select a category and a phrase to have it spoken aloud.")
                    .font(bodyFont)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Voice selector (simplified for now)
                if !isCompact {
                    VStack(spacing: 8) {
                        Text("Select Voice:")
                            .font(bodyFont)
                            .foregroundColor(.primary)
                        
                        Text("System Voice (\(selectedLanguage.rawValue.uppercased()))")
                            .font(bodyFont)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Category tabs
            if !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: isIPad ? 20 : 12) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Button(action: {
                                selectedCategoryIndex = index
                            }) {
                                Text(categories[index].displayName(for: selectedLanguage))
                                    .font(bodyFont)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedCategoryIndex == index ? .white : .primary)
                                    .padding(.horizontal, horizontalPadding)
                                    .padding(.vertical, isIPad ? 12 : 8)
                                    .background(
                                        selectedCategoryIndex == index ? 
                                        Color.accentColor : Color(.systemGray6)
                                    )
                                    .cornerRadius(isIPad ? 12 : 8)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                
                // Phrase buttons grid
                if categories.indices.contains(selectedCategoryIndex) {
                    let phrases = categories[selectedCategoryIndex].phrases[selectedLanguage.rawValue] ?? []
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: isIPad ? 16 : 12), count: gridColumns), 
                        spacing: isIPad ? 16 : 12
                    ) {
                        ForEach(phrases, id: \.self) { phrase in
                            phraseButton(for: phrase)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
            } else {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "speaker.slash.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(.secondary)
                    
                    Text("No soundboard categories available")
                        .font(bodyFont)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func phraseButton(for phrase: String) -> some View {
        Button(action: {
            HapticUtils.selection()
            speak(phrase)
        }) {
            VStack(spacing: isIPad ? 8 : 4) {
                Image(systemName: isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                    .font(.system(size: iconSize))
                    .foregroundColor(.primary)
                    .frame(height: iconSize)
                    .accessibleAnimation(.easeInOut(duration: 0.3), value: isSpeaking)
                
                Text(phrase)
                    .font(buttonFont)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(isCompact ? 2 : 3)
                    .minimumScaleFactor(0.7)
            }
            .padding(.vertical, isIPad ? 16 : (isCompact ? 8 : 12))
            .padding(.horizontal, isIPad ? 12 : (isCompact ? 6 : 8))
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(
                AccessibilityUtils.prefersIncreasedContrast ? 
                Color(.systemGray4) : Color(.systemGray6)
            )
            .cornerRadius(isIPad ? 16 : (isCompact ? 8 : 12))
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 16 : (isCompact ? 8 : 12))
                    .stroke(
                        isSpeaking ? Color.accentColor : Color.clear, 
                        lineWidth: isSpeaking ? 3 : 0
                    )
                    .accessibleAnimation(.easeInOut(duration: 0.2), value: isSpeaking)
            )
        }
        .accessibleTouchTarget(minSize: max(buttonHeight, AccessibilityUtils.minimumTouchTargetSize))
        .voiceOverLabel(
            "Speak: \(phrase)",
            hint: isSpeaking ? "Currently speaking this phrase" : "Double tap to speak this phrase aloud"
        )
        .accessibilityIdentifier("sound_button_\(phrase.replacingOccurrences(of: " ", with: "_"))")
        .accessibilityAddTraits(.isButton)
        .buttonStyle(ScaleButtonStyle())
        .accessibilityAware()
    }
    
    /// Speaks the given phrase using AVSpeechSynthesizer.
    func speak(_ phrase: String) {
        // Stop any current speech
        if speechSynth.isSpeaking {
            speechSynth.stopSpeaking(at: .immediate)
            isSpeaking = false
            return
        }
        
        isSpeaking = true
        let utterance = AVSpeechUtterance(string: phrase)
        
        // Try to get a voice for the selected language, fallback to system default
        if let voice = AVSpeechSynthesisVoice(language: selectedLanguage.rawValue) {
            utterance.voice = voice
        } else {
            // Fallback to English if selected language voice isn't available
            utterance.voice = AVSpeechSynthesisVoice(language: "en") ?? AVSpeechSynthesisVoice.speechVoices().first
        }
        
        // Set speech properties for better healthcare use
        utterance.rate = AccessibilityUtils.isVoiceOverRunning ? 0.4 : 0.5 // Slower for VoiceOver users
        utterance.volume = 1.0
        utterance.pitchMultiplier = 1.0
        
        // Set up delegate to track speech completion
        speechSynth.delegate = SpeechDelegate { [weak self] in
            DispatchQueue.main.async {
                self?.isSpeaking = false
                HapticUtils.success() // Haptic feedback when speech completes
            }
        }
        
        speechSynth.speak(utterance)
        
        // Immediate haptic feedback for button press
        HapticUtils.buttonTap()
    }
}

// Helper class to handle speech synthesis delegate
class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    private let onFinish: () -> Void
    
    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinish()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        onFinish()
    }
}
}

#Preview {
    SoundboardView(
        selectedLanguage: .english, 
        categories: [],
        isIPad: false,
        isCompact: false
    )
}

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
    @State private var speechDelegate: SpeechDelegate?
    @State private var speechSynth = AVSpeechSynthesizer()
    @State private var isSpeakingEnglish = false
    
    // Dynamic layout properties using DeviceUtils
    private var gridColumns: Int {
        DeviceUtils.adaptiveColumns(for: "soundboard")
    }
    private var buttonHeight: CGFloat {
        DeviceUtils.dynamicSpacing(compact: 56, regular: 70, iPad: 90)
    }
    private var titleFont: Font {
        DeviceUtils.dynamicFont(
            compact: .title3,
            regular: .title2,
            iPad: .largeTitle
        )
    }
    private var bodyFont: Font {
        DeviceUtils.dynamicFont(
            compact: .caption2,
            regular: .caption,
            iPad: .body
        )
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
            return 28
        } else if isCompact {
            return 18
        } else {
            return 20
        }
    }
    private var horizontalPadding: CGFloat {
        if isIPad {
            return 12
        } else if isCompact {
            return 6
        } else {
            return 8
        }
    }
    private var sectionSpacing: CGFloat {
        if isIPad {
            return 16
        } else if isCompact {
            return 8
        } else {
            return 12
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: sectionSpacing) {
            // Soundboard title and description (only once)
            VStack(spacing: 8) {
                Text("soundboard_title".localized)
                    .font(titleFont)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                // Voice selector (simplified for now)
                if !isCompact {
                    VStack(spacing: 4) {
                        Text("Select Voice".localized)
                            .font(bodyFont)
                            .foregroundColor(.primary)
                        Text("\("Voice".localized) (\(selectedLanguage.rawValue.uppercased()))")
                            .font(bodyFont)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
            // Category tabs
            if !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: isIPad ? 10 : 6) {
                        ForEach(0..<categories.count, id: \ .self) { index in
                            Button(action: {
                                selectedCategoryIndex = index
                            }) {
                                Text(categories[index].displayName(for: selectedLanguage))
                                    .font(bodyFont)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedCategoryIndex == index ? .white : .primary)
                                    .padding(.horizontal, horizontalPadding)
                                    .padding(.vertical, isIPad ? 6 : 4)
                                    .background(
                                        selectedCategoryIndex == index ? 
                                        Color.accentColor : Color(.systemGray6)
                                    )
                                    .cornerRadius(isIPad ? 8 : 6)
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
                        columns: Array(repeating: GridItem(.flexible(), spacing: isIPad ? 8 : 4), count: gridColumns), 
                        spacing: isIPad ? 8 : 4
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
                        .accessibilityHidden(true)
                    Text("no_categories_available".localized)
                        .font(bodyFont)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
        .padding(.vertical)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("soundboard_group_accessibility".localized)
    }
    
    @ViewBuilder
    private func phraseButton(for phrase: String) -> some View {
        HStack(spacing: 8) {
            Button(action: {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
                speak(phrase)
            }) {
                VStack(spacing: isIPad ? 8 : 4) {
                    Image(systemName: isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(.primary)
                        .frame(height: iconSize)
                        .animation(.easeInOut(duration: 0.3), value: isSpeaking)
                    Text(phrase)
                        .font(buttonFont)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(isCompact ? 2 : 3)
                        .minimumScaleFactor(0.7)
                }
                .padding(.vertical, isIPad ? 6 : (isCompact ? 4 : 6))
                .padding(.horizontal, isIPad ? 6 : (isCompact ? 4 : 6))
                .frame(maxWidth: .infinity)
                .frame(height: buttonHeight)
                .background(
                    UIAccessibility.isDarkerSystemColorsEnabled ? 
                        Color(.systemGray4) : Color(.systemGray6)
                )
                .cornerRadius(isIPad ? 16 : (isCompact ? 8 : 12))
                .overlay(
                    RoundedRectangle(cornerRadius: isIPad ? 16 : (isCompact ? 8 : 12))
                        .stroke(
                            isSpeaking ? Color.accentColor : Color.clear, 
                            lineWidth: isSpeaking ? 3 : 0
                        )
                        .animation(.easeInOut(duration: 0.2), value: isSpeaking)
                )
            }
            .frame(minWidth: max(buttonHeight, 44), minHeight: max(buttonHeight, 44))
            .accessibilityLabel("\("soundboard_phrase_accessibility".localized): \(phrase)")
            .accessibilityHint(isSpeaking ? "currently_speaking_accessibility".localized : "tap_to_speak_accessibility".localized)
            .accessibilityIdentifier("sound_button_\(phrase.replacingOccurrences(of: " ", with: "_"))")
            .accessibilityAddTraits(.isButton)
            .buttonStyle(ScaleButtonStyle())

            // English TTS button if not English
            if selectedLanguage != .english, let englishPhrase = englishTranslation(for: phrase) {
                Button(action: {
                    let selection = UISelectionFeedbackGenerator()
                    selection.selectionChanged()
                    speakEnglish(englishPhrase)
                }) {
                    VStack(spacing: 2) {
                        Image(systemName: isSpeakingEnglish ? "speaker.wave.3.fill" : "globe")
                            .font(.system(size: iconSize - 2))
                            .foregroundColor(.blue)
                        Text("English")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                .accessibilityLabel("Play English version")
                .accessibilityHint("Tap to hear the English translation")
            }
        }
    }

    /// Returns the English translation for a phrase in the current category, if available.
    private func englishTranslation(for phrase: String) -> String? {
        guard selectedLanguage != .english,
              categories.indices.contains(selectedCategoryIndex),
              let phrasesInLang = categories[selectedCategoryIndex].phrases[selectedLanguage.rawValue],
              let idx = phrasesInLang.firstIndex(of: phrase),
              let englishPhrases = categories[selectedCategoryIndex].phrases[Language.english.rawValue],
              englishPhrases.indices.contains(idx)
        else { return nil }
        return englishPhrases[idx]
    }

    /// Speaks the given phrase in English using AVSpeechSynthesizer.
    private func speakEnglish(_ phrase: String) {
        if self.speechSynth.isSpeaking {
            self.speechSynth.stopSpeaking(at: .immediate)
            self.isSpeakingEnglish = false
            return
        }
        self.isSpeakingEnglish = true
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "en") ?? AVSpeechSynthesisVoice.speechVoices().first
        utterance.rate = UIAccessibility.isVoiceOverRunning ? 0.4 : 0.5
        utterance.volume = 1.0
        utterance.pitchMultiplier = 1.0
        let delegate = SpeechDelegate {
            DispatchQueue.main.async {
                self.isSpeakingEnglish = false
                let success = UINotificationFeedbackGenerator()
                success.notificationOccurred(.success)
            }
        }
        self.speechDelegate = delegate
        self.speechSynth.delegate = delegate
        self.speechSynth.speak(utterance)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    /// Speaks the given phrase using AVSpeechSynthesizer.
    private func speak(_ phrase: String) {
        // Stop any current speech
        if self.speechSynth.isSpeaking {
            self.speechSynth.stopSpeaking(at: .immediate)
            self.isSpeaking = false
            return
        }

        self.isSpeaking = true
        let utterance = AVSpeechUtterance(string: phrase)

        // Try to get a voice for the selected language, fallback to system default
        if let voice = AVSpeechSynthesisVoice(language: self.selectedLanguage.rawValue) {
            utterance.voice = voice
        } else {
            // Fallback to English if selected language voice isn't available
            utterance.voice = AVSpeechSynthesisVoice(language: "en") ?? AVSpeechSynthesisVoice.speechVoices().first
        }

        // Set speech properties for better healthcare use
        utterance.rate = UIAccessibility.isVoiceOverRunning ? 0.4 : 0.5 // Slower for VoiceOver users
        utterance.volume = 1.0
        utterance.pitchMultiplier = 1.0

        // Set up delegate to track speech completion
        let delegate = SpeechDelegate {
            DispatchQueue.main.async {
                self.isSpeaking = false
                // Success haptic feedback
                let success = UINotificationFeedbackGenerator()
                success.notificationOccurred(.success)
            }
        }
        self.speechDelegate = delegate
        self.speechSynth.delegate = delegate

        self.speechSynth.speak(utterance)

        // Immediate haptic feedback for button press
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
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

#Preview {
    SoundboardView(
        selectedLanguage: .english, 
        categories: [],
        isIPad: false,
        isCompact: false
    )
}

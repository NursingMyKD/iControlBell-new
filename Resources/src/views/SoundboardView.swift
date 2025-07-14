// SoundboardView.swift
// Soundboard for speaking phrases

import SwiftUI
import AVFoundation

/// Displays a soundboard for speaking phrases in the selected language.
struct SoundboardView: View {
    // Accessibility focus state for rotor navigation
    @AccessibilityFocusState private var focusedPhrase: String?
    // Favorites bar state
    @State private var favoritePhrases: [String] = []
    // Collapsible state for each category
    @State private var expandedCategories: Set<Int> = []
    // System language picker scaffold
    @State private var selectedSystemLocale: Locale = Locale.current

    var selectedLanguage: Language
    var categories: [SoundboardCategory]
    var isIPad: Bool
    var isCompact: Bool
    // Removed selectedCategoryIndex unless used for navigation
    @State private var isSpeaking = false
    @State private var speechDelegate: SpeechDelegate?
    @State private var speechSynth = AVSpeechSynthesizer()
    @State private var isSpeakingEnglish = false
    @State private var selectedVoiceIdentifier: String = AVSpeechSynthesisVoice.speechVoices().first?.identifier ?? ""

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
            return 10
        } else if isCompact {
            return 5
        } else {
            return 8
        }
    }

    // Computed property for available voices
    private var voices: [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
    }

    var body: some View {
        let mainContent = VStack {
            // Favorites bar
            if !favoritePhrases.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(favoritePhrases, id: \.self) { phrase in
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .soft)
                                impact.impactOccurred()
                                speak(phrase, voiceIdentifier: selectedVoiceIdentifier)
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(phrase)
                                        .font(.body)
                                        .dynamicTypeSize(.large ... .xxxLarge)
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                            }
                            .frame(minWidth: 48, minHeight: 48)
                            .accessibilityLabel("Favorite: \(phrase)")
                            .accessibilityHint("Tap to speak favorite phrase")
                            .accessibilityAddTraits(.isButton)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                .padding(.bottom, 4)
            }
            // System language picker (scaffold)
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.accentColor)
                Picker("System Language", selection: $selectedSystemLocale) {
                    ForEach(Locale.availableIdentifiers, id: \.self) { id in
                        let locale = Locale(identifier: id)
                        Text(locale.localizedString(forIdentifier: id) ?? id)
                            .tag(locale)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accessibilityLabel("System Language Picker")
                .accessibilityHint("Select the system language")
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 4)
            VStack(alignment: .leading, spacing: sectionSpacing * 0.8) {
                if !isCompact && voices.count > 1 {
                    Picker(selection: $selectedVoiceIdentifier, label: EmptyView()) {
                        ForEach(voices, id: \.identifier) { voice in
                            Text("\(voice.name) (\(voice.language))")
                                .font(.body)
                                .dynamicTypeSize(.large ... .xxxLarge)
                                .accessibilityLabel("Voice: \(voice.name), Language: \(voice.language)")
                                .tag(voice.identifier)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 320)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .accessibilityLabel("Voice Picker")
                    .accessibilityHint("Select a voice for speech output")
                }
                // Category tabs
                if !categories.isEmpty {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: sectionSpacing) {
                            ForEach(0..<categories.count, id: \.self) { index in
                                VStack(spacing: 0) {
                                    Button(action: {
                                        let impact = UIImpactFeedbackGenerator(style: .soft)
                                        impact.impactOccurred()
                                        if expandedCategories.contains(index) {
                                            expandedCategories.remove(index)
                                        } else {
                                            expandedCategories.insert(index)
                                        }
                                    }) {
                                        HStack {
                                            Text(categories[index].displayName(for: selectedLanguage))
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .dynamicTypeSize(.large ... .xxxLarge)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Image(systemName: expandedCategories.contains(index) ? "chevron.down" : "chevron.right")
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal, horizontalPadding)
                                        .padding(.vertical, isIPad ? 10 : 8)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(isIPad ? 10 : 8)
                                    }
                                    .frame(minWidth: 48, minHeight: 48)
                                    .accessibilityLabel(categories[index].displayName(for: selectedLanguage))
                                    .accessibilityHint("Expand or collapse category \(categories[index].displayName(for: selectedLanguage))")
                                    .accessibilityAddTraits(.isButton)
                                    .buttonStyle(PlainButtonStyle())
                                    if expandedCategories.contains(index) {
                                        let phrases = categories[index].phrases[selectedLanguage.rawValue] ?? []
                                        LazyVGrid(
                                            columns: Array(repeating: GridItem(.flexible(), spacing: isIPad ? 8 : 4), count: gridColumns),
                                            spacing: isIPad ? 8 : 4
                                        ) {
                                            ForEach(phrases, id: \.self) { phrase in
                                                phraseButton(for: phrase)
                                            }
                                        }
                                        .padding(.horizontal, horizontalPadding)
                                        .padding(.bottom, sectionSpacing)
                                    }
                                }
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
            .padding(.vertical, 6)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("soundboard_group_accessibility".localized)
        }

        if #available(iOS 17.0, *) {
            mainContent
                .accessibilityRotor("Categories") {
                    ForEach(categories.indices, id: \.self) { idx in
                        AccessibilityRotorEntry(categories[idx].displayName(for: selectedLanguage), id: categories[idx].displayName(for: selectedLanguage))
                    }
                }
                .accessibilityRotor("Favorites") {
                    ForEach(favoritePhrases, id: \.self) { phrase in
                        AccessibilityRotorEntry(phrase, id: phrase)
                    }
                }
        } else {
            mainContent
        }
    }

    @ViewBuilder
    private func phraseButton(for phrase: String) -> some View {
        HStack(spacing: 8) {
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .soft)
                impact.impactOccurred()
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
                speak(phrase, voiceIdentifier: selectedVoiceIdentifier)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: isIPad ? 20 : (isCompact ? 12 : 16), style: .continuous)
                        .fill(isSpeaking ? Color.successGreen : Color(.systemBackground))
                        .shadow(color: Color.black.opacity(isSpeaking ? 0.18 : 0.08), radius: isSpeaking ? 8 : 4, x: 0, y: isSpeaking ? 4 : 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? 20 : (isCompact ? 12 : 16), style: .continuous)
                                .stroke(isSpeaking ? Color.successGreen : Color.primaryBlue, lineWidth: isSpeaking ? 3 : 1)
                        )
                        .if(!UIAccessibility.isReduceMotionEnabled) { view in
                            view.animation(.easeInOut(duration: 0.2), value: isSpeaking)
                        }
                    VStack(spacing: isIPad ? 10 : 6) {
                        Image(systemName: isSpeaking ? "checkmark.circle.fill" : "speaker.wave.2.fill")
                            .font(.system(size: iconSize + 4))
                            .foregroundColor(isSpeaking ? Color.successGreen : Color.primaryBlue)
                            .frame(height: iconSize + 4)
                            .if(!UIAccessibility.isReduceMotionEnabled) { view in
                                view.animation(.easeInOut(duration: 0.2), value: isSpeaking)
                            }
                        Text(phrase)
                            .font(.body)
                            .dynamicTypeSize(.large ... .xxxLarge)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(isCompact ? 2 : 3)
                            .minimumScaleFactor(0.7)
                    }
                    .padding(.vertical, isIPad ? 10 : (isCompact ? 6 : 8))
                    .padding(.horizontal, isIPad ? 10 : (isCompact ? 6 : 8))
                }
                .frame(maxWidth: .infinity)
                .frame(height: buttonHeight)
            }
            .frame(minWidth: 48, minHeight: 48)
            .accessibilityLabel("\("soundboard_phrase_accessibility".localized): \(phrase)")
            .accessibilityHint(isSpeaking ? "currently_speaking_accessibility".localized : "tap_to_speak_accessibility".localized)
            .accessibilityIdentifier("sound_button_\(phrase.replacingOccurrences(of: " ", with: "_"))")
            .accessibilityAddTraits(.isButton)
            .buttonStyle(PlainButtonStyle())
            .contextMenu {
                Button(action: {
                    if favoritePhrases.contains(phrase) {
                        favoritePhrases.removeAll { $0 == phrase }
                    } else {
                        favoritePhrases.append(phrase)
                    }
                }) {
                    Label(favoritePhrases.contains(phrase) ? "Remove from Favorites" : "Add to Favorites", systemImage: favoritePhrases.contains(phrase) ? "star.slash" : "star")
                }
            }
            .accessibilityAction(named: favoritePhrases.contains(phrase) ? "Remove from Favorites" : "Add to Favorites") {
                if favoritePhrases.contains(phrase) {
                    favoritePhrases.removeAll { $0 == phrase }
                } else {
                    favoritePhrases.append(phrase)
                }
            }
            .accessibilityFocused($focusedPhrase, equals: phrase)

            // English TTS button if not English
            if selectedLanguage != .english, let englishPhrase = englishTranslation(for: phrase) {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .soft)
                    impact.impactOccurred()
                    let selection = UISelectionFeedbackGenerator()
                    selection.selectionChanged()
                    speakEnglish(englishPhrase)
                }) {
                    VStack(spacing: 2) {
                        Image(systemName: isSpeakingEnglish ? "speaker.wave.3.fill" : "globe")
                            .font(.system(size: iconSize - 2))
                            .foregroundColor(.accentColor)
                        Text("English")
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.large ... .xxxLarge)
                            .foregroundColor(.accentColor)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                .frame(minWidth: 48, minHeight: 48)
                .accessibilityLabel("Play English version")
                .accessibilityHint("Tap to hear the English translation")
                .accessibilityAddTraits(.isButton)
            }
        }
    }

    /// Returns the English translation for a phrase in the current category, if available.
    private func englishTranslation(for phrase: String) -> String? {
        // Only implement if selectedCategoryIndex is needed; otherwise, remove this function or refactor as needed.
        return nil
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
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
    }

    /// Speaks the given phrase using AVSpeechSynthesizer.
    private func speak(_ phrase: String, voiceIdentifier: String? = nil) {
        // Stop any current speech
        if self.speechSynth.isSpeaking {
            self.speechSynth.stopSpeaking(at: .immediate)
            self.isSpeaking = false
            return
        }

        self.isSpeaking = true
        let utterance = AVSpeechUtterance(string: phrase)

        // Use selected voice if provided, else fallback to language default
        if let identifier = voiceIdentifier, let voice = AVSpeechSynthesisVoice(identifier: identifier) {
            utterance.voice = voice
        } else if let voice = AVSpeechSynthesisVoice(language: self.selectedLanguage.rawValue) {
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
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
    }
}

// Color extension for custom palette
extension Color {
    static let primaryBlue = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF
    static let secondaryGreen = Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
    static let successGreen = Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
}

// SwiftUI View extension for conditional modifier
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
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
        categories: [
            SoundboardCategory(
                id: "greetings",
                displayNames: ["en": "Greetings", "es": "Saludos"],
                phrases: [
                    "en": ["Hello", "Good morning"],
                    "es": ["Hola", "Buenos días"]
                ]
            )
        ],
        isIPad: false,
        isCompact: false
    )
}

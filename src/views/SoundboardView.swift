// SoundboardView.swift
// Soundboard for speaking phrases

import SwiftUI
import AVFoundation

/// Displays a soundboard for speaking phrases in the selected language.
struct SoundboardView: View {
    var selectedLanguage: Language
    var categories: [SoundboardCategory]
    @State private var selectedCategoryIndex: Int = 0
    @State private var isSpeaking = false
    @State private var speechSynth = AVSpeechSynthesizer()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Soundboard title
            VStack(spacing: 16) {
                Text("Soundboard")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Select a category and a phrase to have it spoken aloud.")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Voice selector
                VStack(spacing: 8) {
                    Text("Select Voice:")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text("Samantha (en-US)")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .cornerRadius(8)
                }
            }
            
            // Category tabs
            if !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Button(action: {
                                selectedCategoryIndex = index
                            }) {
                                Text(categories[index].displayName(for: selectedLanguage))
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedCategoryIndex == index ? .white : .gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedCategoryIndex == index ? Color(red: 0.15, green: 0.15, blue: 0.15) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                // Phrase buttons grid
                if categories.indices.contains(selectedCategoryIndex) {
                    let phrases = categories[selectedCategoryIndex].phrases[selectedLanguage.rawValue] ?? []
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 5), spacing: 16) {
                        ForEach(phrases, id: \.self) { phrase in
                            Button(action: {
                                speak(phrase)
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    Text(phrase)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 8)
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(Color(red: 0.15, green: 0.15, blue: 0.15)) // Dark button background
                                .cornerRadius(12)
                            }
                            .accessibilityLabel(phrase)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint("Double tap to speak phrase.")
                            .accessibilityIdentifier("sound_button_\(phrase)")
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.vertical)
    }
    
    /// Speaks the given phrase using AVSpeechSynthesizer.
    func speak(_ phrase: String) {
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: selectedLanguage.rawValue)
        speechSynth.speak(utterance)
    }
}

#Preview {
    SoundboardView(selectedLanguage: .english, categories: [])
}

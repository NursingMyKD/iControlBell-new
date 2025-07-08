//
//  iControlBellTests.swift
//  iControlBellTests - Enhanced Healthcare Testing Suite
//
//  Created by shane stone on 7/6/25.
//

import XCTest
import AVFoundation
@testable import iControlBell

final class iControlBellTests: XCTestCase {
    
    var appState: AppState!
    var soundManager: SoundManager!
    
    override func setUpWithError() throws {
        // Initialize fresh instances for each test
        appState = AppState()
        soundManager = SoundManager.shared
    }

    override func tearDownWithError() throws {
        // Clean up after each test
        appState = nil
        soundManager = nil
    }

    // MARK: - AppState Tests (Critical for Healthcare Workflow)
    
    func testLanguageSelection() throws {
        // Test language switching functionality
        XCTAssertEqual(appState.selectedLanguage, .english, "Default language should be English")
        
        appState.selectedLanguage = .spanish
        XCTAssertEqual(appState.selectedLanguage, .spanish, "Language should change to Spanish")
        
        appState.selectedLanguage = .french
        XCTAssertEqual(appState.selectedLanguage, .french, "Language should change to French")
    }
    
    func testToastMessage() throws {
        // Test toast notification system (critical for user feedback)
        XCTAssertNil(appState.toastMessage, "Initial toast message should be nil")
        XCTAssertFalse(appState.toastIsError, "Initial toast error state should be false")
        
        appState.showToast("Test message", isError: false)
        XCTAssertEqual(appState.toastMessage, "Test message", "Toast message should be set")
        XCTAssertFalse(appState.toastIsError, "Toast should not be error type")
        
        appState.showToast("Error message", isError: true)
        XCTAssertEqual(appState.toastMessage, "Error message", "Toast error message should be set")
        XCTAssertTrue(appState.toastIsError, "Toast should be error type")
    }
    
    func testBluetoothErrorHandling() throws {
        // Test Bluetooth error handling (critical for medical device connectivity)
        let bluetoothError = "Connection failed"
        appState.showBluetoothError(bluetoothError)
        
        XCTAssertEqual(appState.toastMessage, bluetoothError, "Bluetooth error should be displayed")
        XCTAssertTrue(appState.toastIsError, "Bluetooth error should be marked as error")
    }
    
    func testToastMessageAutoDisappearance() throws {
        // Test that toast messages automatically disappear (prevents UI clutter)
        let expectation = XCTestExpectation(description: "Toast message should disappear")
        
        appState.showToast("Temporary message")
        XCTAssertNotNil(appState.toastMessage, "Toast should initially be visible")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            XCTAssertNil(self.appState.toastMessage, "Toast should disappear after timeout")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - Language System Tests (Critical for Multilingual Healthcare)
    
    func testLanguageEnumeration() throws {
        // Ensure all supported languages are accessible
        let supportedLanguages = Language.allCases
        XCTAssertGreaterThan(supportedLanguages.count, 30, "Should support at least 30 languages")
        XCTAssertTrue(supportedLanguages.contains(.english), "English should be supported")
        XCTAssertTrue(supportedLanguages.contains(.spanish), "Spanish should be supported")
        XCTAssertTrue(supportedLanguages.contains(.french), "French should be supported")
    }
    
    func testLanguageLocalizedNames() throws {
        // Test that languages have proper localized names
        XCTAssertFalse(Language.english.localizedName.isEmpty, "English should have localized name")
        XCTAssertFalse(Language.spanish.localizedName.isEmpty, "Spanish should have localized name")
        XCTAssertFalse(Language.mandarin.localizedName.isEmpty, "Mandarin should have localized name")
    }
    
    // MARK: - Data Loading Tests (Critical for App Functionality)
    
    func testCallRequestOptionsLoading() throws {
        // Test that call request options load properly
        let callOptions = PlistLoader.loadCallRequestOptions()
        XCTAssertFalse(callOptions.isEmpty, "Call request options should not be empty")
        
        // Verify each option has required properties
        for option in callOptions {
            XCTAssertFalse(option.title.isEmpty, "Call option should have title")
            XCTAssertFalse(option.message.isEmpty, "Call option should have message")
            XCTAssertFalse(option.iconName.isEmpty, "Call option should have icon name")
        }
    }
    
    func testSoundboardCategoriesLoading() throws {
        // Test that soundboard categories load properly
        let categories = PlistLoader.loadSoundboardCategories()
        XCTAssertFalse(categories.isEmpty, "Soundboard categories should not be empty")
        
        // Verify each category has required properties
        for category in categories {
            XCTAssertFalse(category.name.isEmpty, "Category should have name")
            XCTAssertFalse(category.iconName.isEmpty, "Category should have icon name")
            XCTAssertFalse(category.phrases.isEmpty, "Category should have phrases")
        }
    }
    
    // MARK: - Sound System Tests (Critical for User Feedback)
    
    func testSoundManagerInitialization() throws {
        // Test that sound manager initializes properly
        XCTAssertNotNil(soundManager, "SoundManager should initialize")
        XCTAssertTrue(soundManager === SoundManager.shared, "Should use singleton pattern")
    }
    
    func testSoundFileAvailability() throws {
        // Test that required sound files are available
        let successSoundURL = Bundle.main.url(forResource: "success", withExtension: "mp3")
        XCTAssertNotNil(successSoundURL, "Success sound file should be available")
        
        // Test that the file is actually readable
        if let url = successSoundURL {
            XCTAssertNoThrow(try Data(contentsOf: url), "Success sound file should be readable")
        }
    }
    
    // MARK: - Accessibility Tests (Critical for Healthcare Compliance)
    
    func testAccessibilityUtilsAvailability() throws {
        // Test that accessibility utilities are available
        let isVoiceOverRunning = AccessibilityUtils.isVoiceOverRunning
        XCTAssertNotNil(isVoiceOverRunning, "VoiceOver status should be determinable")
        
        let preferredContentSize = AccessibilityUtils.preferredContentSizeCategory
        XCTAssertNotNil(preferredContentSize, "Content size category should be available")
    }
    
    func testDeviceUtilsAvailability() throws {
        // Test that device utilities work properly
        let currentDevice = DeviceUtils.currentDevice
        XCTAssertNotNil(currentDevice, "Current device should be determinable")
        
        let isIPad = DeviceUtils.isIPad
        XCTAssertNotNil(isIPad, "iPad detection should work")
        
        let spacing = DeviceUtils.adaptiveSpacing
        XCTAssertGreaterThan(spacing, 0, "Adaptive spacing should be positive")
    }
    
    // MARK: - Performance Tests (Critical for Healthcare Environment)
    
    func testAppStatePerformance() throws {
        // Test performance of frequent operations
        measure {
            for _ in 0..<1000 {
                appState.selectedLanguage = .spanish
                appState.selectedLanguage = .english
                appState.showToast("Performance test")
            }
        }
    }
    
    func testLanguageSwitchingPerformance() throws {
        // Test performance of language switching (frequent operation)
        let languages = Language.allCases
        
        measure {
            for language in languages {
                appState.selectedLanguage = language
            }
        }
    }
    
    func testDataLoadingPerformance() throws {
        // Test performance of data loading operations
        measure {
            _ = PlistLoader.loadCallRequestOptions()
            _ = PlistLoader.loadSoundboardCategories()
        }
    }
    
    // MARK: - Memory Tests (Critical for Long-Running Healthcare Apps)
    
    func testMemoryLeakPrevention() throws {
        // Test for memory leaks in core components
        weak var weakAppState: AppState?
        
        autoreleasepool {
            let testAppState = AppState()
            weakAppState = testAppState
            testAppState.showToast("Memory test")
            testAppState.selectedLanguage = .spanish
        }
        
        XCTAssertNil(weakAppState, "AppState should be deallocated properly")
    }
    
    // MARK: - Integration Tests (Critical for Healthcare Workflow)
    
    func testCompleteWorkflow() throws {
        // Test a complete user workflow
        
        // 1. Change language
        appState.selectedLanguage = .spanish
        XCTAssertEqual(appState.selectedLanguage, .spanish)
        
        // 2. Show success message
        appState.showToast("Call sent successfully")
        XCTAssertEqual(appState.toastMessage, "Call sent successfully")
        XCTAssertFalse(appState.toastIsError)
        
        // 3. Show error message
        appState.showBluetoothError("Connection failed")
        XCTAssertEqual(appState.toastMessage, "Connection failed")
        XCTAssertTrue(appState.toastIsError)
        
        // 4. Reset to normal state
        appState.selectedLanguage = .english
        XCTAssertEqual(appState.selectedLanguage, .english)
    }

}

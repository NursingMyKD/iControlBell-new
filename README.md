# iControlBell

_Accessible, modular, and secure iOS-based call bell and communication app for clinical environments._

---

## 📖 Project Overview

**iControlBell** is a patient-centered communication and nurse call application developed in Swift for iOS devices (iPad/iPhone). Built with accessibility, security, and clinical integration in mind, the app empowers patients—especially those with mobility or speech limitations—to request assistance using intuitive touch or eye-tracking input.

The app is designed for modular integration with hospital systems (e.g., Rauland Responder 5), customizable workflows, and multilingual communication interfaces. It adheres to Apple’s Human Interface Guidelines for healthcare applications and supports assistive technologies such as Switch Control, Voice Control, and third-party eye-tracking devices.

### Core Features
- Accessible UI with large, clearly labeled buttons
- Eye-tracking and switch control compatibility
- Multilingual soundboard with preset clinical phrases
- Visual system connectivity indicator
- Configurable request routing for staff workflows
- Secure, HIPAA-aligned architecture
- Modular integration with nurse call systems

---

## 🖼 Screenshots

> _Note: Add actual screenshots once available._

- [Insert Screenshot: Main Patient Interface]
- [Insert Screenshot: Eye-Tracking Configuration]
- [Insert Screenshot: Admin Settings Panel]

---

## 🚀 Getting Started

### System Requirements
- **macOS:** Ventura 13.0 or later
- **Xcode:** 15.0 or later
- **iOS Deployment Target:** iOS 15.0+
- **Swift:** 5.9+

### Installation Instructions

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-org/icontrolbell-ios.git
   cd icontrolbell-ios

	2.	Install Dependencies (Swift Package Manager):
Dependencies will auto-resolve via Xcode. Alternatively, run:

xcodebuild -resolvePackageDependencies


	3.	Environment Setup:
	•	Copy .env.example to .env:

cp .env.example .env


	•	Set any API keys or configuration flags (if applicable).

	4.	Open the Project:

open iControlBell.xcodeproj



⸻

🛠 Build & Run Instructions
	1.	Open iControlBell.xcodeproj in Xcode.
	2.	Select a simulator (e.g., iPad Pro 11” or iPhone 14).
	3.	Press ⌘ + R to build and run the app.
	4.	Use the Scheme dropdown to switch between Debug, Release, or Testing environments.

⸻

🧱 Project Structure & Architecture

iControlBell follows a modular MVVM (Model-View-ViewModel) architecture with coordinator pattern for navigation.

iControlBell/
├── App/                  # App lifecycle, entry points
├── Core/                 # Global styles, constants, assets
├── Features/             # Feature modules (CallBell, Soundboard, Settings)
│   ├── View/
│   ├── ViewModel/
│   └── Model/
├── Integration/          # Nurse call and device APIs
├── Services/             # Networking, permissions, localization
├── Resources/            # Localized strings, images, sounds
├── Tests/                # Unit and UI test targets
└── Utilities/            # Reusable helpers and extensions

Major navigation is managed via a central AppCoordinator. UI is developed using a hybrid of SwiftUI and UIKit for compatibility and customization.

⸻

📦 Key Dependencies

Dependency	Purpose
SwiftUI/UIKit	Hybrid UI rendering for modern and legacy views
Combine	Reactive state management and bindings
Speech	System TTS for soundboard playback
SwiftEntryKit	In-app alerts and toast messaging (optional)
Firebase Crashlytics	Crash reporting and diagnostics
SwiftyBeaver	Structured logging during development
Lottie (optional)	Accessibility animations (pending)

All packages are managed via Swift Package Manager (SPM).

⸻

✅ Testing

Test Targets
	•	iControlBellTests: Unit tests for business logic and view models
	•	iControlBellUITests: UI and accessibility tests using XCUITest

Running Tests

In Xcode:
	•	Navigate to the Test Navigator (⌘ + 6)
	•	Click the play icon next to each test suite
	•	Or run all tests via:

xcodebuild test -scheme iControlBell -destination 'platform=iOS Simulator,name=iPhone 14'



Code Coverage

Enable code coverage in scheme settings:
	•	Xcode → Product → Scheme → Test → “Gather coverage data”

Code coverage reports can be integrated with CI and viewed using tools like Slather.

⸻

🔁 Continuous Integration (CI)

iControlBell uses GitHub Actions for automated CI/CD.

CI Workflow Includes:
	•	SwiftLint static analysis
	•	Dependency resolution check
	•	Unit & UI test execution on simulators
	•	Optional: Build artifact upload to TestFlight via Fastlane

See .github/workflows/ci.yml for configuration.

Bitrise/Jenkins pipelines can be adapted using fastlane/Fastfile.

⸻

🤝 Contributing

We welcome contributions from internal and open-source collaborators.

🧩 How to Contribute
	1.	Fork this repository
	2.	Create a new branch (feature/your-feature-name)
	3.	Commit your changes with descriptive messages
	4.	Push your branch and open a Pull Request (PR)
	5.	Follow the PR checklist template

🔧 Coding Standards
	•	Follow Swift API Design Guidelines
	•	Use 2-space indentation
	•	Use PascalCase for types, camelCase for variables/functions
	•	Prefer Combine or async/await for async code

🐛 Reporting Issues

Submit bug reports via GitHub Issues. Include device, OS version, and reproduction steps.

⸻

For technical inquiries or system integration questions, please contact support@icontrolbell.com.

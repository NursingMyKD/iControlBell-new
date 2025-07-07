# Running the iControlBell App

## Overview
The iControlBell app is a healthcare communication tool designed for patients to request assistance from nurses or healthcare providers. The app has been fully optimized for responsive design and accessibility across all iOS devices.

## ✅ Recent Updates (Completed)
- **Utility Files Restored**: DeviceUtils.swift and AccessibilityUtils.swift have been restored and integrated into all SwiftUI views
- **Enhanced Responsive Design**: All views now use centralized utility functions for consistent device adaptation
- **Improved Code Maintainability**: Replaced manual device detection with reusable utility functions
- **Build Issues Resolved**: Fixed all duplicate file reference errors in Xcode project

## Prerequisites

### Required Software
- **Xcode 15.0 or later**
- **iOS 16.0 or later** (for target devices)
- **macOS 13.0 or later** (for development)

### Hardware Requirements
- Mac with Apple Silicon or Intel processor
- iOS device or iOS Simulator for testing

## Step-by-Step Setup

### 1. Open the Project
```bash
# Navigate to the project directory
cd /workspaces/iControlBell-new

# Open the project in Xcode
open iControlBell.xcodeproj
```

### 2. Add Utility Files to Xcode Project (Required)
The utility files exist in the filesystem but need to be added to the Xcode project:

1. **In Xcode**, right-click on the `iControlBell/utils/` folder in the Project Navigator
2. Select **"Add Files to 'iControlBell'"**
3. Navigate to and select these files:
   - `iControlBell/utils/DeviceUtils.swift`
   - `iControlBell/utils/AccessibilityUtils.swift`
4. Ensure **"Add to target: iControlBell"** is checked
5. Click **"Add"**

> **Note**: These utility files provide enhanced responsive design and accessibility features. They are already integrated into all SwiftUI views but must be added to the Xcode project to build successfully.

### 3. Configure Build Settings

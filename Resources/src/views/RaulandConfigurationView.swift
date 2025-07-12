//
//  RaulandConfigurationView.swift
// Ensure this file is included in the main app target
//  iControlBell - Rauland Responder 5 Configuration View
//
//  Created by GitHub Copilot on 12/25/24.
//

import SwiftUI


/// Configuration view for setting up Rauland Responder 5 connection
struct RaulandConfigurationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // Configuration state
    @State private var baseURL: String = "https://placeholder.rauland.demo"
    @State private var apiKey: String = "demo-api-key"
    @State private var deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    @State private var facilityID: String = "Demo-Healthcare-Facility"
    @State private var roomNumber: String = "Room-Demo"
    @State private var isShowingHelp: Bool = false
    @State private var isPlaceholderMode: Bool = true
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact || DeviceUtils.screenSize == .iPhoneSmall
    }
    
    private var isIPad: Bool {
        DeviceUtils.isIPad
    }
    
    private var isConfigurationValid: Bool {
        !facilityID.isEmpty && !deviceID.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                headerSection
                
                connectionSection
                
                facilitySection
                
                deviceSection
                
                if isConfigurationValid {
                    testSection
                }
                
                helpSection
            }
            .navigationTitle("rauland_configuration_title".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save".localized) {
                        saveConfiguration()
                    }
                    .disabled(!isConfigurationValid)
                    .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - View Sections
    
    @ViewBuilder
    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "network")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("rauland_configuration_header".localized)
                            .font(.headline)
                            .font(.system(size: 15, weight: .semibold))
                        
                        Text("rauland_configuration_description".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Placeholder mode indicator
                if isPlaceholderMode {
                    HStack {
                        Image(systemName: "testtube.2")
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("rauland_placeholder_mode".localized)
                                .font(.caption)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.orange)
                            
                            Text("rauland_placeholder_description".localized)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .background(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                if !appState.isRaulandConfigured {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        
                        Text("rauland_configuration_required".localized)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private var connectionSection: some View {
        Section("rauland_connection_settings".localized) {
            VStack(alignment: .leading, spacing: 8) {
                Text("rauland_base_url".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("rauland_base_url_placeholder".localized, text: $baseURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.URL)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("rauland_api_key".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingHelp = true
                    }) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                    }
                }
                
                SecureField("rauland_api_key_placeholder".localized, text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .headerProminence(.increased)
    }
    
    @ViewBuilder
    private var facilitySection: some View {
        Section("rauland_facility_settings".localized) {
            VStack(alignment: .leading, spacing: 8) {
                Text("rauland_facility_id".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("rauland_facility_id_placeholder".localized, text: $facilityID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("rauland_room_number".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("rauland_room_number_placeholder".localized, text: $roomNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .headerProminence(.increased)
    }
    
    @ViewBuilder
    private var deviceSection: some View {
        Section("rauland_device_settings".localized) {
            VStack(alignment: .leading, spacing: 8) {
                Text("rauland_device_id".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("rauland_device_id_placeholder".localized, text: $deviceID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Text("rauland_device_id_note".localized)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .headerProminence(.increased)
    }
    
    @ViewBuilder
    private var testSection: some View {
        Section {
            Button(action: {
                testConfiguration()
            }) {
                HStack {
                    Image(systemName: "network.badge.shield.half.filled")
                        .foregroundColor(.blue)
                    
                    Text("rauland_test_connection".localized)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .accessibilityLabel("rauland_test_connection_accessibility".localized)
        }
    }
    
    @ViewBuilder
    private var helpSection: some View {
        Section {
            Button(action: {
                isShowingHelp = true
            }) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.blue)
                    
                    Text("rauland_configuration_help".localized)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        }
        .sheet(isPresented: $isShowingHelp) {
            RaulandConfigurationHelpView()
        }
    }
    
    // MARK: - Actions
    
    private func saveConfiguration() {
        appState.configureRauland(
            baseURL: baseURL,
            apiKey: apiKey,
            deviceID: deviceID,
            facilityID: facilityID,
            roomNumber: roomNumber.isEmpty ? nil : roomNumber
        )
        
        HapticUtils.notification(.success)
        dismiss()
    }
    
    private func testConfiguration() {
        appState.configureRauland(
            baseURL: baseURL,
            apiKey: apiKey,
            deviceID: deviceID,
            facilityID: facilityID,
            roomNumber: roomNumber.isEmpty ? nil : roomNumber
        )
        
        Task {
            HapticUtils.impact(.medium)
            let result = await appState.raulandManager.connect()
            
            switch result {
            case .success:
                appState.showToast("rauland_test_successful".localized)
                HapticUtils.notification(.success)
            case .failure(let error):
                appState.showToast("\("rauland_test_failed".localized): \(error.localizedDescription)", isError: true)
                HapticUtils.notification(.error)
            }
        }
    }
}

// MARK: - Help View

struct RaulandConfigurationHelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    helpSection(
                        title: "rauland_help_api_key".localized,
                        content: "rauland_help_api_key_content".localized,
                        icon: "key.fill"
                    )
                    
                    helpSection(
                        title: "rauland_help_facility_id".localized,
                        content: "rauland_help_facility_id_content".localized,
                        icon: "building.2.fill"
                    )
                    
                    helpSection(
                        title: "rauland_help_device_id".localized,
                        content: "rauland_help_device_id_content".localized,
                        icon: "ipad"
                    )
                    
                    helpSection(
                        title: "rauland_help_room_number".localized,
                        content: "rauland_help_room_number_content".localized,
                        icon: "door.left.hand.open"
                    )
                    
                    helpSection(
                        title: "rauland_help_support".localized,
                        content: "rauland_help_support_content".localized,
                        icon: "person.fill.questionmark"
                    )
                }
                .padding()
            }
            .navigationTitle("rauland_configuration_help".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func helpSection(title: String, content: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .background(Color.adaptiveCardBackground)
        )
    }
}

#Preview {
    let mockManager = RaulandAPIManager(networkService: MockNetworkService())
    RaulandConfigurationView()
        .environmentObject(AppState(raulandManager: mockManager))
}

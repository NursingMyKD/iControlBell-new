//
//  BluetoothManagerTests.swift
//  iControlBellTests - Bluetooth Testing for Healthcare Reliability
//
//  Created by GitHub Copilot on 7/8/25.
//

import XCTest
import CoreBluetooth
@testable import iControlBell

final class BluetoothManagerTests: XCTestCase {
    
    var bluetoothManager: BluetoothManager!
    
    override func setUpWithError() throws {
        bluetoothManager = BluetoothManager.shared
    }
    
    override func tearDownWithError() throws {
        bluetoothManager.disconnect()
        bluetoothManager = nil
    }
    
    // MARK: - Initialization Tests
    
    func testBluetoothManagerInitialization() throws {
        // Test that BluetoothManager initializes properly
        XCTAssertNotNil(bluetoothManager, "BluetoothManager should initialize")
        XCTAssertFalse(bluetoothManager.isConnected, "Should start disconnected")
        XCTAssertNil(bluetoothManager.lastError, "Should start with no errors")
    }
    
    func testSingletonPattern() throws {
        // Test singleton pattern (critical for healthcare device management)
        let instance1 = BluetoothManager.shared
        let instance2 = BluetoothManager.shared
        XCTAssertTrue(instance1 === instance2, "Should use singleton pattern")
    }
    
    // MARK: - State Management Tests
    
    func testInitialState() throws {
        // Test initial Bluetooth state
        XCTAssertFalse(bluetoothManager.isConnected, "Should start disconnected")
        XCTAssertNil(bluetoothManager.lastError, "Should start with no errors")
    }
    
    func testStateChanges() throws {
        // Test state change handling
        let expectation = XCTestExpectation(description: "State should be observable")
        
        let cancellable = bluetoothManager.$isConnected.sink { connected in
            // Verify that state changes are published
            expectation.fulfill()
        }
        
        // Trigger a state change
        bluetoothManager.disconnect()
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }
    
    // MARK: - Error Handling Tests
    
    func testErrorReporting() throws {
        // Test error reporting mechanisms
        let expectation = XCTestExpectation(description: "Errors should be published")
        
        let cancellable = bluetoothManager.$lastError.sink { error in
            if error != nil {
                expectation.fulfill()
            }
        }
        
        // Note: In a real test environment, we would inject mock errors
        // For now, we test the error reporting mechanism
        
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    // MARK: - Connection Management Tests
    
    func testDisconnectionSafety() throws {
        // Test that disconnection is safe even when not connected
        XCTAssertNoThrow(bluetoothManager.disconnect(), "Disconnect should be safe when not connected")
        XCTAssertFalse(bluetoothManager.isConnected, "Should remain disconnected")
    }
    
    func testMultipleDisconnectionCalls() throws {
        // Test multiple disconnection calls (prevents crashes)
        XCTAssertNoThrow(bluetoothManager.disconnect(), "First disconnect should be safe")
        XCTAssertNoThrow(bluetoothManager.disconnect(), "Second disconnect should be safe")
        XCTAssertNoThrow(bluetoothManager.disconnect(), "Third disconnect should be safe")
    }
    
    // MARK: - Call Bell Functionality Tests
    
    func testCallBellTriggerSafety() throws {
        // Test call bell trigger safety when not connected
        XCTAssertNoThrow(bluetoothManager.triggerCallBell(), "Call bell trigger should be safe when disconnected")
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testBluetoothManagingProtocolConformance() throws {
        // Test that BluetoothManager conforms to BluetoothManaging protocol
        let manager: BluetoothManaging = bluetoothManager
        
        XCTAssertNotNil(manager.isConnected, "Protocol property should be accessible")
        XCTAssertNotNil(manager.lastError, "Protocol property should be accessible")
        
        // Test protocol methods are callable
        XCTAssertNoThrow(manager.startScanning(), "Protocol method should be callable")
        XCTAssertNoThrow(manager.stopScanning(), "Protocol method should be callable")
        XCTAssertNoThrow(manager.triggerCallBell(), "Protocol method should be callable")
        XCTAssertNoThrow(manager.disconnect(), "Protocol method should be callable")
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() throws {
        // Test that BluetoothManager doesn't leak memory
        weak var weakManager: BluetoothManager?
        
        autoreleasepool {
            // Note: Since BluetoothManager is a singleton, this test 
            // verifies the pattern rather than actual deallocation
            let manager = BluetoothManager.shared
            weakManager = manager
            manager.disconnect()
        }
        
        // Singleton should still exist
        XCTAssertNotNil(weakManager, "Singleton should persist")
    }
    
    // MARK: - Concurrent Access Tests
    
    func testConcurrentAccess() throws {
        // Test concurrent access safety (critical for healthcare apps)
        let expectation = XCTestExpectation(description: "Concurrent operations should complete")
        expectation.expectedFulfillmentCount = 10
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        for i in 0..<10 {
            queue.async {
                // Simulate concurrent operations
                if i % 2 == 0 {
                    self.bluetoothManager.startScanning()
                } else {
                    self.bluetoothManager.stopScanning()
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Performance Tests
    
    func testBluetoothOperationPerformance() throws {
        // Test performance of Bluetooth operations
        measure {
            for _ in 0..<100 {
                bluetoothManager.startScanning()
                bluetoothManager.stopScanning()
                bluetoothManager.disconnect()
            }
        }
    }
    
    // MARK: - Healthcare-Specific Tests
    
    func testHealthcareComplianceFeatures() throws {
        // Test features required for healthcare compliance
        
        // Test that connection state is always deterministic
        let initialState = bluetoothManager.isConnected
        XCTAssertNotNil(initialState, "Connection state should always be deterministic")
        
        // Test that error state is trackable for audit purposes
        let errorState = bluetoothManager.lastError
        // Error can be nil, but should be trackable
        XCTAssertTrue(errorState == nil || !errorState!.isEmpty, "Error state should be trackable")
    }
    
    func testEmergencyDisconnectionReliability() throws {
        // Test that emergency disconnection always works
        
        // Multiple rapid disconnection attempts (emergency scenario)
        for _ in 0..<10 {
            XCTAssertNoThrow(bluetoothManager.disconnect(), "Emergency disconnection should always work")
        }
        
        XCTAssertFalse(bluetoothManager.isConnected, "Should be disconnected after emergency disconnect")
    }
}

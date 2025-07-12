// BluetoothManager.swift
// Handles Bluetooth Low Energy (BLE) connectivity for hospital call bell integration
// Healthcare compliant: secure, local-only, modular

import Foundation
import CoreBluetooth

/// Protocol for Bluetooth management, for testability and abstraction.
protocol BluetoothManaging: AnyObject {
    var isConnected: Bool { get }
    var lastError: String? { get }
    func startScanning()
    func stopScanning()
    func triggerCallBell()
    func disconnect()
}

/// Manages Bluetooth LE connectivity for hospital call bell integration.
@MainActor
class BluetoothManager: NSObject, ObservableObject, BluetoothManaging {
    static let shared = BluetoothManager()
    private var centralManager: CBCentralManager!
    private var discoveredPeripheral: CBPeripheral?
    private var callBellCharacteristic: CBCharacteristic?
    
    @Published var isConnected: Bool = false
    @Published var lastError: String?
    
    // UUIDs should be set to match the hospital's call bell BLE service/characteristic
    private let callBellServiceUUID = CBUUID(string: "0000FFF0-0000-1000-8000-00805F9B34FB")
    private let callBellCharacteristicUUID = CBUUID(string: "0000FFF1-0000-1000-8000-00805F9B34FB")
    
    override private init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(withServices: [callBellServiceUUID], options: nil)
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func triggerCallBell() {
        guard let peripheral = discoveredPeripheral, let characteristic = callBellCharacteristic else { return }
        let data = Data([0x01]) // Example: 0x01 triggers the call bell
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    /// Disconnects from the current peripheral if connected.
    func disconnect() {
        if let peripheral = discoveredPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
            discoveredPeripheral = nil
            callBellCharacteristic = nil
            isConnected = false
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredPeripheral = peripheral
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
        stopScanning()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        peripheral.discoverServices([callBellServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        lastError = error?.localizedDescription
        isConnected = false
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == callBellServiceUUID {
            peripheral.discoverCharacteristics([callBellCharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.uuid == callBellCharacteristicUUID {
            callBellCharacteristic = characteristic
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            lastError = error.localizedDescription
        }
    }
}

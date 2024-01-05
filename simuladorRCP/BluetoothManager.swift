import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var timer: Timer?
    var receivedData: Data?
    @Published var isConnected = false
    @Published var devices = [CBPeripheral]()
    @Published var pressureData: [PressureData] = []
    @Published var frequencyData: [FrequencyData] = []
    override init() {
        pressureData = [PressureData(time:Date(),value:0)]
        frequencyData = [FrequencyData(time:Date(),value:0)]
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !devices.contains(where: { $0.identifier == peripheral.identifier }) {
            devices.append(peripheral)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string:"4FAFC201-1FB5-459E-8FCC-C5C9C331914B")])
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == CBUUID(string: "4FAFC201-1FB5-459E-8FCC-C5C9C331914B") {
                    peripheral.discoverCharacteristics([CBUUID(string: "BEB5483E-36E1-4688-B7F5-EA07361B26A8")], for: service)
                }
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == CBUUID(string: "BEB5483E-36E1-4688-B7F5-EA07361B26A8") {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == CBUUID(string: "BEB5483E-36E1-4688-B7F5-EA07361B26A8") {
            if let data = characteristic.value, let string = String(data: data, encoding: .utf8) {
                print(string)
                let index = string.index(string.startIndex, offsetBy: 1)
                let numberString = String(string[index...])
                if let number = Double(numberString) {
                    if string.hasPrefix("P") {
                        let dataPoint = PressureData(time: Date(), value: number / 10) // Aquí se divide el valor por 10
                        if(pressureData.count >= 200) {
                            pressureData.removeFirst()
                        }
                        pressureData.append(dataPoint)
                        //print("largo press \(pressureData.count)")
                    } else if string.hasPrefix("B") {
                        let dataPoint = FrequencyData(time: Date(), value: number)
                        if(frequencyData.count >= 200) {
                            frequencyData.removeFirst()
                        }
                        frequencyData.append(dataPoint)
                        //print("largo freq \(frequencyData.count)")
                    }
                }
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is On")
        case .poweredOff:
            print("Bluetooth is Off")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unknown:
            print("Bluetooth is Unknown")
        case .unsupported:
            print("Bluetooth is Unsupported")
        @unknown default:
            print("Unknown state")
        }
    }
    func startScanning() {
        devices = []
        centralManager.scanForPeripherals(withServices: [CBUUID(string:"4FAFC201-1FB5-459E-8FCC-C5C9C331914B")],options: nil)
    }
    func connectToDevice(_ device: CBPeripheral) {
        centralManager.connect(device, options: nil)
        isConnected = true
    }
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
        isConnected = false
    }
}
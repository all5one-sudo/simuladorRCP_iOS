import SwiftUI
import CoreBluetooth
import Charts

struct ContentView: View {
    var body: some View {
            TabView {
                InicioView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Inicio")
                    }
                EntrenamientoView()
                    .tabItem {
                        Image(systemName: "sportscourt.fill")
                        Text("Entrenamiento")
                    }
                EvaluacionView()
                    .tabItem {
                        Image(systemName: "doc.text.fill")
                        Text("Evaluación")
                    }
                AcercaDeView()
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("Acerca de")
                    }
        }
    }
}

struct InicioView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    //@State private var selectedDevice: String = ""
    //@State private var devices = ["Device 1","Device 2","Device 3"]
    //@ObservedObject private var btManager = BluetoothManager()
    @EnvironmentObject var btManager: BluetoothManager
    @State private var selectedDevice: CBPeripheral?
    var body: some View {
        VStack {
            Text("Simulador de RCP Neonatal")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            Text("Para comenzar con las pruebas, primero es necesario conectar un simulador. Para ello, luego de pulsar \"Escanear\", aparecerán los dispositivos disponibles para la conexión. Una vez conectado se puede pasar al modo de evaluación o de entrenamiento.")
            .padding()
            HStack {
                Picker(selection: $selectedDevice, label: Text("Dispositivos vinculados")) {
                    ForEach(btManager.devices, id: \.identifier) { device in
                        Text(device.name ?? "Dispositivo desconocido").tag(device as CBPeripheral?)
                    }
                }
                Button(action: {
                    btManager.startScanning()
                }) {
                    Text("Escanear")
                }
            }
            .padding()
            HStack {
                Button(action: {
                    if let device = selectedDevice {
                        btManager.connectToDevice(device)
                    }
                }) {
                    Text("Conectar")
                }
                .disabled(selectedDevice == nil || btManager.isConnected)
                .padding()
                Button(action: {
                    if let device = selectedDevice {
                        btManager.disconnect(peripheral: device)
                    }
                }) {
                    Text("Desconectar")
                }
                .disabled(!btManager.isConnected)
                .padding()
            }
            Toggle(isOn: $isDarkMode) {
                Text("Modo oscuro")
            }
            .padding()
        }
    }
}
struct EntrenamientoView: View {
    @EnvironmentObject var btManager: BluetoothManager
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var lastPressureData: [PressureData] = [PressureData(time: Date(), value: 6.2)]
    @State var lastFrequencyData: [FrequencyData] = [FrequencyData(time: Date(), value: 120)]
    var body: some View {
        VStack {
            Text("Modo de entrenamiento")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding()
            Chart {
                ForEach(lastPressureData) { pressureData in
                    LineMark(
                        x: PlottableValue.value("Tiempo",pressureData.time),
                        y: PlottableValue.value("Presion [cm]",pressureData.value)
                    )    
                    .foregroundStyle(Color.red)
                    .interpolationMethod(.monotone)
                }
                
            }
            .chartYAxisLabel("Presión [cm]")
            .padding()
            Chart {
                ForEach(lastFrequencyData) { frequencyData in
                    LineMark(
                        x: PlottableValue.value("Tiempo",frequencyData.time),
                        y: PlottableValue.value("Frecuencia [bpm]",frequencyData.value)
                    )    
                    .foregroundStyle(Color.red)
                    .interpolationMethod(.monotone)
                }
                
            }
            .chartYAxisLabel("Frecuencia [bpm]")
        }
        .onReceive(timer) { _ in
            self.lastPressureData = self.btManager.pressureData
            self.lastFrequencyData = self.btManager.frequencyData
            //print("largo press \(lastPressureData.count)")
        }
    }
}
struct EvaluacionView: View {
    var body: some View {
        Text("Página de evaluación")
    }
}
struct AcercaDeView: View {
    var body: some View {
        Text("Acerca del proyecto")
    }
}


#Preview {
    ContentView()
}

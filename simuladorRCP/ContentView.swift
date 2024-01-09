import SwiftUI
import CoreBluetooth
import Charts
import PDFKit

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
                /*AcercaDeView()
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("Acerca de")
                    }*/
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
    @State var lastPressureData: [PressureData] = [PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),
    PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2),PressureData(time: Date(), value: 6.2)]
    @State var lastFrequencyData: [FrequencyData] = [FrequencyData(time: Date(), value: 120)]
    var body: some View {
        VStack {
            Text("Modo de entrenamiento")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding()
            GroupBox("Compresiones en el pecho") {
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
                .chartXAxis(.hidden)
            }
            .padding()
            GroupBox("Frecuencia de compresiones") {
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
                .chartXAxis(.hidden)
            }
            .padding()
        }
        .onReceive(timer) { _ in
            self.lastPressureData = self.btManager.pressureData
            self.lastFrequencyData = self.btManager.frequencyData
            //print("largo press \(lastPressureData.count)")
        }
    }
}
struct EvaluacionView: View {
    @EnvironmentObject var btManager: BluetoothManager
    @State private var isStarted = false
    @State private var ended = false
    @State private var lastPressure: PressureData? = nil
    @State private var lastFrequency: FrequencyData? = nil
    @State private var timer: Timer? = nil
    @State private var insuf = 0
    @State private var optim = 0
    @State private var exces = 0
    @State private var rightF = 0
    @State private var wrongF = 0
    @State private var pressureInfo: [PressureChart] = []
    @State private var frequencyInfo: [FrequencyChart] = []
    var body: some View {
        VStack {
            Text("Modo de evaluación")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding()
            if !ended {
                Button(action: {
                    //self.isStarted.toggle()
                    //self.optim = 0
                    //self.insuf = 0
                    //self.exces = 0
                    //self.wrongF = 0
                    //self.rightF = 0
                    self.lastPressure = self.btManager.pressureData.last
                    self.lastFrequency = self.btManager.frequencyData.last
                    self.isStarted.toggle()
                    let pressData = self.btManager.pressureData.last
                    let freqData = self.btManager.frequencyData.last
                    if self.isStarted && !self.ended{
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                            self.lastPressure = pressData
                            self.lastFrequency = freqData
                            let pressData = self.btManager.pressureData.last
                            let freqData = self.btManager.frequencyData.last
                            if let lastPressure = self.lastPressure, let pressData = pressData {
                                if pressData.value <= 8.0 && pressData.value > 6.38 && pressData.value < lastPressure.value {
                                    self.insuf = self.insuf + 1
                                    print("Insuficiente: \(self.insuf)")
                                }
                                else if pressData.value > 5.42 && pressData.value <= 6.38 && pressData.value < lastPressure.value {
                                    self.optim = self.optim + 1
                                    print("Optima: \(self.optim)")
                                }
                                else if pressData.value <= 5.42 && pressData.value < lastPressure.value {
                                    self.exces = self.exces + 1
                                    print("Excesiva: \(self.exces)")
                                }
                            }
                            if let freqData = freqData {
                                if freqData.value > 100 && freqData.value <= 120 {
                                    self.rightF = self.rightF + 1
                                }
                                else {
                                    self.wrongF = self.wrongF + 1
                                }
                            }
                        }
                    }
                    else {
                        self.ended = true
                        self.isStarted = false
                        print("optimas: \(self.optim)")
                        print("insuficientes: \(self.insuf)")
                        print("excesivas: \(self.exces)")
                        self.pressureInfo.append(PressureChart(title: "Insuficientes", value: Double(self.insuf) / Double(self.insuf+self.exces+self.optim)))
                        self.pressureInfo.append(PressureChart(title: "Óptimas", value: Double(self.optim) / Double(self.insuf+self.exces+self.optim)))
                        self.pressureInfo.append(PressureChart(title: "Excesivas", value: Double(self.exces) / Double(self.insuf+self.exces+self.optim)))
                        print(pressureInfo)
                        self.frequencyInfo.append(FrequencyChart(title: "Óptimas", value: Double(self.rightF)/(Double(self.rightF)+Double(self.wrongF))))
                        self.frequencyInfo.append(FrequencyChart(title: "Erroneas", value: Double(self.wrongF)/(Double(self.rightF)+Double(self.wrongF))))
                        
                    }
                }) {
                    Text(isStarted ? "Finalizar" : "Iniciar")
                }
            }
            if ended {
                HStack {
                    GroupBox("Performance en compresiones") {
                        Chart(pressureInfo) { pressure in 
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: pressure.title),
                                    pressure.value
                                )
                            )    
                            .foregroundStyle(by: .value("category", pressure.title))
                        }
                    }
                    Spacer()
                    GroupBox("Performance en frecuencia") {
                        Chart(frequencyInfo) { frequency in 
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: frequency.title),
                                    frequency.value
                                )
                            )    
                            .foregroundStyle(by:
                                    .value("category", frequency.title)
                            )
                        }
                    }
                }
                if ended {
                    Button(action: {
                        self.ended = false
                        self.isStarted = false
                        self.optim = 0
                        self.insuf = 0
                        self.exces = 0
                        self.wrongF = 0
                        self.rightF = 0
                        self.pressureInfo.removeAll()
                        self.frequencyInfo.removeAll()
                        self.isStarted = false
                    }) {
                        Text("Reiniciar")
                    }
                }
            }
        }
        
    }
}
struct AcercaDeView: View {
    var body: some View {
        Text("Acerca del proyecto")
    }
}
struct PressureChart: Identifiable {
    let id = UUID()
    let title: String
    let value: Double
}
struct FrequencyChart: Identifiable {
    let id = UUID()
    let title: String
    let value: Double
}

#Preview {
    ContentView()
}

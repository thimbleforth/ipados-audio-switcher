import SwiftUI
import AVFoundation
import AVKit

class AudioRouteManager: ObservableObject {
    @Published var isActive = false
    @Published var currentRouteDescription = "Unknown"
    
    private let session = AVAudioSession.sharedInstance()
    
    init() {
        updateRouteDescription()
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.updateRouteDescription()
        }
    }
    
    func activateSession() {
        do {
            try session.setCategory(.playAndRecord,
                                    options: [.allowBluetooth,
                                              .allowBluetoothA2DP,
                                              .defaultToSpeaker])
            try session.setActive(true)
            isActive = true
            updateRouteDescription()
        } catch {
            currentRouteDescription = "Error activating session: \(error.localizedDescription)"
        }
    }
    
    func deactivateSession() {
        do {
            try session.setActive(false)
            isActive = false
            updateRouteDescription()
        } catch {
            currentRouteDescription = "Error deactivating session: \(error.localizedDescription)"
        }
    }
    
    func updateRouteDescription() {
        let route = session.currentRoute
        let outputs = route.outputs.map { $0.portName }.joined(separator: ", ")
        currentRouteDescription = outputs.isEmpty ? "No output detected" : outputs
    }
}

struct ContentView: View {
    @StateObject private var audioManager = AudioRouteManager()
    
    var body: some View {
        VStack(spacing: 24) {
            
            Toggle("Enable Audio Override", isOn: $audioManager.isActive)
                .onChange(of: audioManager.isActive) { oldValue, newValue in
                    if newValue {
                        audioManager.activateSession()
                    } else {
                        audioManager.deactivateSession()
                    }
                }
                .padding()
            
            Text("Current Output: \(audioManager.currentRouteDescription)")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            AVRoutePickerViewRepresentable()
                .frame(width: 200, height: 50)
            
            Button("Close App") {
                exit(0)
            }
            .foregroundColor(.red)
            .padding(.top, 40)
        }
        .padding()
    }
}

struct AVRoutePickerViewRepresentable: UIViewRepresentable {
    typealias UIViewType = AVRoutePickerView

    func makeUIView(context: Context) -> AVRoutePickerView {
        let view = AVRoutePickerView()
        view.activeTintColor = .systemBlue
        view.tintColor = .gray
        return view
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}

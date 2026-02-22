import SwiftUI
import AVFoundation
import AVKit

class AudioRouteManager: ObservableObject {
    @Published var isActive = false
    @Published var currentRouteDescription = "Unknown"
    
    private let session = AVAudioSession.sharedInstance()
    private var routeChangeObserver: Any?
    
    init() {
        configureCategory()
        updateRouteDescription()
        routeChangeObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateRouteDescription()
        }
    }
    
    deinit {
        if let observer = routeChangeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func configureCategory() {
        do {
            try session.setCategory(.playAndRecord,
                                    mode: .default,
                                    options: [.allowBluetooth,
                                              .allowBluetoothA2DP,
                                              .defaultToSpeaker])
        } catch {
            isActive = false
            currentRouteDescription = "Setup error: \(error.localizedDescription)"
        }
    }
    
    func activateSession() {
        do {
            try session.setActive(true)
            isActive = true
            updateRouteDescription()
        } catch {
            isActive = false
            currentRouteDescription = "Error activating session: \(error.localizedDescription)"
        }
    }
    
    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
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
            
            Toggle("Enable Audio Override", isOn: Binding(
                get: { audioManager.isActive },
                set: { newValue in
                    if newValue {
                        audioManager.activateSession()
                    } else {
                        audioManager.deactivateSession()
                    }
                }
            ))
            .padding()
            
            Text("Current Output: \(audioManager.currentRouteDescription)")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            AVRoutePickerViewRepresentable()
                .frame(width: 200, height: 50)
            
            Button("Close App") {
                audioManager.deactivateSession()
                exit(0)
            }
            .foregroundColor(.red)
            .padding(.top, 40)
        }
        .padding()
        .onAppear {
            audioManager.activateSession()
        }
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

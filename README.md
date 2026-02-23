# ipados-audio-switcher
A small piece of Swift code you can run in Playgrounds to dynamically change audio to whatever output, whenever you want.

<img width="1095" height="756" alt="image" src="https://github.com/user-attachments/assets/bdc514f0-1ea0-4f9d-a8ea-96c6c4f0bb4c" />

## Using this in Swift Playgrounds

The following steps assume you are on an iPad running iPadOS 16 or later with the [Swift Playgrounds](https://apps.apple.com/app/swift-playgrounds/id908519492) app installed.

### 1. Create a new App Playground

1. Open **Swift Playgrounds**.
2. Tap the **+** button to create a new playground.
3. Select **App** (not *Blank*) so that the project includes a proper app entry point.
4. Give the project a name (e.g. *Audio Switcher*) and tap **Create**.

### 2. Replace the default source files

Swift Playgrounds creates a starter `ContentView.swift` and `MyApp.swift` for you. Replace their contents with the files from this repository:

1. In the playground, tap the **files sidebar** icon (top-left of the editor) to open the file list.
2. Tap `ContentView.swift`, select all of the existing code, and paste in the full contents of [`ContentView.swift`](ContentView.swift) from this repo.
3. Tap `MyApp.swift`, select all of the existing code, and paste in the full contents of [`MyApp.swift`](MyApp.swift) from this repo.
4. Be sure to Save both files

> **Tip:** If the sidebar isn't visible, tap the Sidebar button **** (top-left).

### 3. Run the app

Tap the **Run** button (▶) in the top toolbar. Swift Playgrounds will build the project and launch it in the canvas.

Alternately, click the Preview button on the right. See screenshot:

<img width="755" height="107" alt="image" src="https://github.com/user-attachments/assets/9ac9f720-f4ff-4c07-bad1-51aef473273b" />

The app shows:
- A **toggle** to enable or disable the audio session override.
- A label showing the **current audio output** (e.g. *Built-in Speaker*, *AirPods Pro*).
- An **AirPlay / route picker button** that opens the system audio output chooser so you can switch to any available output on the fly.

The session is activated automatically when the app appears, so you can start switching outputs right away.

### Requirements

| Requirement | Minimum version |
|---|---|
| Swift Playgrounds | 4.0 |
| iPadOS | 16.0 |

# Creole Companion

**Creole Companion** is a cross-platform Flutter application designed to bridge the language gap between English and Haitian Creole. It features real-time voice and text translation, speech-to-text capabilities, and an immersive audio experience with ambient background music.

## 🚀 Features

* **Two-Way Translation:** Translate text instantly between English and Haitian Creole.
* **Voice Integration:**
    * **Speech-to-Text:** Speak into the microphone to input text (English or Creole).
    * **Text-to-Speech:** Listen to translations (via device accessibility or API).
* **Immersive Audio:** Gentle background ambience ("Le Mal du Pays") to set the mood.
    * **Music Toggle:** Easily turn the background music on or off from the Welcome Screen.
* **Cross-Platform:** optimized for macOS (Desktop), iOS, and Android.

## 🛠 Prerequisites

Before you begin, ensure you have the following installed:

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.9.2 or higher)
* [CocoaPods](https://cocoapods.org/) (For managing iOS/macOS dependencies)
* **Xcode** (Required for macOS/iOS development)
* **Android Studio** (For Android development)

## 📥 Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/creole_companion.git](https://github.com/yourusername/creole_companion.git)
    cd creole_companion
    ```

2.  **Install Dart dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Install Native Dependencies (iOS & macOS):**
    * **macOS:**
        ```bash
        cd macos
        pod install
        cd ..
        ```
    * **iOS:**
        ```bash
        cd ios
        pod install
        cd ..
        ```

## 🔐 Configuration (Important)

### 1. API Keys
For security reasons, the API key file is **ignored** by Git. You must create it manually for translations to work.

1.  Navigate to `lib/services/`.
2.  Create a new file named `api_keys.dart`.
3.  Paste the following code into it (replace with your actual key):

    ```dart
    class ApiKeys {
      static const String googleTranslateApiKey = "YOUR_GOOGLE_CLOUD_API_KEY_HERE";
    }
    ```

### 2. macOS Permissions (Sandbox)
To allow the app to access the Internet (for translation) and the Microphone (for voice input) on macOS, you must verify the entitlements.

**File:** `macos/Runner/DebugProfile.entitlements` (and `Release.entitlements`)

Ensure these keys are present inside the `<dict>` tag:
```xml
<key>com.apple.security.network.client</key>
<true/>
<key>com.apple.security.device.audio-input</key>
<true/>
```

## 🏃‍♂️ Running the App

### macOS Desktop
Run the following command in your terminal:
```bash
flutter run -d macos
```

### iOS Simulator
1. Open the Simulator app.

2. Run:

```Bash
flutter run -d iphonesimulator
```
### Android
Ensure an emulator is running or a device is connected:

```Bash
flutter run -d android
```
### 📂 Project Structure
* `lib/main.dart`: Entry point of the application.
* `lib/screens/`: Contains UI screens (WelcomeScreen, HomeScreen, etc.).
* `lib/services/`: Logic for Audio, Translation API, and Database.
* `assets/`: Images and Audio files.

### 🐛 Troubleshooting
* "OS Error: Operation not permitted" on macOS:
    * This means the App Sandbox is blocking connections. Double-check the Configuration > macOS Permissions section above.
    * Run `flutter clean` and rebuild.

* "Library not loaded" / Xcode errors:
    * Ensure Xcode is fully installed and license agreed: `sudo xcodebuild -license accept`.
    * Run `sudo xcodebuild -runFirstLaunch` to install components.
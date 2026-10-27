# Gudsman FSR Mobile Application (OSS Version)

Gudsman FSR Mobile is a Flutter application for creating and managing field service reports.  
It is designed to support technicians and field operators with structured report capture across mobile, desktop, and web targets.
The application extensively relies on Gudsman Backend Infra for it's operations.
This repo is an early Beta Demo version

## Features

- Cross-platform Flutter app (Android, iOS, Web, Windows, macOS, Linux)
- Field service report workflow
- Asset-backed UI/resources
- Test scaffold included for widget testing

## Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **Targets:** Android, iOS, Web, Windows, macOS, Linux

## Project Structure

```text
Gudsman-reports/
├── lib/                   # Main application source code
├── test/                  # Widget/unit tests
├── assets/                # Static assets used by the app
├── android/               # Android platform project
├── ios/                   # iOS platform project
├── web/                   # Web platform project
├── windows/               # Windows platform project
├── macos/                 # macOS platform project
├── linux/                 # Linux platform project
├── pubspec.yaml           # Flutter project manifest and dependencies
├── pubspec.lock           # Locked dependency versions
└── analysis_options.yaml  # Linting and static analysis configuration
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (included with Flutter)
- Platform tooling depending on target:
  - Android Studio / Xcode
  - Chrome (for web)
  - Desktop toolchains for Windows/macOS/Linux

### Installation

```bash
git clone https://github.com/Bootstrap-Paradox/Gudsman-reports.git
cd Gudsman-reports
flutter pub get
```

### Run the App

```bash
flutter run
```

To run on a specific device/platform:

```bash
flutter devices
flutter run -d <device-id>
```

### Run Tests

```bash
flutter test
```

### Lint / Analyze

```bash
flutter analyze
```

## Build

Examples:

```bash
# Android APK
flutter build apk

# iOS (on macOS with Xcode configured)
flutter build ios

# Web
flutter build web

# Windows/macOS/Linux
flutter build windows
flutter build macos
flutter build linux
```

## Configuration Notes

- Dependencies and assets are declared in `pubspec.yaml`.
- Lint rules are configured in `analysis_options.yaml`.
- Add environment-specific configuration/secrets using your preferred Flutter strategy (e.g., dart-define, flavors, or secure storage).

## Contributing

1. Create a feature branch
2. Make your changes
3. Run:
   - `flutter analyze`
   - `flutter test`
4. Open a pull request

## License

No license file is currently defined in this repository.  
Add a `LICENSE` file if you intend to distribute this project.

# Quick Start Guide - How to Run the App

## Step 1: Navigate to Project Directory

Open your terminal and navigate to the project:

```bash
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
```

## Step 2: Install Dependencies

Install all required Flutter packages:

```bash
flutter pub get
```

This will download all dependencies listed in `pubspec.yaml`.

## Step 3: Check Flutter Setup (Optional)

Verify your Flutter installation is working:

```bash
flutter doctor
```

This will show you if there are any issues with your Flutter setup.

## Step 4: Check Available Devices

See what devices/emulators are available:

```bash
flutter devices
```

You should see:
- Connected physical devices (iPhone, Android phone)
- Available emulators/simulators
- Chrome (for web)

## Step 5: Run the App

### Option A: Run on First Available Device
```bash
flutter run
```

### Option B: Run on Specific Device
```bash
flutter run -d <device-id>
```

### Option C: Run on Web (if you have Chrome)
```bash
flutter run -d chrome
```

### Option D: Run on iOS Simulator (Mac only)
```bash
flutter run -d iPhone
```

### Option E: Run on Android Emulator
```bash
flutter run -d android
```

## Troubleshooting

### If `flutter pub get` fails:
- Make sure you're in the project directory
- Check your internet connection
- Try: `flutter clean` then `flutter pub get`

### If no devices are found:
- For iOS: Open Xcode and start a simulator, or connect an iPhone
- For Android: Start an Android emulator from Android Studio, or connect an Android device
- For Web: Make sure Chrome is installed

### If you get permission errors:
- Make sure Flutter is properly installed: `which flutter`
- Check Flutter path: `echo $PATH`

## Hot Reload

While the app is running:
- Press `r` in the terminal to hot reload (quick refresh)
- Press `R` to hot restart (full restart)
- Press `q` to quit

## Build for Production

### Android APK:
```bash
flutter build apk
```

### iOS (requires Mac and Xcode):
```bash
flutter build ios
```

### Web:
```bash
flutter build web
```

## Need Help?

- Flutter documentation: https://flutter.dev/docs
- Flutter troubleshooting: https://flutter.dev/docs/get-started/install


# 🚀 Momentum Setup Guide

## Project Initialization & Setup Steps

This document guides you through setting up the Momentum Flutter project from scratch to production.

---

## 📋 Checklist

### Phase 1: Local Environment Setup ✅

- [x] Flutter SDK installed (3.0+)
- [x] Dart SDK installed
- [x] Project structure created
- [x] Dependencies added to pubspec.yaml
- [ ] Dependencies downloaded (`flutter pub get`)
- [ ] Firebase project created

### Phase 2: Firebase Configuration ⏳

- [ ] Firebase Console project created
- [ ] Android app registered
- [ ] iOS app registered
- [ ] `google-services.json` downloaded (Android)
- [ ] `GoogleService-Info.plist` downloaded (iOS)
- [ ] Firebase credentials added to `firebase_options.dart`

### Phase 3: Development ⏳

- [ ] Models fully implemented
- [ ] Services integrated with Firebase
- [ ] UI screens completed
- [ ] Navigation setup with GoRouter
- [ ] Authentication logic implemented
- [ ] Task CRUD operations tested

### Phase 4: Testing ⏳

- [ ] Unit tests written
- [ ] Integration tests created
- [ ] Manual testing completed
- [ ] Performance optimized

### Phase 5: Deployment ⏳

- [ ] Android APK/Bundle built
- [ ] iOS IPA built
- [ ] Play Store setup
- [ ] App Store setup
- [ ] Release published

---

## 🛠 Step-by-Step Setup

### 1. Download Dependencies

```bash
cd momentum
flutter pub get
```

### 2. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create Project"
3. Enter project name: `momentum`
4. Accept terms and create

### 3. Register Android App

1. In Firebase Console, click "Add App" → "Android"
2. Enter package name: `com.example.momentum`
3. Download `google-services.json`
4. Place in `android/app/` directory
5. Follow the configuration steps

### 4. Register iOS App

1. Click "Add App" → "iOS"
2. Enter bundle ID: `com.example.momentum`
3. Download `GoogleService-Info.plist`
4. Place in Xcode project

### 5. Update Firebase Options

Edit `lib/firebase_options.dart`:

```dart
class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_ANDROID_MESSAGING_SENDER_ID',
    projectId: 'momentum-xxxxx',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
    projectId: 'momentum-xxxxx',
    iosBundleId: 'com.example.momentum',
  );

  // ... rest of config
}
```

### 6. Run Development Server

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

---

## 📁 File Structure Reference

```
momentum/
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── lib/
│   ├── core/             # Shared utilities
│   │   ├── constants/    # App constants
│   │   ├── theme/        # Theme configuration
│   │   ├── widgets/      # Reusable widgets
│   │   └── services/     # Core services (Firebase)
│   ├── models/           # Data models
│   ├── features/         # Feature modules
│   │   ├── auth/         # Authentication
│   │   ├── dashboard/    # Dashboard
│   │   ├── tasks/        # Task management
│   │   ├── profile/      # User profile
│   │   ├── settings/     # Settings
│   │   ├── notifications/# Notifications
│   │   └── splash/       # Splash screen
│   ├── main.dart         # App entry point
│   ├── app.dart          # App configuration
│   └── firebase_options.dart # Firebase config
├── assets/               # Images, icons
├── pubspec.yaml          # Dependencies
├── README.md             # Project documentation
└── .gitignore            # Git ignore rules
```

---

## 🔐 Firestore Setup

### Create Collections

1. Go to Firebase Console → Firestore Database
2. Create "users" collection
3. Create "tasks" collection
4. Create "notifications" collection

### Set Security Rules

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // Users can only read/write their own tasks
    match /tasks/{taskId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }

    // Users can only read their own notifications
    match /notifications/{notificationId} {
      allow read: if request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## 🔄 Development Workflow

### Feature Development

1. Create feature branch

   ```bash
   git checkout -b feature/task-management
   ```

2. Develop feature
   - Update models if needed
   - Create screens/widgets
   - Implement services
   - Add routes

3. Test locally

   ```bash
   flutter test
   ```

4. Commit and push

   ```bash
   git add .
   git commit -m "feat: add task management"
   git push origin feature/task-management
   ```

5. Create Pull Request

---

## 🧪 Testing

### Unit Tests

```bash
flutter test
```

### Widget Tests

```bash
flutter test test/widget_test.dart
```

### Integration Tests

```bash
flutter test integration_test/
```

---

## 📱 Building for Release

### Android

1. **Update Version**
   - Edit `pubspec.yaml`: `version: 1.0.0+1`

2. **Create Release Build**

   ```bash
   flutter build apk --release
   # Output: build/app/outputs/apk/release/app-release.apk
   ```

3. **Build App Bundle**
   ```bash
   flutter build appbundle --release
   # Output: build/app/outputs/bundle/release/app-release.aab
   ```

### iOS

1. **Update Build Number**
   - Open `ios/Runner.xcworkspace`
   - Update version in Xcode

2. **Create Release Build**
   ```bash
   flutter build ios --release
   ```

---

## 🚀 Deployment to FlutLab

### Option 1: GitHub Import (Recommended)

1. Push to GitHub

   ```bash
   git remote add origin https://github.com/username/momentum.git
   git push -u origin main
   ```

2. Go to FlutLab
3. Click "Create New Project" → "Import from GitHub"
4. Select momentum repository
5. Configure Firebase settings
6. Run the app

### Option 2: ZIP Upload

1. Create ZIP file with all project files
2. Go to FlutLab
3. Click "Create New Project" → "Upload ZIP"
4. Upload ZIP file
5. Configure Firebase settings
6. Run the app

---

## ⚠️ Important Notes

### Firebase Configuration

- Keep `firebase_options.dart` updated with your Firebase credentials
- Don't commit Firebase keys to public repositories
- Use environment variables for production

### Android Configuration

- Update `android/app/build.gradle`:
  ```gradle
  android {
      compileSdkVersion 34
      minSdkVersion 21
      targetSdkVersion 34
  }
  ```

### iOS Configuration

- Update deployment target to iOS 11.0+
- Ensure CocoaPods is installed
- Run `pod repo update` if needed

---

## 🐛 Troubleshooting

### Build Issues

```bash
# Clean build
flutter clean
flutter pub get
flutter run

# Update dependencies
flutter pub upgrade

# Check Doctor
flutter doctor
```

### Firebase Issues

- Verify `google-services.json` is in `android/app/`
- Verify `GoogleService-Info.plist` is in Xcode project
- Check Firebase security rules
- Verify Authentication methods are enabled

### Dependency Issues

```bash
# Resolve conflicts
flutter pub get --no-offline

# Update all packages
flutter pub upgrade

# Check for issues
flutter pub health
```

---

## 📚 Useful Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [GoRouter Guide](https://pub.dev/packages/go_router)
- [Provider Guide](https://pub.dev/packages/provider)
- [Firestore Guide](https://firebase.google.com/docs/firestore)

---

## 📞 Support

For issues:

1. Check [Flutter Troubleshooting](https://flutter.dev/docs/testing/troubleshooting)
2. Review [Firebase Support](https://firebase.google.com/support)
3. Check project issues
4. Search Stack Overflow

---

**Last Updated**: 2024  
**Version**: 1.0.0

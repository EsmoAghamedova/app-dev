# ⚡ Momentum Quick Start Guide

Get Momentum running in 5 minutes!

---

## 🚀 Quick Setup

### 1. Install Dependencies

```bash
cd momentum
flutter pub get
```

### 2. Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project named "momentum"
3. Register Android app (package: `com.example.momentum`)
4. Download `google-services.json` → place in `android/app/`
5. Register iOS app (bundle ID: `com.example.momentum`)
6. Download `GoogleService-Info.plist` → drag to Xcode

### 3. Update Firebase Credentials

Edit `lib/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_HERE',
  appId: 'YOUR_APP_ID_HERE',
  messagingSenderId: 'YOUR_SENDER_ID_HERE',
  projectId: 'momentum-xxxxx',
);
```

### 4. Run the App

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome
```

---

## 📁 Important Files

| File                        | Purpose                     |
| --------------------------- | --------------------------- |
| `lib/main.dart`             | App entry point             |
| `lib/app.dart`              | App configuration & routing |
| `lib/firebase_options.dart` | Firebase credentials        |
| `lib/models/`               | Data structures             |
| `lib/features/`             | Feature screens & logic     |
| `lib/core/services/`        | Shared services             |
| `lib/core/theme/`           | App styling                 |
| `pubspec.yaml`              | Dependencies                |

---

## 🔗 File Navigation

### Authentication

- `lib/features/auth/services/auth_service.dart` - Login/Register logic
- `lib/features/auth/screens/login_screen.dart` - Login UI
- `lib/features/auth/screens/register_screen.dart` - Register UI

### Tasks

- `lib/features/tasks/services/task_service.dart` - Task CRUD
- `lib/features/tasks/screens/tasks_screen.dart` - Task list
- `lib/features/tasks/screens/add_task_screen.dart` - Create task
- `lib/features/tasks/screens/edit_task_screen.dart` - Edit task

### Dashboard

- `lib/features/dashboard/screens/dashboard_screen.dart` - Main dashboard

### User Profile

- `lib/features/profile/screens/profile_screen.dart` - User profile
- `lib/features/settings/screens/settings_screen.dart` - Settings

---

## 🛠 Common Commands

```bash
# Download dependencies
flutter pub get

# Format code
dart format lib/

# Check for errors
flutter analyze

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Clean build
flutter clean && flutter pub get
```

---

## 📚 Documentation

- **Setup Details**: See [SETUP.md](SETUP.md)
- **Architecture**: See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Progress**: See [PROGRESS.md](PROGRESS.md)
- **Full Details**: See [README.md](README.md)

---

## 🚨 Troubleshooting

### Build Fails

```bash
flutter clean
flutter pub get
flutter run
```

### Firebase Not Working

- ✓ Check `google-services.json` is in `android/app/`
- ✓ Check `GoogleService-Info.plist` is in Xcode
- ✓ Verify Firebase credentials in `firebase_options.dart`

### Dependencies Issue

```bash
flutter pub upgrade
flutter pub get
```

### Dart Errors

```bash
dart analyze
dart fix --apply
```

---

## 🎯 What's Next

1. **Firebase Setup** (5-10 mins)
   - Create Firebase project
   - Add credentials

2. **Test App** (2 mins)
   - Run `flutter run`
   - See splash screen

3. **Implement Features** (1-2 hours)
   - Wire up authentication
   - Connect task operations
   - Test CRUD

4. **Polish UI** (1 hour)
   - Add loading states
   - Error handling
   - Responsive design

---

## 📊 Project Structure Summary

```
lib/
├── core/                 # Shared resources
│   ├── constants/        # Colors, strings, routes
│   ├── theme/           # App theme
│   ├── widgets/         # Custom components
│   └── services/        # Firebase service
├── models/              # Data models
├── features/            # Feature modules
│   ├── splash/         # Splash screen
│   ├── auth/           # Login/Register
│   ├── dashboard/      # Main dashboard
│   ├── tasks/          # Task management
│   ├── profile/        # User profile
│   ├── settings/       # App settings
│   └── notifications/  # Notifications
├── main.dart           # Entry point
└── app.dart            # App config
```

---

## 🔐 Firestore Rules

Copy to Firebase Console → Firestore → Rules:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /tasks/{taskId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## 🎨 Customization

### Change Primary Color

Edit `lib/core/constants/app_colors.dart`:

```dart
static const Color primary = Color(0xFF6366F1); // Change this
```

### Change App Name

Edit `pubspec.yaml`:

```yaml
name: momentum # Change this
```

### Change Theme

Edit `lib/core/theme/light_theme.dart`

---

## 📱 Platform-Specific

### Android

- Min SDK: 21
- Target SDK: 34
- File: `android/app/build.gradle`

### iOS

- Min iOS: 11.0
- File: `ios/Podfile`
- File: `ios/Runner.xcworkspace`

---

## 🔄 Development Tips

1. **Hot Reload**: Press `r` in terminal to refresh
2. **Full Rebuild**: Press `R` to rebuild entire app
3. **Debug**: Click elements to debug in DevTools
4. **Logs**: Check console for errors and warnings

---

## 📞 Need Help?

- 📖 Check [SETUP.md](SETUP.md) for detailed instructions
- 🏗 Check [ARCHITECTURE.md](ARCHITECTURE.md) for design patterns
- 📊 Check [PROGRESS.md](PROGRESS.md) for checklist
- 🔗 Check specific service files for implementation details

---

## ✅ Quick Checklist

- [ ] Flutter SDK installed
- [ ] Dependencies downloaded (`flutter pub get`)
- [ ] Firebase project created
- [ ] Firebase credentials configured
- [ ] App builds successfully (`flutter run`)
- [ ] Firestore security rules updated
- [ ] Ready to implement features!

---

**Ready to build Momentum? 🚀**

Start with `flutter pub get` and enjoy!

---

Last Updated: 2024  
Version: 1.0.0-MVP  
Status: Ready for Development ✅

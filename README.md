# Momentum Task Management App

A modern, responsive Flutter task management application built with Firebase integration for real-time data synchronization.

## 🚀 Features

### MVP (Core Features)

- ✅ Firebase Authentication (Login/Register)
- ✅ Firestore Database Integration
- ✅ Create, Read, Update, Delete Tasks (CRUD)
- ✅ Dashboard with Statistics
- ✅ Task Status Management (Planned, In Progress, Completed)
- ✅ Responsive UI Design
- ✅ Task Priority Levels
- ✅ Deadline Management

### Screens

1. **Splash Screen** - App introduction
2. **Login Screen** - User authentication
3. **Register Screen** - New account creation
4. **Dashboard Screen** - Overview with statistics
5. **Tasks Screen** - Complete task list with search and filter
6. **Add Task Screen** - Create new tasks
7. **Edit Task Screen** - Modify existing tasks
8. **Profile Screen** - User profile and statistics
9. **Settings Screen** - App preferences

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   ├── theme/
│   │   └── light_theme.dart
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_textfield.dart
│   │   ├── task_card.dart
│   │   ├── stat_card.dart
│   │   └── loading_indicator.dart
│   └── services/
│       └── firebase_service.dart
├── models/
│   ├── user_model.dart
│   └── task_model.dart
├── features/
│   ├── splash/
│   ├── auth/
│   ├── dashboard/
│   ├── tasks/
│   ├── profile/
│   ├── settings/
│   └── notifications/
├── main.dart
├── app.dart
└── firebase_options.dart
```

## 🛠 Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Backend**: Firebase (Auth + Firestore)
- **Navigation**: GoRouter
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth

## 📦 Dependencies

```yaml
firebase_core: ^2.24.0
firebase_auth: ^4.15.0
cloud_firestore: ^4.14.0
provider: ^6.1.0
go_router: ^13.2.0
intl: ^0.19.0
uuid: ^4.0.0
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed (3.0+)
- Firebase project created
- Dart 3.0+

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/momentum.git
   cd momentum
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Download your Firebase configuration files:
     - `google-services.json` (for Android)
     - `GoogleService-Info.plist` (for iOS)
   - Update `lib/firebase_options.dart` with your credentials

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔐 Firebase Setup

### Collections Structure

**users**

```
{
  id: string (userId)
  username: string
  email: string
  photoUrl: string (optional)
  createdAt: timestamp
  role: string
}
```

**tasks**

```
{
  id: string (taskId)
  title: string
  description: string
  status: string (Planned/In Progress/Completed)
  priority: string (Low/Medium/High)
  deadline: timestamp
  createdAt: timestamp
  updatedAt: timestamp
  userId: string
}
```

**notifications** (Future)

```
{
  id: string
  title: string
  message: string
  userId: string
  isRead: boolean
  createdAt: timestamp
}
```

## 📝 Task Model

```dart
{
  id: String,
  title: String,
  description: String,
  status: TaskStatus (planned, inProgress, completed),
  priority: TaskPriority (low, medium, high),
  deadline: DateTime,
  createdAt: DateTime,
  updatedAt: DateTime,
  userId: String,
}
```

## 🎨 Design System

### Color Palette

- **Primary**: Indigo (#6366F1)
- **Secondary**: Purple (#8B5CF6)
- **Success**: Green (#10B981)
- **Warning**: Amber (#F59E0B)
- **Error**: Red (#EF4444)
- **Info**: Blue (#3B82F6)

### Border Radius

- Default: 12px
- Cards: 12px
- Buttons: 12px

## 🔄 Navigation Flow

```
Splash Screen
    ↓
[Not Logged In] → Login Screen ← Register Screen
    ↓
Dashboard Screen ← (Logged In)
    ↓
├─ Tasks Screen
│  ├─ Add Task Screen
│  └─ Edit Task Screen
├─ Profile Screen
├─ Settings Screen
└─ Notifications Screen
```

## 📱 Responsive Design

- Mobile-first approach
- Optimized for devices 320px and up
- Tested on various screen sizes
- Adaptive layouts using MediaQuery

## 🔄 State Management with Provider

The app uses Provider for:

- Authentication state
- Task list state
- User profile state
- App settings

## 🧪 Testing

```bash
flutter test
```

## 📤 Deployment

### Android

```bash
flutter build apk
flutter build appbundle
```

### iOS

```bash
flutter build ios
```

## 🚦 Next Steps / Future Features

- [ ] Dark Mode Support
- [ ] Team Collaboration
- [ ] Shared Tasks
- [ ] Push Notifications
- [ ] Task Categories/Labels
- [ ] Task Analytics
- [ ] Recurring Tasks
- [ ] Integration with Calendar
- [ ] Offline Support with local database
- [ ] Multi-language Support

## 📖 Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Provider Documentation](https://pub.dev/packages/provider)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

Created as a modern task management solution.

## 📞 Support

For support, email support@momentum-app.com or open an issue in the repository.

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Status**: MVP Development

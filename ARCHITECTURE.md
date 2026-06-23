# 🏗 Momentum Architecture Guide

This document explains the architectural design, patterns, and structure of the Momentum task management application.

---

## 🎯 Architecture Overview

Momentum follows a **Feature-Based Architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI Screens, Widgets, Components)      │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│      Business Logic Layer               │
│  (Services, State Management)           │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│      Data Layer                         │
│  (Models, Firebase, Local Storage)      │
└─────────────────────────────────────────┘
```

---

## 📦 Folder Structure Explanation

### `/core` - Shared Resources

```
core/
├── constants/
│   ├── app_colors.dart      # Color palette
│   ├── app_strings.dart     # String constants
│   └── app_routes.dart      # Navigation routes
├── theme/
│   └── light_theme.dart     # Theme configuration
├── widgets/
│   ├── custom_button.dart   # Reusable button
│   ├── custom_textfield.dart # Reusable input
│   ├── task_card.dart       # Task display card
│   ├── stat_card.dart       # Statistics card
│   └── loading_indicator.dart # Loading spinner
└── services/
    └── firebase_service.dart # Firebase singleton
```

**Purpose**: Centralized resources used across all features
**Benefits**: DRY principle, consistent styling, easy maintenance

### `/models` - Data Models

```
models/
├── user_model.dart          # User data structure
└── task_model.dart          # Task data structure
```

**Purpose**: Define data structures with serialization/deserialization
**Usage**: Convert between Dart objects and Firestore documents

### `/features` - Feature Modules

Each feature follows the same structure:

```
features/
├── feature_name/
│   ├── screens/             # UI screens
│   ├── widgets/             # Feature-specific widgets
│   └── services/            # Business logic
```

#### Feature Structure Pattern

```
feature/
├── screens/
│   ├── feature_screen.dart      # Main screen
│   ├── add_feature_screen.dart  # Create screen
│   └── edit_feature_screen.dart # Edit screen
│
├── widgets/
│   ├── feature_list.dart        # List component
│   ├── feature_tile.dart        # Item component
│   └── feature_form.dart        # Form component
│
└── services/
    └── feature_service.dart     # Business logic
```

---

## 🏛 Design Patterns

### 1. **Singleton Pattern** (Firebase Service)

```dart
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal() {
    // Initialize
  }
}
```

**Use Case**: Single Firebase instance across the app
**Benefit**: Centralized Firebase management

### 2. **Factory Pattern** (Model Creation)

```dart
factory TaskModel.fromMap(Map<String, dynamic> map) {
  return TaskModel(
    id: map['id'] ?? '',
    // ... other properties
  );
}
```

**Use Case**: Create models from Firestore documents
**Benefit**: Encapsulated object creation logic

### 3. **Provider Pattern** (State Management)

```dart
// In the future, wrap screens with Provider
ChangeNotifierProvider(
  create: (_) => AuthProvider(),
  child: const DashboardScreen(),
)
```

**Use Case**: Manage and listen to state changes
**Benefit**: Reactive UI updates

### 4. **Repository Pattern** (Future Implementation)

```dart
// Services act as repositories
class TaskService {
  Future<TaskModel> createTask(...) { ... }
  Stream<List<TaskModel>> getTasksStream(...) { ... }
  Future<void> updateTask(...) { ... }
  Future<void> deleteTask(...) { ... }
}
```

**Use Case**: Abstract data operations
**Benefit**: Easy to mock and test

---

## 🔄 Data Flow

### Creating a Task

```
User Input (Add Task Screen)
    ↓
Validate Form
    ↓
Create TaskModel
    ↓
Call TaskService.createTask()
    ↓
Firebase creates document
    ↓
Update local state
    ↓
Navigate back / Show success
```

### Reading Tasks

```
TasksScreen loads
    ↓
Call TaskService.getTasksStream(userId)
    ↓
Firebase returns snapshot
    ↓
Convert to TaskModel list
    ↓
Update Provider/State
    ↓
Rebuild UI with new data
```

### Updating a Task

```
User edits and saves (Edit Task Screen)
    ↓
Validate Form
    ↓
Update TaskModel
    ↓
Call TaskService.updateTask(taskId, updatedTask)
    ↓
Firebase updates document
    ↓
Refresh task list
    ↓
Navigate back
```

---

## 🗂 Database Schema

### Firestore Collections

#### `users`

- Document ID: User UID
- Fields:
  - `username` (String)
  - `email` (String)
  - `photoUrl` (String, optional)
  - `createdAt` (Timestamp)
  - `role` (String)

#### `tasks`

- Document ID: Auto-generated
- Fields:
  - `title` (String)
  - `description` (String)
  - `status` (String)
  - `priority` (String)
  - `deadline` (Timestamp)
  - `createdAt` (Timestamp)
  - `updatedAt` (Timestamp)
  - `userId` (String, Reference to user)

#### `notifications`

- Document ID: Auto-generated
- Fields:
  - `title` (String)
  - `message` (String)
  - `userId` (String)
  - `isRead` (Boolean)
  - `createdAt` (Timestamp)

---

## 🔐 Security & Validation

### Input Validation

```dart
TextFormField(
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    }
    if (value!.length < 3) {
      return 'Minimum 3 characters';
    }
    return null;
  },
)
```

### Firestore Security Rules

```firestore
// Only authenticated users
// Only their own data
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}

match /tasks/{taskId} {
  allow read, write: if request.auth.uid == resource.data.userId;
}
```

---

## 🎨 Design System

### Color Tokens

```dart
class AppColors {
  // Primary
  static const Color primary = Color(0xFF6366F1);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}
```

### Typography

```dart
TextTheme {
  displayLarge: 32px, bold       // Page titles
  titleLarge: 20px, semibold     // Section titles
  bodyLarge: 16px, medium        // Body text
  labelSmall: 12px, regular      // Labels
}
```

### Spacing System

- Small: 8px
- Medium: 16px
- Large: 24px
- XLarge: 32px

---

## 🔄 State Management Strategy

### Current Implementation (Simple)

- Local `setState` for simple state
- Provider ready for scaling

### Future Implementation (Recommended)

```dart
class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  Future<void> loadTasks(String userId) async {
    _tasks = await _taskService.getTasks(userId);
    notifyListeners();
  }
}
```

---

## 📱 Navigation Architecture

### GoRouter Configuration

```dart
static final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
      routes: [
        GoRoute(
          path: 'tasks',
          builder: (context, state) => const TasksScreen(),
        ),
      ],
    ),
  ],
);
```

**Benefits**:

- Type-safe navigation
- Deep linking support
- Parameter passing
- Nested routing

---

## 🧪 Testing Strategy

### Unit Tests (Services)

```dart
test('createTask should return TaskModel', () async {
  final task = await taskService.createTask(...);
  expect(task, isA<TaskModel>());
});
```

### Widget Tests (UI)

```dart
testWidgets('Login button should be enabled', (WidgetTester tester) async {
  await tester.pumpWidget(const LoginScreen());
  expect(find.byType(ElevatedButton), findsOneWidget);
});
```

### Integration Tests (Full Flow)

```dart
testWidgets('Complete task creation flow', (WidgetTester tester) async {
  // Login
  // Navigate to add task
  // Fill form
  // Submit
  // Verify task appears
});
```

---

## 🚀 Scalability Considerations

### Current MVP

- ✅ Single user focus
- ✅ Basic task management
- ✅ Simple authentication

### Future Improvements

1. **Team Features**
   - Shared tasks
   - Team members
   - Permissions system

2. **Advanced Features**
   - Task categories
   - Tags/Labels
   - Task templates
   - Recurring tasks

3. **Performance**
   - Pagination
   - Caching
   - Offline support
   - Real-time sync

4. **State Management Upgrade**
   - Full Provider implementation
   - Consider Riverpod for complex state

---

## 📊 Performance Optimization

### Current Optimizations

- Lazy loading widgets
- Efficient Firestore queries
- Stream-based updates
- Image caching ready

### Future Optimizations

- Local database (Hive/Drift)
- Pagination for task lists
- Image compression
- Debouncing search/filters

---

## 🔗 Dependency Injection

### Current Approach (Simple)

```dart
final taskService = TaskService();
final authService = AuthService();
```

### Future Approach (Scalable)

```dart
// Using get_it or similar
final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<FirebaseService>(FirebaseService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<TaskService>(TaskService());
}

// Usage
final taskService = getIt<TaskService>();
```

---

## 🔄 CI/CD Pipeline (Future)

```yaml
Pipeline:
1. Code Push → GitHub
2. Run Tests → GitHub Actions
3. Build APK/IPA
4. Deploy to TestFlight/Internal Testing
5. Release to Production
```

---

## 📚 Key Concepts

### Immutability

Models should be immutable or use `copyWith`:

```dart
TaskModel task1 = TaskModel(...);
TaskModel task2 = task1.copyWith(status: TaskStatus.completed);
// task1 remains unchanged
```

### Async/Await

All Firebase operations are async:

```dart
// Don't block UI
Future<void> saveTask() async {
  try {
    await taskService.createTask(task);
  } catch (e) {
    // Handle error
  }
}
```

### Streams for Real-time Data

```dart
// Listen to changes
taskService.getTasksStream(userId).listen((tasks) {
  // Update UI whenever data changes
});
```

---

## 🎓 Architecture Best Practices

✅ **DO**

- Separate concerns (UI, Logic, Data)
- Use meaningful names
- Document complex logic
- Write reusable components
- Test critical paths

❌ **DON'T**

- Mix UI with business logic
- Create god classes
- Hardcode values
- Ignore error handling
- Skip validation

---

## 📖 References

- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [Flutter Design Patterns](https://refactoring.guru/design-patterns)

---

**Last Updated**: 2024  
**Architecture Version**: 1.0  
**Status**: MVP Ready

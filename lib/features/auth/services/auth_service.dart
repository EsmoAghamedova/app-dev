import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();

  // Register
  Future<UserModel?> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User user = userCredential.user!;

      final userModel = UserModel(
        id: user.uid,
        username: username,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Registration failed: $e';
    }
  }

  // Login
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User user = userCredential.user!;
      final doc = await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Login failed: $e';
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _firebaseService.auth.signOut();
    } catch (e) {
      throw 'Logout failed: $e';
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    final user = _firebaseService.currentUser;
    if (user != null) {
      return UserModel(
        id: user.uid,
        username: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    }
    return null;
  }

  // Get user stream
  Stream<User?> get userStream => _firebaseService.userStream;

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}

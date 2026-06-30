import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:momentum/models/user_model.dart';
import 'package:momentum/core/services/firebase_service.dart';
import 'package:momentum/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();
  late final GoogleSignIn _googleSignIn;

  AuthService() {
    _googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? DefaultFirebaseOptions.web.apiKey : null,
    );
  }

  Future<UserModel?> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User user = userCredential.user!;
      await user.updateDisplayName(username);

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

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseService.auth.signInWithCredential(credential);
      final User user = userCredential.user!;

      final doc = await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        final userModel = UserModel(
          id: user.uid,
          username: user.displayName ?? 'User',
          email: user.email ?? '',
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );

        await _firebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        return userModel;
      }

      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw 'Google Sign-In failed: $e';
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firebaseService.firestore
          .collection('users')
          .doc(user.id)
          .update(user.toMap());
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseService.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw 'Logout failed: $e';
    }
  }

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

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send reset email: $e';
    }
  }

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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;

  FirebaseService._internal() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  factory FirebaseService() {
    return _instance;
  }

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;

  // User Stream
  Stream<User?> get userStream => _auth.authStateChanges();

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
}

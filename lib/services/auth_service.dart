import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user and write role to Firestore
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role, // "seller" or "buyer"
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      // optional: send email verification
      await user.sendEmailVerification();

      // create user document
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'displayName': displayName,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  // Sign in
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Sign out
  Future<void> signOut() => _auth.signOut();

  // Get role quickly
  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    doc.exists
        ? (doc.data() != null ? (doc.data()!['role'] as String?) : null)
        : null;
  }

  // Listen to auth changes (useful in app root)
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password, username) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(username);
      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  // get user name
  Future<String?> getUserDisplayName() async {
    final user = getCurrentUser();
    return user?.displayName; // Return display name or null if not set
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = getCurrentUser();
    try {
      await user?.updateDisplayName(displayName);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}

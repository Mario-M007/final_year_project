import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get instance of firebas auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get cuurent user
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
          await userCredential.user?.updateProfile(displayName: username);
      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  // get user name
  Future<String?> getUserDisplayName() async {
    final user = _firebaseAuth.currentUser;
    return user?.displayName; // Return display name or null if not set
  }

  // sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info if doesnt exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _mapSignInErrorCode(e.code);
      throw AuthException(errorMessage);
    }
  }

  String _mapSignInErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'User account has been disabled';
      case 'user-not-found':
        return 'User not found. Please register';
      case 'wrong-password':
        return 'Wrong password provided for this user';
      default:
        return 'Sign in failed. Please try again later.';
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      //create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _mapSignUpErrorCode(e.code);
      throw AuthException(errorMessage);
    }
  }

  String _mapSignUpErrorCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email is already in use. Please use a different email or sign in.';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return 'Sign up failed. Please try again later.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return 'AuthException: $message';
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Logger logger = Logger();
  User? _user;

  AuthService() {
    _initAuthStateListener();
  }

  User? get user => _user;

  void _initAuthStateListener() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        _user = authResult.user;
        logger.d('User signed in: ${_user?.displayName ?? "N/A"}');
        notifyListeners();
        return _user;
      }
      return null;
    } catch (error) {
      logger.e('Error signing in with Google: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (error) {
      logger.e('Error signing out: $error');
    }
  }
}

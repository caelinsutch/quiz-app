import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> anonLogin() async {
    // Create userID
    FirebaseUser user = await _auth.signInAnonymously();
    updateUserData(user);
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      // Account
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      // Auth
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      // Credential for firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken);
      // Get user from Db
      FirebaseUser user = await _auth.signInWithCredential(credential);
      updateUserData(user);
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> updateUserData(FirebaseUser user) {
    print(user.uid);
    DocumentReference reportRef = _db.collection('reports').document(user.uid);

    return reportRef.setData({
      'uid': user.uid,
      'lastActivity': DateTime.now()
    }, merge: true);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

}
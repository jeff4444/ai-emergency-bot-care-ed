import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/my_user.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // method to signin a user using email and password
  Future signInUser(email, password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return res.user;
    } catch (e) {
      return null;
    }
  }

  // method to register a user using email and password
  Future registerUser(MyUser user) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      user.uid = res.user?.uid ?? '';
      res.user?.updateDisplayName(user.name);
      await DatabaseService().updateUserCollection(user);
      return res.user;
    } catch (e) {
      return null;
    }
  }

  // method to signout a user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  // sign in user anonymously
  Future signInAnon() async {
    try {
      UserCredential res = await _auth.signInAnonymously();
      print(res.user);
      return res.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // reset password
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      return null;
    }
  }
}

// create a custom user class from Firebase user class
Future<MyUser?> createUserFromAuthUser(User? user) async {
  if (user == null) {
    return null;
  }
  final DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  dynamic userData = snapshot.data();
  if (userData != null) {
    return MyUser.fromMap(userData);
  }
  return null;
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");
  User? _user;

  //Getter to acess the current user
  User? get user => _user;

  Future<void> signUp(
      String email, String password, String name, String imageUrl) async {
    print(email);
    try {
      //Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //set the user
      _user = userCredential.user;
      // Save user data in Firebase Realtime Database
      _dbRef.child(_user!.uid).set({
        "userId": _user!.uid,
        "name": name,
        "email": email,
        "password": password,
        "imageUrl": imageUrl,
        "role": 'admin',
        "points": 0,
      }).then((_) {
        print("User Data Saved Successfully!");
      }).catchError((error) {
        print("Failed to save user data:$error");
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }
  // login Function

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  // Logout Function
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends ChangeNotifier {
  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String? userId;
  String? name;
  String? email;
  String? password;
  String? imageUrl;
  // double? points;
  int? role;

  void setUsersDetails(DataSnapshot snapshot) {
    if (snapshot.value != "" && snapshot.value != null) {
      userId = snapshot.child('userId').value.toString();
      name = snapshot.child('name').value.toString();
      email = snapshot.child('email').value.toString();
      password = snapshot.child('password').value.toString();
      //  points = double.parse(snapshot.child('point').value.toString());
      // role = int.parse(snapshot.child('role').value.toString());
      notifyListeners();
      //here we store the preference of both user
      setUserPreferences();
      // getUsersDetaulsFromPrefs();
    }
  }

  void getUsersDetailsFromPref() async {
    print(name);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    name = prefs.getString('name');
    email = prefs.getString('email');
    // points = prefs.getDouble('point');
    // role = prefs.getInt('role');
    imageUrl = prefs.getString('imageUrl');
    notifyListeners();
  }

  void setUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email != null) prefs.setString('email', email!);
    if (userId != null) prefs.setString('userId', userId!);
    if (name != null) prefs.setString('name', name!);
    // if (points != null) {
    //   prefs.setDouble('point', double.parse(points.toString()));
    // }
    // prefs.setInt('role', int.parse(role.toString()));
    if (imageUrl != null) prefs.setString('imageUrl', imageUrl!);
    notifyListeners();
  }

  void updateUserPreferences(String name, String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('imageUrl', imageUrl);

    print("updated name : ${prefs.getString('name')}");
    print("Updated imageUrl: ${prefs.getString('imageUrl')}");
    notifyListeners();
  }

  void updateUserPoints(String username, double points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('point', double.parse(points.toString()));

    // print("Updated Points : ${prefs.getDouble('point')}");
    notifyListeners();
  }
}

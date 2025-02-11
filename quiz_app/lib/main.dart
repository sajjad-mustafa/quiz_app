import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/components/devoice_info.dart';
import 'package:quiz_app/models/db_handler.dart';
import 'package:quiz_app/providers/auth_provider.dart';
import 'package:quiz_app/providers/user_details.dart';
import 'package:quiz_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var db = DbHandler();
  // db.addQuestion(Question(id: '20', title: 'What is 20 * 100', options: {
  //   '100': false,
  //   '200': true,
  //   '300': false,
  //   '500': false,
  // }));
  db.fetchQuestions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    screenhHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserDetails()),
      ],
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()),
    );
  }
}

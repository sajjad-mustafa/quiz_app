import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/components/devoice_info.dart';
import 'package:quiz_app/providers/user_details.dart';
import 'package:quiz_app/screens/dashboard_screen.dart';
import 'package:quiz_app/screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  Future<void> getUserData(String userId) async {
    print("Fetching user data for ID: $userId");
    print("get user id$userId");
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    await databaseRef.child('users').child(userId).get().then((val) {
      Provider.of<UserDetails>(context, listen: false).setUsersDetails(val);
    });
  }

  bool isLogined = false;
  bool isLoading = false;

  checkIfLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final uid = pref.getString("id");
    if (uid != "" && uid != null) {
      setState(() {
        isLogined = true;
        Provider.of<UserDetails>(context, listen: false)
            .getUsersDetailsFromPref();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      });
    }
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quiz_app/components/devoice_info.dart';
// import 'package:quiz_app/providers/auth_provider.dart';
// import 'package:quiz_app/screens/dashboard_screen.dart';
// import 'package:quiz_app/screens/sign_up_screen.dart';

// class LoginScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Center(
              child: Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: 'email',
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 5, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.visibility_off_outlined),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black),
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  userLogin(_emailController.text.toString(),
                      _passController.text.toString());
                },
                // onTap: () async {
                //   final authProvider =
                //       Provider.of<AuthProvider>(context, listen: false);
                //   try {
                //     await authProvider.login(
                //       emailController.text.toString(),
                //       passwordController.text.toString(),
                //     );
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => DashboardScreen()));
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('Login Succeful!')),
                //     );
                //   } catch (e) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text(e.toString())),
                //     );
                //   }
                // },
                child: Container(
                  height: screenhHeight * 0.060,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("I have don't account"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Text('SignUp'))
                ],
              ),
            ])));
  }

  void userLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      print("Email or password is empty");
      setState(() {
        isLoading = false;
      });
    } else {
      // UserCredential? userCredential;
      print("Trying to login user...");
      // try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((val) async {
        print("Login successful! User Id: ${val.user!.uid}");

        // Fetch user data before navigating
        await getUserData(val.user!.uid);
        print("Navigating to Dashboard");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
        // if (val.user!.uid != " ") {
        //   print('Login Id = ' + val.user!.uid.toString());
        // await Future.value(getUserData(val.user!.uid.toString()));

        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
              // }).onError((error, StackTrace) {
              //   print("on error catch" + error.toString());
              //   setState(() {
              //     isLoading = false;
              //   });
              // });
              // } }catch (e) {
              //   print("try block" + e.toString());
              //   setState(() {
              //     isLoading = false;
              //   });
              // }

              ).catchError((error) {
        print("Login error: ${error.toString()}");
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/components/devoice_info.dart';
import 'package:quiz_app/providers/auth_provider.dart';
import 'package:quiz_app/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<AuthProvider>(context, listen: false).signUp(
            _emailController.text,
            _passwordController.text,
            _nameController.text,
            _imageUrlController.text);

        // Show success message or navigate to next screen
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign up successful!')));
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Name',
                    suffixIcon: Icon(Icons.account_circle_rounded),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black),
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black),
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    suffixIcon: Icon(Icons.visibility_off_outlined),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 5, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                    labelText: 'Url',
                    hintText: 'ImageUrl',
                    suffixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black),
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Url';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  height: screenhHeight * 0.060,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'SignUp',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account "),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text('Login'))
                ],
              ),
              // _isLoading
              //     ? CircularProgressIndicator()
              //     : ElevatedButton(
              //         onPressed: _signUp,
              //         child: Text('Sign Up'),
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}

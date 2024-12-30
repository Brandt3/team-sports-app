import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:team_app_final_project/signin.dart';
import 'package:team_app_final_project/main.dart';
import 'package:team_app_final_project/db_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(),
        body: const Padding(
          padding: EdgeInsets.all(30.0),
          child: MyCustomForm(),
        ),
      );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  String email = "";
  String password = "";
  final _loginKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> checkPlayer() async {
    //Must run this first so the validators still can give there errors
    if (!_loginKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    List<Map<String, dynamic>> person = await dbHelper.getPasswordCheck(
        email, password);

    //Checks if the email and password exist if it isn't it returns a pop up and won't login the player
    if (person.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and/or password does not exist!')),
      );
      return;
    }

    //This runs only if the validators a good and the password and email check out
    //This will hide the pop up so it doesn't carry over into the home page
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _loginKey.currentState!.save();
    emailController.clear();
    passwordController.clear();
    setState(() {});

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(email: email)),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginKey,
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30,),
            const Text("Login",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 38,
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                password = value!;
              },
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
                onPressed: checkPlayer,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 50),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                child: const Text('LOGIN', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                )
            ),
            const SizedBox(height: 10,),
            //Found this widget by doing some research it allows you to have clickable text within a text widget
            RichText(
              text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(
                      color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to sign-up page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                      ),
                    ]
                  ),
                )
            ],
          ),
        ),
      );
    }
  }

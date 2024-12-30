import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:team_app_final_project/main.dart';
import 'package:team_app_final_project/login.dart';
import 'package:team_app_final_project/db_helper.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView( //Use this to fix an error so I don't have a render overflow
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  String fname = "";
  String lname = "";
  String email = "";
  String phone = "";
  String password = "";
  String comfrim = "";
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> playerMap = [];

  Future<void> addPlayer() async {
    //Before anything check to make sure all fields are filled
    if(!_formKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text.toString();
    List<Map<String, dynamic>> person = await dbHelper.getPlayersEmail(email);

    //Checks if the email is unique if it isn't it returns a pop up and won't add the player
    if (person.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already exists! Please use a different email')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (passwordController.text == confirmController.text) {
        _formKey.currentState!.save();
        Map<String, dynamic> person = {
          'fname': fnameController.text,
          'lname': lnameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'password': passwordController.text,
        };
        await dbHelper.insertPlayer(person);
        fnameController.clear();
        lnameController.clear();
        emailController.clear();
        phoneController.clear();
        passwordController.clear();
        confirmController.clear();

        setState(() {});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(email: email)),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Confirm password does not match password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30,),
            const Text("Sign Up",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 38,
              ),
            ),
            TextFormField(
              controller: fnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your First Name';
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            TextFormField(
              controller: lnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Last Name';
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
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
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Phone Number';
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
            TextFormField(
              controller: confirmController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm Password';
                }
                return null;
              },
              onSaved: (value) {
                password = value!;
              },
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
                onPressed: addPlayer,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 50),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                child: const Text('SIGN UP', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                )
            ),
            const SizedBox(height: 10,),
            //Found this widget by doing some research it allows you to have clickable text within a text widget
            RichText(
              text: TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(
                      color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Login",
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to sign-up page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
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

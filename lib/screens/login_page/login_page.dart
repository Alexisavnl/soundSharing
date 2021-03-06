import 'package:da_song/BottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common/delayed_animation.dart';
import '../../common/theme_helper.dart';
import '../../models/myUser.dart';
import '../register_page/register_page.dart';
import '../../services/auth.dart';
import 'package:da_song/screens/home/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _obsureText = true;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      passwordController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            DelayedAnimation(
              delay: 500,
              child: SizedBox(
                height: 300,
                child: Image.asset('images/app_logo.png'),
              ),
            ),
            DelayedAnimation(
              delay: 1000,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter an email"
                                : null,
                            decoration: ThemeHelper().textInputDecoration(
                                'Email', 'Enter your Email'),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) => value != null &&
                                    value.length < 6
                                ? "Enter a password with at least 6 characters"
                                : null,
                            obscureText: _obsureText,
                            decoration: ThemeHelper().textInputDecoration(
                              'Password',
                              'Enter your password',
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {});
                                  _obsureText = !_obsureText;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              signIn();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(13)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.mail_outline_outlined),
                                SizedBox(width: 10),
                                Text('CONFIRM')
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        UserCredential user = await _auth.signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.all(13)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/google_logo.png',
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('GOOGLE')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DelayedAnimation(
              delay: 1500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Do not have an account ?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text('Signup'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        loading = true;
      });
      var password = passwordController.value.text.trim();
      var email = emailController.value.text.trim();
      MyUser? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        setState(() {
          loading = false;
          error = 'Please supply a valid email';
        });
      }
    }
  }
}

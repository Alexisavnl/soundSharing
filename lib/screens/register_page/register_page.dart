import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/loading.dart';
import 'package:da_song/common/theme_helper.dart';
import 'package:da_song/screens/login_page/login_page.dart';
import 'package:da_song/screens/register_page/header_widget.dart';
import 'package:da_song/services/database.dart';

import '../../common/delayed_animation.dart';
import '../../models/myUser.dart';
import '../../services/auth.dart';
import '../home/home.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var _obsureMdp = true;
  var _obsureMdpVerif = true;
  bool errorEmail = false;
  bool loading = false;

  final AuthService _auth = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      emailController.text = '';
      passwordController.text = '';
      confirmPasswordController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const SizedBox(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 150),
                        Container(
                          child: TextFormField(
                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if ((val!.isEmpty) ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              if (errorEmail == true) {
                                errorEmail = false;
                                return 'This Email already exist';
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _obsureMdp,
                            decoration: ThemeHelper().textInputDecoration(
                              "Password",
                              "Enter your password",
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {});
                                  _obsureMdp = !_obsureMdp;
                                },
                              ),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: confirmPasswordController,
                            obscureText: _obsureMdpVerif,
                            decoration: ThemeHelper().textInputDecoration(
                              "Confirm Password",
                              "Confirm your password",
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {});
                                  _obsureMdpVerif = !_obsureMdpVerif;
                                },
                              ),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter the confirm password";
                              }
                              if (confirmPasswordController.value.text
                                  .trim()
                                  .toString() !=
                                  passwordController.value.text
                                      .trim()
                                      .toString()) {
                                return "Please enter the same password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                register();
                              }
                            },
                          ),
                        ),
                        DelayedAnimation(
                          delay: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('You have an account ?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                },
                                child: const Text('Sign In'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future register() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        loading = true;
      });
      var password = passwordController.value.text.trim();
      var email = emailController.value.text.trim();
      MyUser? user =
          await _auth.registerUserWithEmailAndPassword(email, password);
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomAppBar()));
      } else {
        setState(() {
          loading = false;
          errorEmail = true;
        });
      }
    }
  }
}
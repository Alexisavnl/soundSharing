import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'common/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp(
  name: 'Da-Song',
  options: DefaultFirebaseOptions.currentPlatform,
 ).whenComplete(() {
  print("completedAppInitialize");
 });
}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

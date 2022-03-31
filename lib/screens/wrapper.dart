import 'package:flutter/material.dart';
import '../models/myUser.dart';
import '../screens/login_page/login_page.dart';
import 'package:provider/provider.dart';
import 'package:da_song/screens/bottomNavBar.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if (user == null) {
      return const LoginPage();
    } else {
      return const BottomNavBar();
    }
  }
}

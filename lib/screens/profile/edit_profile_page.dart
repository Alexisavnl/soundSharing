import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:da_song/widget/profile_widget.dart';
import 'package:da_song/widget/textfield_widget.dart';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            ProfileWidget(user.photoURL!,true),
            const SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Container(
                child: TextFieldWidget(
                  label: 'Pseudo',
                  text: user.displayName!,
                  onChanged: (name) {},
                  icon: Icon(Icons.check)
                ),
              ),
              
            ),
          ]),
        ),
      ),
    );
  }
}
import 'dart:io';
import 'dart:typed_data';

import 'package:da_song/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:da_song/utils/utils.dart';

class ProfileWidget extends StatefulWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget(this.imagePath, this.isEdit, this.onClicked);

  @override
  _ProfileWidget createState() => _ProfileWidget();
}

class _ProfileWidget extends State<ProfileWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser!;

  Uint8List? _image;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    print("selec");

    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
    uploadImageStorage();
  }

  uploadImageStorage() async {
    print("up");
    String photoUrl = await StorageMethods()
        .uploadImageToStorage('profilePics', _image!, false);
    print(photoUrl);
    await user.updatePhotoURL(photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    return Stack(
      children: [
        user.photoURL != null
            ? CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(user.photoURL!),
                backgroundColor: Colors.red,
              )
            : const CircleAvatar(
                radius: 64,
                backgroundImage:
                    NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                backgroundColor: Colors.red,
              ),
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: InkWell(
          onTap: selectImage,
          child: buildCircle(
            color: color,
            all: 8,
            child: Icon(
              widget.isEdit ? Icons.add_a_photo : Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

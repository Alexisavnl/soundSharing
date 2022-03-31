import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:da_song/utils/utils.dart';
import '../screens/profile/edit_profile_page.dart';
import '../services/firestore_methods.dart';
import '../services/storage_methods.dart';

class ProfileWidget extends StatefulWidget {
  final String imagePath;
  final bool isEdit;

  const ProfileWidget(this.imagePath, this.isEdit);

  @override
  _ProfileWidget createState() => _ProfileWidget();
}

class _ProfileWidget extends State<ProfileWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  Uint8List? _image;
  final FireStoreMethods firestore = FireStoreMethods();
  String profilePhotoUrl = '';

  //Méthode qui fait appelle  pickImage pour récupérer une photo de la galerie
  //puis appel uploadImageStorage
  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
    uploadImageStorage();
  }

  //uploadImageStorage fait appel à uploadImageToStorage pour envoyer la photo sur le serveur firebase
  //puis appel updatePhotoUrl pour modifier le lien de la nouvelle image de profile
  uploadImageStorage() async {
    String photoUrl = await StorageMethods()
        .uploadImageToStorage('profilePics', _image!, false);
    firestore.updatePhotoUrl(photoUrl);
    setState(() {
      profilePhotoUrl = photoUrl;
    });
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
        GestureDetector(
          onTap: (() {
            widget.isEdit
                ? selectImage()
                : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
          }),
          child: user.photoURL != null
              ? CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(profilePhotoUrl.isEmpty
                      ? widget.imagePath
                      : profilePhotoUrl),
                  backgroundColor: Colors.transparent,
                )
              : const CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      NetworkImage('https://cdn.discordapp.com/attachments/765615018996662364/959160695558111304/thesomeday123171200009.png'),
                  backgroundColor: Colors.red,
                ),
        )
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: InkWell(
          onTap: () {
            widget.isEdit
                ? selectImage()
                : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
          },
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget{
  const AppBarCustom({Key? key}) : super(key: key);


 @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(22, 27, 34, 1),
        title: const Text('DaSong.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        toolbarTextStyle: GoogleFonts.poppins(),
        titleTextStyle: GoogleFonts.poppins(),
        centerTitle: true,
      ),
    );
  }
}

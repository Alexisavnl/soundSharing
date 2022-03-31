import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//écran de chargement
class Loading extends StatelessWidget{
  const Loading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: SpinKitSpinningLines(
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
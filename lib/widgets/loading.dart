import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingProfile extends StatefulWidget {
  @override
  _LoadingProfileState createState() => _LoadingProfileState();
}

class _LoadingProfileState extends State<LoadingProfile> {




  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitDualRing(
        color: Colors.white,
        size: 70.0,
      ),
    );
  }
}




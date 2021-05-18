import 'package:cs310/classes/customUser.dart';
import 'package:cs310/pages/profile.dart';
import 'package:flutter/material.dart';

class targetProfile extends StatelessWidget {

  customUser currentUser;
  targetProfile({this.currentUser});

@ override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Viewing User: " + currentUser.username),
          backgroundColor: Colors.deepPurple,
        ),
        body: PageView(
        children: <Widget>[
        Profile(currentUser: currentUser,),

    ],
    physics: NeverScrollableScrollPhysics(),

    ),
    );
  }
}

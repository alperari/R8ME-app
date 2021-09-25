import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/post.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:flutter/material.dart';

class showProfilePicture extends StatelessWidget {
  final String currentUserID;
  showProfilePicture({this.currentUserID});

  String mediaURL;

  Widget buildImage(BuildContext context, String mediaURL) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-200,
            width:  MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: mediaURL,
            ),
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Viewing Profile Picture"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
        future: usersRef.doc(currentUserID).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return buildImage(context, snapshot.data.data()["photoURL"]);
        },
      ),
    );
  }
}

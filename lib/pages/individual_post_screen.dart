import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/post.dart';
import 'package:flutter/material.dart';
import "package:cs310/initial_routes/homepage.dart";

class Individual_Post_Screen extends StatefulWidget {

  Individual_Post_Screen({this.userID, this.postID});
  final String userID;
  final String postID;

  @override
  _Individual_Post_ScreenState createState() => _Individual_Post_ScreenState();
}

class _Individual_Post_ScreenState extends State<Individual_Post_Screen> {




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef
          .doc(widget.userID)
          .collection("user_posts")
          .doc(widget.postID)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Post post = Post.createPostFromDoc(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text("View Post"),
              backgroundColor: Colors.deepPurple,
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:flutter/material.dart';
import "package:cs310/classes/comment.dart";

class CommentsScreen extends StatefulWidget {

  final String postID;
  final String ownerID;
  final String mediaURL;

  CommentsScreen({
    this.postID,
    this.ownerID,
    this.mediaURL
  });

  @override
  _CommentsScreenState createState() => _CommentsScreenState(
    postID: this.postID,
    ownerID: this.ownerID,
    mediaURL: this.mediaURL
  );
}

class _CommentsScreenState extends State<CommentsScreen> {

  final customUser currentUserOnPage = currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _commentController = TextEditingController();

  final String postID;
  final String ownerID;
  final String mediaURL;

  _CommentsScreenState({
    this.postID,
    this.ownerID,
    this.mediaURL
  });


  Widget showComments(){
    return StreamBuilder(
      stream: commentsRef
          .doc(postID)
          .collection('comments')
          .orderBy("time", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Widget> comments = [];
        snapshot.data.docs.forEach((doc) {
          Comment currentComment = Comment.fromDocument(doc);
          comments.add( ReturnCommentWidget(currentComment, currentUserOnPage.userID));
        });

        return ListView(
          children: comments
        );
      },
    );
  }

  void createCommentInFirestore(){
    commentsRef
        .doc(postID)
        .collection("comments")
        .add({
          "userID" : currentUserOnPage.userID,
          "username" : currentUserOnPage.username,
          "avatarURL" : currentUserOnPage.photo_URL,
          "text" : _commentController.text,
          "time" : DateTime.now()
        });

    //and also add this comment to owner's activity feed
    bool isNotPostOwner = true;//currentUserOnPage.userID != ownerID;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(ownerID)
          .collection("feedItems")
          .add({
        "type": "comment",
        "comment_text" : _commentController.text,
        "username": currentUser.username,
        "userID": currentUser.userID,
        "photo_URL": currentUser.photo_URL,
        "postID": postID,
        "mediaURL": mediaURL,
        "time": DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: showComments()
          ),
          Divider(thickness: 1, height: 2,),
          ListTile(
            title: Form(
              key: _formKey,
              child: TextFormField(
                controller: _commentController,
                decoration: InputDecoration(labelText: "Enter your comment..."),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  else if( value.length <3){
                    return "At least 3 characters!";
                  }
                  else if(value.length> 75){
                    return "Maximum 75 characters!";
                  }
                  return null;
                },
              ),
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                onPrimary: Colors.white,
                shadowColor: Colors.red,
                elevation: 5,
              ),
              onPressed: () async {
                if(_formKey.currentState.validate()){
                  await createCommentInFirestore();
                  _commentController.clear();
                }
              },
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

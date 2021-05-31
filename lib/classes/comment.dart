import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/targetProfile.dart';
import "package:flutter/material.dart";
import 'package:timeago/timeago.dart' as timeago;

class Comment{
  final String commentID;
  final correspondingPostID;

  final String userID;
  final String username;
  final String avatarURL;
  final String text;
  final Timestamp time;

  //constructor
  Comment({
    this.commentID,
    this.correspondingPostID,
    this.userID,
    this.username,
    this.avatarURL,
    this.text,
    this.time,
  });

  //advanced constructor
  factory Comment.fromDocument(DocumentSnapshot myDoc, String postID){
    return Comment(
      commentID: myDoc.data()["commentID"],
      correspondingPostID: postID,

      userID: myDoc.data()["userID"],
      username: myDoc.data()["username"],
      avatarURL: myDoc.data()["avatarURL"],
      text: myDoc.data()["text"],
      time: myDoc.data()["time"],
    );
  }
}




Column ReturnCommentWidget(Comment mycomment, String outcoming_userID, BuildContext context){

  void showProfile(context)async{
    var doc = await usersRef.doc(mycomment.userID).get();
    customUser targetUser = customUser.fromDocument(doc);

    ///TODO: remove the comment lines for if condition, so that owner of post shall not view himself/herself
    //if(currentUser.userID != ownerID){
    Navigator.push(context, MaterialPageRoute(
        builder: (context){

          return targetProfile(currentUser: targetUser);
        }
    ));
    //}
  }

  void deleteEverythingAboutComment()async{
    //delete comment from comments
    DocumentSnapshot snapshot = await commentsRef
        .doc(mycomment.correspondingPostID)
        .collection("comments")
        .doc(mycomment.commentID)
        .get();

    if(snapshot.exists){
      snapshot.reference.delete();
    }


    //delete from feed items
    DocumentSnapshot snapshot2 = await activityFeedRef
      .doc(mycomment.userID)
      .collection("feedItems")
      .doc(mycomment.commentID)
      .get();
    if(snapshot2.exists){
      snapshot2.reference.delete();
    }
  }

  ShowOptions(BuildContext mainContext) {
    return showDialog(
        context: mainContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Do you want to remove your comment?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteEverythingAboutComment();
                },
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  return Column(
    children: <Widget>[
      ListTile(
        title: Container (
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Text(mycomment.username, style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: (){
                  print("Tapped on username");
                  showProfile(context);
                  },
              ),
              Text(mycomment.text),
            ],
         ),
        ),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(mycomment.avatarURL),
        ),
        subtitle: Text(timeago.format(mycomment.time.toDate(), locale: 'en_short')),
        trailing: outcoming_userID == mycomment.userID ? IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            ShowOptions(context);
          },
        ) : null,
      ),
      Divider(thickness: 1,),
    ],
  );
}
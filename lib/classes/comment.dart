import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/targetProfile.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comment{
  final String commentID;
  final String correspondingPostID;
  final String postOwnerID;
  final String userID;
  final String username;
  final String avatarURL;
  final String text;
  final Timestamp time;

  //constructor
  Comment({
    this.commentID,
    this.correspondingPostID,
    this.postOwnerID,

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
      postOwnerID: myDoc.data()["postOwnerID"],
      userID: myDoc.data()["userID"],
      username: myDoc.data()["username"],
      avatarURL: myDoc.data()["avatarURL"],
      text: myDoc.data()["text"],
      time: myDoc.data()["time"],
    );
  }
}




Widget ReturnCommentWidget(Comment mycomment, String outcoming_userID, BuildContext context){




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
      .doc(mycomment.postOwnerID)
      .collection("feedItems")
      .doc(mycomment.commentID)
      .get();

    if(snapshot2.exists){
      print("deleting" + snapshot.data().toString());
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
                  style: GoogleFonts.poppins(color: Colors.red),
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

  Widget Comment(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child:  CircleAvatar(
              radius: 22,
              backgroundImage: CachedNetworkImageProvider(mycomment.avatarURL),
            ),
          ),
          SizedBox(width: 12,),
          Expanded(
            flex: 10,

            child: Container(
              padding: EdgeInsets.fromLTRB(16,16,0,16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(mycomment.username, style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                      outcoming_userID == mycomment.userID ? IconButton(
                        padding: EdgeInsets.only(right: 12),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.clear, color: Colors.grey,),
                        onPressed: () {
                          ShowOptions(context);
                        },
                      ) : Text(""),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mycomment.text, style: GoogleFonts.poppins(),),
                          ],
                        ),
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                          flex: 2,
                          child: Text(timeago.format(mycomment.time.toDate(), locale: 'en_short'), style: GoogleFonts.poppins(color: Colors.grey),)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ownerComment(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            flex: 10,

            child: Container(
              padding: EdgeInsets.fromLTRB(16,16,0,16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(mycomment.username, style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                      outcoming_userID == mycomment.userID ? IconButton(
                        padding: EdgeInsets.only(right: 12),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          ShowOptions(context);
                        },
                      ) : Text(""),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mycomment.text, style: GoogleFonts.poppins(),),
                          ],
                        ),
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                          flex: 2,
                          child: Text(timeago.format(mycomment.time.toDate(), locale: 'en_short'), style: GoogleFonts.poppins(color: Colors.grey),)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12,),
          Expanded(
            flex: 2,
            child:  CircleAvatar(
              radius: 22,
              backgroundImage: CachedNetworkImageProvider(mycomment.avatarURL),
            ),
          ),
        ],
      ),
    );
  }

  if(outcoming_userID == mycomment.userID)
    return ownerComment();
  else
    return Comment();
}
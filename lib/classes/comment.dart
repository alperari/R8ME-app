import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/targetProfile.dart';
import "package:flutter/material.dart";
import 'package:timeago/timeago.dart' as timeago;

class Comment{

  final String userID;
  final String username;
  final String avatarURL;
  final String text;
  final Timestamp time;

  //constructor
  Comment({
    this.userID,
    this.username,
    this.avatarURL,
    this.text,
    this.time,
  });

  //advanced constructor
  factory Comment.fromDocument(DocumentSnapshot myDoc){
    return Comment(
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
            print("Delete the comment!");

          },
        ) : null,
      ),
      Divider(thickness: 1,),
    ],
  );
}
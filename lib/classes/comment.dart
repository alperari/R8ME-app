import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

Column ReturnCommentWidget(Comment mycomment, String outcoming_userID){
  return Column(
    children: <Widget>[
      ListTile(
        title: Container (
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(mycomment.username, style: TextStyle(fontWeight: FontWeight.bold),),
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
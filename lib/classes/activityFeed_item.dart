import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget mediaPreview;
String summaryText;


class ActivitiFeed_Item extends StatelessWidget {

  final String username;
  final String userID;
  final String type; // 'like', 'follow', 'comment'
  final String mediaURL;
  final String postID;
  final String photo_URL;
  final String comment_text;
  final Timestamp timestamp;

  ActivitiFeed_Item({
    this.username,
    this.userID,
    this.type, // 'like', 'follow', 'comment'
    this.mediaURL,
    this.postID,
    this.photo_URL,
    this.comment_text,
    this.timestamp,
  });

  factory ActivitiFeed_Item.fromDocument(DocumentSnapshot mydoc) {
    return ActivitiFeed_Item(
      username: mydoc.data()['username'],
      userID: mydoc.data()['userID'],
      type: mydoc.data()['type'],
      mediaURL: mydoc.data()['mediaURL'],
      postID: mydoc.data()['postID'],
      photo_URL: mydoc.data()['photo_URL'],
      comment_text: mydoc.data()['comment_text'],
      timestamp: mydoc.data()['time'],
    );
  }


  set_media_and_summarytext(context) {
    if (type == "like" || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => print("Show post!"),//showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaURL),
                  )),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      summaryText = "liked your post";
    } else if (type == 'follow') {
      summaryText = "is following you";
    } else if (type == 'comment') {
      summaryText = 'made comment: $comment_text';
    } else {
      summaryText = "Error: Unknown type '$type'";
    }
  }


  @override
  Widget build(BuildContext context) {

    set_media_and_summarytext(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.greenAccent[100],
        child: ListTile(
          title: GestureDetector(
            onTap: () => print("Show profile!"),//showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $summaryText',
                    )
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(photo_URL),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );

  }
}



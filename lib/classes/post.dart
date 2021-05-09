import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:photo_view/photo_view.dart';


CachedNetworkImage cachedNetworkImage_custom(mediaUrl) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Padding(
      child: CircularProgressIndicator(),
      padding: EdgeInsets.all(20.0),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

class Post extends StatefulWidget {

  final String postID;
  final String ownerID;
  final String username;
  final String mediaURL;
  final String description;
  final String location;
  final String time;

  final dynamic liked_users;
  final dynamic disliked_users;

  final int likeCount;
  final int dislikeCount;

  final double rate;

  //CONSTRUCTOR
  Post({
    this.postID,
    this.ownerID,
    this.username,
    this.mediaURL,
    this.description,
    this.location,
    this.time,

    this.liked_users,
    this.disliked_users,

    this.likeCount,
    this.dislikeCount,

    this.rate,
  });

  factory Post.createPostFromDoc(QueryDocumentSnapshot doc){
    return Post(
      postID: doc.data()["postID"],
      ownerID: doc.data()["ownerID"],
      username: doc.data()["username"],
      mediaURL: doc.data()["mediaURL"],
      description: doc.data()["description"],
      location: doc.data()["location"],
      time: doc.data()["time"],

      liked_users: doc.data()["liked_users"],
      disliked_users: doc.data()["disliked_users"],

      likeCount: doc.data()["likeCount"],
      dislikeCount: doc.data()["dislikeCount"],

      rate : doc.data()["rate"]
    );
  }


  int getLikeCount(liked_users){
    if(liked_users == null)
      return 0;

    int counter=0;
    liked_users.forEach((key, value) {
      if(value==true)
        counter++;
    });
    return counter;
  }
  int getDislikeCount(disliked_users){
    if(disliked_users == null)
      return 0;

    int counter=0;
    disliked_users.forEach((key, value) {
      if(value==true)
        counter++;
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
      postID: this.postID,
      ownerID: this.ownerID,
      username: this.username,
      mediaURL: this.mediaURL,
      description: this.description,
      location: this.location,
      time: this.time,

      liked_users: this.liked_users,
      disliked_users: this.disliked_users,

      likeCount: getLikeCount(this.liked_users),
      dislikeCount: getDislikeCount(this.disliked_users),

      rate : likeCount/dislikeCount

  );
}

class _PostState extends State<Post> {

  final String postID;
  final String ownerID;
  final String username;
  final String mediaURL;
  final String description;
  final String location;
  final String time;

  Map liked_users;
  Map disliked_users;

  int likeCount;
  int dislikeCount;

  double rate;

  //CONSTRUCTOR
  _PostState({
    this.postID,
    this.ownerID,
    this.username,
    this.mediaURL,
    this.description,
    this.location,
    this.time,

    this.liked_users,
    this.disliked_users,

    this.likeCount,
    this.dislikeCount,

    this.rate,
  });


  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(ownerID).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        customUser user = customUser.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(currentUser.photo_URL),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => print("Tapped on username"),
            child: Text(
              user.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(location),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => print("tapped on trailing button"),
          ),
        );
      },
    );
  }


  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () => print("Liked post!"),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height-200,
              width:  MediaQuery.of(context).size.width,
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                    mediaURL,
                    
                ),
                backgroundDecoration: BoxDecoration(color:Colors.white),
              ),
          )
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width:15,),
            IconButton(
              icon: Icon(Icons.favorite_rounded),
              iconSize: 30,
              color: Colors.grey[700],
              onPressed: (){
                print("tapped on like!");
              },
            ),
            Container(
              child: Text(
                "$likeCount",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 20,),
            IconButton(
              icon: Icon(Icons.thumb_down_rounded),
              iconSize: 30,
              color: Colors.grey[700],
              onPressed: (){
                print("tapped on dislike!");
              },
            ),
            Container(
              child: Text(
                "$dislikeCount",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 25,),
            IconButton(
              icon: Icon(Icons.chat_rounded),
              iconSize: 30,
              color: Colors.grey[700],
              onPressed: (){
                print("tapped on comment!");
              },
            ),
            SizedBox(width: 25,),
            Text(time.substring(0, time.indexOf(" "))),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username  ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(description))
          ],
        ),
        Divider(thickness: 3,),

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //buildPostHeader(),
        Divider(height: 5,),
        buildPostImage(),
        Divider(height: 5,),
        buildPostFooter(),

      ],
    );
  }
}

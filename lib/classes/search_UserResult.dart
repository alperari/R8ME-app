import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/targetProfile.dart';
import 'package:flutter/material.dart';




class UserResult extends StatefulWidget {
  final customUser user;
  UserResult(this.user);

  @override
  _UserResultState createState() => _UserResultState();
}

class _UserResultState extends State<UserResult> {

  bool iFollow = false;

  void showProfile(context)async{
    var doc = await usersRef.doc(widget.user.userID).get();
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

  Future<bool> checkFollowing()async{
   DocumentSnapshot snapshot = await followings_table_Ref.doc(authUser.userID).collection("myFollowings").doc(widget.user.userID).get();
   if(snapshot.exists){
     return true;
   }
   return false;
  }

  Follow()async{

    //add authedUser's followings the widget.currentUser.userID
    await followings_table_Ref
        .doc(authUser.userID)
        .collection("myFollowings")
        .doc(widget.user.userID)
        .set({});

    //add currentUser's followers the autherUser's ID
    await followers_table_Ref
        .doc(widget.user.userID)
        .collection("myFollowers")
        .doc(authUser.userID)
        .set({});

    //add this activity to feedItem of user being followed, in this case its currentUser
    await activityFeedRef
        .doc(widget.user.userID)
        .collection("feedItems")
        .add({
      "type": "follow",
      "ownerID": widget.user.userID,
      "username": authUser.username,
      "userID": authUser.userID,
      "photo_URL": authUser.photo_URL,
      "time": DateTime.now(),
    });
    setState(() {
      iFollow = true;
    });

  }
  Unfollow()async{

    //remove widget.user.userID from autherUser's followings
    await followings_table_Ref
        .doc(authUser.userID)
        .collection("myFollowings")
        .doc(widget.user.userID)
        .get().then((doc) {
      if(doc.exists){
        doc.reference.delete();
      }
    });

    //remove autherUser.uid from widget.user's followers
    await followers_table_Ref
        .doc(widget.user.userID)
        .collection("myFollowers")
        .doc(authUser.userID)
        .get().then((doc) {
      if(doc.exists){
        doc.reference.delete();
      }
    });
    setState(() {
      iFollow = false;
    });

  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if(authUser.userID != widget.user.userID){
                showProfile(context);
              }
            },  //showProfile(context, profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photo_URL),
                  radius: 25
              ),
              title: Text(
                widget.user.username,
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.user.bio,
                style: TextStyle(color: Colors.black),
              ),
              trailing: widget.user.userID == authUser.userID ? null :
                  FutureBuilder(
                  future: checkFollowing(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }
                    else{
                      if(snapshot.data == false && !iFollow){
                        return GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.lightGreen,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                  "Follow",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                              )
                            ),
                          ),
                          onTap: () async{
                            await Follow();

                          },
                        );
                      }
                      else {
                        return GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.red[300],
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Unfollow",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ),
                          ),

                          onTap: () async{
                            await Unfollow();

                          },
                        );
                      }

                    }
                  }
              )
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}

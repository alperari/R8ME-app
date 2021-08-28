import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customDialogBox.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/targetProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class UserResult extends StatefulWidget {
  final customUser user;
  UserResult(this.user);

  @override
  _UserResultState createState() => _UserResultState();
}

class _UserResultState extends State<UserResult> {

  bool iFollow = false;
  bool processOn = false;


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
   DocumentSnapshot snapshot = await followings_table_Ref.doc(auth.currentUser.uid).collection("myFollowings").doc(widget.user.userID).get();
   if(snapshot.exists){
     return true;
   }
   return false;
  }

  Follow()async{

    //add authedUser's followings the widget.currentUser.userID
    await followings_table_Ref
        .doc(auth.currentUser.uid)
        .collection("myFollowings")
        .doc(widget.user.userID)
        .set({});

    //add currentUser's followers the autherUser's ID
    await followers_table_Ref
        .doc(widget.user.userID)
        .collection("myFollowers")
        .doc(auth.currentUser.uid)
        .set({});

    //add this activity to feedItem of user being followed, in this case its currentUser
    await activityFeedRef
        .doc(widget.user.userID)
        .collection("feedItems")
        .add({
      "type": "follow",
      "ownerID": widget.user.userID,
      "username": auth.currentUser.uid,
      "userID": auth.currentUser.uid,
      "photo_URL": auth.currentUser.uid,
      "time": DateTime.now(),
    });
    setState(() {
      iFollow = true;
    });

  }
  Unfollow()async{

    //remove widget.user.userID from autherUser's followings
    await followings_table_Ref
        .doc(auth.currentUser.uid)
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
        .doc(auth.currentUser.uid)
        .get().then((doc) {
      if(doc.exists){
        doc.reference.delete();
      }
    });
    setState(() {
      iFollow = false;
    });

  }

  Container buildProgressContainer(){
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ]
      ),
      child:  CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if(auth.currentUser.uid != widget.user.userID){
                showProfile(context);
              }
            },  //showProfile(context, profileId: user.id),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0,0), // changes position of shadow
                    ),
                  ],
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.photo_URL),
                ),
              ),
              title: Text(
                widget.user.username,
                style:
                GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.user.bio,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              trailing: widget.user.userID == auth.currentUser.uid ? null :
                  FutureBuilder(
                  future: checkFollowing(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData){
                      return Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[400]
                        ),
                      );
                    }
                    else{
                      if(snapshot.data == false && !iFollow){
                        return GestureDetector(
                          child:Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ]
                            ),
                            child:  Icon(Icons.person_add,),
                          ),

                          onTap: () async{
                            setState(() {
                              processOn = true;
                            });

                            await Follow();

                            setState(() {
                              processOn = false;
                            });
                          },
                        );
                      }

                      else {
                        return GestureDetector(
                          child:Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ]
                            ),
                            child: Icon(Icons.person_remove),
                          ),


                          onTap: () async{
                            setState(() {
                              processOn = true;
                            });

                            await Unfollow();

                            setState(() {
                              processOn = false;
                            });
                          },
                        );
                      }

                    }
                  }
              )
            ),
          ),
        ],
      ),
    );
  }
}

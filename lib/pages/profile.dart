import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/post.dart';
import 'package:cs310/classes/postTile.dart';
import 'package:cs310/crashlytics.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/showFollowers_Followings.dart';
import 'package:cs310/pages/search.dart';
import 'package:cs310/pages/showProfilePicture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:cs310/pages/edit_profile.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cs310/classes/customUser.dart";

import "package:firebase_crashlytics/firebase_crashlytics.dart";

import '../initial_routes/homepage.dart';



class Profile extends StatefulWidget {

  customUser currentUser;
  Profile({this.currentUser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String postView_style = "grid";
  bool isLoading = false;
  int postCount = 0;
  List<Post> posts = [];

  bool isFollowing = false;


  setFollowersCount()async{
    //set the followers count
    await followers_table_Ref
        .doc(widget.currentUser.userID)
        .collection("myFollowers")
        .get().then((doc) {
          setState(() {
            widget.currentUser.followers_count = doc.size;
          });
    });
  }

  setFollowingsCount()async{
    //set the following count
    await followings_table_Ref
        .doc(widget.currentUser.userID)
        .collection("myFollowings")
        .get().then((doc) {
          print("asd");
      setState(() {
        widget.currentUser.followings_count = doc.size;
      });
    });
    print(widget.currentUser.followings_count);
  }



  check_curentlyFollowing() async{
    if(authUser.userID != widget.currentUser.userID){
      DocumentSnapshot snapshot = await followers_table_Ref
          .doc(widget.currentUser.userID)
          .collection("myFollowers")
          .doc(authUser.userID)
          .get().then((doc) {
        if(doc.exists){
          setState(() {
            isFollowing = true;
          });
        }
        else{
          setState(() {
            isFollowing = false;
          });
        }
      });

    }
  }


  getProfilePosts() async{
    setState(() {
      isLoading=true;
    });


    QuerySnapshot snapshot = await postsRef
        .doc(widget.currentUser.userID)
        .collection("user_posts")
        .orderBy("time",descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((e) => Post.createPostFromDoc(e)).toList();

    });
  }

  Container buildNoContent(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset(
              'assets/nocontent.jpg',
            ),

            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }


  Widget buildProfilePosts(){
    if(posts.isEmpty){
      return buildNoContent();
    }

    else if(isLoading == true)
      return CircularProgressIndicator();

    else if(postView_style == "grid") {
      List<GridTile> post_tiles=[];

      posts.forEach((post) {
        post_tiles.add(GridTile(child: PostTile(post:post)));
      });

      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: post_tiles,
      );
    }

    else if(postView_style == "list"){
      return Column(children: posts,);
    }
  }

  Future<void> calculateOverallRate() async {
    int likeCount = 0;
    int dislikeCount = 0;

    await postsRef
        .doc(currentUser.userID)
        .collection("user_posts").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((row) {
        likeCount += row.data()["likeCount"].toInt();
        dislikeCount += row.data()["dislikeCount"].toInt();

      });
    });

    double newRate;

    if((likeCount == 0 && dislikeCount == 0) || (likeCount == 0 && dislikeCount != 0)){
      newRate = 0.0;
    }
    else if(likeCount != 0 && dislikeCount == 0){
      newRate = 100;
    }
    else if(likeCount != 0 && dislikeCount != 0){
      newRate= likeCount / (likeCount+dislikeCount);
      newRate = num.parse(newRate.toStringAsFixed(2));
    }

    //update current rate
    currentUser.rate = newRate;
    print("updated currentUser locally");

    //update in the database
    usersRef.doc(currentUser.userID).update({
      "rate" : newRate
    });

    print("updated in the database");
  }

  build_grid_or_scrollable_button(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () {
            setState(() {
              postView_style = "grid";
            });
          },
          icon: Icon(Icons.grid_on_rounded),
          iconSize: 32,
          color: postView_style == 'grid'
              ? Colors.deepPurple
              : Colors.grey,
        ),
        IconButton(
          onPressed: (){
            setState(() {
              postView_style = "list";
            });
          },
          icon: Icon(Icons.list),
          iconSize: 32,
          color: postView_style == 'list'
              ? Colors.deepPurple
              : Colors.grey,
        ),
        IconButton(
          onPressed: ()async{
            customCrashLog("Tapped on crash button");
          },
          icon: Icon(Icons.block_outlined),
          color: Colors.red,
        )
      ],
    );
  }


  Follow(){

    //add authedUser's followings the widget.currentUser.userID
    followings_table_Ref
        .doc(authUser.userID)
        .collection("myFollowings")
        .doc(widget.currentUser.userID)
        .set({});

    //add currentUser's followers the autherUser's ID
    followers_table_Ref
        .doc(widget.currentUser.userID)
        .collection("myFollowers")
        .doc(authUser.userID)
        .set({});

    //add this activity to feedItem of user being followed, in this case its currentUser
    activityFeedRef
        .doc(widget.currentUser.userID)
        .collection("feedItems")
        .add({
      "type": "follow",
      "ownerID": widget.currentUser.userID,
      "username": authUser.username,
      "userID": authUser.userID,
      "photo_URL": authUser.photo_URL,
      "time": DateTime.now(),
    });
    setState(() {
      isFollowing = true;
    });

  }
  Unfollow(){

    //remove widget.currentUser.userID from autherUser's followings
    followings_table_Ref
        .doc(authUser.userID)
        .collection("myFollowings")
        .doc(widget.currentUser.userID)
        .get().then((doc) {
          if(doc.exists){
            doc.reference.delete();
      }
    });

    //remove autherUser.uid from widget.currentUser's followers
    followers_table_Ref
        .doc(widget.currentUser.userID)
        .collection("myFollowers")
        .doc(authUser.userID)
        .get().then((doc) {
          if(doc.exists){
            doc.reference.delete();
          }
        });
    setState(() {
      isFollowing = false;
    });

  }

  Widget Button_Follow_Unfollow(String buttonText, Function action){
    return FlatButton.icon(
        onPressed: (){
          //Do the Action : Follow/Unfolow
          if(buttonText == "Follow"){
            Follow();
            setState(() {
              widget.currentUser.followers_count++;
            });
          }
          else if(buttonText == "Unfollow"){
            Unfollow();
            setState(() {
              widget.currentUser.followers_count--;
            });
          }
        },
        icon: isFollowing ==true ?  Icon(Icons.person_remove, size: 35) : Icon(Icons.person_add,size:35) ,
        label:Text(buttonText),
      //color: isFollowing ==true ? Colors.redAccent : Colors.lightGreen,
    );

  }

  Widget buildButton_Edit_or_Follow(){
    //this will show the button if the currentUserOnPage is the owner user.
    //otherwise it should show the button "Follow" if not following,  "Unfollow" otherwise
    if(authUser.userID == widget.currentUser.userID){
      return FlatButton.icon(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(currentUser: widget.currentUser)));
          },
          icon: Icon(Icons.edit),label:Text("Edit"));
    }
    else{
      if(isFollowing){
        //Show "Unfollow
        return Button_Follow_Unfollow("Unfollow", Unfollow);
      }
      else{
        //Show "Follow"
        return Button_Follow_Unfollow("Follow", Follow);

      }
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();

      getProfilePosts();

      setFollowersCount();
      setFollowingsCount();


      calculateOverallRate();
      check_curentlyFollowing();

      enableCrashlytics();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset("assets/applogo.jpeg", fit: BoxFit.contain,),
          ),

          DraggableScrollableSheet(
            minChildSize: 0.1,
            initialChildSize: 0.22,
            builder: (context, scrollController){
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(

                  decoration: BoxDecoration(

                      border: Border.all(),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                  ),

                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                  //color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //for user profile header
                      Container(
                        padding : EdgeInsets.only(left: 32, right: 32, top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(widget.currentUser.photo_URL),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              onTap: (){
                                //show profile picture
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => showProfilePicture(currentUserID: widget.currentUser.userID)));

                              },
                            ),


                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(widget.currentUser.username, style: TextStyle(color: Colors.grey[800], fontFamily: "Roboto",
                                      fontSize: 16, fontWeight: FontWeight.w700
                                  ),),

                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: widget.currentUser.userID == authUser.userID ? Colors.white: (isFollowing==true ? Colors.redAccent[200] : Colors.green[300]),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      width: 1
                                  )
                              ),
                              child: buildButton_Edit_or_Follow(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16,),
                      //Container for clients
                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[

                            Text(
                              widget.currentUser.bio.toString(),
                              style: TextStyle(fontFamily: "Roboto", fontSize: 15),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 16,),
                      //Container for clients



                      SizedBox(height: 16,),
                      Container(
                        padding: EdgeInsets.all(32),
                        color: Colors.greenAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.image, color: Colors.black, size: 30,),
                                    SizedBox(width: 4,),
                                    Text(postCount.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                        fontFamily: "Roboto", fontSize: 24
                                    ),)
                                  ],
                                ),

                                Text("Posts", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto", fontSize: 15
                                ),)
                              ],
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Icon(Icons.check_box,size: 30, color: Colors.black),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => showFollowers_Followings(currentUser: widget.currentUser,whichList: "Followings",)));
                                        },
                                      ),
                                      Text(widget.currentUser.followings_count.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto", fontSize: 24
                                      ),)
                                    ],
                                  ),

                                  Text("Following", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto", fontSize: 15
                                  ),)
                                ],
                              ),
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => showFollowers_Followings(currentUser: widget.currentUser,whichList: "Followings",)));
                              },
                            ),

                            GestureDetector(
                              child:  Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.favorite, color: Colors.black, size: 30,),
                                      SizedBox(width: 4,),
                                      Text(widget.currentUser.followers_count.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto", fontSize: 24
                                      ),)
                                    ],
                                  ),

                                  Text("Followers", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto", fontSize: 15
                                  ),)
                                ],
                              ),
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => showFollowers_Followings(currentUser: widget.currentUser,whichList: "Followers",)));
                              },
                            ),


                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    SizedBox(width: 4,),
                                    Text(widget.currentUser.rate.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                        fontFamily: "Roboto", fontSize: 24
                                    ),)
                                  ],
                                ),

                                Text("Rating", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto", fontSize: 15
                                ),)
                              ],
                            ),
                          ],
                        ),
                      ),

                      //Posts will be displayed here
                      Divider(thickness: 3,),
                      build_grid_or_scrollable_button(),
                      Divider(thickness: 3,),
                      buildProfilePosts(),
                    ],
                  ),

                ),
              );
            },
          )
        ],
      ),
    );

  }
}



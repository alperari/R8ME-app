import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/post.dart';
import 'package:cs310/classes/postTile.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/edit_profile.dart';
import 'package:cs310/pages/showFollowers_Followings.dart';
import 'package:cs310/pages/showProfilePicture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:cs310/classes/customUser.dart";
import 'package:google_fonts/google_fonts.dart';


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
      setState(() {
        widget.currentUser.followings_count = doc.size;
      });
    });
    print(widget.currentUser.followings_count);
  }



  check_curentlyFollowing() async{
    if(auth.currentUser.uid != widget.currentUser.userID){
      DocumentSnapshot snapshot = await followers_table_Ref
          .doc(widget.currentUser.userID)
          .collection("myFollowers")
          .doc(auth.currentUser.uid)
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
    return Container(
      child: Center(
        child: Image.asset(
          'assets/nocontent.jpg',
          fit: BoxFit.fill,
        ),

      ),
    );
  }

  Container buildProfileUpper(){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue[500],
            Colors.blue[600],
            Colors.blue[800],
            Colors.blue[900]
          ],
        ),
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: width / 30, vertical: height / 30),
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(1),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
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
                    Text(widget.currentUser.username, style: GoogleFonts.poppins(color: Colors.grey[300],
                        fontSize: 16, fontWeight: FontWeight.w700
                    ),),

                  ],
                ),
              ),
              Container(
                child: buildButton_Edit_or_Follow(),
              ),

            ],
          ),
          SizedBox(height: 16,),
          //Container for clients
          Container(
            padding: EdgeInsets.only(left: 32, right: 32),
            child: Column(
              children: <Widget>[

                Text(
                  widget.currentUser.bio.toString(),
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }

  Container buildUserInfoBar(){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.deepPurple[400],
            Colors.deepPurple,
            Colors.deepPurple[600],
            Colors.deepPurple[700],
            Colors.deepPurple[800]
          ],
        ),
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: width / 30, vertical: height / 100),
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.image, color: Colors.white, size: 30,),
                  Text(postCount.toString(), style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 24
                  ),)
                ],
              ),

              Text("Posts", style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 15
              ),)
            ],
          ),
          GestureDetector(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check_box, color:Colors.white, size: 30,),
                    Text(widget.currentUser.followings_count.toString(), style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 24
                    ),)
                  ],
                ),

                Text("Following", style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 15
                ),)
              ],
            ),
            onTap: (){
              if(widget.currentUser.public || isFollowing || widget.currentUser.userID == auth.currentUser.uid){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => showFollowers_Followings(currentUser: widget.currentUser,whichList: "Followings",)));
              }
            },
          ),

          GestureDetector(
            child:  Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.favorite, color:Colors.white, size: 30,),
                    Text(widget.currentUser.followers_count.toString(), style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 24
                    ),)
                  ],
                ),

                Text("Followers", style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 15
                ),)
              ],
            ),
            onTap: (){
              if(widget.currentUser.public || isFollowing || widget.currentUser.userID == auth.currentUser.uid){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => showFollowers_Followings(currentUser: widget.currentUser,whichList: "Followers",)));

              }
            },
          ),


          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  SizedBox(width: 4,),
                  FutureBuilder(
                    future: getRate(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return Text((snapshot.data*100).toString(), style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold,fontSize: 24
                        ),);
                      }
                      return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
                    },
                  ),
                ],
              ),

              Text("Rating", style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold,fontSize: 15
              ),)
            ],
          ),
        ],
      ),
    );
  }

  Container buildPrivateContent(){
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset(
              'assets/private_acc.jpg',
              fit:BoxFit.contain,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("THIS ACCOUNT IS PRIVATE!",
                style: GoogleFonts.poppins(
                  fontSize: 23,
                  color: Colors.grey[700]
                ),),
                Text("FOLLOW IN ORDER TO SEE THE CONTENT!",
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    color: Colors.grey[700]
                ),),
              ],
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
        childAspectRatio: 0.70,
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

  Future<double> getRate() async {
    DocumentSnapshot snapshot = await usersRef.doc(currentUser.userID).get();
    var rate = snapshot.data()["rate"];
    rate = num.parse(rate.toStringAsFixed(2));
    return rate;
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
      ],
    );
  }


  Follow(){

    //add authedUser's followings the widget.currentUser.userID
    followings_table_Ref
        .doc(auth.currentUser.uid)
        .collection("myFollowings")
        .doc(widget.currentUser.userID)
        .set({});

    //add currentUser's followers the autherUser's ID
    followers_table_Ref
        .doc(widget.currentUser.userID)
        .collection("myFollowers")
        .doc(auth.currentUser.uid)
        .set({});

    //add this activity to feedItem of user being followed, in this case its currentUser
    activityFeedRef
        .doc(widget.currentUser.userID)
        .collection("feedItems")
        .add({
      "type": "follow",
      "ownerID": widget.currentUser.userID,
      "username": auth.currentUser.uid,
      "userID": auth.currentUser.uid,
      "photo_URL": auth.currentUser.uid,
      "time": DateTime.now(),
    });
    setState(() {
      isFollowing = true;
    });

  }
  Unfollow(){

    //remove widget.currentUser.userID from autherUser's followings
    followings_table_Ref
        .doc(auth.currentUser.uid)
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
        .doc(auth.currentUser.uid)
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
    return GestureDetector(
      onTap: (){
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
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]
        ),
        child: isFollowing ==true ?  Icon(Icons.person_remove, size: 26) : Icon(Icons.person_add,size:26) ,
      ),
    );



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
      icon: isFollowing ==true ?  Icon(Icons.person_remove, size: 26) : Icon(Icons.person_add,size:26) ,
      label:Text(buttonText, style: GoogleFonts.poppins(),),
      //color: isFollowing ==true ? Colors.redAccent : Colors.lightGreen,
    );
  }

  Widget Button_Edit(){
    return GestureDetector(
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Icon(Icons.edit, color: Colors.grey[700],size: 30,),

      ),
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfile(currentUser: widget.currentUser))
        );
      },
    );
  }

  Widget buildButton_Edit_or_Follow(){
    //this will show the button if the currentUserOnPage is the owner user.
    //otherwise it should show the button "Follow" if not following,  "Unfollow" otherwise
    if(auth.currentUser.uid == widget.currentUser.userID){
      return Button_Edit();
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

  Widget buildContent(bool public){
    if(public || isFollowing || widget.currentUser.userID == auth.currentUser.uid){
      return Column(
        children: [
          build_grid_or_scrollable_button(),
          Divider(thickness: 3,),
          buildProfilePosts(),
        ],
      );
    }
    else{
      return buildPrivateContent();
    }
  }
  @override
    void initState() {
      // TODO: implement initState
      super.initState();

      getProfilePosts();

      setFollowersCount();
      setFollowingsCount();


      //calculateOverallRate();
      check_curentlyFollowing();

  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover
                )
            ),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.40,
            initialChildSize: 0.5,
            builder: (context, scrollController){
              return Container(
                padding:EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    //padding:EdgeInsets.all(8),
                    decoration: BoxDecoration(

                        border: Border.all(),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                    ),

                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    //color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //for user profile header
                        buildProfileUpper(),
                        buildUserInfoBar(),

                        //Posts will be displayed here
                        Divider(thickness: 3,),

                        buildContent(widget.currentUser.public)


                      ],
                    ),

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



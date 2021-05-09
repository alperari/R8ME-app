import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/post.dart';
import 'package:cs310/classes/postTile.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:cs310/pages/edit_profile.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:cs310/UserHelper.dart';
import "package:cs310/classes/customUser.dart";






class Profile extends StatefulWidget {

  customUser currentUser;
  Profile({this.currentUser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool isLoading = false;
  int postCount = 0;
  List<Post> posts = [];

  getProfilePosts() async{
    setState(() {
      isLoading=true;
    });

    print(2);

    QuerySnapshot snapshot = await postsRef
        .doc(widget.currentUser.userID)
        .collection("user_posts")
        .orderBy("time",descending: true)
        .get();
    setState(() {
      isLoading = false;
      print(1);
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((e) => Post.createPostFromDoc(e)).toList();
      print(3);

    });
  }


  bool grid = true;
  Widget buildProfilePosts(){
    if(grid) {
      List<GridTile> post_tiles=[];

      posts.forEach((post) {
        post_tiles.add(GridTile(child: PostTile(post:post)));
      });

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: post_tiles,
      );
    }
    if(isLoading == true)
      return CircularProgressIndicator();
    else{
      return Column(children: posts,);
    }
  }




  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getProfilePosts();
  }


  @override
  Widget build(BuildContext context) {


    return Stack(
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
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(widget.currentUser.photo_URL),
                                    fit: BoxFit.cover),
                                ),
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
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    width: 1
                                  )
                                ),
                                child: FlatButton.icon(
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProfile(currentUser: widget.currentUser)));
                                      },
                                    icon: Icon(Icons.edit),label:Text("Edit")),
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

                              Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.check_box, color: Colors.black, size: 30,),
                                      SizedBox(width: 4,),
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

                              Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.favorite, color: Colors.black, size: 30,),
                                      SizedBox(width: 4,),
                                      Text(widget.currentUser.followings_count.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto", fontSize: 24
                                      ),)
                                    ],
                                  ),

                                  Text("Followers", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto", fontSize: 15
                                  ),)
                                ],
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

                        SizedBox(height: 16,),
                        //container for about me


                        //Container for reviews

                        buildProfilePosts(),

                      ],
                    ),

                  ),
                );
              },
            )
          ],
        );

  }
}


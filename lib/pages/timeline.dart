import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/classes/post.dart';
import 'package:cs310/pages/profile.dart';
import 'package:flutter/material.dart';
import "package:cs310/initial_routes/homepage.dart";
import 'package:tiktoklikescroller/tiktoklikescroller.dart';


class Timeline extends StatefulWidget {
  
  Timeline({this.authUser});
  final customUser authUser;
  
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> timelinePosts = [];

  Future<void> getPosts() async{
    QuerySnapshot snapshot = await timelineRef
        .doc(authUser.userID)
        .collection("timelinePosts")
        .orderBy("time", descending: true)
        .get();

    setState(() {
      timelinePosts = snapshot.docs.map(  (doc)=>Post.createPostFromDoc(doc)  ).toList();

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

  Widget displayPosts(){
    if(timelinePosts == null){
      return Center(child: CircularProgressIndicator());
    }
    else if(timelinePosts.isEmpty){
      return buildNoContent();
    }
    else{
      return ListView(
        children: timelinePosts,
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    getPosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()=> getPosts() ,
          child: displayPosts(),
      ),
      )
    );
  }
}

/*
    final List<Color> colors = <Color>[Colors.red, Colors.blue];

MaterialApp(
      home: Scaffold(
        body: TikTokStyleFullPageScroller(
          contentSize: colors.length,
          swipeThreshold: 0.1,
          // ^ the fraction of the screen needed to scroll
          swipeVelocityThreshold: 100,
          // ^ the velocity threshold for smaller scrolls
          animationDuration: const Duration(milliseconds: 300),
          // ^ how long the animation will take
          builder: (BuildContext context, int index) {
            return Container(
              child: Image(
                image: AssetImage("assets/a$index.png"),
                fit: BoxFit.fill,
              ),
            );
          },
        ),
      ),
    );
    */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/pages/search.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310/pages/profile.dart';
import 'package:cs310/pages/upload.dart';
import 'package:cs310/pages/timeline.dart';
import 'package:cs310/pages/activity_feed.dart';
import "package:cs310/classes/customUser.dart";

final FirebaseUser = FirebaseAuth.instance.currentUser;
final usersRef = FirebaseFirestore.instance.collection("users");
final postsRef = FirebaseFirestore.instance.collection("posts");
final commentsRef = FirebaseFirestore.instance.collection("posts_comments");

final followers_table_Ref = FirebaseFirestore.instance.collection("followers_table");
final followings_table_Ref = FirebaseFirestore.instance.collection("followings_table");

final timelineRef = FirebaseFirestore.instance.collection("timeline");

final activityFeedRef = FirebaseFirestore.instance.collection("feeds");

final storageRef = FirebaseStorage.instance.ref();

final FirebaseAuth auth = FirebaseAuth.instance;


customUser currentUser;


class HomePage extends StatelessWidget {
  const HomePage({Key key,this.currentUserID}): super(key: key);

  final String currentUserID;


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(currentUserID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {

          return MyHomePageLoaded(doc: snapshot.data);
        }

        return Scaffold(
          body: Center(
            child: Container(child: CircularProgressIndicator(), color: Colors.white,)),
        );
      },
    );
  }
}







class MyHomePageLoaded extends StatefulWidget {

  final DocumentSnapshot doc;


  MyHomePageLoaded({this.doc});

  @override
  _MyHomePageLoadedState createState() => _MyHomePageLoadedState();
}

class _MyHomePageLoadedState extends State<MyHomePageLoaded> {

  PageController pageController;
  int pageIndex = 0;


  onPageChanged(int pindex){
    setState(() {
      this.pageIndex = pindex;
    });
  }
  navigationTap(int pindex){
    pageController.jumpToPage(pindex);
  }


  @override
  void initState() {
    // TODO: implement initState
    currentUser = customUser.fromDocument(widget.doc);

    pageController = PageController();

    super.initState();
  }








  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: PageView(
        children: <Widget>[
          Profile(currentUser: currentUser,),
          Timeline(),
          Upload(currentUser: currentUser,),
          ActivityFeed(),
          Search(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),

      ),

      bottomNavigationBar: BottomNavigationBar(
        iconSize: 34,
        backgroundColor: Colors.transparent,
        currentIndex: pageIndex,
        onTap: navigationTap,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("Profile")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Timeline")),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle,size: 45), title: Text("Upload")),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_rounded), title: Text("Activity")),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), title: Text("Search"))

        ],
      ),

    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }


}
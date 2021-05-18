import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/pages/search.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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
final storageRef = FirebaseStorage.instance.ref();
final commentsRef = FirebaseFirestore.instance.collection("posts_comments");

final followers_table_Ref = FirebaseFirestore.instance.collection("followers_table");
final followings_table_Ref = FirebaseFirestore.instance.collection("followings_table");


final activityFeedRef = FirebaseFirestore.instance.collection("feeds");

final FirebaseAuth myauth = FirebaseAuth.instance;


customUser currentUser;



class HomePage extends StatelessWidget {
  const HomePage({Key key,this.documentId, this.analytics, this.observer}): super(key: key);

  final String documentId;

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {


        if (snapshot.connectionState == ConnectionState.done) {
          return MyHomePageLoaded(doc: snapshot.data , analytics: analytics,observer: observer,);
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
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  MyHomePageLoaded({this.doc,this.analytics,this.observer});

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

  Future<void> Analytics_setUserID(String UserID) async{
    widget.analytics.setUserId(UserID);
  }

  @override
  void initState() {
    // TODO: implement initState
    currentUser = customUser.fromDocument(widget.doc);
    Analytics_setUserID(currentUser.userID);

    pageController = PageController();

    super.initState();
  }








  Future<void> Analytics_SetCurrentScreen() async{
    await widget.analytics.setCurrentScreen(screenName: "Homepage Screen" , screenClassOverride: "homepage");
  }

  @override
  Widget build(BuildContext context) {
    Analytics_SetCurrentScreen();

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

      bottomNavigationBar: CupertinoTabBar(
        iconSize: 34,
        backgroundColor: Colors.transparent,
        currentIndex: pageIndex,
        onTap: navigationTap,
        activeColor: Colors.deepPurple,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle,size: 45)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded))

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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/pages/search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310/pages/profile.dart';
import 'package:cs310/pages/upload.dart';
import 'package:cs310/pages/timeline.dart';
import 'package:cs310/pages/chat.dart';
import 'package:cs310/pages/settings.dart';
import "package:cs310/UserHelper.dart";
import "package:cs310/classes/customUser.dart";

final FirebaseUser = FirebaseAuth.instance.currentUser;
final usersRef = FirebaseFirestore.instance.collection("users");
final postsRef = FirebaseFirestore.instance.collection("posts");
final storageRef = FirebaseStorage.instance.ref();

final FirebaseAuth myauth = FirebaseAuth.instance;

customUser currentUser;



class HomePage extends StatelessWidget {
  final String documentId;

  HomePage(this.documentId);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {


        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return MyHomePageLoaded(incoming_data: data,);
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

  final Map<String, dynamic> incoming_data;
  MyHomePageLoaded({this.incoming_data});

  @override
  _MyHomePageLoadedState createState() => _MyHomePageLoadedState();
}

class _MyHomePageLoadedState extends State<MyHomePageLoaded> {

  PageController pageController;
  int pageIndex = 0;

  var mydata;

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
    mydata = widget.incoming_data;
    currentUser = customUser(mydata);

    pageController = PageController(

    );
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,

      body: PageView(
        children: <Widget>[
          Profile(currentUser: currentUser,),
          Timeline(),
          Upload(currentUser: currentUser,),
          Chat(),
          Search(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),

      ),

      bottomNavigationBar: CupertinoTabBar(
        iconSize: 40,
        backgroundColor: Colors.white.withAlpha(0),
        currentIndex: pageIndex,
        onTap: navigationTap,
        activeColor: Colors.black,
        inactiveColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle)),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded))

        ],
      ),

    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/pages/search.dart';
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


final usersRef = FirebaseFirestore.instance.collection('users');

final FirebaseAuth myauth = FirebaseAuth.instance;

customUser currentUser;



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
          Profile(),
          Timeline(),
          Upload(),
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
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined)),
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle)),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined))

        ],
      ),

    );
  }
}
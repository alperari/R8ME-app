import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/classes/search_UserResult.dart';
import 'package:flutter/material.dart';

class showLikers_Dislikers extends StatefulWidget {
  String ownerID;
  String postID;
  String whichList;
  showLikers_Dislikers({this.ownerID, this.postID,this.whichList});

  @override
  _showLikers_DislikersState createState() => _showLikers_DislikersState();
}

class _showLikers_DislikersState extends State<showLikers_Dislikers> {

  Future<List<UserResult>> searchResultsFuture;

  Future<List<UserResult>> getPeople()async{

    List<UserResult> returnList = [];

    DocumentSnapshot postSnapshot;

    postSnapshot = await postsRef
      .doc(widget.ownerID)
      .collection("user_posts")
      .doc(widget.postID)
      .get();


    var myMap;
    myMap = widget.whichList == "Likers" ? postSnapshot.data()["liked_users"] : postSnapshot.data()["disliked_users"];
    for(var k in myMap.keys){
      if(myMap[k] == true){
        String id = k;
        DocumentSnapshot userDoc = await usersRef.doc(id).get();

        customUser user = customUser.fromDocument(userDoc);
        UserResult result = UserResult(user);
        returnList.add(result);
      }
    }

    return returnList;
  }


  @override
  void initState() {
    // TODO: implement initState
    searchResultsFuture = getPeople();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.whichList,
        ),
      ),
      body: FutureBuilder(
          future: searchResultsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return ListView(
                padding: EdgeInsets.all(5),
                children: snapshot.data,
              );

            }
            return Center(child: CircularProgressIndicator());


          }),
    );
  }
}

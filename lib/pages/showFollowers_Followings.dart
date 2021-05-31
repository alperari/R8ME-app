import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/classes/search_UserResult.dart';
import 'package:flutter/material.dart';

class showFollowers_Followings extends StatefulWidget {
  customUser currentUser;
  String whichList;
  showFollowers_Followings({this.currentUser, this.whichList});

  @override
  _showFollowers_FollowingsState createState() => _showFollowers_FollowingsState();
}

class _showFollowers_FollowingsState extends State<showFollowers_Followings> {

  Future<List<UserResult>> searchResultsFuture;

  Future<List<UserResult>> getPeople()async{

    List<UserResult> returnList = [];

    QuerySnapshot people;

    if(widget.whichList == "Followings"){
      people = await followings_table_Ref
        .doc(widget.currentUser.userID)
        .collection("myFollowings")
        .get();
    }
    else if(widget.whichList == "Followers"){
      people = await followers_table_Ref
          .doc(widget.currentUser.userID)
          .collection("myFollowers")
          .get();
    }

    for(var element in people.docs){
      String id = element.id;

      DocumentSnapshot userDoc = await usersRef.doc(id).get();

      customUser user = customUser.fromDocument(userDoc);
      UserResult result = UserResult(user);

      returnList.add(result);
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
        title: Text(widget.whichList),
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

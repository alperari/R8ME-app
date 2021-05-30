import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/activityFeed_item.dart';
import 'package:cs310/classes/customUser.dart';
import "package:flutter/material.dart";
import "package:cs310/initial_routes/homepage.dart";

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  final customUser currentUserOnPage = currentUser;

  Future<List<ActivitiFeed_Item>> ReturnActivityFeedItems() async{

    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUserOnPage.userID)
        .collection("feedItems")
        .orderBy("time",descending: true)
        .limit(20)
        .get();

    List<ActivitiFeed_Item> feedItems = [];
    snapshot.docs.forEach((mydoc) {
      feedItems.add(ActivitiFeed_Item.fromDocument(mydoc));
    });
    return feedItems;
  }

  Container buildNoContent(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset(
              'assets/no_notifications.jpg',
              fit: BoxFit.fill,
            ),


          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Latest Activity"),
        centerTitle: true,
          automaticallyImplyLeading: false
      ),
      body: Container(

        child: FutureBuilder(
          future: ReturnActivityFeedItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.data.isEmpty)
              return buildNoContent();

            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/classes/customUser.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cs310/initial_routes//homepage.dart';


class Settings extends StatefulWidget {

  Settings({this.currentUser});
  final customUser currentUser;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  Future<void>changePublic(bool val) async{
    DocumentSnapshot snapshot = await usersRef
        .doc(widget.currentUser.userID)
        .get();

    if(snapshot.exists){
      snapshot.reference.update({"public": val});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Settings",
        style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Change password"),
            buildAccountOptionRow(context, "Content settings"),
            buildAccountOptionRow(context, "Social"),
            buildAccountOptionRow(context, "Language"),
            buildAccountOptionRow(context, "Privacy and security"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("New for you", true),
            buildNotificationOptionRow("Account activity", true),
            buildNotificationOptionRow("Opportunity", false),
            SizedBox(
              height: 20,
            ),

            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Public"),
                      StreamBuilder(
                        stream: usersRef.doc(widget.currentUser.userID).snapshots(),
                        builder: (context,snapshot){
                          if(!snapshot.hasData){
                            return Container(child:Text("Loading..."));
                          }
                          else{
                            bool public = snapshot.data.data()["public"];
                            print(public);
                            return  CupertinoSwitch(
                                value: !public,
                                activeColor: Colors.deepPurple,
                                trackColor: Colors.lightGreen,
                                onChanged: (bool val){
                                  print(val);
                                  changePublic(!val);
                                }
                            );
                          }
                        }
                      ),
                      Text("Private"),
                    ],
                  ),

                  SizedBox(height:20),

                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),

                    child: Text("SIGN OUT",
                        style: TextStyle(
                            fontSize: 16, letterSpacing: 2.2, color: Colors.black)),

                    onPressed: () async {
                      final User user = await auth.currentUser;
                      if (user == null) {
//6
                        Scaffold.of(context).showSnackBar(const SnackBar(
                          content: Text('No one has signed in.'),
                        ));
                        return;
                      }
                      await auth.signOut();

                      Navigator.pushNamed(context, "/welcomescreen");

                    },
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
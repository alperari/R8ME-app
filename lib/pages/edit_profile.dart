import 'dart:io';

import 'package:cs310/UserHelper.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/profile.dart';
import 'package:cs310/pages/settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class EditProfile extends StatefulWidget {

  const EditProfile({Key key, this.currentUser, this.analytics, this.observer}): super(key: key);

  final customUser currentUser;

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  Map<String,dynamic> newData ;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool showPassword = false;

  @override
  void initState() {
    newData = {
      "userID": widget.currentUser.userID,
      "username": widget.currentUser.username,
      "email": widget.currentUser.email,
      "photoURL": widget.currentUser.photo_URL,
      "bio": widget.currentUser.bio,
      "followings": widget.currentUser.followings_count,
      "followers": widget.currentUser.followers_count,
      "rate": widget.currentUser.rate,
    };

    _bioController.text = widget.currentUser.bio;
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Settings()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  widget.currentUser.photo_URL,
                                ))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.greenAccent,
                            ),
                            child: GestureDetector(
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                              onTap: (){print("tap");},
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),




                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: "New Bio",
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15
                      )
                  ),

                  validator: (String value) {
                    if(value.length < 3)
                      return "Bio too short!";
                    else if(value.length > 75)
                      return "Bio too long!";
                    newData["bio"] = value;
                    return null;
                  },

                ),
                SizedBox(height: 10,),

                /*
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "New Password",
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  cursorColor: Colors.purple,
                  controller: _passwordController2,
                  obscureText: true,
                  decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "New Password Again",
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    else if(_passwordController.text != _passwordController2.text)
                    {
                      return "Passwords do not match!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: "New Bio",
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15
                      )
                  ),

                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    setState(() {
                      //_username = value;
                    });
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    RaisedButton(
                      onPressed: ()async{
                        if (_formKey.currentState.validate()) {
                          await updateUserById(Uid: widget.currentUser.userID, data:  newData);

                          SnackBar snackbar = SnackBar(
                            content: Text("Successfully Updated!"),);
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(documentId: widget.currentUser.userID, analytics: widget.analytics, observer: widget.observer,)));

                        }
                      },
                      color: Colors.greenAccent,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _bioController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
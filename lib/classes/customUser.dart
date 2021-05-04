import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class customUser
{
  String userID;
  String username;
  String email;
  String photo_URL;
  String bio;

  int followers_count;
  int followings_count;
  int rate;

  //POSTS below

  //Constructor
  customUser(Map<String,dynamic> mymap){
    this.userID = mymap==null ? "" : mymap["userID"];
    this.username = mymap==null ? "" : mymap["username"];
    this.email = mymap==null ? "" : mymap["email"];
    this.photo_URL = mymap==null ? "" : mymap["photo_URL"];
    this.bio = mymap==null ? "" : mymap["bio"];

    this.followers_count = mymap==null ? 0 : mymap["followers"];
    this.followings_count = mymap==null ? 0 : mymap["followings"];
    this.rate = mymap==null ? 0 : mymap["rate"];
  }

  customUser.def({
    this.userID,
    this.username,
    this.email,
    this.photo_URL,
    this.bio,
    this.followers_count,
    this.followings_count,
    this.rate
  });

  factory customUser.fromDocument(DocumentSnapshot doc) {
    return customUser.def(
      userID: doc.data()['userID'],
      username: doc.data()['username'],
      email: doc.data()['email'],
      photo_URL: doc.data()['photoURL'],
      bio: doc.data()['bio'],

      followers_count: doc.data()["followers"],
      followings_count: doc.data()["followings"],
      rate : doc.data()["rate"]
    );
  }
}
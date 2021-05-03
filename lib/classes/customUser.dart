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
}
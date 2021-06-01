import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cs310/initial_routes/homepage.dart";


void createUser(User myuser) {
  usersRef.doc(myuser.uid.toString()).set(
      {
        "userID": myuser.uid,
        "username": myuser.displayName,
        "email": myuser.email,
        "photoURL": myuser.photoURL,
        "bio": "This is my bio",
        "followings": 0,
        "followers": 0,
        "rate": 0,

        "public": true,
      }
  );
}

Future<Map<String,dynamic>> getuserById({String Uid}) async {
  final DocumentSnapshot mydoc = await usersRef.doc(Uid).get();
  Map <String,dynamic> mymap = mydoc.data();
  //print(mymap);
  return mymap;
}


void updateUserById({String Uid, Map<String,dynamic> data}) async {
  final mydoc = await usersRef.doc(Uid).get();
  if (mydoc.exists) {
    mydoc.reference.update(
        {
          "userID": data["userID"],
          "username": data["username"],
          "email": data["email"],
          "photoURL": data["photoURL"],
          "bio": data["bio"],
          "followings": data["followings"],
          "followers": data["followers"],
          "rate": data["rate"],

          "public" : data["public"],
        }
        );
  }
}


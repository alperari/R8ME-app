import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

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
      }
  );
}

Future<Map<String,dynamic>> getuserById({String Uid}) async {
  final DocumentSnapshot mydoc = await usersRef.doc(Uid).get();
  Map <String,dynamic> mymap = mydoc.data();
  //print(mymap);
  return mymap;
}


updateUserById({String Uid, Map<String,dynamic> data}) async {
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
        }
        );
  }
}
  // static saveUser(User user) async {
  //
  //   Map<String, dynamic> userData = {
  //     "userID" : user.uid,
  //     "username": user.displayName,
  //     "email": user.email,
  //     "photoURL": user.photoURL,
  //     "bio" : "Tell us about yourself!",
  //     "followings" : 0,
  //     "followers": 0,
  //     "rate": 0,
  //
  //   };
  //   final userRef = _db.collection("users").doc(user.uid);
  //   if ((await userRef.get()).exists) {
  //
  //     await userRef.update({
  //       "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
  //     });
  //   } else {
  //     await _db.collection("users").doc(user.uid).set(userData);
  //   }
  // }


import "package:cs310/initial_routes/homepage.dart";
import 'package:cs310/initial_routes/walkthrough.dart';
import "package:cs310/initial_routes/loginscreen.dart";
import 'package:cs310/initial_routes/registerscreen.dart';
import 'package:cs310/initial_routes/welcomescreen.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';

//2t

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseAuth myauth = FirebaseAuth.instance;

  var initial="";
  initial = myauth.currentUser!=null ? "/homepage" : "/walkthrough";


  runApp(MaterialApp(

    initialRoute: initial,
    routes: {
      "/walkthrough": (context) => Walkthrough(),
      "/welcomescreen": (context) => WelcomeScreen(),
      "/loginscreen": (context) => LoginScreen(),
      "/registerscreen": (context) => RegisterScreen(),
      "/homepage": (context) => HomePage(myauth.currentUser.uid),


    },
  ));
}









import "package:cs310/initial_routes/homepage.dart";
import 'package:cs310/initial_routes/walkthrough.dart';
import "package:cs310/initial_routes/loginscreen.dart";
import 'package:cs310/initial_routes/registerscreen.dart';
import 'package:cs310/initial_routes/welcomescreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';

//2t

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();



  runApp(AppBase());
}



class AppBase extends StatefulWidget {

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  _AppBaseState createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {

  FirebaseAuth myauth ;

  String initial;

  @override
  Widget build(BuildContext context) {

    setState(() {
      myauth = FirebaseAuth.instance;
      initial = myauth.currentUser!=null ? "homepage" : "walkthrough";
    });

    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[AppBase.observer],
      home: initial == "walkthrough" ? Walkthrough(analytics: AppBase.analytics, observer: AppBase.observer,) : HomePage(currentUserID: myauth.currentUser.uid),
      routes: {
        "/walkthrough": (context) => Walkthrough(analytics: AppBase.analytics, observer: AppBase.observer,),
        "/welcomescreen": (context) => WelcomeScreen(analytics: AppBase.analytics, observer: AppBase.observer,),
        "/loginscreen": (context) => LoginScreen(analytics: AppBase.analytics, observer: AppBase.observer,),
        "/registerscreen": (context) => RegisterScreen(),
        "/homepage": (context) => HomePage(currentUserID: myauth.currentUser.uid),


      },
    );
  }
}









import "package:cs310/initial_routes/homepage.dart";
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';



class WelcomeScreen extends StatefulWidget {

  const WelcomeScreen({Key key, this.analytics, this.observer}): super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final FirebaseAuth myauth = FirebaseAuth.instance;


  Future<void> Analytics_SetCurrentScreen() async{
    await widget.analytics.setCurrentScreen(screenName: "Welcome Screen", screenClassOverride: "welcomescreen");
  }

  @override
  void initState() {
    // TODO: implement initState
    Analytics_SetCurrentScreen();
  }

  @override
  Widget build(BuildContext context) {

    if(myauth.currentUser != null)
      {
        print("ALREADY SIGNED IN!");
        return HomePage(documentId: myauth.currentUser.uid, analytics: widget.analytics, observer: widget.observer);
      }
    else
      {
        print("NO LOGING");
        return Scaffold(

            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.deepPurple,
                    Colors.red,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  FlatButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/registerscreen");
                      },
                      color: Colors.red,
                      child: Text("REGISTER",
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  FlatButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/loginscreen");

                      },
                      color: Colors.green,
                      child: Text("LOGIN",
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
                ],
              ),



            )
        );
      }


  }
}

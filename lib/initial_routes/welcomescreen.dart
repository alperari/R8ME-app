import "package:cs310/initial_routes/homepage.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';



class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final FirebaseAuth myauth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    if(myauth.currentUser != null)
      {
        print("ALREADY SIGNED IN!");
        return MyHomePage();
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

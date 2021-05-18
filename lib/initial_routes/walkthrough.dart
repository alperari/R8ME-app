import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import "package:cs310/classes/styles.dart";
import "package:cs310/classes/colors.dart";





class Walkthrough extends StatefulWidget {

   Walkthrough({this.analytics, this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State {
  int current_page = 1;
  int page_count= 4;
  List<String> AppBarTitles= [
    "WELCOME",
    "SIGN-UP",
    "PROFILES",
    "CONTENT",
  ];

  List<String> PageTitles= [
    "R8M3",
    "Sign up easily",
    "Create your profile",
    "Enjoy rating people"
  ];

  List<String> ImageURLs= [
    "assets/applogo.jpeg",
    "assets/signup.jpeg",
    "assets/profiles.jpeg",
    "assets/content.jpeg",
  ];

  List<String> ImageCaptions= [
    "Just an app created by some CS 310 students",
    "Use app wherever you are",
    "Start your journey",
    "Let people know how they are eligible",
  ];



  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }

  void nextPage() {
    setState(() {
      if(current_page+1 != 5)
      {
        current_page++;
      }
      else
      {
        Navigator.pushNamed(context, "/welcomescreen");
      }
    }

    );
  }

  void prevPage() {
    setState(() {
      if(current_page-1 != 0)
      {
        current_page--;
      }
      else
      {
        current_page=current_page;
      }
    }
    );

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(AppBarTitles[current_page-1],
          style: TextStyle(
            color: myColors.App_bar_text_color,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
        backgroundColor: myColors.App_bar_color,
      ),
      backgroundColor: myColors.Widget_background,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                PageTitles[current_page-1],
                style: TextStyle(
                  fontSize: 34,
                  color: myColors.Page_title_color,
                  letterSpacing: -1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage(ImageURLs[current_page-1]),
              backgroundColor: myColors.Round_image_background,
              radius: 170,
            ),

            Container(
              alignment: Alignment.center,
              child: Text(
                ImageCaptions[current_page-1],
                style: TextStyle(
                  color: myColors.Image_caption_text_color,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1,

                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal:15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: prevPage,
                    child: Text(
                      "Prev",
                      style: TextStyle(
                        color: myColors.Button_text_color,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  Text(
                    "$current_page" + "/" + "$page_count",
                    style: TextStyle(
                      color: myColors.Button_text_color,
                      letterSpacing: -1,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: nextPage,
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: myColors.Button_text_color,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
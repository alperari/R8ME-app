import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';


class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Text("Timeline"),
    );
  }
}

/*
    final List<Color> colors = <Color>[Colors.red, Colors.blue];

MaterialApp(
      home: Scaffold(
        body: TikTokStyleFullPageScroller(
          contentSize: colors.length,
          swipeThreshold: 0.1,
          // ^ the fraction of the screen needed to scroll
          swipeVelocityThreshold: 100,
          // ^ the velocity threshold for smaller scrolls
          animationDuration: const Duration(milliseconds: 300),
          // ^ how long the animation will take
          builder: (BuildContext context, int index) {
            return Container(
              child: Image(
                image: AssetImage("assets/a$index.png"),
                fit: BoxFit.fill,
              ),
            );
          },
        ),
      ),
    );
    */
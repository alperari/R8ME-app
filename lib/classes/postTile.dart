import 'package:cs310/classes/post.dart';
import 'package:cs310/pages/individual_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PostTile extends StatelessWidget {
  Post post;
  PostTile({this.post});


  void showPost(context){
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return Individual_Post_Screen(userID: post.ownerID, postID: post.postID,);
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          showPost(context);
        },
      child: Container(

        margin: EdgeInsets.all(12),
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0,2), // changes position of shadow
                    ),
                  ],
                ),
                width: (MediaQuery.of(context).size.width/2) -30,
                height: ((MediaQuery.of(context).size.width/2) -30) / 3 * 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: cachedNetworkImage_custom(post.mediaURL),
                ),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: (MediaQuery.of(context).size.width/2) -30,
                    animation: true,
                    lineHeight: 24.0,
                    animationDuration: 750,
                    percent: post.rate,
                    center: Text((post.rate*100).toStringAsFixed(2) + "%", style: GoogleFonts.ptSans(color: Colors.white, fontSize: 20),),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}

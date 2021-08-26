import 'package:cs310/classes/post.dart';
import 'package:cs310/pages/individual_post_screen.dart';
import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.all(12),
        child: cachedNetworkImage_custom(post.mediaURL),
      ),
    );
  }
}

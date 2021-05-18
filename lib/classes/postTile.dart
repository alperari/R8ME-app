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
      child: cachedNetworkImage_custom(post.mediaURL),
    );
  }
}

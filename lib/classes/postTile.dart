import 'package:cs310/classes/post.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  Post post;
  PostTile({this.post});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){print("tapped on post tile");},
      child: cachedNetworkImage_custom(post.mediaURL),
    );
  }
}

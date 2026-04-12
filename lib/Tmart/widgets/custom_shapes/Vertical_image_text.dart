import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';

class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    this.name=" ",
    this.imageUrl=" ",
    this.onTap,
  });
  final String name;
  final String imageUrl;
  final Function() ? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right:9,left: 15),
        child: Column(
          children: [
            TRoundedContainer(
              radius: 60,
              height: 60,
              width: 60,
              backgroundColor: Colors.white,
              child:  Image.network(imageUrl, height: 100, fit: BoxFit.cover),
            ),
            SizedBox(height: 2,),
            SizedBox(
              width:60,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


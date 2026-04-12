import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TRatingAndShare extends StatelessWidget {
  const TRatingAndShare({
    super.key,
    required this.totalReviews,
    required this.totalRating,
  });
 final int totalReviews;
 final double totalRating;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.star_border_purple500,color: Colors.amber,size: 24,),
            SizedBox(width: 4,),
            Text.rich(
                TextSpan(
                    children: [
                      TextSpan(text:'${totalRating.toStringAsFixed(1)}',style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: '(${totalReviews.toString()} Reviews)'),
                    ]
                )
            ),
          ],
        ),
        IconButton(onPressed: (){
          final params = ShareParams(
            text:'Check out this product on flashchat!\n\nName: Amazing Product\nPrice: \$99\nLink: https://example.com/product/123',
            subject: 'Awesome product on flashchat',
          );
         SharePlus.instance.share(params);
        }, icon: Icon(Icons.share,size:24))
      ],
    );
  }
}


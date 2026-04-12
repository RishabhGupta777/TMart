import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rating_bar_indicator.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rating_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AverageRatingDisplay extends StatelessWidget {
  final String productId;
  const AverageRatingDisplay({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .collection('reviews')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final reviews = snapshot.data!.docs;
        if (reviews.isEmpty) return Text("No reviews yet");

        final average = reviews.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['rating'] as double;
        }).reduce((a, b) => a + b) / reviews.length;

        FirebaseFirestore.instance
            .collection('Products')
            .doc(productId)
             .update({
          'totalReviews':reviews.length,
          'totalRating':average
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(
          children: [
          Expanded(flex:3 ,child: Text('${average.toStringAsFixed(1) }',style:Theme.of(context).textTheme.displayLarge)),
          Expanded(flex:7, child: Column( children: [
                 TRatingProgressIndicator(text: '5',value: 0.9,),
                 TRatingProgressIndicator(text: '4',value: 0.7,),
                 TRatingProgressIndicator(text: '3',value: 0.5,),
                 TRatingProgressIndicator(text: '2',value: 0.4,),
                 TRatingProgressIndicator(text: '1',value: 0.1,),
             ],  ),
          )
        ],  ),
            TRatingBarIndicator(rating: average,),
            Text("${reviews.length} Reviews"),
          ],
        );
      },
    );
  }
}

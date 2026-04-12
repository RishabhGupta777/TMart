import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/average_rating_display.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/review_submission_form.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/reviews_list.dart';
import 'package:flutter/material.dart';

class ProductReviewsScreen extends StatelessWidget {
  final DocumentSnapshot document;
  const ProductReviewsScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final String productId = document.id;

    return Scaffold(
      appBar: AppBar(title: Text("Reviews & Ratings")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AverageRatingDisplay(productId: productId),
            SizedBox(height: 10),
            ReviewForm(productId: productId),
            SizedBox(height: 20),
            ReviewsList(productId: productId),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// class ProductReviewsScreen extends StatelessWidget {
//   const ProductReviewsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Reviews & Ratings"),
//         ),
//         body:SingleChildScrollView(
//           child:Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Rating and reviews are verified and are from peaople who use the same type of devise that you use."),
//                 SizedBox(height: 10,),
//
//                 ///overall Product reviews
//                 TOverallProductRating(),
//                 TRatingBarIndicator(rating:4.6,),
//                 Text('12,611',style: Theme.of(context).textTheme.bodySmall,),
//
//                 ///User Review List
//                 SizedBox(height:10),
//                 UserReviewCard(),
//                 UserReviewCard(),
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }
//
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rating_bar_indicator.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/text_read_more.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsList extends StatelessWidget {
  final String productId;
  const ReviewsList({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final reviews = snapshot.data!.docs;

        return Column(
          children: reviews.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final orderDate = (data['timestamp'] as Timestamp).toDate();
            final formattedDate = DateFormat('dd MMM yyyy').format(orderDate);
             return TRoundedContainer(
               showBorder: true,
               borderColor: Colors.black12,
               margin: 4,
               padding: 8,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       ClipOval(
                         child: Image.asset("assets/images/profile.png",
                             width: 50, height: 50, fit: BoxFit.cover ),
                       ),
                       SizedBox(width:8),
                       Text(data['submittedUser'] ?? 'UnKnown User',style: Theme.of(context).textTheme.titleLarge,)
                     ],
                   ),
                   SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           TRatingBarIndicator(rating:  data['rating']),
                           SizedBox(width: 5,),
                           Text(data['rating'].toString(),style: TextStyle(color:TColors.primary,fontSize: 18),),
                         ],
                       ),
                       Row(
                         children: [
                           Text(formattedDate,style:Theme.of(context).textTheme.bodyMedium),
                           SizedBox(width: 10,),
                         ],
                       ),
                     ],
                   ),
                   SizedBox(height: 10,),
                   TextReadMore(text: data['comment']),
                 ],
               ),
             );
          }).toList(),
        );
      },
    );
  }
}
